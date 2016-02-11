DIGITO			[0-9]
L			[a-zA-Z_]
E			([Ee][+-]?{DIGITO}+)
P                       ([Pp][+-]?{DIGITO}+)
FS			(f|F|l|L)
IS                      ((u|U)|(u|U)?(l|L|ll|LL)|(l|L|ll|LL)(u|U))

%{
#include <stdio.h>
#include "sintactico.tab.h"

void comentario();
void count(void);
%}

%%
"/*"			{ comentario(); }
"//"[^\n]*              { /* consume //-comentario */ }


"_Bool"			{ count(); return(BOOL); }
"break"			{ count(); return(BREAK); }
"char"			{ count(); return(CHAR); }
"const"			{ count(); return(CONST); }
"do"			{ count(); return(DO); }
"double"		{ count(); return(DOUBLE); }
"else"			{ count(); return(ELSE); }
"float"			{ count(); return(FLOAT); }
"if"			{ count(); return(IF); }
"int"			{ count(); return(INT); }
"return"		{ count(); return(RETURN); }
"void"			{ count(); return(VOID); }
"while"			{ count(); return(WHILE); }

{L}({L}|{DIGITO})*		{ count(); return(check_type()); }

0[0-7]*{IS}?		{ count(); return(CONSTANT); }
[1-9]{DIGITO}*{IS}?		{ count(); return(CONSTANT); }
L?'(\\.|[^\\'\n])+'	{ count(); return(CONSTANT); }

{DIGITO}+{E}{FS}?		{ count(); return(CONSTANT); }
{DIGITO}*"."{DIGITO}+{E}?{FS}?	{ count(); return(CONSTANT); }
{DIGITO}+"."{DIGITO}*{E}?{FS}?	{ count(); return(CONSTANT); }



L?\"(\\.|[^\\"\n])*\"	{ count(); return(STRING_LITERAL); }



"+="			{ count(); return(ADD_ASSIGN); }
"-="			{ count(); return(SUB_ASSIGN); }
"*="			{ count(); return(MUL_ASSIGN); }
"/="			{ count(); return(DIV_ASSIGN); }
"%="			{ count(); return(MOD_ASSIGN); }
">>"			{ count(); return(RIGHT_OP); }
"<<"			{ count(); return(LEFT_OP); }
"++"			{ count(); return(INC_OP); }
"--"			{ count(); return(DEC_OP); }
"->"			{ count(); return(PTR_OP); }
"&&"			{ count(); return(AND_OP); }
"||"			{ count(); return(OR_OP); }
"<="			{ count(); return(LE_OP); }
">="			{ count(); return(GE_OP); }
"=="			{ count(); return(EQ_OP); }
"!="			{ count(); return(NE_OP); }
";"				{ count(); return(';'); }
"{"				{ count(); return('{'); }
"}"				{ count(); return('}'); }
","				{ count(); return(','); }
":"				{ count(); return(':'); }
"="				{ count(); return('='); }
"("				{ count(); return('('); }
")"				{ count(); return(')'); }
"["				{ count(); return('['); }
"]"				{ count(); return(']'); }
"."				{ count(); return('.'); }
"&"				{ count(); return('&'); }
"!"				{ count(); return('!'); }
"~"				{ count(); return('~'); }
"-"				{ count(); return('-'); }
"+"				{ count(); return('+'); }
"*"				{ count(); return('*'); }
"/"				{ count(); return('/'); }
"%"				{ count(); return('%'); }
"<"				{ count(); return('<'); }
">"				{ count(); return('>'); }
"^"				{ count(); return('^'); }
"|"				{ count(); return('|'); }
"?"				{ count(); return('?'); }

[ \t\v\n\f]		{ count(); }
.			{ /* Add code to complain about unmatched characters */ }

%%

int yywrap(void)
{
	return 1;
}


void comentario(void)
{
	char c, prev = 0;
  
	while ((c = input()) != EOF)      /* (EOF maps to 0) */
	{
		if (c == '/' && prev == '*')
			return;
		prev = c;
	}
	printf("comentario incompleto");
}


int column = 0;

void count(void)
{
	int i;

	for (i = 0; yytext[i] != '\0'; i++)
		if (yytext[i] == '\n')
			column = 0;
		else if (yytext[i] == '\t')
			column += 8 - (column % 8);
		else
			column++;

	ECHO;
}


int check_type(void)
{
/*
* pseudo code --- this is what it Houses without doorsould check
*
*	if (yytext == type_name)
*		return TYPE_NAME;
*
*	return IDENTIFIER;
*/

/*
*	it actually will only return IDENTIFIER
*/

	return IDENTIFIER;
}
