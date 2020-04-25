;;;============================================================================

;;; File: "filesystem.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Filesystem operations.

(define-library (filesystem)

  (namespace "##")

  (export

;; r7rs

file-exists?
delete-file

;; gambit

copy-file
create-directory
create-fifo
create-link
create-symbolic-link
create-temporary-directory
current-directory
delete-directory
delete-file-or-directory
directory-files
executable-path
;;UNIMPLEMENTED file-attributes
;;UNIMPLEMENTED file-creation-time
;;UNIMPLEMENTED file-device
;;UNIMPLEMENTED file-error?
;;UNIMPLEMENTED file-group
file-info
file-info-attributes
file-info-creation-time
file-info-device
file-info-group
file-info-inode
file-info-last-access-time
file-info-last-change-time
file-info-last-modification-time
file-info-mode
file-info-number-of-links
file-info-owner
file-info-size
file-info-type
file-info?
;;UNIMPLEMENTED file-inode
file-last-access-and-modification-times-set!
;;UNIMPLEMENTED file-last-access-time
;;UNIMPLEMENTED file-last-change-time
;;UNIMPLEMENTED file-last-modification-time
;;UNIMPLEMENTED file-mode
;;UNIMPLEMENTED file-number-of-links
;;UNIMPLEMENTED file-owner
;;UNIMPLEMENTED file-size
;;UNIMPLEMENTED file-type
path-directory
path-expand
path-extension
path-normalize
path-strip-directory
path-strip-extension
path-strip-trailing-directory-separator
path-strip-volume
path-volume
rename-file

))

;;;============================================================================
