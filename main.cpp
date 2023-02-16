#include <iostream>
#include <string>

extern "C" {
    int yyparse(void);
}
/* Add all extern variables here */

extern int yydebug;

int main(int argc, char *argv[]) {
    yydebug = 1;
    std::string exec_name = argv[0];
    std::string usage = "Usage: " + exec_name + " < (input_file) > (output_file)\n";
    yyparse();
    return 0;
}
