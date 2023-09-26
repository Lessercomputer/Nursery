#define C u8"c"
#define B C
#define A B
#define D a ## b ## c ## 1 C
#define F(a, b) #a b
#define F2(a, b) a ## b
#define F3(...) __VA_ARGS__
#define f(a) a*g
#define g(a) f(a)
#define E1 F
#define E2 E1 (1, 2)
#define o1 f1
#define f1() o2
#define o2() v
#define E3 o1()()
#define G G ## 1
#define F4(a, ...) a __VA_ARGS__
#define F5(a) #a
#define F6(a, b) #a ## b
#define F7(a) #a a
#define F8(a, b, c) a b c
#define G1 g1

A
D
A B
F(abc, (A))
F2(a, F2(b, c))
F3(a, b, c)
f(2)(9)
E2
E3
G
F4(x, y, z)
F5(  u8"\"ab\\c"
    def  1  )
F5(u'a')
F2(C, a)
F6(abc1, 2)
F7(A)
F8( ( a  , b , c ) , x, y)
F8(,,)
F3(,,)

#undef A
A

__LINE__

#define line __LINE__
#define line2 line
line2

#line 54

__LINE__

#line 200 "macro example"

__LINE__

__FILE__
__TIME__
__DATE__
