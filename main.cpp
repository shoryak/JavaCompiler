#include <iostream>
#include <string>
#include "token.h"

/* Add all extern variables here */
int yyparse(void);
extern int yydebug;


int main(int argc, char *argv[]) {
    #ifdef YYDEBUG
        yydebug = 1;
    #endif
    std::string exec_name = argv[0];
    std::string usage = "Usage: " + exec_name + " < (input_file) > (output_file)\n";
    yyparse();
    
    return 0;
}
