(declare (extended-bindings) (not constant-fold) (not safe))

(println (##eof-object? #!eof))
(println (##eof-object? 0))
(println (##eof-object? #f))
(println (##eof-object? #t))
(println (##eof-object? 'sym))
(println (##eof-object? '()))
