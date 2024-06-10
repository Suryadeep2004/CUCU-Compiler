%{
#include <stdio.h>
#include <string.h>
#include "cucu.tab.h"
void yyerror(char *s);
FILE *lexer;
%}

%%
"/*"(\*+[^/*]|([^*]))*\**"*/"     /* Ignoring Multi Line Comments*/
(\/\/.*)                          /* Ignoring Single Line Comments*/
int[ ]                            {fprintf(lexer,"TYPE : %s\n",yytext); yylval.string=strdup(yytext);return ITYPE;}
char[ ]*\**                       {fprintf(lexer,"TYPE : %s\n",yytext); yylval.string=strdup(yytext);return CTYPE;}
==                                {fprintf(lexer,"EQUAL : ==\n"); yylval.string=strdup(yytext);return EQUAL;}
!=                                {fprintf(lexer,"NOTEQUAL : !=\n");yylval.string=strdup(yytext);return NOTEQUAL;}
=                                 {fprintf(lexer,"ASSIGN : =\n");yylval.string=strdup(yytext);return ASSIGN;}
(\&|\^)                           {fprintf(lexer,"BITOPERATOR : &\n");yylval.string=strdup(yytext);return BITOPERATOR;}
\|                                {fprintf(lexer,"BITOPERATOR : &\n");yylval.string=strdup(yytext);return BITOPERATOR;}
return                            {fprintf(lexer,"RETURN : %s\n",yytext);yylval.string=strdup(yytext);return RETURN;}
if                                {fprintf(lexer,"CONTROL : %s\n",yytext);yylval.string=strdup(yytext);return IF;}
else                              {fprintf(lexer,"CONTROL : %s\n",yytext);yylval.string=strdup(yytext);return ELSE;}
while                             {fprintf(lexer,"CONTROL : %s\n",yytext);yylval.string=strdup(yytext);return WHILE;}
\"([^\"])*\"                      {fprintf(lexer,"STRING  : %s\n", yytext);yylval.string = strdup(yytext); return STRING;}
[a-zA-Z][a-zA-Z0-9_]*             {fprintf(lexer,"ID: %s\n",yytext);yylval.string=strdup(yytext);return ID;}
[0-9]+                            {fprintf(lexer,"NUM : %s\n",yytext);yylval.number=atoi(yytext); return NUM;}
\(                                {fprintf(lexer,"OPENBRAC : %s\n",yytext);yylval.string=strdup(yytext);return OB1;}
\)                                {fprintf(lexer,"CLOSEBRAC : %s\n",yytext);yylval.string=strdup(yytext);return CB1;}
\{                                {fprintf(lexer,"OPENBRAC : %s\n",yytext);yylval.string=strdup(yytext);return OB2;}
\}                                {fprintf(lexer,"CLOSEBRAC : %s\n",yytext);yylval.string=strdup(yytext);return CB2;}
\[                                {fprintf(lexer,"OPENBRAC : %s\n",yytext);yylval.string=strdup(yytext);return OB3;}
\]                                {fprintf(lexer,"CLOSEBRAC : %s\n",yytext);yylval.string=strdup(yytext);return CB3;}
\+                                {fprintf(lexer,"PLUS : %s\n",yytext);yylval.string=strdup(yytext);return PLUS;}
-                                 {fprintf(lexer,"SUB : %s\n",yytext);yylval.string=strdup(yytext);return SUB;}
\/                                {fprintf(lexer,"DIV : %s\n",yytext);yylval.string=strdup(yytext);return DIV;}
\*                                {fprintf(lexer,"MUL : %s\n",yytext);yylval.string=strdup(yytext);return MUL;}
\;                                {fprintf(lexer,"SEMI : %s\n",yytext);yylval.string=strdup(yytext);return SEMI;}
,                                 {fprintf(lexer,"COMMA : %s\n",yytext);yylval.string=strdup(yytext);return COMMA;}
(\<\<|\>\>)                       {fprintf(lexer,"SHIFT : %s\n",yytext);yylval.string=strdup(yytext);return SHIFT;}
(\<|\>|\<=|\>=)                   {fprintf(lexer,"COMPARE : %s\n",yytext);yylval.string=strdup(yytext);return COMPARE;}
[ \t]                             /* Ignoring Newline, Tab and Whitespace*/
\n                                {yylineno++;}
.                                 {
                                    fprintf(lexer,"Line number %d: Lexical error, there is an undefined token in input: %s\n", yylineno, yytext);
                                  }
%%
