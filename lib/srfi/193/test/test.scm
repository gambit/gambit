;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2020-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 193, Command line

(import (srfi 193))
(import (_test))

;;;============================================================================

(test-assert (list? (command-line)))
(test-assert (not (member #f (map string? (command-line)))))
(test-assert (>= (length (command-line)) 1))

(test-assert (or (not (command-name)) (string? (command-name))))

(test-assert (list? (command-args)))
(test-assert (not (member #f (map string? (command-args)))))
(test-assert (>= (length (command-args)) 0))

(test-assert (or (not (script-file)) (string? (script-file))))
(test-assert (or (not (script-file)) (file-exists? (script-file))))

(test-assert (or (not (script-directory)) (string? (script-directory))))

(test-assert (or (not (script-file))
                 (not (script-directory))
                 (string=? (path-directory (script-file)) (script-directory))))

;;;============================================================================
