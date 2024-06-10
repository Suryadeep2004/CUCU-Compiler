%{
#include <stdio.h>
#include <string.h>
extern FILE * yyin;
int yylex(void);
int yyparse(void);

FILE *lexer;
FILE *parser;

void yyerror(char *s)
{
	fprintf(parser,"error: %s\n",s);
}

%}

%union 
{
    int number;
    char *string;
}

%token <string> ITYPE CTYPE STRING BITOPERATOR ASSIGN PLUS SUB DIV MUL SEMI COMMA RETURN IF WHILE OB1 OB2 OB3 CB1 CB2 CB3 ELSE EQUAL NOTEQUAL SHIFT COMPARE ID
%token <number> NUM

%left ASSIGN
%left EQUAL NOTEQUAL
%left PLUS ADD
%left MUL DIV

%%
master: master program|program;

program : function_definition| variable_declaration | function_declaration ;

variable_declaration : ITYPE ID SEMI                                              {fprintf(parser,"global variable : %s ,type : %s\n\n",$2,$1);}
                       | ITYPE ID ASSIGN expression SEMI                          {fprintf(parser,"= var-%s\nglobal variable : %s ,type : %s\n\n",$2,$2,$1);}
					   | CTYPE ID SEMI                                            {fprintf(parser,"global variable : %s ,type : %s\n\n",$2,$1);}
                       | CTYPE ID ASSIGN STRING SEMI                              {fprintf(parser,"%s = var-%s\nglobal variable : %s ,type : %s\n\n",$4,$2,$2,$1);}
					   ;

function_declaration : ITYPE ID OB1 function_parameter CB1 SEMI                    {fprintf(parser,"function-name : %s , type: %s\n\n",$2,$1);}
                       | CTYPE ID OB1 function_parameter CB1 SEMI                  {fprintf(parser,"function-name : %s , type: %s\n\n",$2,$1);}
                       ;

function_definition  : ITYPE ID OB1 function_parameter CB1 OB2 function_body CB2   {fprintf(parser,"FUNCTION-BODY END\nfunction-name : %s , type: %s\n\n",$2,$1);}
                       | CTYPE ID OB1 function_parameter CB1 OB2 function_body CB2 {fprintf(parser,"FUNCTION-BODY END\nfunction-name : %s , type: %s\n\n",$2,$1);}
                       ; 

function_parameter : function_parameter COMMA ITYPE ID  {fprintf(parser,"function-parameter : %s \n",$4);}
                  | function_parameter COMMA CTYPE ID   {fprintf(parser,"function-parameter : %s \n",$4);}
                  | ITYPE ID                            {fprintf(parser,"function-parameter : %s \n",$2);}
				  | CTYPE ID                            {fprintf(parser,"function-parameter : %s \n",$2);}
				  |
			      ;

statement: ITYPE ID ASSIGN expression SEMI                      {fprintf(parser,"= var-%s\nlocal variable : %s , type: %s\n",$2,$2,$1);}
        | CTYPE ID ASSIGN STRING SEMI                           {fprintf(parser,"%s = var-%s\nlocal variable : %s , type: %s\n",$4,$2,$2,$1);}
	    | ITYPE ID SEMI                                         {fprintf(parser,"local variable : %s , type: %s\n",$2,$1);}
		| CTYPE ID SEMI                                         {fprintf(parser,"local variable : %s , type: %s\n",$2,$1);}
	    | ID ASSIGN expression SEMI                             {fprintf(parser,"= var-%s\n",$1);}
		| ID ASSIGN STRING SEMI                                 {fprintf(parser,"%s = var-%s\n",$3,$1);}
		| ID OB3 expression CB3 ASSIGN expression SEMI          {fprintf(parser,"= [] var-%s\n",$1);}
		| ID OB1 expression_list CB1 SEMI                       {fprintf(parser,"FUNCTION ARGUMENT END\nfunction-name : %s \n",$1);}
	    | RETURN expression SEMI                                {fprintf(parser,"%s \n",$1);}
	    | IF OB1 expression CB1 OB2 function_body CB2 else      {fprintf(parser,"IF-COND \n");}
	    | WHILE OB1 expression CB1 OB2 function_body CB2        {fprintf(parser,"WHILE-COND \n");}
		;

else: ELSE OB2 function_body CB2    {fprintf(parser,"ELSE-COND \n");}
      | 
	  ;


function_body: function_body statement 
               | statement             
			   ; 

expression_list: expression_list COMMA expression      {fprintf(parser,": function-argument \n");}
           | expression_list COMMA STRING              {fprintf(parser,"%s : function-argument \n",$3);}
           | expression                                {fprintf(parser,": function-argument \n");}
		   | STRING                                    {fprintf(parser,"%s : function-argument \n",$1);}
		   |
		   ;

expression: bitoperator_expression 
      | bitoperator_expression ASSIGN expression {fprintf(parser,"%s ",$2);}
	  ; 

bitoperator_expression : valuecomp_expression
		     | bitoperator_expression BITOPERATOR valuecomp_expression {fprintf(parser,"%s ",$2);}
			 ;
		     
valuecomp_expression : relational_expression
		   | valuecomp_expression EQUAL relational_expression     {fprintf(parser,"%s ",$2);}
		   | valuecomp_expression NOTEQUAL relational_expression  {fprintf(parser,"%s ",$2);}
		   ;
		   
relational_expression : shiftoperator_expression
		      | relational_expression COMPARE shiftoperator_expression   {fprintf(parser,"%s ",$2);}
			  ;
		      
shiftoperator_expression : addsubtract_expression
		   | shiftoperator_expression SHIFT addsubtract_expression       {fprintf(parser,"%s ",$2);}
		   ;
		   
addsubtract_expression : dividemultiply_expression
         | addsubtract_expression PLUS dividemultiply_expression   {fprintf(parser,"%s ",$2);}
		 | addsubtract_expression SUB dividemultiply_expression    {fprintf(parser,"%s ",$2);}
         ;

dividemultiply_expression: prefinal_expression
               | dividemultiply_expression DIV prefinal_expression    {fprintf(parser,"%s ",$2);}
		       | dividemultiply_expression MUL prefinal_expression    {fprintf(parser,"%s ",$2);}
			   ;

prefinal_expression : final_expression
             | prefinal_expression OB3 expression CB3       {fprintf(parser,"[] ");}
		     | prefinal_expression OB1 expression_list CB1  {fprintf(parser,"() ");}
			 ;
		     
final_expression : NUM                   {fprintf(parser,"const-%d ",$1);}
                 | ID                   {fprintf(parser,"var-%s ",$1);}
				 | OB1 expression CB1   {fprintf(parser,"() ");}
				 ; 
	    
%%


int yywrap()
{
	return 1;
}

int main(int argc, char *argv[])
{   
	yyin = fopen(argv[1], "r");
    lexer = fopen("Lexer.txt", "w");
	parser = fopen("Parser.txt", "w");

	yyparse();

	fclose(yyin);
    fclose(lexer);
	fclose(parser);
	return 0;
}