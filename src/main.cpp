#include <iostream>
#include <string>
#include <cstdio>
#include "token.h"

/* Add all extern variables here */
int yyparse(void);
extern int yydebug;
extern FILE *yyin, *yyout;

int main(int argc, char *argv[]) {
    std::string exec_name = argv[0];
    std::string usage = "Usage: " + exec_name + " [input_file] [output_file]\n";
    argv++, argc--;
    if(argc != 3) {
        std::cerr << exec_name << ": Error: " << usage;
        exit(1);
    }
    char *input_file_name = argv[0], *output_file_name = argv[1];
    int verbose = atoi(argv[2]);

    if(verbose) yydebug = 1;

    FILE *input_file = fopen(input_file_name, "r");
    if(input_file == NULL) {
        std::cerr << exec_name << ": Error: Input file " << input_file_name << " not found...\n";
        exit(1);
    }
    yyin = input_file;
    freopen(output_file_name, "w", stdout);
    yyparse();
    return 0;
}
