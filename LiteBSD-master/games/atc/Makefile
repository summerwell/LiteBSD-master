#	@(#)Makefile	8.1 (Berkeley) 5/31/93

PROG=	atc
CFLAGS+=-DBSD -I${.CURDIR} -I. -DOLD_CURSES
SRCS=	extern.c grammar.c graphics.c input.c lex.c list.c log.c \
	main.c tunable.c update.c
MAN6=	atc.0
DPADD=	${usr/lib/libl.a ${LIBM} ${LIBTERM} ${LIBOCURSES} ${LIBCOMPAT}
LDADD=	-ll -lm -locurses -ltermcap -lcompat
GAMES=	ATC_scores Game_List Killer crossover default easy game_2
CLEANFILES=grammar.c y.tab.h lex.c
HIDEGAME=hidegame

beforeinstall: 
	(cd ${.CURDIR}/games; install -c -o ${BINOWN} -g ${BINGRP} -m 400 \
	    ${GAMES} ${DESTDIR}/usr/share/games/atc)

.include <bsd.prog.mk>
