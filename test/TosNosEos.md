# Why Use Tos

## Snipts

# Using ip, sp, rp, tos, nos, pos as registers

#define sp s0

#define rp s1

#define nib s2

#define ip a4

#define tos a5

#define nos a6

#define pos a7

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

.equ hash_GTZERO, 0x0059680B #; ( 0> )

.equ hash_TRUE, 0x7C879BF3 #; ( TRUE )
.equ hash_FALSE, 0x0C3C6778 #; ( FALSE )
.equ hash_NAN, 0x0B87D404 #; ( NAN )
.equ hash_CELL, 0x7C81B0A3 #; ( CELL )

### 

# ---------------------------------------------------------
# A fake header as end of dictionary
	.word FALSE
	.word TRUE
9999:

# ---------------------------------------------------------

# ( -- ) #; 
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

# ( -- ) #; 
def_native "branch" hash_BRANCH 
branch:
	lw pos, 0 (ip)
	add ip, ip, pos
end_native

# ( -- ) #; 
def_native "zbranch" hash_ZBRANCH 
	mv pos, tos
	pull tos sp
	beqz pos, branch
	addi ip, ip, CELL
end_native

# ( -- ) #; 
def_native "tor" hash_TOR 
	push tos rp 
	pull tos sp
end_native

# ( -- ) #; 
def_native "rto" hash_RTO 
	push tos sp
	pull tos rp
end_native

# ( -- ) #; 
def_native "rat" hash_RAT 
	push tos sp
	lw tos, 0 (rp)
end_native

# ( -- ) #; 
def_native "rpat" hash_RPAT 
	push tos sp
	mv tos, rp
end_native

# ( -- ) #; 
def_native "spat" hash_SPAT 
	push tos sp
	mv tos, sp
end_native

# ( -- ) #; 
def_native "rpto" hash_RPTO 
	mv rp, tos
	pull tos sp
end_native

# ( -- ) #; 
def_native "spto" hash_SPTO 
	mv sp, tos
	pull tos sp
end_native

# ( -- ) #; 
def_native "drop" hash_DROP 
	pull tos sp
end_native

# ( -- ) #; 
def_native "dup" hash_DUP 
	push tos sp
end_native

# ( -- ) #; 
def_native "over" hash_OVER 
	push tos sp
	lw tos, CELL (sp)
end_native

# ( -- ) #; 
def_native "swap" hash_SWAP 
	lw nos, 0 (sp)
	sw tos, 0 (sp)
	mv tos, nos
end_native

# ( -- ) #; 
def_native "fetch" hash_FETCH 
	lw tos, 0 (tos)
end_native

# ( -- ) #; 
def_native "store" hash_STORE 
	pull nos sp
	sw nos, 0 (tos)
	pull tos sp
end_native

# ( -- ) #; 
def_native "cfetch" hash_CFETCH 
	lb tos, 0 (tos)
end_native

# ( -- ) #; 
def_native "cstore" hash_CSTORE 
	pull nos sp
	sb nos, 0 (tos)
	pull tos sp
end_native

# ( -- ) #; 
def_native "plus" hash_PLUS 
	pull nos sp
	add tos, tos, nos
end_native

# ( -- ) #; 
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

# ( -- ) #; 
def_native "and" hash_AND 
	pull nos sp
	and tos, tos, nos
end_native

# ( -- ) #; 
def_native "or" hash_ORR 
	pull nos sp
	or tos, tos, nos
end_native

# ( -- ) #; 
def_native "xor" hash_XOR 
	pull nos sp
	xor tos, tos, nos
end_native

# ( -- ) #; 
def_native "cell" hash_CELL
	push tos sp
	lui tos, 0x4
end_native

# ( -- ) #; 
def_native "nan" hash_NAN 
by_error:
by_zero:
	push tos sp
	lui tos, 0x8000
end_native

# ( -- ) #; 
def_native "true" hash_TRUE
	push tos sp
istrue:
	addi tos, zero, TRUE
end_native

# ( -- ) #; 
def_native "false" hash_TRUE
	push tos sp
isfalse:
	addi tos, zero, FALSE	
end_native

# ( -- ) #; 
def_native "equ" hash_EQU
    pull nos sp
	bne tos, nos, isfalse
	j istrue
end_native

# ( -- ) #; 
def_native "less" hash_LESS 
    pull nos sp
	blt nos, tos, istrue
	j isfalse
end_native

# ( -- ) #; 
def_native "uless" hash_ULESS
    pull nos sp
	bltu nos, tos, istrue
	j isfalse
end_native

