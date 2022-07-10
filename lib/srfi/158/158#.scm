;;;============================================================================

;;; File: "158#.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 158, Generators and Accumulators


(##namespace ("srfi/158#"
    every-eof-obj?-and-generate
    generator
    circular-generator
    make-iota-generator
    make-range-generator
    make-coroutine-generator
    list->generator
    vector->generator
    reverse-vector->generator
    string->generator
    bytevector->generator
    make-for-each-generator
    make-unfold-generator
    gcons*
    gappend
    gflatten
    ggroup
    simple-ggroup
    padded-ggrouo
    gmerge
    gmap
    gcombine
    gfilter
    gremove
    gstate-filter
    gtake
    gdrop
    gdrop-while
    gtake-while
    gdelete
    gdelete-neighbor-dups
    gindex
    gselect
    generator->list
    generator->reverse-list        
    generator->vector
    generator->vector!
    generator->string
    generator-fold
    generator-for-each
    generator-map->list
    generator-find
    generator-count  
    generator-any
    generator-every
    generator-unfold
    make-accumulator
    count-accumulator
    list-accumulator
    reverse-list-accumulator
    vector-accumulator
    reverse-vector-accumulator
    bytevector-accumulator
    bytevector-accumulator!
    string-accumulator
    sum-accumulator
    product-accumulator
))

;;;============================================================================
