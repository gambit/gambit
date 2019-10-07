;;;============================================================================

;;; File: "_git#.scm"

;;; Copyright (c) 2019 by Frédéric Hamel, All Rights Reserved.
;;; Copyright (c) 2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##namespace ("_git#"

git-archive
git-clone
git-command
;; git-fetch
;; git-merge
git-pull
git-status
git-tag
git-repository-open

macro-git-repository?
macro-git-repository-path

))

(define-type git-repository
  id: AF9B3B94-EE56-4D95-A323-AEE3C97E70FC
  constructor: macro-make-git-repository
  implementer: implement-type-git-repository
  copier: #f
  opaque:
  macros:
  prefix: macro-

  (path       no-functional-setter: read-only:))

;;;============================================================================
