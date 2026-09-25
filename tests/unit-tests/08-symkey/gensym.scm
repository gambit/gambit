(include "#.scm")

(test-assert (symbol? (gensym)))
(test-assert (symbol? (gensym 'cov)))
(test-assert (uninterned-symbol? (gensym)))
(test-eq #f (eq? (gensym) (gensym)))
(test-error-tail type-exception? (gensym 1))
(test-error-tail wrong-number-of-arguments-exception? (gensym 'a 1))
