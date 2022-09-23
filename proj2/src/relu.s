.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# ==============================================================================
relu:
    # Prologue
    li t0, 1
    blt a1, t0, exit

loop_start:
    lw t0, 0(a0)
    bgez t0, loop_continue
    sw x0, 0(a0)
    
loop_continue:
    addi a0, a0, 4
    addi a1, a1, -1
    bgtz a1, loop_start

loop_end:
    # Epilogue
	ret
    
exit:
    li a1, 57
    call exit2
