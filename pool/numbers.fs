#---------------------------------------------------------------------- 
# to uppercase
.equ toupper, 0xDF
# using ASCII table

# ( k -- d | NaN ) #; ( >DIGIT ), receives a digit '0':'9' or 'A':'Z' 
# does uppercase and returns NaN at error
def_word "todigit" hash_TODIGIT
	.word xt_lit, '0', xt_less
	# less than 0 ?
	.word xt_dup, xt_nil, xt_less
	.word xt_if, xt_drop, xt_nan, xt_exit, xt_then
	# less than 10 ? 0 to 9 valid
	.word xt_dup, xt_lit, 10, xt_less
	.word xt_if, xt_exit, xt_then
	# offset of 'A', and uppercase
	.word xt_lit, 7, xt_minus
	# easy
	.word xt_lit, toupper, xt_and
	# less than 36 ? 10 to 36 valid
 	.word xt_dup, xt_lit, 37, xt_less 
	.word xt_if, xt_exit, xt_then
	# return NaN
	.word xt_drop, xt_nan
	.word xt_exit
 
# ( k* -- w | k NaN ) #; ( >NUMBER ), receives many digits '0':'9' or 'A':'Z' 
# does uppercase and returns NaN at error
def_word "tonumber" hash_TONUMBER
	.word xt_lit, xt_bl, xt_skipk
	.word xt_nil, xt_begin 
	.word xt_todigit, xt_dup, xt_nan, xt_equ
	.word xt_if, xt_drop, xt_drop, xt_abort, xt_exit, 
	.word xt_else, xt_base, xt_bymult, xt_plus, xt_until
	.word xt_then
# ZZZZZ	
	.word xt_exit




