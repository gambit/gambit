;; Copyright (c) 2024 by Macon Gambill, all rights reserved.

(define whitespace-chars '(#\space #\newline #\tab))
(define compound-begin-chars '(#\( #\[ #\{))
(define compound-end-chars '(#\) #\] #\}))
(define abbrev-chars '(#\' #\` #\,))
(define delim-chars
  (append whitespace-chars compound-begin-chars compound-end-chars abbrev-chars
          '(#\" #\; #\| #\\)))

(define binary-chars '(#\0 #\1))
(define octal-chars (append binary-chars '(#\2 #\3 #\4 #\5 #\6 #\7)))
(define decimal-chars (append octal-chars '(#\8 #\9)))
(define hexadecimal-chars (append decimal-chars '(#\a #\b #\c #\d #\e #\f)))

(define mnemonic-escape-chars
  '(#\a #\b #\f #\n #\r #\t #\v #\" #\\ #\| #\? #\space))
(define directives
  (map string->list '("#!fold-case" "#!no-fold-case")))
(define dsssl-sharp-objects
  (map string->list '("#!key" "#!optional" "#!rest")))
(define sharp-objects
  (append dsssl-sharp-objects (map string->list '("#!eof" "#!void"))))
(define short-named-chars (map string->list '("esc" "nul" "tab")))
(define long-named-chars
  (map string->list '("null" "alarm" "backspace" "space" "newline" "return"
                      "delete" "escape" "page" "vtab" "linefeed")))
(define named-chars (append long-named-chars short-named-chars))
(define fvectors (map string->list '("#f32(" "#f64(")))
(define svectors (map string->list '("#s8(" "#s16(" "#s32(" "#s64(")))
(define uvectors (map string->list '("#u8(" "#u16(" "#u32(" "#u64(")))
(define fvector-kinds '(f32vector f64vector))
(define svector-kinds '(s8vector s16vector s32vector s64vector))
(define uvector-kinds '(u8vector u16vector u32vector u64vector))
(define hvector-kinds (append fvector-kinds svector-kinds uvector-kinds))
(define datumc-kinds
  '( datumc datumc-compound datumc-string datumc-compound-string datumc-ident
     datumc-compound-ident ))
(define datumc-escape-kinds
  '( datumc-string-esc datumc-compound-string-esc datumc-ident-esc
     datumc-compound-ident-esc ))
(define comment-kinds (append '(linec nestc) datumc-kinds datumc-escape-kinds))
(define atmosphere-kinds (append '(whitespace directive) comment-kinds))

(define (+prims strings)
  (append strings (map (lambda (s) (string-append "##" s)) strings)))

(define sv-define-syntax
  (map string->list (+prims '("define" "define-prim" "define-record-type"))))

(define define-proc-syntax
  (map string->list
       (+prims '("define-primitive" "define-procedure" "define-prim&proc"))))

(define sv-let-syntax
  (map string->list
       (+prims '("let" "let*" "letrec" "letrec*" "parameterize"))))

(define lambda-syntax (map string->list (+prims '("\x3bb;" "lambda"))))

(define mv-let-syntax
  (map string->list (+prims '("let*-values" "let-values" "letrec*-values"
                               "letrec-values"))))

(define mv-define-syntax (map string->list (+prims '("define-values"))))

(define case-lambda-syntax (map string->list (+prims '("case-lambda"))))

;There's probably some way to populate this list programatically.
(define runtime-syntax
  (append sv-define-syntax
          sv-let-syntax
          lambda-syntax
          mv-let-syntax
          mv-define-syntax
          case-lambda-syntax
          define-proc-syntax
          (map string->list
               (+prims '("and" "begin" "c-declare" "c-define" "c-define-type"
                         "c-initialize" "c-lambda" "case" "cond" "cond-expand"
                         "declare" "define-library" "define-macro"
                         "define-runtime-macro" "define-runtime-syntax"
                         "define-structure" "define-syntax" "define-type"
                         "define-type-of-thread" "delay" "delay-force" "do"
                         "else" "future" "guard" "if" "import" "include"
                         "include-ci" "load" "macro-case-target" "namespace"
                         "or" "quasiquote" "quote" "r7rs-guard" "receive"
                         "set!" "syntax-error" "syntax-rules"
                         "this-source-file" "unless" "when")))))

(define rt-aux-syntax-syntax
  (map string->list (+prims '("cond" "case" "macro-case-target"))))
;======================= Symbol manipulation procedures =======================
(define-record-type achar ; a literal char object, plus some metadata
  (make-adorned-char c k m h s)
  adorned-char?
  (c get-char) ; the literal char (in the sense of char?)
  (k get-kind set-kind!) ; a symbol describing a char's contextualized meaning
  (m get-mesg set-mesg!) ; #f or a symbol that serves as a hint for later chars
  (h get-hop set-hop!) ; #f or an integer representing the distance to a peer
  (s get-stack set-stack!)) ; a list of pointers to earlier points in the list

(define adorn-char ; wrapper around make-adorned-char, providing default values
  (case-lambda
    ((char kind mesg) (make-adorned-char char kind mesg #f '()))
    ((char kind mesg hop) (make-adorned-char char kind mesg hop '()))
    ((char kind mesg hop stack) (make-adorned-char char kind mesg hop stack))))
;======================= Symbol manipulation procedures =======================
(define (append-to-symbol string)
  (lambda (symbol)
    (string->symbol (string-append (symbol->string symbol) string))))

(define ->sub
  (case-lambda
    ((symbol)
     (string->symbol (string-append "sub" (symbol->string symbol))))
    ((symbol ending)
     (string->symbol (string-append "sub" (symbol->string symbol) ending)))))

(define (->begin         symbol) ((append-to-symbol "-begin")     symbol))
(define (->compound      symbol) ((append-to-symbol "-compound")  symbol))
(define (->empty         symbol) ((append-to-symbol "-empty")     symbol))
(define (->end           symbol) ((append-to-symbol "-end")       symbol))
(define (->esc           symbol) ((append-to-symbol "-esc")       symbol))
(define (->ident         symbol) ((append-to-symbol "-ident")     symbol))
(define (->inert         symbol) ((append-to-symbol "-inert")     symbol))
(define (->unmatched     symbol) ((append-to-symbol "-unmatched") symbol))
(define (->sub-unmatched symbol) (->sub symbol "-unmatched"))
(define (->sub-begin     symbol) (->sub symbol "-begin"))
(define (->sub-end       symbol) (->sub symbol "-end"))

(define (->inert-ident symbol)
  (string->symbol (string-append (symbol->string symbol) "-inert-ident")))

(define dsssl-binds '(key-bind opt-bind rest-bind key-init opt-init))

(define lambda-binds '(lambda-bind lambda-rest case-lambda-bind))

(define let-binds '(named-let sv-let mv-let mv-let-rest))

(define define-binds
  '( sv-define defun-proc defun-param mv-define mv-define-rest
     defproc-proc defproc-param defproc-spec rest-spec ))

(define binds (append define-binds let-binds lambda-binds dsssl-binds))

(define dsssl-compounds '(compound-key compound-opt))

(define def-like-compounds '(defun defproc))

(define let-like-compounds
  (append '( lambda-bind-list let-sv-inner case-lambda-inner defproc-inner
             rest-spec-list )
          dsssl-compounds))

(define binding-compounds (append def-like-compounds let-like-compounds))

(define inert-binding-compounds (map ->compound (map ->inert binds)))

(define non-binding-list-compounds
  (append '( list let-sv-outer let-mv-outermost let-mv-outer let-mv-inner
             define-mv-list case-lambda-outer )
          inert-binding-compounds))

(define vector-compounds (cons 'vector hvector-kinds))
(define vector-end-mesgs (map ->end vector-compounds))
(define subvector-end-mesgs (map ->sub vector-end-mesgs))
(define list-compounds (append binding-compounds non-binding-list-compounds))
(define compound-kinds (append list-compounds vector-compounds))
(define sublist-mesgs (map ->sub list-compounds))
(define sublist-end-mesgs (map ->end sublist-mesgs))
(define subcompound-end-mesgs (append sublist-end-mesgs subvector-end-mesgs))
(define comment-end-mesgs '(linec-end datumc-end nestc-end))
(define subcompound/comment-end-mesgs
  (append subcompound-end-mesgs comment-end-mesgs))

(define non-syntax-compounds (cons 'list vector-compounds))

(define sublist-unmatched-mesgs (map ->unmatched sublist-mesgs))

(define list-unmatched-mesgs
  (append sublist-unmatched-mesgs (map ->unmatched list-compounds)))

(define sublist-begin-mesgs
  (append sublist-unmatched-mesgs (map ->begin list-compounds)))

(define list-begin-mesgs
  (append
   sublist-begin-mesgs list-unmatched-mesgs (map ->begin list-compounds)))

(define sublist-delimiter-mesgs (append sublist-begin-mesgs sublist-end-mesgs))

(define list-end-mesgs (map ->end list-compounds))

(define list-delimiter-mesgs
  (append sublist-delimiter-mesgs list-begin-mesgs list-end-mesgs))

(define string-base-mesgs '(string datumc-string datumc-compound-string))

(define binding-ident-base-kinds (map ->ident binds))
(define binding-inert-ident-kinds (map ->inert-ident binds))
(define binding-ident-kinds
  (append binding-ident-base-kinds binding-inert-ident-kinds))

(define ident-base-mesgs
  (let ((base-syms (append '(datumc datumc-compound rt-syntax) binds)))
    (let ((ert (map ->ident base-syms)) (inert (map ->inert-ident binds)))
      (append '(ident) ert inert))))

(define ident/string-base-mesgs (append string-base-mesgs ident-base-mesgs))

(define compound-end-mesgs (map ->end compound-kinds))
(define subcompound-end-mesgs (map ->sub compound-end-mesgs))
(define compound-unmatched-mesgs (map ->unmatched compound-kinds))
(define subcompound-unmatched-mesgs (map ->sub compound-unmatched-mesgs))

(define compound-unmatched-mesgs
  (append compound-unmatched-mesgs subcompound-unmatched-mesgs))
(define compound-peering-mesgs
  (append compound-unmatched-mesgs subcompound-end-mesgs))
(define datumc-compound-unmatched-mesgs
  (map ->unmatched '(datumc-compound datumc-subcompound)))
(define datumc-compound-peering-mesgs
  (cons 'datumc-subcompound-end datumc-compound-unmatched-mesgs))
;======================= Navigation/context procedures ========================
;; It would perhaps be more efficient (and maybe more painful) to use analogous
;; procedures that use pointers exclusively (e.g., the "stack" field).  It also
;; might be more efficient to convert the list into one or more vectors once it
;; reaches a certain size.

(define (atmosphere? ac) (memq (get-kind ac) atmosphere-kinds))

(define (atmosphere/abbrev? ac)
  (memq (get-kind ac) (cons 'abbrev atmosphere-kinds)))

(define (operator-position? ac-list)
  ;; Would the next character be in the operator position of a list?
  (and (not (null? ac-list))
       (let* ((ac (car ac-list)) (mesg (get-mesg ac)))
         (or (memq mesg list-begin-mesgs)
             (cond ((memq mesg comment-end-mesgs)
                    (operator-position?
                     (let skip ((rest (cdr ac-list)) (i (get-hop ac)))
                       (if (negative? i)
                           (skip (cdr rest) (+ i 1))
                           rest))))
                   ((atmosphere? ac) (operator-position? (cdr ac-list)))
                   (else #f))))))

(define (syntax->mesg operator)
  (cond ((matches?        '(#\l #\e #\t)       operator) '~named/sv-let)
        ((matches-one-of? sv-define-syntax     operator) '~sv-define)
        ((matches-one-of? sv-let-syntax        operator) '~~~let-sv)
        ((matches-one-of? lambda-syntax        operator) '~~lambda-bind)
        ((matches-one-of? mv-let-syntax        operator) '~~~~let-mv)
        ((matches-one-of? mv-define-syntax     operator) '~~mv-define)
        ((matches-one-of? case-lambda-syntax   operator) '~~~case-lambda)
        ((matches-one-of? define-proc-syntax   operator) '~~defproc)
        ((matches-one-of? rt-aux-syntax-syntax operator) 'rt-aux-active)
        (else #f)))

(define rt-syntax-mesg
  ;; Returns the mesg associated with the operator of the current list (if that
  ;; list begins with a use of runtime syntax).
  (let ((get-operator
         (lambda (ac-list begin-mesg)
           (or (get-mesg (cadr ac-list))
               (let loop ((rest ac-list) (buffer '()))
                 (let ((ac (car rest)))
                   (if (eq? (get-mesg ac) begin-mesg)
                       (syntax->mesg (cons (get-char ac) buffer))
                       (loop (cdr rest) (cons (get-char ac) buffer)))))))))
    (lambda (ac-list)
      (if (null? ac-list)
          #f
          (let* ((ac (car ac-list)) (kind (get-kind ac)))
            (cond ((eq? kind 'rt-syntax) (get-operator ac-list '~~rt-syntax))
                  ((eq? kind 'rt-syntax-ident)
                   (get-operator ac-list 'rt-syntax-ident-begin))
                  (else (let ((hop (get-hop ac)))
                          (if (and hop (negative? hop))
                              (rt-syntax-mesg
                               (let skip ((rest (cdr ac-list)) (i hop))
                                 (if (negative? i)
                                     (skip (cdr rest) (+ i 1))
                                     rest)))
                              (let ((mesg (get-mesg ac)))
                                (and (not (memq mesg list-delimiter-mesgs))
                                     (rt-syntax-mesg (cdr ac-list)))))))))))))

(define (start-of-list ac-list)
  ;; Return a truncated version of ac-list from the start of the current list.
  (if (null? ac-list)
      '()
      (let* ((ac (car ac-list)) (mesg (get-mesg ac)))
        (cond ((memq mesg list-unmatched-mesgs) ac-list)
              ((memq mesg list-end-mesgs) '())
              ((memq mesg subcompound/comment-end-mesgs)
               (let ((stack (get-stack ac)))
                 (start-of-list (if (null? stack)
                                    (let skip ((rest (cdr ac-list))
                                               (i (get-hop ac)))
                                      (if (negative? i)
                                          (skip (cdr ac-list) (+ i 1))
                                          rest))
                                    (car stack)))))
              (else (start-of-list (cdr ac-list)))))))

(define (up-list ac-list)
  ;; Return a truncated version of ac-list from just before the current list.
  (let ((list-start (start-of-list ac-list)))
    (if (null? list-start) '() (cdr list-start))))

(define (distance-until ac-list char/mesg)
  ;; Return the integer distance to the most recent occurrence of char/mesg.
  (cond ((char? char/mesg)
         (let loop ((rest ac-list) (distance 0))
           (cond ((null? rest) (error "Not found" char/mesg))
                 ((char=? (get-char (car rest)) char/mesg) distance)
                 (else (loop (cdr rest) (+ distance 1))))))
        ((symbol? char/mesg)
         (let loop ((rest ac-list) (distance 0))
           (cond ((null? rest) (error "Not found" char/mesg))
                 ((eq? (get-mesg (car rest)) char/mesg) distance)
                 (else (loop (cdr rest) (+ distance 1))))))))

(define (chars-while ac-list mesg)
  ;; Return a list comprising the chars of each consecutive adorned chars whose
  ;; mesg field is eq? to the mesg argument.
  (let accumulate ((rest ac-list) (chars '()))
    (if (null? ac-list)
        chars
        (let ((ac (car rest)))
          (if (eq? (get-mesg ac) mesg)
              (accumulate (cdr rest) (cons (get-char ac) chars))
              chars)))))

(define (chars-until ac-list char/int/mesgs)
  (cond ((char? char/int/mesgs)
         (let loop ((chars '()) (rest ac-list))
           (if (null? rest)
               chars
               (let ((char (get-char (car rest))))
                 (if (char=? char char/int/mesgs)
                     (cons char chars)
                     (loop (cons char chars) (cdr rest)))))))
        ((integer? char/int/mesgs)
         (let loop ((chars '()) (rest ac-list) (i char/int/mesgs))
           (if (or (zero? i) (null? rest))
               chars
               (loop (cons (get-char (car rest)) chars) (cdr rest) (- i 1)))))
        (else (let ((predicate? (if (symbol? char/int/mesgs) eq? memq)))
                (let loop ((chars '()) (rest ac-list))
                  (if (null? rest)
                      chars
                      (let ((ac (car rest)))
                        (let ((char (get-char ac))
                              (mesg (get-mesg ac)))
                          (if (predicate? mesg char/int/mesgs)
                              (cons char chars)
                              (loop (cons char chars) (cdr rest)))))))))))

(define (^looking/peeking-at predicate?)
  (lambda (ac-list mesg-list)
    (let looking/peeking-loop ((rest ac-list))
      (and (not (null? rest))
           (let* ((ac (car rest)) (mesg (get-mesg ac)))
             (cond ((eq? mesg 'linec-end)
                    (looking/peeking-loop (car (get-stack ac))))
                   ((predicate? ac) (looking/peeking-loop (cdr rest)))
                   (else (memq mesg mesg-list))))))))

;; These names aren't the best.  Possible mnemonic: "looking-at" is true if the
;; target is visible without obstruction; "peeking-at" is true if the target is
;; visible without obstruction or is partially obscured by one or more abbrevs.
(define looking-at (^looking/peeking-at atmosphere?))
(define peeking-at (^looking/peeking-at atmosphere/abbrev?))
;========================== Bulk mutation procedures ==========================
(define (revise-until! ac-list new-kind int/mesgs . end-act)
  ;; If int/mesgs is an integer, mutate the kind of each adorned char until the
  ;; given number of adorned chars have been mutated.  If int/mesgs is a symbol
  ;; or a list of symbols, mutate each adorned char's kind until encountering a
  ;; mesg equal to (one of) int/mesgs (inclusive).
  (cond ((integer? int/mesgs)
         (let loop ((rest ac-list) (i int/mesgs))
           (unless (or (null? rest) (> 1 i))
             (let ((ac (car rest)))
               (set-kind! ac new-kind)
               (when (and (= i 1) (not (null? end-act))) ((car end-act) rest))
               (loop (cdr rest) (- i 1))))))
        (else (let ((predicate? (if (symbol? int/mesgs) eq? memq)))
                (let loop ((rest ac-list))
                  (unless (null? rest)
                    (let ((ac (car rest)))
                      (set-kind! ac new-kind)
                      (if (predicate? (get-mesg ac) int/mesgs)
                          (when (not (null? end-act)) ((car end-act) rest))
                          (loop (cdr rest))))))))))

(define (revise-while! ac-list new-kind predicate?)
  ;; Revise each consecutive adorned char for which predicate? is true.
  (unless (null? ac-list)
    (let ((ac (car ac-list)))
      (when (predicate? ac)
        (set-kind! ac new-kind)
        (revise-while! (cdr ac-list) new-kind predicate?)))))

(define (increment-hops! peer-stack amount)
  ;; Each element of the peer-stack is a sublist of the same "master" list.  We
  ;; use this procedure to increment the hop value of each sublist's car by the
  ;; given amount.  If we're dealing with nested list delimiters, the non-final
  ;; hop value of an adorned #\( character represents the minimum distance from
  ;; that #\( character to its matching #\) character.
  (let ((heads (map car peer-stack)))
    (for-each (lambda (ac) (set-hop! ac (+ (get-hop ac) amount))) heads)))

;============================= Peering procedures =============================
;; Many these procedures construct/deconstruct pairs or lists where it would be
;; more natural to use multi-value procedures (let-values, values, etc.).  This
;; is needed at the time of writing to ensure the code will compile, but should
;; no longer be necessary once there's a fix for GitHub issue #680 and/or #935.

(define (datumc:peer/distance ac-list)
  ;; Return the portion of ac-list beginning with the relevant octothorpe char,
  ;; plus the distance to that char.
  (let ((peering-mesgs '(octothorpe datumc#)))
    (let seek ((rest ac-list) (distance 0))
      (if (null? rest)
          '(#f 0)
          (let* ((ac (car rest)) (mesg (get-mesg ac)))
            (if (and (memq mesg peering-mesgs) (not (null? (get-stack ac))))
                (cons rest distance)
                (seek (cdr rest) (+ distance 1))))))))

(define (^compound:peer/distance peering-mesgs end-mesgs)
  (lambda (ac-list)
    (let seek ((rest ac-list) (distance 1))
      (if (null? rest)
          '(#f . 0)
          (let* ((ac (car rest)) (mesg (get-mesg ac)))
            (cond ((memq mesg peering-mesgs) (cons rest distance))
                  ((memq mesg end-mesgs) '(#f . 0))
                  (else (seek (cdr rest) (+ distance 1)))))))))

(define compound:peer/distance
  (^compound:peer/distance compound-peering-mesgs compound-end-mesgs))

(define datumc-compound:peer/distance
  ;; special-case version for a datum comment that applies to a compound datum
  (^compound:peer/distance datumc-compound-peering-mesgs
                           '(datumc-compound-end datumc-end)))

(define (^begin-compound! peer/distance ->sub-unmatched) ; begin a list/vector
  (lambda (ac-list nc kind)
    (let ((p/d (peer/distance ac-list)))
      (let ((from-peer (car p/d)) (distance (cdr p/d)))
        (if from-peer
            (let* ((peer (car from-peer))
                   (peer-stack (get-stack peer))
                   (first-peer (caar peer-stack)))
              (let ((ac (adorn-char nc kind (->sub-unmatched kind) 0 '())))
                (increment-hops! peer-stack distance)
                (set-stack! peer '())
                (set-stack! ac (cons (cons ac ac-list) peer-stack))
                ac))
            (let ((ac (adorn-char nc kind (->unmatched kind) 0 '())))
              (begin (set-stack! ac (list (cons ac ac-list)))
                     ac)))))))

(define begin-compound!
  (^begin-compound! compound:peer/distance ->sub-unmatched))

(define begin-datumc-compound!
  (let ((^begin-datumc-compound!
         (^begin-compound! datumc-compound:peer/distance
                           (lambda (kind) 'datumc-subcompound-unmatched))))
    (lambda (ac-list nc)
      (^begin-datumc-compound! ac-list nc 'datumc-compound))))

(define (^compound:peer/empty?/distance peering-mesgs end-mesgs empty-init)
  ;; Return a sublist starting from the peer character, whether the intervening
  ;; characters all constitute "emptiness", and the distance to that peer.
  (lambda (ac-list)
    (let ((empty empty-init))
      (let seek ((rest ac-list) (distance 1))
        (if (null? rest)
            '(#f #f . 0)
            (let* ((ac (car rest)) (mesg (get-mesg ac)))
              (cond ((memq mesg peering-mesgs)
                     (if (and empty (memc (get-char ac) compound-begin-chars))
                         (cons rest (cons #t distance))
                         (cons rest (cons #f distance))))
                    ((memq mesg end-mesgs) '(#f #f . 0))
                    ((and empty (not (memq (get-kind ac) atmosphere-kinds)))
                     (set! empty #f)
                     (seek (cdr rest) (+ distance 1)))
                    (else (seek (cdr rest) (+ distance 1))))))))))

(define compound:peer/empty?/distance
  (^compound:peer/empty?/distance
   compound-peering-mesgs compound-end-mesgs #t))

(define datumc-compound:peer/empty?/distance
  (^compound:peer/empty?/distance
   datumc-compound-peering-mesgs
   '(datumc-compound-end datumc-compound-end) #f))

(define (subcompound-mesg? symbol)
  (and symbol (string=? "sub" (string-copy (symbol->string symbol) 0 3))))

(define (datumc-subcompound-mesg? symbol)
  (and symbol
       (string=? "datumc-sub" (string-copy (symbol->string symbol) 0 10))))

(define (compound-kind->distance symbol)
  (cond ((eq? symbol 'vector) 2)
        ((memq symbol '( u8vector s8vector )) 4)
        ((memq symbol '( u16vector u32vector u64vector s16vector s32vector
                         s64vector f32vector f64vector )) 5)
        (else 1)))

(define (^end-compound! sub-mesg? peer/empty?/distance ->sub-begin ->sub-end)
  ;; End a compound datum and maybe adjust the kinds of the begin/end chars.
  (lambda (ac-list nc)
    (let ((p/e/d (peer/empty?/distance ac-list)))
      (let ((from-peer (car p/e/d)) (empty (cadr p/e/d)) (dist (cddr p/e/d)))
        (if from-peer
            (let* ((peer (car from-peer)) (peer-stack (get-stack peer)))
              (increment-hops! (cdr peer-stack) dist)
              (let* ((from-top-peer (car peer-stack))
                     (top-peer (car from-top-peer)))
                (let ((total-dist (+ (get-hop top-peer) dist))
                      (kind (get-kind top-peer))
                      (initial-mesg (get-mesg top-peer)))
                  (set-stack! peer '())
                  (set-hop! top-peer total-dist)
                  (let ((begin-mesg/end-mesg (if (sub-mesg? initial-mesg)
                                                 (cons (->sub-begin kind)
                                                       (->sub-end kind))
                                                 (cons (->begin kind)
                                                       (->end kind)))))
                    (let ((begin-mesg (car begin-mesg/end-mesg))
                          (end-mesg (cdr begin-mesg/end-mesg))
                          (revision-dist (compound-kind->distance kind))
                          (kind (if empty (->empty kind) kind)))
                      (let ((nac (adorn-char nc kind end-mesg (- total-dist))))
                        (revise-until! from-top-peer kind revision-dist)
                        (set-mesg! top-peer begin-mesg)
                        (set-stack! nac (cdr peer-stack))
                        (cons nac (car peer-stack))))))))
            (cons (adorn-char nc 'invalid 'unmatched-end) '()))))))

(define (end-compound! ac-list nc)
  (car ((^end-compound! subcompound-mesg? compound:peer/empty?/distance
                        ->sub-begin ->sub-end) ac-list nc)))

(define datumc:end-compound!
  ;; End a compound datum and also end the applicable datum comment.
  (let ((^datumc:end-compound! (^end-compound!
                                datumc-subcompound-mesg?
                                datumc-compound:peer/empty?/distance
                                (lambda (symbol) 'datumc-subcompound-begin)
                                (lambda (symbol) 'datumc-subcompound-end))))
    (lambda (ac-list nc)
      (let ((ac/rest (^datumc:end-compound! ac-list nc)))
        (let ((ac (car ac/rest)) (rest (cdr ac/rest)))
          (when (eq? (get-mesg ac) 'datumc-compound-end)
            (let ((p/d (datumc:peer/distance rest)))
              (let ((from-peer (car p/d)) (distance-from-# (cdr p/d)))
                (let* ((initial-# (car from-peer))
                       (initial-#-stack (get-stack initial-#)))
                  (let ((top-peer (caar initial-#-stack))
                        (popped-#-stack (cdr initial-#-stack)))
                    (when (null? popped-#-stack)
                      (set-mesg! ac 'datumc-end)
                      (set-stack! ac (cdar initial-#-stack)))
                    (let* ((intra-compound-dist (get-hop (car rest)))
                           (~distance (+ intra-compound-dist distance-from-#))
                           (total-distance (+ ~distance (get-hop top-peer))))
                      (set-hop! ac (- total-distance))
                      (set-hop! top-peer total-distance)
                      (set-stack! initial-# popped-#-stack)))))))
          ac)))))

(define (symmetric:peer/distance ac-list kind)
  ;; Analogous to above, but for non-nestable datums whose beginning and ending
  ;; delimiters are the same (i.e., strings/identifiers).
  (let ((unmatched-kind (->unmatched kind)))
    (let seek ((rest ac-list) (distance 1))
      (cond ((null? rest) '(#f . 0))
            ((eq? (get-mesg (car rest)) unmatched-kind) (cons rest distance))
            (else (seek (cdr rest) (+ distance 1)))))))

(define (begin-symmetric ac-list nc kind)
  (let ((new-ac (adorn-char nc kind (->unmatched kind) 0)))
    (set-stack! new-ac (list (cons new-ac ac-list)))
    new-ac))

(define (^end-symmetric! ac-list nc kind)
  (let ((p/d (symmetric:peer/distance ac-list kind)))
    (let ((from-peer (car p/d)) (distance (cdr p/d)))
      (or from-peer (error "Unable to find beginning of symmetric datum"))
      (let ((peer (car from-peer)))
        (set-hop! peer distance)
        (set-mesg! peer (->begin kind))
        (set-stack! peer '()))
      (cons from-peer distance))))

(define (revise-rt-syntax-ident! ac-list)
  (unless (null? ac-list)
    (let* ((ac (car ac-list)) (kind (get-kind ac)))
      (cond ((eq? kind '~rt-syntax-ident)
             (set-kind! ac 'rt-syntax-ident)
             (revise-rt-syntax-ident! (cdr ac-list)))
            ((eq? kind '~rt-syntax-ident-esc)
             (set-kind! ac 'rt-syntax-ident-esc)
             (revise-rt-syntax-ident! (cdr ac-list)))))))

(define (end-symmetric! ac-list nc kind)
  (let ((p/d (^end-symmetric! ac-list nc kind)))
    (if (eq? kind '~rt-syntax-ident)
        (let ((tested (cdr (chars-until ac-list '~rt-syntax-ident-begin)))
              (dist (- (cdr p/d))))
          (let ((full-match (matches-one-of-escapes runtime-syntax tested)))
            (cond (full-match
                   (revise-rt-syntax-ident! ac-list)
                   (set-mesg! (car ac-list) (syntax->mesg full-match))
                   (adorn-char nc 'rt-syntax-ident 'rt-syntax-ident-end dist))
                  (else (adorn-char nc '~rt-syntax-ident-end dist)))))
        (adorn-char nc kind (->end kind) (- (cdr p/d))))))

(define (datumc:end-symmetric! ac-list nc sym)
  (let* ((p/d (^end-symmetric! ac-list nc sym))
         (datumc:p/d (datumc:peer/distance (car p/d))))
    (let ((from-dc-peer (car datumc:p/d)) (dc-distance (cdr datumc:p/d)))
      (let* ((nearest-peer (car from-dc-peer))
             (stack (get-stack nearest-peer))
             (top-peer (caar stack))
             (total-dist (+ (cdr p/d) dc-distance (get-hop top-peer))))
        (set-hop! top-peer total-dist)
        (let ((rest (cdr stack)))
          (set-stack! nearest-peer rest)
          (if (null? rest)
              (adorn-char nc 'datumc 'datumc-end (- total-dist) (cdar stack))
              (adorn-char nc 'datumc 'datumc-string-end (- total-dist))))))))
