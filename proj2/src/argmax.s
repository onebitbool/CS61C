.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# =================================================================
argmax:
    ebreak
    li t0, 1
    blt a1, t0, exit
    # Prologue
    li t0, 0 # t0: largest number index
    lw t1, 0(a0) # t1: largest number
    mv t2, a0 # t2: largest number pointer
loop_start:
    lw t3, 0(a0) # t3: current number
    bge t1, t3, loop_continue
    sub t0, a0, t2
    srli t0, t0, 2
    mv t1, t3
    
loop_continue:
    addi a0, a0, 4
    addi a1, a1, -1
    bgtz a1, loop_start

loop_end:
    mv a0, t0
    # Epilogue
    ret
exit:
    li a1, 57
    call exit2