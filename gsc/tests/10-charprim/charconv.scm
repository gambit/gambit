(declare (extended-bindings) (not constant-fold) (not safe))

(define (chareq x y)
  (println (##char=? x y))
  (println (if (##char=? x y) 11 22)))

(println (##char->integer #\*))

(println (##char->integer (##integer->char 33)))

(chareq #\! (##integer->char 33))

(chareq #\x #\X)
