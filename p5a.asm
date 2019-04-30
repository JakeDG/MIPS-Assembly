# Name: Jacob Gidley
# Unix ID : 
# Lab Instuctor : Noah Park
# Lab Time : Friday @ 12:35


# This program will prompt the user for an integer, reads the integer typed by the user and outputs the following values:
# The total number of 1's in the right half of the binary representation of the integer.
# The total number of 0's in the left half of the binary representation of the integer.
# The highest power of 2 that evenly divides the integer .
# The value of the largest digit in the decimal representation of the integer.
# Then it will exit

# Function: main
		.data
prompt: 	.asciiz 	"Enter an integer: "
nl:		.asciiz 	"\n"

	.text
	.globl main

main: 

move     $12, $0     #$12 will contain the integer.
 
# Prompt the user for an integer
li	$v0, 4
la	$a0, prompt
syscall

# Read the integer using syscall. 
li       $v0, 5       # 5 represents read_int command.
syscall               # The integer is read into $v0.

move	$12, $v0	# Store the integer

jal	num_ones	# Call the num_ones function
jal	num_zeros	# Call the num_zeros function
jal	pwrsOfTwo	# Call the pwrsOfTwo function
jal	lrgDigit	# Call the lrgDigit function

li       $v0, 10    # exit command.
syscall
#************************************************* End of Main ****************************************************************

# Function : num_ones
# Calculates the number of ones on the right half of the binary representation of the integer
num_ones:

	.data
promptNumOnes:	.asciiz		"No. of 1's in the right half = "

	.text
move $14, $12	# S14 = $12 (the integer)
move $15, $0	# $15 = 0  Stores the amount of ones in the binary number
move $16, $0	# $16 = 0 Counter to go through the right 16-bits 

# While ($16 < 16) keep iterating through the bits
onesloop:
slti 	$t0, $16, 16	# If ($16 < 16) $t0 = 1 else $t0 = 0
beqz	$t0, exit_onesloop 	# If $t0 = 0, thus $16 >= 16, exit the loop
andi 	$t1, $14, 1	# Compare bit by bit of integer of $14 to 1
add	$15, $15, $t1	# Add 1 or 0 to the counter of ones, $15 = $15 + $t1
srl 	$14, $14, 1	# Shift the integer in $14 right logical
addi	$16, $16, 1	# Increment loop counter by 1
j	onesloop	# Keep looping through the binary number

# When loop is done print the number of ones in the binary number to the screen
exit_onesloop:

#Print prompt
li	$v0, 4
la	$a0, promptNumOnes
syscall

# Print number of ones
move	$a0, $15   #The value to be output must be in $a0.
li	$v0, 1     # 1 represents print_int command
syscall            # The integer in $a0 will be printed.

#Print newline
li	$v0, 4
la	$a0, nl
syscall

jr	$31	# Return to main
#***************************************************************************************************************************************

# Function : num_zeros
# Calculates the number of zero on the left half of the binary representation of the integer
num_zeros:

	.data
promptNumZeros:	.asciiz		"No. of 0's in the left half = "

	.text
move	$14, $12	# S14 = $12
move	$15, $0		# $15 = 0  Stores the amount of zeros in the binary number
move	$16, $0		# $16 = 0 Counter to go through a 16-bit integer
move 	$17, $0		# Will store the value 0x80000000 used to compare the bits in the left half of the binary rep.		
			# 0x80000000 = 10000000 00000000 00000000 00000000

li	$17, 0x80000000		

# While ($16 < 16) keep iterating through the bits
zerosloop:
slti 	$t0, $16, 16		# If ($16 < 16) $t0 = 1 else $t0 = 0
beqz	$t0, exit_zerosloop 	# If $t0 = 0, thus $16 >= 16, exit the loop
and  	$t1, $14, $17		# Compare bit by bit of integer of $14 to 1 -- (1 & 0) = 0 , (1 & 1) = 1

beqz	$t1, addZeroCnt		# if ($t1 == 0) then increment the zero counter
sll 	$14, $14, 1	# Shift the integer in $14 le
addi	$16, $16, 1	# Increment loop counter by 1
j	zerosloop

addZeroCnt:
add	$15, $15, 1	# Add 1 to the counter of zeros, $15 = $15 + 1
sll 	$14, $14, 1	# Shift the integer in $14 left logical
addi	$16, $16, 1	# Increment loop counter by 1
j	zerosloop	# j to increment the counter

# When loop is done print the number of ones in the integer to the screen
exit_zerosloop:

#Print prompt
li	$v0, 4
la	$a0, promptNumZeros
syscall

# Print number of zeros
move	$a0, $15   #The value to be output must be in $a0.
li	$v0, 1     # 1 represents print_int command
syscall            # The integer in $a0 will be printed.

#Print newline
li	$v0, 4
la	$a0, nl
syscall

jr	$31	# Return to main
#***************************************************************************************************************************

# Function: pwrsOfTwo
# Calculates the highest power of 2 that evenly divides the integer by counting the number of 
# zeros at the end of the binary representation
pwrsOfTwo:

	.data
promptpwrs:	.asciiz		"Largest power of 2 = "

	.text
move	$14, $12 # $14 now holds the input integer	
move	$15, $0	# Stores the count of zeros
move	$16, $0	# loop counter
move	$t1, $0	# Used to check if bit is a 0 in the binary value

# while ($16 < 32)
pwrsloop:
slti 	$t0, $16, 32	# If ($16 < 32) $t0 = 1 else $t0 = 0
beqz	$t0, exit_pwrsloop

andi 	$t1, $14, 1	# Compare bit by bit of integer of $14 to 1

beqz 	$t1, incPwrCnt	# if ($t1 = 0) then increment counter by 1
j	exit_pwrsloop	# else found the first 1 in the binary number so exit the loop

incPwrCnt:
addi	$15, $15, 1	# $15 = $15 + 1, increment powers of 2 counter
srl 	$14, $14, 1	# Shift the integer in $14 right logical
addi	$16, $16, 1	# Increment loop counter by 1
j	pwrsloop

exit_pwrsloop:

# if($15 == 0) then output 0 as the largest power of two
beqz	$15, outputZero

# else out put the power using the number of zeros found
# Print prompt
li	$v0, 4
la	$a0, promptpwrs
syscall

# Print value
move	$a0, $15   #The value to be output must be in $a0.
li	$v0, 1     # 1 represents print_int command
syscall            # The integer in $a0 will be printed.

#Print newline
li	$v0, 4
la	$a0, nl
syscall

jr	$31

# No zeros found at the end of the binary integer so output zero
outputZero:

# Print prompt
li	$v0, 4
la	$a0, promptpwrs
syscall

# Print value
move	$a0, $15   #The value to be output must be in $a0.
li	$v0, 1     # 1 represents print_int command
syscall            # The integer in $a0 will be printed.

#Print newline
li	$v0, 4
la	$a0, nl
syscall

jr	$31

#*************************************************************************************************************************************
# Function largest digit
# Finds the largest digit in the integer by using successive divisions by 10, then outputs it.
lrgDigit:

	.data
promptDigit:		.asciiz		"Largest decimal digit = "

	.text
move	$14, $12 	# $14 now holds the input integer	
move 	$15, $0		# Stores the largest digit
move	$t0, $0		# Stores remainder
li	$16, 10		# Holds value of 10

digitLoop:
beqz 	$14, exit_digitLoop	# If $14 = 0, thus the quotient is 0, exit the loop

div	$14, $16	# Divide the integer in $14 by 10
mflo	$14		# Store quotient, which is the next number to be divided
mfhi	$t0		# Store remainder

slt	$t1, $15, $t0	# if (largest < remainder) then $t1 = 1, else $t1 = 0
beqz	$t1, digitLoop
move	$15, $t0	# Store the new largest digit in $15
j	digitLoop

exit_digitLoop:

# Print prompt
li	$v0, 4
la	$a0, promptDigit
syscall

# Print value
move	$a0, $15   #The value to be output must be in $a0.
li	$v0, 1     # 1 represents print_int command
syscall            # The integer in $a0 will be printed.

#Print newline
li	$v0, 4
la	$a0, nl
syscall

jr	$31
