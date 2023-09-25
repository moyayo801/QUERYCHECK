%{
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
extern FILE* yyin;
void exitProgram();
void deleteLine(FILE *src, FILE *temp, const int line);
void reset_parser(FILE *src);
%}
%union {
    char*  string_value; // Pour les chaînes de caractères
    int    int_value;      // Pour les entiers
    double double_value; // Pour les décimaux
}

%token SELECT FROM WHERE AND OR INSERT INTO VALUES JOIN ON GROUP BY prO prf brf bro etoi UPDATE SET eg INNER COUNT ORDER ASC DESC 
%token IDENTIFIER INTEGER DECIMAL STRING ver EGALE SUPP INF NONEGALE SUPEGALE INFEGALE pv '\n\n' ter IN DISTINCT






%%
query : sql_stmt
       | sql_stmt ter query
       ;

sql_stmt : select_stmt
         | insert_stmt
         | update_stmt
         ;

select_stmt : SELECT select_list FROM table_list join_clause where_clause group_by_clause order_by_clause pv ter
              {
      printf("\n\nLa requete est syntaxiquement correcte\n\n");
      YYACCEPT;
              }
              |SELECT select_list FROM table_list join_clause where_clause group_by_clause error ter{
                fprintf(stderr,"\n\nPoint vergule n'existe pas \n\n");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
              }
              |SELECT select_list error{
                fprintf(stderr,"\n\nLe mot cle 'FROM' n'existe pas \n\n");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
              }
               |SELECT error{
                fprintf(stderr,"\n\n'Nom de la table (ou (*)) ' n'existe pas \n\n\n\n");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
              }
               |select_list error FROM  {
                fprintf(stderr,"\n\n'Le mot cle SELECT OR UPDATE' n'existe pas \n\n");
                yyerrok;
                                
                                YYABORT;
                exitProgram();
              }
               | SELECT select_list FROM error{
                fprintf(stderr,"\n\n'Le nom de la table ' n'existe pas \n\n");
                yyerrok;
                                
                                YYABORT;
                exitProgram();
              }
            
            ;
update_stmt : UPDATE IDENTIFIER SET IDENTIFIER eg INTEGER where_clause pv ter
              {
      printf("\n\nLa requete est syntaxiquement correcte\n\n\n\n");
      YYACCEPT;
              }
             |UPDATE error{
               fprintf(stderr,"\n\nNOM DE La TABLE n'existe pas \n\n ");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
             }
             |UPDATE IDENTIFIER error{
               fprintf(stderr,"\n\nLe mot cle 'SET' n'existe pas \n\n ");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
             }
              |UPDATE IDENTIFIER SET IDENTIFIER error{
               fprintf(stderr,"\n\nLe mot cle '=' n'existe pas \n\n ");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
             }
                |UPDATE IDENTIFIER SET  error{
               fprintf(stderr,"\n\nNOM de la column n'existe pas \n\n ");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
             }
               |UPDATE IDENTIFIER SET IDENTIFIER eg error{
               fprintf(stderr,"\n\nVous avez besoin d'une valeur entier \n\n ");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
             }
                |UPDATE IDENTIFIER SET IDENTIFIER eg INTEGER where_clause error ter{
               fprintf(stderr,"\n\nPoint vergule n'existe pas \n\n ");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
             }
            ;

insert_stmt : INSERT INTO IDENTIFIER prO column_list prf VALUES prO value_list prf pv ter
              {
      printf("\n\nLa requete est syntaxiquement correcte\n\n");
      YYACCEPT;
              }
             |INSERT error{
               fprintf(stderr,"Le mot cle 'INTO' n'existe pas \n\n");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
             }
            | error INTO{
               fprintf(stderr,"\n\nLe mot cle 'INSERT' n'existe pas\n\n ");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
             }
             |INSERT INTO IDENTIFIER prO column_list prf VALUES error{
               fprintf(stderr,"\n\nVerifie syntax apres VALUES\n\n ");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
             }
            ;

where_clause :WHERE condition
             | /* empty */
             |condition error{
                         fprintf(stderr,"\n\nLe mot cle 'WHERE' n'existe pas \n\n");
                                                                yyerrok;
                                YYABORT;
                exitProgram();        
               

             }
             |WHERE error{
              fprintf(stderr,"\n\n'La Condition de WHERE' n'existe pas \n\n");
                                                                yyerrok;
                                
                                YYABORT;
                                exitProgram();
                
             }
             ;

group_by_clause : GROUP BY column_list
                | /* empty */
                |GROUP error{
               fprintf(stderr,"\n\n'MOT CLE BY' n'existe pas \n\n");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
             }
                   |BY error  {
                   fprintf(stderr,"\n\n'MOT CLE GROUP' n'existe pas \n\n");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
             }
                ;
order_by_clause : ORDER BY IDENTIFIER TYPE
                | /* empty */
                |ORDER error{
               fprintf(stderr,"'MOT CLE BY' n'existe pas \n\n");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
             }
                 |error BY  {
                   fprintf(stderr,"'MOT CLE ORDER' n'existe pas \n\n");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
             }
                |ORDER BY error {
                   fprintf(stderr,"'NOM DE LA COLUMN' n'existe pas \n\n");
                                                                yyerrok;
                                YYABORT;
                exitProgram();
             }
                ;
TYPE : ASC 
      |DESC
      |
      ;

join_clause :INNER JOIN table_list ON expr
            | /* empty */
            |INNER JOIN table_list error expr{
               fprintf(stderr,"\n\nLe mot cle 'ON' n'existe pas \n\n");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
             }
             |INNER error table_list ON expr {
               fprintf(stderr,"\n\nLe mot cle 'JOIN' n'existe pas \n\n");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
                
             }
              | JOIN error table_list ON expr {
               fprintf(stderr,"\n\nLe mot cle 'INNER' n'existe pas \n\n");
                                                                yyerrok;
                                
                                YYABORT;
                exitProgram();
             }
            ;

select_list : column_list
            | etoi  /* for selecting all columns */
            | DISTINCT column_list
            ;
table_list : IDENTIFIER ver table_list
            | IDENTIFIER
            ;

column_list : IDENTIFIER ver column_list
            | IDENTIFIER
            |COUNT prO etoi prf 
            | COUNT prO IDENTIFIER prf
            ;

value_list : value ver value_list
           | value
           ;

value : IDENTIFIER
      | INTEGER
      | DECIMAL
      | STRING
      | expr
      | prO select_stmt prf pv
      ;

expr : IDENTIFIER EGALE IDENTIFIER
      |IDENTIFIER eg IDENTIFIER
     ;
 
condition: IDENTIFIER logique value
           | prO condition OR condition prf
           |prO condition AND condition prf
;
logique:   SUPP
	         |INFEGALE
           |SUPEGALE
           |INF
           |EGALE
           |NONEGALE
           |eg
           |IN
; 

%%
int main ()
{ 		yyin = fopen("in.txt", "r");
	yyparse ();
	fclose (yyin);
           

   
/*    FILE *temp;
   int line;


      do{ 
       yyin = fopen("in.txt", "r");
      temp = fopen("delete.txt", "w");
      yyparse();
      fseek(yyin,0,SEEK_END);
      line = ftell(yyin);
       
        // Move yyin file pointer to beginning
   rewind(yyin);
   // Delete given line from file.
   deleteLine(yyin, temp, 1);

   fclose(yyin);
   fclose(temp);

   remove("in.txt");
   rename("delete.txt", "in.txt");
 

   fclose(yyin);

      }while(line != 0); */


   




  return 0;      

}
int yyerror(const char *s){
      
        return 0;
}
void exitProgram(){
  printf("\n\nPlease fix the issue with the requet and try again ..\n\n\n\n");
  
}
void deleteLine(FILE *file, FILE *temp, const int line){
   char buffer[1024];
   int count = 1;
   while ((fgets(buffer, 1024, file)) != NULL){
      if (line != count)
         fputs(buffer, temp);
      count++;
   }
}
void reset_parser(FILE* input_file){
   yyrestart(input_file);
   yyparse();
}