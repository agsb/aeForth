
.data
.balign 4

# Define two separate data regions with labels
buffer_a:
    .word 0xAAAA     # Address: e.g., 0x80002000
buffer_b:
    .word 0xBBBB     # Address: e.g., 0x80002004

.text
.global _start
_start:

    # 1. Initialize our variable to a numeric constant
    .set current_target, 0
    li a0, current_target          # Loads 0 into a0

    # 2. Update the variable to point to a label
    .set current_target, buffer_a
    la a1, current_target          # Loads the address of 'buffer_a' into a1
    lw t0, 0(a1)                   # t0 now holds 0xAAAA

    # 3. Update the variable to point to a different label
    .set current_target, buffer_b
    la a2, current_target          # Loads the address of 'buffer_b' into a2
    lw t1, 0(a2)                   # t1 now holds 0xBBBB

    # 4. Update the variable using label arithmetic (e.g., look 4 bytes past buffer_a)
    .set current_target, buffer_a + 4
    la a3, current_target          # Loads (buffer_a + 4), which is the address of buffer_b!

