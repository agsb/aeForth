# pecompiled words

def_native "lit" hash_LIT
	.word docon
	.word exit

def_native "here" hash_HERE
	.word heap, fetch
	.word exit

def_native "allot" hash_ALLOT
	.word here, plus, heap, store
	.word exit

def_native "comma" hash_COMMA
	.word here, store, cell, allot
	.word exit

def_native "begin" hash_BEGIN
	.word here
	.word exit

def_native "back" hash_BACK
	.word here, minus, comma
	.word exit

def_native "again" hash_AGAIN
	.word lit, branch, comma, back
	.word exit

def_native "until" hash_UNTIL
	.word lit, zbranch, comma, back
	.word exit

def_native "endif" hash_ENDIF
	.word here, over, minus, swap, store
	.word exit

def_native "mark" hash_MARK
	.word here, nil, comma
	.word exit

def_native "aft" hash_AAFT
	.word here
	.word exit

def_native "if" hash_IF
	.word lit, zbranch, comma, mark
	.word exit

def_native "else" hash_ELSE
	.word lit, branch, comma, mark, swap, endif
	.word exit

def_native "then" hash_THEN
	.word endif
	.word exit

def_native "while" hash_WHILE
	.word lit, zbranch, comma, mark
	.word exit

def_native "repeat" hash_REPEAT
	.word swap, lit, branch, comma, back, endif
	.word exit

def_native "do" hash_DO
	.word lit, swap, comma, 
	.word here 
	.word lit, tor, comma 
	.word lit, tor, comma
	.word exit

def_native "loop" hash_LOOP
	.word lit, rto, comma
	.word lit, lit, comma 
	.word lit, 1, comma
	.word lit, plus, comma
	.word lit, rto, comma
	.word lit, over, comma
	.word lit, over, comma
	.word lit, equ, comma
	.word lit, zbranch, comma
	.word here, minus, comma
	.word lit, drop, comma
	.word lit, drop, comma
	.word exit

def_native "i" hash_I
	.word lit, rat, comma
	.word exit

def_native "j" hash_J
   	.word lit, rto, comma
   	.word lit, rto, comma
   	.word lit, rat, comma
	.word lit, swap, comma
   	.word lit, tor, comma
	.word lit, swap, comma
   	.word lit, tor, comma
	.word exit

def_native "leave" hash_LEAVE
   	.word lit, rto, comma
	.word lit, drop, comma
   	.word lit, rto, comma
	.word lit, drop, comma
	.word exit
	
def_native "for" hash_FOR
	.word here 
	.word lit, tor, comma 
	.word exit

def_native "next" hash_NEXT
	.word lit, rto, comma
	.word lit, 1, comma
	.word lit, minus, comma
	.word lit, dup, comma
	.word lit, 0, comma
	.word lit, equ, comma
	.word lit, zbranch, comma
	.word here, minus, comma
	.word lit, drop, comma
	.word lit, drop, comma
	.word exit

# zzzz

# ( -- ) ; aka figforth semicolon
def_native "colon" hash_COLON
	# save here, panic if semis not follow elsewhere
	.word heap, fetch, pike, store
	# stat is 'compile' == 1
	.word one, state, store
	# make a header
	.word header
	.word exit

# ( -- ) ; aka figforth semicolon, is IMMEDIATE
def_native "semis" hash_SEMIS 
	# load last, panic if colon not lead elsewhere
	.word pike, fetch, last, store
	# stat is 'execute' == 0
	.word nil, state, store
	# make a footer
	.word docon, exit, comma
	.word exit

# ( -- ) ; aka figforth semicolon
def_native "header" hash_HEADER
	.word last, fetch, comma
	.word token, comma
	.word exit

# ( c w -- h )
def_native "djb2" hash_DJB2
	.word dup, dup, plus, 
	.word dup, plus, dup, plus, 
	.word dup, plus, dup, plus, 
	.word plus, xor
	.exit

# ( -- h ) 
def_native "token" hash_TOKEN
	# skip spaces
	.word dolit, BL
	.word begin, key, over, over, equ, inverse, until
	# prepare
	.word dolit, 5381, tor
	.word begin
	.word rto, djb2, tor
	.word key, over, over, equ
	.word inverse, until
	.word drop, drop
	.word nan, inverse, rto, and
	.word exit

#----------------------------------------------------------------------
# djb2 hash function
# classic djb2 hash algorithm, with XOR, adapted from cdb_hash
#----------------------------------------------------------------------
# magic numbers
.equ DJB2, 5381
.equ SFHT, 5
#----------------------------------------------------------------------
# return the hash of token in nos
token:
	push tos sp 

        # prepare for hash

        lui nos, %hi(DJB2)
        addi nos, nos, %lo(DJB2)

        # load word separator, BL is space

        li fth, BL

        # skip spaces, character returns in tos
skip:
        call _getc

        ble tos, fth, skip

        # djb2 hash function
hash:

        mv trd, nos

        slli nos, nos, SFHT

        add nos, nos, trd

        xor nos, nos, fst

        # scan spaces
scan:
        call _getc

        blt tos, fth, scan

        bne tos, fth, hash

        # clear hash high bit
mask:

        slli nos, nos, 1

        srli nos, nos, 1

	pull tos sp

	ret

#----------------------------------------------------------------------

