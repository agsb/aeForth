
VARIABLE A
VARIABLE T
VARIABLE S
VARIABLE R
VARIABLE P

22 ARRAY TS
16 ARRAY RS

CASE	\ 32 operands as 5 bits, ? is non defined
 
	( else ) 	0 OF   END-OF \ 00000
	( T0 )  	1 OF   END-OF \ 00001
	( call ) 	2 OF   END-OF \ 00010
	( C0 ) 		3 OF   END-OF \ 00011
	( ? ) 		4 OF   END-OF \ 00100
	( ? ) 		5 OF   END-OF \ 00101
	( ret ) 	6 OF   END-OF \ 00110
	( ? ) 		7 OF   END-OF \ 00111
	( @R+)		8 OF   END-OF \ 01000
	( @A+) 		9 OF   END-OF \ 01001
	( # )		10 OF   END-OF \ 01010
	( @A )		11 OF   END-OF \ 01011
	( !R+ )		12 OF   END-OF \ 01100
	( !A+ )		13 OF   END-OF \ 01101
	( ? ) 		14 OF   END-OF \ 01110
	( !A )		15 OF   END-OF \ 01111
	( com ) 	16 OF   END-OF \ 10000
	( 2* ) 		17 OF   END-OF \ 10001
	( 2/ )		18 OF   END-OF \ 10010
	( +* )		19 OF   END-OF \ 10011
	( -or )		20 OF   END-OF \ 10100
	( and )		21 OF   END-OF \ 10101
	( ? )		22 OF   END-OF \ 10110
	( + )		23 OF   END-OF \ 10111
	( pop)		24 OF   END-OF \ 11000 
	( A@ )		25 OF   END-OF \ 11001
	( dup )		26 OF   END-OF \ 11010
	( over )	27 OF   END-OF \ 11011
	( push )	28 OF   END-OF \ 11100
	( A! )		29 OF   END-OF \ 11101
	( drop )	30 OF   END-OF \ 11110
	( nop ) 	31 OF   END-OF \ 11111

END-CASE

