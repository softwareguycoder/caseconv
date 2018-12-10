# Program: Case Converter

## Problem to be solved:
Convert any lowercase characters in a data file to uppercase.

## Bounds of the solution:
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

## Pseudo-code:

```
	Read a character from the input file.
	Convert the character to uppercase (if necessary).
	Write the character to the output file.
	Repeat until done.
```

## Successive refinement:
	
```
	Read a character from standard input (stdin).
	Test the character to see if it's a lowercase letter.
	If the character is a lowercase letter, convert it to a uppercase letter by subtracting 20h.
	Write the character to standard output (stdout).
	Repeat until done.
	Exit the program by calling sys_exit.
```

## Expanded (and slightly rearranged) pseudo-code:

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

## Adding labels to the groups of statements so it looks like we have jump targets:

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
