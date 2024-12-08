;; Copyright (c) 2024 by Macon Gambill, all rights reserved.

(define (^invalidate/maybe-end! delim sym predicate?)
  (lambda (ac-list nc)
    (revise-while! ac-list sym predicate?)
    (cond ((char=? nc delim) (end-symmetric! ac-list nc sym))
          (else (adorn-char nc 'invalid sym)))))

(define (^handle:symmetric! delim sym backslash-sym esc-sym)
  (lambda (ac-list nc)
    (cond ((char=? nc #\\) (adorn-char nc esc-sym backslash-sym))
          ((char=? nc delim) (end-symmetric! ac-list nc sym))
          (else (adorn-char nc sym sym)))))

(define (^handle:symmetric-backslash! sym esc-sym hex-x-sym hex-u-sym
                                      hex-U-sym nil-sym oct-long-sym
                                      oct-short-sym invalidate/maybe-end!)
  (lambda (ac-list nc)
    (cond ((char=? nc #\x) (adorn-char nc esc-sym hex-x-sym))
          ((char=? nc #\u) (adorn-char nc esc-sym hex-u-sym))
          ((char=? nc #\U) (adorn-char nc esc-sym hex-U-sym))
          ((char=? nc #\newline) (adorn-char nc esc-sym nil-sym))
          ((memc nc mnemonic-escape-chars) (adorn-char nc esc-sym sym))
          ((memc nc '(#\0 #\1 #\2 #\3)) (adorn-char nc esc-sym oct-long-sym))
          ((memc nc '(#\4 #\5 #\6 #\7)) (adorn-char nc esc-sym oct-short-sym))
          (else (invalidate/maybe-end! ac-list nc)))))

(define (^handle:symmetric-nil! delim sym backslash-sym esc-sym nil-sym)
  (lambda (ac-list nc)
    (cond ((memc nc '(#\space #\tab)) (adorn-char nc esc-sym nil-sym))
          ((char=? nc #\\) (adorn-char nc esc-sym backslash-sym))
          ((char=? nc delim) (end-symmetric! ac-list nc sym))
          (else (adorn-char nc sym sym)))))

(define (^handle:symmetric-hex-x! sym esc-sym hex-x-sym invalidate/maybe-end!)
  (lambda (ac-list nc)
    (cond ((char=? nc #\;) (adorn-char nc esc-sym sym))
          ((memc-ci nc hexadecimal-chars) (adorn-char nc esc-sym hex-x-sym))
          (else (invalidate/maybe-end! ac-list nc)))))

(define (^handle:symmetric-oct-long! delim sym backslash-sym esc-sym next)
  (lambda (ac-list nc)
    (cond ((memc nc octal-chars) (adorn-char nc esc-sym next))
          ((char=? nc delim) (end-symmetric! ac-list nc sym))
          ((char=? nc #\\) (adorn-char nc esc-sym backslash-sym))
          (else (adorn-char nc sym sym)))))

(define (^handle:symmetric-oct-long1! delim sym backslash-sym esc-sym)
  (lambda (ac-list nc)
    (cond ((memc nc octal-chars) (adorn-char nc esc-sym sym))
          ((char=? nc delim) (end-symmetric! ac-list nc sym))
          ((char=? nc #\\) (adorn-char nc esc-sym backslash-sym))
          (else (adorn-char nc sym sym)))))

(define (^handle:symmetric-oct-short! delim sym backslash-sym esc-sym)
  (lambda (ac-list nc)
    (cond ((memc nc octal-chars) (adorn-char nc esc-sym sym))
          ((char=? nc delim) (end-symmetric! ac-list nc sym))
          ((char=? nc #\\) (adorn-char nc esc-sym backslash-sym))
          (else (adorn-char nc sym sym)))))

(define (^handle:symmetric-hex-Uu! esc-sym next invalidate/maybe-end!)
  (lambda (ac-list nc)
    (cond ((memc-ci nc hexadecimal-chars) (adorn-char nc esc-sym next))
          (else (invalidate/maybe-end! ac-list nc)))))

(define (^handle:symmetric-esc! backslash-sym backslash-handler
                                nil-sym       nil-handler
                                hex-x-sym     hex-x-handler
                                hex-u-sym     hex-u-handler
                                hex-u1-sym    hex-u1-handler
                                hex-u2-sym    hex-u2-handler
                                hex-u3-sym    hex-u3-handler
                                hex-U-sym     hex-U-handler
                                hex-U1-sym    hex-U1-handler
                                hex-U2-sym    hex-U2-handler
                                hex-U3-sym    hex-U3-handler
                                hex-U4-sym    hex-U4-handler
                                hex-U5-sym    hex-U5-handler
                                hex-U6-sym    hex-U6-handler
                                hex-U7-sym    hex-U7-handler
                                oct-long-sym  oct-long-handler
                                oct-long1-sym oct-long1-handler
                                oct-short-sym oct-short-handler)
  (lambda (ac-list nc pm)
    (cond ((eq? pm backslash-sym) (backslash-handler ac-list nc))
          ((eq? pm nil-sym)       (nil-handler       ac-list nc))
          ((eq? pm hex-x-sym)     (hex-x-handler     ac-list nc))
          ((eq? pm oct-long-sym)  (oct-long-handler  ac-list nc))
          ((eq? pm oct-long1-sym) (oct-long1-handler ac-list nc))
          ((eq? pm oct-short-sym) (oct-short-handler ac-list nc))
          ((eq? pm hex-u-sym)     (hex-u-handler     ac-list nc))
          ((eq? pm hex-u1-sym)    (hex-u1-handler    ac-list nc))
          ((eq? pm hex-u2-sym)    (hex-u2-handler    ac-list nc))
          ((eq? pm hex-u3-sym)    (hex-u3-handler    ac-list nc))
          ((eq? pm hex-U-sym)     (hex-U-handler     ac-list nc))
          ((eq? pm hex-U1-sym)    (hex-U1-handler    ac-list nc))
          ((eq? pm hex-U2-sym)    (hex-U2-handler    ac-list nc))
          ((eq? pm hex-U3-sym)    (hex-U3-handler    ac-list nc))
          ((eq? pm hex-U4-sym)    (hex-U4-handler    ac-list nc))
          ((eq? pm hex-U5-sym)    (hex-U5-handler    ac-list nc))
          ((eq? pm hex-U6-sym)    (hex-U6-handler    ac-list nc))
          ((eq? pm hex-U7-sym)    (hex-U7-handler    ac-list nc))
          (else #f))))

(define (^try-symm-pm! sym)
  (let ((delim           (if (backmatch "ident" (symbol->string sym)) #\| #\"))
        (unmatched-sym   ((append-to-symbol "-unmatched")   sym))
        (backslash-sym   ((append-to-symbol "-backslash")   sym))
        (esc-sym         ((append-to-symbol "-esc")         sym))
        (hex-u-sym       ((append-to-symbol "-hex-u")       sym))
        (hex-u1-sym      ((append-to-symbol "-hex-u1")      sym))
        (hex-u2-sym      ((append-to-symbol "-hex-u2")      sym))
        (hex-u3-sym      ((append-to-symbol "-hex-u3")      sym))
        (hex-U-sym       ((append-to-symbol "-hex-U")       sym))
        (hex-U1-sym      ((append-to-symbol "-hex-U1")      sym))
        (hex-U2-sym      ((append-to-symbol "-hex-U2")      sym))
        (hex-U3-sym      ((append-to-symbol "-hex-U3")      sym))
        (hex-U4-sym      ((append-to-symbol "-hex-U4")      sym))
        (hex-U5-sym      ((append-to-symbol "-hex-U5")      sym))
        (hex-U6-sym      ((append-to-symbol "-hex-U6")      sym))
        (hex-U7-sym      ((append-to-symbol "-hex-U7")      sym))
        (hex-x-sym       ((append-to-symbol "-hex-x")       sym))
        (nil-sym         ((append-to-symbol "-nil")         sym))
        (oct-short-sym   ((append-to-symbol "-octal-short") sym))
        (oct-long-sym    ((append-to-symbol "-octal-long")  sym))
        (oct-long1-sym   ((append-to-symbol "-octal-long1") sym)))
    (let* ((predicate? (lambda (ac) (eq? (get-kind ac) esc-sym)))
           (invalidate/end! (^invalidate/maybe-end! delim sym predicate?)))
      (let ((base-handler
             (^handle:symmetric! delim sym backslash-sym esc-sym))
            (hex-u-handler
             (^handle:symmetric-hex-Uu! esc-sym hex-u1-sym invalidate/end!))
            (hex-u1-handler
             (^handle:symmetric-hex-Uu! esc-sym hex-u2-sym invalidate/end!))
            (hex-u2-handler
             (^handle:symmetric-hex-Uu! esc-sym hex-u3-sym invalidate/end!))
            (hex-u3-handler
             (^handle:symmetric-hex-Uu! esc-sym sym invalidate/end!))
            (hex-U-handler
             (^handle:symmetric-hex-Uu! esc-sym hex-U1-sym invalidate/end!))
            (hex-U1-handler
             (^handle:symmetric-hex-Uu! esc-sym hex-U2-sym invalidate/end!))
            (hex-U2-handler
             (^handle:symmetric-hex-Uu! esc-sym hex-U3-sym invalidate/end!))
            (hex-U3-handler
             (^handle:symmetric-hex-Uu! esc-sym hex-U4-sym invalidate/end!))
            (hex-U4-handler
             (^handle:symmetric-hex-Uu! esc-sym hex-U5-sym invalidate/end!))
            (hex-U5-handler
             (^handle:symmetric-hex-Uu! esc-sym hex-U6-sym invalidate/end!))
            (hex-U6-handler
             (^handle:symmetric-hex-Uu! esc-sym hex-U7-sym invalidate/end!))
            (hex-U7-handler
             (^handle:symmetric-hex-Uu! esc-sym sym invalidate/end!))
            (hex-x-handler
             (^handle:symmetric-hex-x! sym esc-sym hex-x-sym invalidate/end!))
            (nil-handler
             (^handle:symmetric-nil! delim sym backslash-sym esc-sym nil-sym))
            (oct-short-handler
             (^handle:symmetric-oct-short! delim sym backslash-sym esc-sym))
            (oct-long-handler
             (^handle:symmetric-oct-long!
              delim sym backslash-sym esc-sym oct-long1-sym))
            (oct-long1-handler
             (^handle:symmetric-oct-long1! delim sym backslash-sym esc-sym))
            (backslash-handler
             (^handle:symmetric-backslash!
              sym esc-sym hex-x-sym hex-u-sym hex-U-sym nil-sym oct-long-sym
              oct-short-sym invalidate/end!)))
        (let ((esc-handler (^handle:symmetric-esc!
                            backslash-sym backslash-handler
                            nil-sym nil-handler
                            hex-x-sym hex-x-handler
                            hex-u-sym hex-u-handler
                            hex-u1-sym hex-u1-handler
                            hex-u2-sym hex-u2-handler
                            hex-u3-sym hex-u3-handler
                            hex-U-sym hex-U-handler
                            hex-U1-sym hex-U1-handler
                            hex-U2-sym hex-U2-handler
                            hex-U3-sym hex-U3-handler
                            hex-U4-sym hex-U4-handler
                            hex-U5-sym hex-U5-handler
                            hex-U6-sym hex-U6-handler
                            hex-U7-sym hex-U7-handler
                            oct-long-sym oct-long-handler
                            oct-long1-sym oct-long1-handler
                            oct-short-sym oct-short-handler)))
          (lambda (ac-list nc pac pm)
            (cond ((eq? pm sym)                 (base-handler ac-list nc))
                  ((eq? pm unmatched-sym)       (base-handler ac-list nc))
                  ((eq? (get-kind pac) esc-sym) (esc-handler ac-list nc pm))
                  (else #f))))))))

(define (^try-bind-ident-pm! transform)
  (let ((try-sv-define!        (^try-symm-pm! (transform 'sv-define)))
        (try-defun-param!      (^try-symm-pm! (transform 'defun-param)))
        (try-defun-proc!       (^try-symm-pm! (transform 'defun-proc)))
        (try-sv-let!           (^try-symm-pm! (transform 'sv-let)))
        (try-named-let!        (^try-symm-pm! (transform 'named-let)))
        (try-lambda-bind!      (^try-symm-pm! (transform 'lambda-bind)))
        (try-lambda-rest!      (^try-symm-pm! (transform 'lambda-rest)))
        (try-mv-let!           (^try-symm-pm! (transform 'mv-let)))
        (try-mv-let-rest!      (^try-symm-pm! (transform 'mv-let-rest)))
        (try-mv-define!        (^try-symm-pm! (transform 'mv-define)))
        (try-key-bind!         (^try-symm-pm! (transform 'key-bind)))
        (try-opt-bind!         (^try-symm-pm! (transform 'opt-bind)))
        (try-rest-bind!        (^try-symm-pm! (transform 'rest-bind)))
        (try-key-init!         (^try-symm-pm! (transform 'key-init)))
        (try-opt-init!         (^try-symm-pm! (transform 'opt-init)))
        (try-case-lambda-bind! (^try-symm-pm! (transform 'case-lambda-bind)))
        (try-mv-define-rest!   (^try-symm-pm! (transform 'mv-define-rest)))
        (try-defproc-proc!     (^try-symm-pm! (transform 'defproc-proc)))
        (try-defproc-param!    (^try-symm-pm! (transform 'defproc-param)))
        (try-defproc-spec!     (^try-symm-pm! (transform 'defproc-spec)))
        (try-rest-spec!        (^try-symm-pm! (transform 'rest-spec)))
        (try~rt-syntax!        (^try-symm-pm! (transform '~rt-syntax))))
    (lambda (ac-list nc pac pm)
      (or (try-sv-define!        ac-list nc pac pm)
          (try-defun-param!      ac-list nc pac pm)
          (try-defun-proc!       ac-list nc pac pm)
          (try-sv-let!           ac-list nc pac pm)
          (try-named-let!        ac-list nc pac pm)
          (try-lambda-bind!      ac-list nc pac pm)
          (try-lambda-rest!      ac-list nc pac pm)
          (try-mv-let!           ac-list nc pac pm)
          (try-mv-define!        ac-list nc pac pm)
          (try-mv-let-rest!      ac-list nc pac pm)
          (try-mv-define-rest!   ac-list nc pac pm)
          (try-key-bind!         ac-list nc pac pm)
          (try-opt-bind!         ac-list nc pac pm)
          (try-rest-bind!        ac-list nc pac pm)
          (try-key-init!         ac-list nc pac pm)
          (try-opt-init!         ac-list nc pac pm)
          (try-case-lambda-bind! ac-list nc pac pm)
          (try-defproc-param!    ac-list nc pac pm)
          (try-defproc-proc!     ac-list nc pac pm)
          (try-defproc-spec!     ac-list nc pac pm)
          (try-rest-spec!        ac-list nc pac pm)
          (try~rt-syntax!        ac-list nc pac pm)))))

(define try-symmetric-pm!
  (let ((try-string! (^try-symm-pm! 'string))
        (try-ident! (^try-symm-pm! 'ident))
        (try-bind-ident-pm! (^try-bind-ident-pm! ->ident))
        (try-bind-inert-ident-pm! (^try-bind-ident-pm! ->inert-ident)))
    (lambda (ac-list nc pac pm)
      (or (try-string! ac-list nc pac pm)
          (try-ident! ac-list nc pac pm)
          (try-bind-ident-pm! ac-list nc pac pm)
          (try-bind-inert-ident-pm! ac-list nc pac pm)))))
