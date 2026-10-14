# Why Use Tos


## Snipts

# Using ip, sp, rp, tos, nos, pos as registers


#define sp s0

#define dp s1

#define ip a4

#define tos a5

#define nos a6

#define pos a7

# ---------------------------------------------------------

# word, label, hash
.macro def_native label hash 
it_\label:
    .align 2
    .word 999b - 8
    .word \hash
999:
is_\label:
.endm

.macro end_native
    j next
.endm

.macro push rg ps 
 	addi \ps, \ps, -1 * CELL
	sw \rg, 0 (sp)
.endm

.macro pull rg ps
	lw \rg, 0 (\ps)
 	addi \ps, \ps, 1 * CELL
.endm

# ---------------------------------------------------------

.equ hash_EXIT, 0x7C7CC745 #; ( EXIT ) 
.equ hash_BRANCH, 0x1E6C4191 #; ( BRANCH ) 
.equ hash_ZBRANCH, 0x7D28616B #; ( ZBRANCH ) 
.equ hash_TOR, 0x0B88004C #; ( TOR ) 
.equ hash_RTO, 0x0B8804AC #; ( RTO ) 
.equ hash_RAT, 0x0B880702 #; ( RAT ) 
.equ hash_RPAT, 0x7C88A9B2 #; ( RPAT ) 
.equ hash_SPAT, 0x7C8A4E93 #; ( SPAT ) 
.equ hash_RPTO, 0x7C88ABDC #; ( RPTO ) 
.equ hash_SPTO, 0x7C8A507D #; ( SPTO ) 
.equ hash_DROP, 0x7C7F5C2C #; ( DROP ) 
.equ hash_DUP, 0x0B87BC84 #; ( DUP ) 
.equ hash_OVER, 0x7C84398B #; ( OVER ) 
.equ hash_SWAP, 0x7C8A3910 #; ( SWAP ) 
.equ hash_FETCH, 0x0C3E96F9 #; ( FETCH ) 
.equ hash_STORE, 0x0DD22B7A #; ( STORE ) 
.equ hash_CFETCH, 0x2376B3FA #; ( CFETCH ) 
.equ hash_CSTORE, 0x252B26F9 #; ( CSTORE ) 
.equ hash_PLUS, 0x7C8A057F #; ( PLUS ) 
.equ hash_AND, 0x0B87B72E #; ( AND ) 
.equ hash_ORR, 0x0B87E22A #; ( ORR ) 
.equ hash_XOR, 0x0B883040 #; ( XOR ) 
.equ hash_NAN, 0x0B87D404 #; ( NAN ) 
.equ hash_ZEQ, 0x0B88288B #; ( ZEQ ) 


# ---------------------------------------------------------

999:
    .word 0x0

def_native "EXIT" hash_EXIT 
# keep ip
unnest:
	pull ip rp
next:
	pull nos, ip
pick:
	bge nos, LIMIT, nest
jump:
	jarl ra, 0 (nos)
	j next
nest:
	push ip rp 
move:
	mv ip, nos
	j next

def_native "BRANCH" hash_BRANCH 
branch:
	lw pos, 0 (ip)
	add ip, ip, pos
end_native

def_native "ZBRANCH" hash_ZBRANCH 
	mv pos, tos
	pull tos sp
	beqz pos, branch
	add ip, ip, CELL
end_native

def_native "TOR" hash_TOR 
	push tos rp 
	pull tos sp
end_native

def_native "RTO" hash_RTO 
	push tos sp
	pull ros rp
end_native

def_native "RAT" hash_RAT 
	push tos
	lw tos, 0 (rp)
end_native

def_native "RPAT" hash_RPAT 
	push tos sp
	mv tos, rp
end_native

def_native "SPAT" hash_SPAT 
	push tos sp
	mv tos, sp
end_native

def_native "RPTO" hash_RPTO 
	mv rp, tos
	pull tos sp
end_native

def_native "SPTO" hash_SPTO 
	mv sp, tos
	pull tos sp
end_native

def_native "DROP" hash_DROP 
	pull tos sp
end_native

def_native "DUP" hash_DUP 
	push tos sp
end_native

def_native "OVER" hash_OVER 
	push tos sp
	lw tos, CELL (sp)
end_native

def_native "SWAP" hash_SWAP 
	lw nos, 0 (sp)
	sw tos, 0 (sp)
	mv tos, nos
end_native

def_native "FETCH" hash_FETCH 
	lw tos, 0 (tos)
end_native

def_native "STORE" hash_STORE 
	pull nos sp
	sw nos, 0 (tos)
	pull tos sp
end_native

def_native "CFETCH" hash_CFETCH 
	lb tos, 0 (tos)
end_native

def_native "CSTORE" hash_CSTORE 
	pull nos sp
	sb nos, 0 (tos)
	pull tos sp
end_native

def_native "PLUS" hash_PLUS 
	pull nos sp
	add tos, tos, nos
end_native

def_native "AND" hash_AND 
	pull nos sp
	and tos, tos, nos
end_native

def_native "ORR" hash_ORR 
	pull nos sp
	orr tos, tos, nos
end_native

def_native "XOR" hash_XOR 
	pull nos sp
	eor tos, tos, nos
end_native

def_native "NAN" hash_NAN 
	push tos sp
	lu tos, #0x8000000
end_native

def_native "ZEQ" hash_ZEQ 
	beqz tos, isfalse
istrue:
	addi tos, zero, -1
	j isit	
isfalse:
	addi tos, zero, zero	
isit:
end_native

