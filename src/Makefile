CC = g++
CFLAGS = -g -std=c++2a -Wall
OBJS = bison.o lex.o main.o
LEXER = lexer.l
PARSER = parser.y
EXEC = parser.out

parser:			$(OBJS) $(OBJS_DEBUG)
				$(CC) $(CFLAGS) $(OBJS) -o $(EXEC)

lex.o:			lex.yy.c
				$(CC) $(CFLAGS) -c lex.yy.c -o lex.o

lex.yy.c:		$(LEXER)
				flex $(LEXER)

bison.o:		parser.tab.c
				$(CC) $(CFLAGS) -c parser.tab.c -o bison.o

parser.tab.c:	$(PARSER)
				bison -dvt $(PARSER)
				cmp -s parser.tab.h token.h || cp parser.tab.h token.h

main.o:			main.cpp
				$(CC) $(CFLAGS) -c main.cpp -o main.o

lex.o main.o:	token.h

clean:
				rm -f *.out *.o *.output *.tab.* lex.yy.c *.svg *.ps *.dot
