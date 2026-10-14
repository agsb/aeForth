# Why Use Tos


## Snipts

Using ip, sp, rp, tos, nos, pos as registers

.macro def_native name, label, hash, last
it_\label:
	.align 2
        .word \last
        .word \hash
is_\label:
.endm

.macro push rg ps 
 	addi \ps, \ps, -1 * CELL
	sw \rg, 0 (sp)
.endm

.macro pull rg ps
	lw \rg, 0 (\ps)
 	addi \ps, \ps, 1 * CELL
.endm


def_native EXIT
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
endword

def_native BRANCH
branch:
	lw pos, 0 (ip)
	add ip, ip, pos
endword

def_native ZBRANCH
	mv pos, tos
	pull tos sp
	beqz pos, branch
	add ip, ip, CELL
endword

def_native TOR
	push tos rp 
	pull tos sp
endword

def_native RTO
	push tos sp
	pull ros rp
endword

def_native RAT
	push tos
	lw tos, 0 (rp)
endword

def_native RPAT
	push tos sp
	mv tos, rp
endword

def_native SPAT
	push tos sp
	mv tos, sp
endword

def_native RPTO
	mv rp, tos
	pull tos sp
endword

def_native SPTO
	mv sp, tos
	pull tos sp
endword

def_native DROP
	pull tos sp
endword

def_native DUP
	push tos sp
endword

def_native OVER
	push tos sp
	lw tos, CELL (sp)
endword

def_native SWAP
	lw nos, 0 (sp)
	sw tos, 0 (sp)
	mv tos, nos
endword

def_native FETCH
	lw tos, 0 (tos)
endword

def_native STORE
	pull nos sp
	sw nos, 0 (tos)
	pull tos sp
endword

def_native CFETCH
	lb tos, 0 (tos)
endword

def_native CSTORE
	pull nos sp
	sb nos, 0 (tos)
	pull tos sp
endword

def_native PLUS
	pull nos sp
	add tos, tos, nos
endword

def_native AND
	pull nos sp
	and tos, tos, nos
endword

def_native ORR
	pull nos sp
	orr tos, tos, nos
endword

def_native XOR
	pull nos sp
	eor tos, tos, nos
endword

def_native NAN
	push tos sp
	lu tos, #0x8000000
endword

def_native ZEQ
	beqz tos, isfalse
istrue:
	addi tos, zero, -1
	j isit	
isfalse:
	addi tos, zero, zero	
isit:
endword

