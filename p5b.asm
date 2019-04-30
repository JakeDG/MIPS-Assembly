# Name: Jacob Gidley
# Unix ID : 
# Lab Instuctor : Noah Park
# Lab Time : Friday @ 12:35


# This program will prompt the user for a sentence.
# If the sentence contains only whitespace charcters, then it will output that the line has only whitespace characters. 
# If the line is not empty then the program will output the following values:
# The total number of of non-whitespace characters.
# The total number of words.
# The maximum length of a word.
# The minimum length of a word.
# The word of maximum length.
# The word of minimum length
# Then it will exit
	
	.data
prompt: 	.asciiz 	"Enter a sentence: "
inputArray:	.space		81
nl:		.asciiz 	"\n"
blank:		.asciiz		"Line contains only white space characters."

	.text
	.globl	main

# Main function
main:

# Prompt user for a sentence
li	$v0, 4	
la	$a0, prompt
syscall

# Get user input
li	$v0, 8		# Read string
la	$a0, inputArray	# Store into sentence array
li	$a1, 81		# Indicate the maximum size of the sentence
syscall

move	$14, $a0	# Base addr. of array

# Determine if the line contains only whitespace characters
spaceLoop:
lbu	$t0, ($14)	
beqz	$t0, blankLine	# Element in the array is = to zero (NULL), then the line is blank, exit the loop

# if ($t0 > 32) then the character must be an a non-whitespace character. Exit the loop.
bgt	$t0, 32, exit_spcLoop # ASSCII values 0-32 are all whitespace characters

addi 	$14, $14, 1	# Increment the address of the array. (i.e. array[i] + 1)
j	spaceLoop

exit_spcLoop:

# else start calling functions
jal	count_chars	# call count characters function
jal	count_words	# call count words function
jal	find_lrgWord	# call find largest word function
jal	find_smlWord	# call find smallest word function
jal	print_lrgWord	# call print largest word function
jal	print_smlWord	# call print smallest word function

# Exit program
li       $v0, 10
syscall

# Print that the line is empty
blankLine:

# Display the sentence
li	$v0, 4
la	$a0, blank
syscall

#Print newline
li	$v0, 4
la	$a0, nl
syscall

# Exit program
li       $v0, 10
syscall
#*********************************************************** End of main **********************************************************************************

# Function count characters
# Counts the number of white space characters in the sentence
count_chars:

	.data

charsCnt:	.asciiz		"No. of non-whitespace characters: "

	.text
la	$14, inputArray	# $14 holds the beginning address of the array
move	$15, $0		# Stores the numbers of characters in the sentence
move	$t0, $0		# Stores the current ascii value of the character at the current index of the array

# Loop through the array until the null character is found
charsLoop:
lbu	$t0, ($14)		# $t0 = the ascii value of the character located at the current element $14 is at in the array
beqz	$t0, exit_charsLoop	# if ($t0 == '\0'), end of string, exit the loop

# if ($t0 > 32) then the character must be an a non-whitespace character. Increment the counter.
bgt	$t0, 32, incCharCnt # ASSCII alues 0-32 are all whitespace characters
addi 	$14, $14, 1	# Increment the address of the array. (i.e. array[i] + 1)
j	charsLoop

incCharCnt:
addi	$15, $15, 1	# Increment counter by one
addi 	$14, $14, 1	# Increment the address of the array. (i.e. array[i] + 1)
j	charsLoop

exit_charsLoop:

# Print the prompt
li $v0, 4
la $a0, charsCnt
syscall

# output the number of non-whitespace characters
move	$a0, $15   #The value to be output must be in $a0.
li	$v0, 1     # 1 represents print_int command
syscall            # The integer in $a0 will be printed.

#Print newline
li	$v0, 4
la	$a0, nl
syscall

jr	$31
#*****************************************************************************************************************************

# Fucntion: word_num
# Counts the number of words in the sentence
count_words:

	.data
promptWordCnt:	.asciiz		"No. of words: "

	.text
la	$14, inputArray	# Set $14 to beginning of input array
move	$15, $0		# Stores the numbers of words in the sentence
move	$t0, $0		# Stores the current ascii value of the character at the current index of the array

# Loop through the array until a character is found, then exit the loop. 
# Since the array doesn't contain an empty string it will never reach the null 
wordsLoop:
lbu	$t0, ($14)	
beqz	$t0, exit_wordsLoop	# Element in the array is = to zero (NULL), end of string, exit the loop

# if ($t0 > 32) then the character must be an a non-whitespace character. Thus, found the first character in the string. Jump to word counting loop.
bgt	$t0, 32, wordCnt # ASSCII alues 0-32 are all whitespace characters
addi 	$14, $14, 1	# Increment to the next address in the array. (i.e. array[i] + 1)
j	wordsLoop

# Count the number of words in the sentence
wordCnt:
lbu	$t0, ($14)
beqz	$t0, exit_wordsLoop	# Element in the array is = to zero (NULL), end of string, exit the loop

slti	$t1, $t0, 33	# if ($t0 < 32) then a space was found meaning its the end of a word so increment the counter 
beq	$t1, 1, incWordCnt	# else $t0 is a character so keep looping until a space is found
addi 	$14, $14, 1	# Increment the address of the array. (i.e. array[i] + 1)
j	wordCnt

# Increment the word count
incWordCnt:
addi	$15, $15, 1	# Increment counter by one
addi 	$14, $14, 1	# Increment the address of the array. (i.e. array[i] + 1)
j	wordCnt

exit_wordsLoop:

# Print the prompt
li $v0, 4
la $a0, promptWordCnt
syscall

# Output the number of words in the sentence
move	$a0, $15   #The value to be output must be in $a0.
li	$v0, 1     # 1 represents print_int command
syscall            # The integer in $a0 will be printed.

#Print newline
li	$v0, 4
la	$a0, nl
syscall

jr	$31
#*******************************************************************************************************************************

# Function: lrg_word
# Finds the maximum length of a word
find_lrgWord:

	.data
promptMaxLenCnt:	.asciiz		"Maximum length of a word: "

	.text
la	$14, inputArray	# Set $14 to beginning of input array
move	$15, $0		# Stores the number of characters in the sentence
move	$16, $0		# Stores the largest word's char count
move	$17, $0		# Stores the address of the beginning of the largest word
move	$t0, $0		# Stores the current ascii value of the character at the current index of the array
move	$t1, $0

# Loop through the array until a character is found, then exit the loop. 
# Since the array doesn't contain an empty string it will never reach the null 
lrgWordLoop:
lbu	$t0, ($14)	
beqz	$t0, exit_lrgWordLoop	# if ($t0 == NULL) then exit the loop

# if ($t0 > 32) then the character must be an a non-whitespace character. Thus, found the first character in the string. Jump to word counting loop.
bgt	$t0, 32, lrgCnt # ASSCII alues 0-32 are all whitespace characters
addi 	$14, $14, 1	# Increment to the next address in the array. (i.e. array[i] + 1)
j	lrgWordLoop

# Count the number of words in the sentence
lrgCnt:
la	$t1, ($14)	# $t1 now holds the current address of the first letter of a word

lrgCharCnt:
lbu	$t3, ($14)	# Get ascii value of current index of the word
slti	$t4, $t3, 33	# if ($t3 < 33) then whitespace detected, end of word so exit the loop
beq	$t4, 1, lrgCntCheck

addi	$15, $15, 1	# increment the counter
addi	$14, $14, 1	# Next element in the array
j	lrgCharCnt

lrgCntCheck:
bgt	$15, $16, newLrgCnt	# if ($15 > $16) then the new largest count is the value of $15
move	$15, $0			# reset counter to zero to count the next words chars
j	lrgWordLoop

newLrgCnt:
move	$16, $15	# Store the largest count value
la	$17, ($t1)	# Store the address of the beginning of the largest word
move	$15, $0		# reset counter to zero to count the next words chars
j	lrgWordLoop

exit_lrgWordLoop:

# Print prompt
la	$a0, promptMaxLenCnt
li	$v0, 4
syscall

# Print the max length
move	$a0, $16
li	$v0, 1
syscall

 #Print newline
li	$v0, 4
la	$a0, nl
syscall

jr	$31
#**********************************************************************************************************************************

# Function: sml_word
# Finds the minimum length of a word
find_smlWord:

	.data
promptMinLenCnt:	.asciiz		"Minimum length of a word: "

	.text
la	$14, inputArray	# Set $14 to beginning of input array
move	$15, $0		# Stores the number of characters in the sentence
move	$16, $0		# Stores the smallest word's char count
move	$18, $0		# Stores the address of the beginning of the smallest word
move	$t0, $0		# Stores the current ascii value of the character at the current index of the array
move	$t1, $0		# Temporarily stores the address at the beginning of every word found in the sentence

# Loop through the array until a character is found, then exit the loop. 
# Since the array doesn't contain an empty string it will never reach the null 
smlWordLoop:
lbu	$t0, ($14)	
beqz	$t0, exit_smlWordLoop	# if ($t0 == NULL) then exit the loop

# if ($t0 > 32) then the character must be an a non-whitespace character. Thus, found the first character in the string. Jump to word counting loop.
bgt	$t0, 32, smlCnt # ASSCII alues 0-32 are all whitespace characters
addi 	$14, $14, 1	# Increment to the next address in the array. (i.e. array[i] + 1)
j	smlWordLoop

# Count the number of words in the sentence
smlCnt:
la	$t1, ($14)	# $t1 now holds the current address of the first letter of a word

smlCharCnt:
lbu	$t3, ($14)	# Get ascii value of current index of the word

slti	$t4, $t3, 33	# if ($t3 < 33) then whitespace detected, end of word so exit the loop
beq	$t4, 1, smlCntCheck

addi	$15, $15, 1	# increment the counter
addi	$14, $14, 1	# Next element in the array
j	smlCharCnt

smlCntCheck:
beqz	$16, firstWord		# Check if $16 == 0, if it is, then store the first word's char count into it. This test should only be true once!

slt	$t4, $15, $16		# if ($15 < $16) then the new largest count is the value of $15
beq	$t4, 1, newSmlCnt	
move	$15, $0			# reset counter to zero to count the next words chars
j	smlWordLoop

#$16 == 0, store the first word's char count into it
firstWord:
move	$16, $15	# Stores the first word's length into $16
la	$18, ($t1)	# Store the address of the beginning of the smallest word
move	$15, $0		# reset counter to zero to count the next words chars

j	smlWordLoop

newSmlCnt:
move	$16, $15	# Store the smallest count value
la	$18, ($t1)	# Store the address of the beginning of the largest word
move	$15, $0		# reset counter to zero
j	smlWordLoop

exit_smlWordLoop:

# Print prompt
la	$a0, promptMinLenCnt
li	$v0, 4
syscall

# Print the min length
move	$a0, $16
li	$v0, 1
syscall

 #Print newline
li	$v0, 4
la	$a0, nl
syscall

jr	$31

#**********************************************************************************************************************************

# Function: print_lrgWord
# Prints the largest word in the sentence character by character
print_lrgWord:

	.data
promptMaxWord:	.asciiz		"Word of maximum length: "

	.text
move $t0, $0	# Stores the current ascii value of the character at the current index of the array
move $t1, $0	# Used to check if the end of the word has been reached

# Print prompt
la	$a0, promptMaxWord
li	$v0, 4
syscall

# Print the largest word character by character
prtLrgLoop:
lbu	$t0, ($17)	# Get ascii value of current index of the word
slti	$t1, $t0, 33	# if ($t3 < 33) then whitespace detected, end of word so exit the loop
beq	$t1, 1, exit_prtLrgLoop

lbu	$a0, ($17)
li	$v0, 11		# Print char
syscall

addi	$17, $17, 1	# Increment to the next element of the word in the array
j	prtLrgLoop

exit_prtLrgLoop:

 #Print newline
li	$v0, 4
la	$a0, nl
syscall

jr	$31

#**********************************************************************************************************************************

# Function: print_smlWord
# Prints the smallest word in the sentence character by character
print_smlWord:

	.data
promptMinWord:	.asciiz		"Word of minimum length: "

	.text
move $t0, $0	# Stores the current ascii value of the character at the current index of the array
move $t1, $0	# Used to check if the end of the word has been reached

# Print prompt
la	$a0, promptMinWord
li	$v0, 4
syscall

# Print the smallest word character by character
prtSmlLoop:
lbu	$t0, ($18)
slti	$t1, $t0, 33	# if ($t3 < 33) then whitespace detected, end of word so exit the loop
beq	$t1, 1, exit_prtSmlLoop

lbu	$a0, ($18)	# Print char
li	$v0, 11
syscall

addi	$18, $18, 1	# Increment to the next element of the word in the array
j	prtSmlLoop

exit_prtSmlLoop:

 #Print newline
li	$v0, 4
la	$a0, nl
syscall

jr	$31
