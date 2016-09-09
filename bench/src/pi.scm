;;; PI -- Compute PI using bignums.

; See http://mathworld.wolfram.com/Pi.html for the various algorithms.

; Utilities.

(define (width x)
  (let loop ((i 0) (n 1))
    (if (GENERIC< x n) i (loop (GENERIC+ i 1) (GENERIC* n 2)))))

(define (root x y)
  (let loop ((g (GENERICexpt
                 2
                 (GENERICquotient (GENERIC+ (width x) (GENERIC- y 1)) y))))
    (let ((a (GENERICexpt g (GENERIC- y 1))))
      (let ((b (GENERIC* a y)))
        (let ((c (GENERIC* a (GENERIC- y 1))))
          (let ((d (GENERICquotient (GENERIC+ x (GENERIC* g c)) b)))
            (if (GENERIC< d g) (loop d) g)))))))

(define (square-root x)
  (root x 2))

(define (quartic-root x)
  (root x 4))

(define (square x)
  (GENERIC* x x))

; Compute pi using the 'brent-salamin' method.

(define (pi-brent-salamin nb-digits)
  (let ((one (GENERICexpt 10 nb-digits)))
    (let loop ((a one)
               (b (square-root (GENERICquotient (square one) 2)))
               (t (GENERICquotient one 4))
               (x 1))
      (if (GENERIC= a b)
          (GENERICquotient (square (GENERIC+ a b)) (GENERIC* 4 t))
          (let ((new-a (GENERICquotient (GENERIC+ a b) 2)))
            (loop new-a
                  (square-root (GENERIC* a b))
                  (GENERIC- t
                            (GENERICquotient
                             (GENERIC* x (square (GENERIC- new-a a)))
                             one))
                  (GENERIC* 2 x)))))))

; Compute pi using the quadratically converging 'borwein' method.

(define (pi-borwein2 nb-digits)
  (let* ((one (GENERICexpt 10 nb-digits))
         (one^2 (square one))
         (one^4 (square one^2))
         (sqrt2 (square-root (GENERIC* one^2 2)))
         (qurt2 (quartic-root (GENERIC* one^4 2))))
    (let loop ((x (GENERICquotient
                   (GENERIC* one (GENERIC+ sqrt2 one))
                   (GENERIC* 2 qurt2)))
               (y qurt2)
               (p (GENERIC+ (GENERIC* 2 one) sqrt2)))
      (let ((new-p (GENERICquotient (GENERIC* p (GENERIC+ x one))
                                    (GENERIC+ y one))))
        (if (GENERIC= x one)
            new-p
            (let ((sqrt-x (square-root (GENERIC* one x))))
              (loop (GENERICquotient
                     (GENERIC* one (GENERIC+ x one))
                     (GENERIC* 2 sqrt-x))
                    (GENERICquotient
                     (GENERIC* one (GENERIC+ (GENERIC* x y) one^2))
                     (GENERIC* (GENERIC+ y one) sqrt-x))
                    new-p)))))))

; Compute pi using the quartically converging 'borwein' method.

(define (pi-borwein4 nb-digits)
  (let* ((one (GENERICexpt 10 nb-digits))
         (one^2 (square one))
         (one^4 (square one^2))
         (sqrt2 (square-root (GENERIC* one^2 2))))
    (let loop ((y (GENERIC- sqrt2 one))
               (a (GENERIC- (GENERIC* 6 one) (GENERIC* 4 sqrt2)))
               (x 8))
      (if (GENERIC= y 0)
          (GENERICquotient one^2 a)
          (let* ((t1 (quartic-root (GENERIC- one^4 (square (square y)))))
                 (t2 (GENERICquotient
                      (GENERIC* one (GENERIC- one t1))
                      (GENERIC+ one t1)))
                 (t3 (GENERICquotient
                      (square (GENERICquotient (square (GENERIC+ one t2)) one))
                      one))
                 (t4 (GENERIC+ one
                               (GENERIC+ t2
                                         (GENERICquotient (square t2) one)))))
            (loop t2
                  (GENERICquotient
                   (GENERIC- (GENERIC* t3 a) (GENERIC* x (GENERIC* t2 t4)))
                   one)
                  (GENERIC* 4 x)))))))

; Try it.

(define (pies n m s)
  (if (GENERIC< m n)
      '()
      (let ((bs (pi-brent-salamin n))
            (b2 (pi-borwein2 n))
            (b4 (pi-borwein4 n)))
        (cons (list b2 (GENERIC- bs b2) (GENERIC- b4 b2))
              (pies (GENERIC+ n s) m s)))))

(define expected
  '((314159265358979323846264338327950288419716939937507
     -54
     124)
    (31415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170673
     -51
     -417)
    (3141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408122
     -57
     -819)
    (314159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038195
     -76
     332)
    (31415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019089
     -83
     477)
    (3141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481117450284102701938521105559644622948954930381964428810975665933446128475648233786783165271201909145648566923460348610454326648213393607260249141268
     -72
     -2981)
    (314159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038196442881097566593344612847564823378678316527120190914564856692346034861045432664821339360726024914127372458700660631558817488152092096282925409171536431
     -70
     -2065)
    (31415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665213841469519415116089
     -79
     1687)
    (3141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481117450284102701938521105559644622948954930381964428810975665933446128475648233786783165271201909145648566923460348610454326648213393607260249141273724587006606315588174881520920962829254091715364367892590360011330530548820466521384146951941511609433057270365759591953092186117381932611793105118542
     -92
     -2728)
    (314159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038196442881097566593344612847564823378678316527120190914564856692346034861045432664821339360726024914127372458700660631558817488152092096282925409171536436789259036001133053054882046652138414695194151160943305727036575959195309218611738193261179310511854807446237996274956735188575272489122793818301194907
     -76
     -3726)))

(define (main . args)
  (run-benchmark
   "pi"
   pi-iters
   (lambda (result) (equal? result expected))
   (lambda (n m s) (lambda () (pies n m s)))
   50
   500
   50))
