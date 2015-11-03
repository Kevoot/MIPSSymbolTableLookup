	.data
st_prompt: .asciiz "\nEnter a new input line. \n"
Tabchar: .word ' ', 5
	.word '#', 6
	.word '(', 4
	.word ')', 4
	.word '*', 3
	.word '+', 3
	.word ',', 4
	.word '-', 3
	.word '.', 4
	.word '/', 3
	.word '0', 1
	.word '1', 1
	.word '2', 1
	.word '3', 1
	.word '4', 1
	.word '5', 1
	.word '6', 1
	.word '7', 1
	.word '8', 1
	.word '9', 1
	.word ':', 4
	.word 'A', 2
	.word 'B', 2
	.word 'C', 2
	.word 'D', 2
	.word 'E', 2
	.word 'F', 2
	.word 'G', 2
	.word 'H', 2
	.word 'I', 2
	.word 'J', 2
	.word 'K', 2
	.word 'L', 2
	.word 'M', 2
	.word 'N', 2
	.word 'O', 2
	.word 'P', 2
	.word 'Q', 2
	.word 'R', 2
	.word 'S', 2
	.word 'T', 2
	.word 'U', 2
	.word 'V', 2
	.word 'W', 2
	.word 'X', 2
	.word 'Y', 2
	.word 'Z', 2
	.word 'a', 2
	.word 'b', 2
	.word 'c', 2
	.word 'd', 2
	.word 'e', 2
	.word 'f', 2
	.word 'g', 2
	.word 'h', 2
	.word 'i', 2
	.word 'j', 2
	.word 'k', 2
	.word 'l', 2
	.word 'm', 2
	.word 'n', 2
	.word 'o', 2
	.word 'p', 2
	.word 'q', 2
	.word 'r', 2
	.word 's', 2
	.word 't', 2
	.word 'u', 2
	.word 'v', 2 
	.word 'w', 2
	.word 'x', 2
	.word 'y', 2
	.word 'z', 2
outBuf: .space 80
inBuf:  .space 80

	.text
main:
	la $a3, outBuf			#load address of output buffer
	jal getline
	la $a0, inBuf			#load address from string
	lb $t1, ($a0)			#load byte from address of string
	jal search
	
getline:
	la $a0, st_prompt 		# Prompt to enter a new line
	li $v0, 4
	syscall
	
	la $a0, inBuf 			# read a new line
	li $a1, 80
	li $v0, 8
	syscall
	
	jr $ra

search:
	lb $t1, ($a0)			#load address from string
	beq $t1, 10, printoutput	#if carriage return, string end
	beq $t1, 0, printoutput		#if null terminator, string end
	la $a2, Tabchar			#load address of Tabchar symtab
	loop:
	lw $t2, ($a2)			#load byte from symtab
	beq $t1, $t2, found		#branch if value is equal
	addi $a2, $a2, 8		#if not found, increment address of $a2 by two and try again
	j loop
	
	
found:
	lw $t3, 4($a2)			#load next value, which will be the numerical code.
	beq $t3, 5, space		#empty space found, add directly to output buffer
	addi $t3, $t3, 48		#convert to ascii
	beq $t3, 54, endProgram		#ends program if detects pound symbol
	sb $t3, ($a3)			#store converted result into outBuf
	addi $a3, $a3, 1		#go to next location in output buffer
	addi $a0, $a0, 1		#increment by 1 byte to get next character
	b search			#branch back to search

printoutput:
	la $a0, outBuf 			# Print output buffer
	li $v0, 4
	syscall

cleanBuffer:		# Sets the input and output buffers to 0 (cleans the strings)
	la $t0, ($a0)
	addi $t0, $t0, 80
	
cleanLoop:	# Loop to set each element to 0
	sb $zero, ($a0)
	addi $a0, $a0, 1
	bne $t0, $a0, cleanLoop
	b main
endProgram:
	li 	$v0, 10			#exit syscall
	syscall
space:
	sb $t1, ($a3)
	addi $a3, $a3, 1
	addi $a0, $a0, 1
	b search
