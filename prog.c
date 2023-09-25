#include <stdio.h>
#include <stdbool.h>
#include <string.h>


int main ()
{ 	       FILE* src=fopen("ex.txt", "r");
 
           
           char buffer[1024];
           while(fgets(buffer, 1024, src) != NULL){
           FILE* in=fopen("in.txt", "w+");
           fputs(buffer,in);
           fclose(in); 
           system("flex lex.l");
           system("bison -d syn.y");
           system("gcc syn.tab.c lex.yy.c -lfl -ly");
           system(".\\a.exe");
  }
           



           
           
           fclose(src);
           
  return 0;      

}
