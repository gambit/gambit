(##namespace
 ("srfi/231#"
  
  ;; Miscellaneous Functions
  translation?
  permutation?
  index-rotate
  index-first
  index-last
  index-swap

  ;; Intervals
  make-interval
  interval?
  interval-dimension
  interval-lower-bound interval-upper-bound interval-width
  interval-lower-bounds->list interval-upper-bounds->list
  interval-lower-bounds->vector interval-upper-bounds->vector
  interval=
  interval-widths interval-volume interval-empty?
  interval-subset?
  interval-contains-multi-index?
  interval-projections
  interval-for-each
  interval-fold-left interval-fold-right
  interval-dilate
  interval-intersect
  interval-translate
  interval-permute
  interval-scale
  interval-cartesian-product

  ;; Storage Classes
  make-storage-class
  storage-class?
  storage-class-getter
  storage-class-setter
  storage-class-checker
  storage-class-maker
  storage-class-copier
  storage-class-length
  storage-class-default
  storage-class-data?
  storage-class-data->body
  generic-storage-class
  char-storage-class
  s8-storage-class
  s16-storage-class
  s32-storage-class
  s64-storage-class
  u1-storage-class
  u8-storage-class
  u16-storage-class
  u32-storage-class
  u64-storage-class
  f8-storage-class
  f16-storage-class
  f32-storage-class
  f64-storage-class
  c64-storage-class
  c128-storage-class

  ;; Arrays
  make-array
  array?
  array-domain
  array-getter
  array-dimension
  mutable-array?
  array-setter
  array-freeze!
  specialized-array-default-safe?
  specialized-array-default-mutable?
  array-empty?
  make-specialized-array
  make-specialized-array-from-data
  specialized-array?
  array-storage-class
  array-indexer
  array-body
  array-safe?
  array-packed?
  specialized-array-share
  array-curry
  array-extract
  array-tile
  array-translate
  array-permute
  array-reverse
  array-sample
  array-outer-product
  array-inner-product
  array-map
  array-for-each
  array-fold-left
  array-fold-right
  array-reduce
  array-any
  array-every
  array->list
  list->array
  list*->array
  array->list*
  array->vector
  vector->array
  vector*->array
  array->vector*
  array-assign!
  array-copy    array-copy!
  array-append  array-append!
  array-block   array-block!
  array-stack   array-stack!
  array-decurry array-decurry!
  specialized-array-reshape
  array-ref
  array-set!
  ))
