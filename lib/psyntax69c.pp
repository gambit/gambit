;;; psyntax.pp
;;; automatically generated from psyntax.ss
;;; Thu Sep 2 11:24:17 EST 2004
;;; see copyright notice in psyntax.ss

((lambda ()
   (letrec ((noexpand62 '"noexpand")
            (make-syntax-object63
             (lambda (expression2423 wrap2422)
               (vector 'syntax-object expression2423 wrap2422)))
            (syntax-object?64
             (lambda (x2421)
               (if (vector? x2421)
                   (if (= (vector-length x2421) '3)
                       (eq? (vector-ref x2421 '0) 'syntax-object)
                       '#f)
                   '#f)))
            (syntax-object-expression65
             (lambda (x2420) (vector-ref x2420 '1)))
            (syntax-object-wrap66
             (lambda (x2419) (vector-ref x2419 '2)))
            (set-syntax-object-expression!67
             (lambda (x2418 update2417)
               (vector-set! x2418 '1 update2417)))
            (set-syntax-object-wrap!68
             (lambda (x2416 update2415)
               (vector-set! x2416 '2 update2415)))
            (annotation?132 (lambda (x2414) '#f))
            (top-level-eval-hook133
             (lambda (x2413) (eval (list noexpand62 x2413))))
            (local-eval-hook134
             (lambda (x2412) (eval (list noexpand62 x2412))))
            (define-top-level-value-hook135
             (lambda (sym2411 val2410)
               (top-level-eval-hook133
                 (list 'define sym2411 (list 'quote val2410)))))
            (error-hook136
             (lambda (who2409 why2408 what2407)
               (error who2409 '"~a ~s" why2408 what2407)))
            (put-cte-hook141
             (lambda (symbol2406 val2405)
               ($sc-put-cte symbol2406 val2405 '*top*)))
            (get-global-definition-hook142
             (lambda (symbol2404) (getprop symbol2404 '*sc-expander*)))
            (put-global-definition-hook143
             (lambda (symbol2403 x2402)
               (if (not x2402)
                   (remprop symbol2403 '*sc-expander*)
                   (putprop symbol2403 '*sc-expander* x2402))))
            (read-only-binding?144 (lambda (symbol2401) '#f))
            (get-import-binding145
             (lambda (symbol2400 token2399)
               (getprop symbol2400 token2399)))
            (put-import-binding146
             (lambda (symbol2398 token2397 x2396)
               (if (not x2396)
                   (remprop symbol2398 token2397)
                   (putprop symbol2398 token2397 x2396))))
            (generate-id147
             ((lambda (digits2382)
                ((lambda (base2384 session-key2383)
                   (letrec ((make-digit2385
                             (lambda (x2395)
                               (string-ref digits2382 x2395)))
                            (fmt2386
                             (lambda (n2389)
                               ((letrec ((fmt2390
                                          (lambda (n2392 a2391)
                                            (if (< n2392 base2384)
                                                (list->string
                                                  (cons (make-digit2385
                                                          n2392)
                                                        a2391))
                                                ((lambda (r2394 rest2393)
                                                   (fmt2390
                                                     rest2393
                                                     (cons (make-digit2385
                                                             r2394)
                                                           a2391)))
                                                 (modulo n2392 base2384)
                                                 (quotient
                                                   n2392
                                                   base2384))))))
                                  fmt2390)
                                n2389
                                '()))))
                     ((lambda (n2387)
                        (lambda (name2388)
                          (begin (set! n2387 (+ n2387 '1))
                                 (string->symbol
                                   (string-append
                                     session-key2383
                                     (fmt2386 n2387))))))
                      '-1)))
                 (string-length digits2382)
                 '"_"))
              '"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!$%&*/:<=>?~_^.+-"))
            (built-lambda?221
             (lambda (x2381)
               (if (pair? x2381) (eq? (car x2381) 'lambda) '#f)))
            (build-sequence239
             (lambda (ae2378 exps2377)
               ((letrec ((loop2379
                          (lambda (exps2380)
                            (if (null? (cdr exps2380))
                                (car exps2380)
                                (if (equal? (car exps2380) '(void))
                                    (loop2379 (cdr exps2380))
                                    (cons 'begin exps2380))))))
                  loop2379)
                exps2377)))
            (build-letrec240
             (lambda (ae2376 vars2375 val-exps2374 body-exp2373)
               (if (null? vars2375)
                   body-exp2373
                   (list 'letrec
                         (map list vars2375 val-exps2374)
                         body-exp2373))))
            (build-body241
             (lambda (ae2372 vars2371 val-exps2370 body-exp2369)
               (build-letrec240
                 ae2372
                 vars2371
                 val-exps2370
                 body-exp2369)))
            (build-top-module242
             (lambda (ae2357
                      types2356
                      vars2355
                      val-exps2354
                      body-exp2353)
               (call-with-values
                 (lambda ()
                   ((letrec ((f2361
                              (lambda (types2363 vars2362)
                                (if (null? types2363)
                                    (values '() '() '())
                                    ((lambda (var2364)
                                       (call-with-values
                                         (lambda ()
                                           (f2361
                                             (cdr types2363)
                                             (cdr vars2362)))
                                         (lambda (vars2367
                                                  defns2366
                                                  sets2365)
                                           (if (eq? (car types2363)
                                                    'global)
                                               ((lambda (x2368)
                                                  (values
                                                    (cons x2368 vars2367)
                                                    (cons (list 'define
                                                                var2364
                                                                (chi-void503))
                                                          defns2366)
                                                    (cons (list 'set!
                                                                var2364
                                                                x2368)
                                                          sets2365)))
                                                (gensym))
                                               (values
                                                 (cons var2364 vars2367)
                                                 defns2366
                                                 sets2365)))))
                                     (car vars2362))))))
                      f2361)
                    types2356
                    vars2355))
                 (lambda (vars2360 defns2359 sets2358)
                   (if (null? defns2359)
                       (build-letrec240
                         ae2357
                         vars2360
                         val-exps2354
                         body-exp2353)
                       (build-sequence239
                         '#f
                         (append
                           defns2359
                           (list (build-letrec240
                                   ae2357
                                   vars2360
                                   val-exps2354
                                   (build-sequence239
                                     '#f
                                     (append
                                       sets2358
                                       (list body-exp2353))))))))))))
            (sanitize-binding275
             (lambda (b2349)
               (if (procedure? b2349)
                   (cons 'macro b2349)
                   (if (binding?289 b2349)
                       (if ((lambda (t2350)
                              (if (memv t2350
                                        '(core macro macro! deferred))
                                  (procedure? (binding-value286 b2349))
                                  (if (memv t2350 '($module))
                                      (interface?440
                                        (binding-value286 b2349))
                                      (if (memv t2350 '(lexical))
                                          '#f
                                          (if (memv t2350
                                                    '(global
                                                       meta-variable))
                                              (symbol?
                                                (binding-value286 b2349))
                                              (if (memv t2350 '(syntax))
                                                  ((lambda (x2351)
                                                     (if (pair? x2351)
                                                         (if '#f
                                                             ((lambda (n2352)
                                                                (if (integer?
                                                                      n2352)
                                                                    (if (exact?
                                                                          n2352)
                                                                        (>= n2352
                                                                            '0)
                                                                        '#f)
                                                                    '#f))
                                                              (cdr x2351))
                                                             '#f)
                                                         '#f))
                                                   (binding-value286
                                                     b2349))
                                                  (if (memv t2350
                                                            '(begin define
                                                                    define-syntax
                                                                    set!
                                                                    $module-key
                                                                    $import
                                                                    eval-when
                                                                    meta))
                                                      (null?
                                                        (binding-value286
                                                          b2349))
                                                      (if (memv t2350
                                                                '(local-syntax))
                                                          (boolean?
                                                            (binding-value286
                                                              b2349))
                                                          (if (memv t2350
                                                                    '(displaced-lexical))
                                                              (eq? (binding-value286
                                                                     b2349)
                                                                   '#f)
                                                              '#t)))))))))
                            (binding-type285 b2349))
                           b2349
                           '#f)
                       '#f))))
            (binding-type285 car)
            (binding-value286 cdr)
            (set-binding-type!287 set-car!)
            (set-binding-value!288 set-cdr!)
            (binding?289
             (lambda (x2348)
               (if (pair? x2348) (symbol? (car x2348)) '#f)))
            (extend-env299
             (lambda (label2347 binding2346 r2345)
               (cons (cons label2347 binding2346) r2345)))
            (extend-env*300
             (lambda (labels2344 bindings2343 r2342)
               (if (null? labels2344)
                   r2342
                   (extend-env*300
                     (cdr labels2344)
                     (cdr bindings2343)
                     (extend-env299
                       (car labels2344)
                       (car bindings2343)
                       r2342)))))
            (extend-var-env*301
             (lambda (labels2341 vars2340 r2339)
               (if (null? labels2341)
                   r2339
                   (extend-var-env*301
                     (cdr labels2341)
                     (cdr vars2340)
                     (extend-env299
                       (car labels2341)
                       (cons 'lexical (car vars2340))
                       r2339)))))
            (displaced-lexical?302
             (lambda (id2336 r2335)
               ((lambda (n2337)
                  (if n2337
                      ((lambda (b2338)
                         (eq? (binding-type285 b2338) 'displaced-lexical))
                       (lookup305 n2337 r2335))
                      '#f))
                (id-var-name423 id2336 '(())))))
            (displaced-lexical-error303
             (lambda (id2334)
               (syntax-error
                 id2334
                 (if (id-var-name423 id2334 '(()))
                     '"identifier out of context"
                     '"identifier not visible"))))
            (lookup*304
             (lambda (x2331 r2330)
               ((lambda (t2332)
                  (if t2332
                      (cdr t2332)
                      (if (symbol? x2331)
                          ((lambda (t2333)
                             (if t2333 t2333 (cons 'global x2331)))
                           (get-global-definition-hook142 x2331))
                          '(displaced-lexical . #f))))
                (assq x2331 r2330))))
            (lookup305
             (lambda (x2325 r2324)
               (letrec ((whack-binding!2326
                         (lambda (b2329 *b2328)
                           (begin (set-binding-type!287
                                    b2329
                                    (binding-type285 *b2328))
                                  (set-binding-value!288
                                    b2329
                                    (binding-value286 *b2328))))))
                 ((lambda (b2327)
                    (begin (if (eq? (binding-type285 b2327) 'deferred)
                               (whack-binding!2326
                                 b2327
                                 (make-transformer-binding306
                                   ((binding-value286 b2327))))
                               (void))
                           b2327))
                  (lookup*304 x2325 r2324)))))
            (make-transformer-binding306
             (lambda (b2322)
               ((lambda (t2323)
                  (if t2323
                      t2323
                      (syntax-error b2322 '"invalid transformer")))
                (sanitize-binding275 b2322))))
            (defer-or-eval-transformer307
             (lambda (eval2321 x2320)
               (if (built-lambda?221 x2320)
                   (cons 'deferred (lambda () (eval2321 x2320)))
                   (make-transformer-binding306 (eval2321 x2320)))))
            (global-extend308
             (lambda (type2319 sym2318 val2317)
               (put-cte-hook141 sym2318 (cons type2319 val2317))))
            (nonsymbol-id?309
             (lambda (x2315)
               (if (syntax-object?64 x2315)
                   (symbol?
                     ((lambda (e2316)
                        (if (annotation?132 e2316)
                            (annotation-expression e2316)
                            e2316))
                      (syntax-object-expression65 x2315)))
                   '#f)))
            (id?310
             (lambda (x2313)
               (if (symbol? x2313)
                   '#t
                   (if (syntax-object?64 x2313)
                       (symbol?
                         ((lambda (e2314)
                            (if (annotation?132 e2314)
                                (annotation-expression e2314)
                                e2314))
                          (syntax-object-expression65 x2313)))
                       (if (annotation?132 x2313)
                           (symbol? (annotation-expression x2313))
                           '#f)))))
            (id-sym-name&marks316
             (lambda (x2310 w2309)
               (if (syntax-object?64 x2310)
                   (values
                     ((lambda (e2311)
                        (if (annotation?132 e2311)
                            (annotation-expression e2311)
                            e2311))
                      (syntax-object-expression65 x2310))
                     (join-marks413
                       (wrap-marks318 w2309)
                       (wrap-marks318 (syntax-object-wrap66 x2310))))
                   (values
                     ((lambda (e2312)
                        (if (annotation?132 e2312)
                            (annotation-expression e2312)
                            e2312))
                      x2310)
                     (wrap-marks318 w2309)))))
            (make-wrap317 cons)
            (wrap-marks318 car)
            (wrap-subst319 cdr)
            (make-indirect-label348
             (lambda (label2308) (vector 'indirect-label label2308)))
            (indirect-label?349
             (lambda (x2307)
               (if (vector? x2307)
                   (if (= (vector-length x2307) '2)
                       (eq? (vector-ref x2307 '0) 'indirect-label)
                       '#f)
                   '#f)))
            (indirect-label-label350
             (lambda (x2306) (vector-ref x2306 '1)))
            (set-indirect-label-label!351
             (lambda (x2305 update2304)
               (vector-set! x2305 '1 update2304)))
            (gen-indirect-label352
             (lambda () (make-indirect-label348 (gen-label355))))
            (get-indirect-label353
             (lambda (x2303) (indirect-label-label350 x2303)))
            (set-indirect-label!354
             (lambda (x2302 v2301)
               (set-indirect-label-label!351 x2302 v2301)))
            (gen-label355 (lambda () (string '#\i)))
            (label?356
             (lambda (x2298)
               ((lambda (t2299)
                  (if t2299
                      t2299
                      ((lambda (t2300)
                         (if t2300 t2300 (indirect-label?349 x2298)))
                       (symbol? x2298))))
                (string? x2298))))
            (gen-labels357
             (lambda (ls2297)
               (if (null? ls2297)
                   '()
                   (cons (gen-label355) (gen-labels357 (cdr ls2297))))))
            (make-ribcage358
             (lambda (symnames2296 marks2295 labels2294)
               (vector 'ribcage symnames2296 marks2295 labels2294)))
            (ribcage?359
             (lambda (x2293)
               (if (vector? x2293)
                   (if (= (vector-length x2293) '4)
                       (eq? (vector-ref x2293 '0) 'ribcage)
                       '#f)
                   '#f)))
            (ribcage-symnames360 (lambda (x2292) (vector-ref x2292 '1)))
            (ribcage-marks361 (lambda (x2291) (vector-ref x2291 '2)))
            (ribcage-labels362 (lambda (x2290) (vector-ref x2290 '3)))
            (set-ribcage-symnames!363
             (lambda (x2289 update2288)
               (vector-set! x2289 '1 update2288)))
            (set-ribcage-marks!364
             (lambda (x2287 update2286)
               (vector-set! x2287 '2 update2286)))
            (set-ribcage-labels!365
             (lambda (x2285 update2284)
               (vector-set! x2285 '3 update2284)))
            (make-top-ribcage366
             (lambda (key2283 mutable?2282)
               (vector 'top-ribcage key2283 mutable?2282)))
            (top-ribcage?367
             (lambda (x2281)
               (if (vector? x2281)
                   (if (= (vector-length x2281) '3)
                       (eq? (vector-ref x2281 '0) 'top-ribcage)
                       '#f)
                   '#f)))
            (top-ribcage-key368 (lambda (x2280) (vector-ref x2280 '1)))
            (top-ribcage-mutable?369
             (lambda (x2279) (vector-ref x2279 '2)))
            (set-top-ribcage-key!370
             (lambda (x2278 update2277)
               (vector-set! x2278 '1 update2277)))
            (set-top-ribcage-mutable?!371
             (lambda (x2276 update2275)
               (vector-set! x2276 '2 update2275)))
            (make-import-token372
             (lambda (key2274) (vector 'import-token key2274)))
            (import-token?373
             (lambda (x2273)
               (if (vector? x2273)
                   (if (= (vector-length x2273) '2)
                       (eq? (vector-ref x2273 '0) 'import-token)
                       '#f)
                   '#f)))
            (import-token-key374 (lambda (x2272) (vector-ref x2272 '1)))
            (set-import-token-key!375
             (lambda (x2271 update2270)
               (vector-set! x2271 '1 update2270)))
            (make-env376
             (lambda (top-ribcage2269 wrap2268)
               (vector 'env top-ribcage2269 wrap2268)))
            (env?377
             (lambda (x2267)
               (if (vector? x2267)
                   (if (= (vector-length x2267) '3)
                       (eq? (vector-ref x2267 '0) 'env)
                       '#f)
                   '#f)))
            (env-top-ribcage378 (lambda (x2266) (vector-ref x2266 '1)))
            (env-wrap379 (lambda (x2265) (vector-ref x2265 '2)))
            (set-env-top-ribcage!380
             (lambda (x2264 update2263)
               (vector-set! x2264 '1 update2263)))
            (set-env-wrap!381
             (lambda (x2262 update2261)
               (vector-set! x2262 '2 update2261)))
            (anti-mark391
             (lambda (w2260)
               (make-wrap317
                 (cons '#f (wrap-marks318 w2260))
                 (cons 'shift (wrap-subst319 w2260)))))
            (barrier-marker396 '#f)
            (extend-ribcage!401
             (lambda (ribcage2258 id2257 label2256)
               (begin (set-ribcage-symnames!363
                        ribcage2258
                        (cons ((lambda (e2259)
                                 (if (annotation?132 e2259)
                                     (annotation-expression e2259)
                                     e2259))
                               (syntax-object-expression65 id2257))
                              (ribcage-symnames360 ribcage2258)))
                      (set-ribcage-marks!364
                        ribcage2258
                        (cons (wrap-marks318 (syntax-object-wrap66 id2257))
                              (ribcage-marks361 ribcage2258)))
                      (set-ribcage-labels!365
                        ribcage2258
                        (cons label2256
                              (ribcage-labels362 ribcage2258))))))
            (extend-ribcage-barrier!402
             (lambda (ribcage2255 killer-id2254)
               (extend-ribcage-barrier-help!403
                 ribcage2255
                 (syntax-object-wrap66 killer-id2254))))
            (extend-ribcage-barrier-help!403
             (lambda (ribcage2253 wrap2252)
               (begin (set-ribcage-symnames!363
                        ribcage2253
                        (cons barrier-marker396
                              (ribcage-symnames360 ribcage2253)))
                      (set-ribcage-marks!364
                        ribcage2253
                        (cons (wrap-marks318 wrap2252)
                              (ribcage-marks361 ribcage2253))))))
            (extend-ribcage-subst!404
             (lambda (ribcage2251 token2250)
               (set-ribcage-symnames!363
                 ribcage2251
                 (cons (make-import-token372 token2250)
                       (ribcage-symnames360 ribcage2251)))))
            (lookup-import-binding-name405
             (lambda (sym2245 token2244 marks2243)
               ((lambda (new2246)
                  (if new2246
                      ((letrec ((f2247
                                 (lambda (new2248)
                                   (if (pair? new2248)
                                       ((lambda (t2249)
                                          (if t2249
                                              t2249
                                              (f2247 (cdr new2248))))
                                        (f2247 (car new2248)))
                                       (if (symbol? new2248)
                                           (if (same-marks?415
                                                 marks2243
                                                 (wrap-marks318 '((top))))
                                               new2248
                                               '#f)
                                           (if (same-marks?415
                                                 marks2243
                                                 (wrap-marks318
                                                   (syntax-object-wrap66
                                                     new2248)))
                                               new2248
                                               '#f))))))
                         f2247)
                       new2246)
                      '#f))
                (get-import-binding145 sym2245 token2244))))
            (store-import-binding406
             (lambda (id2229 token2228)
               (letrec ((id-marks2230
                         (lambda (id2242)
                           (if (symbol? id2242)
                               (wrap-marks318 '((top)))
                               (wrap-marks318
                                 (syntax-object-wrap66 id2242)))))
                        (cons-id2231
                         (lambda (id2241 x2240)
                           (if (not x2240) id2241 (cons id2241 x2240))))
                        (weed2232
                         (lambda (marks2239 x2238)
                           (if (pair? x2238)
                               (if (same-marks?415
                                     (id-marks2230 (car x2238))
                                     marks2239)
                                   (weed2232 marks2239 (cdr x2238))
                                   (cons-id2231
                                     (car x2238)
                                     (weed2232 marks2239 (cdr x2238))))
                               (if x2238
                                   (if (not (same-marks?415
                                              (id-marks2230 x2238)
                                              marks2239))
                                       x2238
                                       '#f)
                                   '#f)))))
                 ((lambda (sym2233)
                    (if (not (eq? id2229 sym2233))
                        ((lambda (marks2234)
                           ((lambda (x2235)
                              (put-import-binding146
                                sym2233
                                token2228
                                (cons-id2231
                                  (if (same-marks?415
                                        marks2234
                                        (wrap-marks318 '((top))))
                                      (resolved-id-var-name410 id2229)
                                      id2229)
                                  x2235)))
                            (weed2232
                              marks2234
                              (get-import-binding145 sym2233 token2228))))
                         (id-marks2230 id2229))
                        (void)))
                  ((lambda (x2236)
                     ((lambda (e2237)
                        (if (annotation?132 e2237)
                            (annotation-expression e2237)
                            e2237))
                      (if (syntax-object?64 x2236)
                          (syntax-object-expression65 x2236)
                          x2236)))
                   id2229)))))
            (make-binding-wrap407
             (lambda (ids2218 labels2217 w2216)
               (if (null? ids2218)
                   w2216
                   (make-wrap317
                     (wrap-marks318 w2216)
                     (cons ((lambda (labelvec2219)
                              ((lambda (n2220)
                                 ((lambda (symnamevec2222 marksvec2221)
                                    (begin ((letrec ((f2223
                                                      (lambda (ids2225
                                                               i2224)
                                                        (if (not (null?
                                                                   ids2225))
                                                            (call-with-values
                                                              (lambda ()
                                                                (id-sym-name&marks316
                                                                  (car ids2225)
                                                                  w2216))
                                                              (lambda (symname2227
                                                                       marks2226)
                                                                (begin (vector-set!
                                                                         symnamevec2222
                                                                         i2224
                                                                         symname2227)
                                                                       (vector-set!
                                                                         marksvec2221
                                                                         i2224
                                                                         marks2226)
                                                                       (f2223
                                                                         (cdr ids2225)
                                                                         (+ i2224
                                                                            '1)))))
                                                            (void)))))
                                              f2223)
                                            ids2218
                                            '0)
                                           (make-ribcage358
                                             symnamevec2222
                                             marksvec2221
                                             labelvec2219)))
                                  (make-vector n2220)
                                  (make-vector n2220)))
                               (vector-length labelvec2219)))
                            (list->vector labels2217))
                           (wrap-subst319 w2216))))))
            (make-resolved-id408
             (lambda (fromsym2215 marks2214 tosym2213)
               (make-syntax-object63
                 fromsym2215
                 (make-wrap317
                   marks2214
                   (list (make-ribcage358
                           (vector fromsym2215)
                           (vector marks2214)
                           (vector tosym2213)))))))
            (id->resolved-id409
             (lambda (id2208)
               (call-with-values
                 (lambda () (id-var-name&marks421 id2208 '(())))
                 (lambda (tosym2210 marks2209)
                   (begin (if (not tosym2210)
                              (syntax-error
                                id2208
                                '"identifier not visible for export")
                              (void))
                          (make-resolved-id408
                            ((lambda (x2211)
                               ((lambda (e2212)
                                  (if (annotation?132 e2212)
                                      (annotation-expression e2212)
                                      e2212))
                                (if (syntax-object?64 x2211)
                                    (syntax-object-expression65 x2211)
                                    x2211)))
                             id2208)
                            marks2209
                            tosym2210))))))
            (resolved-id-var-name410
             (lambda (id2207)
               (vector-ref
                 (ribcage-labels362
                   (car (wrap-subst319 (syntax-object-wrap66 id2207))))
                 '0)))
            (smart-append411
             (lambda (m12206 m22205)
               (if (null? m22205) m12206 (append m12206 m22205))))
            (join-wraps412
             (lambda (w12202 w22201)
               ((lambda (m12204 s12203)
                  (if (null? m12204)
                      (if (null? s12203)
                          w22201
                          (make-wrap317
                            (wrap-marks318 w22201)
                            (join-subst414 s12203 (wrap-subst319 w22201))))
                      (make-wrap317
                        (join-marks413 m12204 (wrap-marks318 w22201))
                        (join-subst414 s12203 (wrap-subst319 w22201)))))
                (wrap-marks318 w12202)
                (wrap-subst319 w12202))))
            (join-marks413
             (lambda (m12200 m22199) (smart-append411 m12200 m22199)))
            (join-subst414
             (lambda (s12198 s22197) (smart-append411 s12198 s22197)))
            (same-marks?415
             (lambda (x2195 y2194)
               ((lambda (t2196)
                  (if t2196
                      t2196
                      (if (not (null? x2195))
                          (if (not (null? y2194))
                              (if (eq? (car x2195) (car y2194))
                                  (same-marks?415 (cdr x2195) (cdr y2194))
                                  '#f)
                              '#f)
                          '#f)))
                (eq? x2195 y2194))))
            (leave-implicit?416
             (lambda (token2193) (eq? token2193 '*top*)))
            (new-binding417
             (lambda (sym2190 marks2189 token2188)
               ((lambda (loc2191)
                  ((lambda (id2192)
                     (begin (store-import-binding406 id2192 token2188)
                            (values loc2191 id2192)))
                   (make-resolved-id408 sym2190 marks2189 loc2191)))
                (if (if (leave-implicit?416 token2188)
                        (same-marks?415 marks2189 (wrap-marks318 '((top))))
                        '#f)
                    sym2190
                    (generate-id147 sym2190)))))
            (top-id-bound-var-name418
             (lambda (sym2184 marks2183 top-ribcage2182)
               ((lambda (token2185)
                  ((lambda (t2186)
                     (if t2186
                         ((lambda (id2187)
                            (if (symbol? id2187)
                                (if (read-only-binding?144 id2187)
                                    (new-binding417
                                      sym2184
                                      marks2183
                                      token2185)
                                    (values
                                      id2187
                                      (make-resolved-id408
                                        sym2184
                                        marks2183
                                        id2187)))
                                (values
                                  (resolved-id-var-name410 id2187)
                                  id2187)))
                          t2186)
                         (new-binding417 sym2184 marks2183 token2185)))
                   (lookup-import-binding-name405
                     sym2184
                     token2185
                     marks2183)))
                (top-ribcage-key368 top-ribcage2182))))
            (top-id-free-var-name419
             (lambda (sym2176 marks2175 top-ribcage2174)
               ((lambda (token2177)
                  ((lambda (t2178)
                     (if t2178
                         ((lambda (id2179)
                            (if (symbol? id2179)
                                id2179
                                (resolved-id-var-name410 id2179)))
                          t2178)
                         (if (if (top-ribcage-mutable?369 top-ribcage2174)
                                 (same-marks?415
                                   marks2175
                                   (wrap-marks318 '((top))))
                                 '#f)
                             (call-with-values
                               (lambda ()
                                 (new-binding417
                                   sym2176
                                   (wrap-marks318 '((top)))
                                   token2177))
                               (lambda (sym2181 id2180) sym2181))
                             '#f)))
                   (lookup-import-binding-name405
                     sym2176
                     token2177
                     marks2175)))
                (top-ribcage-key368 top-ribcage2174))))
            (id-var-name-loc&marks420
             (lambda (id2139 w2138)
               (letrec ((search2140
                         (lambda (sym2169 subst2168 marks2167)
                           (if (null? subst2168)
                               (values '#f marks2167)
                               ((lambda (fst2170)
                                  (if (eq? fst2170 'shift)
                                      (search2140
                                        sym2169
                                        (cdr subst2168)
                                        (cdr marks2167))
                                      (if (ribcage?359 fst2170)
                                          ((lambda (symnames2171)
                                             (if (vector? symnames2171)
                                                 (search-vector-rib2142
                                                   sym2169
                                                   subst2168
                                                   marks2167
                                                   symnames2171
                                                   fst2170)
                                                 (search-list-rib2141
                                                   sym2169
                                                   subst2168
                                                   marks2167
                                                   symnames2171
                                                   fst2170)))
                                           (ribcage-symnames360 fst2170))
                                          (if (top-ribcage?367 fst2170)
                                              ((lambda (t2172)
                                                 (if t2172
                                                     ((lambda (var-name2173)
                                                        (values
                                                          var-name2173
                                                          marks2167))
                                                      t2172)
                                                     (search2140
                                                       sym2169
                                                       (cdr subst2168)
                                                       marks2167)))
                                               (top-id-free-var-name419
                                                 sym2169
                                                 marks2167
                                                 fst2170))
                                              (error 'sc-expand
                                                '"internal error in id-var-name-loc&marks: improper subst ~s"
                                                subst2168)))))
                                (car subst2168)))))
                        (search-list-rib2141
                         (lambda (sym2161
                                  subst2160
                                  marks2159
                                  symnames2158
                                  ribcage2157)
                           ((letrec ((f2162
                                      (lambda (symnames2164 i2163)
                                        (if (null? symnames2164)
                                            (search2140
                                              sym2161
                                              (cdr subst2160)
                                              marks2159)
                                            (if (if (eq? (car symnames2164)
                                                         sym2161)
                                                    (same-marks?415
                                                      marks2159
                                                      (list-ref
                                                        (ribcage-marks361
                                                          ribcage2157)
                                                        i2163))
                                                    '#f)
                                                (values
                                                  (list-ref
                                                    (ribcage-labels362
                                                      ribcage2157)
                                                    i2163)
                                                  marks2159)
                                                (if (import-token?373
                                                      (car symnames2164))
                                                    ((lambda (t2165)
                                                       (if t2165
                                                           ((lambda (id2166)
                                                              (values
                                                                (if (symbol?
                                                                      id2166)
                                                                    id2166
                                                                    (resolved-id-var-name410
                                                                      id2166))
                                                                marks2159))
                                                            t2165)
                                                           (f2162
                                                             (cdr symnames2164)
                                                             i2163)))
                                                     (lookup-import-binding-name405
                                                       sym2161
                                                       (import-token-key374
                                                         (car symnames2164))
                                                       marks2159))
                                                    (if (if (eq? (car symnames2164)
                                                                 barrier-marker396)
                                                            (same-marks?415
                                                              marks2159
                                                              (list-ref
                                                                (ribcage-marks361
                                                                  ribcage2157)
                                                                i2163))
                                                            '#f)
                                                        (values
                                                          '#f
                                                          marks2159)
                                                        (f2162
                                                          (cdr symnames2164)
                                                          (+ i2163
                                                             '1)))))))))
                              f2162)
                            symnames2158
                            '0)))
                        (search-vector-rib2142
                         (lambda (sym2153
                                  subst2152
                                  marks2151
                                  symnames2150
                                  ribcage2149)
                           ((lambda (n2154)
                              ((letrec ((f2155
                                         (lambda (i2156)
                                           (if (= i2156 n2154)
                                               (search2140
                                                 sym2153
                                                 (cdr subst2152)
                                                 marks2151)
                                               (if (if (eq? (vector-ref
                                                              symnames2150
                                                              i2156)
                                                            sym2153)
                                                       (same-marks?415
                                                         marks2151
                                                         (vector-ref
                                                           (ribcage-marks361
                                                             ribcage2149)
                                                           i2156))
                                                       '#f)
                                                   (values
                                                     (vector-ref
                                                       (ribcage-labels362
                                                         ribcage2149)
                                                       i2156)
                                                     marks2151)
                                                   (f2155 (+ i2156 '1)))))))
                                 f2155)
                               '0))
                            (vector-length symnames2150)))))
                 (if (symbol? id2139)
                     (search2140
                       id2139
                       (wrap-subst319 w2138)
                       (wrap-marks318 w2138))
                     (if (syntax-object?64 id2139)
                         ((lambda (sym2144 w12143)
                            (call-with-values
                              (lambda ()
                                (search2140
                                  sym2144
                                  (wrap-subst319 w2138)
                                  (join-marks413
                                    (wrap-marks318 w2138)
                                    (wrap-marks318 w12143))))
                              (lambda (name2146 marks2145)
                                (if name2146
                                    (values name2146 marks2145)
                                    (search2140
                                      sym2144
                                      (wrap-subst319 w12143)
                                      marks2145)))))
                          ((lambda (e2147)
                             (if (annotation?132 e2147)
                                 (annotation-expression e2147)
                                 e2147))
                           (syntax-object-expression65 id2139))
                          (syntax-object-wrap66 id2139))
                         (if (annotation?132 id2139)
                             (search2140
                               ((lambda (e2148)
                                  (if (annotation?132 e2148)
                                      (annotation-expression e2148)
                                      e2148))
                                id2139)
                               (wrap-subst319 w2138)
                               (wrap-marks318 w2138))
                             (error-hook136
                               'id-var-name
                               '"invalid id"
                               id2139)))))))
            (id-var-name&marks421
             (lambda (id2135 w2134)
               (call-with-values
                 (lambda () (id-var-name-loc&marks420 id2135 w2134))
                 (lambda (label2137 marks2136)
                   (values
                     (if (indirect-label?349 label2137)
                         (get-indirect-label353 label2137)
                         label2137)
                     marks2136)))))
            (id-var-name-loc422
             (lambda (id2131 w2130)
               (call-with-values
                 (lambda () (id-var-name-loc&marks420 id2131 w2130))
                 (lambda (label2133 marks2132) label2133))))
            (id-var-name423
             (lambda (id2127 w2126)
               (call-with-values
                 (lambda () (id-var-name-loc&marks420 id2127 w2126))
                 (lambda (label2129 marks2128)
                   (if (indirect-label?349 label2129)
                       (get-indirect-label353 label2129)
                       label2129)))))
            (free-id=?424
             (lambda (i2121 j2120)
               (if (eq? ((lambda (x2124)
                           ((lambda (e2125)
                              (if (annotation?132 e2125)
                                  (annotation-expression e2125)
                                  e2125))
                            (if (syntax-object?64 x2124)
                                (syntax-object-expression65 x2124)
                                x2124)))
                         i2121)
                        ((lambda (x2122)
                           ((lambda (e2123)
                              (if (annotation?132 e2123)
                                  (annotation-expression e2123)
                                  e2123))
                            (if (syntax-object?64 x2122)
                                (syntax-object-expression65 x2122)
                                x2122)))
                         j2120))
                   (eq? (id-var-name423 i2121 '(()))
                        (id-var-name423 j2120 '(())))
                   '#f)))
            (literal-id=?425
             (lambda (id2110 literal2109)
               (if (eq? ((lambda (x2113)
                           ((lambda (e2114)
                              (if (annotation?132 e2114)
                                  (annotation-expression e2114)
                                  e2114))
                            (if (syntax-object?64 x2113)
                                (syntax-object-expression65 x2113)
                                x2113)))
                         id2110)
                        ((lambda (x2111)
                           ((lambda (e2112)
                              (if (annotation?132 e2112)
                                  (annotation-expression e2112)
                                  e2112))
                            (if (syntax-object?64 x2111)
                                (syntax-object-expression65 x2111)
                                x2111)))
                         literal2109))
                   ((lambda (n-id2116 n-literal2115)
                      ((lambda (t2117)
                         (if t2117
                             t2117
                             (if ((lambda (t2118)
                                    (if t2118 t2118 (symbol? n-id2116)))
                                  (not n-id2116))
                                 ((lambda (t2119)
                                    (if t2119
                                        t2119
                                        (symbol? n-literal2115)))
                                  (not n-literal2115))
                                 '#f)))
                       (eq? n-id2116 n-literal2115)))
                    (id-var-name423 id2110 '(()))
                    (id-var-name423 literal2109 '(())))
                   '#f)))
            (bound-id=?426
             (lambda (i2104 j2103)
               (if (if (syntax-object?64 i2104)
                       (syntax-object?64 j2103)
                       '#f)
                   (if (eq? ((lambda (e2106)
                               (if (annotation?132 e2106)
                                   (annotation-expression e2106)
                                   e2106))
                             (syntax-object-expression65 i2104))
                            ((lambda (e2105)
                               (if (annotation?132 e2105)
                                   (annotation-expression e2105)
                                   e2105))
                             (syntax-object-expression65 j2103)))
                       (same-marks?415
                         (wrap-marks318 (syntax-object-wrap66 i2104))
                         (wrap-marks318 (syntax-object-wrap66 j2103)))
                       '#f)
                   (eq? ((lambda (e2108)
                           (if (annotation?132 e2108)
                               (annotation-expression e2108)
                               e2108))
                         i2104)
                        ((lambda (e2107)
                           (if (annotation?132 e2107)
                               (annotation-expression e2107)
                               e2107))
                         j2103)))))
            (valid-bound-ids?427
             (lambda (ids2099)
               (if ((letrec ((all-ids?2100
                              (lambda (ids2101)
                                ((lambda (t2102)
                                   (if t2102
                                       t2102
                                       (if (id?310 (car ids2101))
                                           (all-ids?2100 (cdr ids2101))
                                           '#f)))
                                 (null? ids2101)))))
                      all-ids?2100)
                    ids2099)
                   (distinct-bound-ids?428 ids2099)
                   '#f)))
            (distinct-bound-ids?428
             (lambda (ids2095)
               ((letrec ((distinct?2096
                          (lambda (ids2097)
                            ((lambda (t2098)
                               (if t2098
                                   t2098
                                   (if (not (bound-id-member?430
                                              (car ids2097)
                                              (cdr ids2097)))
                                       (distinct?2096 (cdr ids2097))
                                       '#f)))
                             (null? ids2097)))))
                  distinct?2096)
                ids2095)))
            (invalid-ids-error429
             (lambda (ids2091 exp2090 class2089)
               ((letrec ((find2092
                          (lambda (ids2094 gooduns2093)
                            (if (null? ids2094)
                                (syntax-error exp2090)
                                (if (id?310 (car ids2094))
                                    (if (bound-id-member?430
                                          (car ids2094)
                                          gooduns2093)
                                        (syntax-error
                                          (car ids2094)
                                          '"duplicate "
                                          class2089)
                                        (find2092
                                          (cdr ids2094)
                                          (cons (car ids2094)
                                                gooduns2093)))
                                    (syntax-error
                                      (car ids2094)
                                      '"invalid "
                                      class2089))))))
                  find2092)
                ids2091
                '())))
            (bound-id-member?430
             (lambda (x2087 list2086)
               (if (not (null? list2086))
                   ((lambda (t2088)
                      (if t2088
                          t2088
                          (bound-id-member?430 x2087 (cdr list2086))))
                    (bound-id=?426 x2087 (car list2086)))
                   '#f)))
            (wrap431
             (lambda (x2085 w2084)
               (if (if (null? (wrap-marks318 w2084))
                       (null? (wrap-subst319 w2084))
                       '#f)
                   x2085
                   (if (syntax-object?64 x2085)
                       (make-syntax-object63
                         (syntax-object-expression65 x2085)
                         (join-wraps412
                           w2084
                           (syntax-object-wrap66 x2085)))
                       (if (null? x2085)
                           x2085
                           (make-syntax-object63 x2085 w2084))))))
            (source-wrap432
             (lambda (x2083 w2082 ae2081)
               (wrap431
                 (if (annotation?132 ae2081)
                     (begin (if (not (eq? (annotation-expression ae2081)
                                          x2083))
                                (error 'sc-expand
                                  '"internal error in source-wrap: ae/x mismatch")
                                (void))
                            ae2081)
                     x2083)
                 w2082)))
            (chi-when-list433
             (lambda (when-list2079 w2078)
               (map (lambda (x2080)
                      (if (literal-id=?425
                            x2080
                            '#(syntax-object compile ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(when-list w) #((top) (top)) #("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                          'compile
                          (if (literal-id=?425
                                x2080
                                '#(syntax-object load ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(when-list w) #((top) (top)) #("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                              'load
                              (if (literal-id=?425
                                    x2080
                                    '#(syntax-object visit ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(when-list w) #((top) (top)) #("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                  'visit
                                  (if (literal-id=?425
                                        x2080
                                        '#(syntax-object revisit ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(when-list w) #((top) (top)) #("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                      'revisit
                                      (if (literal-id=?425
                                            x2080
                                            '#(syntax-object eval ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(when-list w) #((top) (top)) #("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                          'eval
                                          (syntax-error
                                            (wrap431 x2080 w2078)
                                            '"invalid eval-when situation")))))))
                    when-list2079)))
            (syntax-type434
             (lambda (e2063 r2062 w2061 ae2060 rib2059)
               (if (symbol? e2063)
                   ((lambda (n2064)
                      ((lambda (b2065)
                         ((lambda (type2066)
                            ((lambda ()
                               ((lambda (t2067)
                                  (if (memv t2067 '(macro macro!))
                                      (syntax-type434
                                        (chi-macro489
                                          (binding-value286 b2065)
                                          e2063
                                          r2062
                                          w2061
                                          ae2060
                                          rib2059)
                                        r2062
                                        '(())
                                        '#f
                                        rib2059)
                                      (values
                                        type2066
                                        (binding-value286 b2065)
                                        e2063
                                        w2061
                                        ae2060)))
                                type2066))))
                          (binding-type285 b2065)))
                       (lookup305 n2064 r2062)))
                    (id-var-name423 e2063 w2061))
                   (if (pair? e2063)
                       ((lambda (first2068)
                          (if (id?310 first2068)
                              ((lambda (n2069)
                                 ((lambda (b2070)
                                    ((lambda (type2071)
                                       ((lambda ()
                                          ((lambda (t2072)
                                             (if (memv t2072 '(lexical))
                                                 (values
                                                   'lexical-call
                                                   (binding-value286 b2070)
                                                   e2063
                                                   w2061
                                                   ae2060)
                                                 (if (memv t2072
                                                           '(macro macro!))
                                                     (syntax-type434
                                                       (chi-macro489
                                                         (binding-value286
                                                           b2070)
                                                         e2063
                                                         r2062
                                                         w2061
                                                         ae2060
                                                         rib2059)
                                                       r2062
                                                       '(())
                                                       '#f
                                                       rib2059)
                                                     (if (memv t2072
                                                               '(core))
                                                         (values
                                                           type2071
                                                           (binding-value286
                                                             b2070)
                                                           e2063
                                                           w2061
                                                           ae2060)
                                                         (if (memv t2072
                                                                   '(begin))
                                                             (values
                                                               'begin-form
                                                               '#f
                                                               e2063
                                                               w2061
                                                               ae2060)
                                                             (if (memv t2072
                                                                       '(alias))
                                                                 (values
                                                                   'alias-form
                                                                   '#f
                                                                   e2063
                                                                   w2061
                                                                   ae2060)
                                                                 (if (memv t2072
                                                                           '(define))
                                                                     (values
                                                                       'define-form
                                                                       '#f
                                                                       e2063
                                                                       w2061
                                                                       ae2060)
                                                                     (if (memv t2072
                                                                               '(define-syntax))
                                                                         (values
                                                                           'define-syntax-form
                                                                           '#f
                                                                           e2063
                                                                           w2061
                                                                           ae2060)
                                                                         (if (memv t2072
                                                                                   '(set!))
                                                                             (chi-set!488
                                                                               e2063
                                                                               r2062
                                                                               w2061
                                                                               ae2060
                                                                               rib2059)
                                                                             (if (memv t2072
                                                                                       '($module-key))
                                                                                 (values
                                                                                   '$module-form
                                                                                   '#f
                                                                                   e2063
                                                                                   w2061
                                                                                   ae2060)
                                                                                 (if (memv t2072
                                                                                           '($import))
                                                                                     (values
                                                                                       '$import-form
                                                                                       '#f
                                                                                       e2063
                                                                                       w2061
                                                                                       ae2060)
                                                                                     (if (memv t2072
                                                                                               '(eval-when))
                                                                                         (values
                                                                                           'eval-when-form
                                                                                           '#f
                                                                                           e2063
                                                                                           w2061
                                                                                           ae2060)
                                                                                         (if (memv t2072
                                                                                                   '(meta))
                                                                                             (values
                                                                                               'meta-form
                                                                                               '#f
                                                                                               e2063
                                                                                               w2061
                                                                                               ae2060)
                                                                                             (if (memv t2072
                                                                                                       '(local-syntax))
                                                                                                 (values
                                                                                                   'local-syntax-form
                                                                                                   (binding-value286
                                                                                                     b2070)
                                                                                                   e2063
                                                                                                   w2061
                                                                                                   ae2060)
                                                                                                 (values
                                                                                                   'call
                                                                                                   '#f
                                                                                                   e2063
                                                                                                   w2061
                                                                                                   ae2060)))))))))))))))
                                           type2071))))
                                     (binding-type285 b2070)))
                                  (lookup305 n2069 r2062)))
                               (id-var-name423 first2068 w2061))
                              (values 'call '#f e2063 w2061 ae2060)))
                        (car e2063))
                       (if (syntax-object?64 e2063)
                           (syntax-type434
                             (syntax-object-expression65 e2063)
                             r2062
                             (join-wraps412
                               w2061
                               (syntax-object-wrap66 e2063))
                             '#f
                             rib2059)
                           (if (annotation?132 e2063)
                               (syntax-type434
                                 (annotation-expression e2063)
                                 r2062
                                 w2061
                                 e2063
                                 rib2059)
                               (if ((lambda (x2073)
                                      ((lambda (t2074)
                                         (if t2074
                                             t2074
                                             ((lambda (t2075)
                                                (if t2075
                                                    t2075
                                                    ((lambda (t2076)
                                                       (if t2076
                                                           t2076
                                                           ((lambda (t2077)
                                                              (if t2077
                                                                  t2077
                                                                  (null?
                                                                    x2073)))
                                                            (char?
                                                              x2073))))
                                                     (string? x2073))))
                                              (number? x2073))))
                                       (boolean? x2073)))
                                    e2063)
                                   (values
                                     'constant
                                     '#f
                                     e2063
                                     w2061
                                     ae2060)
                                   (values
                                     'other
                                     '#f
                                     e2063
                                     w2061
                                     ae2060))))))))
            (chi-top*435
             (lambda (e2054
                      r2053
                      w2052
                      ctem2051
                      rtem2050
                      meta?2049
                      top-ribcage2048)
               ((lambda (meta-residuals2055)
                  (letrec ((meta-residualize!2056
                            (lambda (x2058)
                              (set! meta-residuals2055
                                (cons x2058 meta-residuals2055)))))
                    ((lambda (e2057)
                       (build-sequence239
                         '#f
                         (reverse (cons e2057 meta-residuals2055))))
                     (chi-top437
                       e2054
                       r2053
                       w2052
                       ctem2051
                       rtem2050
                       meta?2049
                       top-ribcage2048
                       meta-residualize!2056
                       '#f))))
                '())))
            (chi-top-sequence436
             (lambda (body2044
                      r2043
                      w2042
                      ae2041
                      ctem2040
                      rtem2039
                      meta?2038
                      ribcage2037
                      meta-residualize!2036)
               (build-sequence239
                 ae2041
                 ((letrec ((dobody2045
                            (lambda (body2046)
                              (if (null? body2046)
                                  '()
                                  ((lambda (first2047)
                                     (cons first2047
                                           (dobody2045 (cdr body2046))))
                                   (chi-top437
                                     (car body2046)
                                     r2043
                                     w2042
                                     ctem2040
                                     rtem2039
                                     meta?2038
                                     ribcage2037
                                     meta-residualize!2036
                                     '#f))))))
                    dobody2045)
                  body2044))))
            (chi-top437
             (lambda (e1982
                      r1981
                      w1980
                      ctem1979
                      rtem1978
                      meta?1977
                      top-ribcage1976
                      meta-residualize!1975
                      meta-seen?1974)
               (call-with-values
                 (lambda ()
                   (syntax-type434 e1982 r1981 w1980 '#f top-ribcage1976))
                 (lambda (type1987 value1986 e1985 w1984 ae1983)
                   ((lambda (t1988)
                      (if (memv t1988 '(begin-form))
                          ((lambda (forms1989)
                             (if (null? forms1989)
                                 (chi-void503)
                                 (chi-top-sequence436
                                   forms1989
                                   r1981
                                   w1984
                                   ae1983
                                   ctem1979
                                   rtem1978
                                   meta?1977
                                   top-ribcage1976
                                   meta-residualize!1975)))
                           (parse-begin500 e1985 w1984 ae1983 '#t))
                          (if (memv t1988 '(local-syntax-form))
                              (call-with-values
                                (lambda ()
                                  (chi-local-syntax502
                                    value1986
                                    e1985
                                    r1981
                                    r1981
                                    w1984
                                    ae1983))
                                (lambda (forms1994
                                         r1993
                                         mr1992
                                         w1991
                                         ae1990)
                                  (chi-top-sequence436
                                    forms1994
                                    r1993
                                    w1991
                                    ae1990
                                    ctem1979
                                    rtem1978
                                    meta?1977
                                    top-ribcage1976
                                    meta-residualize!1975)))
                              (if (memv t1988 '(eval-when-form))
                                  (call-with-values
                                    (lambda ()
                                      (parse-eval-when498
                                        e1985
                                        w1984
                                        ae1983))
                                    (lambda (when-list1996 forms1995)
                                      ((lambda (ctem1998 rtem1997)
                                         (if (if (null? ctem1998)
                                                 (null? rtem1997)
                                                 '#f)
                                             (chi-void503)
                                             (chi-top-sequence436
                                               forms1995
                                               r1981
                                               w1984
                                               ae1983
                                               ctem1998
                                               rtem1997
                                               meta?1977
                                               top-ribcage1976
                                               meta-residualize!1975)))
                                       (update-mode-set477
                                         when-list1996
                                         ctem1979)
                                       (update-mode-set477
                                         when-list1996
                                         rtem1978))))
                                  (if (memv t1988 '(meta-form))
                                      (chi-top437
                                        (parse-meta497 e1985 w1984 ae1983)
                                        r1981
                                        w1984
                                        ctem1979
                                        rtem1978
                                        '#t
                                        top-ribcage1976
                                        meta-residualize!1975
                                        '#t)
                                      (if (memv t1988
                                                '(define-syntax-form))
                                          (call-with-values
                                            (lambda ()
                                              (parse-define-syntax496
                                                e1985
                                                w1984
                                                ae1983))
                                            (lambda (id2001 rhs2000 w1999)
                                              ((lambda (id2002)
                                                 (begin (if (displaced-lexical?302
                                                              id2002
                                                              r1981)
                                                            (displaced-lexical-error303
                                                              id2002)
                                                            (void))
                                                        (if (not (top-ribcage-mutable?369
                                                                   top-ribcage1976))
                                                            (syntax-error
                                                              (source-wrap432
                                                                e1985
                                                                w1999
                                                                ae1983)
                                                              '"invalid definition in read-only environment")
                                                            (void))
                                                        ((lambda (sym2003)
                                                           (call-with-values
                                                             (lambda ()
                                                               (top-id-bound-var-name418
                                                                 sym2003
                                                                 (wrap-marks318
                                                                   (syntax-object-wrap66
                                                                     id2002))
                                                                 top-ribcage1976))
                                                             (lambda (valsym2005
                                                                      bound-id2004)
                                                               (begin (if (not (eq? (id-var-name423
                                                                                      id2002
                                                                                      '(()))
                                                                                    valsym2005))
                                                                          (syntax-error
                                                                            (source-wrap432
                                                                              e1985
                                                                              w1999
                                                                              ae1983)
                                                                            '"definition not permitted")
                                                                          (void))
                                                                      (if (read-only-binding?144
                                                                            valsym2005)
                                                                          (syntax-error
                                                                            (source-wrap432
                                                                              e1985
                                                                              w1999
                                                                              ae1983)
                                                                            '"invalid definition of read-only identifier")
                                                                          (void))
                                                                      (ct-eval/residualize2480
                                                                        ctem1979
                                                                        (lambda ()
                                                                          (list '$sc-put-cte
                                                                                (list 'quote
                                                                                      bound-id2004)
                                                                                (chi485
                                                                                  rhs2000
                                                                                  r1981
                                                                                  r1981
                                                                                  w1999
                                                                                  '#t)
                                                                                (list 'quote
                                                                                      (top-ribcage-key368
                                                                                        top-ribcage1976)))))))))
                                                         ((lambda (x2006)
                                                            ((lambda (e2007)
                                                               (if (annotation?132
                                                                     e2007)
                                                                   (annotation-expression
                                                                     e2007)
                                                                   e2007))
                                                             (if (syntax-object?64
                                                                   x2006)
                                                                 (syntax-object-expression65
                                                                   x2006)
                                                                 x2006)))
                                                          id2002))))
                                               (wrap431 id2001 w1999))))
                                          (if (memv t1988 '(define-form))
                                              (call-with-values
                                                (lambda ()
                                                  (parse-define495
                                                    e1985
                                                    w1984
                                                    ae1983))
                                                (lambda (id2010
                                                         rhs2009
                                                         w2008)
                                                  ((lambda (id2011)
                                                     (begin (if (displaced-lexical?302
                                                                  id2011
                                                                  r1981)
                                                                (displaced-lexical-error303
                                                                  id2011)
                                                                (void))
                                                            (if (not (top-ribcage-mutable?369
                                                                       top-ribcage1976))
                                                                (syntax-error
                                                                  (source-wrap432
                                                                    e1985
                                                                    w2008
                                                                    ae1983)
                                                                  '"invalid definition in read-only environment")
                                                                (void))
                                                            ((lambda (sym2012)
                                                               (call-with-values
                                                                 (lambda ()
                                                                   (top-id-bound-var-name418
                                                                     sym2012
                                                                     (wrap-marks318
                                                                       (syntax-object-wrap66
                                                                         id2011))
                                                                     top-ribcage1976))
                                                                 (lambda (valsym2014
                                                                          bound-id2013)
                                                                   (begin (if (not (eq? (id-var-name423
                                                                                          id2011
                                                                                          '(()))
                                                                                        valsym2014))
                                                                              (syntax-error
                                                                                (source-wrap432
                                                                                  e1985
                                                                                  w2008
                                                                                  ae1983)
                                                                                '"definition not permitted")
                                                                              (void))
                                                                          (if (read-only-binding?144
                                                                                valsym2014)
                                                                              (syntax-error
                                                                                (source-wrap432
                                                                                  e1985
                                                                                  w2008
                                                                                  ae1983)
                                                                                '"invalid definition of read-only identifier")
                                                                              (void))
                                                                          (if meta?1977
                                                                              (ct-eval/residualize2480
                                                                                ctem1979
                                                                                (lambda ()
                                                                                  (build-sequence239
                                                                                    '#f
                                                                                    (list (list '$sc-put-cte
                                                                                                (list 'quote
                                                                                                      bound-id2013)
                                                                                                (list 'quote
                                                                                                      (cons 'meta-variable
                                                                                                            valsym2014))
                                                                                                (list 'quote
                                                                                                      (top-ribcage-key368
                                                                                                        top-ribcage1976)))
                                                                                          (list 'define
                                                                                                valsym2014
                                                                                                (chi485
                                                                                                  rhs2009
                                                                                                  r1981
                                                                                                  r1981
                                                                                                  w2008
                                                                                                  '#t))))))
                                                                              (build-sequence239
                                                                                '#f
                                                                                (list (ct-eval/residualize2480
                                                                                        ctem1979
                                                                                        (lambda ()
                                                                                          (list '$sc-put-cte
                                                                                                (list 'quote
                                                                                                      bound-id2013)
                                                                                                (list 'quote
                                                                                                      (cons 'global
                                                                                                            valsym2014))
                                                                                                (list 'quote
                                                                                                      (top-ribcage-key368
                                                                                                        top-ribcage1976)))))
                                                                                      (rt-eval/residualize479
                                                                                        rtem1978
                                                                                        (lambda ()
                                                                                          (list 'define
                                                                                                valsym2014
                                                                                                (chi485
                                                                                                  rhs2009
                                                                                                  r1981
                                                                                                  r1981
                                                                                                  w2008
                                                                                                  '#f)))))))))))
                                                             ((lambda (x2015)
                                                                ((lambda (e2016)
                                                                   (if (annotation?132
                                                                         e2016)
                                                                       (annotation-expression
                                                                         e2016)
                                                                       e2016))
                                                                 (if (syntax-object?64
                                                                       x2015)
                                                                     (syntax-object-expression65
                                                                       x2015)
                                                                     x2015)))
                                                              id2011))))
                                                   (wrap431
                                                     id2010
                                                     w2008))))
                                              (if (memv t1988
                                                        '($module-form))
                                                  ((lambda (ribcage2017)
                                                     (call-with-values
                                                       (lambda ()
                                                         (parse-module493
                                                           e1985
                                                           w1984
                                                           ae1983
                                                           (make-wrap317
                                                             (wrap-marks318
                                                               w1984)
                                                             (cons ribcage2017
                                                                   (wrap-subst319
                                                                     w1984)))))
                                                       (lambda (orig2021
                                                                id2020
                                                                exports2019
                                                                forms2018)
                                                         (begin (if (displaced-lexical?302
                                                                      id2020
                                                                      r1981)
                                                                    (displaced-lexical-error303
                                                                      (wrap431
                                                                        id2020
                                                                        w1984))
                                                                    (void))
                                                                (if (not (top-ribcage-mutable?369
                                                                           top-ribcage1976))
                                                                    (syntax-error
                                                                      orig2021
                                                                      '"invalid definition in read-only environment")
                                                                    (void))
                                                                (chi-top-module469
                                                                  orig2021
                                                                  r1981
                                                                  r1981
                                                                  top-ribcage1976
                                                                  ribcage2017
                                                                  ctem1979
                                                                  rtem1978
                                                                  meta?1977
                                                                  id2020
                                                                  exports2019
                                                                  forms2018
                                                                  meta-residualize!1975)))))
                                                   (make-ribcage358
                                                     '()
                                                     '()
                                                     '()))
                                                  (if (memv t1988
                                                            '($import-form))
                                                      (call-with-values
                                                        (lambda ()
                                                          (parse-import494
                                                            e1985
                                                            w1984
                                                            ae1983))
                                                        (lambda (orig2024
                                                                 only?2023
                                                                 mid2022)
                                                          (begin (if (not (top-ribcage-mutable?369
                                                                            top-ribcage1976))
                                                                     (syntax-error
                                                                       orig2024
                                                                       '"invalid definition in read-only environment")
                                                                     (void))
                                                                 (ct-eval/residualize2480
                                                                   ctem1979
                                                                   (lambda ()
                                                                     ((lambda (binding2025)
                                                                        ((lambda (t2026)
                                                                           (if (memv t2026
                                                                                     '($module))
                                                                               (do-top-import476
                                                                                 only?2023
                                                                                 top-ribcage1976
                                                                                 mid2022
                                                                                 (interface-token442
                                                                                   (binding-value286
                                                                                     binding2025)))
                                                                               (if (memv t2026
                                                                                         '(displaced-lexical))
                                                                                   (displaced-lexical-error303
                                                                                     mid2022)
                                                                                   (syntax-error
                                                                                     mid2022
                                                                                     '"unknown module"))))
                                                                         (binding-type285
                                                                           binding2025)))
                                                                      (lookup305
                                                                        (id-var-name423
                                                                          mid2022
                                                                          '(()))
                                                                        '())))))))
                                                      (if (memv t1988
                                                                '(alias-form))
                                                          (call-with-values
                                                            (lambda ()
                                                              (parse-alias499
                                                                e1985
                                                                w1984
                                                                ae1983))
                                                            (lambda (new-id2028
                                                                     old-id2027)
                                                              ((lambda (new-id2029)
                                                                 (begin (if (displaced-lexical?302
                                                                              new-id2029
                                                                              r1981)
                                                                            (displaced-lexical-error303
                                                                              new-id2029)
                                                                            (void))
                                                                        (if (not (top-ribcage-mutable?369
                                                                                   top-ribcage1976))
                                                                            (syntax-error
                                                                              (source-wrap432
                                                                                e1985
                                                                                w1984
                                                                                ae1983)
                                                                              '"invalid definition in read-only environment")
                                                                            (void))
                                                                        ((lambda (sym2030)
                                                                           (call-with-values
                                                                             (lambda ()
                                                                               (top-id-bound-var-name418
                                                                                 sym2030
                                                                                 (wrap-marks318
                                                                                   (syntax-object-wrap66
                                                                                     new-id2029))
                                                                                 top-ribcage1976))
                                                                             (lambda (valsym2032
                                                                                      bound-id2031)
                                                                               (begin (if (not (eq? (id-var-name423
                                                                                                      new-id2029
                                                                                                      '(()))
                                                                                                    valsym2032))
                                                                                          (syntax-error
                                                                                            (source-wrap432
                                                                                              e1985
                                                                                              w1984
                                                                                              ae1983)
                                                                                            '"definition not permitted")
                                                                                          (void))
                                                                                      (if (read-only-binding?144
                                                                                            valsym2032)
                                                                                          (syntax-error
                                                                                            (source-wrap432
                                                                                              e1985
                                                                                              w1984
                                                                                              ae1983)
                                                                                            '"invalid definition of read-only identifier")
                                                                                          (void))
                                                                                      (ct-eval/residualize2480
                                                                                        ctem1979
                                                                                        (lambda ()
                                                                                          (list '$sc-put-cte
                                                                                                (list 'quote
                                                                                                      (make-resolved-id408
                                                                                                        sym2030
                                                                                                        (wrap-marks318
                                                                                                          (syntax-object-wrap66
                                                                                                            new-id2029))
                                                                                                        (id-var-name423
                                                                                                          old-id2027
                                                                                                          w1984)))
                                                                                                (list 'quote
                                                                                                      '(do-alias
                                                                                                         .
                                                                                                         #f))
                                                                                                (list 'quote
                                                                                                      (top-ribcage-key368
                                                                                                        top-ribcage1976)))))))))
                                                                         ((lambda (x2033)
                                                                            ((lambda (e2034)
                                                                               (if (annotation?132
                                                                                     e2034)
                                                                                   (annotation-expression
                                                                                     e2034)
                                                                                   e2034))
                                                                             (if (syntax-object?64
                                                                                   x2033)
                                                                                 (syntax-object-expression65
                                                                                   x2033)
                                                                                 x2033)))
                                                                          new-id2029))))
                                                               (wrap431
                                                                 new-id2028
                                                                 w1984))))
                                                          (begin (if meta-seen?1974
                                                                     (syntax-error
                                                                       (source-wrap432
                                                                         e1985
                                                                         w1984
                                                                         ae1983)
                                                                       '"invalid meta definition")
                                                                     (void))
                                                                 (if meta?1977
                                                                     ((lambda (x2035)
                                                                        (begin (top-level-eval-hook133
                                                                                 x2035)
                                                                               (ct-eval/residualize3481
                                                                                 ctem1979
                                                                                 void
                                                                                 (lambda ()
                                                                                   x2035))))
                                                                      (chi-expr486
                                                                        type1987
                                                                        value1986
                                                                        e1985
                                                                        r1981
                                                                        r1981
                                                                        w1984
                                                                        ae1983
                                                                        '#t))
                                                                     (rt-eval/residualize479
                                                                       rtem1978
                                                                       (lambda ()
                                                                         (chi-expr486
                                                                           type1987
                                                                           value1986
                                                                           e1985
                                                                           r1981
                                                                           r1981
                                                                           w1984
                                                                           ae1983
                                                                           '#f)))))))))))))))
                    type1987)))))
            (flatten-exports438
             (lambda (exports1970)
               ((letrec ((loop1971
                          (lambda (exports1973 ls1972)
                            (if (null? exports1973)
                                ls1972
                                (loop1971
                                  (cdr exports1973)
                                  (if (pair? (car exports1973))
                                      (loop1971 (car exports1973) ls1972)
                                      (cons (car exports1973) ls1972)))))))
                  loop1971)
                exports1970
                '())))
            (make-interface439
             (lambda (exports1969 token1968)
               (vector 'interface exports1969 token1968)))
            (interface?440
             (lambda (x1967)
               (if (vector? x1967)
                   (if (= (vector-length x1967) '3)
                       (eq? (vector-ref x1967 '0) 'interface)
                       '#f)
                   '#f)))
            (interface-exports441
             (lambda (x1966) (vector-ref x1966 '1)))
            (interface-token442 (lambda (x1965) (vector-ref x1965 '2)))
            (set-interface-exports!443
             (lambda (x1964 update1963)
               (vector-set! x1964 '1 update1963)))
            (set-interface-token!444
             (lambda (x1962 update1961)
               (vector-set! x1962 '2 update1961)))
            (make-unresolved-interface445
             (lambda (exports1959)
               (make-interface439
                 (list->vector
                   (map (lambda (x1960)
                          (if (pair? x1960) (car x1960) x1960))
                        exports1959))
                 '#f)))
            (make-resolved-interface1446
             (lambda (exports1958)
               (make-resolved-interface2447 exports1958 '#f)))
            (make-resolved-interface2447
             (lambda (exports1956 import-token1955)
               (make-interface439
                 (list->vector
                   (map (lambda (x1957)
                          (id->resolved-id409
                            (if (pair? x1957) (car x1957) x1957)))
                        exports1956))
                 import-token1955)))
            (make-module-binding448
             (lambda (type1954
                      id1953
                      label1952
                      imps1951
                      val1950
                      exported1949)
               (vector
                 'module-binding
                 type1954
                 id1953
                 label1952
                 imps1951
                 val1950
                 exported1949)))
            (module-binding?449
             (lambda (x1948)
               (if (vector? x1948)
                   (if (= (vector-length x1948) '7)
                       (eq? (vector-ref x1948 '0) 'module-binding)
                       '#f)
                   '#f)))
            (module-binding-type450
             (lambda (x1947) (vector-ref x1947 '1)))
            (module-binding-id451
             (lambda (x1946) (vector-ref x1946 '2)))
            (module-binding-label452
             (lambda (x1945) (vector-ref x1945 '3)))
            (module-binding-imps453
             (lambda (x1944) (vector-ref x1944 '4)))
            (module-binding-val454
             (lambda (x1943) (vector-ref x1943 '5)))
            (module-binding-exported455
             (lambda (x1942) (vector-ref x1942 '6)))
            (set-module-binding-type!456
             (lambda (x1941 update1940)
               (vector-set! x1941 '1 update1940)))
            (set-module-binding-id!457
             (lambda (x1939 update1938)
               (vector-set! x1939 '2 update1938)))
            (set-module-binding-label!458
             (lambda (x1937 update1936)
               (vector-set! x1937 '3 update1936)))
            (set-module-binding-imps!459
             (lambda (x1935 update1934)
               (vector-set! x1935 '4 update1934)))
            (set-module-binding-val!460
             (lambda (x1933 update1932)
               (vector-set! x1933 '5 update1932)))
            (set-module-binding-exported!461
             (lambda (x1931 update1930)
               (vector-set! x1931 '6 update1930)))
            (create-module-binding462
             (lambda (type1929 id1928 label1927 imps1926 val1925)
               (make-module-binding448
                 type1929
                 id1928
                 label1927
                 imps1926
                 val1925
                 '#f)))
            (make-frob463
             (lambda (e1924 meta?1923) (vector 'frob e1924 meta?1923)))
            (frob?464
             (lambda (x1922)
               (if (vector? x1922)
                   (if (= (vector-length x1922) '3)
                       (eq? (vector-ref x1922 '0) 'frob)
                       '#f)
                   '#f)))
            (frob-e465 (lambda (x1921) (vector-ref x1921 '1)))
            (frob-meta?466 (lambda (x1920) (vector-ref x1920 '2)))
            (set-frob-e!467
             (lambda (x1919 update1918)
               (vector-set! x1919 '1 update1918)))
            (set-frob-meta?!468
             (lambda (x1917 update1916)
               (vector-set! x1917 '2 update1916)))
            (chi-top-module469
             (lambda (orig1857
                      r1856
                      mr1855
                      top-ribcage1854
                      ribcage1853
                      ctem1852
                      rtem1851
                      meta?1850
                      id1849
                      exports1848
                      forms1847
                      meta-residualize!1846)
               ((lambda (fexports1858)
                  (call-with-values
                    (lambda ()
                      (chi-external473
                        ribcage1853
                        orig1857
                        (map (lambda (d1915)
                               (make-frob463 d1915 meta?1850))
                             forms1847)
                        r1856
                        mr1855
                        ctem1852
                        exports1848
                        fexports1858
                        meta-residualize!1846))
                    (lambda (r1862 mr1861 bindings1860 inits1859)
                      ((letrec ((process-exports1863
                                 (lambda (fexports1865 ctdefs1864)
                                   (if (null? fexports1865)
                                       ((letrec ((process-locals1866
                                                  (lambda (bs1871
                                                           r1870
                                                           dts1869
                                                           dvs1868
                                                           des1867)
                                                    (if (null? bs1871)
                                                        ((lambda (des1873
                                                                  inits1872)
                                                           (build-sequence239
                                                             '#f
                                                             (append
                                                               (ctdefs1864)
                                                               (list (ct-eval/residualize2480
                                                                       ctem1852
                                                                       (lambda ()
                                                                         ((lambda (sym1874)
                                                                            ((lambda (token1875)
                                                                               ((lambda (b1876)
                                                                                  ((lambda ()
                                                                                     (call-with-values
                                                                                       (lambda ()
                                                                                         (top-id-bound-var-name418
                                                                                           sym1874
                                                                                           (wrap-marks318
                                                                                             (syntax-object-wrap66
                                                                                               id1849))
                                                                                           top-ribcage1854))
                                                                                       (lambda (valsym1878
                                                                                                bound-id1877)
                                                                                         (begin (if (not (eq? (id-var-name423
                                                                                                                id1849
                                                                                                                '(()))
                                                                                                              valsym1878))
                                                                                                    (syntax-error
                                                                                                      orig1857
                                                                                                      '"definition not permitted")
                                                                                                    (void))
                                                                                                (if (read-only-binding?144
                                                                                                      valsym1878)
                                                                                                    (syntax-error
                                                                                                      orig1857
                                                                                                      '"invalid definition of read-only identifier")
                                                                                                    (void))
                                                                                                (list '$sc-put-cte
                                                                                                      (list 'quote
                                                                                                            bound-id1877)
                                                                                                      b1876
                                                                                                      (list 'quote
                                                                                                            (top-ribcage-key368
                                                                                                              top-ribcage1854)))))))))
                                                                                (list 'quote
                                                                                      (cons '$module
                                                                                            (make-resolved-interface2447
                                                                                              exports1848
                                                                                              token1875)))))
                                                                             (generate-id147
                                                                               sym1874)))
                                                                          ((lambda (x1879)
                                                                             ((lambda (e1880)
                                                                                (if (annotation?132
                                                                                      e1880)
                                                                                    (annotation-expression
                                                                                      e1880)
                                                                                    e1880))
                                                                              (if (syntax-object?64
                                                                                    x1879)
                                                                                  (syntax-object-expression65
                                                                                    x1879)
                                                                                  x1879)))
                                                                           id1849))))
                                                                     (rt-eval/residualize479
                                                                       rtem1851
                                                                       (lambda ()
                                                                         (build-top-module242
                                                                           '#f
                                                                           dts1869
                                                                           dvs1868
                                                                           des1873
                                                                           (if (null?
                                                                                 inits1872)
                                                                               (chi-void503)
                                                                               (build-sequence239
                                                                                 '#f
                                                                                 (append
                                                                                   inits1872
                                                                                   (list (chi-void503))))))))))))
                                                         (chi-frobs482
                                                           des1867
                                                           r1870
                                                           mr1861
                                                           '#f)
                                                         (chi-frobs482
                                                           inits1859
                                                           r1870
                                                           mr1861
                                                           '#f))
                                                        ((lambda (b1882
                                                                  bs1881)
                                                           ((lambda (t1883)
                                                              ((lambda (t1884)
                                                                 (if (memv t1884
                                                                           '(define-form))
                                                                     ((lambda (label1885)
                                                                        (if (module-binding-exported455
                                                                              b1882)
                                                                            ((lambda (var1886)
                                                                               (process-locals1866
                                                                                 bs1881
                                                                                 r1870
                                                                                 (cons 'global
                                                                                       dts1869)
                                                                                 (cons label1885
                                                                                       dvs1868)
                                                                                 (cons (module-binding-val454
                                                                                         b1882)
                                                                                       des1867)))
                                                                             (module-binding-id451
                                                                               b1882))
                                                                            ((lambda (var1887)
                                                                               (process-locals1866
                                                                                 bs1881
                                                                                 (extend-env299
                                                                                   label1885
                                                                                   (cons 'lexical
                                                                                         var1887)
                                                                                   r1870)
                                                                                 (cons 'local
                                                                                       dts1869)
                                                                                 (cons var1887
                                                                                       dvs1868)
                                                                                 (cons (module-binding-val454
                                                                                         b1882)
                                                                                       des1867)))
                                                                             (gen-var508
                                                                               (module-binding-id451
                                                                                 b1882)))))
                                                                      (get-indirect-label353
                                                                        (module-binding-label452
                                                                          b1882)))
                                                                     (if (memv t1884
                                                                               '(ctdefine-form
                                                                                  define-syntax-form
                                                                                  $module-form
                                                                                  alias-form))
                                                                         (process-locals1866
                                                                           bs1881
                                                                           r1870
                                                                           dts1869
                                                                           dvs1868
                                                                           des1867)
                                                                         (error 'sc-expand-internal
                                                                           '"unexpected module binding type ~s"
                                                                           t1883))))
                                                               (module-binding-type450
                                                                 b1882)))
                                                            (module-binding-type450
                                                              b1882)))
                                                         (car bs1871)
                                                         (cdr bs1871))))))
                                          process-locals1866)
                                        bindings1860
                                        r1862
                                        '()
                                        '()
                                        '())
                                       ((lambda (id1889 fexports1888)
                                          ((letrec ((loop1890
                                                     (lambda (bs1891)
                                                       (if (null? bs1891)
                                                           (process-exports1863
                                                             fexports1888
                                                             ctdefs1864)
                                                           ((lambda (b1893
                                                                     bs1892)
                                                              (if (free-id=?424
                                                                    (module-binding-id451
                                                                      b1893)
                                                                    id1889)
                                                                  (if (module-binding-exported455
                                                                        b1893)
                                                                      (process-exports1863
                                                                        fexports1888
                                                                        ctdefs1864)
                                                                      ((lambda (t1894)
                                                                         ((lambda (label1895)
                                                                            ((lambda (imps1896)
                                                                               ((lambda (fexports1897)
                                                                                  ((lambda ()
                                                                                     (begin (set-module-binding-exported!461
                                                                                              b1893
                                                                                              '#t)
                                                                                            ((lambda (t1898)
                                                                                               (if (memv t1898
                                                                                                         '(define-form))
                                                                                                   ((lambda (sym1899)
                                                                                                      (begin (set-indirect-label!354
                                                                                                               label1895
                                                                                                               sym1899)
                                                                                                             (process-exports1863
                                                                                                               fexports1897
                                                                                                               ctdefs1864)))
                                                                                                    (generate-id147
                                                                                                      ((lambda (x1900)
                                                                                                         ((lambda (e1901)
                                                                                                            (if (annotation?132
                                                                                                                  e1901)
                                                                                                                (annotation-expression
                                                                                                                  e1901)
                                                                                                                e1901))
                                                                                                          (if (syntax-object?64
                                                                                                                x1900)
                                                                                                              (syntax-object-expression65
                                                                                                                x1900)
                                                                                                              x1900)))
                                                                                                       id1889)))
                                                                                                   (if (memv t1898
                                                                                                             '(ctdefine-form))
                                                                                                       ((lambda (b1902)
                                                                                                          (process-exports1863
                                                                                                            fexports1897
                                                                                                            (lambda ()
                                                                                                              ((lambda (sym1903)
                                                                                                                 (begin (set-indirect-label!354
                                                                                                                          label1895
                                                                                                                          sym1903)
                                                                                                                        (cons (ct-eval/residualize3481
                                                                                                                                ctem1852
                                                                                                                                (lambda ()
                                                                                                                                  (put-cte-hook141
                                                                                                                                    sym1903
                                                                                                                                    b1902))
                                                                                                                                (lambda ()
                                                                                                                                  (list '$sc-put-cte
                                                                                                                                        (list 'quote
                                                                                                                                              sym1903)
                                                                                                                                        (list 'quote
                                                                                                                                              b1902)
                                                                                                                                        (list 'quote
                                                                                                                                              '#f))))
                                                                                                                              (ctdefs1864))))
                                                                                                               (binding-value286
                                                                                                                 b1902)))))
                                                                                                        (module-binding-val454
                                                                                                          b1893))
                                                                                                       (if (memv t1898
                                                                                                                 '(define-syntax-form))
                                                                                                           ((lambda (sym1904)
                                                                                                              (process-exports1863
                                                                                                                fexports1897
                                                                                                                (lambda ()
                                                                                                                  ((lambda (local-label1905)
                                                                                                                     (begin (set-indirect-label!354
                                                                                                                              label1895
                                                                                                                              sym1904)
                                                                                                                            (cons (ct-eval/residualize3481
                                                                                                                                    ctem1852
                                                                                                                                    (lambda ()
                                                                                                                                      (put-cte-hook141
                                                                                                                                        sym1904
                                                                                                                                        (car (module-binding-val454
                                                                                                                                               b1893))))
                                                                                                                                    (lambda ()
                                                                                                                                      (list '$sc-put-cte
                                                                                                                                            (list 'quote
                                                                                                                                                  sym1904)
                                                                                                                                            (cdr (module-binding-val454
                                                                                                                                                   b1893))
                                                                                                                                            (list 'quote
                                                                                                                                                  '#f))))
                                                                                                                                  (ctdefs1864))))
                                                                                                                   (get-indirect-label353
                                                                                                                     label1895)))))
                                                                                                            (generate-id147
                                                                                                              ((lambda (x1906)
                                                                                                                 ((lambda (e1907)
                                                                                                                    (if (annotation?132
                                                                                                                          e1907)
                                                                                                                        (annotation-expression
                                                                                                                          e1907)
                                                                                                                        e1907))
                                                                                                                  (if (syntax-object?64
                                                                                                                        x1906)
                                                                                                                      (syntax-object-expression65
                                                                                                                        x1906)
                                                                                                                      x1906)))
                                                                                                               id1889)))
                                                                                                           (if (memv t1898
                                                                                                                     '($module-form))
                                                                                                               ((lambda (sym1909
                                                                                                                         exports1908)
                                                                                                                  (process-exports1863
                                                                                                                    (append
                                                                                                                      (flatten-exports438
                                                                                                                        exports1908)
                                                                                                                      fexports1897)
                                                                                                                    (lambda ()
                                                                                                                      (begin (set-indirect-label!354
                                                                                                                               label1895
                                                                                                                               sym1909)
                                                                                                                             ((lambda (rest1910)
                                                                                                                                ((lambda (x1911)
                                                                                                                                   (cons (ct-eval/residualize3481
                                                                                                                                           ctem1852
                                                                                                                                           (lambda ()
                                                                                                                                             (put-cte-hook141
                                                                                                                                               sym1909
                                                                                                                                               x1911))
                                                                                                                                           (lambda ()
                                                                                                                                             (list '$sc-put-cte
                                                                                                                                                   (list 'quote
                                                                                                                                                         sym1909)
                                                                                                                                                   (list 'quote
                                                                                                                                                         x1911)
                                                                                                                                                   (list 'quote
                                                                                                                                                         '#f))))
                                                                                                                                         rest1910))
                                                                                                                                 (cons '$module
                                                                                                                                       (make-resolved-interface2447
                                                                                                                                         exports1908
                                                                                                                                         sym1909))))
                                                                                                                              (ctdefs1864))))))
                                                                                                                (generate-id147
                                                                                                                  ((lambda (x1912)
                                                                                                                     ((lambda (e1913)
                                                                                                                        (if (annotation?132
                                                                                                                              e1913)
                                                                                                                            (annotation-expression
                                                                                                                              e1913)
                                                                                                                            e1913))
                                                                                                                      (if (syntax-object?64
                                                                                                                            x1912)
                                                                                                                          (syntax-object-expression65
                                                                                                                            x1912)
                                                                                                                          x1912)))
                                                                                                                   id1889))
                                                                                                                (module-binding-val454
                                                                                                                  b1893))
                                                                                                               (if (memv t1898
                                                                                                                         '(alias-form))
                                                                                                                   (process-exports1863
                                                                                                                     fexports1897
                                                                                                                     (lambda ()
                                                                                                                       ((lambda (rest1914)
                                                                                                                          (begin (if (indirect-label?349
                                                                                                                                       label1895)
                                                                                                                                     (if (not (symbol?
                                                                                                                                                (get-indirect-label353
                                                                                                                                                  label1895)))
                                                                                                                                         (syntax-error
                                                                                                                                           (module-binding-id451
                                                                                                                                             b1893)
                                                                                                                                           '"unexported target of alias")
                                                                                                                                         (void))
                                                                                                                                     (void))
                                                                                                                                 rest1914))
                                                                                                                        (ctdefs1864))))
                                                                                                                   (error 'sc-expand-internal
                                                                                                                     '"unexpected module binding type ~s"
                                                                                                                     t1894)))))))
                                                                                             t1894)))))
                                                                                (append
                                                                                  imps1896
                                                                                  fexports1888)))
                                                                             (module-binding-imps453
                                                                               b1893)))
                                                                          (module-binding-label452
                                                                            b1893)))
                                                                       (module-binding-type450
                                                                         b1893)))
                                                                  (loop1890
                                                                    bs1892)))
                                                            (car bs1891)
                                                            (cdr bs1891))))))
                                             loop1890)
                                           bindings1860))
                                        (car fexports1865)
                                        (cdr fexports1865))))))
                         process-exports1863)
                       fexports1858
                       (lambda () '())))))
                (flatten-exports438 exports1848))))
            (id-set-diff470
             (lambda (exports1845 defs1844)
               (if (null? exports1845)
                   '()
                   (if (bound-id-member?430 (car exports1845) defs1844)
                       (id-set-diff470 (cdr exports1845) defs1844)
                       (cons (car exports1845)
                             (id-set-diff470
                               (cdr exports1845)
                               defs1844))))))
            (check-module-exports471
             (lambda (source-exp1827 fexports1826 ids1825)
               (letrec ((defined?1828
                         (lambda (e1835 ids1834)
                           (ormap
                             (lambda (x1836)
                               (if (interface?440 x1836)
                                   ((lambda (token1837)
                                      (if token1837
                                          (lookup-import-binding-name405
                                            ((lambda (x1838)
                                               ((lambda (e1839)
                                                  (if (annotation?132
                                                        e1839)
                                                      (annotation-expression
                                                        e1839)
                                                      e1839))
                                                (if (syntax-object?64
                                                      x1838)
                                                    (syntax-object-expression65
                                                      x1838)
                                                    x1838)))
                                             e1835)
                                            token1837
                                            (wrap-marks318
                                              (syntax-object-wrap66
                                                e1835)))
                                          ((lambda (v1840)
                                             ((letrec ((lp1841
                                                        (lambda (i1842)
                                                          (if (>= i1842 '0)
                                                              ((lambda (t1843)
                                                                 (if t1843
                                                                     t1843
                                                                     (lp1841
                                                                       (- i1842
                                                                          '1))))
                                                               (bound-id=?426
                                                                 e1835
                                                                 (vector-ref
                                                                   v1840
                                                                   i1842)))
                                                              '#f))))
                                                lp1841)
                                              (- (vector-length v1840)
                                                 '1)))
                                           (interface-exports441 x1836))))
                                    (interface-token442 x1836))
                                   (bound-id=?426 e1835 x1836)))
                             ids1834))))
                 ((letrec ((loop1829
                            (lambda (fexports1831 missing1830)
                              (if (null? fexports1831)
                                  (if (not (null? missing1830))
                                      (syntax-error
                                        missing1830
                                        '"missing definition for export(s)")
                                      (void))
                                  ((lambda (e1833 fexports1832)
                                     (if (defined?1828 e1833 ids1825)
                                         (loop1829
                                           fexports1832
                                           missing1830)
                                         (loop1829
                                           fexports1832
                                           (cons e1833 missing1830))))
                                   (car fexports1831)
                                   (cdr fexports1831))))))
                    loop1829)
                  fexports1826
                  '()))))
            (check-defined-ids472
             (lambda (source-exp1782 ls1781)
               (letrec ((b-i=?1783
                         (lambda (x1820 y1819)
                           (if (symbol? x1820)
                               (if (symbol? y1819)
                                   (eq? x1820 y1819)
                                   (if (eq? x1820
                                            ((lambda (x1821)
                                               ((lambda (e1822)
                                                  (if (annotation?132
                                                        e1822)
                                                      (annotation-expression
                                                        e1822)
                                                      e1822))
                                                (if (syntax-object?64
                                                      x1821)
                                                    (syntax-object-expression65
                                                      x1821)
                                                    x1821)))
                                             y1819))
                                       (same-marks?415
                                         (wrap-marks318
                                           (syntax-object-wrap66 y1819))
                                         (wrap-marks318 '((top))))
                                       '#f))
                               (if (symbol? y1819)
                                   (if (eq? y1819
                                            ((lambda (x1823)
                                               ((lambda (e1824)
                                                  (if (annotation?132
                                                        e1824)
                                                      (annotation-expression
                                                        e1824)
                                                      e1824))
                                                (if (syntax-object?64
                                                      x1823)
                                                    (syntax-object-expression65
                                                      x1823)
                                                    x1823)))
                                             x1820))
                                       (same-marks?415
                                         (wrap-marks318
                                           (syntax-object-wrap66 x1820))
                                         (wrap-marks318 '((top))))
                                       '#f)
                                   (bound-id=?426 x1820 y1819)))))
                        (vfold1784
                         (lambda (v1814 p1813 cls1812)
                           ((lambda (len1815)
                              ((letrec ((lp1816
                                         (lambda (i1818 cls1817)
                                           (if (= i1818 len1815)
                                               cls1817
                                               (lp1816
                                                 (+ i1818 '1)
                                                 (p1813
                                                   (vector-ref v1814 i1818)
                                                   cls1817))))))
                                 lp1816)
                               '0
                               cls1812))
                            (vector-length v1814))))
                        (conflicts1785
                         (lambda (x1805 y1804 cls1803)
                           (if (interface?440 x1805)
                               (if (interface?440 y1804)
                                   (call-with-values
                                     (lambda ()
                                       ((lambda (xe1811 ye1810)
                                          (if (> (vector-length xe1811)
                                                 (vector-length ye1810))
                                              (values x1805 ye1810)
                                              (values y1804 xe1811)))
                                        (interface-exports441 x1805)
                                        (interface-exports441 y1804)))
                                     (lambda (iface1807 exports1806)
                                       (vfold1784
                                         exports1806
                                         (lambda (id1809 cls1808)
                                           (id-iface-conflicts1786
                                             id1809
                                             iface1807
                                             cls1808))
                                         cls1803)))
                                   (id-iface-conflicts1786
                                     y1804
                                     x1805
                                     cls1803))
                               (if (interface?440 y1804)
                                   (id-iface-conflicts1786
                                     x1805
                                     y1804
                                     cls1803)
                                   (if (b-i=?1783 x1805 y1804)
                                       (cons x1805 cls1803)
                                       cls1803)))))
                        (id-iface-conflicts1786
                         (lambda (id1797 iface1796 cls1795)
                           ((lambda (token1798)
                              (if token1798
                                  (if (lookup-import-binding-name405
                                        ((lambda (x1799)
                                           ((lambda (e1800)
                                              (if (annotation?132 e1800)
                                                  (annotation-expression
                                                    e1800)
                                                  e1800))
                                            (if (syntax-object?64 x1799)
                                                (syntax-object-expression65
                                                  x1799)
                                                x1799)))
                                         id1797)
                                        token1798
                                        (if (symbol? id1797)
                                            (wrap-marks318 '((top)))
                                            (wrap-marks318
                                              (syntax-object-wrap66
                                                id1797))))
                                      (cons id1797 cls1795)
                                      cls1795)
                                  (vfold1784
                                    (interface-exports441 iface1796)
                                    (lambda (*id1802 cls1801)
                                      (if (b-i=?1783 *id1802 id1797)
                                          (cons *id1802 cls1801)
                                          cls1801))
                                    cls1795)))
                            (interface-token442 iface1796)))))
                 (if (not (null? ls1781))
                     ((letrec ((lp1787
                                (lambda (x1790 ls1789 cls1788)
                                  (if (null? ls1789)
                                      (if (not (null? cls1788))
                                          ((lambda (cls1791)
                                             (syntax-error
                                               source-exp1782
                                               '"duplicate definition for "
                                               (symbol->string
                                                 (car cls1791))
                                               '" in"))
                                           (syntax-object->datum cls1788))
                                          (void))
                                      ((letrec ((lp21792
                                                 (lambda (ls21794 cls1793)
                                                   (if (null? ls21794)
                                                       (lp1787
                                                         (car ls1789)
                                                         (cdr ls1789)
                                                         cls1793)
                                                       (lp21792
                                                         (cdr ls21794)
                                                         (conflicts1785
                                                           x1790
                                                           (car ls21794)
                                                           cls1793))))))
                                         lp21792)
                                       ls1789
                                       cls1788)))))
                        lp1787)
                      (car ls1781)
                      (cdr ls1781)
                      '())
                     (void)))))
            (chi-external473
             (lambda (ribcage1675
                      source-exp1674
                      body1673
                      r1672
                      mr1671
                      ctem1670
                      exports1669
                      fexports1668
                      meta-residualize!1667)
               (letrec ((return1676
                         (lambda (r1780
                                  mr1779
                                  bindings1778
                                  ids1777
                                  inits1776)
                           (begin (check-defined-ids472
                                    source-exp1674
                                    ids1777)
                                  (check-module-exports471
                                    source-exp1674
                                    fexports1668
                                    ids1777)
                                  (values
                                    r1780
                                    mr1779
                                    bindings1778
                                    inits1776))))
                        (get-implicit-exports1677
                         (lambda (id1773)
                           ((letrec ((f1774
                                      (lambda (exports1775)
                                        (if (null? exports1775)
                                            '()
                                            (if (if (pair?
                                                      (car exports1775))
                                                    (bound-id=?426
                                                      id1773
                                                      (caar exports1775))
                                                    '#f)
                                                (flatten-exports438
                                                  (cdar exports1775))
                                                (f1774
                                                  (cdr exports1775)))))))
                              f1774)
                            exports1669)))
                        (update-imp-exports1678
                         (lambda (bindings1768 exports1767)
                           ((lambda (exports1769)
                              (map (lambda (b1770)
                                     ((lambda (id1771)
                                        (if (not (bound-id-member?430
                                                   id1771
                                                   exports1769))
                                            b1770
                                            (create-module-binding462
                                              (module-binding-type450
                                                b1770)
                                              id1771
                                              (module-binding-label452
                                                b1770)
                                              (append
                                                (get-implicit-exports1677
                                                  id1771)
                                                (module-binding-imps453
                                                  b1770))
                                              (module-binding-val454
                                                b1770))))
                                      (module-binding-id451 b1770)))
                                   bindings1768))
                            (map (lambda (x1772)
                                   (if (pair? x1772) (car x1772) x1772))
                                 exports1767)))))
                 ((letrec ((parse1679
                            (lambda (body1686
                                     r1685
                                     mr1684
                                     ids1683
                                     bindings1682
                                     inits1681
                                     meta-seen?1680)
                              (if (null? body1686)
                                  (return1676
                                    r1685
                                    mr1684
                                    bindings1682
                                    ids1683
                                    inits1681)
                                  ((lambda (fr1687)
                                     ((lambda (e1688)
                                        ((lambda (meta?1689)
                                           ((lambda ()
                                              (call-with-values
                                                (lambda ()
                                                  (syntax-type434
                                                    e1688
                                                    r1685
                                                    '(())
                                                    '#f
                                                    ribcage1675))
                                                (lambda (type1694
                                                         value1693
                                                         e1692
                                                         w1691
                                                         ae1690)
                                                  ((lambda (t1695)
                                                     (if (memv t1695
                                                               '(define-form))
                                                         (call-with-values
                                                           (lambda ()
                                                             (parse-define495
                                                               e1692
                                                               w1691
                                                               ae1690))
                                                           (lambda (id1698
                                                                    rhs1697
                                                                    w1696)
                                                             ((lambda (id1699)
                                                                ((lambda (label1700)
                                                                   ((lambda (sym1701)
                                                                      ((lambda (imps1702)
                                                                         ((lambda ()
                                                                            (begin (extend-ribcage!401
                                                                                     ribcage1675
                                                                                     id1699
                                                                                     label1700)
                                                                                   (if meta?1689
                                                                                       ((lambda (sym1703)
                                                                                          ((lambda (b1704)
                                                                                             ((lambda ()
                                                                                                ((lambda (mr1705)
                                                                                                   ((lambda (exp1706)
                                                                                                      (begin (define-top-level-value-hook135
                                                                                                               sym1703
                                                                                                               (top-level-eval-hook133
                                                                                                                 exp1706))
                                                                                                             (meta-residualize!1667
                                                                                                               (ct-eval/residualize3481
                                                                                                                 ctem1670
                                                                                                                 void
                                                                                                                 (lambda ()
                                                                                                                   (list 'define
                                                                                                                         sym1703
                                                                                                                         exp1706))))
                                                                                                             (parse1679
                                                                                                               (cdr body1686)
                                                                                                               r1685
                                                                                                               mr1705
                                                                                                               (cons id1699
                                                                                                                     ids1683)
                                                                                                               (cons (create-module-binding462
                                                                                                                       'ctdefine-form
                                                                                                                       id1699
                                                                                                                       label1700
                                                                                                                       imps1702
                                                                                                                       b1704)
                                                                                                                     bindings1682)
                                                                                                               inits1681
                                                                                                               '#f)))
                                                                                                    (chi485
                                                                                                      rhs1697
                                                                                                      mr1705
                                                                                                      mr1705
                                                                                                      w1696
                                                                                                      '#t)))
                                                                                                 (extend-env299
                                                                                                   (get-indirect-label353
                                                                                                     label1700)
                                                                                                   b1704
                                                                                                   mr1684)))))
                                                                                           (cons 'meta-variable
                                                                                                 sym1703)))
                                                                                        (generate-id147
                                                                                          ((lambda (x1707)
                                                                                             ((lambda (e1708)
                                                                                                (if (annotation?132
                                                                                                      e1708)
                                                                                                    (annotation-expression
                                                                                                      e1708)
                                                                                                    e1708))
                                                                                              (if (syntax-object?64
                                                                                                    x1707)
                                                                                                  (syntax-object-expression65
                                                                                                    x1707)
                                                                                                  x1707)))
                                                                                           id1699)))
                                                                                       (parse1679
                                                                                         (cdr body1686)
                                                                                         r1685
                                                                                         mr1684
                                                                                         (cons id1699
                                                                                               ids1683)
                                                                                         (cons (create-module-binding462
                                                                                                 type1694
                                                                                                 id1699
                                                                                                 label1700
                                                                                                 imps1702
                                                                                                 (make-frob463
                                                                                                   (wrap431
                                                                                                     rhs1697
                                                                                                     w1696)
                                                                                                   meta?1689))
                                                                                               bindings1682)
                                                                                         inits1681
                                                                                         '#f))))))
                                                                       (get-implicit-exports1677
                                                                         id1699)))
                                                                    (generate-id147
                                                                      ((lambda (x1709)
                                                                         ((lambda (e1710)
                                                                            (if (annotation?132
                                                                                  e1710)
                                                                                (annotation-expression
                                                                                  e1710)
                                                                                e1710))
                                                                          (if (syntax-object?64
                                                                                x1709)
                                                                              (syntax-object-expression65
                                                                                x1709)
                                                                              x1709)))
                                                                       id1699))))
                                                                 (gen-indirect-label352)))
                                                              (wrap431
                                                                id1698
                                                                w1696))))
                                                         (if (memv t1695
                                                                   '(define-syntax-form))
                                                             (call-with-values
                                                               (lambda ()
                                                                 (parse-define-syntax496
                                                                   e1692
                                                                   w1691
                                                                   ae1690))
                                                               (lambda (id1713
                                                                        rhs1712
                                                                        w1711)
                                                                 ((lambda (id1714)
                                                                    ((lambda (label1715)
                                                                       ((lambda (imps1716)
                                                                          ((lambda (exp1717)
                                                                             ((lambda ()
                                                                                (begin (extend-ribcage!401
                                                                                         ribcage1675
                                                                                         id1714
                                                                                         label1715)
                                                                                       ((lambda (l1719
                                                                                                 b1718)
                                                                                          (parse1679
                                                                                            (cdr body1686)
                                                                                            (extend-env299
                                                                                              l1719
                                                                                              b1718
                                                                                              r1685)
                                                                                            (extend-env299
                                                                                              l1719
                                                                                              b1718
                                                                                              mr1684)
                                                                                            (cons id1714
                                                                                                  ids1683)
                                                                                            (cons (create-module-binding462
                                                                                                    type1694
                                                                                                    id1714
                                                                                                    label1715
                                                                                                    imps1716
                                                                                                    (cons b1718
                                                                                                          exp1717))
                                                                                                  bindings1682)
                                                                                            inits1681
                                                                                            '#f))
                                                                                        (get-indirect-label353
                                                                                          label1715)
                                                                                        (defer-or-eval-transformer307
                                                                                          top-level-eval-hook133
                                                                                          exp1717))))))
                                                                           (chi485
                                                                             rhs1712
                                                                             mr1684
                                                                             mr1684
                                                                             w1711
                                                                             '#t)))
                                                                        (get-implicit-exports1677
                                                                          id1714)))
                                                                     (gen-indirect-label352)))
                                                                  (wrap431
                                                                    id1713
                                                                    w1711))))
                                                             (if (memv t1695
                                                                       '($module-form))
                                                                 ((lambda (*ribcage1720)
                                                                    ((lambda (*w1721)
                                                                       ((lambda ()
                                                                          (call-with-values
                                                                            (lambda ()
                                                                              (parse-module493
                                                                                e1692
                                                                                w1691
                                                                                ae1690
                                                                                *w1721))
                                                                            (lambda (orig1725
                                                                                     id1724
                                                                                     *exports1723
                                                                                     forms1722)
                                                                              (call-with-values
                                                                                (lambda ()
                                                                                  (chi-external473
                                                                                    *ribcage1720
                                                                                    orig1725
                                                                                    (map (lambda (d1737)
                                                                                           (make-frob463
                                                                                             d1737
                                                                                             meta?1689))
                                                                                         forms1722)
                                                                                    r1685
                                                                                    mr1684
                                                                                    ctem1670
                                                                                    *exports1723
                                                                                    (flatten-exports438
                                                                                      *exports1723)
                                                                                    meta-residualize!1667))
                                                                                (lambda (r1729
                                                                                         mr1728
                                                                                         *bindings1727
                                                                                         *inits1726)
                                                                                  ((lambda (iface1730)
                                                                                     ((lambda (bindings1731)
                                                                                        ((lambda (inits1732)
                                                                                           ((lambda ()
                                                                                              ((lambda (label1734
                                                                                                        imps1733)
                                                                                                 (begin (extend-ribcage!401
                                                                                                          ribcage1675
                                                                                                          id1724
                                                                                                          label1734)
                                                                                                        ((lambda (l1736
                                                                                                                  b1735)
                                                                                                           (parse1679
                                                                                                             (cdr body1686)
                                                                                                             (extend-env299
                                                                                                               l1736
                                                                                                               b1735
                                                                                                               r1729)
                                                                                                             (extend-env299
                                                                                                               l1736
                                                                                                               b1735
                                                                                                               mr1728)
                                                                                                             (cons id1724
                                                                                                                   ids1683)
                                                                                                             (cons (create-module-binding462
                                                                                                                     type1694
                                                                                                                     id1724
                                                                                                                     label1734
                                                                                                                     imps1733
                                                                                                                     *exports1723)
                                                                                                                   bindings1731)
                                                                                                             inits1732
                                                                                                             '#f))
                                                                                                         (get-indirect-label353
                                                                                                           label1734)
                                                                                                         (cons '$module
                                                                                                               iface1730))))
                                                                                               (gen-indirect-label352)
                                                                                               (get-implicit-exports1677
                                                                                                 id1724)))))
                                                                                         (append
                                                                                           inits1681
                                                                                           *inits1726)))
                                                                                      (append
                                                                                        *bindings1727
                                                                                        bindings1682)))
                                                                                   (make-unresolved-interface445
                                                                                     *exports1723)))))))))
                                                                     (make-wrap317
                                                                       (wrap-marks318
                                                                         w1691)
                                                                       (cons *ribcage1720
                                                                             (wrap-subst319
                                                                               w1691)))))
                                                                  (make-ribcage358
                                                                    '()
                                                                    '()
                                                                    '()))
                                                                 (if (memv t1695
                                                                           '($import-form))
                                                                     (call-with-values
                                                                       (lambda ()
                                                                         (parse-import494
                                                                           e1692
                                                                           w1691
                                                                           ae1690))
                                                                       (lambda (orig1740
                                                                                only?1739
                                                                                mid1738)
                                                                         ((lambda (mlabel1741)
                                                                            ((lambda (binding1742)
                                                                               ((lambda (t1743)
                                                                                  (if (memv t1743
                                                                                            '($module))
                                                                                      ((lambda (iface1744)
                                                                                         (begin (if only?1739
                                                                                                    (extend-ribcage-barrier!402
                                                                                                      ribcage1675
                                                                                                      mid1738)
                                                                                                    (void))
                                                                                                (do-import!492
                                                                                                  iface1744
                                                                                                  ribcage1675)
                                                                                                (parse1679
                                                                                                  (cdr body1686)
                                                                                                  r1685
                                                                                                  mr1684
                                                                                                  (cons iface1744
                                                                                                        ids1683)
                                                                                                  (update-imp-exports1678
                                                                                                    bindings1682
                                                                                                    (vector->list
                                                                                                      (interface-exports441
                                                                                                        iface1744)))
                                                                                                  inits1681
                                                                                                  '#f)))
                                                                                       (binding-value286
                                                                                         binding1742))
                                                                                      (if (memv t1743
                                                                                                '(displaced-lexical))
                                                                                          (displaced-lexical-error303
                                                                                            mid1738)
                                                                                          (syntax-error
                                                                                            mid1738
                                                                                            '"unknown module"))))
                                                                                (binding-type285
                                                                                  binding1742)))
                                                                             (lookup305
                                                                               mlabel1741
                                                                               r1685)))
                                                                          (id-var-name423
                                                                            mid1738
                                                                            '(())))))
                                                                     (if (memv t1695
                                                                               '(alias-form))
                                                                         (call-with-values
                                                                           (lambda ()
                                                                             (parse-alias499
                                                                               e1692
                                                                               w1691
                                                                               ae1690))
                                                                           (lambda (new-id1746
                                                                                    old-id1745)
                                                                             ((lambda (new-id1747)
                                                                                ((lambda (label1748)
                                                                                   ((lambda (imps1749)
                                                                                      ((lambda ()
                                                                                         (begin (extend-ribcage!401
                                                                                                  ribcage1675
                                                                                                  new-id1747
                                                                                                  label1748)
                                                                                                (parse1679
                                                                                                  (cdr body1686)
                                                                                                  r1685
                                                                                                  mr1684
                                                                                                  (cons new-id1747
                                                                                                        ids1683)
                                                                                                  (cons (create-module-binding462
                                                                                                          type1694
                                                                                                          new-id1747
                                                                                                          label1748
                                                                                                          imps1749
                                                                                                          '#f)
                                                                                                        bindings1682)
                                                                                                  inits1681
                                                                                                  '#f)))))
                                                                                    (get-implicit-exports1677
                                                                                      new-id1747)))
                                                                                 (id-var-name-loc422
                                                                                   old-id1745
                                                                                   w1691)))
                                                                              (wrap431
                                                                                new-id1746
                                                                                w1691))))
                                                                         (if (memv t1695
                                                                                   '(begin-form))
                                                                             (parse1679
                                                                               ((letrec ((f1750
                                                                                          (lambda (forms1751)
                                                                                            (if (null?
                                                                                                  forms1751)
                                                                                                (cdr body1686)
                                                                                                (cons (make-frob463
                                                                                                        (wrap431
                                                                                                          (car forms1751)
                                                                                                          w1691)
                                                                                                        meta?1689)
                                                                                                      (f1750
                                                                                                        (cdr forms1751)))))))
                                                                                  f1750)
                                                                                (parse-begin500
                                                                                  e1692
                                                                                  w1691
                                                                                  ae1690
                                                                                  '#t))
                                                                               r1685
                                                                               mr1684
                                                                               ids1683
                                                                               bindings1682
                                                                               inits1681
                                                                               '#f)
                                                                             (if (memv t1695
                                                                                       '(eval-when-form))
                                                                                 (call-with-values
                                                                                   (lambda ()
                                                                                     (parse-eval-when498
                                                                                       e1692
                                                                                       w1691
                                                                                       ae1690))
                                                                                   (lambda (when-list1753
                                                                                            forms1752)
                                                                                     (parse1679
                                                                                       (if (memq 'eval
                                                                                                 when-list1753)
                                                                                           ((letrec ((f1754
                                                                                                      (lambda (forms1755)
                                                                                                        (if (null?
                                                                                                              forms1755)
                                                                                                            (cdr body1686)
                                                                                                            (cons (make-frob463
                                                                                                                    (wrap431
                                                                                                                      (car forms1755)
                                                                                                                      w1691)
                                                                                                                    meta?1689)
                                                                                                                  (f1754
                                                                                                                    (cdr forms1755)))))))
                                                                                              f1754)
                                                                                            forms1752)
                                                                                           (cdr body1686))
                                                                                       r1685
                                                                                       mr1684
                                                                                       ids1683
                                                                                       bindings1682
                                                                                       inits1681
                                                                                       '#f)))
                                                                                 (if (memv t1695
                                                                                           '(meta-form))
                                                                                     (parse1679
                                                                                       (cons (make-frob463
                                                                                               (wrap431
                                                                                                 (parse-meta497
                                                                                                   e1692
                                                                                                   w1691
                                                                                                   ae1690)
                                                                                                 w1691)
                                                                                               '#t)
                                                                                             (cdr body1686))
                                                                                       r1685
                                                                                       mr1684
                                                                                       ids1683
                                                                                       bindings1682
                                                                                       inits1681
                                                                                       '#t)
                                                                                     (if (memv t1695
                                                                                               '(local-syntax-form))
                                                                                         (call-with-values
                                                                                           (lambda ()
                                                                                             (chi-local-syntax502
                                                                                               value1693
                                                                                               e1692
                                                                                               r1685
                                                                                               mr1684
                                                                                               w1691
                                                                                               ae1690))
                                                                                           (lambda (forms1760
                                                                                                    r1759
                                                                                                    mr1758
                                                                                                    w1757
                                                                                                    ae1756)
                                                                                             (parse1679
                                                                                               ((letrec ((f1761
                                                                                                          (lambda (forms1762)
                                                                                                            (if (null?
                                                                                                                  forms1762)
                                                                                                                (cdr body1686)
                                                                                                                (cons (make-frob463
                                                                                                                        (wrap431
                                                                                                                          (car forms1762)
                                                                                                                          w1757)
                                                                                                                        meta?1689)
                                                                                                                      (f1761
                                                                                                                        (cdr forms1762)))))))
                                                                                                  f1761)
                                                                                                forms1760)
                                                                                               r1759
                                                                                               mr1758
                                                                                               ids1683
                                                                                               bindings1682
                                                                                               inits1681
                                                                                               '#f)))
                                                                                         (begin (if meta-seen?1680
                                                                                                    (syntax-error
                                                                                                      (source-wrap432
                                                                                                        e1692
                                                                                                        w1691
                                                                                                        ae1690)
                                                                                                      '"invalid meta definition")
                                                                                                    (void))
                                                                                                ((letrec ((f1763
                                                                                                           (lambda (body1764)
                                                                                                             (if ((lambda (t1765)
                                                                                                                    (if t1765
                                                                                                                        t1765
                                                                                                                        (not (frob-meta?466
                                                                                                                               (car body1764)))))
                                                                                                                  (null?
                                                                                                                    body1764))
                                                                                                                 (return1676
                                                                                                                   r1685
                                                                                                                   mr1684
                                                                                                                   bindings1682
                                                                                                                   ids1683
                                                                                                                   (append
                                                                                                                     inits1681
                                                                                                                     body1764))
                                                                                                                 (begin ((lambda (x1766)
                                                                                                                           (begin (top-level-eval-hook133
                                                                                                                                    x1766)
                                                                                                                                  (meta-residualize!1667
                                                                                                                                    (ct-eval/residualize3481
                                                                                                                                      ctem1670
                                                                                                                                      void
                                                                                                                                      (lambda ()
                                                                                                                                        x1766)))))
                                                                                                                         (chi-meta-frob483
                                                                                                                           (car body1764)
                                                                                                                           mr1684))
                                                                                                                        (f1763
                                                                                                                          (cdr body1764)))))))
                                                                                                   f1763)
                                                                                                 (cons (make-frob463
                                                                                                         (source-wrap432
                                                                                                           e1692
                                                                                                           w1691
                                                                                                           ae1690)
                                                                                                         meta?1689)
                                                                                                       (cdr body1686))))))))))))))
                                                   type1694))))))
                                         (frob-meta?466 fr1687)))
                                      (frob-e465 fr1687)))
                                   (car body1686))))))
                    parse1679)
                  body1673
                  r1672
                  mr1671
                  '()
                  '()
                  '()
                  '#f))))
            (vmap474
             (lambda (fn1663 v1662)
               ((letrec ((do1664
                          (lambda (i1666 ls1665)
                            (if (< i1666 '0)
                                ls1665
                                (do1664
                                  (- i1666 '1)
                                  (cons (fn1663 (vector-ref v1662 i1666))
                                        ls1665))))))
                  do1664)
                (- (vector-length v1662) '1)
                '())))
            (vfor-each475
             (lambda (fn1658 v1657)
               ((lambda (len1659)
                  ((letrec ((do1660
                             (lambda (i1661)
                               (if (not (= i1661 len1659))
                                   (begin (fn1658 (vector-ref v1657 i1661))
                                          (do1660 (+ i1661 '1)))
                                   (void)))))
                     do1660)
                   '0))
                (vector-length v1657))))
            (do-top-import476
             (lambda (import-only?1656 top-ribcage1655 mid1654 token1653)
               (list '$sc-put-cte
                     (list 'quote mid1654)
                     (list 'quote
                           (cons 'do-import
                                 (cons import-only?1656 token1653)))
                     (list 'quote (top-ribcage-key368 top-ribcage1655)))))
            (update-mode-set477
             ((lambda (table1647)
                (lambda (when-list1649 mode-set1648)
                  (remq '-
                        (apply
                          append
                          (map (lambda (m1650)
                                 ((lambda (row1651)
                                    (map (lambda (s1652)
                                           (cdr (assq s1652 row1651)))
                                         when-list1649))
                                  (cdr (assq m1650 table1647))))
                               mode-set1648)))))
              '((l (load . l)
                   (compile . c)
                   (visit . v)
                   (revisit . r)
                   (eval . -))
                (c (load . -)
                   (compile . -)
                   (visit . -)
                   (revisit . -)
                   (eval . c))
                (v (load . v)
                   (compile . c)
                   (visit . v)
                   (revisit . -)
                   (eval . -))
                (r (load . r)
                   (compile . c)
                   (visit . -)
                   (revisit . r)
                   (eval . -))
                (e (load . -)
                   (compile . -)
                   (visit . -)
                   (revisit . -)
                   (eval . e)))))
            (initial-mode-set478
             (lambda (when-list1643 compiling-a-file1642)
               (apply
                 append
                 (map (lambda (s1644)
                        (if compiling-a-file1642
                            ((lambda (t1645)
                               (if (memv t1645 '(compile))
                                   '(c)
                                   (if (memv t1645 '(load))
                                       '(l)
                                       (if (memv t1645 '(visit))
                                           '(v)
                                           (if (memv t1645 '(revisit))
                                               '(r)
                                               '())))))
                             s1644)
                            ((lambda (t1646)
                               (if (memv t1646 '(eval)) '(e) '()))
                             s1644)))
                      when-list1643))))
            (rt-eval/residualize479
             (lambda (rtem1637 thunk1636)
               (if (memq 'e rtem1637)
                   (thunk1636)
                   ((lambda (thunk1638)
                      (if (memq 'v rtem1637)
                          (if ((lambda (t1639)
                                 (if t1639 t1639 (memq 'r rtem1637)))
                               (memq 'l rtem1637))
                              (thunk1638)
                              (thunk1638))
                          (if ((lambda (t1640)
                                 (if t1640 t1640 (memq 'r rtem1637)))
                               (memq 'l rtem1637))
                              (thunk1638)
                              (chi-void503))))
                    (if (memq 'c rtem1637)
                        ((lambda (x1641)
                           (begin (top-level-eval-hook133 x1641)
                                  (lambda () x1641)))
                         (thunk1636))
                        thunk1636)))))
            (ct-eval/residualize2480
             (lambda (ctem1633 thunk1632)
               ((lambda (t1634)
                  (ct-eval/residualize3481
                    ctem1633
                    (lambda ()
                      (begin (if (not t1634)
                                 (set! t1634 (thunk1632))
                                 (void))
                             (top-level-eval-hook133 t1634)))
                    (lambda ()
                      ((lambda (t1635) (if t1635 t1635 (thunk1632)))
                       t1634))))
                '#f)))
            (ct-eval/residualize3481
             (lambda (ctem1629 eval-thunk1628 residualize-thunk1627)
               (if (memq 'e ctem1629)
                   (begin (eval-thunk1628) (chi-void503))
                   (begin (if (memq 'c ctem1629) (eval-thunk1628) (void))
                          (if (memq 'r ctem1629)
                              (if ((lambda (t1630)
                                     (if t1630 t1630 (memq 'v ctem1629)))
                                   (memq 'l ctem1629))
                                  (residualize-thunk1627)
                                  (residualize-thunk1627))
                              (if ((lambda (t1631)
                                     (if t1631 t1631 (memq 'v ctem1629)))
                                   (memq 'l ctem1629))
                                  (residualize-thunk1627)
                                  (chi-void503)))))))
            (chi-frobs482
             (lambda (frob*1625 r1624 mr1623 m?1622)
               (map (lambda (x1626)
                      (chi485 (frob-e465 x1626) r1624 mr1623 '(()) m?1622))
                    frob*1625)))
            (chi-meta-frob483
             (lambda (x1621 mr1620)
               (chi485 (frob-e465 x1621) mr1620 mr1620 '(()) '#t)))
            (chi-sequence484
             (lambda (body1616 r1615 mr1614 w1613 ae1612 m?1611)
               (build-sequence239
                 ae1612
                 ((letrec ((dobody1617
                            (lambda (body1618)
                              (if (null? body1618)
                                  '()
                                  ((lambda (first1619)
                                     (cons first1619
                                           (dobody1617 (cdr body1618))))
                                   (chi485
                                     (car body1618)
                                     r1615
                                     mr1614
                                     w1613
                                     m?1611))))))
                    dobody1617)
                  body1616))))
            (chi485
             (lambda (e1605 r1604 mr1603 w1602 m?1601)
               (call-with-values
                 (lambda () (syntax-type434 e1605 r1604 w1602 '#f '#f))
                 (lambda (type1610 value1609 e1608 w1607 ae1606)
                   (chi-expr486
                     type1610
                     value1609
                     e1608
                     r1604
                     mr1603
                     w1607
                     ae1606
                     m?1601)))))
            (chi-expr486
             (lambda (type1585
                      value1584
                      e1583
                      r1582
                      mr1581
                      w1580
                      ae1579
                      m?1578)
               ((lambda (t1586)
                  (if (memv t1586 '(lexical))
                      value1584
                      (if (memv t1586 '(core))
                          (value1584
                            e1583
                            r1582
                            mr1581
                            w1580
                            ae1579
                            m?1578)
                          (if (memv t1586 '(lexical-call))
                              (chi-application487
                                value1584
                                e1583
                                r1582
                                mr1581
                                w1580
                                ae1579
                                m?1578)
                              (if (memv t1586 '(constant))
                                  (list 'quote
                                        (strip507
                                          (source-wrap432
                                            e1583
                                            w1580
                                            ae1579)
                                          '(())))
                                  (if (memv t1586 '(global))
                                      value1584
                                      (if (memv t1586 '(meta-variable))
                                          (if m?1578
                                              value1584
                                              (displaced-lexical-error303
                                                (source-wrap432
                                                  e1583
                                                  w1580
                                                  ae1579)))
                                          (if (memv t1586 '(call))
                                              (chi-application487
                                                (chi485
                                                  (car e1583)
                                                  r1582
                                                  mr1581
                                                  w1580
                                                  m?1578)
                                                e1583
                                                r1582
                                                mr1581
                                                w1580
                                                ae1579
                                                m?1578)
                                              (if (memv t1586
                                                        '(begin-form))
                                                  (chi-sequence484
                                                    (parse-begin500
                                                      e1583
                                                      w1580
                                                      ae1579
                                                      '#f)
                                                    r1582
                                                    mr1581
                                                    w1580
                                                    ae1579
                                                    m?1578)
                                                  (if (memv t1586
                                                            '(local-syntax-form))
                                                      (call-with-values
                                                        (lambda ()
                                                          (chi-local-syntax502
                                                            value1584
                                                            e1583
                                                            r1582
                                                            mr1581
                                                            w1580
                                                            ae1579))
                                                        (lambda (forms1591
                                                                 r1590
                                                                 mr1589
                                                                 w1588
                                                                 ae1587)
                                                          (chi-sequence484
                                                            forms1591
                                                            r1590
                                                            mr1589
                                                            w1588
                                                            ae1587
                                                            m?1578)))
                                                      (if (memv t1586
                                                                '(eval-when-form))
                                                          (call-with-values
                                                            (lambda ()
                                                              (parse-eval-when498
                                                                e1583
                                                                w1580
                                                                ae1579))
                                                            (lambda (when-list1593
                                                                     forms1592)
                                                              (if (memq 'eval
                                                                        when-list1593)
                                                                  (chi-sequence484
                                                                    forms1592
                                                                    r1582
                                                                    mr1581
                                                                    w1580
                                                                    ae1579
                                                                    m?1578)
                                                                  (chi-void503))))
                                                          (if (memv t1586
                                                                    '(meta-form))
                                                              (syntax-error
                                                                (source-wrap432
                                                                  e1583
                                                                  w1580
                                                                  ae1579)
                                                                '"invalid context for meta definition")
                                                              (if (memv t1586
                                                                        '(define-form))
                                                                  (begin (parse-define495
                                                                           e1583
                                                                           w1580
                                                                           ae1579)
                                                                         (syntax-error
                                                                           (source-wrap432
                                                                             e1583
                                                                             w1580
                                                                             ae1579)
                                                                           '"invalid context for definition"))
                                                                  (if (memv t1586
                                                                            '(define-syntax-form))
                                                                      (begin (parse-define-syntax496
                                                                               e1583
                                                                               w1580
                                                                               ae1579)
                                                                             (syntax-error
                                                                               (source-wrap432
                                                                                 e1583
                                                                                 w1580
                                                                                 ae1579)
                                                                               '"invalid context for definition"))
                                                                      (if (memv t1586
                                                                                '($module-form))
                                                                          (call-with-values
                                                                            (lambda ()
                                                                              (parse-module493
                                                                                e1583
                                                                                w1580
                                                                                ae1579
                                                                                w1580))
                                                                            (lambda (orig1597
                                                                                     id1596
                                                                                     exports1595
                                                                                     forms1594)
                                                                              (syntax-error
                                                                                orig1597
                                                                                '"invalid context for definition")))
                                                                          (if (memv t1586
                                                                                    '($import-form))
                                                                              (call-with-values
                                                                                (lambda ()
                                                                                  (parse-import494
                                                                                    e1583
                                                                                    w1580
                                                                                    ae1579))
                                                                                (lambda (orig1600
                                                                                         only?1599
                                                                                         mid1598)
                                                                                  (syntax-error
                                                                                    orig1600
                                                                                    '"invalid context for definition")))
                                                                              (if (memv t1586
                                                                                        '(alias-form))
                                                                                  (begin (parse-alias499
                                                                                           e1583
                                                                                           w1580
                                                                                           ae1579)
                                                                                         (syntax-error
                                                                                           (source-wrap432
                                                                                             e1583
                                                                                             w1580
                                                                                             ae1579)
                                                                                           '"invalid context for definition"))
                                                                                  (if (memv t1586
                                                                                            '(syntax))
                                                                                      (syntax-error
                                                                                        (source-wrap432
                                                                                          e1583
                                                                                          w1580
                                                                                          ae1579)
                                                                                        '"reference to pattern variable outside syntax form")
                                                                                      (if (memv t1586
                                                                                                '(displaced-lexical))
                                                                                          (displaced-lexical-error303
                                                                                            (source-wrap432
                                                                                              e1583
                                                                                              w1580
                                                                                              ae1579))
                                                                                          (syntax-error
                                                                                            (source-wrap432
                                                                                              e1583
                                                                                              w1580
                                                                                              ae1579)))))))))))))))))))))
                type1585)))
            (chi-application487
             (lambda (x1570 e1569 r1568 mr1567 w1566 ae1565 m?1564)
               ((lambda (tmp1571)
                  ((lambda (tmp1572)
                     (if tmp1572
                         (apply
                           (lambda (e01574 e11573)
                             (cons x1570
                                   (map (lambda (e1576)
                                          (chi485
                                            e1576
                                            r1568
                                            mr1567
                                            w1566
                                            m?1564))
                                        e11573)))
                           tmp1572)
                         ((lambda (_1577)
                            (syntax-error
                              (source-wrap432 e1569 w1566 ae1565)))
                          tmp1571)))
                   ($syntax-dispatch tmp1571 '(any . each-any))))
                e1569)))
            (chi-set!488
             (lambda (e1538 r1537 w1536 ae1535 rib1534)
               ((lambda (tmp1539)
                  ((lambda (tmp1540)
                     (if (if tmp1540
                             (apply
                               (lambda (_1543 id1542 val1541)
                                 (id?310 id1542))
                               tmp1540)
                             '#f)
                         (apply
                           (lambda (_1546 id1545 val1544)
                             ((lambda (n1547)
                                ((lambda (b1548)
                                   ((lambda (t1549)
                                      (if (memv t1549 '(macro!))
                                          ((lambda (id1551 val1550)
                                             (syntax-type434
                                               (chi-macro489
                                                 (binding-value286 b1548)
                                                 (list '#(syntax-object set! ((top) #(ribcage () () ()) #(ribcage #(id val) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(t) #(("m" top)) #("i")) #(ribcage () () ()) #(ribcage #(b) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(n) #((top)) #("i")) #(ribcage #(_ id val) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(e r w ae rib) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                       id1551
                                                       val1550)
                                                 r1537
                                                 '(())
                                                 '#f
                                                 rib1534)
                                               r1537
                                               '(())
                                               '#f
                                               rib1534))
                                           (wrap431 id1545 w1536)
                                           (wrap431 val1544 w1536))
                                          (values
                                            'core
                                            (lambda (e1557
                                                     r1556
                                                     mr1555
                                                     w1554
                                                     ae1553
                                                     m?1552)
                                              ((lambda (val1559 n1558)
                                                 ((lambda (b1560)
                                                    ((lambda (t1561)
                                                       (if (memv t1561
                                                                 '(lexical))
                                                           (list 'set!
                                                                 (binding-value286
                                                                   b1560)
                                                                 val1559)
                                                           (if (memv t1561
                                                                     '(global))
                                                               ((lambda (sym1562)
                                                                  (begin (if (read-only-binding?144
                                                                               n1558)
                                                                             (syntax-error
                                                                               (source-wrap432
                                                                                 e1557
                                                                                 w1554
                                                                                 ae1553)
                                                                               '"invalid assignment to read-only variable")
                                                                             (void))
                                                                         (list 'set!
                                                                               sym1562
                                                                               val1559)))
                                                                (binding-value286
                                                                  b1560))
                                                               (if (memv t1561
                                                                         '(meta-variable))
                                                                   (if m?1552
                                                                       (list 'set!
                                                                             (binding-value286
                                                                               b1560)
                                                                             val1559)
                                                                       (displaced-lexical-error303
                                                                         (wrap431
                                                                           id1545
                                                                           w1554)))
                                                                   (if (memv t1561
                                                                             '(displaced-lexical))
                                                                       (displaced-lexical-error303
                                                                         (wrap431
                                                                           id1545
                                                                           w1554))
                                                                       (syntax-error
                                                                         (source-wrap432
                                                                           e1557
                                                                           w1554
                                                                           ae1553)))))))
                                                     (binding-type285
                                                       b1560)))
                                                  (lookup305 n1558 r1556)))
                                               (chi485
                                                 val1544
                                                 r1556
                                                 mr1555
                                                 w1554
                                                 m?1552)
                                               (id-var-name423
                                                 id1545
                                                 w1554)))
                                            e1538
                                            w1536
                                            ae1535)))
                                    (binding-type285 b1548)))
                                 (lookup305 n1547 r1537)))
                              (id-var-name423 id1545 w1536)))
                           tmp1540)
                         ((lambda (_1563)
                            (syntax-error
                              (source-wrap432 e1538 w1536 ae1535)))
                          tmp1539)))
                   ($syntax-dispatch tmp1539 '(any any any))))
                e1538)))
            (chi-macro489
             (lambda (p1521 e1520 r1519 w1518 ae1517 rib1516)
               (letrec ((rebuild-macro-output1522
                         (lambda (x1526 m1525)
                           (if (pair? x1526)
                               (cons (rebuild-macro-output1522
                                       (car x1526)
                                       m1525)
                                     (rebuild-macro-output1522
                                       (cdr x1526)
                                       m1525))
                               (if (syntax-object?64 x1526)
                                   ((lambda (w1527)
                                      ((lambda (ms1529 s1528)
                                         (make-syntax-object63
                                           (syntax-object-expression65
                                             x1526)
                                           (if (if (pair? ms1529)
                                                   (eq? (car ms1529) '#f)
                                                   '#f)
                                               (make-wrap317
                                                 (cdr ms1529)
                                                 (cdr s1528))
                                               (make-wrap317
                                                 (cons m1525 ms1529)
                                                 (if rib1516
                                                     (cons rib1516
                                                           (cons 'shift
                                                                 s1528))
                                                     (cons 'shift
                                                           s1528))))))
                                       (wrap-marks318 w1527)
                                       (wrap-subst319 w1527)))
                                    (syntax-object-wrap66 x1526))
                                   (if (vector? x1526)
                                       ((lambda (n1530)
                                          ((lambda (v1531)
                                             ((lambda ()
                                                ((letrec ((do1532
                                                           (lambda (i1533)
                                                             (if (= i1533
                                                                    n1530)
                                                                 v1531
                                                                 (begin (vector-set!
                                                                          v1531
                                                                          i1533
                                                                          (rebuild-macro-output1522
                                                                            (vector-ref
                                                                              x1526
                                                                              i1533)
                                                                            m1525))
                                                                        (do1532
                                                                          (+ i1533
                                                                             '1)))))))
                                                   do1532)
                                                 '0))))
                                           (make-vector n1530)))
                                        (vector-length x1526))
                                       (if (symbol? x1526)
                                           (syntax-error
                                             (source-wrap432
                                               e1520
                                               w1518
                                               ae1517)
                                             '"encountered raw symbol "
                                             (format '"~s" x1526)
                                             '" in output of macro")
                                           x1526)))))))
                 (rebuild-macro-output1522
                   ((lambda (out1523)
                      (if (procedure? out1523)
                          (out1523
                            (lambda (id1524)
                              (begin (if (not (identifier? id1524))
                                         (syntax-error
                                           id1524
                                           '"environment argument is not an identifier")
                                         (void))
                                     (lookup305
                                       (id-var-name423 id1524 '(()))
                                       r1519))))
                          out1523))
                    (p1521
                      (source-wrap432 e1520 (anti-mark391 w1518) ae1517)))
                   (string '#\m)))))
            (chi-body490
             (lambda (body1504 outer-form1503 r1502 mr1501 w1500 m?1499)
               ((lambda (ribcage1505)
                  ((lambda (w1506)
                     ((lambda (body1507)
                        ((lambda ()
                           (call-with-values
                             (lambda ()
                               (chi-internal491
                                 ribcage1505
                                 outer-form1503
                                 body1507
                                 r1502
                                 mr1501
                                 m?1499))
                             (lambda (r1514
                                      mr1513
                                      exprs1512
                                      ids1511
                                      vars1510
                                      vals1509
                                      inits1508)
                               (begin (if (null? exprs1512)
                                          (syntax-error
                                            outer-form1503
                                            '"no expressions in body")
                                          (void))
                                      (build-body241
                                        '#f
                                        (reverse vars1510)
                                        (chi-frobs482
                                          (reverse vals1509)
                                          r1514
                                          mr1513
                                          m?1499)
                                        (build-sequence239
                                          '#f
                                          (chi-frobs482
                                            (append inits1508 exprs1512)
                                            r1514
                                            mr1513
                                            m?1499)))))))))
                      (map (lambda (x1515)
                             (make-frob463 (wrap431 x1515 w1506) '#f))
                           body1504)))
                   (make-wrap317
                     (wrap-marks318 w1500)
                     (cons ribcage1505 (wrap-subst319 w1500)))))
                (make-ribcage358 '() '() '()))))
            (chi-internal491
             (lambda (ribcage1409
                      source-exp1408
                      body1407
                      r1406
                      mr1405
                      m?1404)
               (letrec ((return1410
                         (lambda (r1498
                                  mr1497
                                  exprs1496
                                  ids1495
                                  vars1494
                                  vals1493
                                  inits1492)
                           (begin (check-defined-ids472
                                    source-exp1408
                                    ids1495)
                                  (values
                                    r1498
                                    mr1497
                                    exprs1496
                                    ids1495
                                    vars1494
                                    vals1493
                                    inits1492)))))
                 ((letrec ((parse1411
                            (lambda (body1419
                                     r1418
                                     mr1417
                                     ids1416
                                     vars1415
                                     vals1414
                                     inits1413
                                     meta-seen?1412)
                              (if (null? body1419)
                                  (return1410
                                    r1418
                                    mr1417
                                    body1419
                                    ids1416
                                    vars1415
                                    vals1414
                                    inits1413)
                                  ((lambda (fr1420)
                                     ((lambda (e1421)
                                        ((lambda (meta?1422)
                                           ((lambda ()
                                              (call-with-values
                                                (lambda ()
                                                  (syntax-type434
                                                    e1421
                                                    r1418
                                                    '(())
                                                    '#f
                                                    ribcage1409))
                                                (lambda (type1427
                                                         value1426
                                                         e1425
                                                         w1424
                                                         ae1423)
                                                  ((lambda (t1428)
                                                     (if (memv t1428
                                                               '(define-form))
                                                         (call-with-values
                                                           (lambda ()
                                                             (parse-define495
                                                               e1425
                                                               w1424
                                                               ae1423))
                                                           (lambda (id1431
                                                                    rhs1430
                                                                    w1429)
                                                             ((lambda (id1433
                                                                       label1432)
                                                                (if meta?1422
                                                                    ((lambda (sym1434)
                                                                       (begin (extend-ribcage!401
                                                                                ribcage1409
                                                                                id1433
                                                                                label1432)
                                                                              ((lambda (mr1435)
                                                                                 (begin (define-top-level-value-hook135
                                                                                          sym1434
                                                                                          (top-level-eval-hook133
                                                                                            (chi485
                                                                                              rhs1430
                                                                                              mr1435
                                                                                              mr1435
                                                                                              w1429
                                                                                              '#t)))
                                                                                        (parse1411
                                                                                          (cdr body1419)
                                                                                          r1418
                                                                                          mr1435
                                                                                          (cons id1433
                                                                                                ids1416)
                                                                                          vars1415
                                                                                          vals1414
                                                                                          inits1413
                                                                                          '#f)))
                                                                               (extend-env299
                                                                                 label1432
                                                                                 (cons 'meta-variable
                                                                                       sym1434)
                                                                                 mr1417))))
                                                                     (generate-id147
                                                                       ((lambda (x1436)
                                                                          ((lambda (e1437)
                                                                             (if (annotation?132
                                                                                   e1437)
                                                                                 (annotation-expression
                                                                                   e1437)
                                                                                 e1437))
                                                                           (if (syntax-object?64
                                                                                 x1436)
                                                                               (syntax-object-expression65
                                                                                 x1436)
                                                                               x1436)))
                                                                        id1433)))
                                                                    ((lambda (var1438)
                                                                       (begin (extend-ribcage!401
                                                                                ribcage1409
                                                                                id1433
                                                                                label1432)
                                                                              (parse1411
                                                                                (cdr body1419)
                                                                                (extend-env299
                                                                                  label1432
                                                                                  (cons 'lexical
                                                                                        var1438)
                                                                                  r1418)
                                                                                mr1417
                                                                                (cons id1433
                                                                                      ids1416)
                                                                                (cons var1438
                                                                                      vars1415)
                                                                                (cons (make-frob463
                                                                                        (wrap431
                                                                                          rhs1430
                                                                                          w1429)
                                                                                        meta?1422)
                                                                                      vals1414)
                                                                                inits1413
                                                                                '#f)))
                                                                     (gen-var508
                                                                       id1433))))
                                                              (wrap431
                                                                id1431
                                                                w1429)
                                                              (gen-label355))))
                                                         (if (memv t1428
                                                                   '(define-syntax-form))
                                                             (call-with-values
                                                               (lambda ()
                                                                 (parse-define-syntax496
                                                                   e1425
                                                                   w1424
                                                                   ae1423))
                                                               (lambda (id1441
                                                                        rhs1440
                                                                        w1439)
                                                                 ((lambda (id1444
                                                                           label1443
                                                                           exp1442)
                                                                    (begin (extend-ribcage!401
                                                                             ribcage1409
                                                                             id1444
                                                                             label1443)
                                                                           ((lambda (b1445)
                                                                              (parse1411
                                                                                (cdr body1419)
                                                                                (extend-env299
                                                                                  label1443
                                                                                  b1445
                                                                                  r1418)
                                                                                (extend-env299
                                                                                  label1443
                                                                                  b1445
                                                                                  mr1417)
                                                                                (cons id1444
                                                                                      ids1416)
                                                                                vars1415
                                                                                vals1414
                                                                                inits1413
                                                                                '#f))
                                                                            (defer-or-eval-transformer307
                                                                              local-eval-hook134
                                                                              exp1442))))
                                                                  (wrap431
                                                                    id1441
                                                                    w1439)
                                                                  (gen-label355)
                                                                  (chi485
                                                                    rhs1440
                                                                    mr1417
                                                                    mr1417
                                                                    w1439
                                                                    '#t))))
                                                             (if (memv t1428
                                                                       '($module-form))
                                                                 ((lambda (*ribcage1446)
                                                                    ((lambda (*w1447)
                                                                       ((lambda ()
                                                                          (call-with-values
                                                                            (lambda ()
                                                                              (parse-module493
                                                                                e1425
                                                                                w1424
                                                                                ae1423
                                                                                *w1447))
                                                                            (lambda (orig1451
                                                                                     id1450
                                                                                     exports1449
                                                                                     forms1448)
                                                                              (call-with-values
                                                                                (lambda ()
                                                                                  (chi-internal491
                                                                                    *ribcage1446
                                                                                    orig1451
                                                                                    (map (lambda (d1465)
                                                                                           (make-frob463
                                                                                             d1465
                                                                                             meta?1422))
                                                                                         forms1448)
                                                                                    r1418
                                                                                    mr1417
                                                                                    m?1404))
                                                                                (lambda (r1458
                                                                                         mr1457
                                                                                         *body1456
                                                                                         *ids1455
                                                                                         *vars1454
                                                                                         *vals1453
                                                                                         *inits1452)
                                                                                  (begin (check-module-exports471
                                                                                           source-exp1408
                                                                                           (flatten-exports438
                                                                                             exports1449)
                                                                                           *ids1455)
                                                                                         ((lambda (iface1462
                                                                                                   vars1461
                                                                                                   vals1460
                                                                                                   inits1459)
                                                                                            ((lambda (label1463)
                                                                                               (begin (extend-ribcage!401
                                                                                                        ribcage1409
                                                                                                        id1450
                                                                                                        label1463)
                                                                                                      ((lambda (b1464)
                                                                                                         (parse1411
                                                                                                           (cdr body1419)
                                                                                                           (extend-env299
                                                                                                             label1463
                                                                                                             b1464
                                                                                                             r1458)
                                                                                                           (extend-env299
                                                                                                             label1463
                                                                                                             b1464
                                                                                                             mr1457)
                                                                                                           (cons id1450
                                                                                                                 ids1416)
                                                                                                           vars1461
                                                                                                           vals1460
                                                                                                           inits1459
                                                                                                           '#f))
                                                                                                       (cons '$module
                                                                                                             iface1462))))
                                                                                             (gen-label355)))
                                                                                          (make-resolved-interface1446
                                                                                            exports1449)
                                                                                          (append
                                                                                            *vars1454
                                                                                            vars1415)
                                                                                          (append
                                                                                            *vals1453
                                                                                            vals1414)
                                                                                          (append
                                                                                            inits1413
                                                                                            *inits1452
                                                                                            *body1456))))))))))
                                                                     (make-wrap317
                                                                       (wrap-marks318
                                                                         w1424)
                                                                       (cons *ribcage1446
                                                                             (wrap-subst319
                                                                               w1424)))))
                                                                  (make-ribcage358
                                                                    '()
                                                                    '()
                                                                    '()))
                                                                 (if (memv t1428
                                                                           '($import-form))
                                                                     (call-with-values
                                                                       (lambda ()
                                                                         (parse-import494
                                                                           e1425
                                                                           w1424
                                                                           ae1423))
                                                                       (lambda (orig1468
                                                                                only?1467
                                                                                mid1466)
                                                                         ((lambda (mlabel1469)
                                                                            ((lambda (binding1470)
                                                                               ((lambda (t1471)
                                                                                  (if (memv t1471
                                                                                            '($module))
                                                                                      ((lambda (iface1472)
                                                                                         (begin (if only?1467
                                                                                                    (extend-ribcage-barrier!402
                                                                                                      ribcage1409
                                                                                                      mid1466)
                                                                                                    (void))
                                                                                                (do-import!492
                                                                                                  iface1472
                                                                                                  ribcage1409)
                                                                                                (parse1411
                                                                                                  (cdr body1419)
                                                                                                  r1418
                                                                                                  mr1417
                                                                                                  (cons iface1472
                                                                                                        ids1416)
                                                                                                  vars1415
                                                                                                  vals1414
                                                                                                  inits1413
                                                                                                  '#f)))
                                                                                       (cdr binding1470))
                                                                                      (if (memv t1471
                                                                                                '(displaced-lexical))
                                                                                          (displaced-lexical-error303
                                                                                            mid1466)
                                                                                          (syntax-error
                                                                                            mid1466
                                                                                            '"unknown module"))))
                                                                                (car binding1470)))
                                                                             (lookup305
                                                                               mlabel1469
                                                                               r1418)))
                                                                          (id-var-name423
                                                                            mid1466
                                                                            '(())))))
                                                                     (if (memv t1428
                                                                               '(alias-form))
                                                                         (call-with-values
                                                                           (lambda ()
                                                                             (parse-alias499
                                                                               e1425
                                                                               w1424
                                                                               ae1423))
                                                                           (lambda (new-id1474
                                                                                    old-id1473)
                                                                             ((lambda (new-id1475)
                                                                                (begin (extend-ribcage!401
                                                                                         ribcage1409
                                                                                         new-id1475
                                                                                         (id-var-name-loc422
                                                                                           old-id1473
                                                                                           w1424))
                                                                                       (parse1411
                                                                                         (cdr body1419)
                                                                                         r1418
                                                                                         mr1417
                                                                                         (cons new-id1475
                                                                                               ids1416)
                                                                                         vars1415
                                                                                         vals1414
                                                                                         inits1413
                                                                                         '#f)))
                                                                              (wrap431
                                                                                new-id1474
                                                                                w1424))))
                                                                         (if (memv t1428
                                                                                   '(begin-form))
                                                                             (parse1411
                                                                               ((letrec ((f1476
                                                                                          (lambda (forms1477)
                                                                                            (if (null?
                                                                                                  forms1477)
                                                                                                (cdr body1419)
                                                                                                (cons (make-frob463
                                                                                                        (wrap431
                                                                                                          (car forms1477)
                                                                                                          w1424)
                                                                                                        meta?1422)
                                                                                                      (f1476
                                                                                                        (cdr forms1477)))))))
                                                                                  f1476)
                                                                                (parse-begin500
                                                                                  e1425
                                                                                  w1424
                                                                                  ae1423
                                                                                  '#t))
                                                                               r1418
                                                                               mr1417
                                                                               ids1416
                                                                               vars1415
                                                                               vals1414
                                                                               inits1413
                                                                               '#f)
                                                                             (if (memv t1428
                                                                                       '(eval-when-form))
                                                                                 (call-with-values
                                                                                   (lambda ()
                                                                                     (parse-eval-when498
                                                                                       e1425
                                                                                       w1424
                                                                                       ae1423))
                                                                                   (lambda (when-list1479
                                                                                            forms1478)
                                                                                     (parse1411
                                                                                       (if (memq 'eval
                                                                                                 when-list1479)
                                                                                           ((letrec ((f1480
                                                                                                      (lambda (forms1481)
                                                                                                        (if (null?
                                                                                                              forms1481)
                                                                                                            (cdr body1419)
                                                                                                            (cons (make-frob463
                                                                                                                    (wrap431
                                                                                                                      (car forms1481)
                                                                                                                      w1424)
                                                                                                                    meta?1422)
                                                                                                                  (f1480
                                                                                                                    (cdr forms1481)))))))
                                                                                              f1480)
                                                                                            forms1478)
                                                                                           (cdr body1419))
                                                                                       r1418
                                                                                       mr1417
                                                                                       ids1416
                                                                                       vars1415
                                                                                       vals1414
                                                                                       inits1413
                                                                                       '#f)))
                                                                                 (if (memv t1428
                                                                                           '(meta-form))
                                                                                     (parse1411
                                                                                       (cons (make-frob463
                                                                                               (wrap431
                                                                                                 (parse-meta497
                                                                                                   e1425
                                                                                                   w1424
                                                                                                   ae1423)
                                                                                                 w1424)
                                                                                               '#t)
                                                                                             (cdr body1419))
                                                                                       r1418
                                                                                       mr1417
                                                                                       ids1416
                                                                                       vars1415
                                                                                       vals1414
                                                                                       inits1413
                                                                                       '#t)
                                                                                     (if (memv t1428
                                                                                               '(local-syntax-form))
                                                                                         (call-with-values
                                                                                           (lambda ()
                                                                                             (chi-local-syntax502
                                                                                               value1426
                                                                                               e1425
                                                                                               r1418
                                                                                               mr1417
                                                                                               w1424
                                                                                               ae1423))
                                                                                           (lambda (forms1486
                                                                                                    r1485
                                                                                                    mr1484
                                                                                                    w1483
                                                                                                    ae1482)
                                                                                             (parse1411
                                                                                               ((letrec ((f1487
                                                                                                          (lambda (forms1488)
                                                                                                            (if (null?
                                                                                                                  forms1488)
                                                                                                                (cdr body1419)
                                                                                                                (cons (make-frob463
                                                                                                                        (wrap431
                                                                                                                          (car forms1488)
                                                                                                                          w1483)
                                                                                                                        meta?1422)
                                                                                                                      (f1487
                                                                                                                        (cdr forms1488)))))))
                                                                                                  f1487)
                                                                                                forms1486)
                                                                                               r1485
                                                                                               mr1484
                                                                                               ids1416
                                                                                               vars1415
                                                                                               vals1414
                                                                                               inits1413
                                                                                               '#f)))
                                                                                         (begin (if meta-seen?1412
                                                                                                    (syntax-error
                                                                                                      (source-wrap432
                                                                                                        e1425
                                                                                                        w1424
                                                                                                        ae1423)
                                                                                                      '"invalid meta definition")
                                                                                                    (void))
                                                                                                ((letrec ((f1489
                                                                                                           (lambda (body1490)
                                                                                                             (if ((lambda (t1491)
                                                                                                                    (if t1491
                                                                                                                        t1491
                                                                                                                        (not (frob-meta?466
                                                                                                                               (car body1490)))))
                                                                                                                  (null?
                                                                                                                    body1490))
                                                                                                                 (return1410
                                                                                                                   r1418
                                                                                                                   mr1417
                                                                                                                   body1490
                                                                                                                   ids1416
                                                                                                                   vars1415
                                                                                                                   vals1414
                                                                                                                   inits1413)
                                                                                                                 (begin (top-level-eval-hook133
                                                                                                                          (chi-meta-frob483
                                                                                                                            (car body1490)
                                                                                                                            mr1417))
                                                                                                                        (f1489
                                                                                                                          (cdr body1490)))))))
                                                                                                   f1489)
                                                                                                 (cons (make-frob463
                                                                                                         (source-wrap432
                                                                                                           e1425
                                                                                                           w1424
                                                                                                           ae1423)
                                                                                                         meta?1422)
                                                                                                       (cdr body1419))))))))))))))
                                                   type1427))))))
                                         (frob-meta?466 fr1420)))
                                      (frob-e465 fr1420)))
                                   (car body1419))))))
                    parse1411)
                  body1407
                  r1406
                  mr1405
                  '()
                  '()
                  '()
                  '()
                  '#f))))
            (do-import!492
             (lambda (interface1400 ribcage1399)
               ((lambda (token1401)
                  (if token1401
                      (extend-ribcage-subst!404 ribcage1399 token1401)
                      (vfor-each475
                        (lambda (id1402)
                          ((lambda (label11403)
                             (begin (if (not label11403)
                                        (syntax-error
                                          id1402
                                          '"exported identifier not visible")
                                        (void))
                                    (extend-ribcage!401
                                      ribcage1399
                                      id1402
                                      label11403)))
                           (id-var-name-loc422 id1402 '(()))))
                        (interface-exports441 interface1400))))
                (interface-token442 interface1400))))
            (parse-module493
             (lambda (e1375 w1374 ae1373 *w1372)
               (letrec ((listify1376
                         (lambda (exports1393)
                           (if (null? exports1393)
                               '()
                               (cons ((lambda (tmp1394)
                                        ((lambda (tmp1395)
                                           (if tmp1395
                                               (apply
                                                 (lambda (ex1396)
                                                   (listify1376 ex1396))
                                                 tmp1395)
                                               ((lambda (x1398)
                                                  (if (id?310 x1398)
                                                      (wrap431
                                                        x1398
                                                        *w1372)
                                                      (syntax-error
                                                        (source-wrap432
                                                          e1375
                                                          w1374
                                                          ae1373)
                                                        '"invalid exports list in")))
                                                tmp1394)))
                                         ($syntax-dispatch
                                           tmp1394
                                           'each-any)))
                                      (car exports1393))
                                     (listify1376 (cdr exports1393)))))))
                 ((lambda (tmp1377)
                    ((lambda (tmp1378)
                       (if (if tmp1378
                               (apply
                                 (lambda (_1383
                                          orig1382
                                          mid1381
                                          ex1380
                                          form1379)
                                   (id?310 mid1381))
                                 tmp1378)
                               '#f)
                           (apply
                             (lambda (_1388
                                      orig1387
                                      mid1386
                                      ex1385
                                      form1384)
                               (values
                                 orig1387
                                 (wrap431 mid1386 w1374)
                                 (listify1376 ex1385)
                                 (map (lambda (x1390)
                                        (wrap431 x1390 *w1372))
                                      form1384)))
                             tmp1378)
                           ((lambda (_1392)
                              (syntax-error
                                (source-wrap432 e1375 w1374 ae1373)))
                            tmp1377)))
                     ($syntax-dispatch
                       tmp1377
                       '(any any any each-any . each-any))))
                  e1375))))
            (parse-import494
             (lambda (e1355 w1354 ae1353)
               ((lambda (tmp1356)
                  ((lambda (tmp1357)
                     (if (if tmp1357
                             (apply
                               (lambda (_1360 orig1359 mid1358)
                                 (id?310 mid1358))
                               tmp1357)
                             '#f)
                         (apply
                           (lambda (_1363 orig1362 mid1361)
                             (values orig1362 '#t (wrap431 mid1361 w1354)))
                           tmp1357)
                         ((lambda (tmp1364)
                            (if (if tmp1364
                                    (apply
                                      (lambda (_1367 orig1366 mid1365)
                                        (id?310 mid1365))
                                      tmp1364)
                                    '#f)
                                (apply
                                  (lambda (_1370 orig1369 mid1368)
                                    (values
                                      orig1369
                                      '#f
                                      (wrap431 mid1368 w1354)))
                                  tmp1364)
                                ((lambda (_1371)
                                   (syntax-error
                                     (source-wrap432 e1355 w1354 ae1353)))
                                 tmp1356)))
                          ($syntax-dispatch
                            tmp1356
                            '(any any #(atom #f) any)))))
                   ($syntax-dispatch tmp1356 '(any any #(atom #t) any))))
                e1355)))
            (parse-define495
             (lambda (e1326 w1325 ae1324)
               ((lambda (tmp1327)
                  ((lambda (tmp1328)
                     (if (if tmp1328
                             (apply
                               (lambda (_1331 name1330 val1329)
                                 (id?310 name1330))
                               tmp1328)
                             '#f)
                         (apply
                           (lambda (_1334 name1333 val1332)
                             (values name1333 val1332 w1325))
                           tmp1328)
                         ((lambda (tmp1335)
                            (if (if tmp1335
                                    (apply
                                      (lambda (_1340
                                               name1339
                                               args1338
                                               e11337
                                               e21336)
                                        (if (id?310 name1339)
                                            (valid-bound-ids?427
                                              (lambda-var-list509
                                                args1338))
                                            '#f))
                                      tmp1335)
                                    '#f)
                                (apply
                                  (lambda (_1345
                                           name1344
                                           args1343
                                           e11342
                                           e21341)
                                    (values
                                      (wrap431 name1344 w1325)
                                      (cons '#(syntax-object lambda ((top) #(ribcage #(_ name args e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(e w ae) #((top) (top) (top)) #("i" "i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                            (wrap431
                                              (cons args1343
                                                    (cons e11342 e21341))
                                              w1325))
                                      '(())))
                                  tmp1335)
                                ((lambda (tmp1347)
                                   (if (if tmp1347
                                           (apply
                                             (lambda (_1349 name1348)
                                               (id?310 name1348))
                                             tmp1347)
                                           '#f)
                                       (apply
                                         (lambda (_1351 name1350)
                                           (values
                                             (wrap431 name1350 w1325)
                                             '#(syntax-object (void) ((top) #(ribcage #(_ name) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(e w ae) #((top) (top) (top)) #("i" "i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                             '(())))
                                         tmp1347)
                                       ((lambda (_1352)
                                          (syntax-error
                                            (source-wrap432
                                              e1326
                                              w1325
                                              ae1324)))
                                        tmp1327)))
                                 ($syntax-dispatch tmp1327 '(any any)))))
                          ($syntax-dispatch
                            tmp1327
                            '(any (any . any) any . each-any)))))
                   ($syntax-dispatch tmp1327 '(any any any))))
                e1326)))
            (parse-define-syntax496
             (lambda (e1302 w1301 ae1300)
               ((lambda (tmp1303)
                  ((lambda (tmp1304)
                     (if (if tmp1304
                             (apply
                               (lambda (_1309
                                        name1308
                                        id1307
                                        e11306
                                        e21305)
                                 (if (id?310 name1308)
                                     (id?310 id1307)
                                     '#f))
                               tmp1304)
                             '#f)
                         (apply
                           (lambda (_1314 name1313 id1312 e11311 e21310)
                             (values
                               (wrap431 name1313 w1301)
                               (list*
                                 '#(syntax-object lambda ((top) #(ribcage #(_ name id e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(e w ae) #((top) (top) (top)) #("i" "i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                 (wrap431 (list id1312) w1301)
                                 (wrap431 (cons e11311 e21310) w1301))
                               '(())))
                           tmp1304)
                         ((lambda (tmp1316)
                            (if (if tmp1316
                                    (apply
                                      (lambda (_1319 name1318 val1317)
                                        (id?310 name1318))
                                      tmp1316)
                                    '#f)
                                (apply
                                  (lambda (_1322 name1321 val1320)
                                    (values name1321 val1320 w1301))
                                  tmp1316)
                                ((lambda (_1323)
                                   (syntax-error
                                     (source-wrap432 e1302 w1301 ae1300)))
                                 tmp1303)))
                          ($syntax-dispatch tmp1303 '(any any any)))))
                   ($syntax-dispatch
                     tmp1303
                     '(any (any any) any . each-any))))
                e1302)))
            (parse-meta497
             (lambda (e1294 w1293 ae1292)
               ((lambda (tmp1295)
                  ((lambda (tmp1296)
                     (if tmp1296
                         (apply (lambda (_1298 form1297) form1297) tmp1296)
                         ((lambda (_1299)
                            (syntax-error
                              (source-wrap432 e1294 w1293 ae1292)))
                          tmp1295)))
                   ($syntax-dispatch tmp1295 '(any . any))))
                e1294)))
            (parse-eval-when498
             (lambda (e1282 w1281 ae1280)
               ((lambda (tmp1283)
                  ((lambda (tmp1284)
                     (if tmp1284
                         (apply
                           (lambda (_1288 x1287 e11286 e21285)
                             (values
                               (chi-when-list433 x1287 w1281)
                               (cons e11286 e21285)))
                           tmp1284)
                         ((lambda (_1291)
                            (syntax-error
                              (source-wrap432 e1282 w1281 ae1280)))
                          tmp1283)))
                   ($syntax-dispatch
                     tmp1283
                     '(any each-any any . each-any))))
                e1282)))
            (parse-alias499
             (lambda (e1270 w1269 ae1268)
               ((lambda (tmp1271)
                  ((lambda (tmp1272)
                     (if (if tmp1272
                             (apply
                               (lambda (_1275 new-id1274 old-id1273)
                                 (if (id?310 new-id1274)
                                     (id?310 old-id1273)
                                     '#f))
                               tmp1272)
                             '#f)
                         (apply
                           (lambda (_1278 new-id1277 old-id1276)
                             (values new-id1277 old-id1276))
                           tmp1272)
                         ((lambda (_1279)
                            (syntax-error
                              (source-wrap432 e1270 w1269 ae1268)))
                          tmp1271)))
                   ($syntax-dispatch tmp1271 '(any any any))))
                e1270)))
            (parse-begin500
             (lambda (e1257 w1256 ae1255 empty-okay?1254)
               ((lambda (tmp1258)
                  ((lambda (tmp1259)
                     (if (if tmp1259
                             (apply
                               (lambda (_1260) empty-okay?1254)
                               tmp1259)
                             '#f)
                         (apply (lambda (_1261) '()) tmp1259)
                         ((lambda (tmp1262)
                            (if tmp1262
                                (apply
                                  (lambda (_1265 e11264 e21263)
                                    (cons e11264 e21263))
                                  tmp1262)
                                ((lambda (_1267)
                                   (syntax-error
                                     (source-wrap432 e1257 w1256 ae1255)))
                                 tmp1258)))
                          ($syntax-dispatch
                            tmp1258
                            '(any any . each-any)))))
                   ($syntax-dispatch tmp1258 '(any))))
                e1257)))
            (chi-lambda-clause501
             (lambda (e1231 c1230 r1229 mr1228 w1227 m?1226)
               ((lambda (tmp1232)
                  ((lambda (tmp1233)
                     (if tmp1233
                         (apply
                           (lambda (id1236 e11235 e21234)
                             ((lambda (ids1237)
                                (if (not (valid-bound-ids?427 ids1237))
                                    (syntax-error
                                      e1231
                                      '"invalid parameter list in")
                                    ((lambda (labels1239 new-vars1238)
                                       (values
                                         new-vars1238
                                         (chi-body490
                                           (cons e11235 e21234)
                                           e1231
                                           (extend-var-env*301
                                             labels1239
                                             new-vars1238
                                             r1229)
                                           mr1228
                                           (make-binding-wrap407
                                             ids1237
                                             labels1239
                                             w1227)
                                           m?1226)))
                                     (gen-labels357 ids1237)
                                     (map gen-var508 ids1237))))
                              id1236))
                           tmp1233)
                         ((lambda (tmp1242)
                            (if tmp1242
                                (apply
                                  (lambda (ids1245 e11244 e21243)
                                    ((lambda (old-ids1246)
                                       (if (not (valid-bound-ids?427
                                                  old-ids1246))
                                           (syntax-error
                                             e1231
                                             '"invalid parameter list in")
                                           ((lambda (labels1248
                                                     new-vars1247)
                                              (values
                                                ((letrec ((f1250
                                                           (lambda (ls11252
                                                                    ls21251)
                                                             (if (null?
                                                                   ls11252)
                                                                 ls21251
                                                                 (f1250
                                                                   (cdr ls11252)
                                                                   (cons (car ls11252)
                                                                         ls21251))))))
                                                   f1250)
                                                 (cdr new-vars1247)
                                                 (car new-vars1247))
                                                (chi-body490
                                                  (cons e11244 e21243)
                                                  e1231
                                                  (extend-var-env*301
                                                    labels1248
                                                    new-vars1247
                                                    r1229)
                                                  mr1228
                                                  (make-binding-wrap407
                                                    old-ids1246
                                                    labels1248
                                                    w1227)
                                                  m?1226)))
                                            (gen-labels357 old-ids1246)
                                            (map gen-var508 old-ids1246))))
                                     (lambda-var-list509 ids1245)))
                                  tmp1242)
                                ((lambda (_1253) (syntax-error e1231))
                                 tmp1232)))
                          ($syntax-dispatch
                            tmp1232
                            '(any any . each-any)))))
                   ($syntax-dispatch tmp1232 '(each-any any . each-any))))
                c1230)))
            (chi-local-syntax502
             (lambda (rec?1207 e1206 r1205 mr1204 w1203 ae1202)
               ((lambda (tmp1208)
                  ((lambda (tmp1209)
                     (if tmp1209
                         (apply
                           (lambda (_1214 id1213 val1212 e11211 e21210)
                             ((lambda (ids1215)
                                (if (not (valid-bound-ids?427 ids1215))
                                    (invalid-ids-error429
                                      (map (lambda (x1216)
                                             (wrap431 x1216 w1203))
                                           ids1215)
                                      (source-wrap432 e1206 w1203 ae1202)
                                      '"keyword")
                                    ((lambda (labels1217)
                                       ((lambda (new-w1218)
                                          ((lambda (b*1219)
                                             (values
                                               (cons e11211 e21210)
                                               (extend-env*300
                                                 labels1217
                                                 b*1219
                                                 r1205)
                                               (extend-env*300
                                                 labels1217
                                                 b*1219
                                                 mr1204)
                                               new-w1218
                                               ae1202))
                                           ((lambda (w1221)
                                              (map (lambda (x1223)
                                                     (defer-or-eval-transformer307
                                                       local-eval-hook134
                                                       (chi485
                                                         x1223
                                                         mr1204
                                                         mr1204
                                                         w1221
                                                         '#t)))
                                                   val1212))
                                            (if rec?1207
                                                new-w1218
                                                w1203))))
                                        (make-binding-wrap407
                                          ids1215
                                          labels1217
                                          w1203)))
                                     (gen-labels357 ids1215))))
                              id1213))
                           tmp1209)
                         ((lambda (_1225)
                            (syntax-error
                              (source-wrap432 e1206 w1203 ae1202)))
                          tmp1208)))
                   ($syntax-dispatch
                     tmp1208
                     '(any #(each (any any)) any . each-any))))
                e1206)))
            (chi-void503 (lambda () (list 'void)))
            (ellipsis?504
             (lambda (x1201)
               (if (nonsymbol-id?309 x1201)
                   (literal-id=?425
                     x1201
                     '#(syntax-object ... ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                   '#f)))
            (strip-annotation505
             (lambda (x1200)
               (if (pair? x1200)
                   (cons (strip-annotation505 (car x1200))
                         (strip-annotation505 (cdr x1200)))
                   (if (annotation?132 x1200)
                       (annotation-stripped x1200)
                       x1200))))
            (strip*506
             (lambda (x1193 w1192 fn1191)
               (if (memq 'top (wrap-marks318 w1192))
                   (fn1191 x1193)
                   ((letrec ((f1194
                              (lambda (x1195)
                                (if (syntax-object?64 x1195)
                                    (strip*506
                                      (syntax-object-expression65 x1195)
                                      (syntax-object-wrap66 x1195)
                                      fn1191)
                                    (if (pair? x1195)
                                        ((lambda (a1197 d1196)
                                           (if (if (eq? a1197 (car x1195))
                                                   (eq? d1196 (cdr x1195))
                                                   '#f)
                                               x1195
                                               (cons a1197 d1196)))
                                         (f1194 (car x1195))
                                         (f1194 (cdr x1195)))
                                        (if (vector? x1195)
                                            ((lambda (old1198)
                                               ((lambda (new1199)
                                                  (if (andmap
                                                        eq?
                                                        old1198
                                                        new1199)
                                                      x1195
                                                      (list->vector
                                                        new1199)))
                                                (map f1194 old1198)))
                                             (vector->list x1195))
                                            x1195))))))
                      f1194)
                    x1193))))
            (strip507
             (lambda (x1188 w1187)
               (strip*506
                 x1188
                 w1187
                 (lambda (x1189)
                   (if ((lambda (t1190)
                          (if t1190
                              t1190
                              (if (pair? x1189)
                                  (annotation?132 (car x1189))
                                  '#f)))
                        (annotation?132 x1189))
                       (strip-annotation505 x1189)
                       x1189)))))
            (gen-var508
             (lambda (id1185)
               ((lambda (id1186)
                  (if (annotation?132 id1186) (gensym) (gensym)))
                (if (syntax-object?64 id1185)
                    (syntax-object-expression65 id1185)
                    id1185))))
            (lambda-var-list509
             (lambda (vars1180)
               ((letrec ((lvl1181
                          (lambda (vars1184 ls1183 w1182)
                            (if (pair? vars1184)
                                (lvl1181
                                  (cdr vars1184)
                                  (cons (wrap431 (car vars1184) w1182)
                                        ls1183)
                                  w1182)
                                (if (id?310 vars1184)
                                    (cons (wrap431 vars1184 w1182) ls1183)
                                    (if (null? vars1184)
                                        ls1183
                                        (if (syntax-object?64 vars1184)
                                            (lvl1181
                                              (syntax-object-expression65
                                                vars1184)
                                              ls1183
                                              (join-wraps412
                                                w1182
                                                (syntax-object-wrap66
                                                  vars1184)))
                                            (if (annotation?132 vars1184)
                                                (lvl1181
                                                  (annotation-expression
                                                    vars1184)
                                                  ls1183
                                                  w1182)
                                                (cons vars1184
                                                      ls1183)))))))))
                  lvl1181)
                vars1180
                '()
                '(())))))
     (begin (set! $sc-put-cte
              (lambda (id1161 b1160 top-token1159)
                (letrec ((sc-put-module1162
                          (lambda (exports1178 token1177)
                            (vfor-each475
                              (lambda (id1179)
                                (store-import-binding406 id1179 token1177))
                              exports1178)))
                         (put-cte1163
                          (lambda (id1175 binding1174 token1173)
                            ((lambda (sym1176)
                               (begin (store-import-binding406
                                        id1175
                                        token1173)
                                      (put-global-definition-hook143
                                        sym1176
                                        (if (if (eq? (binding-type285
                                                       binding1174)
                                                     'global)
                                                (eq? (binding-value286
                                                       binding1174)
                                                     sym1176)
                                                '#f)
                                            '#f
                                            binding1174))))
                             (if (symbol? id1175)
                                 id1175
                                 (id-var-name423 id1175 '(())))))))
                  ((lambda (binding1164)
                     ((lambda (t1165)
                        (if (memv t1165 '($module))
                            (begin ((lambda (iface1166)
                                      (sc-put-module1162
                                        (interface-exports441 iface1166)
                                        (interface-token442 iface1166)))
                                    (binding-value286 binding1164))
                                   (put-cte1163
                                     id1161
                                     binding1164
                                     top-token1159))
                            (if (memv t1165 '(do-alias))
                                (store-import-binding406
                                  id1161
                                  top-token1159)
                                (if (memv t1165 '(do-import))
                                    ((lambda (import-only?1168 token1167)
                                       ((lambda (b1169)
                                          ((lambda (t1170)
                                             (if (memv t1170 '($module))
                                                 ((lambda (iface1171)
                                                    ((lambda (exports1172)
                                                       ((lambda ()
                                                          (begin (if (not (eq? (interface-token442
                                                                                 iface1171)
                                                                               token1167))
                                                                     (syntax-error
                                                                       id1161
                                                                       '"import mismatch for module")
                                                                     (void))
                                                                 (sc-put-module1162
                                                                   exports1172
                                                                   top-token1159)))))
                                                     (interface-exports441
                                                       iface1171)))
                                                  (binding-value286 b1169))
                                                 (syntax-error
                                                   id1161
                                                   '"unknown module")))
                                           (binding-type285 b1169)))
                                        (lookup305
                                          (id-var-name423 id1161 '(()))
                                          '())))
                                     (car (binding-value286 b1160))
                                     (cdr (binding-value286 b1160)))
                                    (put-cte1163
                                      id1161
                                      binding1164
                                      top-token1159)))))
                      (binding-type285 binding1164)))
                   (make-transformer-binding306 b1160)))))
            (global-extend308 'local-syntax 'letrec-syntax '#t)
            (global-extend308 'local-syntax 'let-syntax '#f)
            (global-extend308
              'core
              'fluid-let-syntax
              (lambda (e1133 r1132 mr1131 w1130 ae1129 m?1128)
                ((lambda (tmp1134)
                   ((lambda (tmp1135)
                      (if (if tmp1135
                              (apply
                                (lambda (_1140
                                         var1139
                                         val1138
                                         e11137
                                         e21136)
                                  (valid-bound-ids?427 var1139))
                                tmp1135)
                              '#f)
                          (apply
                            (lambda (_1146 var1145 val1144 e11143 e21142)
                              ((lambda (names1147)
                                 (begin (for-each
                                          (lambda (id1154 n1153)
                                            ((lambda (t1155)
                                               (if (memv t1155
                                                         '(displaced-lexical))
                                                   (displaced-lexical-error303
                                                     (wrap431
                                                       id1154
                                                       w1130))
                                                   (void)))
                                             (binding-type285
                                               (lookup305 n1153 r1132))))
                                          var1145
                                          names1147)
                                        ((lambda (b*1148)
                                           (chi-body490
                                             (cons e11143 e21142)
                                             (source-wrap432
                                               e1133
                                               w1130
                                               ae1129)
                                             (extend-env*300
                                               names1147
                                               b*1148
                                               r1132)
                                             (extend-env*300
                                               names1147
                                               b*1148
                                               mr1131)
                                             w1130
                                             m?1128))
                                         (map (lambda (x1151)
                                                (defer-or-eval-transformer307
                                                  local-eval-hook134
                                                  (chi485
                                                    x1151
                                                    mr1131
                                                    mr1131
                                                    w1130
                                                    '#t)))
                                              val1144))))
                               (map (lambda (x1157)
                                      (id-var-name423 x1157 w1130))
                                    var1145)))
                            tmp1135)
                          ((lambda (_1158)
                             (syntax-error
                               (source-wrap432 e1133 w1130 ae1129)))
                           tmp1134)))
                    ($syntax-dispatch
                      tmp1134
                      '(any #(each (any any)) any . each-any))))
                 e1133)))
            (global-extend308
              'core
              'quote
              (lambda (e1122 r1121 mr1120 w1119 ae1118 m?1117)
                ((lambda (tmp1123)
                   ((lambda (tmp1124)
                      (if tmp1124
                          (apply
                            (lambda (_1126 e1125)
                              (list 'quote (strip507 e1125 w1119)))
                            tmp1124)
                          ((lambda (_1127)
                             (syntax-error
                               (source-wrap432 e1122 w1119 ae1118)))
                           tmp1123)))
                    ($syntax-dispatch tmp1123 '(any any))))
                 e1122)))
            (global-extend308
              'core
              'syntax
              ((lambda ()
                 (letrec ((gen-syntax1002
                           (lambda (src1062
                                    e1061
                                    r1060
                                    maps1059
                                    ellipsis?1058)
                             (if (id?310 e1061)
                                 ((lambda (label1063)
                                    ((lambda (b1064)
                                       (if (eq? (binding-type285 b1064)
                                                'syntax)
                                           (call-with-values
                                             (lambda ()
                                               ((lambda (var.lev1067)
                                                  (gen-ref1003
                                                    src1062
                                                    (car var.lev1067)
                                                    (cdr var.lev1067)
                                                    maps1059))
                                                (binding-value286 b1064)))
                                             (lambda (var1066 maps1065)
                                               (values
                                                 (list 'ref var1066)
                                                 maps1065)))
                                           (if (ellipsis?1058 e1061)
                                               (syntax-error
                                                 src1062
                                                 '"misplaced ellipsis in syntax form")
                                               (values
                                                 (list 'quote e1061)
                                                 maps1059))))
                                     (lookup305 label1063 r1060)))
                                  (id-var-name423 e1061 '(())))
                                 ((lambda (tmp1068)
                                    ((lambda (tmp1069)
                                       (if (if tmp1069
                                               (apply
                                                 (lambda (dots1071 e1070)
                                                   (ellipsis?1058
                                                     dots1071))
                                                 tmp1069)
                                               '#f)
                                           (apply
                                             (lambda (dots1073 e1072)
                                               (gen-syntax1002
                                                 src1062
                                                 e1072
                                                 r1060
                                                 maps1059
                                                 (lambda (x1074) '#f)))
                                             tmp1069)
                                           ((lambda (tmp1075)
                                              (if (if tmp1075
                                                      (apply
                                                        (lambda (x1078
                                                                 dots1077
                                                                 y1076)
                                                          (ellipsis?1058
                                                            dots1077))
                                                        tmp1075)
                                                      '#f)
                                                  (apply
                                                    (lambda (x1081
                                                             dots1080
                                                             y1079)
                                                      ((letrec ((f1082
                                                                 (lambda (y1084
                                                                          k1083)
                                                                   ((lambda (tmp1085)
                                                                      ((lambda (tmp1086)
                                                                         (if (if tmp1086
                                                                                 (apply
                                                                                   (lambda (dots1088
                                                                                            y1087)
                                                                                     (ellipsis?1058
                                                                                       dots1088))
                                                                                   tmp1086)
                                                                                 '#f)
                                                                             (apply
                                                                               (lambda (dots1090
                                                                                        y1089)
                                                                                 (f1082
                                                                                   y1089
                                                                                   (lambda (maps1091)
                                                                                     (call-with-values
                                                                                       (lambda ()
                                                                                         (k1083
                                                                                           (cons '()
                                                                                                 maps1091)))
                                                                                       (lambda (x1093
                                                                                                maps1092)
                                                                                         (if (null?
                                                                                               (car maps1092))
                                                                                             (syntax-error
                                                                                               src1062
                                                                                               '"extra ellipsis in syntax form")
                                                                                             (values
                                                                                               (gen-mappend1005
                                                                                                 x1093
                                                                                                 (car maps1092))
                                                                                               (cdr maps1092))))))))
                                                                               tmp1086)
                                                                             ((lambda (_1094)
                                                                                (call-with-values
                                                                                  (lambda ()
                                                                                    (gen-syntax1002
                                                                                      src1062
                                                                                      y1084
                                                                                      r1060
                                                                                      maps1059
                                                                                      ellipsis?1058))
                                                                                  (lambda (y1096
                                                                                           maps1095)
                                                                                    (call-with-values
                                                                                      (lambda ()
                                                                                        (k1083
                                                                                          maps1095))
                                                                                      (lambda (x1098
                                                                                               maps1097)
                                                                                        (values
                                                                                          (gen-append1004
                                                                                            x1098
                                                                                            y1096)
                                                                                          maps1097))))))
                                                                              tmp1085)))
                                                                       ($syntax-dispatch
                                                                         tmp1085
                                                                         '(any .
                                                                               any))))
                                                                    y1084))))
                                                         f1082)
                                                       y1079
                                                       (lambda (maps1099)
                                                         (call-with-values
                                                           (lambda ()
                                                             (gen-syntax1002
                                                               src1062
                                                               x1081
                                                               r1060
                                                               (cons '()
                                                                     maps1099)
                                                               ellipsis?1058))
                                                           (lambda (x1101
                                                                    maps1100)
                                                             (if (null?
                                                                   (car maps1100))
                                                                 (syntax-error
                                                                   src1062
                                                                   '"extra ellipsis in syntax form")
                                                                 (values
                                                                   (gen-map1006
                                                                     x1101
                                                                     (car maps1100))
                                                                   (cdr maps1100))))))))
                                                    tmp1075)
                                                  ((lambda (tmp1102)
                                                     (if tmp1102
                                                         (apply
                                                           (lambda (x1104
                                                                    y1103)
                                                             (call-with-values
                                                               (lambda ()
                                                                 (gen-syntax1002
                                                                   src1062
                                                                   x1104
                                                                   r1060
                                                                   maps1059
                                                                   ellipsis?1058))
                                                               (lambda (xnew1106
                                                                        maps1105)
                                                                 (call-with-values
                                                                   (lambda ()
                                                                     (gen-syntax1002
                                                                       src1062
                                                                       y1103
                                                                       r1060
                                                                       maps1105
                                                                       ellipsis?1058))
                                                                   (lambda (ynew1108
                                                                            maps1107)
                                                                     (values
                                                                       (gen-cons1007
                                                                         e1061
                                                                         x1104
                                                                         y1103
                                                                         xnew1106
                                                                         ynew1108)
                                                                       maps1107))))))
                                                           tmp1102)
                                                         ((lambda (tmp1109)
                                                            (if tmp1109
                                                                (apply
                                                                  (lambda (x11111
                                                                           x21110)
                                                                    ((lambda (ls1112)
                                                                       (call-with-values
                                                                         (lambda ()
                                                                           (gen-syntax1002
                                                                             src1062
                                                                             ls1112
                                                                             r1060
                                                                             maps1059
                                                                             ellipsis?1058))
                                                                         (lambda (lsnew1114
                                                                                  maps1113)
                                                                           (values
                                                                             (gen-vector1008
                                                                               e1061
                                                                               ls1112
                                                                               lsnew1114)
                                                                             maps1113))))
                                                                     (cons x11111
                                                                           x21110)))
                                                                  tmp1109)
                                                                ((lambda (_1116)
                                                                   (values
                                                                     (list 'quote
                                                                           e1061)
                                                                     maps1059))
                                                                 tmp1068)))
                                                          ($syntax-dispatch
                                                            tmp1068
                                                            '#(vector
                                                               (any .
                                                                    each-any))))))
                                                   ($syntax-dispatch
                                                     tmp1068
                                                     '(any . any)))))
                                            ($syntax-dispatch
                                              tmp1068
                                              '(any any . any)))))
                                     ($syntax-dispatch
                                       tmp1068
                                       '(any any))))
                                  e1061))))
                          (gen-ref1003
                           (lambda (src1053 var1052 level1051 maps1050)
                             (if (= level1051 '0)
                                 (values var1052 maps1050)
                                 (if (null? maps1050)
                                     (syntax-error
                                       src1053
                                       '"missing ellipsis in syntax form")
                                     (call-with-values
                                       (lambda ()
                                         (gen-ref1003
                                           src1053
                                           var1052
                                           (- level1051 '1)
                                           (cdr maps1050)))
                                       (lambda (outer-var1055
                                                outer-maps1054)
                                         ((lambda (b1056)
                                            (if b1056
                                                (values
                                                  (cdr b1056)
                                                  maps1050)
                                                ((lambda (inner-var1057)
                                                   (values
                                                     inner-var1057
                                                     (cons (cons (cons outer-var1055
                                                                       inner-var1057)
                                                                 (car maps1050))
                                                           outer-maps1054)))
                                                 (gen-var508 'tmp))))
                                          (assq outer-var1055
                                                (car maps1050)))))))))
                          (gen-append1004
                           (lambda (x1049 y1048)
                             (if (equal? y1048 ''())
                                 x1049
                                 (list 'append x1049 y1048))))
                          (gen-mappend1005
                           (lambda (e1047 map-env1046)
                             (list 'apply
                                   '(primitive append)
                                   (gen-map1006 e1047 map-env1046))))
                          (gen-map1006
                           (lambda (e1039 map-env1038)
                             ((lambda (formals1041 actuals1040)
                                (if (eq? (car e1039) 'ref)
                                    (car actuals1040)
                                    (if (andmap
                                          (lambda (x1042)
                                            (if (eq? (car x1042) 'ref)
                                                (memq (cadr x1042)
                                                      formals1041)
                                                '#f))
                                          (cdr e1039))
                                        (cons 'map
                                              (cons (list 'primitive
                                                          (car e1039))
                                                    (map ((lambda (r1043)
                                                            (lambda (x1044)
                                                              (cdr (assq (cadr x1044)
                                                                         r1043))))
                                                          (map cons
                                                               formals1041
                                                               actuals1040))
                                                         (cdr e1039))))
                                        (cons 'map
                                              (cons (list 'lambda
                                                          formals1041
                                                          e1039)
                                                    actuals1040)))))
                              (map cdr map-env1038)
                              (map (lambda (x1045) (list 'ref (car x1045)))
                                   map-env1038))))
                          (gen-cons1007
                           (lambda (e1034 x1033 y1032 xnew1031 ynew1030)
                             ((lambda (t1035)
                                (if (memv t1035 '(quote))
                                    (if (eq? (car xnew1031) 'quote)
                                        ((lambda (xnew1037 ynew1036)
                                           (if (if (eq? xnew1037 x1033)
                                                   (eq? ynew1036 y1032)
                                                   '#f)
                                               (list 'quote e1034)
                                               (list 'quote
                                                     (cons xnew1037
                                                           ynew1036))))
                                         (cadr xnew1031)
                                         (cadr ynew1030))
                                        (if (eq? (cadr ynew1030) '())
                                            (list 'list xnew1031)
                                            (list 'cons
                                                  xnew1031
                                                  ynew1030)))
                                    (if (memv t1035 '(list))
                                        (cons 'list
                                              (cons xnew1031
                                                    (cdr ynew1030)))
                                        (list 'cons xnew1031 ynew1030))))
                              (car ynew1030))))
                          (gen-vector1008
                           (lambda (e1029 ls1028 lsnew1027)
                             (if (eq? (car lsnew1027) 'quote)
                                 (if (eq? (cadr lsnew1027) ls1028)
                                     (list 'quote e1029)
                                     (list 'quote
                                           (list->vector
                                             (cadr lsnew1027))))
                                 (if (eq? (car lsnew1027) 'list)
                                     (cons 'vector (cdr lsnew1027))
                                     (list 'list->vector lsnew1027)))))
                          (regen1009
                           (lambda (x1024)
                             ((lambda (t1025)
                                (if (memv t1025 '(ref))
                                    (cadr x1024)
                                    (if (memv t1025 '(primitive))
                                        (cadr x1024)
                                        (if (memv t1025 '(quote))
                                            (list 'quote (cadr x1024))
                                            (if (memv t1025 '(lambda))
                                                (list 'lambda
                                                      (cadr x1024)
                                                      (regen1009
                                                        (caddr x1024)))
                                                (if (memv t1025 '(map))
                                                    ((lambda (ls1026)
                                                       (cons (if (= (length
                                                                      ls1026)
                                                                    '2)
                                                                 'map
                                                                 'map)
                                                             ls1026))
                                                     (map regen1009
                                                          (cdr x1024)))
                                                    (cons (car x1024)
                                                          (map regen1009
                                                               (cdr x1024)))))))))
                              (car x1024)))))
                   (lambda (e1015 r1014 mr1013 w1012 ae1011 m?1010)
                     ((lambda (e1016)
                        ((lambda (tmp1017)
                           ((lambda (tmp1018)
                              (if tmp1018
                                  (apply
                                    (lambda (_1020 x1019)
                                      (call-with-values
                                        (lambda ()
                                          (gen-syntax1002
                                            e1016
                                            x1019
                                            r1014
                                            '()
                                            ellipsis?504))
                                        (lambda (e1022 maps1021)
                                          (regen1009 e1022))))
                                    tmp1018)
                                  ((lambda (_1023) (syntax-error e1016))
                                   tmp1017)))
                            ($syntax-dispatch tmp1017 '(any any))))
                         e1016))
                      (source-wrap432 e1015 w1012 ae1011)))))))
            (global-extend308
              'core
              'lambda
              (lambda (e995 r994 mr993 w992 ae991 m?990)
                ((lambda (tmp996)
                   ((lambda (tmp997)
                      (if tmp997
                          (apply
                            (lambda (_999 c998)
                              (call-with-values
                                (lambda ()
                                  (chi-lambda-clause501
                                    (source-wrap432 e995 w992 ae991)
                                    c998
                                    r994
                                    mr993
                                    w992
                                    m?990))
                                (lambda (vars1001 body1000)
                                  (list 'lambda vars1001 body1000))))
                            tmp997)
                          (syntax-error tmp996)))
                    ($syntax-dispatch tmp996 '(any . any))))
                 e995)))
            (global-extend308
              'core
              'letrec
              (lambda (e971 r970 mr969 w968 ae967 m?966)
                ((lambda (tmp972)
                   ((lambda (tmp973)
                      (if tmp973
                          (apply
                            (lambda (_978 id977 val976 e1975 e2974)
                              ((lambda (ids979)
                                 (if (not (valid-bound-ids?427 ids979))
                                     (invalid-ids-error429
                                       (map (lambda (x980)
                                              (wrap431 x980 w968))
                                            ids979)
                                       (source-wrap432 e971 w968 ae967)
                                       '"bound variable")
                                     ((lambda (labels982 new-vars981)
                                        ((lambda (w984 r983)
                                           (build-letrec240
                                             ae967
                                             new-vars981
                                             (map (lambda (x987)
                                                    (chi485
                                                      x987
                                                      r983
                                                      mr969
                                                      w984
                                                      m?966))
                                                  val976)
                                             (chi-body490
                                               (cons e1975 e2974)
                                               (source-wrap432
                                                 e971
                                                 w984
                                                 ae967)
                                               r983
                                               mr969
                                               w984
                                               m?966)))
                                         (make-binding-wrap407
                                           ids979
                                           labels982
                                           w968)
                                         (extend-var-env*301
                                           labels982
                                           new-vars981
                                           r970)))
                                      (gen-labels357 ids979)
                                      (map gen-var508 ids979))))
                               id977))
                            tmp973)
                          ((lambda (_989)
                             (syntax-error
                               (source-wrap432 e971 w968 ae967)))
                           tmp972)))
                    ($syntax-dispatch
                      tmp972
                      '(any #(each (any any)) any . each-any))))
                 e971)))
            (global-extend308
              'core
              'if
              (lambda (e954 r953 mr952 w951 ae950 m?949)
                ((lambda (tmp955)
                   ((lambda (tmp956)
                      (if tmp956
                          (apply
                            (lambda (_959 test958 then957)
                              (list 'if
                                    (chi485 test958 r953 mr952 w951 m?949)
                                    (chi485 then957 r953 mr952 w951 m?949)
                                    (chi-void503)))
                            tmp956)
                          ((lambda (tmp960)
                             (if tmp960
                                 (apply
                                   (lambda (_964 test963 then962 else961)
                                     (list 'if
                                           (chi485
                                             test963
                                             r953
                                             mr952
                                             w951
                                             m?949)
                                           (chi485
                                             then962
                                             r953
                                             mr952
                                             w951
                                             m?949)
                                           (chi485
                                             else961
                                             r953
                                             mr952
                                             w951
                                             m?949)))
                                   tmp960)
                                 ((lambda (_965)
                                    (syntax-error
                                      (source-wrap432 e954 w951 ae950)))
                                  tmp955)))
                           ($syntax-dispatch tmp955 '(any any any any)))))
                    ($syntax-dispatch tmp955 '(any any any))))
                 e954)))
            (global-extend308 'set! 'set! '())
            (global-extend308 'alias 'alias '())
            (global-extend308 'begin 'begin '())
            (global-extend308 '$module-key '$module '())
            (global-extend308 '$import '$import '())
            (global-extend308 'define 'define '())
            (global-extend308 'define-syntax 'define-syntax '())
            (global-extend308 'eval-when 'eval-when '())
            (global-extend308 'meta 'meta '())
            (global-extend308
              'core
              'syntax-case
              ((lambda ()
                 (letrec ((convert-pattern821
                           (lambda (pattern898 keys897)
                             (letrec ((cvt*899
                                       (lambda (p*944 n943 ids942)
                                         (if (null? p*944)
                                             (values '() ids942)
                                             (call-with-values
                                               (lambda ()
                                                 (cvt*899
                                                   (cdr p*944)
                                                   n943
                                                   ids942))
                                               (lambda (y946 ids945)
                                                 (call-with-values
                                                   (lambda ()
                                                     (cvt900
                                                       (car p*944)
                                                       n943
                                                       ids945))
                                                   (lambda (x948 ids947)
                                                     (values
                                                       (cons x948 y946)
                                                       ids947))))))))
                                      (cvt900
                                       (lambda (p903 n902 ids901)
                                         (if (id?310 p903)
                                             (if (bound-id-member?430
                                                   p903
                                                   keys897)
                                                 (values
                                                   (vector 'free-id p903)
                                                   ids901)
                                                 (values
                                                   'any
                                                   (cons (cons p903 n902)
                                                         ids901)))
                                             ((lambda (tmp904)
                                                ((lambda (tmp905)
                                                   (if (if tmp905
                                                           (apply
                                                             (lambda (x907
                                                                      dots906)
                                                               (ellipsis?504
                                                                 dots906))
                                                             tmp905)
                                                           '#f)
                                                       (apply
                                                         (lambda (x909
                                                                  dots908)
                                                           (call-with-values
                                                             (lambda ()
                                                               (cvt900
                                                                 x909
                                                                 (+ n902
                                                                    '1)
                                                                 ids901))
                                                             (lambda (p911
                                                                      ids910)
                                                               (values
                                                                 (if (eq? p911
                                                                          'any)
                                                                     'each-any
                                                                     (vector
                                                                       'each
                                                                       p911))
                                                                 ids910))))
                                                         tmp905)
                                                       ((lambda (tmp912)
                                                          (if (if tmp912
                                                                  (apply
                                                                    (lambda (x916
                                                                             dots915
                                                                             y914
                                                                             z913)
                                                                      (ellipsis?504
                                                                        dots915))
                                                                    tmp912)
                                                                  '#f)
                                                              (apply
                                                                (lambda (x920
                                                                         dots919
                                                                         y918
                                                                         z917)
                                                                  (call-with-values
                                                                    (lambda ()
                                                                      (cvt900
                                                                        z917
                                                                        n902
                                                                        ids901))
                                                                    (lambda (z922
                                                                             ids921)
                                                                      (call-with-values
                                                                        (lambda ()
                                                                          (cvt*899
                                                                            y918
                                                                            n902
                                                                            ids921))
                                                                        (lambda (y924
                                                                                 ids923)
                                                                          (call-with-values
                                                                            (lambda ()
                                                                              (cvt900
                                                                                x920
                                                                                (+ n902
                                                                                   '1)
                                                                                ids923))
                                                                            (lambda (x926
                                                                                     ids925)
                                                                              (values
                                                                                (vector
                                                                                  'each+
                                                                                  x926
                                                                                  (reverse
                                                                                    y924)
                                                                                  z922)
                                                                                ids925))))))))
                                                                tmp912)
                                                              ((lambda (tmp928)
                                                                 (if tmp928
                                                                     (apply
                                                                       (lambda (x930
                                                                                y929)
                                                                         (call-with-values
                                                                           (lambda ()
                                                                             (cvt900
                                                                               y929
                                                                               n902
                                                                               ids901))
                                                                           (lambda (y932
                                                                                    ids931)
                                                                             (call-with-values
                                                                               (lambda ()
                                                                                 (cvt900
                                                                                   x930
                                                                                   n902
                                                                                   ids931))
                                                                               (lambda (x934
                                                                                        ids933)
                                                                                 (values
                                                                                   (cons x934
                                                                                         y932)
                                                                                   ids933))))))
                                                                       tmp928)
                                                                     ((lambda (tmp935)
                                                                        (if tmp935
                                                                            (apply
                                                                              (lambda ()
                                                                                (values
                                                                                  '()
                                                                                  ids901))
                                                                              tmp935)
                                                                            ((lambda (tmp936)
                                                                               (if tmp936
                                                                                   (apply
                                                                                     (lambda (x937)
                                                                                       (call-with-values
                                                                                         (lambda ()
                                                                                           (cvt900
                                                                                             x937
                                                                                             n902
                                                                                             ids901))
                                                                                         (lambda (p939
                                                                                                  ids938)
                                                                                           (values
                                                                                             (vector
                                                                                               'vector
                                                                                               p939)
                                                                                             ids938))))
                                                                                     tmp936)
                                                                                   ((lambda (x941)
                                                                                      (values
                                                                                        (vector
                                                                                          'atom
                                                                                          (strip507
                                                                                            p903
                                                                                            '(())))
                                                                                        ids901))
                                                                                    tmp904)))
                                                                             ($syntax-dispatch
                                                                               tmp904
                                                                               '#(vector
                                                                                  each-any)))))
                                                                      ($syntax-dispatch
                                                                        tmp904
                                                                        '()))))
                                                               ($syntax-dispatch
                                                                 tmp904
                                                                 '(any .
                                                                       any)))))
                                                        ($syntax-dispatch
                                                          tmp904
                                                          '(any any
                                                                .
                                                                #(each+
                                                                  any
                                                                  ()
                                                                  any))))))
                                                 ($syntax-dispatch
                                                   tmp904
                                                   '(any any))))
                                              p903)))))
                               (cvt900 pattern898 '0 '()))))
                          (build-dispatch-call822
                           (lambda (pvars890 exp889 y888 r887 mr886 m?885)
                             ((lambda (ids892 levels891)
                                ((lambda (labels894 new-vars893)
                                   (list 'apply
                                         (list 'lambda
                                               new-vars893
                                               (chi485
                                                 exp889
                                                 (extend-env*300
                                                   labels894
                                                   (map (lambda (var896
                                                                 level895)
                                                          (cons 'syntax
                                                                (cons var896
                                                                      level895)))
                                                        new-vars893
                                                        (map cdr pvars890))
                                                   r887)
                                                 mr886
                                                 (make-binding-wrap407
                                                   ids892
                                                   labels894
                                                   '(()))
                                                 m?885))
                                         y888))
                                 (gen-labels357 ids892)
                                 (map gen-var508 ids892)))
                              (map car pvars890)
                              (map cdr pvars890))))
                          (gen-clause823
                           (lambda (x868
                                    keys867
                                    clauses866
                                    r865
                                    mr864
                                    m?863
                                    pat862
                                    fender861
                                    exp860)
                             (call-with-values
                               (lambda ()
                                 (convert-pattern821 pat862 keys867))
                               (lambda (p870 pvars869)
                                 (if (not (distinct-bound-ids?428
                                            (map car pvars869)))
                                     (invalid-ids-error429
                                       (map car pvars869)
                                       pat862
                                       '"pattern variable")
                                     (if (not (andmap
                                                (lambda (x871)
                                                  (not (ellipsis?504
                                                         (car x871))))
                                                pvars869))
                                         (syntax-error
                                           pat862
                                           '"misplaced ellipsis in syntax-case pattern")
                                         ((lambda (y872)
                                            (list (list 'lambda
                                                        (list y872)
                                                        (list 'if
                                                              ((lambda (tmp882)
                                                                 ((lambda (tmp883)
                                                                    (if tmp883
                                                                        (apply
                                                                          (lambda ()
                                                                            y872)
                                                                          tmp883)
                                                                        ((lambda (_884)
                                                                           (list 'if
                                                                                 y872
                                                                                 (build-dispatch-call822
                                                                                   pvars869
                                                                                   fender861
                                                                                   y872
                                                                                   r865
                                                                                   mr864
                                                                                   m?863)
                                                                                 (list 'quote
                                                                                       '#f)))
                                                                         tmp882)))
                                                                  ($syntax-dispatch
                                                                    tmp882
                                                                    '#(atom
                                                                       #t))))
                                                               fender861)
                                                              (build-dispatch-call822
                                                                pvars869
                                                                exp860
                                                                y872
                                                                r865
                                                                mr864
                                                                m?863)
                                                              (gen-syntax-case824
                                                                x868
                                                                keys867
                                                                clauses866
                                                                r865
                                                                mr864
                                                                m?863)))
                                                  (if (eq? p870 'any)
                                                      (list 'list x868)
                                                      (list '$syntax-dispatch
                                                            x868
                                                            (list 'quote
                                                                  p870)))))
                                          (gen-var508 'tmp))))))))
                          (gen-syntax-case824
                           (lambda (x848
                                    keys847
                                    clauses846
                                    r845
                                    mr844
                                    m?843)
                             (if (null? clauses846)
                                 (list 'syntax-error x848)
                                 ((lambda (tmp849)
                                    ((lambda (tmp850)
                                       (if tmp850
                                           (apply
                                             (lambda (pat852 exp851)
                                               (if (if (id?310 pat852)
                                                       (if (not (bound-id-member?430
                                                                  pat852
                                                                  keys847))
                                                           (not (ellipsis?504
                                                                  pat852))
                                                           '#f)
                                                       '#f)
                                                   ((lambda (label854
                                                             var853)
                                                      (list (list 'lambda
                                                                  (list var853)
                                                                  (chi485
                                                                    exp851
                                                                    (extend-env299
                                                                      label854
                                                                      (cons 'syntax
                                                                            (cons var853
                                                                                  '0))
                                                                      r845)
                                                                    mr844
                                                                    (make-binding-wrap407
                                                                      (list pat852)
                                                                      (list label854)
                                                                      '(()))
                                                                    m?843))
                                                            x848))
                                                    (gen-label355)
                                                    (gen-var508 pat852))
                                                   (gen-clause823
                                                     x848
                                                     keys847
                                                     (cdr clauses846)
                                                     r845
                                                     mr844
                                                     m?843
                                                     pat852
                                                     '#t
                                                     exp851)))
                                             tmp850)
                                           ((lambda (tmp855)
                                              (if tmp855
                                                  (apply
                                                    (lambda (pat858
                                                             fender857
                                                             exp856)
                                                      (gen-clause823
                                                        x848
                                                        keys847
                                                        (cdr clauses846)
                                                        r845
                                                        mr844
                                                        m?843
                                                        pat858
                                                        fender857
                                                        exp856))
                                                    tmp855)
                                                  ((lambda (_859)
                                                     (syntax-error
                                                       (car clauses846)
                                                       '"invalid syntax-case clause"))
                                                   tmp849)))
                                            ($syntax-dispatch
                                              tmp849
                                              '(any any any)))))
                                     ($syntax-dispatch tmp849 '(any any))))
                                  (car clauses846))))))
                   (lambda (e830 r829 mr828 w827 ae826 m?825)
                     ((lambda (e831)
                        ((lambda (tmp832)
                           ((lambda (tmp833)
                              (if tmp833
                                  (apply
                                    (lambda (_837 val836 key835 m834)
                                      (if (andmap
                                            (lambda (x839)
                                              (if (id?310 x839)
                                                  (not (ellipsis?504 x839))
                                                  '#f))
                                            key835)
                                          ((lambda (x840)
                                             (list (list 'lambda
                                                         (list x840)
                                                         (gen-syntax-case824
                                                           x840
                                                           key835
                                                           m834
                                                           r829
                                                           mr828
                                                           m?825))
                                                   (chi485
                                                     val836
                                                     r829
                                                     mr828
                                                     '(())
                                                     m?825)))
                                           (gen-var508 'tmp))
                                          (syntax-error
                                            e831
                                            '"invalid literals list in")))
                                    tmp833)
                                  (syntax-error tmp832)))
                            ($syntax-dispatch
                              tmp832
                              '(any any each-any . each-any))))
                         e831))
                      (source-wrap432 e830 w827 ae826)))))))
            (put-cte-hook141
              'module
              (lambda (x790)
                (letrec ((proper-export?791
                          (lambda (e814)
                            ((lambda (tmp815)
                               ((lambda (tmp816)
                                  (if tmp816
                                      (apply
                                        (lambda (id818 e817)
                                          (if (identifier? id818)
                                              (andmap
                                                proper-export?791
                                                e817)
                                              '#f))
                                        tmp816)
                                      ((lambda (id820) (identifier? id820))
                                       tmp815)))
                                ($syntax-dispatch
                                  tmp815
                                  '(any . each-any))))
                             e814))))
                  ((lambda (tmp792)
                     ((lambda (orig793)
                        ((lambda (tmp794)
                           ((lambda (tmp795)
                              (if tmp795
                                  (apply
                                    (lambda (_798 e797 d796)
                                      (if (andmap proper-export?791 e797)
                                          (list '#(syntax-object begin ((top) #(ribcage #(_ e d) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig) #((top)) #("i")) #(ribcage (proper-export?) ((top)) ("i")) #(ribcage #(x) #((top)) #("i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                (cons '#(syntax-object $module ((top) #(ribcage #(_ e d) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig) #((top)) #("i")) #(ribcage (proper-export?) ((top)) ("i")) #(ribcage #(x) #((top)) #("i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                      (cons orig793
                                                            (cons '#(syntax-object anon ((top) #(ribcage #(_ e d) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig) #((top)) #("i")) #(ribcage (proper-export?) ((top)) ("i")) #(ribcage #(x) #((top)) #("i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                  (cons e797
                                                                        d796))))
                                                (cons '#(syntax-object $import ((top) #(ribcage #(_ e d) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig) #((top)) #("i")) #(ribcage (proper-export?) ((top)) ("i")) #(ribcage #(x) #((top)) #("i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                      (cons orig793
                                                            '#(syntax-object (#f anon) ((top) #(ribcage #(_ e d) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig) #((top)) #("i")) #(ribcage (proper-export?) ((top)) ("i")) #(ribcage #(x) #((top)) #("i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))))
                                          (syntax-error
                                            x790
                                            '"invalid exports list in")))
                                    tmp795)
                                  ((lambda (tmp802)
                                     (if (if tmp802
                                             (apply
                                               (lambda (_806
                                                        m805
                                                        e804
                                                        d803)
                                                 (identifier? m805))
                                               tmp802)
                                             '#f)
                                         (apply
                                           (lambda (_810 m809 e808 d807)
                                             (if (andmap
                                                   proper-export?791
                                                   e808)
                                                 (cons '#(syntax-object $module ((top) #(ribcage #(_ m e d) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage #(orig) #((top)) #("i")) #(ribcage (proper-export?) ((top)) ("i")) #(ribcage #(x) #((top)) #("i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                       (cons orig793
                                                             (cons m809
                                                                   (cons e808
                                                                         d807))))
                                                 (syntax-error
                                                   x790
                                                   '"invalid exports list in")))
                                           tmp802)
                                         (syntax-error tmp794)))
                                   ($syntax-dispatch
                                     tmp794
                                     '(any any each-any . each-any)))))
                            ($syntax-dispatch
                              tmp794
                              '(any each-any . each-any))))
                         x790))
                      tmp792))
                   x790))))
            ((lambda ()
               (letrec (($module-exports597
                         (lambda (m786 r785)
                           ((lambda (b787)
                              ((lambda (t788)
                                 (if (memv t788 '($module))
                                     (vmap474
                                       (lambda (x789)
                                         (datum->syntax-object
                                           m786
                                           (syntax-object->datum
                                             (if (pair? x789)
                                                 (car x789)
                                                 x789))))
                                       (interface-exports441
                                         (binding-value286 b787)))
                                     (if (memv t788 '(displaced-lexical))
                                         (displaced-lexical-error303 m786)
                                         (syntax-error
                                           m786
                                           '"unknown module"))))
                               (binding-type285 b787)))
                            (r785 m786))))
                        ($import-help598
                         (lambda (orig602 import-only?601)
                           (lambda (r603)
                             (letrec ((difference604
                                       (lambda (ls1784 ls2783)
                                         (if (null? ls1784)
                                             ls1784
                                             (if (bound-id-member?430
                                                   (car ls1784)
                                                   ls2783)
                                                 (difference604
                                                   (cdr ls1784)
                                                   ls2783)
                                                 (cons (car ls1784)
                                                       (difference604
                                                         (cdr ls1784)
                                                         ls2783))))))
                                      (prefix-add605
                                       (lambda (prefix-id780)
                                         ((lambda (prefix781)
                                            (lambda (id782)
                                              (datum->syntax-object
                                                id782
                                                (string->symbol
                                                  (string-append
                                                    prefix781
                                                    (symbol->string
                                                      (syntax-object->datum
                                                        id782)))))))
                                          (symbol->string
                                            (syntax-object->datum
                                              prefix-id780)))))
                                      (prefix-drop606
                                       (lambda (prefix-id774)
                                         ((lambda (prefix775)
                                            (lambda (id776)
                                              ((lambda (s777)
                                                 ((lambda (np779 ns778)
                                                    (begin (if (not (if (>= ns778
                                                                            np779)
                                                                        (string=?
                                                                          (substring
                                                                            s777
                                                                            '0
                                                                            np779)
                                                                          prefix775)
                                                                        '#f))
                                                               (syntax-error
                                                                 id776
                                                                 (string-append
                                                                   '"missing expected prefix "
                                                                   prefix775))
                                                               (void))
                                                           (datum->syntax-object
                                                             id776
                                                             (string->symbol
                                                               (substring
                                                                 s777
                                                                 np779
                                                                 ns778)))))
                                                  (string-length prefix775)
                                                  (string-length s777)))
                                               (symbol->string
                                                 (syntax-object->datum
                                                   id776)))))
                                          (symbol->string
                                            (syntax-object->datum
                                              prefix-id774)))))
                                      (gen-mid607
                                       (lambda (mid773)
                                         (datum->syntax-object
                                           mid773
                                           (gensym))))
                                      (modspec608
                                       (lambda (m624 exports?623)
                                         ((lambda (tmp625)
                                            ((lambda (tmp626)
                                               (if tmp626
                                                   (apply
                                                     (lambda (orig628
                                                              import-only?627)
                                                       ((lambda (tmp629)
                                                          ((lambda (tmp630)
                                                             (if (if tmp630
                                                                     (apply
                                                                       (lambda (m632
                                                                                id631)
                                                                         (andmap
                                                                           identifier?
                                                                           id631))
                                                                       tmp630)
                                                                     '#f)
                                                                 (apply
                                                                   (lambda (m635
                                                                            id634)
                                                                     (call-with-values
                                                                       (lambda ()
                                                                         (modspec608
                                                                           m635
                                                                           '#f))
                                                                       (lambda (mid638
                                                                                d637
                                                                                exports636)
                                                                         ((lambda (tmp639)
                                                                            ((lambda (tmp640)
                                                                               (if tmp640
                                                                                   (apply
                                                                                     (lambda (d642
                                                                                              tmid641)
                                                                                       (values
                                                                                         mid638
                                                                                         (list '#(syntax-object begin ((top) #(ribcage #(d tmid) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                               (list '#(syntax-object $module ((top) #(ribcage #(d tmid) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                     orig628
                                                                                                     tmid641
                                                                                                     id634
                                                                                                     d642)
                                                                                               (list '#(syntax-object $import ((top) #(ribcage #(d tmid) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                     orig628
                                                                                                     import-only?627
                                                                                                     tmid641))
                                                                                         (if exports?623
                                                                                             id634
                                                                                             '#f)))
                                                                                     tmp640)
                                                                                   (syntax-error
                                                                                     tmp639)))
                                                                             ($syntax-dispatch
                                                                               tmp639
                                                                               '(any any))))
                                                                          (list d637
                                                                                (gen-mid607
                                                                                  mid638))))))
                                                                   tmp630)
                                                                 ((lambda (tmp645)
                                                                    (if (if tmp645
                                                                            (apply
                                                                              (lambda (m647
                                                                                       id646)
                                                                                (andmap
                                                                                  identifier?
                                                                                  id646))
                                                                              tmp645)
                                                                            '#f)
                                                                        (apply
                                                                          (lambda (m650
                                                                                   id649)
                                                                            (call-with-values
                                                                              (lambda ()
                                                                                (modspec608
                                                                                  m650
                                                                                  '#t))
                                                                              (lambda (mid653
                                                                                       d652
                                                                                       exports651)
                                                                                ((lambda (tmp654)
                                                                                   ((lambda (tmp656)
                                                                                      (if tmp656
                                                                                          (apply
                                                                                            (lambda (d659
                                                                                                     tmid658
                                                                                                     id657)
                                                                                              (values
                                                                                                mid653
                                                                                                (list '#(syntax-object begin ((top) #(ribcage #(d tmid id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                      (list '#(syntax-object $module ((top) #(ribcage #(d tmid id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                            orig628
                                                                                                            tmid658
                                                                                                            id657
                                                                                                            d659)
                                                                                                      (list '#(syntax-object $import ((top) #(ribcage #(d tmid id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                            orig628
                                                                                                            import-only?627
                                                                                                            tmid658))
                                                                                                (if exports?623
                                                                                                    id657
                                                                                                    '#f)))
                                                                                            tmp656)
                                                                                          (syntax-error
                                                                                            tmp654)))
                                                                                    ($syntax-dispatch
                                                                                      tmp654
                                                                                      '(any any
                                                                                            each-any))))
                                                                                 (list d652
                                                                                       (gen-mid607
                                                                                         mid653)
                                                                                       (difference604
                                                                                         exports651
                                                                                         id649))))))
                                                                          tmp645)
                                                                        ((lambda (tmp662)
                                                                           (if (if tmp662
                                                                                   (apply
                                                                                     (lambda (m664
                                                                                              prefix-id663)
                                                                                       (identifier?
                                                                                         prefix-id663))
                                                                                     tmp662)
                                                                                   '#f)
                                                                               (apply
                                                                                 (lambda (m666
                                                                                          prefix-id665)
                                                                                   (call-with-values
                                                                                     (lambda ()
                                                                                       (modspec608
                                                                                         m666
                                                                                         '#t))
                                                                                     (lambda (mid669
                                                                                              d668
                                                                                              exports667)
                                                                                       ((lambda (tmp670)
                                                                                          ((lambda (tmp671)
                                                                                             (if tmp671
                                                                                                 (apply
                                                                                                   (lambda (d676
                                                                                                            tmid675
                                                                                                            old-id674
                                                                                                            tmp673
                                                                                                            id672)
                                                                                                     (values
                                                                                                       mid669
                                                                                                       (list '#(syntax-object begin ((top) #(ribcage #(d tmid old-id tmp id) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m prefix-id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                             (cons '#(syntax-object $module ((top) #(ribcage #(d tmid old-id tmp id) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m prefix-id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                   (cons orig628
                                                                                                                         (cons tmid675
                                                                                                                               (cons (map list
                                                                                                                                          id672
                                                                                                                                          tmp673)
                                                                                                                                     (cons (cons '#(syntax-object $module ((top) #(ribcage #(d tmid old-id tmp id) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m prefix-id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                                 (cons orig628
                                                                                                                                                       (cons tmid675
                                                                                                                                                             (cons (map list
                                                                                                                                                                        tmp673
                                                                                                                                                                        old-id674)
                                                                                                                                                                   (cons d676
                                                                                                                                                                         (map (lambda (tmp683
                                                                                                                                                                                       tmp682)
                                                                                                                                                                                (list '#(syntax-object alias ((top) #(ribcage #(d tmid old-id tmp id) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m prefix-id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                                                                      tmp682
                                                                                                                                                                                      tmp683))
                                                                                                                                                                              old-id674
                                                                                                                                                                              tmp673))))))
                                                                                                                                           (cons (list '#(syntax-object $import ((top) #(ribcage #(d tmid old-id tmp id) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m prefix-id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                                       orig628
                                                                                                                                                       import-only?627
                                                                                                                                                       tmid675)
                                                                                                                                                 (map (lambda (tmp685
                                                                                                                                                               tmp684)
                                                                                                                                                        (list '#(syntax-object alias ((top) #(ribcage #(d tmid old-id tmp id) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m prefix-id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                                              tmp684
                                                                                                                                                              tmp685))
                                                                                                                                                      tmp673
                                                                                                                                                      id672)))))))
                                                                                                             (list '#(syntax-object $import ((top) #(ribcage #(d tmid old-id tmp id) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m prefix-id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                   orig628
                                                                                                                   import-only?627
                                                                                                                   tmid675))
                                                                                                       (if exports?623
                                                                                                           id672
                                                                                                           '#f)))
                                                                                                   tmp671)
                                                                                                 (syntax-error
                                                                                                   tmp670)))
                                                                                           ($syntax-dispatch
                                                                                             tmp670
                                                                                             '(any any
                                                                                                   each-any
                                                                                                   each-any
                                                                                                   each-any))))
                                                                                        (list d668
                                                                                              (gen-mid607
                                                                                                mid669)
                                                                                              exports667
                                                                                              (generate-temporaries
                                                                                                exports667)
                                                                                              (map (prefix-add605
                                                                                                     prefix-id665)
                                                                                                   exports667))))))
                                                                                 tmp662)
                                                                               ((lambda (tmp686)
                                                                                  (if (if tmp686
                                                                                          (apply
                                                                                            (lambda (m688
                                                                                                     prefix-id687)
                                                                                              (identifier?
                                                                                                prefix-id687))
                                                                                            tmp686)
                                                                                          '#f)
                                                                                      (apply
                                                                                        (lambda (m690
                                                                                                 prefix-id689)
                                                                                          (call-with-values
                                                                                            (lambda ()
                                                                                              (modspec608
                                                                                                m690
                                                                                                '#t))
                                                                                            (lambda (mid693
                                                                                                     d692
                                                                                                     exports691)
                                                                                              ((lambda (tmp694)
                                                                                                 ((lambda (tmp695)
                                                                                                    (if tmp695
                                                                                                        (apply
                                                                                                          (lambda (d700
                                                                                                                   tmid699
                                                                                                                   old-id698
                                                                                                                   tmp697
                                                                                                                   id696)
                                                                                                            (values
                                                                                                              mid693
                                                                                                              (list '#(syntax-object begin ((top) #(ribcage #(d tmid old-id tmp id) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m prefix-id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                    (cons '#(syntax-object $module ((top) #(ribcage #(d tmid old-id tmp id) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m prefix-id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                          (cons orig628
                                                                                                                                (cons tmid699
                                                                                                                                      (cons (map list
                                                                                                                                                 id696
                                                                                                                                                 tmp697)
                                                                                                                                            (cons (cons '#(syntax-object $module ((top) #(ribcage #(d tmid old-id tmp id) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m prefix-id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                                        (cons orig628
                                                                                                                                                              (cons tmid699
                                                                                                                                                                    (cons (map list
                                                                                                                                                                               tmp697
                                                                                                                                                                               old-id698)
                                                                                                                                                                          (cons d700
                                                                                                                                                                                (map (lambda (tmp707
                                                                                                                                                                                              tmp706)
                                                                                                                                                                                       (list '#(syntax-object alias ((top) #(ribcage #(d tmid old-id tmp id) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m prefix-id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                                                                             tmp706
                                                                                                                                                                                             tmp707))
                                                                                                                                                                                     old-id698
                                                                                                                                                                                     tmp697))))))
                                                                                                                                                  (cons (list '#(syntax-object $import ((top) #(ribcage #(d tmid old-id tmp id) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m prefix-id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                                              orig628
                                                                                                                                                              import-only?627
                                                                                                                                                              tmid699)
                                                                                                                                                        (map (lambda (tmp709
                                                                                                                                                                      tmp708)
                                                                                                                                                               (list '#(syntax-object alias ((top) #(ribcage #(d tmid old-id tmp id) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m prefix-id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                                                     tmp708
                                                                                                                                                                     tmp709))
                                                                                                                                                             tmp697
                                                                                                                                                             id696)))))))
                                                                                                                    (list '#(syntax-object $import ((top) #(ribcage #(d tmid old-id tmp id) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m prefix-id) #((top) (top)) #("i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                          orig628
                                                                                                                          import-only?627
                                                                                                                          tmid699))
                                                                                                              (if exports?623
                                                                                                                  id696
                                                                                                                  '#f)))
                                                                                                          tmp695)
                                                                                                        (syntax-error
                                                                                                          tmp694)))
                                                                                                  ($syntax-dispatch
                                                                                                    tmp694
                                                                                                    '(any any
                                                                                                          each-any
                                                                                                          each-any
                                                                                                          each-any))))
                                                                                               (list d692
                                                                                                     (gen-mid607
                                                                                                       mid693)
                                                                                                     exports691
                                                                                                     (generate-temporaries
                                                                                                       exports691)
                                                                                                     (map (prefix-drop606
                                                                                                            prefix-id689)
                                                                                                          exports691))))))
                                                                                        tmp686)
                                                                                      ((lambda (tmp710)
                                                                                         (if (if tmp710
                                                                                                 (apply
                                                                                                   (lambda (m713
                                                                                                            new-id712
                                                                                                            old-id711)
                                                                                                     (if (andmap
                                                                                                           identifier?
                                                                                                           new-id712)
                                                                                                         (andmap
                                                                                                           identifier?
                                                                                                           old-id711)
                                                                                                         '#f))
                                                                                                   tmp710)
                                                                                                 '#f)
                                                                                             (apply
                                                                                               (lambda (m718
                                                                                                        new-id717
                                                                                                        old-id716)
                                                                                                 (call-with-values
                                                                                                   (lambda ()
                                                                                                     (modspec608
                                                                                                       m718
                                                                                                       '#t))
                                                                                                   (lambda (mid721
                                                                                                            d720
                                                                                                            exports719)
                                                                                                     ((lambda (tmp722)
                                                                                                        ((lambda (tmp725)
                                                                                                           (if tmp725
                                                                                                               (apply
                                                                                                                 (lambda (d729
                                                                                                                          tmid728
                                                                                                                          tmp727
                                                                                                                          other-id726)
                                                                                                                   (values
                                                                                                                     mid721
                                                                                                                     (list '#(syntax-object begin ((top) #(ribcage #(d tmid tmp other-id) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m new-id old-id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                           (cons '#(syntax-object $module ((top) #(ribcage #(d tmid tmp other-id) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m new-id old-id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                 (cons orig628
                                                                                                                                       (cons tmid728
                                                                                                                                             (cons (append
                                                                                                                                                     (map list
                                                                                                                                                          new-id717
                                                                                                                                                          tmp727)
                                                                                                                                                     other-id726)
                                                                                                                                                   (cons (cons '#(syntax-object $module ((top) #(ribcage #(d tmid tmp other-id) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m new-id old-id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                                               (cons orig628
                                                                                                                                                                     (cons tmid728
                                                                                                                                                                           (cons (append
                                                                                                                                                                                   other-id726
                                                                                                                                                                                   (map list
                                                                                                                                                                                        tmp727
                                                                                                                                                                                        old-id716))
                                                                                                                                                                                 (cons d729
                                                                                                                                                                                       (map (lambda (tmp739
                                                                                                                                                                                                     tmp738)
                                                                                                                                                                                              (list '#(syntax-object alias ((top) #(ribcage #(d tmid tmp other-id) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m new-id old-id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                                                                                    tmp738
                                                                                                                                                                                                    tmp739))
                                                                                                                                                                                            old-id716
                                                                                                                                                                                            tmp727))))))
                                                                                                                                                         (cons (list '#(syntax-object $import ((top) #(ribcage #(d tmid tmp other-id) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m new-id old-id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                                                     orig628
                                                                                                                                                                     import-only?627
                                                                                                                                                                     tmid728)
                                                                                                                                                               (map (lambda (tmp741
                                                                                                                                                                             tmp740)
                                                                                                                                                                      (list '#(syntax-object alias ((top) #(ribcage #(d tmid tmp other-id) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m new-id old-id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                                                            tmp740
                                                                                                                                                                            tmp741))
                                                                                                                                                                    tmp727
                                                                                                                                                                    new-id717)))))))
                                                                                                                           (list '#(syntax-object $import ((top) #(ribcage #(d tmid tmp other-id) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m new-id old-id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                 orig628
                                                                                                                                 import-only?627
                                                                                                                                 tmid728))
                                                                                                                     (if exports?623
                                                                                                                         (append
                                                                                                                           new-id717
                                                                                                                           other-id726)
                                                                                                                         '#f)))
                                                                                                                 tmp725)
                                                                                                               (syntax-error
                                                                                                                 tmp722)))
                                                                                                         ($syntax-dispatch
                                                                                                           tmp722
                                                                                                           '(any any
                                                                                                                 each-any
                                                                                                                 each-any))))
                                                                                                      (list d720
                                                                                                            (gen-mid607
                                                                                                              mid721)
                                                                                                            (generate-temporaries
                                                                                                              old-id716)
                                                                                                            (difference604
                                                                                                              exports719
                                                                                                              old-id716))))))
                                                                                               tmp710)
                                                                                             ((lambda (tmp742)
                                                                                                (if (if tmp742
                                                                                                        (apply
                                                                                                          (lambda (m745
                                                                                                                   new-id744
                                                                                                                   old-id743)
                                                                                                            (if (andmap
                                                                                                                  identifier?
                                                                                                                  new-id744)
                                                                                                                (andmap
                                                                                                                  identifier?
                                                                                                                  old-id743)
                                                                                                                '#f))
                                                                                                          tmp742)
                                                                                                        '#f)
                                                                                                    (apply
                                                                                                      (lambda (m750
                                                                                                               new-id749
                                                                                                               old-id748)
                                                                                                        (call-with-values
                                                                                                          (lambda ()
                                                                                                            (modspec608
                                                                                                              m750
                                                                                                              '#t))
                                                                                                          (lambda (mid753
                                                                                                                   d752
                                                                                                                   exports751)
                                                                                                            ((lambda (tmp754)
                                                                                                               ((lambda (tmp755)
                                                                                                                  (if tmp755
                                                                                                                      (apply
                                                                                                                        (lambda (d758
                                                                                                                                 tmid757
                                                                                                                                 other-id756)
                                                                                                                          (values
                                                                                                                            mid753
                                                                                                                            (list '#(syntax-object begin ((top) #(ribcage #(d tmid other-id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m new-id old-id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                  (cons '#(syntax-object $module ((top) #(ribcage #(d tmid other-id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m new-id old-id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                        (cons orig628
                                                                                                                                              (cons tmid757
                                                                                                                                                    (cons (append
                                                                                                                                                            (map list
                                                                                                                                                                 new-id749
                                                                                                                                                                 old-id748)
                                                                                                                                                            other-id756)
                                                                                                                                                          (cons d758
                                                                                                                                                                (map (lambda (tmp765
                                                                                                                                                                              tmp764)
                                                                                                                                                                       (list '#(syntax-object alias ((top) #(ribcage #(d tmid other-id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m new-id old-id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                                                             tmp764
                                                                                                                                                                             tmp765))
                                                                                                                                                                     old-id748
                                                                                                                                                                     new-id749))))))
                                                                                                                                  (list '#(syntax-object $import ((top) #(ribcage #(d tmid other-id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(mid d exports) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(m new-id old-id) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                                        orig628
                                                                                                                                        import-only?627
                                                                                                                                        tmid757))
                                                                                                                            (if exports?623
                                                                                                                                (append
                                                                                                                                  new-id749
                                                                                                                                  other-id756)
                                                                                                                                '#f)))
                                                                                                                        tmp755)
                                                                                                                      (syntax-error
                                                                                                                        tmp754)))
                                                                                                                ($syntax-dispatch
                                                                                                                  tmp754
                                                                                                                  '(any any
                                                                                                                        each-any))))
                                                                                                             (list d752
                                                                                                                   (gen-mid607
                                                                                                                     mid753)
                                                                                                                   exports751)))))
                                                                                                      tmp742)
                                                                                                    ((lambda (tmp766)
                                                                                                       (if (if tmp766
                                                                                                               (apply
                                                                                                                 (lambda (mid767)
                                                                                                                   (identifier?
                                                                                                                     mid767))
                                                                                                                 tmp766)
                                                                                                               '#f)
                                                                                                           (apply
                                                                                                             (lambda (mid768)
                                                                                                               (values
                                                                                                                 mid768
                                                                                                                 (list '#(syntax-object $import ((top) #(ribcage #(mid) #((top)) #("i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                       orig628
                                                                                                                       import-only?627
                                                                                                                       mid768)
                                                                                                                 (if exports?623
                                                                                                                     ($module-exports597
                                                                                                                       mid768
                                                                                                                       r603)
                                                                                                                     '#f)))
                                                                                                             tmp766)
                                                                                                           ((lambda (tmp769)
                                                                                                              (if (if tmp769
                                                                                                                      (apply
                                                                                                                        (lambda (mid770)
                                                                                                                          (identifier?
                                                                                                                            mid770))
                                                                                                                        tmp769)
                                                                                                                      '#f)
                                                                                                                  (apply
                                                                                                                    (lambda (mid771)
                                                                                                                      (values
                                                                                                                        mid771
                                                                                                                        (list '#(syntax-object $import ((top) #(ribcage #(mid) #((top)) #("i")) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                                                                              orig628
                                                                                                                              import-only?627
                                                                                                                              mid771)
                                                                                                                        (if exports?623
                                                                                                                            ($module-exports597
                                                                                                                              mid771
                                                                                                                              r603)
                                                                                                                            '#f)))
                                                                                                                    tmp769)
                                                                                                                  ((lambda (_772)
                                                                                                                     (syntax-error
                                                                                                                       m624
                                                                                                                       '"invalid module specifier"))
                                                                                                                   tmp629)))
                                                                                                            ($syntax-dispatch
                                                                                                              tmp629
                                                                                                              '(any)))))
                                                                                                     (list tmp629))))
                                                                                              ($syntax-dispatch
                                                                                                tmp629
                                                                                                '(#(free-id
                                                                                                    #(syntax-object alias ((top) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                                                                                   any
                                                                                                   .
                                                                                                   #(each
                                                                                                     (any any)))))))
                                                                                       ($syntax-dispatch
                                                                                         tmp629
                                                                                         '(#(free-id
                                                                                             #(syntax-object rename ((top) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                                                                            any
                                                                                            .
                                                                                            #(each
                                                                                              (any any)))))))
                                                                                ($syntax-dispatch
                                                                                  tmp629
                                                                                  '(#(free-id
                                                                                      #(syntax-object drop-prefix ((top) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                                                                     any
                                                                                     any)))))
                                                                         ($syntax-dispatch
                                                                           tmp629
                                                                           '(#(free-id
                                                                               #(syntax-object add-prefix ((top) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                                                              any
                                                                              any)))))
                                                                  ($syntax-dispatch
                                                                    tmp629
                                                                    '(#(free-id
                                                                        #(syntax-object except ((top) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                                                       any
                                                                       .
                                                                       each-any)))))
                                                           ($syntax-dispatch
                                                             tmp629
                                                             '(#(free-id
                                                                 #(syntax-object only ((top) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(m exports?) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                                                any
                                                                .
                                                                each-any))))
                                                        m624))
                                                     tmp626)
                                                   (syntax-error tmp625)))
                                             ($syntax-dispatch
                                               tmp625
                                               '(any any))))
                                          (list orig602 import-only?601))))
                                      (modspec*609
                                       (lambda (m619)
                                         (call-with-values
                                           (lambda ()
                                             (modspec608 m619 '#f))
                                           (lambda (mid622 d621 exports620)
                                             d621)))))
                               ((lambda (tmp610)
                                  ((lambda (tmp611)
                                     (if tmp611
                                         (apply
                                           (lambda (_613 m612)
                                             ((lambda (tmp614)
                                                ((lambda (tmp616)
                                                   (if tmp616
                                                       (apply
                                                         (lambda (d617)
                                                           (cons '#(syntax-object begin ((top) #(ribcage #(d) #((top)) #("i")) #(ribcage #(_ m) #((top) (top)) #("i" "i")) #(ribcage (modspec* modspec gen-mid prefix-drop prefix-add difference) ((top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i")) #(ribcage #(r) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(orig import-only?) #((top) (top)) #("i" "i")) #(ribcage ($import-help $module-exports) ((top) (top)) ("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-begin parse-alias parse-eval-when parse-meta parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi chi-sequence chi-meta-frob chi-frobs ct-eval/residualize3 ct-eval/residualize2 rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports id-set-diff chi-top-module set-frob-meta?! set-frob-e! frob-meta? frob-e frob? make-frob create-module-binding set-module-binding-exported! set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-exported module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface2 make-resolved-interface1 make-unresolved-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-sequence chi-top* syntax-type chi-when-list source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks top-id-free-var-name top-id-bound-var-name anon same-marks? join-subst join-marks join-wraps smart-append resolved-id-var-name id->resolved-id make-resolved-id make-binding-wrap store-import-binding lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage barrier-marker new-mark anti-mark the-anti-mark set-env-wrap! set-env-top-ribcage! env-wrap env-top-ribcage env? make-env set-import-token-key! import-token-key import-token? make-import-token set-top-ribcage-mutable?! set-top-ribcage-key! top-ribcage-mutable? top-ribcage-key top-ribcage? make-top-ribcage set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label anon only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend defer-or-eval-transformer make-transformer-binding lookup lookup* displaced-lexical-error displaced-lexical? extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding sanitize-binding arg-check no-source unannotate self-evaluating? lexical-var? build-lexical-var build-top-module build-body build-letrec build-sequence build-data build-primref built-lambda? build-lambda build-revisit-only build-visit-only build-cte-install build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id put-import-binding get-import-binding read-only-binding? put-global-definition-hook get-global-definition-hook put-cte-hook gensym-hook error-hook define-top-level-value-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) ("m" top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                 d617))
                                                         tmp616)
                                                       (syntax-error
                                                         tmp614)))
                                                 ($syntax-dispatch
                                                   tmp614
                                                   'each-any)))
                                              (map modspec*609 m612)))
                                           tmp611)
                                         (syntax-error tmp610)))
                                   ($syntax-dispatch
                                     tmp610
                                     '(any . each-any))))
                                orig602))))))
                 (begin (put-cte-hook141
                          'import
                          (lambda (orig600) ($import-help598 orig600 '#f)))
                        (put-cte-hook141
                          'import-only
                          (lambda (orig599)
                            ($import-help598 orig599 '#t)))))))
            (set! sc-expand
              ((lambda (ctem594 rtem593)
                 (lambda (x595)
                   ((lambda (env596)
                      (if (if (pair? x595)
                              (equal? (car x595) noexpand62)
                              '#f)
                          (cadr x595)
                          (chi-top*435
                            x595
                            '()
                            (env-wrap379 env596)
                            ctem594
                            rtem593
                            '#f
                            (env-top-ribcage378 env596))))
                    (interaction-environment))))
               '(e)
               '(e)))
            (set! $make-environment
              (lambda (token591 mutable?590)
                ((lambda (top-ribcage592)
                   (make-env376
                     top-ribcage592
                     (make-wrap317
                       (wrap-marks318 '((top)))
                       (cons top-ribcage592 (wrap-subst319 '((top)))))))
                 (make-top-ribcage366 token591 mutable?590))))
            (set! environment? (lambda (x589) (env?377 x589)))
            (set! interaction-environment
              ((lambda (e588) (lambda () e588))
               ($make-environment '*top* '#t)))
            (set! identifier? (lambda (x587) (nonsymbol-id?309 x587)))
            (set! datum->syntax-object
              (lambda (id585 datum584)
                (begin ((lambda (x586)
                          (if (not (nonsymbol-id?309 x586))
                              (error-hook136
                                'datum->syntax-object
                                '"invalid argument"
                                x586)
                              (void)))
                        id585)
                       (make-syntax-object63
                         datum584
                         (syntax-object-wrap66 id585)))))
            (set! syntax-object->datum
              (lambda (x583) (strip507 x583 '(()))))
            (set! generate-temporaries
              (lambda (ls580)
                (begin ((lambda (x582)
                          (if (not (list? x582))
                              (error-hook136
                                'generate-temporaries
                                '"invalid argument"
                                x582)
                              (void)))
                        ls580)
                       (map (lambda (x581) (wrap431 (gensym) '((top))))
                            ls580))))
            (set! free-identifier=?
              (lambda (x577 y576)
                (begin ((lambda (x579)
                          (if (not (nonsymbol-id?309 x579))
                              (error-hook136
                                'free-identifier=?
                                '"invalid argument"
                                x579)
                              (void)))
                        x577)
                       ((lambda (x578)
                          (if (not (nonsymbol-id?309 x578))
                              (error-hook136
                                'free-identifier=?
                                '"invalid argument"
                                x578)
                              (void)))
                        y576)
                       (free-id=?424 x577 y576))))
            (set! bound-identifier=?
              (lambda (x573 y572)
                (begin ((lambda (x575)
                          (if (not (nonsymbol-id?309 x575))
                              (error-hook136
                                'bound-identifier=?
                                '"invalid argument"
                                x575)
                              (void)))
                        x573)
                       ((lambda (x574)
                          (if (not (nonsymbol-id?309 x574))
                              (error-hook136
                                'bound-identifier=?
                                '"invalid argument"
                                x574)
                              (void)))
                        y572)
                       (bound-id=?426 x573 y572))))
            (set! literal-identifier=?
              (lambda (x569 y568)
                (begin ((lambda (x571)
                          (if (not (nonsymbol-id?309 x571))
                              (error-hook136
                                'literal-identifier=?
                                '"invalid argument"
                                x571)
                              (void)))
                        x569)
                       ((lambda (x570)
                          (if (not (nonsymbol-id?309 x570))
                              (error-hook136
                                'literal-identifier=?
                                '"invalid argument"
                                x570)
                              (void)))
                        y568)
                       (literal-id=?425 x569 y568))))
            (set! syntax-error
              (lambda (object563 . messages564)
                (begin (for-each
                         (lambda (x566)
                           ((lambda (x567)
                              (if (not (string? x567))
                                  (error-hook136
                                    'syntax-error
                                    '"invalid argument"
                                    x567)
                                  (void)))
                            x566))
                         messages564)
                       ((lambda (message565)
                          (error-hook136
                            '#f
                            message565
                            (strip507 object563 '(()))))
                        (if (null? messages564)
                            '"invalid syntax"
                            (apply string-append messages564))))))
            ((lambda ()
               (letrec ((match-each510
                         (lambda (e560 p559 w558)
                           (if (annotation?132 e560)
                               (match-each510
                                 (annotation-expression e560)
                                 p559
                                 w558)
                               (if (pair? e560)
                                   ((lambda (first561)
                                      (if first561
                                          ((lambda (rest562)
                                             (if rest562
                                                 (cons first561 rest562)
                                                 '#f))
                                           (match-each510
                                             (cdr e560)
                                             p559
                                             w558))
                                          '#f))
                                    (match516 (car e560) p559 w558 '()))
                                   (if (null? e560)
                                       '()
                                       (if (syntax-object?64 e560)
                                           (match-each510
                                             (syntax-object-expression65
                                               e560)
                                             p559
                                             (join-wraps412
                                               w558
                                               (syntax-object-wrap66
                                                 e560)))
                                           '#f))))))
                        (match-each+511
                         (lambda (e550
                                  x-pat549
                                  y-pat548
                                  z-pat547
                                  w546
                                  r545)
                           ((letrec ((f551
                                      (lambda (e553 w552)
                                        (if (pair? e553)
                                            (call-with-values
                                              (lambda ()
                                                (f551 (cdr e553) w552))
                                              (lambda (xr*556
                                                       y-pat555
                                                       r554)
                                                (if r554
                                                    (if (null? y-pat555)
                                                        ((lambda (xr557)
                                                           (if xr557
                                                               (values
                                                                 (cons xr557
                                                                       xr*556)
                                                                 y-pat555
                                                                 r554)
                                                               (values
                                                                 '#f
                                                                 '#f
                                                                 '#f)))
                                                         (match516
                                                           (car e553)
                                                           x-pat549
                                                           w552
                                                           '()))
                                                        (values
                                                          '()
                                                          (cdr y-pat555)
                                                          (match516
                                                            (car e553)
                                                            (car y-pat555)
                                                            w552
                                                            r554)))
                                                    (values '#f '#f '#f))))
                                            (if (annotation?132 e553)
                                                (f551 (annotation-expression
                                                        e553)
                                                      w552)
                                                (if (syntax-object?64 e553)
                                                    (f551 (syntax-object-expression65
                                                            e553)
                                                          (join-wraps412
                                                            w552
                                                            (syntax-object-wrap66
                                                              e553)))
                                                    (values
                                                      '()
                                                      y-pat548
                                                      (match516
                                                        e553
                                                        z-pat547
                                                        w552
                                                        r545))))))))
                              f551)
                            e550
                            w546)))
                        (match-each-any512
                         (lambda (e543 w542)
                           (if (annotation?132 e543)
                               (match-each-any512
                                 (annotation-expression e543)
                                 w542)
                               (if (pair? e543)
                                   ((lambda (l544)
                                      (if l544
                                          (cons (wrap431 (car e543) w542)
                                                l544)
                                          '#f))
                                    (match-each-any512 (cdr e543) w542))
                                   (if (null? e543)
                                       '()
                                       (if (syntax-object?64 e543)
                                           (match-each-any512
                                             (syntax-object-expression65
                                               e543)
                                             (join-wraps412
                                               w542
                                               (syntax-object-wrap66
                                                 e543)))
                                           '#f))))))
                        (match-empty513
                         (lambda (p540 r539)
                           (if (null? p540)
                               r539
                               (if (eq? p540 'any)
                                   (cons '() r539)
                                   (if (pair? p540)
                                       (match-empty513
                                         (car p540)
                                         (match-empty513 (cdr p540) r539))
                                       (if (eq? p540 'each-any)
                                           (cons '() r539)
                                           ((lambda (t541)
                                              (if (memv t541 '(each))
                                                  (match-empty513
                                                    (vector-ref p540 '1)
                                                    r539)
                                                  (if (memv t541 '(each+))
                                                      (match-empty513
                                                        (vector-ref
                                                          p540
                                                          '1)
                                                        (match-empty513
                                                          (reverse
                                                            (vector-ref
                                                              p540
                                                              '2))
                                                          (match-empty513
                                                            (vector-ref
                                                              p540
                                                              '3)
                                                            r539)))
                                                      (if (memv t541
                                                                '(free-id
                                                                   atom))
                                                          r539
                                                          (if (memv t541
                                                                    '(vector))
                                                              (match-empty513
                                                                (vector-ref
                                                                  p540
                                                                  '1)
                                                                r539)
                                                              (void))))))
                                            (vector-ref p540 '0))))))))
                        (combine514
                         (lambda (r*538 r537)
                           (if (null? (car r*538))
                               r537
                               (cons (map car r*538)
                                     (combine514 (map cdr r*538) r537)))))
                        (match*515
                         (lambda (e530 p529 w528 r527)
                           (if (null? p529)
                               (if (null? e530) r527 '#f)
                               (if (pair? p529)
                                   (if (pair? e530)
                                       (match516
                                         (car e530)
                                         (car p529)
                                         w528
                                         (match516
                                           (cdr e530)
                                           (cdr p529)
                                           w528
                                           r527))
                                       '#f)
                                   (if (eq? p529 'each-any)
                                       ((lambda (l531)
                                          (if l531 (cons l531 r527) '#f))
                                        (match-each-any512 e530 w528))
                                       ((lambda (t532)
                                          (if (memv t532 '(each))
                                              (if (null? e530)
                                                  (match-empty513
                                                    (vector-ref p529 '1)
                                                    r527)
                                                  ((lambda (r*533)
                                                     (if r*533
                                                         (combine514
                                                           r*533
                                                           r527)
                                                         '#f))
                                                   (match-each510
                                                     e530
                                                     (vector-ref p529 '1)
                                                     w528)))
                                              (if (memv t532 '(free-id))
                                                  (if (id?310 e530)
                                                      (if (literal-id=?425
                                                            (wrap431
                                                              e530
                                                              w528)
                                                            (vector-ref
                                                              p529
                                                              '1))
                                                          r527
                                                          '#f)
                                                      '#f)
                                                  (if (memv t532 '(each+))
                                                      (call-with-values
                                                        (lambda ()
                                                          (match-each+511
                                                            e530
                                                            (vector-ref
                                                              p529
                                                              '1)
                                                            (vector-ref
                                                              p529
                                                              '2)
                                                            (vector-ref
                                                              p529
                                                              '3)
                                                            w528
                                                            r527))
                                                        (lambda (xr*536
                                                                 y-pat535
                                                                 r534)
                                                          (if r534
                                                              (if (null?
                                                                    y-pat535)
                                                                  (if (null?
                                                                        xr*536)
                                                                      (match-empty513
                                                                        (vector-ref
                                                                          p529
                                                                          '1)
                                                                        r534)
                                                                      (combine514
                                                                        xr*536
                                                                        r534))
                                                                  '#f)
                                                              '#f)))
                                                      (if (memv t532
                                                                '(atom))
                                                          (if (equal?
                                                                (vector-ref
                                                                  p529
                                                                  '1)
                                                                (strip507
                                                                  e530
                                                                  w528))
                                                              r527
                                                              '#f)
                                                          (if (memv t532
                                                                    '(vector))
                                                              (if (vector?
                                                                    e530)
                                                                  (match516
                                                                    (vector->list
                                                                      e530)
                                                                    (vector-ref
                                                                      p529
                                                                      '1)
                                                                    w528
                                                                    r527)
                                                                  '#f)
                                                              (void)))))))
                                        (vector-ref p529 '0)))))))
                        (match516
                         (lambda (e524 p523 w522 r521)
                           (if (not r521)
                               '#f
                               (if (eq? p523 'any)
                                   (cons (wrap431 e524 w522) r521)
                                   (if (syntax-object?64 e524)
                                       (match*515
                                         ((lambda (e525)
                                            (if (annotation?132 e525)
                                                (annotation-expression
                                                  e525)
                                                e525))
                                          (syntax-object-expression65
                                            e524))
                                         p523
                                         (join-wraps412
                                           w522
                                           (syntax-object-wrap66 e524))
                                         r521)
                                       (match*515
                                         ((lambda (e526)
                                            (if (annotation?132 e526)
                                                (annotation-expression
                                                  e526)
                                                e526))
                                          e524)
                                         p523
                                         w522
                                         r521)))))))
                 (set! $syntax-dispatch
                   (lambda (e518 p517)
                     (if (eq? p517 'any)
                         (list e518)
                         (if (syntax-object?64 e518)
                             (match*515
                               ((lambda (e519)
                                  (if (annotation?132 e519)
                                      (annotation-expression e519)
                                      e519))
                                (syntax-object-expression65 e518))
                               p517
                               (syntax-object-wrap66 e518)
                               '())
                             (match*515
                               ((lambda (e520)
                                  (if (annotation?132 e520)
                                      (annotation-expression e520)
                                      e520))
                                e518)
                               p517
                               '(())
                               '()))))))))))))
($sc-put-cte
  '#(syntax-object with-syntax ((top) #(ribcage #(with-syntax) #((top)) #(with-syntax))))
  (lambda (x2424)
    ((lambda (tmp2425)
       ((lambda (tmp2426)
          (if tmp2426
              (apply
                (lambda (_2429 e12428 e22427)
                  (cons '#(syntax-object begin ((top) #(ribcage #(_ e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                        (cons e12428 e22427)))
                tmp2426)
              ((lambda (tmp2431)
                 (if tmp2431
                     (apply
                       (lambda (_2436 out2435 in2434 e12433 e22432)
                         (list '#(syntax-object syntax-case ((top) #(ribcage #(_ out in e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                               in2434
                               '()
                               (list out2435
                                     (cons '#(syntax-object begin ((top) #(ribcage #(_ out in e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                           (cons e12433 e22432)))))
                       tmp2431)
                     ((lambda (tmp2438)
                        (if tmp2438
                            (apply
                              (lambda (_2443 out2442 in2441 e12440 e22439)
                                (list '#(syntax-object syntax-case ((top) #(ribcage #(_ out in e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                      (cons '#(syntax-object list ((top) #(ribcage #(_ out in e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                            in2441)
                                      '()
                                      (list out2442
                                            (cons '#(syntax-object begin ((top) #(ribcage #(_ out in e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                  (cons e12440 e22439)))))
                              tmp2438)
                            (syntax-error tmp2425)))
                      ($syntax-dispatch
                        tmp2425
                        '(any #(each (any any)) any . each-any)))))
               ($syntax-dispatch
                 tmp2425
                 '(any ((any any)) any . each-any)))))
        ($syntax-dispatch tmp2425 '(any () any . each-any))))
     x2424))
  '*top*)
($sc-put-cte
  '#(syntax-object syntax-rules ((top) #(ribcage #(syntax-rules) #((top)) #(syntax-rules))))
  (lambda (x2447)
    ((lambda (tmp2448)
       ((lambda (tmp2449)
          (if tmp2449
              (apply
                (lambda (_2454 k2453 keyword2452 pattern2451 template2450)
                  (list '#(syntax-object lambda ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                        '#(syntax-object (x) ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                        (cons '#(syntax-object syntax-case ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                              (cons '#(syntax-object x ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                    (cons k2453
                                          (map (lambda (tmp2457 tmp2456)
                                                 (list (cons '#(syntax-object dummy ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                             tmp2456)
                                                       (list '#(syntax-object syntax ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                             tmp2457)))
                                               template2450
                                               pattern2451))))))
                tmp2449)
              (syntax-error tmp2448)))
        ($syntax-dispatch
          tmp2448
          '(any each-any . #(each ((any . any) any))))))
     x2447))
  '*top*)
($sc-put-cte
  '#(syntax-object or ((top) #(ribcage #(or) #((top)) #(or))))
  (lambda (x2458)
    ((lambda (tmp2459)
       ((lambda (tmp2460)
          (if tmp2460
              (apply
                (lambda (_2461)
                  '#(syntax-object #f ((top) #(ribcage #(_) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                tmp2460)
              ((lambda (tmp2462)
                 (if tmp2462
                     (apply (lambda (_2464 e2463) e2463) tmp2462)
                     ((lambda (tmp2465)
                        (if tmp2465
                            (apply
                              (lambda (_2469 e12468 e22467 e32466)
                                (list '#(syntax-object let ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                      (list (list '#(syntax-object t ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                  e12468))
                                      (list '#(syntax-object if ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                            '#(syntax-object t ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                            '#(syntax-object t ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                            (cons '#(syntax-object or ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                  (cons e22467 e32466)))))
                              tmp2465)
                            (syntax-error tmp2459)))
                      ($syntax-dispatch
                        tmp2459
                        '(any any any . each-any)))))
               ($syntax-dispatch tmp2459 '(any any)))))
        ($syntax-dispatch tmp2459 '(any))))
     x2458))
  '*top*)
($sc-put-cte
  '#(syntax-object and ((top) #(ribcage #(and) #((top)) #(and))))
  (lambda (x2471)
    ((lambda (tmp2472)
       ((lambda (tmp2473)
          (if tmp2473
              (apply
                (lambda (_2477 e12476 e22475 e32474)
                  (cons '#(syntax-object if ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                        (cons e12476
                              (cons (cons '#(syntax-object and ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                          (cons e22475 e32474))
                                    '#(syntax-object (#f) ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))))))
                tmp2473)
              ((lambda (tmp2479)
                 (if tmp2479
                     (apply (lambda (_2481 e2480) e2480) tmp2479)
                     ((lambda (tmp2482)
                        (if tmp2482
                            (apply
                              (lambda (_2483)
                                '#(syntax-object #t ((top) #(ribcage #(_) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                              tmp2482)
                            (syntax-error tmp2472)))
                      ($syntax-dispatch tmp2472 '(any)))))
               ($syntax-dispatch tmp2472 '(any any)))))
        ($syntax-dispatch tmp2472 '(any any any . each-any))))
     x2471))
  '*top*)
($sc-put-cte
  '#(syntax-object let ((top) #(ribcage #(let) #((top)) #(let))))
  (lambda (x2484)
    ((lambda (tmp2485)
       ((lambda (tmp2486)
          (if (if tmp2486
                  (apply
                    (lambda (_2491 x2490 v2489 e12488 e22487)
                      (andmap identifier? x2490))
                    tmp2486)
                  '#f)
              (apply
                (lambda (_2497 x2496 v2495 e12494 e22493)
                  (cons (cons '#(syntax-object lambda ((top) #(ribcage #(_ x v e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                              (cons x2496 (cons e12494 e22493)))
                        v2495))
                tmp2486)
              ((lambda (tmp2501)
                 (if (if tmp2501
                         (apply
                           (lambda (_2507 f2506 x2505 v2504 e12503 e22502)
                             (andmap identifier? (cons f2506 x2505)))
                           tmp2501)
                         '#f)
                     (apply
                       (lambda (_2514 f2513 x2512 v2511 e12510 e22509)
                         (cons (list '#(syntax-object letrec ((top) #(ribcage #(_ f x v e1 e2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                     (list (list f2513
                                                 (cons '#(syntax-object lambda ((top) #(ribcage #(_ f x v e1 e2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       (cons x2512
                                                             (cons e12510
                                                                   e22509)))))
                                     f2513)
                               v2511))
                       tmp2501)
                     (syntax-error tmp2485)))
               ($syntax-dispatch
                 tmp2485
                 '(any any #(each (any any)) any . each-any)))))
        ($syntax-dispatch
          tmp2485
          '(any #(each (any any)) any . each-any))))
     x2484))
  '*top*)
($sc-put-cte
  '#(syntax-object let* ((top) #(ribcage #(let*) #((top)) #(let*))))
  (lambda (x2518)
    ((lambda (tmp2519)
       ((lambda (tmp2520)
          (if (if tmp2520
                  (apply
                    (lambda (let*2525 x2524 v2523 e12522 e22521)
                      (andmap identifier? x2524))
                    tmp2520)
                  '#f)
              (apply
                (lambda (let*2531 x2530 v2529 e12528 e22527)
                  ((letrec ((f2532
                             (lambda (bindings2533)
                               (if (null? bindings2533)
                                   (cons '#(syntax-object let ((top) #(ribcage () () ()) #(ribcage #(bindings) #((top)) #("i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(let* x v e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                         (cons '() (cons e12528 e22527)))
                                   ((lambda (tmp2535)
                                      ((lambda (tmp2536)
                                         (if tmp2536
                                             (apply
                                               (lambda (body2538
                                                        binding2537)
                                                 (list '#(syntax-object let ((top) #(ribcage #(body binding) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(bindings) #((top)) #("i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(let* x v e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       (list binding2537)
                                                       body2538))
                                               tmp2536)
                                             (syntax-error tmp2535)))
                                       ($syntax-dispatch
                                         tmp2535
                                         '(any any))))
                                    (list (f2532 (cdr bindings2533))
                                          (car bindings2533)))))))
                     f2532)
                   (map list x2530 v2529)))
                tmp2520)
              (syntax-error tmp2519)))
        ($syntax-dispatch
          tmp2519
          '(any #(each (any any)) any . each-any))))
     x2518))
  '*top*)
($sc-put-cte
  '#(syntax-object cond ((top) #(ribcage #(cond) #((top)) #(cond))))
  (lambda (x2541)
    ((lambda (tmp2542)
       ((lambda (tmp2543)
          (if tmp2543
              (apply
                (lambda (_2546 m12545 m22544)
                  ((letrec ((f2547
                             (lambda (clause2549 clauses2548)
                               (if (null? clauses2548)
                                   ((lambda (tmp2550)
                                      ((lambda (tmp2551)
                                         (if tmp2551
                                             (apply
                                               (lambda (e12553 e22552)
                                                 (cons '#(syntax-object begin ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       (cons e12553
                                                             e22552)))
                                               tmp2551)
                                             ((lambda (tmp2555)
                                                (if tmp2555
                                                    (apply
                                                      (lambda (e02556)
                                                        (cons '#(syntax-object let ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                              (cons (list (list '#(syntax-object t ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                                e02556))
                                                                    '#(syntax-object ((if t t)) ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))))
                                                      tmp2555)
                                                    ((lambda (tmp2557)
                                                       (if tmp2557
                                                           (apply
                                                             (lambda (e02559
                                                                      e12558)
                                                               (list '#(syntax-object let ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                     (list (list '#(syntax-object t ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                                 e02559))
                                                                     (list '#(syntax-object if ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                           '#(syntax-object t ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                           (cons e12558
                                                                                 '#(syntax-object (t) ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))))))
                                                             tmp2557)
                                                           ((lambda (tmp2560)
                                                              (if tmp2560
                                                                  (apply
                                                                    (lambda (e02563
                                                                             e12562
                                                                             e22561)
                                                                      (list '#(syntax-object if ((top) #(ribcage #(e0 e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                            e02563
                                                                            (cons '#(syntax-object begin ((top) #(ribcage #(e0 e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                                  (cons e12562
                                                                                        e22561))))
                                                                    tmp2560)
                                                                  ((lambda (_2565)
                                                                     (syntax-error
                                                                       x2541))
                                                                   tmp2550)))
                                                            ($syntax-dispatch
                                                              tmp2550
                                                              '(any any
                                                                    .
                                                                    each-any)))))
                                                     ($syntax-dispatch
                                                       tmp2550
                                                       '(any #(free-id
                                                               #(syntax-object => ((top) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                                                             any)))))
                                              ($syntax-dispatch
                                                tmp2550
                                                '(any)))))
                                       ($syntax-dispatch
                                         tmp2550
                                         '(#(free-id
                                             #(syntax-object else ((top) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                                            any
                                            .
                                            each-any))))
                                    clause2549)
                                   ((lambda (tmp2566)
                                      ((lambda (rest2567)
                                         ((lambda (tmp2568)
                                            ((lambda (tmp2569)
                                               (if tmp2569
                                                   (apply
                                                     (lambda (e02570)
                                                       (list '#(syntax-object let ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                             (list (list '#(syntax-object t ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                         e02570))
                                                             (list '#(syntax-object if ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                   '#(syntax-object t ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                   '#(syntax-object t ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                   rest2567)))
                                                     tmp2569)
                                                   ((lambda (tmp2571)
                                                      (if tmp2571
                                                          (apply
                                                            (lambda (e02573
                                                                     e12572)
                                                              (list '#(syntax-object let ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                    (list (list '#(syntax-object t ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                                e02573))
                                                                    (list '#(syntax-object if ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                          '#(syntax-object t ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                          (cons e12572
                                                                                '#(syntax-object (t) ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                                                                          rest2567)))
                                                            tmp2571)
                                                          ((lambda (tmp2574)
                                                             (if tmp2574
                                                                 (apply
                                                                   (lambda (e02577
                                                                            e12576
                                                                            e22575)
                                                                     (list '#(syntax-object if ((top) #(ribcage #(e0 e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                           e02577
                                                                           (cons '#(syntax-object begin ((top) #(ribcage #(e0 e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                                 (cons e12576
                                                                                       e22575))
                                                                           rest2567))
                                                                   tmp2574)
                                                                 ((lambda (_2579)
                                                                    (syntax-error
                                                                      x2541))
                                                                  tmp2568)))
                                                           ($syntax-dispatch
                                                             tmp2568
                                                             '(any any
                                                                   .
                                                                   each-any)))))
                                                    ($syntax-dispatch
                                                      tmp2568
                                                      '(any #(free-id
                                                              #(syntax-object => ((top) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                                                            any)))))
                                             ($syntax-dispatch
                                               tmp2568
                                               '(any))))
                                          clause2549))
                                       tmp2566))
                                    (f2547
                                      (car clauses2548)
                                      (cdr clauses2548)))))))
                     f2547)
                   m12545
                   m22544))
                tmp2543)
              (syntax-error tmp2542)))
        ($syntax-dispatch tmp2542 '(any any . each-any))))
     x2541))
  '*top*)
($sc-put-cte
  '#(syntax-object do ((top) #(ribcage #(do) #((top)) #(do))))
  (lambda (orig-x2581)
    ((lambda (tmp2582)
       ((lambda (tmp2583)
          (if tmp2583
              (apply
                (lambda (_2590
                         var2589
                         init2588
                         step2587
                         e02586
                         e12585
                         c2584)
                  ((lambda (tmp2591)
                     ((lambda (tmp2601)
                        (if tmp2601
                            (apply
                              (lambda (step2602)
                                ((lambda (tmp2603)
                                   ((lambda (tmp2605)
                                      (if tmp2605
                                          (apply
                                            (lambda ()
                                              (list '#(syntax-object let ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                    '#(syntax-object do ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                    (map list
                                                         var2589
                                                         init2588)
                                                    (list '#(syntax-object if ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                          (list '#(syntax-object not ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                e02586)
                                                          (cons '#(syntax-object begin ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                (append
                                                                  c2584
                                                                  (list (cons '#(syntax-object do ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                              step2602)))))))
                                            tmp2605)
                                          ((lambda (tmp2610)
                                             (if tmp2610
                                                 (apply
                                                   (lambda (e12612 e22611)
                                                     (list '#(syntax-object let ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                           '#(syntax-object do ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                           (map list
                                                                var2589
                                                                init2588)
                                                           (list '#(syntax-object if ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                 e02586
                                                                 (cons '#(syntax-object begin ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                       (cons e12612
                                                                             e22611))
                                                                 (cons '#(syntax-object begin ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                       (append
                                                                         c2584
                                                                         (list (cons '#(syntax-object do ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                                     step2602)))))))
                                                   tmp2610)
                                                 (syntax-error tmp2603)))
                                           ($syntax-dispatch
                                             tmp2603
                                             '(any . each-any)))))
                                    ($syntax-dispatch tmp2603 '())))
                                 e12585))
                              tmp2601)
                            (syntax-error tmp2591)))
                      ($syntax-dispatch tmp2591 'each-any)))
                   (map (lambda (v2595 s2594)
                          ((lambda (tmp2596)
                             ((lambda (tmp2597)
                                (if tmp2597
                                    (apply (lambda () v2595) tmp2597)
                                    ((lambda (tmp2598)
                                       (if tmp2598
                                           (apply
                                             (lambda (e2599) e2599)
                                             tmp2598)
                                           ((lambda (_2600)
                                              (syntax-error orig-x2581))
                                            tmp2596)))
                                     ($syntax-dispatch tmp2596 '(any)))))
                              ($syntax-dispatch tmp2596 '())))
                           s2594))
                        var2589
                        step2587)))
                tmp2583)
              (syntax-error tmp2582)))
        ($syntax-dispatch
          tmp2582
          '(any #(each (any any . any))
                (any . each-any)
                .
                each-any))))
     orig-x2581))
  '*top*)
($sc-put-cte
  '#(syntax-object quasiquote ((top) #(ribcage #(quasiquote) #((top)) #(quasiquote))))
  (letrec ((isquote?2626
            (lambda (x2738)
              (if (identifier? x2738)
                  (free-identifier=?
                    x2738
                    '#(syntax-object quote ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                  '#f)))
           (islist?2625
            (lambda (x2737)
              (if (identifier? x2737)
                  (free-identifier=?
                    x2737
                    '#(syntax-object list ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                  '#f)))
           (iscons?2624
            (lambda (x2736)
              (if (identifier? x2736)
                  (free-identifier=?
                    x2736
                    '#(syntax-object cons ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                  '#f)))
           (quote-nil?2623
            (lambda (x2731)
              ((lambda (tmp2732)
                 ((lambda (tmp2733)
                    (if tmp2733
                        (apply
                          (lambda (quote?2734) (isquote?2626 quote?2734))
                          tmp2733)
                        ((lambda (_2735) '#f) tmp2732)))
                  ($syntax-dispatch tmp2732 '(any ()))))
               x2731)))
           (quasilist*2622
            (lambda (x2728 y2727)
              ((letrec ((f2729
                         (lambda (x2730)
                           (if (null? x2730)
                               y2727
                               (quasicons2621
                                 (car x2730)
                                 (f2729 (cdr x2730)))))))
                 f2729)
               x2728)))
           (quasicons2621
            (lambda (x2703 y2702)
              ((lambda (tmp2704)
                 ((lambda (tmp2705)
                    (if tmp2705
                        (apply
                          (lambda (x2707 y2706)
                            ((lambda (tmp2708)
                               ((lambda (tmp2709)
                                  (if (if tmp2709
                                          (apply
                                            (lambda (quote?2711 dy2710)
                                              (isquote?2626 quote?2711))
                                            tmp2709)
                                          '#f)
                                      (apply
                                        (lambda (quote?2713 dy2712)
                                          ((lambda (tmp2714)
                                             ((lambda (tmp2715)
                                                (if (if tmp2715
                                                        (apply
                                                          (lambda (quote?2717
                                                                   dx2716)
                                                            (isquote?2626
                                                              quote?2717))
                                                          tmp2715)
                                                        '#f)
                                                    (apply
                                                      (lambda (quote?2719
                                                               dx2718)
                                                        (list '#(syntax-object quote ((top) #(ribcage #(quote? dx) #((top) (top)) #("i" "i")) #(ribcage #(quote? dy) #((top) (top)) #("i" "i")) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                              (cons dx2718
                                                                    dy2712)))
                                                      tmp2715)
                                                    ((lambda (_2720)
                                                       (if (null? dy2712)
                                                           (list '#(syntax-object list ((top) #(ribcage #(_) #((top)) #("i")) #(ribcage #(quote? dy) #((top) (top)) #("i" "i")) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                 x2707)
                                                           (list '#(syntax-object cons ((top) #(ribcage #(_) #((top)) #("i")) #(ribcage #(quote? dy) #((top) (top)) #("i" "i")) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                 x2707
                                                                 y2706)))
                                                     tmp2714)))
                                              ($syntax-dispatch
                                                tmp2714
                                                '(any any))))
                                           x2707))
                                        tmp2709)
                                      ((lambda (tmp2721)
                                         (if (if tmp2721
                                                 (apply
                                                   (lambda (listp2723
                                                            stuff2722)
                                                     (islist?2625
                                                       listp2723))
                                                   tmp2721)
                                                 '#f)
                                             (apply
                                               (lambda (listp2725
                                                        stuff2724)
                                                 (cons '#(syntax-object list ((top) #(ribcage #(listp stuff) #((top) (top)) #("i" "i")) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                       (cons x2707
                                                             stuff2724)))
                                               tmp2721)
                                             ((lambda (else2726)
                                                (list '#(syntax-object cons ((top) #(ribcage #(else) #((top)) #("i")) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                      x2707
                                                      y2706))
                                              tmp2708)))
                                       ($syntax-dispatch
                                         tmp2708
                                         '(any . any)))))
                                ($syntax-dispatch tmp2708 '(any any))))
                             y2706))
                          tmp2705)
                        (syntax-error tmp2704)))
                  ($syntax-dispatch tmp2704 '(any any))))
               (list x2703 y2702))))
           (quasiappend2620
            (lambda (x2694 y2693)
              ((lambda (ls2695)
                 (if (null? ls2695)
                     '#(syntax-object (quote ()) ((top) #(ribcage () () ()) #(ribcage #(ls) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                     (if (null? (cdr ls2695))
                         (car ls2695)
                         ((lambda (tmp2696)
                            ((lambda (tmp2697)
                               (if tmp2697
                                   (apply
                                     (lambda (p2698)
                                       (cons '#(syntax-object append ((top) #(ribcage #(p) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(ls) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                             p2698))
                                     tmp2697)
                                   (syntax-error tmp2696)))
                             ($syntax-dispatch tmp2696 'each-any)))
                          ls2695))))
               ((letrec ((f2700
                          (lambda (x2701)
                            (if (null? x2701)
                                (if (quote-nil?2623 y2693)
                                    '()
                                    (list y2693))
                                (if (quote-nil?2623 (car x2701))
                                    (f2700 (cdr x2701))
                                    (cons (car x2701)
                                          (f2700 (cdr x2701))))))))
                  f2700)
                x2694))))
           (quasivector2619
            (lambda (x2656)
              ((lambda (tmp2657)
                 ((lambda (pat-x2658)
                    ((lambda (tmp2659)
                       ((lambda (tmp2660)
                          (if (if tmp2660
                                  (apply
                                    (lambda (quote?2662 x2661)
                                      (isquote?2626 quote?2662))
                                    tmp2660)
                                  '#f)
                              (apply
                                (lambda (quote?2664 x2663)
                                  (list '#(syntax-object quote ((top) #(ribcage #(quote? x) #((top) (top)) #("i" "i")) #(ribcage #(pat-x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                        (list->vector x2663)))
                                tmp2660)
                              ((lambda (_2666)
                                 ((letrec ((f2667
                                            (lambda (x2669 k2668)
                                              ((lambda (tmp2670)
                                                 ((lambda (tmp2671)
                                                    (if (if tmp2671
                                                            (apply
                                                              (lambda (quote?2673
                                                                       x2672)
                                                                (isquote?2626
                                                                  quote?2673))
                                                              tmp2671)
                                                            '#f)
                                                        (apply
                                                          (lambda (quote?2675
                                                                   x2674)
                                                            (k2668
                                                              (map (lambda (tmp2676)
                                                                     (list '#(syntax-object quote ((top) #(ribcage #(quote? x) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x k) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_) #((top)) #("i")) #(ribcage #(pat-x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                           tmp2676))
                                                                   x2674)))
                                                          tmp2671)
                                                        ((lambda (tmp2677)
                                                           (if (if tmp2677
                                                                   (apply
                                                                     (lambda (listp2679
                                                                              x2678)
                                                                       (islist?2625
                                                                         listp2679))
                                                                     tmp2677)
                                                                   '#f)
                                                               (apply
                                                                 (lambda (listp2681
                                                                          x2680)
                                                                   (k2668
                                                                     x2680))
                                                                 tmp2677)
                                                               ((lambda (tmp2683)
                                                                  (if (if tmp2683
                                                                          (apply
                                                                            (lambda (cons?2686
                                                                                     x2685
                                                                                     y2684)
                                                                              (iscons?2624
                                                                                cons?2686))
                                                                            tmp2683)
                                                                          '#f)
                                                                      (apply
                                                                        (lambda (cons?2689
                                                                                 x2688
                                                                                 y2687)
                                                                          (f2667
                                                                            y2687
                                                                            (lambda (ls2690)
                                                                              (k2668
                                                                                (cons x2688
                                                                                      ls2690)))))
                                                                        tmp2683)
                                                                      ((lambda (else2691)
                                                                         (list '#(syntax-object list->vector ((top) #(ribcage #(else) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x k) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_) #((top)) #("i")) #(ribcage #(pat-x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                               pat-x2658))
                                                                       tmp2670)))
                                                                ($syntax-dispatch
                                                                  tmp2670
                                                                  '(any any
                                                                        any)))))
                                                         ($syntax-dispatch
                                                           tmp2670
                                                           '(any .
                                                                 each-any)))))
                                                  ($syntax-dispatch
                                                    tmp2670
                                                    '(any each-any))))
                                               x2669))))
                                    f2667)
                                  x2656
                                  (lambda (ls2692)
                                    (cons '#(syntax-object vector ((top) #(ribcage () () ()) #(ribcage #(ls) #((top)) #("i")) #(ribcage #(_) #((top)) #("i")) #(ribcage #(pat-x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                          ls2692))))
                               tmp2659)))
                        ($syntax-dispatch tmp2659 '(any each-any))))
                     pat-x2658))
                  tmp2657))
               x2656)))
           (quasi2618
            (lambda (p2633 lev2632)
              ((lambda (tmp2634)
                 ((lambda (tmp2635)
                    (if tmp2635
                        (apply
                          (lambda (p2636)
                            (if (= lev2632 '0)
                                p2636
                                (quasicons2621
                                  '#(syntax-object (quote unquote) ((top) #(ribcage #(p) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                  (quasi2618
                                    (list p2636)
                                    (- lev2632 '1)))))
                          tmp2635)
                        ((lambda (tmp2637)
                           (if tmp2637
                               (apply
                                 (lambda (p2639 q2638)
                                   (if (= lev2632 '0)
                                       (quasilist*2622
                                         p2639
                                         (quasi2618 q2638 lev2632))
                                       (quasicons2621
                                         (quasicons2621
                                           '#(syntax-object (quote unquote) ((top) #(ribcage #(p q) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                           (quasi2618
                                             p2639
                                             (- lev2632 '1)))
                                         (quasi2618 q2638 lev2632))))
                                 tmp2637)
                               ((lambda (tmp2642)
                                  (if tmp2642
                                      (apply
                                        (lambda (p2644 q2643)
                                          (if (= lev2632 '0)
                                              (quasiappend2620
                                                p2644
                                                (quasi2618 q2643 lev2632))
                                              (quasicons2621
                                                (quasicons2621
                                                  '#(syntax-object (quote unquote-splicing) ((top) #(ribcage #(p q) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                  (quasi2618
                                                    p2644
                                                    (- lev2632 '1)))
                                                (quasi2618
                                                  q2643
                                                  lev2632))))
                                        tmp2642)
                                      ((lambda (tmp2647)
                                         (if tmp2647
                                             (apply
                                               (lambda (p2648)
                                                 (quasicons2621
                                                   '#(syntax-object (quote quasiquote) ((top) #(ribcage #(p) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                   (quasi2618
                                                     (list p2648)
                                                     (+ lev2632 '1))))
                                               tmp2647)
                                             ((lambda (tmp2649)
                                                (if tmp2649
                                                    (apply
                                                      (lambda (p2651 q2650)
                                                        (quasicons2621
                                                          (quasi2618
                                                            p2651
                                                            lev2632)
                                                          (quasi2618
                                                            q2650
                                                            lev2632)))
                                                      tmp2649)
                                                    ((lambda (tmp2652)
                                                       (if tmp2652
                                                           (apply
                                                             (lambda (x2653)
                                                               (quasivector2619
                                                                 (quasi2618
                                                                   x2653
                                                                   lev2632)))
                                                             tmp2652)
                                                           ((lambda (p2655)
                                                              (list '#(syntax-object quote ((top) #(ribcage #(p) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t)))
                                                                    p2655))
                                                            tmp2634)))
                                                     ($syntax-dispatch
                                                       tmp2634
                                                       '#(vector
                                                          each-any)))))
                                              ($syntax-dispatch
                                                tmp2634
                                                '(any . any)))))
                                       ($syntax-dispatch
                                         tmp2634
                                         '(#(free-id
                                             #(syntax-object quasiquote ((top) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                            any)))))
                                ($syntax-dispatch
                                  tmp2634
                                  '((#(free-id
                                       #(syntax-object unquote-splicing ((top) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                                      .
                                      each-any)
                                    .
                                    any)))))
                         ($syntax-dispatch
                           tmp2634
                           '((#(free-id
                                #(syntax-object unquote ((top) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                               .
                               each-any)
                             .
                             any)))))
                  ($syntax-dispatch
                    tmp2634
                    '(#(free-id
                        #(syntax-object unquote ((top) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(top-ribcage *top* #t))))
                       any))))
               p2633))))
    (lambda (x2627)
      ((lambda (tmp2628)
         ((lambda (tmp2629)
            (if tmp2629
                (apply (lambda (_2631 e2630) (quasi2618 e2630 '0)) tmp2629)
                (syntax-error tmp2628)))
          ($syntax-dispatch tmp2628 '(any any))))
       x2627)))
  '*top*)
($sc-put-cte
  '#(syntax-object include ((top) #(ribcage #(include) #((top)) #(include))))
  (lambda (x2739)
    (letrec ((read-file2740
              (lambda (fn2751 k2750)
                ((lambda (p2752)
                   ((letrec ((f2753
                              (lambda ()
                                ((lambda (x2754)
                                   (if (eof-object? x2754)
                                       (begin (close-input-port p2752) '())
                                       (cons (datum->syntax-object
                                               k2750
                                               x2754)
                                             (f2753))))
                                 (read p2752)))))
                      f2753)))
                 (open-input-file fn2751)))))
      ((lambda (tmp2741)
         ((lambda (tmp2742)
            (if tmp2742
                (apply
                  (lambda (k2744 filename2743)
                    ((lambda (fn2745)
                       ((lambda (tmp2746)
                          ((lambda (tmp2747)
                             (if tmp2747
                                 (apply
                                   (lambda (exp2748)
                                     (cons '#(syntax-object begin ((top) #(ribcage #(exp) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(fn) #((top)) #("i")) #(ribcage #(k filename) #((top) (top)) #("i" "i")) #(ribcage (read-file) ((top)) ("i")) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                           exp2748))
                                   tmp2747)
                                 (syntax-error tmp2746)))
                           ($syntax-dispatch tmp2746 'each-any)))
                        (read-file2740 fn2745 k2744)))
                     (syntax-object->datum filename2743)))
                  tmp2742)
                (syntax-error tmp2741)))
          ($syntax-dispatch tmp2741 '(any any))))
       x2739)))
  '*top*)
($sc-put-cte
  '#(syntax-object unquote ((top) #(ribcage #(unquote) #((top)) #(unquote))))
  (lambda (x2755)
    ((lambda (tmp2756)
       ((lambda (tmp2757)
          (if tmp2757
              (apply
                (lambda (_2759 e2758)
                  (syntax-error
                    x2755
                    '"expression not valid outside of quasiquote"))
                tmp2757)
              (syntax-error tmp2756)))
        ($syntax-dispatch tmp2756 '(any . each-any))))
     x2755))
  '*top*)
($sc-put-cte
  '#(syntax-object unquote-splicing ((top) #(ribcage #(unquote-splicing) #((top)) #(unquote-splicing))))
  (lambda (x2760)
    ((lambda (tmp2761)
       ((lambda (tmp2762)
          (if tmp2762
              (apply
                (lambda (_2764 e2763)
                  (syntax-error
                    x2760
                    '"expression not valid outside of quasiquote"))
                tmp2762)
              (syntax-error tmp2761)))
        ($syntax-dispatch tmp2761 '(any . each-any))))
     x2760))
  '*top*)
($sc-put-cte
  '#(syntax-object case ((top) #(ribcage #(case) #((top)) #(case))))
  (lambda (x2765)
    ((lambda (tmp2766)
       ((lambda (tmp2767)
          (if tmp2767
              (apply
                (lambda (_2771 e2770 m12769 m22768)
                  ((lambda (tmp2772)
                     ((lambda (body2799)
                        (list '#(syntax-object let ((top) #(ribcage #(body) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                              (list (list '#(syntax-object t ((top) #(ribcage #(body) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                          e2770))
                              body2799))
                      tmp2772))
                   ((letrec ((f2773
                              (lambda (clause2775 clauses2774)
                                (if (null? clauses2774)
                                    ((lambda (tmp2776)
                                       ((lambda (tmp2777)
                                          (if tmp2777
                                              (apply
                                                (lambda (e12779 e22778)
                                                  (cons '#(syntax-object begin ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                        (cons e12779
                                                              e22778)))
                                                tmp2777)
                                              ((lambda (tmp2781)
                                                 (if tmp2781
                                                     (apply
                                                       (lambda (k2784
                                                                e12783
                                                                e22782)
                                                         (list '#(syntax-object if ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                               (list '#(syntax-object memv ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                     '#(syntax-object t ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                     (list '#(syntax-object quote ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                           k2784))
                                                               (cons '#(syntax-object begin ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                     (cons e12783
                                                                           e22782))))
                                                       tmp2781)
                                                     ((lambda (_2787)
                                                        (syntax-error
                                                          x2765))
                                                      tmp2776)))
                                               ($syntax-dispatch
                                                 tmp2776
                                                 '(each-any
                                                    any
                                                    .
                                                    each-any)))))
                                        ($syntax-dispatch
                                          tmp2776
                                          '(#(free-id
                                              #(syntax-object else ((top) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                                             any
                                             .
                                             each-any))))
                                     clause2775)
                                    ((lambda (tmp2788)
                                       ((lambda (rest2789)
                                          ((lambda (tmp2790)
                                             ((lambda (tmp2791)
                                                (if tmp2791
                                                    (apply
                                                      (lambda (k2794
                                                               e12793
                                                               e22792)
                                                        (list '#(syntax-object if ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                              (list '#(syntax-object memv ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                    '#(syntax-object t ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                    (list '#(syntax-object quote ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                          k2794))
                                                              (cons '#(syntax-object begin ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                    (cons e12793
                                                                          e22792))
                                                              rest2789))
                                                      tmp2791)
                                                    ((lambda (_2797)
                                                       (syntax-error
                                                         x2765))
                                                     tmp2790)))
                                              ($syntax-dispatch
                                                tmp2790
                                                '(each-any
                                                   any
                                                   .
                                                   each-any))))
                                           clause2775))
                                        tmp2788))
                                     (f2773
                                       (car clauses2774)
                                       (cdr clauses2774)))))))
                      f2773)
                    m12769
                    m22768)))
                tmp2767)
              (syntax-error tmp2766)))
        ($syntax-dispatch tmp2766 '(any any any . each-any))))
     x2765))
  '*top*)
($sc-put-cte
  '#(syntax-object identifier-syntax ((top) #(ribcage #(identifier-syntax) #((top)) #(identifier-syntax))))
  (lambda (x2800)
    ((lambda (tmp2801)
       ((lambda (tmp2802)
          (if tmp2802
              (apply
                (lambda (_2804 e2803)
                  (list '#(syntax-object lambda ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                        '#(syntax-object (x) ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                        (list '#(syntax-object syntax-case ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                              '#(syntax-object x ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                              '()
                              (list '#(syntax-object id ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                    '#(syntax-object (identifier? (syntax id)) ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                    (list '#(syntax-object syntax ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                          e2803))
                              (list (cons _2804
                                          '(#(syntax-object x ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                             #(syntax-object ... ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))))
                                    (list '#(syntax-object syntax ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                          (cons e2803
                                                '(#(syntax-object x ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                   #(syntax-object ... ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))))))))
                tmp2802)
              ((lambda (tmp2805)
                 (if (if tmp2805
                         (apply
                           (lambda (_2811
                                    id2810
                                    exp12809
                                    var2808
                                    val2807
                                    exp22806)
                             (if (identifier? id2810)
                                 (identifier? var2808)
                                 '#f))
                           tmp2805)
                         '#f)
                     (apply
                       (lambda (_2817
                                id2816
                                exp12815
                                var2814
                                val2813
                                exp22812)
                         (list '#(syntax-object cons ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                               '#(syntax-object (quote macro!) ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                               (list '#(syntax-object lambda ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                     '#(syntax-object (x) ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                     (list '#(syntax-object syntax-case ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                           '#(syntax-object x ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                           '#(syntax-object (set!) ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                           (list (list '#(syntax-object set! ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       var2814
                                                       val2813)
                                                 (list '#(syntax-object syntax ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       exp22812))
                                           (list (cons id2816
                                                       '(#(syntax-object x ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                          #(syntax-object ... ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))))
                                                 (list '#(syntax-object syntax ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       (cons exp12815
                                                             '(#(syntax-object x ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                                #(syntax-object ... ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))))))
                                           (list id2816
                                                 (list '#(syntax-object identifier? ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       (list '#(syntax-object syntax ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                             id2816))
                                                 (list '#(syntax-object syntax ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t)))
                                                       exp12815))))))
                       tmp2805)
                     (syntax-error tmp2801)))
               ($syntax-dispatch
                 tmp2801
                 '(any (any any)
                       ((#(free-id
                           #(syntax-object set! ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(top-ribcage *top* #t))))
                          any
                          any)
                        any))))))
        ($syntax-dispatch tmp2801 '(any any))))
     x2800))
  '*top*)
