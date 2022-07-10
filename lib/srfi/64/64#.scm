;;;============================================================================

;;; File: "64#.scm"

;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 64, A Scheme API for test suites

;; export a subset of _test exports

(##namespace ("_test#"

test-assert
test-equal
test-eqv
test-eq
test-approximate
test-error
test-begin
test-end
test-group

%test-predicate
%test-relation
%test-approximate
%test-error
%test-begin
%test-end
%test-group

))

;;;----------------------------------------------------------------------------

(##define-syntax test-assert      (lambda (src)
                                    (##import _test/test-expand)
                                    (test-expand src 'test-assert)))

(##define-syntax test-equal       (lambda (src)
                                    (##import _test/test-expand)
                                    (test-expand src 'test-equal)))

(##define-syntax test-eqv         (lambda (src)
                                    (##import _test/test-expand)
                                    (test-expand src 'test-eqv)))

(##define-syntax test-eq          (lambda (src)
                                    (##import _test/test-expand)
                                    (test-expand src 'test-eq)))

(##define-syntax test-approximate (lambda (src)
                                    (##import _test/test-expand)
                                    (test-expand src 'test-approximate)))

(##define-syntax test-error       (lambda (src)
                                    (##import _test/test-expand)
                                    (test-expand src 'test-error)))

(##define-syntax test-begin       (lambda (src)
                                    (##import _test/test-expand)
                                    (test-expand src 'test-begin)))

(##define-syntax test-end         (lambda (src)
                                    (##import _test/test-expand)
                                    (test-expand src 'test-end)))

(##define-syntax test-group       (lambda (src)
                                    (##import _test/test-expand)
                                    (test-expand src 'test-group)))

;;;============================================================================
