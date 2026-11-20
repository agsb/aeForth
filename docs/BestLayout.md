
## Ask GEMINI
@GEMINI, 19/11/2026

Riscv compact instructions uses s0,s1,a0-a5 registers. Linux ecall uses a0,a1,a2,a7 sometimes a3, a4, a5 never a6. Need keep 4 registers. Consider pull and push operation costs 2 cycles, any compact operations cost 2 bytes and other operations 4 bytes. Need use a virtual stack for data, a virtual stack for return, and 4 registers for scrath. 
what the best register allocation to minimize cycle and size ?
do not use sp (x2) and do top-of-stack caching

__results are edited__

## Top-of-Stack (TOS)

With Top-of-Stack (TOS) caching enabled (and sp excluded), dedicate a0 as your permanent Data TOS register, keep a1–a3 as your 3 remaining scratch registers, use a4 and a5 for your two stack pointers, and place your 4 kept registers in s0, s1, s2, s3 (or s0, s1, a6, s2).

### Updated Register Map with TOS Caching

Role Register(s). Why This Maximizes Cycles & Size.

Data Top-of-Stack (TOS)	a0.  Sits in the RVC window for 2-byte ALU/branch ops and is already in the first argument/return slot (a0) for Linux ecalls.

The 3 Scratch Registers	a1, a2, a3.	Full 2-byte RVC support (c.add, c.sub, c.lw, c.sw, c.beqz) and zero moves needed for ecall arguments 2–4.

Data Stack Pointer (NOS+) a4. Points to the Next-on-Stack (NOS) in memory; uses 2-byte c.lw/c.sw + c.addi.

Return Stack Pointer a5. Uses 2-byte c.lw/c.sw + c.addi. Only conflicts with rare 6-argument syscalls.

Kept Registers	s0, s1, s2, s3. The s0–s1 get 2-byte RVC ops and all 4 are untouched by Linux ecalls.

### Cycle & Byte Savings on Common VM Operations (RV32C)

Because a0 holds the top value in a register and a4 points directly to the second item in memory (NOS), most stack operations drop memory traffic by 50% to 100%:

| VM Operation	| Without TOS Cache	| With TOS Cache (a0 = TOS, a4 = NOS)	| Savings |
| -- | -- | -- | -- |
| ADD (pop 2, push sum)	| c.lw a0, 0(a4)
c.lw a1, 4(a4)
c.addi a4, 4
c.add a0, a1
c.sw a0, 0(a4)
(10 bytes, 5 cycles)	
c.lw a1, 0(a4)
c.addi a4, 4
c.add a0, a1


(6 bytes, 3 cycles)	-4 bytes
-2 cycles
DUP (duplicate top)	c.lw a0, 0(a4)
c.addi a4, -4
c.sw a0, 0(a4)
(6 bytes, 3 cycles)	c.addi a4, -4
c.sw a0, 0(a4)

(4 bytes, 2 cycles)	-2 bytes
-1 cycle
DROP (discard top)	c.addi a4, 4

(2 bytes, 1 cycle)	c.lw a0, 0(a4)
c.addi a4, 4
(4 bytes, 2 cycles)	+2 bytes
+1 cycle
1+ / NEGATE / INVERT	c.lw + op + c.sw
(6 bytes, 3 cycles)	c.addi a0, 1 (single op)
(2 bytes, 1 cycle)	-4 bytes
-2 cycles
0= / Conditional Branch	c.lw a0, 0(a4)
c.addi a4, 4
c.beqz a0, target
(6 bytes, 3 cycles)	c.beqz a0, target
(followed by DROP)

(2 bytes for test, 1 cycle)	-4 bytes
-2 cycles
>R (Data to Return Stack)	c.lw a0, 0(a4)
c.addi a4, 4
c.addi a5, -4
c.sw a0, 0(a5)
(8 bytes, 4 cycles)	c.addi a5, -4
c.sw a0, 0(a5)
c.lw a0, 0(a4)
c.addi a4, 4
(8 bytes, 4 cycles)	Equal cost

### Practical Tips for Your VM

• Zero-cost ecall return values: Since Linux ecall overwrites a0 with its return code/result, any syscall wrapper in your VM naturally replaces TOS (a0) with the syscall result without needing a c.mv instruction.

• Keep Return Stack un-cached: Return stack traffic is mostly balanced >R / R> pairs and call/return addresses. Caching Return TOS would steal a1 from your scratch pool and force register spills on 2-argument Linux ecalls (a0, a1).

• 3 scratch registers (a1–a3) are plenty: With a0 holding the primary operand in place, binary operations only need a1 to load NOS, leaving a2 and a3 completely free for address math, loop counters, or multi-step primitives (SWAP, OVER, ROT).

If you'd like, I can write out the compact RV32C/RV64C instruction sequences for trickier stack primitives like SWAP, OVER, and ROT under this register layout.

## Stack Manipulation

### DUP ( n -- n n ) [4B, 2 cycles]
DUP:
    c.addi  a4, -4
    c.sw    a0, 0(a4)

### DROP ( n -- ) [4B, 2 cycles]
DROP:
    c.lw    a0, 0(a4)
    c.addi  a4, 4

### SWAP ( n1 n2 -- n2 n1 ) [6B, 3 cycles]
SWAP:
    c.lw    a1, 0(a4)       # a1 = n1 (NOS)
    c.sw    a0, 0(a4)       # NOS = n2 (old TOS)
    c.mv    a0, a1          # TOS = n1

### OVER ( n1 n2 -- n1 n2 n1 ) [8B, 4 cycles]
OVER:
    c.lw    a1, 0(a4)       # a1 = n1 (NOS)
    c.addi  a4, -4
    c.sw    a0, 0(a4)       # push n2
    c.mv    a0, a1          # TOS = n1

### ROT ( n1 n2 n3 -- n2 n3 n1 ) [10B, 5 cycles]
ROT:
    c.lw    a1, 0(a4)       # a1 = n2
    c.lw    a2, 4(a4)       # a2 = n1
    c.sw    a1, 4(a4)       # stack[1] = n2
    c.sw    a0, 0(a4)       # stack[0] = n3
    c.mv    a0, a2          # TOS = n1

## Bitwise & Unary Logic

### AND ( n1 n2 -- n1&n2 ) [6B, 3 cycles]
AND:
    c.lw    a1, 0(a4)
    c.addi  a4, 4
    c.and   a0, a1

### OR ( n1 n2 -- n1|n2 ) [6B, 3 cycles]
OR:
    c.lw    a1, 0(a4)
    c.addi  a4, 4
    c.or    a0, a1

### XOR ( n1 n2 -- n1^n2 ) [6B, 3 cycles]
XOR:
    c.lw    a1, 0(a4)
    c.addi  a4, 4
    c.xor   a0, a1

### NEGATE ( n -- -n ) [4B, 1 cycle]
NEGATE:
    neg     a0, a0          # pseudo-op: sub a0, x0, a0 (no 2B c.neg in RV32C)

### INVERSE / INVERT ( n -- ~n ) [4B, 1 cycle]
INVERSE:
    not     a0, a0          # pseudo-op: xori a0, a0, -1 (no 2B c.not in RV32C)

## Arithmetic (RV32IM)

### + ( n1 n2 -- n1+n2 ) [6B, 3 cycles]
ADD:
    c.lw    a1, 0(a4)
    c.addi  a4, 4
    c.add   a0, a1

### - ( n1 n2 -- n1-n2 ) [8B, 4 cycles]
SUB:
    c.lw    a1, 0(a4)       # a1 = n1 (NOS)
    c.addi  a4, 4
    c.sub   a1, a0          # a1 = n1 - n2 (c.sub modifies 1st operand)
    c.mv    a0, a1          # TOS = result

### M* ( n1 n2 -- d_lo d_hi ) Signed 32x32 -> 64-bit product [12B, 4 cycles]
M_STAR:
    c.lw    a1, 0(a4)       # a1 = n1
    mul     a2, a1, a0      # a2 = low 32 bits (4B)
    mulh    a0, a1, a0      # a0 = high 32 bits -> TOS (4B)
    c.sw    a2, 0(a4)       # NOS = low 32 bits (2B)

### /MOD ( n1 n2 -- rem quot ) Signed symmetric division [14B, 5 cycles]
SLASH_MOD:
    c.lw    a1, 0(a4)       # a1 = n1 (dividend)
    rem     a2, a1, a0      # a2 = remainder (4B)
    div     a0, a1, a0      # a0 = quotient -> TOS (4B)
    c.sw    a2, 0(a4)       # NOS = remainder (2B)

## Return Stack & Memory Access

### >R ( n -- ) ( R: -- n ) [8B, 4 cycles]
TO_R:
    c.addi  a5, -4
    c.sw    a0, 0(a5)       # push TOS to return stack
    c.lw    a0, 0(a4)       # pop new TOS from data stack
    c.addi  a4, 4

### R> ( -- n ) ( R: n -- ) [8B, 4 cycles]
R_FROM:
    c.addi  a4, -4
    c.sw    a0, 0(a4)       # push old TOS to data stack
    c.lw    a0, 0(a5)       # pop return stack into TOS
    c.addi  a5, 4

### R@ ( -- n ) ( R: n -- n ) [6B, 3 cycles]
R_FETCH:
    c.addi  a4, -4
    c.sw    a0, 0(a4)       # push old TOS to data stack
    c.lw    a0, 0(a5)       # copy top of return stack into TOS

### @ ( addr -- val ) [2B, 1 cycle]
FETCH:
    c.lw    a0, 0(a0)       # load word at address in TOS directly into TOS

### ! ( val addr -- ) [10B, 5 cycles]
STORE:
    c.lw    a1, 0(a4)       # a1 = val (NOS)
    c.sw    a1, 0(a0)       # *addr = val
    c.lw    a0, 4(a4)       # load next item into TOS
    c.addi  a4, 8           # drop both addr and val


## Key Optimization Details

• @ (Fetch) is just 1 instruction (2 bytes): Because a0 is both the source address and the destination register, c.lw a0, 0(a0) overwrites TOS directly with zero stack pointer changes.

• M* and /MOD do not adjust a4: Both take 2 inputs (n1, n2) and produce 2 outputs (lo/hi or rem/quot), so the stack depth stays unchanged—overwriting 0(a4) in place saves 2 c.addi instructions.

• Subroutine Threading Tip: If you emit these inline (subroutine-threaded / native code compiler) rather than jumping to them via indirect threading (NEXT), NEGATE, INVERSE, and @ require zero call/return overhead.

NEXT:
    c.lw    a1, 0(s0)       # fetch code address at IP (2B)
    c.addi  s0, 4           # advance IP by 4 bytes (2B)
    c.jr    a1              # jump to primitive (2B)


## Indirect Threading (ITC)

In Indirect Threading, NEXT leaves the word's Code Field Address (CFA) in a1, so NEST sets the new IP (s0) to the Parameter Field Address at 4(a1):

### NEXT (ITC) [8 bytes, 4 cycles]
NEXT:
    c.lw    a1, 0(s0)       # a1 = CFA of next word (2B)
    c.addi  s0, 4           # advance IP (2B)
    c.lw    a2, 0(a1)       # a2 = code address (2B)
    c.jr    a2              # execute word (2B)

### NEST / DOCOL (ITC) [8 bytes, 4 cycles]
NEST:
    c.addi  a5, -4          # push old IP onto return stack (2B)
    c.sw    s0, 0(a5)       # (2B)
    c.addi  a1, 4           # a1 = PFA (CFA + 4) (2B)
    c.mv    s0, a1          # IP = PFA (2B)
    j       NEXT            # (2B if within ±2KB)

### UNNEST / EXIT (ITC & DTC) [6 bytes, 3 cycles]
UNNEST:
    c.lw    s0, 0(a5)       # pop saved IP from return stack (2B)
    c.addi  a5, 4           # adjust return stack pointer (2B)
    j       NEXT            # (2B if within ±2KB)


## Direct Threading (DTC)

In Direct Threading, the first instruction of every colon definition is a direct call (jal a1, NEST or c.jal NEST if using ra), which automatically places the Parameter Field Address (PC + 4) into a1:
asm

Start of every colon word in memory:
   jal a1, NEST   (4 bytes — sets a1 = address of first thread cell)
   .word WORD1, WORD2, ..., UNNEST

### NEST / DOCOL (DTC) [6 bytes, 3 cycles]
NEST:
    c.addi  a5, -4          # push old IP onto return stack (2B)
    c.sw    s0, 0(a5)       # (2B)
    c.mv    s0, a1          # IP = PFA passed by jal a1, NEST (2B)
    j       NEXT            # (2B if within ±2KB)

### UNNEST / EXIT (DTC) [6 bytes, 3 cycles]
UNNEST:
    c.lw    s0, 0(a5)       # pop saved IP from return stack (2B)
    c.addi  a5, 4           # adjust return stack pointer (2B)
    j       NEXT            # (2B if within ±2KB)



Use code with caution.
(Tip: In Direct Threading on RV32C, if you use ra (x1) instead of a1 in c.jal NEST, the colon header shrinks from 4 bytes to 2 bytes, and NEST simply uses c.mv s0, ra—still 2 bytes—cutting every colon word's header size in half.)



1. Literals & Control Flow (LIT, BRANCH, 0BRANCH)

These three work identically in both Indirect Threading (ITC) and Direct Threading (DTC):
asm
# LIT ( -- n ) [8 bytes + j NEXT, 4 cycles]
# Pushes the inline 32-bit cell following LIT onto the data stack
LIT:
    c.addi  a4, -4          # make room on data stack (2B)
    c.sw    a0, 0(a4)       # push old TOS to memory (2B)
    c.lw    a0, 0(s0)       # fetch inline literal directly into TOS (2B)
    c.addi  s0, 4           # advance IP past literal (2B)
    j       NEXT

# BRANCH ( -- ) [4 bytes + j NEXT, 2 cycles]
# Unconditional branch using an inline target address
BRANCH:
    c.lw    s0, 0(s0)       # IP = target address stored at *IP (2B)
    j       NEXT

# 0BRANCH ( flag -- ) [12 bytes + j NEXT, 5 cycles]
# Branches to inline target address if TOS == 0; otherwise skips target
ZBRANCH:
    c.mv    a1, a0          # save flag in scratch a1 (2B)
    c.lw    a0, 0(a4)       # pop new TOS from data stack (2B)
    c.addi  a4, 4           # adjust data stack pointer (2B)
    c.bnez  a1, 1f          # if flag != 0, skip branch (2B)
    c.lw    s0, 0(s0)       # flag == 0: IP = target address at *IP (2B)
    j       NEXT
1:
    c.addi  s0, 4           # flag != 0: advance IP past target address (2B)
    j       NEXT
Use code with caution.
(Note on BRANCH/0BRANCH encoding: Storing an absolute target address at 0(s0) takes only 1 instruction (c.lw s0, 0(s0), 2 bytes). If your Forth compiler uses relative byte offsets instead, replace c.lw s0, 0(s0) with c.lw a2, 0(s0) + c.add s0, a2 — 4 bytes total.)

2. Defining Words (DOVAR, DOCON)


Option A: Indirect Threading (ITC)

In ITC, NEXT leaves the Code Field Address (CFA) in a1, so the Parameter Field Address (PFA) is at 4(a1):
asm
# DOVAR ( -- addr ) [6 bytes + j NEXT, 3 cycles]
# Pushes the Parameter Field Address (PFA) of a VARIABLE or CREATEd word
DOVAR:
    c.addi  a4, -4          # push old TOS onto data stack (2B)
    c.sw    a0, 0(a4)       # (2B)
    c.addi  a1, 4           # a1 = PFA (CFA + 4) (2B)
    c.mv    a0, a1          # TOS = PFA (2B) -> [Total: 8B, 4 cycles]
    j       NEXT

# DOCON ( -- n ) [6 bytes + j NEXT, 3 cycles]
# Pushes the 32-bit value stored in the Parameter Field of a CONSTANT
DOCON:
    c.addi  a4, -4          # push old TOS onto data stack (2B)
    c.sw    a0, 0(a4)       # (2B)
    c.lw    a0, 4(a1)       # TOS = *(CFA + 4) (2B)
    j       NEXT
Use code with caution.

Option B: Direct Threading (DTC)

In DTC, the word's header calls DOVAR or DOCON via jal a1, DOVAR (4 bytes), which puts the PFA directly into a1:
asm
# DOVAR (DTC) ( -- addr ) [6 bytes + j NEXT, 3 cycles]
DOVAR:
    c.addi  a4, -4          # push old TOS onto data stack (2B)
    c.sw    a0, 0(a4)       # (2B)
    c.mv    a0, a1          # TOS = PFA passed in a1 (2B)
    j       NEXT

# DOCON (DTC) ( -- n ) [6 bytes + j NEXT, 3 cycles]
DOCON:
    c.addi  a4, -4          # push old TOS onto data stack (2B)
    c.sw    a0, 0(a4)       # (2B)
    c.lw    a0, 0(a1)       # TOS = *PFA (2B)
    j       NEXT
Use code with caution.

Summary of Remaining Kept Registers (s1, s2, s3)

With s0 serving as IP and all core primitives complete, you still have 3 untouched kept registers (s1, s2, s3) available for VM state—such as:
• s1: Loop index (I) or USER area base pointer (gets full 2-byte compressed c.lw/c.sw access!).
• s2 & s3: Loop limit (LIMIT) and HERE / BASE pointers.


