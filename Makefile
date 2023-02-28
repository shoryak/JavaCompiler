CC = g++
CFLAGS = -g -std=c++2a -Wall
OBJS = bison.o lex.o main.o
OBJS_DEBUG = bison_debug.o lex.o main.o
LEXER = lexer.l
PARSER = parser.y
EXEC = parser.out
EXEC_DEBUG = parser_debug.out
EXEC_TEST = parser_test.out

parser:			$(OBJS)
				$(CC) $(CFLAGS) $(OBJS) -o $(EXEC)

debug:			$(OBJS_DEBUG)
				$(CC) $(CFLAGS) $(OBJS_DEBUG) -o $(EXEC_DEBUG)

lex.o:			lex.yy.c
				$(CC) $(CFLAGS) -c lex.yy.c -o lex.o

lex.yy.c:		$(LEXER)
				flex $(LEXER)

bison.o:		parser.tab.c
				$(CC) $(CFLAGS) -c parser.tab.c -o bison.o

bison_debug.o:	parser_debug.tab.c
				$(CC) $(CFLAGS) -c parser_debug.tab.c -o bison_debug.o

parser.tab.c:	$(PARSER)
				bison -d $(PARSER)
				cmp -s parser.tab.h token.h || cp parser.tab.h token.h

parser_debug.tab.c:	$(PARSER)
					bison -dvt $(PARSER) -o parser_debug.tab.c
					cmp -s parser_debug.tab.h token.h || cp parser_debug.tab.h token.h

main.o:			main.cpp
				$(CC) $(CFLAGS) -c main.cpp -o main.o

test:			test.o
				$(CC) $(CFLAGS) test.o -o $(EXEC_TEST)

test.o:			test.cpp
				$(CC) $(CFLAGS) -c test.cpp test.o

lex.o main.o:	token.h

clean:
				rm -f $(EXEC) $(EXEC_TEST) *.o *.output *.tab.* lex.yy.c *.svg *.ps *.dot
