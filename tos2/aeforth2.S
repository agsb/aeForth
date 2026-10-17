# Why Use Tos

## Snipts

# Using ip, sp, rp, tos, dedicated registers
# nos, trd, fth as generic registers
#
# s0, s1, a0, a2, a3, a7 used in ecalls
#
# s0, s1, a0, a2, a3, a4, a5 used in 16 bits opcodes
#

# parameter stack pointer
#define sp s0

# return stack pointer
#define rp s1

# forth instruction pointer
#define ip a4

# second at stack
#define nos a5

# top of stack 
#define tos a3

#define ran s2

#define pos a7

#define usr s3

#define nib s4 

#---------------------------------------------------------------------
# generics alias

#---------------------------------------------------------------------
# max size of dictionary 64k CELLS, depends on host machine

.equ RAM_LIMIT, 0x40000

# as FORTH 1983

.equ FALSE, 0

.equ TRUE, -1

# states

.equ EXECUTE, 0

.equ COMPILE, 1

# usefull

.equ CELL, 4    # sizeof a CELL

.equ BL,  32    # word delimiter is blank space

# highlander, immediate flag, unique NaN

# -2147483648
.equ FLAG_IMM, 0x80000000

# +2147483647
.equ MASK_IMM, 0x7FFFFFFF

# user parameter stack: sp rp heap last state base

# data stack index
.equ SPTR, 0 * CELL

# return stack index
.equ RPTR, 1 * CELL

# last link cell in heap dictionary linked list
.equ LAST, 2 * CELL

# next free cell in heap dictionary, aka dp
.equ HEAP, 3 * CELL

# last heap
.equ PIKE, 4 * CELL

# state flag
.equ STAT, 5 * CELL

# base radix for numbers, for future use
.equ BASE, 6 * CELL

# temporary scratch as array of CELLS
.equ TEMP, 7 * CELL

# allow some cells for extra

.equ params, 16

# ---------------------------------------------------------

.align 2

# word, label, hash
# ( -- ) #; 
.macro def_native label hash 
it_\label:
    .word 9999b - 8
    .word \hash
9999:
is_\label:
.endm

.macro end_native
    j next
.endm

.macro push rg ps 
 	addi \ps, \ps, -1 * CELL
	sw \rg, 0 (\ps)
.endm

.macro pull rg ps
	lw \rg, 0 (\ps)
 	addi \ps, \ps, 1 * CELL
.endm

# ---------------------------------------------------------

.equ FALSE, 0x00000000
.equ TRUE,  0xFFFFFFFF
.equ NAN,   0x80000000
.equ CELL, 4

# ---------------------------------------------------------

# DJB2 hash for UPPERCASE Forth words inside ( )

.equ hash_EXIT, 0x7C7CC745 #; ( EXIT ) 
.equ hash_BRANCH, 0x1E6C4191 #; ( BRANCH ) 
.equ hash_ZBRANCH, 0x7D28616B #; ( ZBRANCH ) 
.equ hash_GBRANCH, 0x689E2DB6 #; ( GBRANCH )
.equ hash_LIT, 0x0B87DB14 #; ( LIT )

.equ hash_TOR, 0x0B88004C #; ( >R ) 
.equ hash_RTO, 0x0B8804AC #; ( R> ) 
.equ hash_RAT, 0x0B880702 #; ( R@ ) 

.equ hash_RPAT, 0x7C88A9B2 #; ( RP@ ) 
.equ hash_SPAT, 0x7C8A4E93 #; ( SP@ ) 
.equ hash_RPTO, 0x7C88ABDC #; ( RP! ) 
.equ hash_SPTO, 0x7C8A507D #; ( SP! ) 

.equ hash_DROP, 0x7C7F5C2C #; ( DROP ) 
.equ hash_DUP, 0x0B87BC84 #; ( DUP ) 
.equ hash_OVER, 0x7C84398B #; ( OVER ) 
.equ hash_SWAP, 0x7C8A3910 #; ( SWAP ) 
.equ hash_ROT, 0x0B8807CC #; ( ROT )

.equ hash_FETCH, 0x0C3E96F9 #; ( @ ) 
.equ hash_STORE, 0x0DD22B7A #; ( ! ) 
.equ hash_CFETCH, 0x2376B3FA #; ( C@ ) 
.equ hash_CSTORE, 0x252B26F9 #; ( C! ) 

.equ hash_PLUS, 0x7C8A057F #; ( + ) 
.equ hash_MINUS, 0x0002B588 #; ( - )
.equ hash_BYMUL, 0x005972C2 #; ( M* )
.equ hash_BYMOD, 0x7C4D1C6C #; ( /MOD )

.equ hash_AND, 0x0B87B72E #; ( AND ) 
.equ hash_ORR, 0x0B87E22A #; ( OR ) 
.equ hash_XOR, 0x0B883040 #; ( XOR ) 

.equ hash_EQU, 0x0002B598  #; ( = )
.equ hash_LESS, 0x0002B599 #; ( < ) 
.equ hash_ULESS, 0x005973CC #; (U< ) 
.equ hash_GREATHER, 0x2D802BBF #; ( GREATHER )

.equ hash_GTZERO, 0x0059680B #; ( 0> )

.equ hash_TRUE, 0x7C879BF3 #; ( TRUE )
.equ hash_FALSE, 0x0C3C6778 #; ( FALSE )
.equ hash_NAN, 0x0B87D404 #; ( NAN )
.equ hash_CELL, 0x7C81B0A3 #; ( CELL )

.equ hash_LSHIFT, 0x2C5784C9 #; ( LSHIFT )
.equ hash_RSHIFT, 0x416E6B97 #; ( RSHIFT )

.equ hash_RPZ, 0x0B88053D #; ( RPZ )
.equ hash_SPZ, 0x0B8811FC #; ( SPZ )

.equ hash_STATE, 0x0DD1F032 #; ( STATE )
.equ hash_LATEST, 0x2ADAAFBE #; ( LATEST )
.equ hash_HEAP, 0x7C857DF9 #; ( HEAP )
.equ hash_PIKE, 0x7C8A12B2 #; ( PIKE )

.equ hash_ALIGN, 0x0C531CC8 #; ( ALIGN )
.equ hash_INVERSE, 0x2D6AA2B5 #; ( INVERSE )
.equ hash_NEGATE, 0x26B37A79 #; ( NEGATE )
.equ hash_EXECUTE, 0x69224E1A #; ( EXECUTE )
.equ hash_PERFORM, 0x15EEB854 #; ( PERFORM )

# ---------------------------------------------------------
# A fake header as end of dictionary
	.word FALSE
	.word TRUE
9999:

# ---------------------------------------------------------

# ( -- ) #; ( EXIT ) 
def_native "exit" hash_EXIT 
# keep ip
unnest:
	pull ip rp
next:
	pull nos ip
pick:
	bge nos, nib, nest
jump:
	jalr ra, 0 (nos)
	j next
nest:
	push ip rp 
move:
	mv ip, nos
	j next

# ( -- ) #; ( BRANCH )
def_native "branch" hash_BRANCH 
branch:
	lw pos, 0 (ip)
	add ip, ip, pos
end_native

# ( w -- ) #; ( ZBRANCH )
def_native "zbranch" hash_ZBRANCH 
	mv pos, tos
	pull tos sp
	beqz pos, branch
	addi ip, ip, CELL
end_native

# ( w -- ) #; ( GBRANCH )
def_native "gbranch" hash_GBRANCH 
	mv pos, tos
	pull tos sp
	blt zero, pos, branch
	addi ip, ip, CELL
end_native

# ( -- w ) #; ( LIT )
def_native "lit" hash_LIT 
	push tos sp
	lw tos, 0 (ip)
	addi ip, ip, CELL
end_native

# ( w -- ; -- w ) #; ( >R )
def_native "tor" hash_TOR 
	push tos rp 
	pull tos sp
end_native

# ( -- w ; w -- ) #; ( R> )
def_native "rto" hash_RTO 
	push tos sp
	pull tos rp
end_native

# ( -- w ; w -- w ) #; ( R@ )
def_native "rat" hash_RAT 
	push tos sp
	lw tos, 0 (rp)
end_native

# ( -- rp ) #; ( RP@ )
def_native "rpat" hash_RPAT 
	push tos sp
	mv tos, rp
end_native

# ( -- sp ) #; ( SP@ )
def_native "spat" hash_SPAT 
	push tos sp
	mv tos, sp
end_native

# ( rp -- ) #; ( RP! )
def_native "rpto" hash_RPTO 
	mv rp, tos
	pull tos sp
end_native

# ( sp -- ) #; ( SP! )
def_native "spto" hash_SPTO 
	mv sp, tos
	pull tos sp
end_native

# ( w -- ) #; ( DROP )
def_native "drop" hash_DROP 
	pull tos sp
end_native

# ( w -- w w ) #; ( DUP )
def_native "dup" hash_DUP 
	push tos sp
end_native

# ( w1 w2 -- w1 w2 w1 ) #; ( OVER )
def_native "over" hash_OVER 
	push tos sp
	lw tos, CELL (sp)
end_native

# ( w1 w2  -- w2 w1 ) #; ( SWAP )
def_native "swap" hash_SWAP 
	lw nos, 0 (sp)
	sw tos, 0 (sp)
	mv tos, nos
end_native

# ( w1 w2 W3 -- w3 w1 w2 ) #; ( ROT )
def_native "rot" hash_ROT 
	lw nos, 0 (sp)
	lw pos, 4 (sp)
	sw pos, 0 (sp)
	sw tos, 4 (sp)
	mv tos, nos
end_native

# ( a -- w ) #; ( @ )
def_native "fetch" hash_FETCH 
	lw tos, 0 (tos)
end_native

# ( w a -- ) #; ( ! )
def_native "store" hash_STORE 
	pull nos sp
	sw nos, 0 (tos)
	pull tos sp
end_native

# ( a -- c ) #; ( C@ ) 
def_native "cfetch" hash_CFETCH 
	lb tos, 0 (tos)
end_native

# ( c a -- ) #; ( C! )
def_native "cstore" hash_CSTORE 
	pull nos sp
	sb nos, 0 (tos)
	pull tos sp
end_native

# ( w1 w2 -- w3 ) #; ( + ) 
def_native "plus" hash_PLUS 
	pull nos sp
	add tos, tos, nos
end_native

# ( w1 w2 -- w3 ) #; ( - )
def_native "minus" hash_MINUS 
	pull nos sp
	add tos, tos, nos
end_native

# ( w1 w2 -- w3 w4 ) double multiply
def_native "bymul", hash_BYMUL
    pull nos sp
    mulh pos, tos, nos
    mul nos, tos, nos
push2:
    push nos sp
    mv tos, pos
end_native

# ( w1 w2 -- w3 w4 ) divide
def_native "bymod", hash_BYMOD
    pull nos sp
    beqz nos, by_zero
    div pos, tos, nos
    rem nos, tos, nos
    j push2

# ( w1 w2 -- w3 ) #; ( AND )
def_native "and" hash_AND 
	pull nos sp
	and tos, tos, nos
end_native

# ( w1 w2 -- w3 ) #; ( OR )
def_native "or" hash_ORR 
	pull nos sp
	or tos, tos, nos
end_native

# ( w1 w2 -- w3 ) #; ( XOR ) 
def_native "xor" hash_XOR 
	pull nos sp
	xor tos, tos, nos
end_native

# ( w1 w2 -- w1<<w2 ) #; ( LSHIFT ) shift left some bits
def_native "lshift", hash_LSHIFT
         pull nos sp
         sll tos, nos, tos
end_native

# ( w1 w2 -- w1>>w2 ) #; ( RSHIFT ) shift right some bits
def_native "rshift", hash_RSHIFT
         pull nos sp
         srl tos, nos, tos
end_native

# ( -- 0xFFFFFFFF ) #; ( TRUE ) 
def_native "true" hash_TRUE
	push tos sp
istrue:
	addi tos, zero, TRUE
end_native

# ( -- 0x00000000 ) #; ( FALSE ) 
def_native "false" hash_TRUE
	push tos sp
isfalse:
	addi tos, zero, FALSE	
end_native

# ( w1 w2 -- T|F ) #; ( = ) 
def_native "equ" hash_EQU
    	pull nos sp
	beq tos, nos, istrue
	j isfalse
end_native

# ( w1 w2 -- T|F ) #; ( < )
def_native "less" hash_LESS 
    pull nos sp
	blt nos, tos, istrue
	j isfalse
end_native

# ( u1 u2 -- T|F ) #; ( U< ) 
def_native "uless" hash_ULESS
    	pull nos sp
	bltu nos, tos, istrue
	j isfalse
end_native

# ( u1 u2 -- T|F ) #; ( 0> ) 
def_native "greather" hash_GREATHER
    	pull nos sp
	blt tos, nos, istrue
	j isfalse
end_native

# ( -- 0x80000000 ) #; ( NAN )
def_native "nan" hash_NAN 
by_erro:
by_zero:
by_under:
by_over:
	push tos sp
	lui tos, 0x8000
end_native

# ( w1 -- w2 ) #; ( ALIGN ) align to cell, word is 4 bytes
def_native "align", hash_ALIGN
        addi tos, tos,  (CELL-1)
        andi tos, tos, ~(CELL-1)
end_native

# ( w1 -- w2 ) #; ( INVERSE) 
def_native "nots", hash_INVERSE
        # xori fst, fst, -1
        not tos, tos
end_native

# ( w1 -- w2 ) #; ( NEGATE ), arithmetic inverse
def_native "negs", hash_NEGATE
        # sub fst, zero, fst
        neg tos, tos
end_native

# ( w1 -- ; -- w2 ) #; ( EXECUTE ), 
def_native "execute", hash_EXECUTE
        # sub fst, zero, fst
        push tos rp
	pull tos sp 
end_native

# ( w -- ) #; @
def_native "perform", hash_PERFORM
	mv nos, tos
	pull tos sp
        jalr ra, 0 (nos)
end_native

#---------------------------------------------------------------------

# ( -- 4) #; ( CELL ) 
def_native "cell" hash_CELL
	push tos sp
	lui tos, 0x4
end_native

# ( -- rp0 ) #; ( RPZ ) 
def_native "rp0" hash_RPZ
	push tos sp
	lw tos, RPTR ( usr )
end_native

# ( -- sp0 ) #; ( SPZ ) 
def_native "sp0" hash_SPZ
	push tos sp
	lw tos, SPTR ( usr )
end_native

# ( -- state ) #; ( STATE ) 
def_native "state" hash_STATE
	push tos sp
	lw tos, STAT ( usr )
end_native

# ( -- last ) #; ( LATEST ) 
def_native "latest" hash_LATEST
	push tos sp
	lw tos, LAST ( usr )
end_native

# ( -- heap ) #; ( DP ) 
def_native "heap" hash_HEAP
	push tos sp
	lw tos, HEAP ( usr )
end_native

# ( -- pike ) #; ( PIKE ) 
def_native "pike" hash_PIKE
	push tos sp
	lw tos, PIKE ( usr )
end_native

#---------------------------------------------------------------------
 
