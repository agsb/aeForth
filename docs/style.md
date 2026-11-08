

This comes up every now and then. Here's a summary I made:
Word 	Explanation
0foo 	Clear foo, reset foo
foo0 	Initial state of foo
+foo 	Add to foo
-foo 	Remove from foo, or disable foo
foo! 	Store a foo at an address
foo@ 	Fetch a foo from an address
!foo 	Set foo, or enable foo
@foo 	Get foo (sorry GitHub user @foo)
>foo 	Convert to foo, or push onto foo
foo> 	Pop from foo
?foo 	Optionally do foo
foo? 	Return a boolean value
foo' 	Accept an address or xt as input
'foo 	Address or xt of foo
foo" 	Parse a string and do foo
"foo 	Accept a string as input
foo, 	Compile a foo, or assemble foo instruction
#foo 	Number of foos
foo# 	Foo index
/foo 	Size of foo
foo: 	Define a foo
.foo 	Print a foo
[foo] 	Do foo at compile time
(foo) 	Internal implementation of foo, runtime action of foo
\foo 	Foo with argument order reversed or permuted



https://docs.google.com/spreadsheets/d/1TDGwB0WVFC9nuAOQ2-o6ifNpvb8OILJtZK2zFm6ONxc/edit?gid=1980885478#gid=1980885478

Example	Description	

word!	store; source on stack.  dest either on stack or implied	
!word	store; source not on stack	
word@	fetch; returns item on stack.  source either on stack or implied	
datatype@	fetch; source address on stack; datatype can be for example F for "float"	
word+!	plus-store; add to dest on stack or implied	
+word	increment or push	
word+	add something to item on stack	
		
-word	delete something	
word-	subtract or undo something	
/word	initialize something. rarely, the size of something (deprecated)	
word/	tear down something	
#words	count of something	
word#	integer	
word$	string	
%word	struct	
*word	create something	
word*	multiply	
word>	pop, or DOES>-style code body	
>word	push, or convert	
[word]	compiler directive	
[word word]	start/end data definition, or some state	
:word	define something	
word:	create something (parameters on stack)	
'word	XT or address of code	
word,	compile	
.word	print	
?word	conditionally do something; may take parameters or not	
word?	returns a flag	
<word>	denotes string in input stream	

Example	Description	
word!	store; source on stack.  dest either on stack or implied	
!word	store; source not on stack	
word@	fetch; returns item on stack.  source either on stack or implied	
datatype@	fetch; source address on stack; datatype can be for example F for "float"	
word+!	plus-store; add to dest on stack or implied	
+word	increment or push	
word+	add something to item on stack	
		
-word	delete something	
word-	subtract or undo something	
/word	initialize something. rarely, the size of something (deprecated)	
word/	tear down something	
#words	count of something	
word#	integer	
word$	string	
%word	struct	
*word	create something	
word*	multiply	
word>	pop, or DOES>-style code body	
>word	push, or convert	
[word]	compiler directive	
[word word]	start/end data definition, or some state	
:word	define something	
word:	create something (parameters on stack)	
'word	XT or address of code	
word,	compile	
.word	print	
?word	conditionally do something; may take parameters or not	
word?	returns a flag	
<word>	denotes string in input stream	
		
