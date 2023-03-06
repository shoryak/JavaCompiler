CC = g++
CFLAGS = -g -std=c++2a -Wall
OBJS = bison.o lex.o main.o
LEXER_L = lexer.l
PARSER_Y = parser.y
ASTGEN_EXEC = ASTGen.out
BIN = ../bin

astgen:			$(OBJS)
				$(CC) $(CFLAGS) $(OBJS) -o $(BIN)/$(ASTGEN_EXEC)

lex.o:			lex.yy.c
				$(CC) $(CFLAGS) -c lex.yy.c -o lex.o

lex.yy.c:		$(LEXER_L)
				flex $(LEXER_L)

bison.o:		parser.tab.c
				$(CC) $(CFLAGS) -c parser.tab.c -o bison.o

parser.tab.c:	$(PARSER_Y)
				bison -dvt $(PARSER_Y)
				cmp -s parser.tab.h token.h || cp parser.tab.h token.h

lex.o main.o:	token.h

main.o:			main.cpp
				$(CC) $(CFLAGS) -c main.cpp -o main.o

clean:
				rm -f $(BIN)/$(ASTGEN_EXEC)
				rm -f *.out *.o *.output *.tab.* lex.yy.c *.svg *.ps *.dot
