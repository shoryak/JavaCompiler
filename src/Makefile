CC = g++
CFLAGS = -g -std=c++2a -Wall
OBJS = lexer.o parser.o symbol_table.o 3ac.o main.o
TEST_OBJS = lexer.o parser.o symbol_table.o 3ac.o test.o

# Source files
LEXER_SRC = lexer.l
PARSER_SRC = parser.y
3AC_SRC = 3ac.cpp

# Executible files for different stage outputs
ASTGEN_EXEC = ASTGen.out
3ACGEN_EXEC = 3ACGen.out
TEST_EXEC = test.out

BIN = ../bin

3acgen:			$(OBJS)
				$(CC) $(CFLAGS) $(OBJS) -o $(BIN)/$(3ACGEN_EXEC)

test:			$(TEST_OBJS)
				$(CC) $(CFLAGS) $(TEST_OBJS) -o $(BIN)/$(TEST_EXEC)

astgen:			$(OBJS)
				$(CC) $(CFLAGS) $(OBJS) -o $(BIN)/$(ASTGEN_EXEC)

test.o:			test.cpp
				$(CC) $(CFLAGS) -c test.cpp -o test.o

lexer.o:		lex.yy.c token.h
				$(CC) $(CFLAGS) -c lex.yy.c -o lexer.o

lex.yy.c:		$(LEXER_SRC)
				flex $(LEXER_SRC)

parser.o:		parser.tab.c
				$(CC) $(CFLAGS) -c parser.tab.c -o parser.o

parser.tab.c token.h:	$(PARSER_SRC)
						bison -dvt $(PARSER_SRC)
						cmp -s parser.tab.h token.h || cp parser.tab.h token.h

3ac.o:			$(3AC_SRC)
				$(CC) $(CFLAGS) -c $(3AC_SRC) -o 3ac.o

main.o:			main.cpp token.h
				$(CC) $(CFLAGS) -c main.cpp -o main.o

clean:
				rm -f $(BIN)/$(ASTGEN_EXEC) $(BIN)/$(3ACGEN_EXEC) $(BIN)/$(TEST_EXEC)
				rm -f *.out *.o *.output *.tab.* lex.yy.c *.svg *.ps *.dot token.h
