CC = g++
CFLAGS = -g -std=c++2a -Wall
OBJS = lexer.o parser.o main.o
LEXER_L = lexer.l
PARSER_Y = parser.y
ASTGEN_EXEC = ASTGen.out
BIN = ../bin

astgen:			$(OBJS)
				$(CC) $(CFLAGS) $(OBJS) -o $(BIN)/$(ASTGEN_EXEC)

lexer.o:		lex.yy.c
				$(CC) $(CFLAGS) -c lex.yy.c -o lexer.o

lex.yy.c:		$(LEXER_L)
				flex $(LEXER_L)

parser.o:		parser.tab.c
				$(CC) $(CFLAGS) -c parser.tab.c -o parser.o

parser.tab.c:	$(PARSER_Y)
				bison -dvt $(PARSER_Y)
				cmp -s parser.tab.h token.h || cp parser.tab.h token.h

lexer.o main.o:	token.h

main.o:			main.cpp
				$(CC) $(CFLAGS) -c main.cpp -o main.o

clean:
				rm -f $(BIN)/$(ASTGEN_EXEC)
				rm -f *.out *.o *.output *.tab.* lex.yy.c *.svg *.ps *.dot
