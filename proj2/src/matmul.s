.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 59
# =======================================================
matmul:
    ebreak
    # Error checks
    li t0, 1
    blt a1, t0, exit
    blt a2, t0, exit
    blt a4, t0, exit
    blt a5, t0, exit
    bne a2, a4, exit
    
# initialization
    # t0: outer_loop_counter
    # t1: inner loop counter
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    
    mv s0, a0 # s0: m0 start address
    mv s1, a3 # s1: m1 start address
    mv s2, a2 # s2: m0 colums as well as m0 offset
    mv s3, a5 # s3: m1 columns as well as m1 stride
    mv s4, a6 # s4: d martix start address
    mv s5, a1 # s5: outer counter as well as m0 rows
    
outer_loop_start:
    li s6, 0 # s6: init inner counter

inner_loop_start:
    mv a0, s0 # a0 is array1 address
    slli t0, s6, 2
    add a1, s1, t0 # a1 is array2 address

    mv a2, s2 # a2 is number of elements
    li a3, 1 # array1 stride is 1
    mv a4, s3 # array2 stride is m1 columns
    
    addi sp, sp, -4
    sw ra, 0(sp)
    call dot
    lw ra, 0(sp)
    addi sp, sp, 4
    
    sw a0, 0(s4)
    addi s4, s4, 4 # move d martix
    
inner_loop_end:
    addi s6, s6, 1
    bne s6, s3, inner_loop_start

outer_loop_end:
    addi s5, s5, -1 # decrese outer counter
    slli t0, s2, 2 
    add s0, s0, t0 # offset m1
    bnez s5, outer_loop_start

recovery:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    addi sp, sp, 28

    ret
exit:
    li a1, 59
    call exit2
    