.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 58
# =======================================================

dot:
exception_check:
    li t0, 1
    blt a2, t0, exit_57
    blt a3, t0, exit_58
    blt a4, t0, exit_58

dot_start:
    li t0, 0 # t0: sum
    slli a3, a3, 2 # offset first array every movement
    slli a4, a4, 2 # offset second array every movement

loop_start:
    lw t2, 0(a0)
    lw t3, 0(a1)
    mul t1, t2, t3 # t1: temporary register for save dot prodoct
    add t0, t0, t1 # add to sum
    add a0, a0, a3 # move
    add a1, a1, a4
    addi a2, a2, -1
    bnez a2, loop_start

loop_end:
    mv a0, t0
    ret
    
exit_57:
    li a1, 57
    j exit
exit_58:
    li a1, 58
exit:
    call exit2