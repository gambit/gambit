;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2021-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 151, Bitwise Operations

(import (srfi 151))
(import (_test))

;;;============================================================================

;; Copyright 2017 John Cowan
;; Copyright 2017 Shiro Kawai
;; SPDX-License-Identifier: MIT

(test-begin "srfi-151")

(test-begin "basic")
(test-eqv "test-1" -1 (bitwise-not 0))
(test-eqv "test-122" 0 (bitwise-not -1))
(test-eqv "test-248" -11 (bitwise-not 10))
(test-eqv "test-249" 36 (bitwise-not -37))
(test-eqv "test-2" 0 (bitwise-and #b0 #b1))
(test-eqv "test-10" 1680869008 (bitwise-and -193073517 1689392892))
(test-eqv "test-20" 3769478 (bitwise-and 1694076839 -4290775858))
(test-eqv "test-115" 6 (bitwise-and 14 6))
(test-eqv "test-251" 10 (bitwise-and 11 26))
(test-eqv "test-254" 4 (bitwise-and 37 12))
(test-eqv "test-288" 1 (bitwise-and #b1 #b1))
(test-eqv "test-289" 0 (bitwise-and #b1 #b10))
(test-eqv "test-290" #b10 (bitwise-and #b11 #b10))
(test-eqv "test-291" #b101 (bitwise-and #b101 #b111))
(test-eqv "test-292" #b111 (bitwise-and -1 #b111))
(test-eqv "test-293" #b110 (bitwise-and -2 #b111))
(test-eqv "test-294" 3769478 (bitwise-and -4290775858 1694076839))
(test-eqv "test-11" -4294967295 (bitwise-ior 1 (- -1 #xffffffff)))
(test-eqv "test-12"
  -18446744073709551615 (bitwise-ior 1 (- -1 #xffffffffffffffff)))
(test-eqv "test-117" 14 (bitwise-ior 10 12))
(test-eqv "test-250" 11 (bitwise-ior 3  10))
(test-eqv "test-13" -4294967126 (bitwise-xor #b10101010 (- -1 #xffffffff)))
(test-eqv "test-15"
  -18446744073709551446 (bitwise-xor #b10101010 (- -1 #xffffffffffffffff)))
(test-eqv "test-16" -2600468497 (bitwise-ior 1694076839 -4290775858))
(test-eqv "test-17" -184549633 (bitwise-ior -193073517 1689392892))
(test-eqv "test-18" -2604237975 (bitwise-xor 1694076839 -4290775858))
(test-eqv "test-19" -1865418641 (bitwise-xor -193073517 1689392892))
(test-eqv "test-119" 6 (bitwise-xor 10 12))
(test-eqv "test-252" 9 (bitwise-xor 3 10))
(test-eqv "test-14"
  (bitwise-not -4294967126) (bitwise-eqv #b10101010 (- -1 #xffffffff)))
(test-eqv "test-253" -42 (bitwise-eqv 37 12))
(test-eqv "test-27" -1 (bitwise-nand 0 0))
(test-eqv "test-28" -1 (bitwise-nand 0 -1))
(test-eqv "test-29" -124 (bitwise-nand -1 123))
(test-eqv "test-326" -11 (bitwise-nand 11 26))
(test-eqv "test-327" -28 (bitwise-nor  11 26))
(test-eqv "test-317" 0 (bitwise-nor -1 123))
(test-eqv "test-328" 16 (bitwise-andc1 11 26))
(test-eqv "test-329" 1 (bitwise-andc2 11 26))
(test-eqv "test-330" -2 (bitwise-orc1 11 26))
(test-eqv "test-30" -1 (bitwise-nor 0 0))
(test-eqv "test-31" 0 (bitwise-nor 0 -1))
(test-eqv "test-22" 0 (bitwise-andc1 0 0))
(test-eqv "test-23" -1 (bitwise-andc1 0 -1))
(test-eqv "test-24" 123 (bitwise-andc1 0 123))
(test-eqv "test-25" 0 (bitwise-andc2 0 0))
(test-eqv "test-26" -1 (bitwise-andc2 -1 0))
(test-eqv "test-318" -1 (bitwise-orc1 0 0))
(test-eqv "test-319" -1 (bitwise-orc1 0 -1))
(test-eqv "test-320" 0 (bitwise-orc1 -1 0))
(test-eqv "test-321" -124 (bitwise-orc1 123 0))
(test-eqv "test-322" -1 (bitwise-orc2 0 0))
(test-eqv "test-323" -1 (bitwise-orc2 -1 0))
(test-eqv "test-324" 0 (bitwise-orc2 0 -1))
(test-eqv "test-325" -124 (bitwise-orc2 0 123))
(test-end "basic")

(test-begin "integer")
(test-eqv "test-78" #x1000000000000000100000000000000000000000000000000
          (arithmetic-shift #x100000000000000010000000000000000 64))
(test-eqv "test-79"
  #x8e73b0f7da0e6452c810f32b809079e5
  (arithmetic-shift #x8e73b0f7da0e6452c810f32b809079e562f8ead2522c6b7b -64))
(test-eqv "test-196" 2 (arithmetic-shift 1 1))
(test-eqv "test-197" 0 (arithmetic-shift 1 -1))
(test-eqv "test-331" 1 (arithmetic-shift 1 0))
(test-eqv "test-333" 4 (arithmetic-shift 1 2))
(test-eqv "test-334" 8 (arithmetic-shift 1 3))
(test-eqv "test-335" 16 (arithmetic-shift 1 4))
(test-eqv "test-336" (expt 2 31) (arithmetic-shift 1 31))
(test-eqv "test-337" (expt 2 32) (arithmetic-shift 1 32))
(test-eqv "test-338" (expt 2 33) (arithmetic-shift 1 33))
(test-eqv "test-339" (expt 2 63) (arithmetic-shift 1 63))
(test-eqv "test-340" (expt 2 64) (arithmetic-shift 1 64))
(test-eqv "test-341" (expt 2 65) (arithmetic-shift 1 65))
(test-eqv "test-342" (expt 2 127) (arithmetic-shift 1 127))
(test-eqv "test-343" (expt 2 128) (arithmetic-shift 1 128))
(test-eqv "test-344" (expt 2 129) (arithmetic-shift 1 129))
(test-eqv "test-345"
  3028397001194014464 (arithmetic-shift 11829675785914119 8))
(test-eqv "test-346" -1 (arithmetic-shift -1 0))
(test-eqv "test-347" -2 (arithmetic-shift -1 1))
(test-eqv "test-348" -4 (arithmetic-shift -1 2))
(test-eqv "test-349" -8 (arithmetic-shift -1 3))
(test-eqv "test-350" -16 (arithmetic-shift -1 4))
(test-eqv "test-351" (- (expt 2 31)) (arithmetic-shift -1 31))
(test-eqv "test-352" (- (expt 2 32)) (arithmetic-shift -1 32))
(test-eqv "test-353" (- (expt 2 33)) (arithmetic-shift -1 33))
(test-eqv "test-354" (- (expt 2 63)) (arithmetic-shift -1 63))
(test-eqv "test-355" (- (expt 2 64)) (arithmetic-shift -1 64))
(test-eqv "test-356" (- (expt 2 65)) (arithmetic-shift -1 65))
(test-eqv "test-357" (- (expt 2 127)) (arithmetic-shift -1 127))
(test-eqv "test-358" (- (expt 2 128)) (arithmetic-shift -1 128))
(test-eqv "test-359" (- (expt 2 129)) (arithmetic-shift -1 129))
(test-eqv "test-360" 0 (arithmetic-shift 1 -63))
(test-eqv "test-361" 0 (arithmetic-shift 1 -64))
(test-eqv "test-362" 0 (arithmetic-shift 1 -65))
(test-eqv "test-255" 32 (arithmetic-shift 8 2))
(test-eqv "test-256" 4 (arithmetic-shift 4 0))
(test-eqv "test-257" 4 (arithmetic-shift 8 -1))
(test-eqv "test-258" -79
          (arithmetic-shift -100000000000000000000000000000000 -100))
(test-eqv "test-135" 2 (bit-count 12))
(test-eqv "test-263" 0 (integer-length  0))
(test-eqv "test-264" 1 (integer-length  1))
(test-eqv "test-265" 0 (integer-length -1))
(test-eqv "test-266" 3 (integer-length  7))
(test-eqv "test-267" 3 (integer-length -7))
(test-eqv "test-268" 4 (integer-length  8))
(test-eqv "test-269" 3 (integer-length -8))
(test-eqv "test-125" 9 (bitwise-if 3 1 8))
(test-eqv "test-126" 0 (bitwise-if 3 8 1))
(test-eqv "test-373" 3 (bitwise-if 1 1 2))
(test-eqv "test-378" #b00110011 (bitwise-if #b00111100 #b11110000 #b00001111))
(test-end "integer")

(test-begin "single")
(test-eqv "test-160" #t (bit-set? 0 1))
(test-eqv "test-161" #f (bit-set? 1 1))
(test-eqv "test-162" #f (bit-set? 1 8))
(test-eqv "test-163" #t (bit-set? 10000 -1))
(test-eqv "test-167" #t (bit-set? 1000 -1))
(test-eqv "test-541" #t (bit-set? 64 #x10000000000000000))
(test-eqv "test-542" #f (bit-set? 64 1))
(test-eqv "test-272" #t (bit-set? 3 10))
(test-eqv "test-273" #t (bit-set? 2 6))
(test-eqv "test-274" #f (bit-set? 0 6))
(test-eqv "test-168" 0 (copy-bit 0 0 #f))
(test-eqv "test-169" 0 (copy-bit 30 0 #f))
(test-eqv "test-170" 0 (copy-bit 31 0 #f))
(test-eqv "test-171" 0 (copy-bit 62 0 #f))
(test-eqv "test-172" 0 (copy-bit 63 0 #f))
(test-eqv "test-173" 0 (copy-bit 128 0 #f))
(test-eqv "test-174" -1 (copy-bit 0 -1 #t))
(test-eqv "test-175" -1 (copy-bit 30 -1 #t))
(test-eqv "test-176" -1 (copy-bit 31 -1 #t))
(test-eqv "test-177" -1 (copy-bit 62 -1 #t))
(test-eqv "test-178" -1 (copy-bit 63 -1 #t))
(test-eqv "test-179" -1 (copy-bit 128 -1 #t))
(test-eqv "test-180" 1 (copy-bit 0 0 #t))
(test-eqv "test-181" #x106 (copy-bit 8 6 #t))
(test-eqv "test-182" 6 (copy-bit 8 6 #f))
(test-eqv "test-183" -2 (copy-bit 0 -1 #f))
(test-eqv "test-184" 0 (copy-bit 128 #x100000000000000000000000000000000 #f))
(test-eqv "test-185" #x100000000000000000000000000000000
          (copy-bit 128 #x100000000000000000000000000000000 #t))
(test-eqv "test-186" #x100000000000000000000000000000000
          (copy-bit 64 #x100000000000000000000000000000000 #f))
(test-eqv "test-187" #x-100000000000000000000000000000000
          (copy-bit 64 #x-100000000000000000000000000000000 #f))
(test-eqv "test-188" #x-100000000000000000000000000000000
          (copy-bit 256 #x-100000000000000000000000000000000 #t))
(test-eqv "test-276" #b100 (copy-bit 2 0 #t))
(test-eqv "test-277" #b1011 (copy-bit 2 #b1111 #f))
(test-eqv "test-379" #b1 (copy-bit 0 0 #t))
(test-eqv "test-100" #b1011 (bit-swap 1 2 #b1101))
(test-eqv "test-101" #b1011 (bit-swap 2 1 #b1101))
(test-eqv "test-382" #b1110 (bit-swap 0 1 #b1101))
(test-eqv "test-102" #b10000000101 (bit-swap 3 10 #b1101))
(test-eqv "test-278" 1 (bit-swap 0 2 4))
(test-eqv "test-129" #t (any-bit-set? 3 6))
(test-eqv "test-130" #f (any-bit-set? 3 12))
(test-eqv "test-133" #t (every-bit-set? 4 6))
(test-eqv "test-134" #f (every-bit-set? 7 6))
(test-eqv "test-141" -1 (first-set-bit 0))
(test-eqv "test-142" 0 (first-set-bit 1))
(test-eqv "test-143" 0 (first-set-bit 3))
(test-eqv "test-144" 2 (first-set-bit 4))
(test-eqv "test-145" 1 (first-set-bit 6))
(test-eqv "test-146" 0 (first-set-bit -1))
(test-eqv "test-147" 1 (first-set-bit -2))
(test-eqv "test-148" 0 (first-set-bit -3))
(test-eqv "test-149" 2 (first-set-bit -4))
(test-eqv "test-150" 128 (first-set-bit #x100000000000000000000000000000000))
(test-eqv "test-280" 1 (first-set-bit 2))
(test-eqv "test-282" 3 (first-set-bit 40))
(test-eqv "test-283" 2 (first-set-bit -28))
(test-eqv "test-284" 99 (first-set-bit (expt  2 99)))
(test-eqv "test-285" 99 (first-set-bit (expt -2 99)))
(test-end "single")

(test-begin "field")
(test-eqv "test-189" 0 (bit-field 6 0 1))
(test-eqv "test-190" 3 (bit-field 6 1 3))
(test-eqv "test-191" 1 (bit-field 6 2 999))
(test-eqv "test-192"
  1 (bit-field #x100000000000000000000000000000000 128 129))
(test-eqv "test-363" #b1010 (bit-field #b1101101010 0 4))
(test-eqv "test-364" #b101101 (bit-field #b1101101010 3 9))
(test-eqv "test-365" #b10110 (bit-field #b1101101010 4 9))
(test-eqv "test-366" #b110110 (bit-field #b1101101010 4 10))
(test-eqv "test-367" #t (bit-field-any? #b101101 0 2))
(test-eqv "test-368" #t (bit-field-any? #b101101 2 4))
(test-eqv "test-369" #f (bit-field-any? #b101101 1 2))
(test-eqv "test-370" #f (bit-field-every? #b101101 0 2))
(test-eqv "test-371" #t (bit-field-every? #b101101 2 4))
(test-eqv "test-372" #t (bit-field-every? #b101101 0 1))
(test-eqv "test-374" #b100000 (bit-field-clear #b101010 1 4))
(test-eqv "test-375" #b101110 (bit-field-set #b101010 1 4))
(test-eqv "test-193" #b111 (bit-field-replace #b110 1 0 1))
(test-eqv "test-194" #b110 (bit-field-replace #b110 1 1 2))
(test-eqv "test-195" #b010 (bit-field-replace #b110 1 1 3))
(test-eqv "test-376" #b100100 (bit-field-replace #b101010 #b010 1 4))
(test-eqv "test-377" #b1001 (bit-field-replace-same #b1111 #b0000 1 3))
(test-eqv "test-200" #b110  (bit-field-rotate #b110 1 1 2))
(test-eqv "test-201" #b1010 (bit-field-rotate #b110 1 2 4))
(test-eqv "test-202" #b1011 (bit-field-rotate #b0111 -1 1 4))
(test-eqv "test-203" #b0  (bit-field-rotate #b0 128 0 256))
(test-eqv "test-204" #b1  (bit-field-rotate #b1 128 1 256))
(test-eqv "test-205" #x100000000000000000000000000000000
          (bit-field-rotate #x100000000000000000000000000000000 128 0 64))
(test-eqv "test-206" #x100000000000000000000000000000008
          (bit-field-rotate #x100000000000000000000000000000001 3 0 64))
(test-eqv "test-207" #x100000000000000002000000000000000
          (bit-field-rotate #x100000000000000000000000000000001 -3 0 64))
(test-eqv "test-208" #b110 (bit-field-rotate #b110 0 0 10))
(test-eqv "test-209" #b110 (bit-field-rotate #b110 0 0 256))
(test-eqv "test-475"
  1 (bit-field-rotate #x100000000000000000000000000000000 1 0 129))
(test-eqv "test-211" 6 (bit-field-reverse 6 1 3))
(test-eqv "test-212" 12 (bit-field-reverse 6 1 4))
(test-eqv "test-213" #x80000000 (bit-field-reverse 1 0 32))
(test-eqv "test-214" #x40000000 (bit-field-reverse 1 0 31))
(test-eqv "test-215" #x20000000 (bit-field-reverse 1 0 30))
(test-eqv "test-216" (bitwise-ior (arithmetic-shift -1 32) #xFBFFFFFF)
          (bit-field-reverse -2 0 27))
(test-eqv "test-217" (bitwise-ior (arithmetic-shift -1 32) #xF7FFFFFF)
          (bit-field-reverse -2 0 28))
(test-eqv "test-218" (bitwise-ior (arithmetic-shift -1 32) #xEFFFFFFF)
          (bit-field-reverse -2 0 29))
(test-eqv "test-219" (bitwise-ior (arithmetic-shift -1 32) #xDFFFFFFF)
          (bit-field-reverse -2 0 30))
(test-eqv "test-220" (bitwise-ior (arithmetic-shift -1 32) #xBFFFFFFF)
          (bit-field-reverse -2 0 31))
(test-eqv "test-221" (bitwise-ior (arithmetic-shift -1 32) #x7FFFFFFF)
          (bit-field-reverse -2 0 32))
(test-eqv "test-222"
  5 (bit-field-reverse #x140000000000000000000000000000000 0 129))
(test-end "field")

(test-begin "conversion")
(test-equal "test-103" '(#t #f #t #f #t #t #t) (bits->list #b1110101))
(test-equal "test-104" '(#f #t #f #t) (bits->list #b111010 4))
(test-eqv "test-106" #b1110101 (list->bits '(#t #f #t #f #t #t #t)))
(test-eqv "test-107" #b111010100 (list->bits '(#f #f #t #f #t #f #t #t #t)))
(test-equal "test-223" '(#t #t) (bits->list 3))
(test-equal "test-224" '(#f #t #t #f) (bits->list 6 4))
(test-equal "test-225" '(#f #t) (bits->list 6 2))
(test-equal "test-226" '(#t #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                            #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                            #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                            #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                            #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                            #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                            #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                            #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f)
            (bits->list 1 128))
(test-equal "test-228" '(#f
                         #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                         #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                         #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                         #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                         #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                         #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                         #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                         #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #t)
            (bits->list #x100000000000000000000000000000000))
(test-eqv "test-229" 6 (list->bits '(#f #t #t)))
(test-eqv "test-230" 12 (list->bits '(#f #f #t #t)))
(test-eqv "test-231" 6 (list->bits '(#f #t #t #f)))
(test-eqv "test-232" 2 (list->bits '(#f #t)))
(test-eqv "test-233"
  1 (list->bits
     '(#t #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
          #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
          #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
          #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
          #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
          #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
          #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
          #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f)))
(test-eqv "test-234" #x100000000000000000000000000000000
          (list->bits
           '(#f
             #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
             #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
             #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
             #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
             #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
             #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
             #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
             #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #t)))
(test-eqv "test-235" #x03FFFFFF (list->bits '(#t #t
                                                 #t #t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t)))
(test-eqv "test-236" #x07FFFFFF (list->bits '(#t #t #t
                                                 #t #t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t)))
(test-eqv "test-237" #x0FFFFFFF (list->bits '(#t #t #t #t
                                                 #t #t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t)))
(test-eqv "test-238" #x1FFFFFFF (list->bits '(#t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t)))
(test-eqv "test-239" #x3FFFFFFF (list->bits '(#t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t)))
(test-eqv "test-240" #x7FFFFFFF (list->bits '(#t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t)))
(test-eqv "test-241" #xFFFFFFFF (list->bits '(#t #t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t
                                                 #t #t #t #t #t #t #t #t)))
(test-eqv "test-242" #x1FFFFFFFF (list->bits '(#t
                                               #t #t #t #t #t #t #t #t
                                               #t #t #t #t #t #t #t #t
                                               #t #t #t #t #t #t #t #t
                                               #t #t #t #t #t #t #t #t)))
(test-eqv "test-490" 1 (list->bits '(#t #f)))
(test-eqv "test-108" #b1110101 (vector->bits '#(#t #f #t #f #t #t #t)))
(test-eqv "test-109" #b00011010100 (vector->bits '#(#f #f #t #f #t #f #t #t)))
(test-equal "test-105"
  '#(#t #t #t #f #t #f #t #f #f) (bits->vector #b1010111 9))
(test-equal "test-105"
  '#(#t #t #t #f #t #f #t #f #f) (bits->vector #b1010111 9))
(test-eqv "test-110" #b1110101 (bits #t #f #t #f #t #t #t))
(test-eqv "test-243" 0 (bits))
(test-eqv "test-111" #b111010100 (bits #f #f #t #f #t #f #t #t #t))
(test-end "conversion")

(test-begin "fold")
(test-equal "test-112"
  '(#t #f #t #f #t #t #t) (bitwise-fold cons '() #b1010111))
(test-eqv "test-113" 5
          (let ((count 0))
            (bitwise-for-each (lambda (b) (if b (set! count (+ count 1))))
                              #b1010111)
            count))
(test-eqv "test-114" #b101010101
          (bitwise-unfold (lambda (i) (= i 10)) even? (lambda (i) (+ i 1)) 0))
(let ((g (make-bitwise-generator #b110)))
  (test-eqv "test-244a" #f (g))
  (test-eqv "test-244b" #t (g))
  (test-eqv "test-244c" #t (g))
  (test-eqv "test-244d" #f (g)))
(test-end "fold")

(test-end "srfi-151")
