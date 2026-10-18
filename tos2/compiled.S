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
	# save here, is_panic if semis not follow elsewhere
	.word is_heap, is_fetch, is_pike, is_store
	# stat is 'compile' == 1
	.word is_one, is_state, is_store
	# make a header
	.word is_header
	.word is_exit

# ( -- ) ; aka figforth semicolon, is IMMEDIATE
def_native "semis" hash_SEMIS 
	# load last, is_panic if colon not lead elsewhere
	.word is_pike, is_fetch, is_last, is_store
	# stat is 'execute' == 0
	.word is_nil, is_state, is_store
	# make a footer
	.word is_docon, is_exit, is_comma
	.word is_exit

# ( -- ) ; aka figforth semicolon
def_native "header" hash_HEADER
	.word is_last, is_fetch, is_comma
	.word is_token, is_comma
	.word is_exit

# ( -- ) ; aka figforth semicolon
def_native "token" hash_TOKEN
	.word docon, 5381
	.word docon, BL
	.word key, over, over, equ, zbranch  
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

