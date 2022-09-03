(include "#.scm")

(define (str->obj str)
  (with-exception-catcher
   (lambda (exc)
     ;;(display-exception exc)
     exc)
   (lambda ()
     (with-input-from-string str read-all))))

(define-macro (chk str first . rest)
  `(check-equal? (str->obj ,str) '((six.infix ,first) ,@rest)))

(chk "\\a"        (six.identifier a))
(chk "\\ a "      (six.identifier a))
(chk "\\a;"       (six.identifier a))
(chk "\\a;Z"      (six.identifier a) Z)
(chk "\\{ a ; }"  (six.compound (six.identifier a)))
(chk "\\{ a ; }Z" (six.compound (six.identifier a)) Z)

(chk "\\a++" (six.x++ (six.identifier a)))
(chk "\\a--" (six.x-- (six.identifier a)))
(chk "\\a( )" (six.call (six.identifier a)))
(chk "\\a( b )" (six.call (six.identifier a) (six.identifier b)))
(chk "\\a( b , c )" (six.call (six.identifier a) (six.identifier b) (six.identifier c)))
(chk "\\a[ b ]" (six.index (six.identifier a) (six.identifier b)))
(chk "\\a-> b" (six.arrow (six.identifier a) (six.identifier b)))
(chk "\\a.b" (six.dot (six.identifier a) (six.identifier b)))

(chk "\\& a" (six.&x (six.identifier a)))
(chk "\\+ a" (six.+x (six.identifier a)))
(chk "\\- a" (six.-x (six.identifier a)))
(chk "\\* a" (six.*x (six.identifier a)))
(chk "\\++ a" (six.++x (six.identifier a)))
(chk "\\-- a" (six.--x (six.identifier a)))
(chk "\\~ a" (six.~x (six.identifier a)))
(chk "\\new a ( )" (six.new (six.identifier a)))
(chk "\\new a ( b )" (six.new (six.identifier a) (six.identifier b)))
(chk "\\new a ( b , c )" (six.new (six.identifier a) (six.identifier b) (six.identifier c)))
(chk "\\a** b" (six.x**y (six.identifier a) (six.identifier b)))

(chk "\\a+ b" (six.x+y (six.identifier a) (six.identifier b)))
(chk "\\a- b" (six.x-y (six.identifier a) (six.identifier b)))

(chk "\\a<< b" (six.x<<y (six.identifier a) (six.identifier b)))
(chk "\\a>> b" (six.x>>y (six.identifier a) (six.identifier b)))
(chk "\\a>>> b" (six.x>>>y (six.identifier a) (six.identifier b)))

(chk "\\a? b : c" (six.x?y:z (six.identifier a) (six.identifier b) (six.identifier c)))

(chk "\\a< b" (six.x<y (six.identifier a) (six.identifier b)))
(chk "\\a<= b" (six.x<=y (six.identifier a) (six.identifier b)))
(chk "\\a> b" (six.x>y (six.identifier a) (six.identifier b)))
(chk "\\a>= b" (six.x>=y (six.identifier a) (six.identifier b)))
(chk "\\( a in b )" (six.xiny (six.identifier a) (six.identifier b)))
(chk "\\( a is b )" (six.xisy (six.identifier a) (six.identifier b)))

(chk "\\a!= b" (six.x!=y (six.identifier a) (six.identifier b)))
(chk "\\a== b" (six.x==y (six.identifier a) (six.identifier b)))
(chk "\\a!== b" (six.x!==y (six.identifier a) (six.identifier b)))
(chk "\\a=== b" (six.x===y (six.identifier a) (six.identifier b)))

(chk "\\a& b" (six.x&y (six.identifier a) (six.identifier b)))

(chk "\\a^ b" (six.x^y (six.identifier a) (six.identifier b)))

(chk "\\a| b" (|six.x\|y| (six.identifier a) (six.identifier b)))

(chk "\\a&& b" (six.x&&y (six.identifier a) (six.identifier b)))

(chk "\\a|| b" (|six.x\|\|y| (six.identifier a) (six.identifier b)))

(chk "\\!;" (six.!))
(chk "\\(!)" (six.!))
(chk "\\! a==b" (six.x==y (six.!x (six.identifier a)) (six.identifier b)))
(chk "\\( ! a == b )"  (six.x==y (six.!x (six.identifier a)) (six.identifier b)))

(chk "\\async" (six.identifier async))
(chk "\\( async a == b )" (six.x==y (six.asyncx (six.identifier a)) (six.identifier b)))

(chk "\\await" (six.identifier await))
(chk "\\( await a == b )" (six.x==y (six.awaitx (six.identifier a)) (six.identifier b)))

(chk "\\typeof" (six.identifier typeof))
(chk "\\( typeof a == b )" (six.x==y (six.typeofx (six.identifier a)) (six.identifier b)))

(chk "\\not" (six.identifier not))
(chk "\\( not a == b )" (six.notx (six.x==y (six.identifier a) (six.identifier b))))

(chk "\\yield" (six.identifier yield))
(chk "\\( yield a == b )" (six.yieldx (six.x==y (six.identifier a) (six.identifier b))))

(chk "\\instanceof" (six.identifier instanceof))
(chk "\\( a instanceof b )" (six.xinstanceofy (six.identifier a) (six.identifier b)))

(chk "\\and" (six.identifier and))
(chk "\\( a and b )" (six.xandy (six.identifier a) (six.identifier b)))

(chk "\\or" (six.identifier or))
(chk "\\( a or b )" (six.xory (six.identifier a) (six.identifier b)))

(chk "\\( a : b )" (six.x:y (six.identifier a) (six.identifier b)))

(chk "\\a%= b" (six.x%=y (six.identifier a) (six.identifier b)))
(chk "\\a&= b" (six.x&=y (six.identifier a) (six.identifier b)))
(chk "\\a**= b" (six.x**=y (six.identifier a) (six.identifier b)))
(chk "\\a*= b" (six.x*=y (six.identifier a) (six.identifier b)))
(chk "\\a@= b" (six.x@=y (six.identifier a) (six.identifier b)))
(chk "\\a+= b" (six.x+=y (six.identifier a) (six.identifier b)))
(chk "\\a-= b" (six.x-=y (six.identifier a) (six.identifier b)))
(chk "\\a//= b" (six.x//=y (six.identifier a) (six.identifier b)))
(chk "\\a/= b" (six.x/=y (six.identifier a) (six.identifier b)))
(chk "\\a<<= b" (six.x<<=y (six.identifier a) (six.identifier b)))
(chk "\\a= b" (six.x=y (six.identifier a) (six.identifier b)))
(chk "\\a>>>= b" (six.x>>>=y (six.identifier a) (six.identifier b)))
(chk "\\a>>= b" (six.x>>=y (six.identifier a) (six.identifier b)))
(chk "\\a^= b" (six.x^=y (six.identifier a) (six.identifier b)))
(chk "\\a|= b" (|six.x\|=y| (six.identifier a) (six.identifier b)))

(chk "\\a:= b" (six.x:=y (six.identifier a) (six.identifier b)))

(chk "\\a, b" (|six.x,y| (six.identifier a) (six.identifier b)))

(chk "\\a:- b" (six.x:-y (six.identifier a) (six.identifier b)))

(chk "\\if (0) 1"        (six.if (six.literal 0) (six.literal 1)))
(chk "\\if (0) ;"        (six.if (six.literal 0) (six.compound)))
(chk "\\if (0) ;else"    (six.if (six.literal 0) (six.compound)) else)
(chk "\\if (0) 1;else"   (six.if (six.literal 0) (six.literal 1)) else)
(chk "\\{ if (0) ; }"    (six.compound (six.if (six.literal 0) (six.compound))))
(chk "\\{ if (0) 1 ; }Z" (six.compound (six.if (six.literal 0) (six.literal 1))) Z)

(chk "\\while (0) 1"        (six.while (six.literal 0) (six.literal 1)))
(chk "\\while (0) ;"        (six.while (six.literal 0) (six.compound)))
(chk "\\while (0) ;Z"       (six.while (six.literal 0) (six.compound)) Z)
(chk "\\while (0) 1;Z"      (six.while (six.literal 0) (six.literal 1)) Z)
(chk "\\{ while (0) 1 ; }"  (six.compound (six.while (six.literal 0) (six.literal 1))))
(chk "\\{ while (0) 1 ; }Z" (six.compound (six.while (six.literal 0) (six.literal 1))) Z)

(chk "\\do 1 ; while (0)"        (six.do-while (six.literal 1) (six.literal 0)))
(chk "\\do 1 ; while (0);Z"      (six.do-while (six.literal 1) (six.literal 0)) Z)
(chk "\\{ do 1 ; while (0) ; }"  (six.compound (six.do-while (six.literal 1) (six.literal 0))))
(chk "\\{ do 1 ; while (0) ; }Z" (six.compound (six.do-while (six.literal 1) (six.literal 0))) Z)

(chk "\\for (;;) 1"        (six.for (six.compound) #f #f (six.literal 1)))
(chk "\\for (;;) ;"        (six.for (six.compound) #f #f (six.compound)))
(chk "\\for (;;) ;Z"       (six.for (six.compound) #f #f (six.compound)) Z)
(chk "\\for (;;) 1;Z"      (six.for (six.compound) #f #f (six.literal 1)) Z)
(chk "\\{ for (;;) 1 ; }"  (six.compound (six.for (six.compound) #f #f (six.literal 1))))
(chk "\\{ for (;;) 1 ; }Z" (six.compound (six.for (six.compound) #f #f (six.literal 1))) Z)

(chk "\\switch (0) 1"        (six.switch (six.literal 0) (six.literal 1)))
(chk "\\switch (0) ;"        (six.switch (six.literal 0) (six.compound)))
(chk "\\switch (0) ;Z"       (six.switch (six.literal 0) (six.compound)) Z)
(chk "\\switch (0) 1;Z"      (six.switch (six.literal 0) (six.literal 1)) Z)
(chk "\\{ switch (0) 1 ; }"  (six.compound (six.switch (six.literal 0) (six.literal 1))))
(chk "\\{ switch (0) 1 ; }Z" (six.compound (six.switch (six.literal 0) (six.literal 1))) Z)

(chk "\\case 0 : 1"        (six.case (six.literal 0) (six.literal 1)))
(chk "\\case 0 : ;"        (six.case (six.literal 0) (six.compound)))
(chk "\\case 0 : ;Z"       (six.case (six.literal 0) (six.compound)) Z)
(chk "\\case 0 : 1;Z"      (six.case (six.literal 0) (six.literal 1)) Z)
(chk "\\{ case 0 : 1 ; }"  (six.compound (six.case (six.literal 0) (six.literal 1))))
(chk "\\{ case 0 : 1 ; }Z" (six.compound (six.case (six.literal 0) (six.literal 1))) Z)

(chk "\\break"        (six.break))
(chk "\\break;"       (six.break))
(chk "\\{ break ; }"  (six.compound (six.break)))
(chk "\\{ break ; }Z" (six.compound (six.break)) Z)

(chk "\\continue"        (six.continue))
(chk "\\continue;"       (six.continue))
(chk "\\{ continue ; }"  (six.compound (six.continue)))
(chk "\\{ continue ; }Z" (six.compound (six.continue)) Z)

(chk "\\lab: 1"        (six.label lab (six.literal 1)))
(chk "\\lab: ;"        (six.label lab (six.compound)))
(chk "\\lab: ;Z"       (six.label lab (six.compound)) Z)
(chk "\\lab: 1;Z"      (six.label lab (six.literal 1)) Z)
(chk "\\{ lab: 1 ; }"  (six.compound (six.label lab (six.literal 1))))
(chk "\\{ lab: 1 ; }Z" (six.compound (six.label lab (six.literal 1))) Z)

(chk "\\goto 1"        (six.goto (six.literal 1)))
(chk "\\goto 1;Z"      (six.goto (six.literal 1)) Z)
(chk "\\{ goto 1 ; }"  (six.compound (six.goto (six.literal 1))))
(chk "\\{ goto 1 ; }Z" (six.compound (six.goto (six.literal 1))) Z)

(chk "\\return 1"        (six.return (six.literal 1)))
(chk "\\return 1;Z"      (six.return (six.literal 1)) Z)
(chk "\\return ;"        (six.return))
(chk "\\return ;Z"       (six.return) Z)
(chk "\\{ return 1 ; }"  (six.compound (six.return (six.literal 1))))
(chk "\\{ return 1 ; }Z" (six.compound (six.return (six.literal 1))) Z)
(chk "\\{ return ; }"    (six.compound (six.return)))
(chk "\\{ return ; }Z"   (six.compound (six.return)) Z)

(chk "\\import 1"            (six.import (six.literal 1)))
(chk "\\import 1, 2"         (six.import (six.literal 1) (six.literal 2)))
(chk "\\import 1, 2;Z"       (six.import (six.literal 1) (six.literal 2)) Z)
(chk "\\{ import 1 , 2 ; }"  (six.compound (six.import (six.literal 1) (six.literal 2))))
(chk "\\{ import 1 , 2 ; }Z" (six.compound (six.import (six.literal 1) (six.literal 2))) Z)

(chk "\\from 0 import 1"           (six.from-import (six.literal 0) (six.literal 1)))
(chk "\\from 0 import 1, 2"        (six.from-import (six.literal 0) (six.literal 1) (six.literal 2)))
(chk "\\from 0 import 1, 2;Z"      (six.from-import (six.literal 0) (six.literal 1) (six.literal 2)) Z)
(chk "\\{ from 0 import 1, 2 ; }"  (six.compound (six.from-import (six.literal 0) (six.literal 1) (six.literal 2))))
(chk "\\{ from 0 import 1, 2 ; }Z" (six.compound (six.from-import (six.literal 0) (six.literal 1) (six.literal 2))) Z)

(chk "\\from 0 import *"        (six.from-import-* (six.literal 0)))
(chk "\\from 0 import *;Z"      (six.from-import-* (six.literal 0)) Z)
(chk "\\{ from 0 import * ; }"  (six.compound (six.from-import-* (six.literal 0))))
(chk "\\{ from 0 import * ; }Z" (six.compound (six.from-import-* (six.literal 0))) Z)

(chk "\\ { 1; 2; 3; }" (six.compound (six.literal 1) (six.literal 2) (six.literal 3)))

(chk "\\a= - b"        (six.x=y (six.identifier a) (six.-x (six.identifier b))))
(chk "\\a= - b;Z"      (six.x=y (six.identifier a) (six.-x (six.identifier b))) Z)
(chk "\\{ a= - b ; }"  (six.compound (six.x=y (six.identifier a) (six.-x (six.identifier b)))))
(chk "\\{ a= - b ; }Z" (six.compound (six.x=y (six.identifier a) (six.-x (six.identifier b)))) Z)

(chk "\\a= b+ c"          (six.x=y (six.identifier a) (six.x+y (six.identifier b) (six.identifier c))))
(chk "\\a= b+ c;Z"        (six.x=y (six.identifier a) (six.x+y (six.identifier b) (six.identifier c))) Z)
(chk "\\{ a = b + c ; }"  (six.compound (six.x=y (six.identifier a) (six.x+y (six.identifier b) (six.identifier c)))))
(chk "\\{ a = b + c ; }Z" (six.compound (six.x=y (six.identifier a) (six.x+y (six.identifier b) (six.identifier c)))) Z)

(chk "\\a? b : c"         (six.x?y:z (six.identifier a) (six.identifier b) (six.identifier c)))
(chk "\\a? b : c;Z"       (six.x?y:z (six.identifier a) (six.identifier b) (six.identifier c)) Z)
(chk "\\{ a ? b : c ; }"  (six.compound (six.x?y:z (six.identifier a) (six.identifier b) (six.identifier c))))
(chk "\\{ a ? b : c ; }Z" (six.compound (six.x?y:z (six.identifier a) (six.identifier b) (six.identifier c))) Z)

(chk "\\scmobj x"        (six.define-variable (six.identifier x) scmobj () #f))
(chk "\\scmobj x;Z"      (six.define-variable (six.identifier x) scmobj () #f) Z)
(chk "\\{ scmobj x ; }"  (six.compound (six.define-variable (six.identifier x) scmobj () #f)))
(chk "\\{ scmobj x ; }Z" (six.compound (six.define-variable (six.identifier x) scmobj () #f)) Z)

(chk "\\scmobj x= 1"         (six.define-variable (six.identifier x) scmobj () (six.literal 1)))
(chk "\\scmobj x= 1;Z"       (six.define-variable (six.identifier x) scmobj () (six.literal 1)) Z)
(chk "\\{ scmobj x = 1 ; }"  (six.compound (six.define-variable (six.identifier x) scmobj () (six.literal 1))))
(chk "\\{ scmobj x = 1 ; }Z" (six.compound (six.define-variable (six.identifier x) scmobj () (six.literal 1))) Z)

(chk "\\scmobj x[ 5 ]= 1"          (six.define-variable (six.identifier x) scmobj ((six.literal 5)) (six.literal 1)))
(chk "\\scmobj x[ 5 ]= 1;Z"        (six.define-variable (six.identifier x) scmobj ((six.literal 5)) (six.literal 1)) Z)
(chk "\\{ scmobj x [ 5 ] = 1 ; }"  (six.compound (six.define-variable (six.identifier x) scmobj ((six.literal 5)) (six.literal 1))))
(chk "\\{ scmobj x [ 5 ] = 1 ; }Z" (six.compound (six.define-variable (six.identifier x) scmobj ((six.literal 5)) (six.literal 1))) Z)

(chk "\\scmobj ( ) { }"        (six.procedure scmobj () (six.procedure-body)))
(chk "\\scmobj ( ) { };"       (six.procedure scmobj () (six.procedure-body)))
(chk "\\scmobj ( ) { };Z"      (six.procedure scmobj () (six.procedure-body)) Z)

(chk "\\function ( ) { }"      (six.procedure #f () (six.procedure-body)))
(chk "\\function ( ) { };"     (six.procedure #f () (six.procedure-body)))
(chk "\\function ( ) { };Z"    (six.procedure #f () (six.procedure-body)) Z)

(chk "\\scmobj x( ) { }"       (six.define-procedure (six.identifier x) (six.procedure scmobj () (six.procedure-body))))
(chk "\\scmobj x( ) { }Z"      (six.define-procedure (six.identifier x) (six.procedure scmobj () (six.procedure-body))) Z)
(chk "\\{ scmobj x ( ) { } }"  (six.compound (six.define-procedure (six.identifier x) (six.procedure scmobj () (six.procedure-body)))))
(chk "\\{ scmobj x ( ) { } }Z" (six.compound (six.define-procedure (six.identifier x) (six.procedure scmobj () (six.procedure-body)))) Z)

(chk "\\scmobj x( scmobj y ) { }"  (six.define-procedure (six.identifier x) (six.procedure scmobj (((six.identifier y) scmobj)) (six.procedure-body))))
(chk "\\scmobj x( y ) { }"         (six.define-procedure (six.identifier x) (six.procedure scmobj (((six.identifier y) #f)) (six.procedure-body))))

(chk "\\scmobj x( scmobj y , z) { }" (six.define-procedure (six.identifier x) (six.procedure scmobj (((six.identifier y) scmobj) ((six.identifier z) #f)) (six.procedure-body))))
(chk "\\scmobj x( y , scmobj z) { }" (six.define-procedure (six.identifier x) (six.procedure scmobj (((six.identifier y) #f) ((six.identifier z) scmobj)) (six.procedure-body))))

(chk "\\function x(y) { return y; }" (six.define-procedure (six.identifier x) (six.procedure #f (((six.identifier y) #f)) (six.procedure-body (six.return (six.identifier y))))))
(chk "\\function x(y) { return y; }Z" (six.define-procedure (six.identifier x) (six.procedure #f (((six.identifier y) #f)) (six.procedure-body (six.return (six.identifier y))))) Z)
