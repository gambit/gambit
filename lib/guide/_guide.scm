;==============================================================================

; File: "_guide.scm", Time-stamp: <2007-04-04 11:33:22 feeley>

; Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved.

;==============================================================================

(##include "../../lib/header.scm")
(##include "_guide#.scm")

;==============================================================================

(c-declare #<<end-of-c-declare

#include "_guide.h"
#include "guide.h"

end-of-c-declare
)

(c-define-type QString "QString" "QString_to_SCMOBJ" "SCMOBJ_to_QString" #f)
(c-define-type QApplication "QApplication")
(c-define-type QApplication* (pointer QApplication))
(c-define-type GuideUiMainWindow "GuideUiMainWindow")
(c-define-type GuideUiMainWindow* (pointer GuideUiMainWindow))
(c-define-type GuideUiScheme "GuideUiScheme")
(c-define-type GuideUiScheme* (pointer GuideUiScheme))

(define ##QApplication-new
  (c-lambda (nonnull-char-string-list) QApplication* "QApplication_new"))

(define ##QApplication-processEvents
  (c-lambda (QApplication*) void "QApplication_processEvents"))

(define ##GuideUiMainWindow-new
  (c-lambda () GuideUiMainWindow* "GuideUiMainWindow_new"))

(define ##GuideUiScheme-new
  (c-lambda (GuideUiMainWindow* QString scheme-object) GuideUiScheme* "GuideUiScheme_new"))

(define ##GuideUiScheme-print-text
  (c-lambda (GuideUiScheme* QString) void "GuideUiScheme_print_text"))

(c-define (##GuideUiScheme-typed-text channel text)
  (scheme-object QString) void "GuideUiScheme_typed_text" ""
  (let ((far (macro-repl-channel-guide-far-port channel)))
    (##write-string text far)))

(c-define (##GuideUiScheme-typed-eof channel)
  (scheme-object) void "GuideUiScheme_typed_eof" ""
  (let ((far (macro-repl-channel-guide-far-port channel)))
    (##close-output-port far)))

(define ##GuideUiScheme-continuation-set-highlight
  (c-lambda (GuideUiScheme* int) void "GuideUiScheme_continuation_set_highlight"))

(define ##GuideUiScheme-continuation-set-cell
  (c-lambda (GuideUiScheme* int int QString) void "GuideUiScheme_continuation_set_cell"))

(define ##GuideUiScheme-continuation-set-length
  (c-lambda (GuideUiScheme* int) void "GuideUiScheme_continuation_set_length"))

(define ##GuideUiScheme-environment-set-cell
  (c-lambda (GuideUiScheme* int int QString) void "GuideUiScheme_environment_set_cell"))

(define ##GuideUiScheme-environment-set-length
  (c-lambda (GuideUiScheme* int) void "GuideUiScheme_environment_set_length"))

(define ##GuideUiScheme-highlight-expr-in-console
  (c-lambda (GuideUiScheme* int int) void "GuideUiScheme_highlight_expr_in_console"))

(define ##GuideUiScheme-highlight-expr-in-file
  (c-lambda (GuideUiScheme* int int QString) void "GuideUiScheme_highlight_expr_in_file"))

;==============================================================================

(implement-type-repl-channel-guide)

(define-prim (##make-repl-channel-guide)
  (let ((ct (macro-current-thread)))
    (receive (near far)
             (##open-string-pipe '(buffering: #f permanent-close: #f))

      (macro-port-name-set! near (lambda (port) ct))

      (let ((channel
             (##still-copy
              (macro-make-repl-channel-guide

               (##make-mutex #f)
               (macro-current-thread)
               near
               near

               (lambda (channel level depth) ; read-command

                 (define prompt "> ")

                 (let ((output-port (macro-repl-channel-output-port channel)))
                   (if (##fixnum.< 0 level)
                     (##write level output-port))
                   (if (##fixnum.< 0 depth)
                     (begin
                       (##write-string "\\" output-port)
                       (##write depth output-port)))
                   (##write-string prompt output-port)
                   (##force-output output-port))

                 (let ((input-port (macro-repl-channel-input-port channel))
                       (output-port (macro-repl-channel-output-port channel)))
                   (let ((result (##read-expr-from-port input-port)))
                     (##output-port-column-set! output-port 1)
                     result)))

               (lambda (channel results) ; write-results
                 (let ((output-port (macro-repl-channel-output-port channel)))
                   (##for-each
                    (lambda (obj)
                      (if (##not (##eq? obj (##void)))
                        (##pretty-print obj output-port)))
                    results)))

               (lambda (channel writer) ; display-monoline-message
                 (let ((output-port (macro-repl-channel-output-port channel)))
                   (writer output-port)
                   (##newline output-port)))

               (lambda (channel writer) ; display-multiline-message
                 (let ((output-port (macro-repl-channel-output-port channel)))
                   (writer output-port)))

               ##repl-channel-guide-display-continuation ; display-continuation

               ##repl-channel-guide-pinpoint-continuation ; pinpoint-continuation

               (lambda (channel) ; really-quit?
                 (let ((input-port (macro-repl-channel-input-port channel))
                       (output-port (macro-repl-channel-output-port channel)))
                   (##write-string "*** EOF again to exit" output-port)
                   (##newline output-port)
                   (##not (##char? (##peek-char input-port)))))

               (lambda (channel) ; newline
                 (let ((output-port (macro-repl-channel-output-port channel)))
                   (##newline output-port)))

               far

               #f))))

        (macro-repl-channel-guide-GuideUiScheme-set!
         channel
         (##GuideUiScheme-new
          (##guide-main-window)
          (##object->string ct)
          channel))

        (##thread-start!
         (make-thread
          (lambda ()
            (let ((far (macro-repl-channel-guide-far-port channel)))

              (define (input-timeout-set! timeout)
                (##input-port-timeout-set! far timeout (lambda () #f)))

              (let loop ()
                (##peek-char far)
                (input-timeout-set! -inf.0)
                (let ((text (##read-line far #f #t #f)))
                  (input-timeout-set! #f)
                  (##GuideUiScheme-print-text
                   (macro-repl-channel-guide-GuideUiScheme channel)
                   text)
                  (loop)))))))

        channel))))

(define-prim (##repl-channel-guide-pinpoint-continuation channel cont)
  (and cont
       (let ((locat (##continuation-locat cont)))
         (and locat
              (let* ((filepos (##position->filepos (##locat-position locat)))
                     (line (##fixnum.+ (##filepos-line filepos) 1))
                     (col (##fixnum.+ (##filepos-col filepos) 1))
                     (container (##locat-container locat))
                     (file (##container->file container)))
                (if file
                  (begin
                    (##GuideUiScheme-highlight-expr-in-file
                     (macro-repl-channel-guide-GuideUiScheme channel)
                     line
                     col
                     file)
                    #t)
                  (if (##thread? container)
                    (begin
                      (##GuideUiScheme-highlight-expr-in-console
                       (##thread-repl-channel-get! container)
                       line
                       col)
                      #t)
                    #f)))))))

(define-prim (##repl-channel-guide-display-continuation channel cont depth)

  (define (display-frame cont i)

    (##GuideUiScheme-continuation-set-cell
     (macro-repl-channel-guide-GuideUiScheme channel)
     i
     0
     (##object->string i))

    (##GuideUiScheme-continuation-set-cell
     (macro-repl-channel-guide-GuideUiScheme channel)
     i
     1
     (##object->string
      (let ((creator (##continuation-creator cont)))
        (if creator
          (##procedure-name creator)
          '(interaction)))))

    (##GuideUiScheme-continuation-set-cell
     (macro-repl-channel-guide-GuideUiScheme channel)
     i
     2
     (let ((p (##open-output-string)))
       (let ((locat (##continuation-locat cont)))
         (##display-locat locat #t p)
         (##get-output-string p))))

    (##GuideUiScheme-continuation-set-cell
     (macro-repl-channel-guide-GuideUiScheme channel)
     i
     3
     (let ((call
            (if (##interp-continuation? cont)
              (let* (($code (##interp-continuation-code cont))
                     (cprc (macro-code-cprc $code)))
                (if (##eq? cprc ##interp-procedure-wrapper)
                  #f
                  (##decomp $code)))
              (let* ((ret (##continuation-ret cont))
                     (call (##decompile ret)))
                (if (##eq? call ret)
                  #f
                  call)))))
       (if call
         (##object->string call 100)
         ""))))

  (define (display-cont cont depth)
    (let loop ((i 0)
               (cont cont))
      (if cont
        (begin
          (display-frame cont i)
          (if (##fixnum.= i depth)
            (display-env cont))
          (loop (##fixnum.+ i 1)
                (##continuation-next-interesting cont)))
        (begin
          (##GuideUiScheme-continuation-set-length
           (macro-repl-channel-guide-GuideUiScheme channel)
           i)
          (##GuideUiScheme-continuation-set-highlight
           (macro-repl-channel-guide-GuideUiScheme channel)
           depth)))))

  (define (display-env cont)

    (define (display-var-val var val cte row)
      (let ((var-str
             (##object->string var))
            (val-str
             (##object->string
              (if (##cte-top? cte)
                (##inverse-eval-in-env val cte)
                (##inverse-eval-in-env val (##cte-parent-cte cte)))
              100)))
        (##GuideUiScheme-environment-set-cell
         (macro-repl-channel-guide-GuideUiScheme channel)
         row
         0
         var-str)
        (##GuideUiScheme-environment-set-cell
         (macro-repl-channel-guide-GuideUiScheme channel)
         row
         1
         val-str)
        (##fixnum.+ row 1)))

    (define (display-rte cte rte row)
      (let loop1 ((c cte)
                  (r rte)
                  (row row))
        (cond ((##cte-top? c)
               row)
              ((##cte-frame? c)
               (let loop2 ((vars (##cte-frame-vars c))
                           (vals (##cdr (##vector->list r)))
                           (row row))
                 (if (##pair? vars)
                   (let ((var (##car vars)))
                     (loop2 (##cdr vars)
                            (##cdr vals)
                            (if (##not (##hidden-local-var? var))
                              (display-var-val var (##car vals) c row)
                              row)))
                   (loop1 (##cte-parent-cte c)
                          (macro-rte-up r)
                          row))))
              (else
               (loop1 (##cte-parent-cte c)
                      r
                      row)))))

    (define (display-vars lst cte row)
      (let loop ((lst lst) (row row))
        (if (##pair? lst)
          (let* ((var-val (##car lst))
                 (var (##car var-val))
                 (val (##cdr var-val)))
            (display-var-val var val cte row)
            (loop (##cdr lst) (##fixnum.+ row 1)))
          row)))

    (define (display-locals lst cte row)
      (if lst
        (display-vars lst cte row)
        row))

    (define (display-parameters lst cte row)
      (let loop ((lst lst) (row row))
        (if (##pair? lst)
          (let* ((param-val (##car lst))
                 (param (##car param-val))
                 (val (##cdr param-val)))
            (loop (##cdr lst)
                  (if (##hidden-parameter? param)
                    row
                    (let ((x (##inverse-eval-in-env param cte)))
                      (display-var-val (##list x) val cte row)))))
          row)))

    (let* ((nb-lex/cte
            (if (##interp-continuation? cont)
              (let (($code (##interp-continuation-code cont))
                    (rte (##interp-continuation-rte cont)))
                (##cons (display-rte (macro-code-cte $code) rte 0)
                        (macro-code-cte $code)))
              (##cons (display-locals (##continuation-locals cont)
                                      ##interaction-cte
                                      0)
                      ##interaction-cte)))
           (nb-rows
            (if cont
              (display-parameters
               (##dynamic-env->list (macro-continuation-denv cont))
               (##cdr nb-lex/cte)
               (##car nb-lex/cte))
              (##car nb-lex/cte))))
      (##GuideUiScheme-environment-set-length
       (macro-repl-channel-guide-GuideUiScheme channel)
       nb-rows)))

  (display-cont cont depth))

;==============================================================================

(set! ##thread-make-repl-channel
  (lambda ()
    (##make-repl-channel-guide)))

(define-prim (##guide-main-window)
  (or ##main-window
      (let* ((app (##QApplication-new (##list (##car (##command-line)))))
             (w (##GuideUiMainWindow-new)))

        (##thread-start!
         (make-thread
          (lambda ()
            (let loop ()
              (##thread-sleep! 0.02)
              (##QApplication-processEvents app)
              (loop)))))

        (set! ##main-window w)
        w)))

(define ##main-window #f)

;==============================================================================
