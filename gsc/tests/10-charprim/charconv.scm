(declare (extended-bindings) (not constant-fold) (not safe))

(define (chareq x y)
  (println (##char=? x y))
  (println (if (##char=? x y) 11 22)))

(println (##fx<-char #\*))

(println (##fx<-char (##fx->char 33)))

(chareq #\! (##fx->char 33))

(chareq #\x #\X)
