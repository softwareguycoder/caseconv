# Program: Case Converter

This program is written in Assembly with NASM on Linux (x86) and is supposed to be a minimal useful program in Assembly.  Thanks for to Jeff Duntemann for the code.  This comes from his excellent book, "Assembly Language Step-by-Step: Programming with Linux, 3rd ed" (John Wiley & Sons, 2009).

## Problem to be solved
Convert any lowercase characters in a data file to uppercase.

## Bounds of the solution
- We will be working under Linux.
- The data exists in disk files.
- We do not know ahead of time how large any of the files will be.
- There is no maximum or minimum size for the files.
- We will use I/O redirection to pass filenames to the program.
- All the input files are in the same encoding scheme.  The program
  can assume that an "a" character in one file is encoded the same way 
  as an "a" in another file.  (In our case, this is ASCII.)
- We must preserve the original file in its original form, rather than 
  read data from the original file and then write it back to the original
  file (that's because, if the process crashes, we've destroyed the
  original file without completely generating an output file.)

## Pseudo-code
### First pass at psuedo-code

```
	Read a character from the input file.
	Convert the character to uppercase (if necessary).
	Write the character to the output file.
	Repeat until done.
```

### Successive refinement
	
```
	Read a character from standard input (stdin).
	Test the character to see if it's a lowercase letter.
	If the character is a lowercase letter, convert it to a uppercase letter by subtracting 20h.
	Write the character to standard output (stdout).
	Repeat until done.
	Exit the program by calling sys_exit.
```

### Expanded (and slightly rearranged) pseudo-code

```	
	Read a character from the standard input (stdin).
	Test if we have reached End Of File (EOF).
	If we have reached EOF, we're done, so jump to exit
	Test the current character to see if it's a lowercase letter.
	If the charactrer is lowercase, convert it to uppercase by subtracting 20h
	Write the character to standard output (stdout).
	Go back and read another character.
	Exit the program by calling sys_exit.
```

### Adding labels to the groups of statements so it looks like we have jump targets:

```	
Read:
	Set up registers for the sys_read kernel call
	Call sys_read to read from stdin
	Test for EOF.
	If we're at EOF, jump to Exit.

	Test the character to see if it's a lowercase letter.
	If it's not a lowercase letter, jump to Write.
	Convert the character to an uppercase letter by subtracting 20h.

Write:
	Set up registers for the sys_write kernel call
	Call sys_write to write to stdout
	Jump back to Read and get another character.

Exit:
	Set up registers for terminating the program via sys_exit.
	Call sys_exit.
```
## How to run this program
To test the executable produced when this program is compiled, use I/O redirection, as follows:
### Sample command line
```
./caseconv > outputfile < inputfile
```
where `inputfile` and `outputfile` are the names of two ASCII text files.  The inputfile must exist
prior to the execution of the program; however, if the outputfile does not exist, it will be created.  If
an outputfile already exists, it is overwritten.

## Next steps

### Scanning a buffer

The program needs error handling, which in this case mostly involves testing the return values from `sys_read` and
displaying meaningful messages on the Linux console.  There's no technical difference between displaying error
messages and displaying slogans for greasy-spoon diners, so you can add error handling yourself as an exercise.

The more interesting challenge, howver, involves buffered file I/O.  The Unix read and write kernel calls are 
buffer-oriented and not character-oriented, so we have to recast our psuedo-code to fill buffers with characters,
and then process the buffers.

Let's go back to the psuedo-code and give it a try:
```
Read:
	Set up registers for the sys_read kernel call.
	Call sys_read to read a buffer full of characters from stdin.
	Test for EOF.
	If we're at EOF, jump to Exit.

	Set up registers as a pointer to scan the buffer (by the time sys_read
	is done, pointer will be set at the end of the -- now filled -- buffer).
Scan:
	Test the character at the buffer pointer to see if it's a lowercase letter.
	If it's not a lowercase letter, skip conversion.
	Convert the current letter to uppercase by subtracting 20h from its ASCII character code.
	Decrement the buffer pointer.
	If we still have characters in the buffer, jump to Scan.

Write:
	Set up registers for the sys_write kernel call.
	Call sys_write to write the processed buffer to stdout.
	Jump back to Read and get another buffer full of characters.

Exit:
	Set up registers for terminating the program via sys_exit.
	Call sys_exit.
```
