# ( -- ) ; aka figforth semicolon
def_native "colon" hash_COLON
	# save here, panic if semis not follow elsewhere

        lw nos, HEAP (usr)

        sw nos, PIKE (usr)

	# stat is 'compile' == 1

        li nos, COMPILE

        sw nos, STAT (usr)

	# make a header
header:

	# copy last into (here)

        lw nos, LAST (usr)

        call comma

	# get a hash of the next token

        call token

	# copy hash into (here)

        call comma

end_native

# ( -- ) ; aka figforth semicolon
def_native "semis" hash_SEMIS
	# load last, panic if colon not lead elsewhere
      
	lw nos, PIKE (usr)
        
	sw nos, LAST (usr)
        
	# stat is 'execute' == 0

	li nos, EXECUTE

        sw nos, STAT (usr)

	# compiled words ends with 'exit

        la nos, is_exit

        call comma

end_native

comma:
	lw trd, HEAP (usr)
        
 	sw nos, 0 (trd)
        
	addi trd, trd, CELL
        
	sw trd, HEAP (usr)
        
	ret

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

