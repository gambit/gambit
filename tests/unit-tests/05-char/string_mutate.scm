(include "#.scm")

(test-equal "bcd" (string-copy "abcde" 1 4))
(test-equal "abcde" (string-copy "abcde"))
(test-equal "abxde"
  (let ((s (string #\a #\b #\c #\d #\e)))
    (string-set! s 2 #\x)
    s))
(test-equal "xxxxx"
  (let ((s (string #\a #\b #\c #\d #\e)))
    (string-fill! s #\x)
    s))
(test-equal "abxde" (string-set "abcde" 2 #\x))
(test-equal "abdce"
  (let ((s (string #\a #\b #\c #\d #\e)))
    (string-swap! s 2 3)
    s))
(test-equal "abc"
  (let ((s (string #\a #\b #\c #\d #\e)))
    (string-shrink! s 3)
    s))
(test-equal "axxde"
  (let ((s (string #\a #\b #\c #\d #\e)))
    (substring-fill! s 1 3 #\x)
    s))
(test-error-tail type-exception? (string-copy 1))
(test-error-tail type-exception? (string-set! 1 0 #\x))
(test-error-tail type-exception? (string-fill! 1 #\x))
(test-error-tail type-exception? (string-set 1 0 #\x))
(test-error-tail type-exception? (string-swap! 1 0 1))
(test-error-tail type-exception? (string-shrink! 1 0))
(test-error-tail type-exception? (substring-fill! 1 0 1 #\x))
(test-equal "eabcd"
  (let ((src (string #\a #\b #\c #\d))
        (dst (string #\e #\f #\g #\h #\i)))
    (string-copy! dst 1 src)
    dst))
(test-error-tail type-exception? (string-copy! 1 0 "ab"))
(test-equal "ecghi"
  (let ((src (string #\a #\b #\c #\d))
        (dst (string #\e #\f #\g #\h #\i)))
    (substring-move! src 2 3 dst 1)
    dst))
(test-error-tail type-exception? (substring-move! 1 0 1 "ab" 0))
