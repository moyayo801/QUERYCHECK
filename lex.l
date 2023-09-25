%{
 #include<stdio.h>
 #include "string.h"
 #include "stdlib.h"
 #include "syn.tab.h"

 extern YYSTYPE yylval;
%}



%%


SELECT     { return SELECT; }
FROM       { return FROM; }
WHERE      { return WHERE; }
AND        { return AND; }
OR         { return OR; }
INSERT    { return INSERT; }
INTO      { return INTO; }
VALUES    { return VALUES; }
JOIN      { return JOIN; }
ON        { return ON; }
GROUP     { return GROUP; }
BY        { return BY; }
INNER       { return INNER; }
UPDATE        { return UPDATE; }
SET        { return SET; }
COUNT        { return COUNT; }
ORDER        { return ORDER; }
ASC        { return ASC; }
DESC        { return DESC; }
IN        { return IN; }
DISTINCT        { return DISTINCT; }
"="        { return eg; }
"*"   { return etoi; }
"("   { return  prO;}
")"   { return  prf;}
"]"   {return brf;}
"["   {return bro;}
"/"   {return ter;}

">" 	  { return SUPP;}
"<" 	  { return INF;}
"==" 	  { return EGALE;}
"!=" 	  { return NONEGALE;}
">=" 	  { return SUPEGALE;}
"<=" 	  { return INFEGALE;}
","        { return ver;}
";"        { return pv;}

"\"[^\"]+\"" { yylval.string_value = strdup(yytext); return IDENTIFIER; }
"\'[^\"]+\'" { yylval.string_value = strdup(yytext); return IDENTIFIER; }
[a-zA-Z_][a-zA-Z0-9_.]*   { yylval.string_value = strdup(yytext); return IDENTIFIER; }
[0-9]+   { yylval.int_value = atoi(yytext); return INTEGER; }
[0-9]+\.[0-9]+   { yylval.double_value = atof(yytext); return DECIMAL; }
'[^']*'   { yylval.string_value = strdup(yytext); return STRING; }
[ \t\n]+  {} 
.     {printf("Erreur lexical entite %s \n", yytext);}




