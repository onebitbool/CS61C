.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91
# ==============================================================================
read_matrix:
    # save all arguments
    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    mv s1, a1 # s1: row number pointer
    mv s2, a2 # s2: colums number pointer

open_file:
    mv a1, a0
    li a2, 0
    
    addi sp, sp, -4
    sw ra, 0(sp)
    call fopen 
    lw ra, 0(sp)
    addi sp, sp, 4
    
    li t0, -1
    beq a0, t0, exit_89
    mv s0, a0 #s0: file descriptor
    
read_row:
    mv a1, s0 # load file descriptor
    mv a2, s1
    li a3, 1
    
    addi sp, sp, -4
    sw ra, 0(sp)
    call fread
    lw ra, 0(sp)
    addi sp, sp, 4

    li t0, 1
    bne a0, t0, exit_91
    lw s1, 0(s1)
    
read_column:
    mv a1, s0
    mv a2, s2
    li a3, 1
    
    addi sp, sp, -4
    sw ra, 0(sp)
    call fread
    lw ra, 0(sp)
    addi sp, sp, 4
    
    li t0, 1
    bne a0, t0, exit_91
    lw s2, 0(s2)
    
malloc_matrix:
    mul s1, s1, s2 # s1: martix size now
    mv a0, s1
    
    addi sp, sp, -4
    sw ra, 0(sp)
    call malloc
    lw ra, 0(sp)
    addi sp, sp, 4
    
    beqz a0, exit_88
    mv s3, a0 # s3: matrix pointer
    
read:
    mv a1, s0
    mv a2, s3
    mv a3, s1
    
    addi sp, sp, -4
    sw ra, 0(sp)
    call fread
    lw ra, 0(sp)
    addi sp, sp, 4
    
    bne a0, s1, exit_89

close:
    mv a1, s0
    
    addi sp, sp, -4
    sw ra, 0(sp)
    call fclose
    lw ra, 0(sp)
    addi sp, sp, 4
    
    ebreak
    bnez a0, exit_90

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    addi sp, sp, 16
    mv a0, s3
    ret
exit_88:
    li a1, 88
    j exit
exit_89:
    li a1, 89
    j exit
exit_90:
    li a1, 90
    j exit
exit_91:
    li a1, 91
exit:
    call exit2