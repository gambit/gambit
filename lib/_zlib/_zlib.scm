;;;============================================================================

;;; File: "_zlib.scm"

;;; Copyright (c) 2006-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Zlib compression/decompression.

;;; Contains procedures to compress and decompress data in DEFLATE and
;;; GZIP format.

;;; The following documents are specifications of the various formats:
;;;
;;;  RFC 1950 "ZLIB Compressed Data Format Specification version 3.3"
;;;  RFC 1951 "DEFLATE Compressed Data Format Specification version 1.3"
;;;  RFC 1952 "GZIP file format specification version 4.3"

(##supply-module _zlib)

(##namespace ("_zlib#"))         ;; in _zlib#
(##include "~~lib/_prim#.scm")   ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm") ;; for macro-check-string,
                                 ;; macro-absent-obj, etc

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;----------------------------------------------------------------------------

(##import _digest)

(##include "_zlib#.scm")

;;; Representation of exceptions.

(define-type zlib-exception
  id: CA726F64-BF31-4501-9A9A-E1C1F0438DBB
  constructor: macro-make-zlib-exception
  copier: #f
  opaque:
  macros:
  prefix: macro-

  (message read-only: no-functional-setter:)
)

;;;----------------------------------------------------------------------------

(define-macro (gzip-signature) 35615) ;; #x1F #x8B

(define (zlib-error msg)
  (raise (macro-make-zlib-exception msg)))

;;;----------------------------------------------------------------------------

;;; Compression.

;;; Note: currently the DEFLATE "stored" format is used, which does
;;; not compress the data.  This shortcoming should be fixed in a
;;; future release.

(define (compress-port port gzip?)

  (define stored-header 5) ;; size of a stored block header
  (define gzip-crc+size 8)
  (define block 65535) ;; 1 <= block <= 65535

  (let* ((bufsize (fx+ stored-header block gzip-crc+size))
         (buf (make-u8vector bufsize))
         (pos 0)
         (limit 0)
         (eof? #f)
         (crc32 (and gzip? (open-digest 'crc32)))
         (filesize 0))

    (define (get u8vect start end)
      (let ((n (fx- limit pos)))
        (cond ((fx> n 0)
               (let ((m (min n (fx- end start))))
                 (subu8vector-move! buf pos (fx+ pos m) u8vect start)
                 (set! pos (fx+ pos m))
                 m))
              (eof?
               #f)
              (else
               (let* ((len
                       (read-subu8vector
                        buf
                        stored-header
                        (fx+ stored-header block)
                        port))
                      (len-lo8
                       (fxand len #xff))
                      (len-hi8
                       (fxarithmetic-shift-right len 8)))
                 (u8vector-set! buf 1 len-lo8)
                 (u8vector-set! buf 2 len-hi8)
                 (u8vector-set! buf 3 (fxxor len-lo8 #xff))
                 (u8vector-set! buf 4 (fxxor len-hi8 #xff))
                 (set! limit (fx+ stored-header len))
                 (if gzip?
                     (begin
                       (digest-update-subu8vector crc32 buf stored-header limit)
                       (set! filesize (fx+ filesize len))))
                 (if (fx< len block) ;; last block?
                     (begin
                       (u8vector-set! buf 0 1) ;; final block
                       (set! eof? #t)
                       (if gzip?
                           (let* ((crc32
                                   (close-digest crc32 'hex))
                                  (crc32-0
                                   (string->number (substring crc32 6 8) 16))
                                  (crc32-1
                                   (string->number (substring crc32 4 6) 16))
                                  (crc32-2
                                   (string->number (substring crc32 2 4) 16))
                                  (crc32-3
                                   (string->number (substring crc32 0 2) 16))
                                  (filesize-0
                                   (fxand
                                    (fxarithmetic-shift-right filesize 0)
                                    #xff))
                                  (filesize-1
                                   (fxand
                                    (fxarithmetic-shift-right filesize 8)
                                    #xff))
                                  (filesize-2
                                   (fxand
                                    (fxarithmetic-shift-right filesize 16)
                                    #xff))
                                  (filesize-3
                                   (fxand
                                    (fxarithmetic-shift-right filesize 24)
                                    #xff)))
                             (u8vector-set! buf (fx+ limit 0) crc32-0)
                             (u8vector-set! buf (fx+ limit 1) crc32-1)
                             (u8vector-set! buf (fx+ limit 2) crc32-2)
                             (u8vector-set! buf (fx+ limit 3) crc32-3)
                             (u8vector-set! buf (fx+ limit 4) filesize-0)
                             (u8vector-set! buf (fx+ limit 5) filesize-1)
                             (u8vector-set! buf (fx+ limit 6) filesize-2)
                             (u8vector-set! buf (fx+ limit 7) filesize-3)
                             (set! limit (fx+ limit 8)))))
                     (u8vector-set! buf 0 0)) ;; not final block
                 (set! pos 0)
                 (get u8vect start end))))))

    (if gzip?
        (begin
          (u8vector-set!
           buf
           0
           (fxand (gzip-signature) #xff))
          (u8vector-set!
           buf
           1
           (fxarithmetic-shift-right (gzip-signature) 8))
          (u8vector-set! buf 2 8) ;; compression type
          (u8vector-set! buf 3 0) ;; flags
          (u8vector-set! buf 4 0) ;; unix modification time (4 bytes)
          (u8vector-set! buf 5 0)
          (u8vector-set! buf 6 0)
          (u8vector-set! buf 7 0)
          (u8vector-set! buf 8 0) ;; extra flags
          (u8vector-set! buf 9 #xff) ;; operating system = unknown
          (set! limit (fx+ limit 10))))

    (let loop ((i 0) (rev-chunks '()))
      (let ((u8vect (make-u8vector 512)))
        (let ((n (get u8vect 0 (u8vector-length u8vect))))
          (if (not n)
              (append-u8vectors (reverse rev-chunks))
              (begin
                (u8vector-shrink! u8vect n)
                (loop (fx+ i n) (cons u8vect rev-chunks)))))))))

(define (deflate-port port)
  (macro-force-vars (port)
    (macro-check-input-port
      port
      1
      (deflate-port port)
      (compress-port port #f))))

(define (gzip-port-aux port)
  (compress-port port #t))

(define (gzip-port port)
  (macro-force-vars (port)
    (macro-check-input-port
      port
      1
      (gzip-port port)
      (gzip-port-aux port))))

(define (gzip-u8vector u8vect)
  (macro-force-vars (u8vect)
    (macro-check-u8vector
      u8vect
      1
      (gzip-u8vector u8vect)
      (call-with-input-u8vector u8vect gzip-port-aux))))

(define (gzip-file path)
  (macro-force-vars (path)
    (macro-check-string
      path
      1
      (gzip-file path)
      (call-with-input-file path gzip-port-aux))))

;;;----------------------------------------------------------------------------

;;; Decompression.

(define (decompress-port port gzip?)

  (define inbufsize 32768)
  (define inbuf #f)
  (define inbufpos 0)
  (define inbuflimit 0)
  (define inbufeof? #f)

  (define outbufsize 32768)
  (define outbuf #f)
  (define outbufpos 0)
  (define outbuflimit 0)
  (define outbufeof? #f)

  (define next #f)
  (define crc32 #f)
  (define filesize 0)

  (define wp 0)
  (define bb 0) ;; bit buffer
  (define bk 0) ;; bits in bit buffer

  (define (make-res a b c) (vector a b c))
  (define (res-1 res) (vector-ref res 0))
  (define (res-2 res) (vector-ref res 1))
  (define (res-3 res) (vector-ref res 2))

  (define (fill-inbuf)
    (let ((n (read-subu8vector inbuf 0 inbufsize port)))
      (set! inbufpos 0)
      (set! inbuflimit n)
      (if (fx< n inbufsize)
          (set! inbufeof? #t))
      (fx> n 0)))

  (define (get-inbuf u8vect start end)
    (let* ((have (fx- inbuflimit inbufpos))
           (need (fx- end start))
           (n (min have need)))
      (subu8vector-move!
       inbuf
       inbufpos
       (fx+ inbufpos n)
       u8vect
       start)
      (set! inbufpos (fx+ inbufpos n))
      (if (fx< n need)
          (let* ((start2 (fx+ start n))
                 (need2 (fx- end start2))
                 (n (read-subu8vector u8vect start2 end port)))
            (if (fx< n need2)
                (zlib-error "unexpected end of file"))))))

  (define (get-u8)
    (if (or (fx< inbufpos inbuflimit)
            (and (not inbufeof?)
                 (fill-inbuf)))
        (let ((x (u8vector-ref inbuf inbufpos)))
          (set! inbufpos (fx+ inbufpos 1))
          x)
        (zlib-error "unexpected end of file")))

  (define (get-u16)
    (let* ((lo (get-u8))
           (hi (get-u8)))
      (fx+ lo (fxarithmetic-shift-left hi 8))))

  (define (get-string)
    (let loop ((s '()))
      (let ((x (get-u8)))
        (if (fx= x 0)
            (list->string (reverse s))
            (loop (cons (integer->char x) s))))))

  (define (ignore n)
    (let loop ((i n))
      (if (fx> i 0)
          (begin
            (get-u8)
            (loop (fx- i 1))))))

  (define (make-huft e b v) (vector e b v))
  (define (huft-e huft) (vector-ref huft 0))
  (define (huft-e-set! huft x) (vector-set! huft 0 x))
  (define (huft-b huft) (vector-ref huft 1))
  (define (huft-b-set! huft x) (vector-set! huft 1 x))
  (define (huft-v huft) (vector-ref huft 2))
  (define (huft-v-set! huft x) (vector-set! huft 2 x))

  (define (huft-copy! dest src)
    (huft-e-set! dest (huft-e src))
    (huft-b-set! dest (huft-b src))
    (huft-v-set! dest (huft-v src)))

  (define (iterate start end f)
    (let loop ((i start))
      (if (fx< i end)
          (begin
            (f i)
            (loop (fx+ i 1))))))

  (define (subvect v offset)
    (let* ((len (fx- (vector-length v) offset))
           (new (make-vector len)))
      (iterate 0
               len
               (lambda (i)
                 (vector-set! new i (vector-ref v (fx+ i offset)))))
      new))

  (define border ;; Order of the bit length code lengths
    '#(16 17 18 0 8 7 9 6 10 5 11 4 12 3 13 2 14 1 15))

  (define cplens ;; Copy lengths for literal codes 257..285
    '#(3 4 5 6 7 8 9 10 11 13 15 17 19 23 27 31
         35 43 51 59 67 83 99 115 131 163 195 227 258 0 0))

  (define cplext ;; Extra bits for literal codes 257..285
    '#(0 0 0 0 0 0 0 0 1 1 1 1 2 2 2 2
         3 3 3 3 4 4 4 4 5 5 5 5 0 99 99))

  (define cpdist ;; Copy offsets for distance codes 0..29
    '#(1 2 3 4 5 7 9 13 17 25 33 49 65 97 129 193
         257 385 513 769 1025 1537 2049 3073 4097 6145
         8193 12289 16385 24577))

  (define cpdext ;; Extra bits for distance codes
    '#(0 0 0 0 1 1 2 2 3 3 4 4 5 5 6 6
         7 7 8 8 9 9 10 10 11 11
         12 12 13 13))

  (define lbits 9) ;; bits in base literal/length lookup table
  (define dbits 6) ;; bits in base distance lookup table

  (define BMAX 16) ;; maximum bit length of any code (16 for explode)
  (define N-MAX 288) ;; maximum number of codes in any set

  (define (mask n) ;; n >= 0
    (fxnot (fxarithmetic-shift-left -1 n)))

  (define (NEEDBITS n)
    (let loop ()
      (if (fx< bk n)
          (begin
            (set! bb (fx+ bb (fxarithmetic-shift-left (get-u8) bk)))
            (set! bk (fx+ bk 8))
            (loop)))))

  (define (DUMPBITS n)
    (set! bb (fxarithmetic-shift-right bb n))
    (set! bk (fx- bk n)))

  (define (GETBITS n)
    (NEEDBITS n)
    (let ((r bb))
      (DUMPBITS n)
      (fxand r (mask n))))

  (define (check-flush)
    (if (fx= wp outbufsize)
        (begin
          (set! wp 0)
          outbufsize)
        0))

  (define (huft-build b n s d e m incomp-okp)

    (define c (make-vector (fx+ BMAX 1) 0))
    (define v (make-vector N-MAX))
    (define x (make-vector (fx+ BMAX 1)))
    (define final-y 0)
    (define t-result #f)

    ;; Generate counts for each bit length
    (iterate 0
             n
             (lambda (i)
               (let ((*p (vector-ref b i)))
                 (vector-set! c *p (fx+ (vector-ref c *p) 1)))))

    (if (fx= (vector-ref c 0) n)

        ;; null input--all zero length codes
        (make-res #f
                  0
                  #f)

        ;; Find minimum and maximum length, bound *m by those
        (let* ((j (let loop ((j 1))
                    (cond ((fx> j BMAX) j)
                          ((fx> (vector-ref c j) 0) j)
                          (else (loop (fx+ j 1))))))
               (k j)
               (i (let loop ((i BMAX))
                    (cond ((fx= i 0) 0)
                          ((fx> (vector-ref c i) 0) i)
                          (else (loop (fx- i 1))))))
               (g i)
               (l (fxmin (fxmax m j) i))
               (m-result l))

          ;; Adjust last length count to fill out codes, if needed
          (let ((y0 (let loop ((y (fxarithmetic-shift-left 1 j))
                               (j j))
                      (if (fx>= j i)
                          y
                          (let ((y2 (fx- y (vector-ref c j))))
                            (if (fx< y2 0)
                                (zlib-error "bad input: more codes than bits")
                                (loop (fx* y2 2) (fx+ j 1))))))))
            (set! final-y (fx- y0 (vector-ref c i)))
            (if (fx< final-y 0)
                (zlib-error "bad input: more codes than bits"))
            (vector-set! c i (fx+ (vector-ref c i) final-y)))

          ;; Generate starting offsets into the value table for each length
          (vector-set! x 1 0)
          (let ((j (let loop ((i (fx- i 1))
                              (x-pos 2)
                              (c-pos 1)
                              (j 0))
                     (if (fx= i 0)
                         j
                         (let ((v (vector-ref c c-pos)))
                           (vector-set! x x-pos (fx+ j v))
                           (loop (fx- i 1)
                                 (fx+ x-pos 1)
                                 (fx+ c-pos 1)
                                 (fx+ j v)))))))

            ;; Make a table of values in order of bit lengths
            (let loop ((i 0)
                       (b-pos 0))
              (let ((j (vector-ref b b-pos)))
                (if (not (fx= j 0))
                    (let ((xj (vector-ref x j)))
                      (vector-set! x j (fx+ 1 xj))
                      (vector-set! v xj i)))
                (let ((i2 (fx+ 1 i)))
                  (if (fx< i2 n)
                      (loop i2 (fx+ 1 b-pos))))))

            ;; Generate the Huffman codes and for each, make the table entries
            (vector-set! x 0 0)
            (let ((v-pos 0)
                  (i 0)
                  (h -1)
                  (w (fx- l))
                  (u (make-vector BMAX))
                  (q #f)
                  (z #f)
                  (r (make-huft 0 0 0)))

              ;; go through the bit lengths (k already is bits in shortest code
              (let k-loop ((k k))
                (if (fx<= k g)
                    (let ((a (vector-ref c k)))
                      (let a-loop ((a (fx- a 1)))
                        (if (fx>= a 0)

                            (begin
                              ;; here i is the Huffman code of length k bits
                              ;; for value *p make tables up to required level
                              (let kwl-loop ()
                                (if (fx> k (fx+ w l))
                                    (begin
                                      (set! h (fx+ h 1))
                                      (set! w (fx+ w l))

                                      ;; compute minimum size table less
                                      ;; than or equal to l bits
                                      (let* ((m (fxmin (fx- g w) l))
                                             (k-w (fx- k w))
                                             (f (fxarithmetic-shift-left 1 k-w))
                                             (j
                                              (if (fx> f (fx+ a 1))
                                                  (let loop ((j k-w)
                                                             (f (fx- f (fx+ a 1)))
                                                             (c-pos k))
                                                    (let ((j+1 (fx+ j 1)))
                                                      (if (fx< j+1 m)
                                                          (let* ((f
                                                                  (fx* f 2))
                                                                 (c-pos
                                                                  (fx+ c-pos 1))
                                                                 (cv
                                                                  (vector-ref
                                                                   c
                                                                   c-pos)))
                                                            (if (fx> f cv)
                                                                (loop j+1
                                                                      (fx- f cv)
                                                                      c-pos)
                                                                j+1))
                                                          j+1)))
                                                  k-w)))
                                        (set! z (fxarithmetic-shift-left 1 j))

                                        ;; allocate and link in new table
                                        (set! q
                                              (let ((v (make-vector z)))
                                                (iterate
                                                 0
                                                 z
                                                 (lambda (i)
                                                   (vector-set!
                                                    v
                                                    i
                                                    (make-huft 0 0 0))))
                                                v))

                                        (if (not t-result)
                                            (set! t-result q))

                                        (vector-set! u h q)

                                        ;; connect to last table, if there
                                        ;; is one
                                        (if (not (fx= h 0))
                                            (begin
                                              (vector-set! x h i)
                                              (huft-b-set! r l)
                                              (huft-e-set! r (fx+ j 16))
                                              (huft-v-set! r q)
                                              (set! j
                                                    (fxarithmetic-shift-right
                                                     i
                                                     (fx- w l)))
                                              ;; connect to last table:
                                              (huft-copy!
                                               (vector-ref
                                                (vector-ref u (fx- h 1)) j)
                                               r))))

                                      (kwl-loop))))

                              (huft-b-set! r (fx- k w))

                              (if (fx>= v-pos n)
                                  (huft-e-set! r 99)
                                  (let ((vv (vector-ref v v-pos)))
                                    (if (fx< vv s)
                                        (begin
                                          (huft-e-set!
                                           r (if (fx< vv 256) 16 15))
                                          (huft-v-set! r vv))
                                        (begin
                                          (huft-e-set!
                                           r (vector-ref e (fx- vv s)))
                                          (huft-v-set!
                                           r (vector-ref d (fx- vv s)))))
                                    (set! v-pos (fx+ v-pos 1))))
                              ;; fill code-like entries with r
                              (let ((f (fxarithmetic-shift-left 1 (fx- k w))))
                                (let loop ((j (fxarithmetic-shift-right i w)))
                                  (if (fx< j z)
                                      (begin
                                        (huft-copy! (vector-ref q j) r)
                                        (loop (fx+ j f))))))
                              ;; backwards increment the k-bit code i
                              (let loop ((j (fxarithmetic-shift-left 1 (fx- k 1))))
                                (if (fx< 0 (fxand i j))
                                    (begin
                                      (set! i (fxxor i j))
                                      (loop (fxarithmetic-shift-right j 1)))
                                    (set! i (fxxor i j))))
                              ;; backup over finished tables
                              (let loop ()
                                (if (not (fx= (vector-ref x h)
                                              (fxand i (fx- (fxarithmetic-shift-left 1 w) 1))))
                                    (begin
                                      (set! h (fx- h 1))
                                      (set! w (fx- w l))
                                      (loop))))

                              (a-loop (fx- a 1)))))
                      (k-loop (fx+ k 1)))))

              ;; Return #f as third if we were given an incomplete table
              (let ((okp (or incomp-okp
                             (not (and (not (fx= 0 final-y))
                                       (not (fx= g 1)))))))
                (if (not okp)
                    (zlib-error "incomplete table"))
                (make-res t-result
                          m-result
                          okp)))))))

  (define (inflate-codes tl td bl bd)

    ;; inflate the coded data
    (let ((ml (mask bl))
          (md (mask bd))
          (t #f)
          (e 0)
          (n 0)
          (d 0))

      (define (jump-to-next)
        (let loop ()
          (if (fx= e 99)
              (zlib-error "bad inflate code"))
          (DUMPBITS (huft-b t))
          (set! e (fx- e 16))
          (NEEDBITS e)
          (set! t (vector-ref
                   (huft-v t) (fxand bb (mask e))))
          (set! e (huft-e t))
          (if (fx> e 16)
              (loop))))

      ;; do until end of block
      (let loop ((ret 0))
        (if (fx> ret 0)
            (make-res 'flush
                      ret
                      (lambda () (loop 0)))
            (begin
              (NEEDBITS bl)
              (set! t (vector-ref tl (fxand bb ml)))
              (set! e (huft-e t))
              (if (fx> e 16)
                  (jump-to-next))
              (DUMPBITS (huft-b t))
              (cond ((fx= e 16)
                     ;; it's a literal
                     (u8vector-set! outbuf wp (huft-v t))
                     (set! wp (fx+ wp 1))
                     (loop (check-flush)))
                    ((fx= e 15)
                     ;; it's an EOB or a length
                     ;; exit if end of block
                     (make-res 'return
                               #t
                               #f))
                    (else
                     ;; get length of block to copy
                     (set! n (fx+ (huft-v t) (GETBITS e)))

                     ;; decode distance of block to copy
                     (NEEDBITS bd)
                     (set! t (vector-ref td (fxand bb md)))
                     (set! e (huft-e t))
                     (if (fx> e 16)
                         (jump-to-next))
                     (DUMPBITS (huft-b t))

                     (set! d (modulo (fx- wp (fx+ (huft-v t) (GETBITS e)))
                                     outbufsize))
                     ;; do the copy
                     (let laap ()
                       (let* ((start (fxand d (fx- outbufsize 1)))
                              (e (min n (fx- outbufsize (fxmax d wp))))
                              (end (fx+ start e))
                              (dest wp))
                         (set! wp (fx+ dest e))
                         (set! n (fx- n e))
                         (set! d end)
                         (let liip ((i start)
                                    (j dest))
                           (if (fx< i end)
                               (begin
                                 (u8vector-set!
                                  outbuf
                                  j
                                  (u8vector-ref outbuf i))
                                 (liip (fx+ i 1)
                                       (fx+ j 1))))))
                       (let ((r (check-flush)))
                         (cond ((fx= n 0)
                                (loop r))
                               ((fx= r 0)
                                (laap))
                               (else
                                (make-res 'flush
                                          r
                                          (lambda () (laap))))))))))))))

  (define (inflate-stored)

    ;; "decompress" an inflated type 0 (stored) block.

    ;; go to byte boundary
    (DUMPBITS (fxand bk 7))

    ;; get the length and its complement
    (let ((n (GETBITS 16)))
      (if (not (fx= (GETBITS 16) (fxxor n #xffff)))
          (zlib-error "error in compressed data"))

      ;; read and output the compressed data
      (let loop ((n n))
        (if (fx> n 0)
            (let ((m (fxmin n (fx- outbufsize wp))))
              (get-inbuf outbuf wp (fx+ wp m))
              (set! wp (fx+ wp m))
              (let ((r (check-flush))
                    (new-n (fx- n m)))
                (if (fx> r 0)
                    (make-res 'flush
                              r
                              (lambda () (loop new-n)))
                    (loop new-n))))
            (make-res 'return
                      #t
                      #f)))))

  (define (inflate-fixed)

    ;; *** This procedure is untested ***
    ;; I could not find a .gz file that contained blocks compressed
    ;; using this format.

    ;; decompress an inflated type 1 (fixed Huffman codes) block.  We should
    ;; either replace this with a custom decoder, or at least precompute the
    ;; Huffman tables.

    (let ((l (make-vector 288)))

      (iterate 0 144 (lambda (i) (vector-set! l i 8)))
      (iterate 144 256 (lambda (i) (vector-set! l i 9)))
      (iterate 256 280 (lambda (i) (vector-set! l i 7)))
      (iterate 280 288 (lambda (i) (vector-set! l i 8)))

      (let* ((res (huft-build l 288 257 cplens cplext 7 #f))
             (tl (res-1 res))
             (bl (res-2 res))
             (ok? (res-3 res)))
        (and ok?
             (begin
               (iterate 0 30 (lambda (i) (vector-set! l i 5)))
               (let* ((res (huft-build l 30 0 cpdist cpdext 5 #t))
                      (td (res-1 res))
                      (bd (res-2 res))
                      (ok? (res-3 res)))
                 (and ok?
                      ;; decompress until an end-of-block code
                      (inflate-codes tl td bl bd))))))))

  (define (inflate-dynamic)

    ;; decompress an inflated type 2 (dynamic Huffman codes) block.

    ;; read in table lengths
    (let* ((nl (fx+ 257 (GETBITS 5)))
           (nd (fx+ 1 (GETBITS 5)))
           (nb (fx+ 4 (GETBITS 4)))
           (ll (make-vector (fx+ 286 30))))

      (cond ((fx> nl 286)
             (zlib-error "bad lengths"))
            ((fx> nd 30)
             (zlib-error "bad lengths"))
            (else
             ;; read in bit-length-code lengths
             (iterate 0
                      nb
                      (lambda (j)
                        (vector-set!
                         ll (vector-ref border j) (GETBITS 3))))
             (iterate nb
                      19
                      (lambda (j)
                        (vector-set!
                         ll (vector-ref border j) 0)))

             ;; build decoding table for trees--single level, 7 bit lookup
             (let* ((res (huft-build ll 19 19 '#() '#() 7 #f))
                    (tl (res-1 res))
                    (bl (res-2 res))
                    (ok? (res-3 res)))
               (and ok?
                    (begin
                      ;; read in literal and distance code lengths
                      (let ((n (fx+ nl nd))
                            (m (mask bl)))
                        (let loop1 ((l 0) (i 0))
                          (if (fx< i n)
                              (begin
                                (NEEDBITS bl)
                                (let* ((pos (fxand bb m))
                                       (td (vector-ref tl pos))
                                       (dmp (huft-b td))
                                       (j (huft-v td))
                                       (set-lit
                                        (lambda (l i j)
                                          (if (fx> (fx+ i j) n)
                                              (zlib-error "bad hop"))
                                          (let loop2 ((i i) (j j))
                                            (if (fx= j 0)
                                                (loop1 l i)
                                                (begin
                                                  (vector-set! ll i l)
                                                  (loop2 (fx+ i 1)
                                                         (fx- j 1))))))))
                                  (DUMPBITS dmp)
                                  (cond ((fx< j 16)
                                         ;; length of code in bits (0..15)
                                         (vector-set! ll i j)
                                         ;; save last length in l
                                         (loop1 j (fx+ i 1)))
                                        ((fx= j 16)
                                         ;; repeat last length 3 to 6 times
                                         (set-lit l
                                                  i
                                                  (fx+ 3 (GETBITS 2))))
                                        ((fx= j 17)
                                         ;; 3 to 10 zero length codes
                                         (set-lit 0
                                                  i
                                                  (fx+ 3 (GETBITS 3))))
                                        (else
                                         ;; j == 18: 11 to 138 zero length codes
                                         (set-lit 0
                                                  i
                                                  (fx+ 11 (GETBITS 7)))))))))


                        ;; build the decoding tables for literal/length and distance codes
                        (let* ((res (huft-build ll nl 257 cplens cplext lbits #f))
                               (tl (res-1 res))
                               (bl (res-2 res))
                               (ok? (res-3 res)))
                          (if (not ok?)
                              (zlib-error "incomplete code set")
                              (let* ((res (huft-build (subvect ll nl) nd 0 cpdist cpdext dbits #f))
                                     (td (res-1 res))
                                     (bd (res-2 res))
                                     (ok? (res-3 res)))
                                (if (not ok?)
                                    (zlib-error "incomplete code set")
                                    ;; decompress until an end-of-block code
                                    (inflate-codes tl td bl bd)))))))))))))

  (define (inflate-block)

    ;; decompress an inflated block
    (let* ((e (GETBITS 1))
           (t (GETBITS 2)))
      ;; read in block type
      (let loop ((res
                  (case t
                    ((0) (inflate-stored))
                    ((1) (inflate-fixed))
                    ((2) (inflate-dynamic))
                    (else
                     (zlib-error "unknown inflate type")))))
        (let ((state (res-1 res))
              (val (res-2 res))
              (kont (res-3 res)))
          (case state
            ((return)
             (make-res 'return
                       e
                       val))
            ((flush)
             (make-res 'flush
                       val
                       (lambda () (loop (kont)))))
            (else
             (zlib-error "illegal state")))))))

  (define (decompress)

    ;; initialize window, bit buffer
    (set! wp 0)
    (set! bk 0)
    (set! bb 0)

    ;; decompress until the last block
    (let loop ((h 0))
      (let ((hufts 0))
        (let laap ((res (inflate-block)))
          (let ((state (res-1 res))
                (e (res-2 res))
                (r (res-3 res)))
            (case state
              ((return)
               (if (and r (fx= e 0))
                   (loop (if (fx> hufts h) hufts h))
                   ;; Undo too much lookahead. The next read will be byte aligned so we
                   ;; can discard unused bits in the last meaningful byte
                   (make-res 'complete
                             wp
                             #f)))
              ((flush)
               (make-res 'step
                         e
                         (lambda () (laap (r)))))
              (else
               (zlib-error "illegal state"))))))))

  (define (read-gzip-header)
    (let* ((magic-header (get-u16))
           (compression-type (get-u8))
           (flags (get-u8))
           (is-ascii? (fx< 0 (fxand flags 1)))
           (is-continuation? (fx< 0 (fxand flags 2)))
           (has-extra-field? (fx< 0 (fxand flags 4)))
           (has-original-filename? (fx< 0 (fxand flags 8)))
           (has-comment? (fx< 0 (fxand flags 16)))
           (is-encrypted? (fx< 0 (fxand flags 32)))
           (unix-mod-time (ignore 4))
           (extra-flags (ignore 1))
           (source-os (ignore 1)))
      (cond ((not (fx= magic-header (gzip-signature)))
             (zlib-error "not in gzip format"))
            ((not (fx= compression-type 8))
             (zlib-error "unknown compression method"))
            (is-encrypted?
             (zlib-error "cannot decompress encrypted file"))
            (is-continuation?
             (zlib-error "cannot decompress multi-part file"))
            (else
             (if is-continuation?
                 (get-u16))
             (if has-extra-field?
                 (ignore (get-u16)))
             (let* ((original-filename
                     (and has-original-filename?
                          (get-string)))
                    (comment
                     (and has-comment?
                          (get-string))))
               (if is-encrypted?
                   (ignore 12)))))))

  (define (get-outbuf u8vect start end)
    (let ((n (fx- outbuflimit outbufpos)))
      (cond ((fx> n 0)
             (let ((m (fxmin n (fx- end start))))
               (subu8vector-move!
                outbuf
                outbufpos
                (fx+ outbufpos m)
                u8vect
                start)
               (set! outbufpos (fx+ outbufpos m))
               m))
            (outbufeof?
             #f)
            (else
             (let* ((res (next))
                    (state (res-1 res))
                    (len (res-2 res))
                    (cont (res-3 res)))
               (set! next cont)
               (set! outbuflimit len)
               (if gzip?
                   (begin
                     (digest-update-subu8vector crc32 outbuf 0 outbuflimit)
                     (set! filesize (fx+ filesize len))))
               (if (not (eq? state 'step)) ;; last block?
                   (begin
                     (set! outbufeof? #t)
                     (if gzip?
                         (let* ((crc32
                                 (close-digest crc32 'hex))
                                (crc32-0
                                 (string->number (substring crc32 6 8) 16))
                                (crc32-1
                                 (string->number (substring crc32 4 6) 16))
                                (crc32-2
                                 (string->number (substring crc32 2 4) 16))
                                (crc32-3
                                 (string->number (substring crc32 0 2) 16))
                                (filesize-0
                                 (fxand
                                  (fxarithmetic-shift-right filesize 0)
                                  #xff))
                                (filesize-1
                                 (fxand
                                  (fxarithmetic-shift-right filesize 8)
                                  #xff))
                                (filesize-2
                                 (fxand
                                  (fxarithmetic-shift-right filesize 16)
                                  #xff))
                                (filesize-3
                                 (fxand
                                  (fxarithmetic-shift-right filesize 24)
                                  #xff)))
                           (DUMPBITS (fxand bk 7))
                           (if (not
                                (and (fx= (GETBITS 8) crc32-0)
                                     (fx= (GETBITS 8) crc32-1)
                                     (fx= (GETBITS 8) crc32-2)
                                     (fx= (GETBITS 8) crc32-3)))
                               (zlib-error "CRC is incorrect"))
                           (if (not
                                (and (fx= (GETBITS 8) filesize-0)
                                     (fx= (GETBITS 8) filesize-1)
                                     (fx= (GETBITS 8) filesize-2)
                                     (fx= (GETBITS 8) filesize-3)))
                               (zlib-error "file size is incorrect"))))))
               (set! outbufpos 0)
               (get-outbuf u8vect start end))))))

  (set! inbuf (make-u8vector inbufsize))
  (set! outbuf (make-u8vector outbufsize))

  (set! next (lambda ()
               (if gzip?
                   (read-gzip-header))
               (decompress)))

  (set! crc32 (and gzip? (open-digest 'crc32)))

  (let loop ((i 0) (rev-chunks '()))
    (let ((u8vect (make-u8vector 512)))
      (let ((n (get-outbuf u8vect 0 (u8vector-length u8vect))))
        (if (not n)
            (append-u8vectors (reverse rev-chunks))
            (begin
              (u8vector-shrink! u8vect n)
              (loop (fx+ i n) (cons u8vect rev-chunks))))))))

(define (inflate-port port)
  (macro-force-vars (port)
    (macro-check-input-port
      port
      1
      (inflate-port port)
      (decompress-port port #f))))

(define (gunzip-port-aux port)
  (decompress-port port #t))

(define (gunzip-port port)
  (macro-force-vars (port)
    (macro-check-input-port
      port
      1
      (gunzip-port port)
      (gunzip-port-aux port))))

(define (gunzip-u8vector u8vect)
  (macro-force-vars (u8vect)
    (macro-check-u8vector
      u8vect
      1
      (gunzip-u8vector u8vect)
      (call-with-input-u8vector u8vect gunzip-port))))

(define (gunzip-file path)
  (macro-force-vars (path)
    (macro-check-string
      path
      1
      (gunzip-file path)
      (call-with-input-file path gunzip-port-aux))))

;;;============================================================================
