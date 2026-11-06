#---------------------------------------------------------------------- 

# words from compiled.S that were included into assembled.S

#---------------------------------------------------------------------- 
.equ hash_ZEQU, 0x00596808 #; ( 0= )
.equ hash_ZLESS, 0x00596809 #; ( 0< )
.equ hash_ZGREAT, 0x0059680B #; ( 0> )

# ( w -- f ) #; ( 0= )
def_word "zequ" hash_ZEQU
	.word xt_lit, 0
	.word xt_equ
	.word xt_exit

# ( w -- f ) #; ( 0< )
def_word "zless" hash_ZLESS
	.word xt_lit, 0
	.word xt_less
	.word xt_exit

# ( w -- f ) #; ( 0> )
def_word "zmore" hash_ZMORE
	.word xt_lit, 0
	.word xt_greather
	.word xt_exit

#---------------------------------------------------------------------- 
# must hide what value is it !
# do not presume is 0 or -1 :)

.equ hash_FALSE, 0x0C3C6778 #; ( FALSE )
.equ hash_TRUE, 0x7C879BF3 #; ( TRUE )

def_word "false" hash_FALSE
	.word xt_lit, FALSE
	.word xt_exit

def_word "true" hash_TRUE
	.word xt_lit, TRUE
	.word xt_exit

#---------------------------------------------------------------------- 

