;;;============================================================================

;;; File: "33#.scm"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 33, Integer Bitwise-operation Library

(##namespace (""

bitwise-not
bitwise-and   bitwise-ior
bitwise-xor   bitwise-eqv
bitwise-nand  bitwise-nor
bitwise-andc1 bitwise-andc2
bitwise-orc1  bitwise-orc2

arithmetic-shift bit-count integer-length

bitwise-merge
bit-set? any-bits-set? all-bits-set?
first-set-bit

extract-bit-field test-bit-field? clear-bit-field
replace-bit-field copy-bit-field

))

;;;============================================================================
