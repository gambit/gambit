;;;============================================================================

;;; File: "tar.scm"

;;; Copyright (c) 2006-2014 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Contains procedures to pack and unpack tar files.

(##namespace ("tar#"))

(##include "~~lib/gambit#.scm")

(##include "tar#.scm")
(##include "genport#.scm")
(##include "zlib#.scm")

(declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (fixnum)
  (not safe)
)

(implement-type-tar-rec)

;;;============================================================================

;;; System dependencies.

(define (ISO-8859-1-string->u8vector str)
  (let* ((len (string-length str))
         (u8vect (make-u8vector len)))
    (let loop ((i (- len 1)))
      (if (>= i 0)
          (begin
            (u8vector-set! u8vect i (char->integer (string-ref str i)))
            (loop (- i 1)))
          u8vect))))

(define (u8vector->ISO-8859-1-string u8vect)
  (let* ((len (u8vector-length u8vect))
         (str (make-string len)))
    (let loop ((i (- len 1)))
      (if (>= i 0)
          (begin
            (string-set! str i (integer->char (u8vector-ref u8vect i)))
            (loop (- i 1)))
          str))))

(define (make-tar-condition msg)
  msg)

;;;----------------------------------------------------------------------------

(define-macro (header-size) 512)

;;;----------------------------------------------------------------------------

;; Packing tar files.

(define (tar-pack-genport tar-rec-list genport-out)

  (define tar-format 'gnu) ;; can be gnu, ustar or v7
;;  (define tar-format 'ustar)
;;  (define tar-format 'v7)

  (define use-blanks #f)

  ;; Error handling.

  (define (tar-field-overflow)
    (make-tar-condition "tar field overflow"))

  (define (tar-illegal-field)
    (make-tar-condition "tar illegal field"))

  (define (write-pad n)
    (genport-write-subu8vector
     (make-u8vector n 0)
     0
     n
     genport-out)
    #f)

  (define (write-header tr)
    (let ((header (make-u8vector (header-size) 0)))

      (define (string-field str max-length offset)
        (let ((len (string-length str)))
          (if (> len max-length)
              (tar-field-overflow)
              (let loop ((i 0))
                (if (< i len)
                    (begin
                      (u8vector-set!
                       header
                       (+ offset i)
                       (char->integer (string-ref str i)))
                      (loop (+ i 1)))
                    #f)))))

      (define (byte-field byte offset)
        (u8vector-set! header offset byte)
        #f)

      (define (octal-field-aux n-str len offset)
        (let ((n-str-len (string-length n-str)))
          (if (> n-str-len len)
              (tar-field-overflow)
              (let ((pad (- len n-str-len)))
                (let loop ((i 0))
                  (if (< i pad)
                      (begin
                        (u8vector-set! header
                                       (+ offset i)
                                       (if use-blanks 32 48))
                        (loop (+ i 1)))))
                (subu8vector-move!
                 (ISO-8859-1-string->u8vector n-str)
                 0
                 n-str-len
                 header
                 (+ offset pad))
                #f))))

      (define (octal-field0 n-str len offset)
        (if use-blanks
            (u8vector-set! header (+ offset (- len 1)) 32))
        (octal-field-aux n-str (- len 1) offset))

      (define (octal-field1-bignum n len offset)
        (octal-field1 n len offset))

      (define (octal-field1 n len offset)
        (octal-field0 (number->string n 8) len offset))

      (define (octal-field2 n len offset)
        (if use-blanks
            (octal-field1 n (- len 1) offset)
            (octal-field1 n len offset)))

      (define (octal-field3 n len offset)
        (u8vector-set! header (+ offset (- len 1)) 0)
        (octal-field-aux (number->string n 8) (- len 1) offset))

      (define (checksum)
        (let loop ((i 0))
          (if (< i 8)
              (begin
                (u8vector-set! header (+ 148 i) 32)
                (loop (+ i 1)))))
        (let loop ((sum 0) (i 0))
          (if (< i (header-size))
              (loop (+ sum (u8vector-ref header i))
                    (+ i 1))
              sum)))

      (let* ((name     (tar-rec-name tr))
             (mode     (tar-rec-mode tr))
             (uid      (tar-rec-uid tr))
             (gid      (tar-rec-gid tr))
             (mtime    (tar-rec-mtime tr))
             (type     (tar-rec-type tr))
             (linkname (tar-rec-linkname tr))
             (uname    (tar-rec-uname tr))
             (gname    (tar-rec-gname tr))
             (devmajor (tar-rec-devmajor tr))
             (devminor (tar-rec-devminor tr))
             (atime    (tar-rec-atime tr))
             (ctime    (tar-rec-ctime tr))
             (content  (tar-rec-content tr))
             (size     (u8vector-length content)))
        (or (string-field
             (if (eq? tar-format 'gnu)
                 name
                 (let ((len (string-length name)))
                   (substring name (- len (min 100 len)) len)))
             100
             0)
            (octal-field2 mode 8 100)
            (octal-field2 uid 8 108)
            (octal-field2 gid 8 116)
            (octal-field1-bignum size 12 124)
            (octal-field1-bignum mtime 12 136)
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
                (or (and atime (octal-field1-bignum atime 12 345))
                    (and ctime (octal-field1-bignum ctime 12 357)))
                (let ((len (string-length name)))
                  (string-field
                   (substring name 0 (- len (min 100 len)))
                   155
                   345)))
            (octal-field3 (checksum) 7 148)
            (begin
              (genport-write-subu8vector header 0 (header-size) genport-out)
              #f)))))

  (define (write-content tr)
    (let* ((content (tar-rec-content tr))
           (size (u8vector-length content)))
      (genport-write-subu8vector content 0 size genport-out)
      (write-pad (modulo (- size) 512))))

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
        (write-pad (* 2 512)))))

(define (tar-pack-file tar-rec-list filename #!optional (compressed? #f))
  (genport-write-file (tar-pack-u8vector tar-rec-list compressed?)
                      filename)
  #f)

(define (tar-pack-u8vector tar-rec-list #!optional (compressed? #f))
  (let ((genport-out (genport-open-output-u8vector)))
    (tar-pack-genport tar-rec-list genport-out)
    (let ((u8vect (genport-get-output-u8vector genport-out)))
      (if compressed?
          (gzip-u8vector u8vect)
          u8vect))))

;;;----------------------------------------------------------------------------

;; Unpacking tar files.

(define (tar-unpack-genport genport-in)

  ;; Error handling.

  (define (tar-file-truncated-error)
    (make-tar-condition "tar file truncated"))

  (define (tar-header-format-unrecognized-error)
    (make-tar-condition "tar header format unrecognized"))

  (define (tar-header-checksum-error)
    (make-tar-condition "tar header checksum error"))

  (let ((header (make-u8vector (header-size))))

    (define (string-field max-length offset)
      (string-field-aux
       (let loop ((len 0))
         (if (or (= len max-length)
                 (= (u8vector-ref header (+ offset len)) 0))
             len
             (loop (+ len 1))))
       offset))

    (define (string-field-aux len offset)
      (let ((str (make-string len)))
        (let loop ((i 0))
          (if (< i len)
              (begin
                (string-set!
                 str
                 i
                 (integer->char (u8vector-ref header (+ offset i))))
                (loop (+ i 1)))
              str))))

    (define (byte-field offset)
      (u8vector-ref header offset))

    (define (octal-field-extract len offset)
      (let loop1 ((start 0))
        (if (and (< start len)
                 (= 32 (u8vector-ref header (+ offset start))))
            (loop1 (+ start 1))
            (let loop2 ((end start))
              (if (and (< end len)
                       (let ((x (u8vector-ref header (+ offset end))))
                         (and (>= x 48) (<= x 55))))
                  (loop2 (+ end 1))
                  (u8vector->ISO-8859-1-string
                   (subu8vector header
                                (+ offset start)
                                (+ offset end))))))))

    (define (octal-field-bignum len offset)
      (octal-field len offset))

    (define (octal-field len offset)
      (string->number (octal-field-extract len offset) 8))

    (define (checksum)
      (let loop ((i 0))
        (if (< i 8)
            (begin
              (u8vector-set! header (+ 148 i) 32)
              (loop (+ i 1)))))
      (let loop ((sum 0) (i 0))
        (if (< i (header-size))
            (loop (+ sum (u8vector-ref header i))
                  (+ i 1))
            sum)))

    (define (read-header)
      (let ((n (genport-read-subu8vector header 0 (header-size) genport-in)))
        (cond ((not (= n (header-size)))
               (tar-file-truncated-error))
              ((= (u8vector-ref header 0) 0)
               (make-tar-rec
                #f #f #f #f #f #f #f #f #f
                #f #f #f #f #f))
              (else
               (let ((name     (string-field 100 0))
                     (mode     (octal-field 8 100))
                     (uid      (octal-field 8 108))
                     (gid      (octal-field 8 116))
                     (size     (octal-field-bignum 12 124))
                     (mtime    (octal-field-bignum 12 136))
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
                         ((not (= chksum (checksum)))
                          (tar-header-checksum-error))
                         (else
                          (let ((uname (string-field 32 265))
                                (gname (string-field 32 297))
                                (devmajor (octal-field 8 329))
                                (devminor (octal-field 8 337))
                                (prefix
                                 (if gnu? "" (string-field 155 345)))
                                (atime
                                 (if gnu? (octal-field-bignum 12 345) #f))
                                (ctime
                                 (if gnu? (octal-field-bignum 12 357) #f))
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
                                   (else
                                    #f))))
                            (make-tar-rec
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
          (if (tar-rec? tar-rec)
              (let ((name (tar-rec-name tar-rec)))
                (if (not name)
                    (reverse rev-tar-rec-list)
                    (let* ((size-bignum (tar-rec-content tar-rec))
                           (size size-bignum)
                           (v (make-u8vector size))
                           (n (genport-read-subu8vector v 0 size genport-in)))
                      (if (or (not (= n size))
                              (let ((pad (modulo (- size) 512)))
                                (not (= pad
                                        (genport-read-subu8vector
                                         (make-u8vector pad)
                                         0
                                         pad
                                         genport-in)))))
                          (tar-file-truncated-error)
                          (begin
                            (tar-rec-content-set! tar-rec v)
                            (loop (cons tar-rec rev-tar-rec-list)))))))
              tar-rec))))

    (let ((result (read-tar-file)))
      (if (pair? result)
          result
          (raise result)))))

(define (tar-unpack-genport* genport-in #!optional (compressed? #f))
  (let* ((genport-in2
          (if compressed?
              (gunzip-genport genport-in)
              genport-in))
         (result
          (tar-unpack-genport genport-in2)))
    (genport-close-input-port genport-in2)
    result))

(define (tar-unpack-file filename #!optional (compressed? #f))
  (tar-unpack-genport* (genport-open-input-file filename)
                       compressed?))

(define (tar-unpack-u8vector u8vect #!optional (compressed? #f))
  (tar-unpack-genport* (genport-open-input-u8vector u8vect)
                       compressed?))

;;;----------------------------------------------------------------------------

(define (tar-read filename)

  (define (seconds t)
    (round (inexact->exact (time->seconds t))))

  (define (read-file filename rev-tar-rec-list)
    (let* ((type
            (if (eq? (file-type filename) 'directory)
                'directory
                'regular))
           (content
            (if (eq? type 'regular)
                (genport-read-file filename)
                (make-u8vector 0)))
           (mode
            (if (eq? type 'directory) 493 420))
           (mtime
            (seconds (file-last-modification-time filename)))
           (atime
            (seconds (file-last-access-time filename)))
           (ctime
            (seconds (file-last-change-time filename)))
           (tr
            (make-tar-rec
             (path-to-unix
              (if (eq? type 'directory)
                  (path-expand "" filename)
                  filename))
             mode ;; mode
             0 ;; uid
             0 ;; gid
             mtime ;; mtime
             type
             "" ;; linkname
             "root" ;; uname
             "root" ;; gname
             0 ;; devmajor
             0 ;; devminor
             atime ;; atime
             ctime ;; ctime
             content))
           (new-rev-tar-rec-list
            (cons tr rev-tar-rec-list)))
      (if (eq? type 'directory)
          (read-dir filename new-rev-tar-rec-list)
          new-rev-tar-rec-list)))

  (define (read-dir dir rev-tar-rec-list)
    (let loop ((files (directory-files dir))
               (rev-tar-rec-list rev-tar-rec-list))
      (if (pair? files)
          (let* ((name
                  (car files))
                 (filename
                  (path-expand name dir)))
            (loop (cdr files)
                  (read-file filename rev-tar-rec-list)))
          rev-tar-rec-list)))

  (reverse (read-file filename '())))

(define (tar-write tar-rec-list)
  (if (not (pair? tar-rec-list))
      (raise "empty tar record list")
      (let* ((root-tar-rec (car tar-rec-list))
             (root-name (tar-rec-name root-tar-rec))
             (root-type (tar-rec-type root-tar-rec)))
        (if (not (and (string=? (path-directory root-name) root-name)
                      (not (string=? (path-expand root-name ".") root-name))
                      (eq? root-type 'directory)))
            (raise "root must be a directory that is not absolute")
            (begin

              (for-each
               (lambda (tr)
                 (let ((name (tar-rec-name tr)))
                   (if (not (and (>= (string-length name)
                                     (string-length root-name))
                                 (string=? (substring
                                            name
                                            0
                                            (string-length root-name))
                                           root-name)))
                       (begin
                         (pp (list name root-name))
                       (raise "all files must be included in root directory"))))
)
               tar-rec-list)

              (delete-file-recursive root-name)

              (tar-write-unchecked tar-rec-list))))))

(define (tar-write-unchecked tar-rec-list)
  (for-each
   (lambda (tr)
     (let* ((name (tar-rec-name tr))
            (filename (path-expand name)))
       (create-dir-recursive (path-directory filename))
       (if (eq? (tar-rec-type tr) 'directory)
           (create-dir-recursive filename)
           (genport-write-file (tar-rec-content tr) filename))))
   tar-rec-list))

(define (create-dir dir)
  (with-exception-catcher
   (lambda (e)
     #f)
   (lambda ()
     (create-directory dir)
     #t)))

(define (exists? path)
  (##vector? (##os-file-info path #t)))

(define (create-dir-recursive dir)
  (let ((d (path-strip-trailing-directory-separator dir)))
    (if (and (not (string=? dir "")) (not (exists? d)))
        (begin
          (create-dir-recursive (path-directory d))
          (create-dir d)))))

(define (delete-file-recursive path)
  (let ((path2 (path-expand path)))
    (if (exists? path2)
        (let ((type (file-type path2)))
          (if (eq? type 'directory)
              (let ((files
                     (directory-files
                      (list path: path2
                            ignore-hidden: 'dot-and-dot-dot))))
                (parameterize ((current-directory path2))
                              (for-each delete-file-recursive files))
                (delete-directory path2))
              (delete-file path2))))))

(define (path-to-unix path)

  (define (p2u path parts)
    (let* ((f (path-strip-directory path))
           (x (cons f parts))
           (d (path-directory path)))
      (if (string=? d "")
          x
          (let ((y (cons "/" x))
                (p (path-strip-trailing-directory-separator d)))
            (if (string=? p "")
                y
                (p2u p y))))))

  (append-strings (p2u (path-strip-volume path) '())))

;;;----------------------------------------------------------------------------

(define (tar-file filename-in filename-out #!optional (compressed? #f))
  (tar-pack-file
   (tar-read filename-in)
   filename-out
   compressed?))

(define (untar-file filename #!optional (compressed? #f))
  (tar-write
   (tar-unpack-file
    filename
    compressed?)))

;;;============================================================================
