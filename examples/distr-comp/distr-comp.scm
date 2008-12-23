#!/usr/bin/env gsi-script

; File: "distr-comp.scm", Time-stamp: <2008-12-17 13:41:12 feeley>

; Copyright (c) 2005-2007 by Marc Feeley, All Rights Reserved.

; A small example of distributed computation.

;==============================================================================

(##include "~~lib/gambit#.scm")
(##include "dc#.scm")

(declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (not safe)
)

;==============================================================================

(define port-num 9000)

(define (main)
  (spawn (become-tcp-node port-num 'node-1 node-1))
  (become-tcp-node port-num 'node-2 (lambda () 'no-op)))

(define (node-1)
  (spawn
   (let ((n1 (current-node))
         (n2 (make-tcp-node (host-name) port-num 'node-2)))
     (let loop ((i 0) (a n1) (b n2))
       (if (= i 100)
           (exit)
           (begin
             (if #t
                 (begin
                   (pp (list i 'from (current-node-name))
                       (current-output-port))
                   (force-output (current-output-port))
                   (thread-sleep! .1)))
             (goto b)
             (loop (+ i 1) b a)))))))

(define (node-2)
  'do-nothing)

;==============================================================================
