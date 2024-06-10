# CUCU-Compiler
A compiler based on a new programming language named CUCU.
To compile and execute, follow these steps:

flex cucu.l (to generate lexical analyzer code from cucu.l.)
bison -d cucu.y (to create parser code (cucu.tab.c, cucu.tab.h) from cucu.y.)
gcc lex.yy.c cucu.tab.c -o cucu -lfl.
Key Features of the Compiler:

Supports variable declarations, function declarations, and definitions.
Variable declaration syntax includes initialization.
Functions can be declared and defined, including parameters.
Follows precedence and associativity rules for expressions.
Supports various arithmetic and logical operations.
Ignores single and multi-line comments.
Errors in lexical analysis are logged in Lexer.txt.
Parsing errors are reported in Parser.txt.
Error Handling:

Lexical errors are reported in the format: "Line number X: Lexical error, undefined token in input: @", logged in Lexer.txt.
Parsing errors are reported simply as "error: syntax error" and are logged in Parser.txt.
This compiler project aims to facilitate learning about compiler construction while implementing essential features of a language.

