#	@(#)Makefile	8.1 (Berkeley) 5/31/93

PROG=	robots
CFLAGS+=-DMAX_PER_UID=5 -DOLD_CURSES
SRCS=	extern.c init_field.c main.c make_level.c move.c move_robs.c \
	play_level.c query.c rnd_pos.c score.c flush_in.c
MAN6=	robots.0
DPADD=	${LIBOCURSES} ${LIBTERM} ${LIBCOMPAT}
LDADD=	-locurses -ltermlib -lcompat
HIDEGAME=hidegame

beforeinstall:
	install -c -o ${BINOWN} -g ${BINGRP} -m 600 /dev/null \
	    ${DESTDIR}/var/games/robots_roll

.include <bsd.prog.mk>
