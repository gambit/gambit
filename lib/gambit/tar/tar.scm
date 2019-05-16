;;;============================================================================

;;; File: "gambit/tar/tar.scm"

;;; Copyright (c) 2006-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Tar file packing/unpacking.

(##declare (extended-bindings) (not safe))

(##include "tar#.scm")

(##supply-module gambit/tar)

(##namespace ("##"
              car
              cdr
              char->integer
              close-input-port
              close-output-port
              cons
              create-directory
              current-directory
              directory-files
              eq?
              floor
              force-output
              fx*
              fx+
              fx-
              fx<
              fx<=
              fx=
              fx>
              fx>=
              fxmin
              fxmodulo
              get-output-u8vector
              inexact->exact
              integer->char
              list
              make-string
              make-u8vector
              not
              number->string
              open-input-file
              open-input-u8vector
              open-output-file
              open-output-u8vector
              pair?
              path-expand
              path-strip-trailing-directory-separator
              raise
              read-subu8vector
              reverse
              string->number
              string->utf8
              string-append
              string-length
              string-ref
              string-set!
              string=?
              substring
              subu8vector
              subu8vector-move!
              u8vector-length
              u8vector-ref
              u8vector-set!
              utf8->string
              void
              write-subu8vector)
             (""
              file-info
              file-info-group
              file-info-last-access-time
              file-info-last-change-time
              file-info-last-modification-time
              file-info-mode
              file-info-owner
              file-info-size
              file-info-type
              file-last-access-and-modification-times-set!
              seconds->time
              time->seconds))

(implement-type-tar-rec)

;;; Representation of exceptions.

(define-type tar-exception
  id: B59622A7-7C4D-448D-B344-2329704672C1
  constructor: macro-make-tar-exception
  copier: #f
  opaque:
  macros:
  prefix: macro-

  (message read-only: no-functional-setter:)
)

(define-macro (header-size) 512)

;;;----------------------------------------------------------------------------

;; Packing tar files.

(define (tar-pack-port tar-rec-list port-out)

  (define tar-format 'gnu) ;; can be gnu, ustar or v7
;;  (define tar-format 'ustar)
;;  (define tar-format 'v7)

  (define use-blanks #f)

  ;; Error handling.

  (define (tar-field-overflow)
    (macro-make-tar-exception "tar field overflow"))

  (define (tar-illegal-field)
    (macro-make-tar-exception "tar illegal field"))

  (define (write-pad n)
    (write-subu8vector
     (make-u8vector n 0)
     0
     n
     port-out)
    #f)

  (define (write-header tr)
    (let ((header (make-u8vector (header-size) 0)))

      (define (string-field str max-length offset)
        (let ((len (string-length str)))
          (if (fx> len max-length)
              (tar-field-overflow)
              (let loop ((i 0))
                (if (fx< i len)
                    (begin
                      (u8vector-set!
                       header
                       (fx+ offset i)
                       (char->integer (string-ref str i)))
                      (loop (fx+ i 1)))
                    #f)))))

      (define (byte-field byte offset)
        (u8vector-set! header offset byte)
        #f)

      (define (octal-field-aux n-str len offset)
        (let ((n-str-len (string-length n-str)))
          (if (fx> n-str-len len)
              (tar-field-overflow)
              (let ((pad (fx- len n-str-len)))
                (let loop ((i 0))
                  (if (fx< i pad)
                      (begin
                        (u8vector-set! header
                                       (fx+ offset i)
                                       (if use-blanks 32 48))
                        (loop (fx+ i 1)))))
                (subu8vector-move!
                 (string->utf8 n-str)
                 0
                 n-str-len
                 header
                 (fx+ offset pad))
                #f))))

      (define (octal-field0 n-str len offset)
        (if use-blanks
            (u8vector-set! header (fx+ offset (fx- len 1)) 32))
        (octal-field-aux n-str (fx- len 1) offset))

      (define (octal-field1 n len offset)
        (octal-field0 (number->string n 8) len offset))

      (define (octal-field2 n len offset)
        (if use-blanks
            (octal-field1 n (fx- len 1) offset)
            (octal-field1 n len offset)))

      (define (octal-field3 n len offset)
        (u8vector-set! header (fx+ offset (fx- len 1)) 0)
        (octal-field-aux (number->string n 8) (fx- len 1) offset))

      (define (checksum)
        (let loop ((i 0))
          (if (fx< i 8)
              (begin
                (u8vector-set! header (fx+ 148 i) 32)
                (loop (fx+ i 1)))))
        (let loop ((sum 0) (i 0))
          (if (fx< i (header-size))
              (loop (fx+ sum (u8vector-ref header i))
                    (fx+ i 1))
              sum)))

      (let* ((name     (macro-tar-rec-name tr))
             (mode     (macro-tar-rec-mode tr))
             (uid      (macro-tar-rec-uid tr))
             (gid      (macro-tar-rec-gid tr))
             (mtime    (macro-tar-rec-mtime tr))
             (type     (macro-tar-rec-type tr))
             (linkname (macro-tar-rec-linkname tr))
             (uname    (macro-tar-rec-uname tr))
             (gname    (macro-tar-rec-gname tr))
             (devmajor (macro-tar-rec-devmajor tr))
             (devminor (macro-tar-rec-devminor tr))
             (atime    (macro-tar-rec-atime tr))
             (ctime    (macro-tar-rec-ctime tr))
             (content  (macro-tar-rec-content tr))
             (size     (u8vector-length content)))
        (or (string-field
             (if (eq? tar-format 'gnu)
                 name
                 (let ((len (string-length name)))
                   (substring name (fx- len (fxmin 100 len)) len)))
             100
             0)
            (octal-field2 mode 8 100)
            (octal-field2 uid 8 108)
            (octal-field2 gid 8 116)
            (octal-field1 size 12 124)
            (octal-field1 mtime 12 136)
            (case type
              ((regular)
               (byte-field (if (eq? tar-format 'v7) 0 48) 156))
              ((link)
               (byte-field 49 156))
              ((symbolic-link)
               (byte-field 50 156))
              ((character-special)
               (byte-field 51 156))
              ((block-special)
               (byte-field 52 156))
              ((directory)
               (byte-field 53 156))
              ((fifo)
               (byte-field 54 156))
              (else
               (tar-illegal-field)))
            (string-field linkname 100 157)
            (case tar-format
              ((gnu)
               (string-field "ustar  " 8 257))
              ((ustar)
               (or (string-field "ustar" 6 257)
                   (string-field "00" 2 263)))
              (else
               #f))
            (string-field uname 32 265)
            (string-field gname 32 297)
            (and devmajor (octal-field1 devmajor 8 329))
            (and devminor (octal-field1 devminor 8 337))
            (if (eq? tar-format 'gnu)
                (or (and atime (octal-field1 atime 12 345))
                    (and ctime (octal-field1 ctime 12 357)))
                (let ((len (string-length name)))
                  (string-field
                   (substring name 0 (fx- len (fxmin 100 len)))
                   155
                   345)))
            (octal-field3 (checksum) 7 148)
            (begin
              (write-subu8vector header 0 (header-size) port-out)
              #f)))))

  (define (write-content tr)
    (let* ((content (macro-tar-rec-content tr))
           (size (u8vector-length content)))
      (write-subu8vector content 0 size port-out)
      (write-pad (fxmodulo (fx- size) 512))))

  (define (write-tar-rec tr)
    (or (write-header tr)
        (write-content tr)))

  (define (write-tar-rec-list tar-rec-list)
    (let loop ((lst tar-rec-list))
      (if (pair? lst)
          (let ((tr (car lst)))
            (or (write-tar-rec tr)
                (loop (cdr lst))))
          #f)))

  (let ((exc (write-tar-rec-list tar-rec-list)))
    (if exc
        (raise exc)
        (begin
          (write-pad (fx* 2 512))
          (void)))))

(define (tar-pack-file tar-rec-list path)
  (let ((port-out (open-output-file path)))
    (tar-pack-port tar-rec-list port-out)
    (close-output-port port-out)
    (void)))

(define (tar-pack-u8vector tar-rec-list)
  (let ((port-out (open-output-u8vector)))
    (tar-pack-port tar-rec-list port-out)
    (get-output-u8vector port-out)))

;;;----------------------------------------------------------------------------

;; Unpacking tar files.

(define (tar-unpack-port port-in)

  ;; Error handling.

  (define (tar-file-truncated-error)
    (macro-make-tar-exception "tar file truncated"))

  (define (tar-header-format-unrecognized-error)
    (macro-make-tar-exception "tar header format unrecognized"))

  (define (tar-header-checksum-error)
    (macro-make-tar-exception "tar header checksum error"))

  (let ((header (make-u8vector (header-size))))

    (define (string-field max-length offset)
      (string-field-aux
       (let loop ((len 0))
         (if (or (fx= len max-length)
                 (fx= (u8vector-ref header (fx+ offset len)) 0))
             len
             (loop (fx+ len 1))))
       offset))

    (define (string-field-aux len offset)
      (let ((str (make-string len)))
        (let loop ((i 0))
          (if (fx< i len)
              (begin
                (string-set!
                 str
                 i
                 (integer->char (u8vector-ref header (fx+ offset i))))
                (loop (fx+ i 1)))
              str))))

    (define (byte-field offset)
      (u8vector-ref header offset))

    (define (octal-field-extract len offset)
      (let loop1 ((start 0))
        (if (and (fx< start len)
                 (fx= 32 (u8vector-ref header (fx+ offset start))))
            (loop1 (fx+ start 1))
            (let loop2 ((end start))
              (if (and (fx< end len)
                       (let ((x (u8vector-ref header (fx+ offset end))))
                         (and (fx>= x 48) (fx<= x 55))))
                  (loop2 (fx+ end 1))
                  (utf8->string
                   (subu8vector header
                                (fx+ offset start)
                                (fx+ offset end))))))))

    (define (octal-field len offset)
      (string->number (octal-field-extract len offset) 8))

    (define (checksum)
      (let loop ((i 0))
        (if (fx< i 8)
            (begin
              (u8vector-set! header (fx+ 148 i) 32)
              (loop (fx+ i 1)))))
      (let loop ((sum 0) (i 0))
        (if (fx< i (header-size))
            (loop (fx+ sum (u8vector-ref header i))
                  (fx+ i 1))
            sum)))

    (define (read-header)
      (let ((n (read-subu8vector header 0 (header-size) port-in)))
        (cond ((not (fx= n (header-size)))
               (tar-file-truncated-error))
              ((fx= (u8vector-ref header 0) 0)
               (macro-make-tar-rec
                #f #f #f #f #f #f #f #f #f
                #f #f #f #f #f))
              (else
               (let ((name     (string-field 100 0))
                     (mode     (octal-field 8 100))
                     (uid      (octal-field 8 108))
                     (gid      (octal-field 8 116))
                     (size     (octal-field 12 124))
                     (mtime    (octal-field 12 136))
                     (chksum   (octal-field 8 148))
                     (typeflag (byte-field 156))
                     (linkname (string-field 100 157))
                     (magicver (string-field 8 257))
                     (magic    (string-field 6 257))
                     (version  (string-field 2 263)))
                 (let* ((tar-format
                         (cond ((string=? magicver "ustar  ")
                                'gnu)
                               ((and (string=? magic "ustar")
                                     (string=? version "00"))
                                'ustar)
                               ((and (string=? magic "")
                                     (string=? version ""))
                                'v7)
                               (else
                                'unknown)))
                        (gnu?
                         (eq? tar-format 'gnu)))
                   (cond ((eq? tar-format 'unknown)
                          (tar-header-format-unrecognized-error))
                         ((not (fx= chksum (checksum)))
                          (tar-header-checksum-error))
                         (else
                          (let ((uname (string-field 32 265))
                                (gname (string-field 32 297))
                                (devmajor (octal-field 8 329))
                                (devminor (octal-field 8 337))
                                (prefix
                                 (if gnu? "" (string-field 155 345)))
                                (atime
                                 (if gnu? (octal-field 12 345) #f))
                                (ctime
                                 (if gnu? (octal-field 12 357) #f))
                                (type
                                 (case typeflag
                                   ((0 48)
                                    'regular)
                                   ((49)
                                    'link)
                                   ((50)
                                    'symbolic-link)
                                   ((51)
                                    'character-special)
                                   ((52)
                                    'block-special)
                                   ((53)
                                    'directory)
                                   ((54)
                                    'fifo)
                                   ((103)
                                    'pax-g)
                                   ((120)
                                    'pax-x)
                                   (else
                                    #f))))
                            (macro-make-tar-rec
                             (string-append prefix name)
                             mode
                             uid
                             gid
                             mtime
                             type
                             linkname
                             uname
                             gname
                             devmajor
                             devminor
                             atime
                             ctime
                             size))))))))))

    (define (read-tar-file)
      (let loop ((rev-tar-rec-list '()))
        (let ((tar-rec (read-header)))
          (if (macro-tar-rec? tar-rec)
              (let ((name (macro-tar-rec-name tar-rec)))
                (if (not name)
                    (reverse rev-tar-rec-list)
                    (let* ((size (macro-tar-rec-content tar-rec))
                           (v (make-u8vector size))
                           (n (read-subu8vector v 0 size port-in)))
                      (if (or (not (fx= n size))
                              (let ((pad (fxmodulo (fx- size) 512)))
                                (not (fx= pad
                                          (read-subu8vector
                                           (make-u8vector pad)
                                           0
                                           pad
                                           port-in)))))
                          (tar-file-truncated-error)
                          (begin
                            (macro-tar-rec-content-set! tar-rec v)
                            (let ((type (macro-tar-rec-type tar-rec)))
                              (if (or (eq? type 'pax-g) ;; ignore pax records
                                      (eq? type 'pax-x))
                                  (loop rev-tar-rec-list)
                                  (loop (cons tar-rec rev-tar-rec-list)))))))))
              tar-rec))))

    (let ((result (read-tar-file)))
      (if (pair? result)
          result
          (raise result)))))

(define (tar-unpack-file path)
  (let* ((port-in (open-input-file path))
         (result (tar-unpack-port port-in)))
    (close-input-port port-in)
    result))

(define (tar-unpack-u8vector u8vect)
  (let* ((port-in (open-input-u8vector u8vect))
         (result (tar-unpack-port port-in)))
    (close-input-port port-in)
    result))

;;;----------------------------------------------------------------------------

(define (tar-rec-list-read
         #!optional
         (paths '())
         (from-dir (current-directory)))

  (define force-times #f)

  (define (time-to-integer x)
    (floor (inexact->exact (time->seconds x))))

  (define (read-file path size)
    (let* ((port (open-input-file path))
           (u8vect (make-u8vector size)))
      (read-subu8vector u8vect 0 size port)
      (close-input-port port)
      u8vect))

  (define (read-tar-rec-list path rev-tar-rec-list)
    (let* ((path*
            (path-expand path from-dir))
           (info
            (file-info path*))
           (type
            (file-info-type info))
           (mode
            (file-info-mode info))
           (owner
            (file-info-owner info))
           (group
            (file-info-group info))
           (size
            (file-info-size info))
           (atime
            (or force-times
                (time-to-integer (file-info-last-access-time info))))
           (ctime
            (or force-times
                (time-to-integer (file-info-last-change-time info))))
           (mtime
            (or force-times
                (time-to-integer (file-info-last-modification-time info))))
           (content
            (if (eq? type 'regular)
                (read-file path* size)
                (make-u8vector 0)))
           (tr
            (macro-make-tar-rec
             (if (eq? type 'directory)
                 (string-append
                  (path-strip-trailing-directory-separator path)
                  "/")
                 path)
             mode   ;; mode
             owner  ;; uid
             group  ;; gid
             mtime  ;; mtime
             type
             ""     ;; linkname
             "root" ;; uname
             "root" ;; gname
             0      ;; devmajor
             0      ;; devminor
             atime  ;; atime
             ctime  ;; ctime
             content))
           (new-rev-tar-rec-list
            (cons tr rev-tar-rec-list)))
      (if (eq? type 'directory)
          (read-tar-rec-list* (dir-files path*)
                              new-rev-tar-rec-list
                              path)
          new-rev-tar-rec-list)))

  (define (dir-files path)
    (directory-files
     (list path: path
           ignore-hidden: 'dot-and-dot-dot)))

  (define (read-tar-rec-list* names rev-tar-rec-list dir)
    (let loop ((names names)
               (rev-tar-rec-list rev-tar-rec-list))
      (if (pair? names)
          (let* ((name
                  (car names))
                 (path
                  (path-expand name dir)))
            (loop (cdr names)
                  (read-tar-rec-list path rev-tar-rec-list)))
          rev-tar-rec-list)))

  (reverse (read-tar-rec-list*
            (if (pair? paths)
                paths
                (dir-files from-dir))
            '()
            "")))

;;;----------------------------------------------------------------------------

(define (tar-rec-list-write
         tar-rec-list
         #!optional
         (to-dir (current-directory)))

  (define (change-times path atime mtime)
    (file-last-access-and-modification-times-set!
     path
     (seconds->time (or atime 0))
     (seconds->time (or mtime 0))))

  (define (write-directory path mode atime mtime)
    (create-directory
     (list path: path
           permissions: mode))
    (change-times path atime mtime))

  (define (write-regular path mode atime mtime u8vect)
    (let* ((port
            (open-output-file
             (list path: path
                   permissions: mode)))
           (size
            (u8vector-length u8vect))
           (n
            (write-subu8vector u8vect 0 size port)))
      (force-output port 1) ;; force transmit the data to the disk
      (close-output-port port)
      (change-times path atime mtime)))

  (define (write-tar-rec tar-rec)
    (let* ((name (macro-tar-rec-name tar-rec))
           (type (macro-tar-rec-type tar-rec))
           (mode (macro-tar-rec-mode tar-rec))
           (atime (macro-tar-rec-atime tar-rec))
           (mtime (macro-tar-rec-mtime tar-rec))
           (content (macro-tar-rec-content tar-rec))
           (path (path-expand name to-dir)))
      (case type
        ((directory)
         (write-directory path mode atime mtime)
         #f)
        ((regular)
         (write-regular path mode atime mtime content)
         #f)
        ((pax-g pax-x)
         #f)
        (else
         (macro-make-tar-exception "tar unsupported file type")))))

  (let loop ((lst tar-rec-list))
    (if (pair? lst)
        (let* ((tar-rec (car lst))
               (exc (write-tar-rec tar-rec)))
          (if exc
              (raise exc)
              (loop (cdr lst)))))))

;;;============================================================================
