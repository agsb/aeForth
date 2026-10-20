/*
#---------------------------------------------------------------------
 
  Copyright 2025 Alvaro Gomes Sobral Barcellos <@agsb>
 
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 2 of the License, or
  (at your option) any later version.
 
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.
 
  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.

#----------------------------------------------------------------------
*/

#---------------------------------------------------------------------
#
# the minimal primitives 
# 
#---------------------------------------------------------------------

.macro push stack, register, index
        addi \stack, \stack, (index + 1) * CELL
        sw \register, 0 ( \stack )
.endm

.macro pull stack, register, index
        lw \register, 0 ( \stack )
        addi \stack, \stack, -1 * (index + 1) * CELL
.endm

#---------------------------------------------------------------------

.macro look stack, register, index
        lw \register, 0 ( \stack )
.endm

.macro post stack, register, index
        sw \register, (index) * CELL ( \stack )
.endm

#---------------------------------------------------------------------
# lazy macros
#
#       fst is the TOS, not in stack @!#$#%#
#       snd is the first CELL, trd is the second CELL, in data stack
#
.macro spusht 
        addi spt, spt, -1 * CELL
        sw tos, 0 ( spt )
.endm

.macro spullt 
        lw tos, 0 ( spt )
        addi spt, spt, +1 * CELL
.endm

.macro spulls
        lw snd, 0 ( spt )
        addi spt, spt, +1 * CELL
.endm

.macro rpusht
        addi rpt, rpt, -1 * CELL
        sw tos, 0 ( rpt )
.endm

.macro rpullt
        lw tos, 0 ( rpt )
        addi rpt, rpt, +1 * CELL
.endm

#---------------------------------------------------------------------
#
#  djb2 hash cleared of bit 31
#
#---------------------------------------------------------------------
# symbols ! @ + 0# : ;
.equ hash_store, 0x0002B584 
.equ hash_fetch, 0x0002B5E5 
.equ hash_plus,  0x0002B58E 
.equ hash_zeroq, 0x00596816 
.equ hash_colon, 0x0002B59F 
.equ hash_semis, 0x8002B59E # unique with FLAG_IMM 

#---------------------------------------------------------------------
# uppercase KEY EMIT EXIT NAND U@
.equ hash_KEY,   0x0B87F112
.equ hash_EMIT,  0x7C7C87D0
.equ hash_NAND,  0x7C8254C0
.equ hash_USERAT, 0x005973B0
.equ hash_EXIT,  0x7C7CC745

#---------------------------------------------------------------------

.equ init_minimals, last_next

#---------------------------------------------------------------------
# ( -- ) ; aka figforth semis
def_word "EXIT", "exit", hash_EXIT, init_minimals

        j unnest

#---------------------------------------------------------------------
# ( -- ), ; aka figforth colon 
def_word ":", "colon", hash_colon, it_exit
# save here, panic if semis not follow elsewhere
        
        lw fst, HEAP (usr)
        
        sw fst, PEEK (usr)

# stat is 'compile' == 1
        
        li fst, COMPILE
        
        sw fst, STAT (usr)

# make a header

header:

# copy last into (here)
        
        lw fst, LAST (usr)
        
        call comma

# get a hash of the next token
        
        call token

# copy hash into (here)

        mv fst, trd

docomma:

        call comma

        j next 

#---------------------------------------------------------------------
# ( -- ) ; aka figforth semicolon
def_word ";", "semis", hash_semis, it_colon 
# update last, panic if colon not lead elsewhere 
        
        lw fst, PEEK (usr)
        
        sw fst, LAST (usr)

# stat is 'interpret' == 0
        
        li fst, EXECUTE

        sw fst, STAT (usr)

footer:
# compound words must ends with exit
        
        la fst, is_exit

        j docomma

#---------------------------------------------------------------------
# ( -- c ) 
def_word "KEY", "key", hash_KEY, it_semis 

        spusht

        call _getc

        mv tos, fst

        j next

#---------------------------------------------------------------------
# ( c -- ) 
def_word "EMIT", "emit", hash_EMIT, it_key
        
        mv fst, tos

        call _putc

        spullt
        
        j next

#---------------------------------------------------------------------
# ( a w -- ),  [a] = w
def_word "!", "store", hash_store, it_emit
        
        spulls

        sw snd, 0 (tos)

        spullt

        j next

#---------------------------------------------------------------------
# ( a -- w ), w = [a]
def_word "@", "fetch", hash_fetch, it_store
        
        lw tos, 0 (tos)
        
        j next

#---------------------------------------------------------------------
# ( w1 w2 -- w), NOT(w1 AND w2)
def_word "NAND", "nand", hash_NAND, it_fetch

        spulls

        and tos, snd, tos
        
        not tos, tos

        j next

#---------------------------------------------------------------------
# ( w1 w2 -- w), w = w1 + w2  
def_word "+", "plus", hash_plus, it_nand
        
        spulls

        add tos, snd, tos

        j next

#---------------------------------------------------------------------
# ( 0 -- FALSE) | ( n -- TRUE), not zero at top ?
def_word "0#", "zeroq", hash_zeroq, it_plus

        beq tos, zero, isfalse

istrue:
        li tos, TRUE

        j next

isfalse:
        li tos, FALSE

        j next

#---------------------------------------------------------------------
# beware variables order
# ( -- _user ) return an reference to _user structure
def_word "U@", "userat", hash_USERAT, it_zeroq
        
        mv fst, usr

copyit:
        spusht

        mv tos, fst 

        j next

#---------------------------------------------------------------------

.equ last_next, it_userat

#---------------------------------------------------------------------

#---------------------------------------------------------------------
#
#  djb2 hash cleared of bit 31
#
#---------------------------------------------------------------------

.equ hash_DOCODE, 0x0059697A
.equ hash_ABORT, 0x0A1DFF4F
.equ hash_BYE, 0x0B87C61B
.equ hash_DOT, 0x0002B58B
.equ hash_HEX, 0x0002B581

#---------------------------------------------------------------------

.set init_extras, last_next

#---------------------------------------------------------------------
# ( -- ) push 0x80000000 #; Not a Number and flag IMMEDIATE and error
def_word "NAN", "nan", hash_NAN, init_extras
by_erro:
by_zero:
by_under:        
by_over:

        lui fst, 0x80000
        
        j copyit

#---------------------------------------------------------------------
# ( w1 w2 -- w1<<w2 ) #; shift left
def_word "LSHIFT", "lshift", hash_LSHIFT, it_nan

        spulls
        
        sll tos, snd, tos
        
        j next

#---------------------------------------------------------------------
# ( w1 w2 -- w1>>w2 ) #; shift right
def_word "RSHIFT", "rshift", hash_RSHIFT, it_lshift

        spulls
        
        srl tos, snd, tos
        
        j next

#---------------------------------------------------------------------
# ( -- ) execute a jump and link
def_word ";$", "docode", hash_DOCODE, it_rshift 

        # jump and link to there 

        jalr ra, 0 (ipt)
        
        # at there, save ra, do whatever, load ra,
        # end with  jalr s1, 0 (ra)
        # s1 is ipt :)

        j next

#---------------------------------------------------------------------
# ( -- ) ae abort
def_word "ABORT", "aborts", hash_ABORT, it_docode

        j abort

#---------------------------------------------------------------------
# ( -- ) exit forth
def_word "BYE", "byes", hash_BYE, it_aborts

        j _exit

#---------------------------------------------------------------------
# ( w -- ) #; load next token as a 32-bit hexadecimal value to TOS
def_word "$", "hex", hash_HEX, it_byes

        spusht

        call number

        mv tos, fst
        
        j next
        
#---------------------------------------------------------------------
# ( w -- ) #; display the 32-bit hexadecimal value at TOS
def_word ".", "dot", hash_DOT, it_hex

        mv fst, tos

        call tohex

        spullt

        j next
        
#---------------------------------------------------------------------

.equ last_next, it_dot

#---------------------------------------------------------------------
# code a 32-bit word in ASCII hexadecimal
# safe inside Forth words
# 
tohex:

        save_ra

        mv snd, fst
        
        li trd, 58

        li spc, 32

        # rolls 
100:
        beqz spc, 300f

        addi spc, spc, -4

        srl  fst, snd, spc
        andi fst, fst, 15
        ori  fst, fst, 48
        blt  fst, trd, 200f
        addi fst, fst, 7
200:
        call _putc
        
        j 100b

300:

        load_ra

        ret

#----------------------------------------------------------------------
# code a ASCII $0-9A-F hexadecimal to value
# safe inside Forth words
number:

        save_ra

        # clear result

        li trd, 0

        # load NaN

        lui snd, 0x80000

        # load word separator, BL is space      

        li spc, BL

        # skip spaces 
nskip:
        call _getc
        bleu fst, spc, nskip

ndigit:

        call digit

        beq fst, snd, nodigit

        slli trd, trd, 4

        add trd, trd, fst
        
        # scan spaces 
nscan:
        call _getc
        bltu fst, spc, nscan

        bne fst, spc, ndigit

isdigit:

        mv fst, trd 

nodigit:

        load_ra

        ret

# verify valid digit and convert it
digit:

100:
        #; valid digit, 0-9 and A-F  
        addi fst, fst, -48
        blt fst, zero, 400f

        #; 0-9 ?
        li hsh, 10
        blt fst, hsh, 200f

        #; normalize gap ascii 9 to A
        addi fst, fst, -7

        #; A to F ? No esoteric bases !
        li hsh, 16
        bgt fst, hsh, 400f

200:
        #; fst [ 0 .. 16 ]
        
        # lw hst, BASE (usr)
        # bgt fst, hst, 400f

        ret

400:
# is_error, NaN

        lui fst, 0x80000

        ret

#---------------------------------------------------------------------
#       
#       core primitives
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
#
# djb2 hash cleared of bit 31
#

.equ hash_MINUS, 0x0002B588     # - 

.equ hash_EQU, 0x0002B598       # = 
.equ hash_LESS, 0x0002B599      # < 
.equ hash_ULESS, 0x005973CC     # U< 
.equ hash_GTZERO, 0x0059680B    # 0>

.equ hash_CFETCH, 0x005972E6    # C@
.equ hash_CSTORE, 0x00597287    # C!

.equ hash_RAT, 0x00597497       # R@
.equ hash_TOR, 0x005968A9       # >R
.equ hash_RTO, 0x005974E9       # R>

.equ hash_AND, 0x0B87B72E 
.equ hash_OR, 0x00597378 
.equ hash_XOR, 0x0B883040 

.equ hash_INVERSE, 0x2D6AA2B5 
.equ hash_NEGATE, 0x26B37A79  

.equ hash_DUP, 0x0B87BC84 
.equ hash_DROP, 0x7C7F5C2C 
.equ hash_OVER, 0x7C84398B 
.equ hash_SWAP, 0x7C8A3910 
.equ hash_ROT, 0x0B8807CC 
.equ hash_NROT, 0x7C4E8CA1 

.equ hash_RPAT, 0x0B880527      # RP!
.equ hash_RPTO, 0x0B880546      # RP@
.equ hash_RPZO, 0x0B880557      # RP0

.equ hash_SPTO, 0x0B881187      # SP!
.equ hash_SPAT, 0x0B8811E6      # SP@
.equ hash_SPZO, 0x0B881196      # SP0

.equ hash_BRANCH, 0x1E6C4191 
.equ hash_ZBRANCH, 0x7D28616B
.equ hash_GBRANCH, 0x689E2DB6    

.equ hash_LIT, 0x0B87DB14 
.equ hash_ALIGN, 0x0C531CC8 

.equ hash_TRUE, 0x7C879BF3
.equ hash_FALSE, 0x0C3C6778

.equ hash_ONE, 0x00002B594      # 1
.equ hash_TWO, 0x00002B597      # 2
.equ hash_CELL, 0x07C81B0A3
.equ hash_NAN, 0x0B87D404       

.equ hash_STATE, 0x0DD1F032

.equ hash_LAST, 0x7C835F2F
.equ hash_HEAP, 0x7C857DF9

.equ hash_PEEK, 0x7C75C17E 
.equ hash_CEIL, 0x7C81B006 

.equ hash_HEAD, 0x7C857DED
.equ hash_TAIL, 0x7C87C175

.equ hash_PLUSTO, 0x0059676F    # +!

.equ hash_BYMUL, 0x005972C2     # M*
.equ hash_BYMOD, 0x7C4D1C6C     # /MOD

.equ hash_TWOMUL, 0x0059685D    # 2*
.equ hash_TWODIV, 0x00596858    # 2/

.equ hash_RSHIFT, 0x416E6B97
.equ hash_LSHIFT, 0x2C5784C9 

.equ hash_PERFORM, 0x15EEB854 #; 

#---------------------------------------------------------------------

.equ init_primitives, last_next

#---------------------------------------------------------------------
#

#---------------------------------------------------------------------
# ( w1 -- w2 ) #; align to cell, word is 4 bytes
def_word "ALIGN", "align", hash_ALIGN, init_primitives

        addi tos, tos, 3

        andi tos, tos, ~3

        j next

#---------------------------------------------------------------------
# ( w1 -- w2 ) #; INVERSE w
def_word "INVERSE", "nots", hash_INVERSE, it_align

        # xori tos, tos, -1
        not tos, tos

        j next

#---------------------------------------------------------------------
# ( w1 -- w2 ) #; NEGATE w, arithmetic inverse
def_word "NEGATE", "negs", hash_NEGATE, it_nots

        # sub tos, zero, tos
        neg tos, tos

        j next

#---------------------------------------------------------------------
# ( w -- w w ) #; duplicate tos
def_word "DUP", "dups", hash_DUP, it_negs

        spusht

        j next

#---------------------------------------------------------------------
# ( w -- ) #; drop tos
def_word "DROP", "drop", hash_DROP, it_dups

        spullt

        j next

#---------------------------------------------------------------------
# ( w1 w2 -- w1 w2 w1 ) #; over tos
def_word "OVER", "over", hash_OVER, it_drop

        lw tos, CELL (spt)

        j next

#---------------------------------------------------------------------
# ( w1 w2 -- w2 w1 ) #; over tos
def_word "SWAP", "swap", hash_SWAP, it_over

        lw snd, 0 (spt)

        sw tos, 0 (spt)

        mv tos, snd

        j next

#---------------------------------------------------------------------
# ( w1 w2 w3 -- w2 w3 w1 ) #; rot tos
def_word "ROT", "rot", hash_ROT, it_swap

        lw snd, 0 (spt)

        lw trd, CELL (spt)
        
        sw tos, CELL (spt)

        sw trd, 0 (spt)

        mv tos, snd

        j next

#---------------------------------------------------------------------
 # ( a -- w ), w = [a], one byte
 def_word "C@", "cfetch", hash_CFETCH, it_rot

        lb tos, 0 (tos)

        j next

 #---------------------------------------------------------------------
 # ( a w -- ),  [a] = w, one byte
 def_word "C!", "cstore", hash_CSTORE, it_cfetch

        spulls

        sb snd, 0 (tos)

        spullt

        j next

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 - w2
def_word "-", "minus", hash_MINUS, it_cstore

        spulls

        sub tos, snd, tos

        j next

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 AND w2
def_word "AND", "and", hash_AND, it_minus

        spulls

        and tos, snd, tos

        j next

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 OR w2 
def_word "OR", "or", hash_OR, it_and

        spulls

        or tos, snd, tos

        j next

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 OR w2 
def_word "XOR", "xor", hash_XOR, it_or

        spulls

        xor tos, snd, tos

        j next

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 = w2 
def_word "=", "equ", hash_EQU, it_xor

        spulls

        beq snd, tos, istrue

        j isfalse

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 < w2 
def_word "<", "less", hash_LESS, it_equ

        spulls

        blt snd, tos, istrue

        j isfalse

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 < w2 unsigned
def_word "U<", "uless", hash_ULESS, it_less     

        spulls

        bltu snd, tos, istrue

        j isfalse

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 < w2 greater than zero
def_word "0>", "gtzero", hash_GTZERO, it_uless     

        spulls

        bgt tos, zero, istrue

        j isfalse

#---------------------------------------------------------------------
# ( -- w ) #; the value is at second cell
def_word "R@", "rat", hash_RAT, it_gtzero

        spusht

        lw tos, CELL (rpt)

        j next

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; the value is at second cell
def_word "R>", "rto", hash_RTO, it_rat

        # save tos

        spusht

        # load return, 1st

        lw snd, 0 (rpt)

        # load value, 2nd

        lw tos, CELL (rpt)

        # update index

        addi rpt, rpt, CELL

        # save return, 1st 

        sw snd, 0 (rpt)

        j next

#---------------------------------------------------------------------
# ( w --  ; -- w ) #; the value is at second cell
def_word ">R", "tor", hash_TOR, it_rto

        # load return, 1st

        lw snd, 0 (rpt) 

        # save value

        sw tos, 0 (rpt) 

        # update index

        addi rpt, rpt, -1 * CELL
        
        # save return

        sw snd, 0 (rpt)

        # load tos

        spullt

        j next

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_word "RP@", "rpat", hash_RPAT, it_tor

        spusht

        mv tos, rpt

        j next

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_word "RP!", "rpto", hash_RPTO, it_rpat

        mv rpt, tos

        spullt

        j next

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_word "SP@", "spat", hash_SPAT, it_rpto

        spusht

        mv tos, spt

        j next

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_word "SP!", "spto", hash_SPTO, it_spat

        mv spt, tos

        spullt

        j next

#---------------------------------------------------------------------
# ( -- ; -- ) #; branch is relative, not absolute
def_word "BRANCH", "branch", hash_BRANCH, it_spto

branch:

        lw fst, 0 (ipt)
        
        # when absolute
        # mv ipt, fst

        # when relative
        add ipt, ipt, fst

        j next

#---------------------------------------------------------------------
# ( -- ; -- ) #; branch if zero
def_word "0BRANCH", "zbranch", hash_ZBRANCH, it_branch
        
        mv fst, tos
        
        spullt

        beq fst, zero, branch

        j next

#---------------------------------------------------------------------
# ( -- ; -- ) #; branch if greater than zero
def_word "GBRANCH", "gbranch", hash_GBRANCH, it_zbranch
        
        mv fst, tos

        spullt

        bgt fst, zero, branch

        j next

#---------------------------------------------------------------------
# ( -- w ) #; 
def_word "LIT", "lit", hash_LIT, it_gbranch

        spusht

        lw tos, 0 (ipt)

        addi ipt, ipt, CELL

        j next

#---------------------------------------------------------------------
# ( -- TRUE ) #; push 0xFFFFFFFF 
def_word "TRUE", "true", hash_TRUE, it_lit
        
        li fst, TRUE 

        j copyit

#---------------------------------------------------------------------
# ( -- FALSE ) #; push 0x00000000
def_word "FALSE", "false", hash_FALSE, it_true

        li fst, FALSE 

        j copyit

#---------------------------------------------------------------------
# ( -- 4 ) #; push 0x00000004
def_word "CELL", "cell", hash_CELL, it_false

        li fst, CELL

        j copyit

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; constant
def_word "RP0", "rpzo", hash_RPZO, it_cell

        la fst, _rp0

        j copyit

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; constant
def_word "SP0", "spzo", hash_SPZO, it_rpzo

        la fst, _sp0

        j copyit

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_word "STATE", "state", hash_STATE, it_spzo

        lw fst, STAT (usr)

        j copyit

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @ last in dictionary
def_word "LAST", "last", hash_LAST, it_state

        lw fst, LAST (usr)

        j copyit

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; next unused cell of memory
def_word "HEAP", "heap", hash_HEAP, it_last

        lw fst, HEAP (usr)

        j copyit

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; last HEAP before compiling
def_word "PEEK", "peek", hash_PEEK, it_heap

        lw fst, PEEK (usr)

        j copyit

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; last unused cell of memory
def_word "CEIL", "ceil", hash_CEIL, it_peek

        lw fst, CEIL (usr)

        j copyit

#---------------------------------------------------------------------
# ( w1 w2 -- w3 w4 ) double multiply, w1 * w2  
def_word "M*", "bymul", hash_BYMUL, it_ceil
        
        lw snd, 0 (spt)

        mulh fst, snd, tos
        mul snd, snd, tos

push2:
        sw snd, 0 (spt)
        
        mv tos, fst

	j next

#---------------------------------------------------------------------
# ( w1 w2 -- w3 w4 ) double divide, w1/w2
def_word "/MOD", "bymod", hash_BYMOD, it_bymul
        
	beqz tos, by_zero

        lw snd, 0 (spt)

        div fst, snd, tos
        rem snd, snd, tos

	j push2

#---------------------------------------------------------------------
# ( w -- ) #; @
def_word "PERFORM", "perform", hash_PERFORM, it_bymod

        mv fst, tos

        spullt

        # same note of ;$ 

        jalr ra, 0 (fst)

        j next
        
#---------------------------------------------------------------------

.set last_next, it_perform

#---------------------------------------------------------------------

