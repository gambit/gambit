;;; -*- Mode:Emacs-Lisp -*-
;;; gambit.el --- Run Gambit in an [X]Emacs buffer

;; Copyright (c) 1997-2004 Marc Feeley & Michael Sperber

;; Authors: Marc Feeley <feeley@iro.umontreal.ca>
;;          Mike Sperber <sperber@informatik.uni-tuebingen.de>
;; Keywords: processes, lisp

;; To use this package, make sure this file is accessible from your
;; load-path and that the following lines are in your ".emacs" file:
;;
;; (autoload 'gambit-inferior-mode "gambit" "Hook Gambit mode into cmuscheme.")
;; (autoload 'gambit-mode "gambit" "Hook Gambit mode into scheme.")
;; (add-hook 'inferior-scheme-mode-hook (function gambit-inferior-mode))
;; (add-hook 'scheme-mode-hook (function gambit-mode))
;; (setq scheme-program-name "gsi -:t")
;;
;; Alternatively, if you don't mind always loading this package,
;; you can simply add this line to your ".emacs" file:
;;
;; (require 'gambit)
;;
;; You can then start Gambit with "M-x run-scheme".
;;
;; When Gambit signals an error, Emacs will intercept the location
;; information in the error message and automatically open a buffer
;; highlighting the error.
;;
;; The continuation of the error can be inspected with the "C-c ["
;; (crawl towards older frames) and "C-c ]" (crawl towards newer
;; frames).  For each new frame visited, Emacs will highlight the
;; expression associated with the frame.
;;
;; "C-c c", "C-c s" and "C-c l" can be used to send the commands
;; ",c", ",s" and ",l" respectively to Gambit.  This is convenient for
;; single-stepping a program.
;;
;; "C-c _" can be used to delete the last popup window that was
;; created to highlight a Scheme expression.

;;;----------------------------------------------------------------------------

;; User overridable parameters.

(defvar scheme-program-name "gsi -:d-")

(defvar gambit-repl-command-prefix "\C-c"
  "Emacs keybinding prefix for Gambit REPL's commands.")

(defvar gambit-highlight-color "gold"
  "Color of the overlay for highlighting Scheme expressions.")

(defvar gambit-highlight-face
  (let ((face 'gambit-highlight-face))
    (condition-case nil
        (progn
          (make-face face)
          (if (x-display-color-p)
              (set-face-background face gambit-highlight-color)
              (progn
                ;(make-face-bold face)
                (set-face-underline-p face t))))
        (error (setq face nil)))
    face)
  "Face of overlay for highlighting Scheme expressions.")

(defvar gambit-new-window-height 6
  "Height of a window opened to highlight a Scheme expression.")

(defvar gambit-move-to-highlighted (not gambit-highlight-face)
  "Flag to move to window opened to highlight a Scheme expression.")

;;;----------------------------------------------------------------------------

;; These must be loaded first because we redefine some of the
;; functions they contain.

(require 'scheme)
(require 'cmuscheme)

;;;----------------------------------------------------------------------------

(defun gambit-indent-function (indent-point state)
  (let ((normal-indent (current-column)))
    (goto-char (1+ (elt state 1)))
    (parse-partial-sexp (point) calculate-lisp-indent-last-sexp 0 t)
    (if (and (elt state 2)
             (not (looking-at "\\sw\\|\\s_")))
        ;; car of form doesn't seem to be a a symbol
        (progn
          (if (not (> (save-excursion (forward-line 1) (point))
                      calculate-lisp-indent-last-sexp))
              (progn (goto-char calculate-lisp-indent-last-sexp)
                     (beginning-of-line)
                     (parse-partial-sexp (point)
                                         calculate-lisp-indent-last-sexp 0 t)))
          ;; Indent under the list or under the first sexp on the same
          ;; line as calculate-lisp-indent-last-sexp.  Note that first
          ;; thing on that line has to be complete sexp since we are
          ;; inside the innermost containing sexp.
          (backward-prefix-chars)
          (current-column))
      (let ((function (buffer-substring (point)
                                        (progn (forward-sexp 1) (point))))
            method)
        (setq method (or (gambit-indent-method function)
                         (get (intern-soft function) 'scheme-indent-function)
                         (get (intern-soft function) 'scheme-indent-hook)))
        (cond ((or (eq method 'defun)
                   (and (null method)
                        (> (length function) 3)
                        (string-match "\\`def" function)))
               (lisp-indent-defform state indent-point))
              ((integerp method)
               (lisp-indent-specform method state
                                     indent-point normal-indent))
              (method
                (funcall method state indent-point normal-indent)))))))

(defun gambit-indent-method (function)
  (let ((method nil)
        (alist gambit-indent-regexp-alist))
    (while (and (not method) (not (null alist)))
      (let* ((regexp (car alist))
             (x (string-match (car regexp) function)))
        (if x
            (setq method (cdr regexp)))
        (setq alist (cdr alist))))
    method))

(set lisp-indent-function 'gambit-indent-function)

(defvar gambit-indent-regexp-alist
  '(
    ("^declare$"               . defun)
    ("^##declare$"             . defun)
    ("^##define"               . defun)
    ("^macro-check"            . defun)
    ("^macro-force-vars$"      . defun)
    ("^macro-number-dispatch$" . defun)
   ))

;;;----------------------------------------------------------------------------

;; Portable functions for FSF Emacs and Xemacs.

(defun window-top-edge (window)
  (if (fboundp 'window-edges)
      (car (cdr (window-edges window)))
      (car (cdr (window-pixel-edges window)))))

;; Xemacs calls its overlays "extents", so we have to use them to emulate 
;; overlays on Xemacs.  Some versions of Xemacs have the portability package
;; "overlays.el" for this, so we could simply do:
;;
;; (condition-case nil ; load "overlay.el" if we have it
;;     (require 'overlay)
;;   (error nil))
;;
;; Unfortunately some versions of Xemacs don't have this package so
;; we explicitly define an interface to extents.

(if (not (fboundp 'make-overlay))
    (defun make-overlay (start end)
      (make-extent start end)))

(if (not (fboundp 'overlay-put))
    (defun overlay-put (overlay prop val)
      (set-extent-property overlay prop val)))

(if (not (fboundp 'move-overlay))
    (defun move-overlay (overlay start end buffer)
      (set-extent-endpoints overlay start end buffer)))

;;;----------------------------------------------------------------------------

;; Redefine the function scheme-send-region from `cmuscheme' so
;; that we can keep track of all text sent to Gambit's stdin.

(defun scheme-send-region (start end)
  "Send the current region to the inferior Scheme process."
  (interactive "r")
  (scheme-send-string (buffer-substring start end)))

(defun scheme-send-string (str)
  "Send a string to the inferior Scheme process."
  (let* ((clean-str (gambit-string-terminate-with-newline str))
         (proc (scheme-proc))
         (pmark (process-mark proc))
         (buffer (get-buffer scheme-buffer))
         (old-buffer (current-buffer)))
    (set-buffer buffer)
    (goto-char pmark)
    (set-marker comint-last-input-start (point))
    (insert clean-str)
    (set-marker pmark (point))
    (gambit-input-sender proc clean-str)
    (set-buffer old-buffer)))

(defun gambit-input-sender (proc str)
  (let ((clean-str (gambit-string-terminate-with-newline str)))
    (gambit-register-input clean-str)
    (gambit-make-read-only (current-buffer) (point-max))
    (gambit-unhighlight)
    (comint-send-string proc clean-str)))

(defun gambit-register-input (str)
  (let ((marker (make-marker)))
    (set-marker marker comint-last-input-start)
    (setq gambit-input-line-marker-alist
          (cons (cons gambit-input-line-count
                      marker)
                gambit-input-line-marker-alist))
    (setq gambit-input-line-count
          (+ gambit-input-line-count
             (gambit-string-count-lines str)))))

(defun gambit-make-read-only (buffer end)
  ' ; disable read-only interaction, cause it doesn't work!
  (progn
    (put-text-property 1 end 'front-sticky '(read-only) buffer)
    (put-text-property 1 end 'rear-nonsticky '(read-only) buffer)
    (put-text-property 1 end 'read-only t buffer)))

;;;----------------------------------------------------------------------------

(defun gambit-load-file (file-name)
  "Load a Scheme file FILE-NAME into the inferior Scheme process."
  (interactive (comint-get-source "Load Scheme file: " scheme-prev-l/c-dir/file
                                  scheme-source-modes t)) ; T because LOAD
                                                          ; needs an exact name
  (comint-check-source file-name) ; Check to see if buffer needs saved.
  (setq scheme-prev-l/c-dir/file (cons (file-name-directory    file-name)
                                       (file-name-nondirectory file-name)))
  (scheme-send-string (concat "(load \"" file-name "\"\)\n")))

(defun gambit-compile-file (file-name)
  "Compile a Scheme file FILE-NAME in the inferior Scheme process."
  (interactive (comint-get-source "Compile Scheme file: "
                                  scheme-prev-l/c-dir/file
                                  scheme-source-modes
                                  nil)) ; NIL because COMPILE doesn't
                                        ; need an exact name.
  (comint-check-source file-name) ; Check to see if buffer needs saved.
  (setq scheme-prev-l/c-dir/file (cons (file-name-directory    file-name)
                                       (file-name-nondirectory file-name)))
  (scheme-send-string (concat "(compile-file \"" file-name "\"\)\n")))

;;;----------------------------------------------------------------------------

;; Buffer local variables of the Gambit inferior process(es).

(defvar gambit-input-line-count nil
  "Line number as seen by the Gambit process.")

(defvar gambit-input-line-marker-alist nil
  "Alist of line numbers of input blocks and markers.")

(defvar gambit-last-output-marker nil
  "Points to the last character output by the Gambit process.")

;;;----------------------------------------------------------------------------

;; Utilities

(defun gambit-string-count-lines (str)
  "Returns number of complete lines in string."
  (let ((n 0)
        (start 0))
    (while (string-match "\n" str start)
      (setq n (+ n 1))
      (setq start (match-end 0)))
    n))

(defun gambit-string-terminate-with-newline (str)
  "Adds a newline at end of string if it doesn't already have one."
  (let ((len (length str)))
    (if (or (= len 0)
            (not (equal (aref str (- len 1)) ?\n)))
        (concat str "\n")
        str)))

;;;----------------------------------------------------------------------------

;; Define keys for single stepping and continuation crawling.

(defun gambit-step-continuation ()
  (interactive)
  (scheme-send-string "#||#,s;"))

(defun gambit-leap-continuation ()
  (interactive)
  (scheme-send-string "#||#,l;"))

(defun gambit-continue ()
  (interactive)
  (scheme-send-string "#||#,c;"))

(defun gambit-environment ()
  (interactive)
  (scheme-send-string "#||#,e;"))

(defun gambit-backtrace ()
  (interactive)
  (scheme-send-string "#||#,b;"))

(defun gambit-crawl-backtrace-newer ()
  (interactive)
  (scheme-send-string "#||#,-;"))
  
(defun gambit-crawl-backtrace-older ()
  (interactive)
  (scheme-send-string "#||#,+;"))

(defun gambit-kill-last-popup ()
  (interactive)
  (let ((windows gambit-popups))
    (while (not (null windows))
      (let ((window (car windows)))
        (setq windows (cdr windows))
        (if (and window
                 (window-live-p window))
            (progn
              (setq gambit-popups windows)
              (setq windows nil)
              (delete-window window)))))))

(defun gambit-add-popup (popup)
  (setq gambit-popups
        (cons popup (gambit-gc-popups gambit-popups))))

(defun gambit-gc-popups (popups)
  (cond ((null popups)
         '())
        ((window-live-p (car popups))
         (cons (car popups) (gambit-gc-popups (cdr popups))))
        (t
         (gambit-gc-popups (cdr popups)))))

(defvar gambit-popups nil)

;;;----------------------------------------------------------------------------

;; Procedures to intercept and process the location information output
;; by Gambit.

(defun gambit-output-filter (str)
  (let* ((buffer
          (current-buffer))
         (output-marker
          (process-mark (get-buffer-process buffer)))
         (locat
          (if (string-match "\n" str) ; match only after end of line is seen
              (let* ((end
                      (save-excursion
                        (goto-char output-marker)
                        (beginning-of-line)
                        (point)))
                     (start
                      (save-excursion
                        (goto-char (+ gambit-last-output-marker 1))
                        (beginning-of-line)
                        (point))))
                (gambit-extract-location
                 (buffer-substring start end)))
              nil)))
    (gambit-make-read-only buffer output-marker)
    (set-marker gambit-last-output-marker (- output-marker 1))
    (let* ((windows
            (gambit-windows-displaying-buffer buffer))
           (initially-selected-window
            (selected-window)))
      (if (not (null windows))
          (save-excursion
            (set-buffer buffer)
            (select-window (car windows))
            (goto-char output-marker)
            (if (not (pos-visible-in-window-p))
                (recenter -1))
            (select-window initially-selected-window))))
    (if locat
        (gambit-highlight-location locat))))

(defun gambit-extract-location (str)
  (let ((location nil)
        (alist gambit-location-regexp-alist))
    (while (and (not location) (not (null alist)))
      (let* ((regexp (car alist))
             (x (string-match (car regexp) str)))
        (if x
            (let* ((pos1 (nth 1 regexp))
                   (pos2 (nth 2 regexp))
                   (pos3 (nth 3 regexp))
                   (name (substring str
                                    (match-beginning pos1)
                                    (match-end pos1)))
                   (line (substring str
                                    (match-beginning pos2)
                                    (match-end pos2)))
                   (column (substring str
                                      (match-beginning pos3)
                                      (match-end pos3))))
              (setq location (list (read name) (read line) (read column)))))
        (setq alist (cdr alist))))
    location))

(defvar gambit-location-regexp-alist
  '(("\\(\\\"\\(\\\\\\\\\\|\\\\\"\\|[^\\\"\n]\\)+\\\"\\)@\\([0-9]+\\)\\.\\([0-9]+\\)[^0-9]" 1 3 4)
    ("\\((console)\\)@\\([0-9]+\\)\\.\\([0-9]+\\)[^0-9]" 1 2 3)
    ("\\((stdin)\\)@\\([0-9]+\\)\\.\\([0-9]+\\)[^0-9]" 1 2 3)))

(defun gambit-closest-non-following (line alist)
  (let ((closest nil))
    (while (not (null alist))
      (let ((x (car alist)))
        (if (and (<= (car x) line)
                 (or (not closest)
                     (> (car x) (car closest))))
            (setq closest x))
        (setq alist (cdr alist))))
    closest))

(defun gambit-highlight-location (locat)

  ; invariant: the current buffer is the Scheme buffer

  (let ((name (car locat))
        (line (car (cdr locat)))
        (column (car (cdr (cdr locat)))))
    (cond ((or (equal name '(console))
               (equal name '(stdin)))
           (let ((closest
                  (gambit-closest-non-following
                   line
                   gambit-input-line-marker-alist)))
             (if closest
                 (let ((n (- line (car closest))))
                   (gambit-highlight-expression
                    (current-buffer)
                    (save-excursion
                      (goto-char (cdr closest))
                      (if (> n 0) (forward-line n))
                      (forward-char (- column 1))
                      (point)))))))
          ((stringp name)
           (let ((buffer (find-file-noselect name)))
             (if buffer
                 (gambit-highlight-expression
                  buffer
                  (save-excursion
                    (set-buffer buffer)
                    (goto-line line)
                    (forward-char (- column 1))
                    (point)))))))))

(defun gambit-highlight-expression (location-buffer pos)

"Highlight the expression at a specific location in a buffer.

The location buffer is the one that contains the location to
highlight and "pos" points to the first character of the
expression in the buffer.  If the location buffer is not visible
then we must display it in a window.  We also have to make sure
the highlighted expression is visible, which may require the
window to be scrolled.

Our approach is simple: if the location buffer is not visible or
it is the Scheme buffer and it is only displayed in the selected
window, then we split one of the windows in 2 and use the bottom
window to display the location buffer.  The window chosen is
preferentially the topmost window displaying the Scheme buffer,
otherwise it is the selected window.  Before we do the split, we
enlarge the window if it is too small."

  (let* ((location-windows
          (gambit-windows-displaying-buffer location-buffer))
         (initially-selected-window
          (selected-window)))

    ; "location-windows" is the list of windows containing
    ; the location buffer.

    (if (or (null location-windows)
            (and (eq location-buffer (get-buffer scheme-buffer))
                 (eq initially-selected-window (car location-windows))
                 (null (cdr location-windows))))

        (let* ((scheme-windows
                (gambit-windows-displaying-buffer (get-buffer scheme-buffer)))
               (window-to-split
                (if (null scheme-windows)
                    initially-selected-window
                    (car scheme-windows)))
               (height
                (window-height window-to-split)))
          (select-window window-to-split)
          (if (< height (* 2 gambit-new-window-height))
              (enlarge-window
               (- (* 2 gambit-new-window-height)
                  height)))
          (let ((bottom-window
                 (split-window
                  window-to-split
                  (- (window-height window-to-split)
                     gambit-new-window-height))))
            (gambit-add-popup bottom-window)
            (select-window bottom-window)
            (switch-to-buffer location-buffer)))

        (select-window (car (reverse location-windows))))

    ; Highlight the expression in the location buffer.

    (save-excursion
      (set-buffer (window-buffer (selected-window)))
      (goto-char pos)
      (if (not (pos-visible-in-window-p))
          (recenter (- (/ (window-height) 2) 1)))
      (gambit-highlight-region
       location-buffer
       pos
       (progn
         (condition-case nil
           (forward-sexp) ; we assume this uses the same syntax as Gambit
           (error ; if forward-sexp fails with this condition name
            (forward-char 1)))
         (point)))
      (goto-char pos))

    (if (not (eq initially-selected-window (selected-window)))
        (progn
          (goto-char pos)
          (if (not gambit-move-to-highlighted)
              (select-window initially-selected-window))))))

(defun gambit-windows-displaying-buffer (buffer)
  (let ((windows '()))
    (walk-windows (function
                   (lambda (w)
                     (if (eq buffer (window-buffer w))
                         (setq windows (cons w windows)))))
                  t
                  'visible)
    (sort windows
          (function
           (lambda (w1 w2)
             (< (window-top-edge w1)
                (window-top-edge w2)))))))

(defvar gambit-highlight-overlay
  (let ((ovl (make-overlay (point-min) (point-min))))
    (overlay-put ovl 'face gambit-highlight-face)
    ovl)
  "Overlay for highlighting Scheme expressions.")

(defun gambit-highlight-region (buffer start end)
  (if gambit-highlight-overlay
      (move-overlay gambit-highlight-overlay start end buffer)))

(defun gambit-unhighlight ()
  (gambit-highlight-region (get-buffer scheme-buffer) 1 1))

;;;----------------------------------------------------------------------------

(defun gambit-install-comment-syntax ()
  "Configure #| ... |# comments."
  ;; XEmacs 19 and beyond use 8-bit modify-syntax-entry flags.
  ;; Emacs 19 uses a 1-bit flag.  We will have to set up our
  ;; syntax tables differently to handle this.
  ;; Stolen from CC Mode.
  (let ((table (copy-syntax-table))
        entry)
    (modify-syntax-entry ?a ". 12345678" table)
    (cond
     ;; XEmacs 19, and beyond Emacs 19.34
     ((arrayp table)
      (setq entry (aref table ?a))
      ;; In Emacs, table entries are cons cells
      (if (consp entry) (setq entry (car entry))))
     ;; XEmacs 20
     ((fboundp 'get-char-table) (setq entry (get-char-table ?a table)))
     ;; before and including Emacs 19.34
     ((and (fboundp 'char-table-p)
           (char-table-p table))
      (setq entry (car (char-table-range table [?a]))))
     ;; incompatible
     (t (error "Gambit mode is incompatible with this version of Emacs")))
    (if (= (logand (lsh entry -16) 255) 255)
        (progn
          ;; XEmacs 19 & 20
          (modify-syntax-entry ?# "(#58" scheme-mode-syntax-table)
          (modify-syntax-entry ?| ". 67" scheme-mode-syntax-table))
      ;; Emacs 19 & 20
      (modify-syntax-entry ?# "_ 14" scheme-mode-syntax-table)
      (modify-syntax-entry ?| "\" 23" scheme-mode-syntax-table))))

(defun gambit-extend-mode-map (map)
  (define-key map [(f8)]  'gambit-continue)
  (define-key map [(f9)]  'gambit-crawl-backtrace-newer)
  (define-key map [(f10)] 'gambit-crawl-backtrace-older)
  (define-key map [(f11)] 'gambit-step-continuation)
  (define-key map [(f12)] 'gambit-leap-continuation)

  (define-key map "\C-c\C-l" 'gambit-load-file)
  (define-key map "\C-c\C-k" 'gambit-compile-file)

  (let ((prefix gambit-repl-command-prefix))
    (define-key map (concat prefix "c") 'gambit-continue)
    (define-key map (concat prefix "]") 'gambit-crawl-backtrace-newer)
    (define-key map (concat prefix "[") 'gambit-crawl-backtrace-older)
    (define-key map (concat prefix "s") 'gambit-step-continuation)
    (define-key map (concat prefix "l") 'gambit-leap-continuation)
    (define-key map (concat prefix "_") 'gambit-kill-last-popup)))

(defun gambit-inferior-mode ()

  (gambit-install-comment-syntax)
  (gambit-extend-mode-map inferior-scheme-mode-map)

  (make-local-variable 'gambit-input-line-count)
  (setq gambit-input-line-count 1)

  (make-local-variable 'gambit-input-line-marker-alist)
  (setq gambit-input-line-marker-alist '())

  (make-local-variable 'gambit-last-output-marker)
  (setq gambit-last-output-marker (make-marker))
  (set-marker gambit-last-output-marker 0)

  (setq comint-input-sender (function gambit-input-sender))

  (add-hook 'comint-output-filter-functions
            (function gambit-output-filter)
            t
            t)) ; hook is buffer-local

(defun gambit-mode ()
  (gambit-install-comment-syntax)
  (gambit-extend-mode-map scheme-mode-map))

;;(autoload 'gambit-inferior-mode "gambit" "Hook Gambit mode into cmuscheme.")
;;(autoload 'gambit-mode "gambit" "Hook Gambit mode into scheme.")
(add-hook 'inferior-scheme-mode-hook (function gambit-inferior-mode))
(add-hook 'scheme-mode-hook (function gambit-mode))

(provide 'gambit)

;;;----------------------------------------------------------------------------
