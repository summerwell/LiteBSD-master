#	@(#)bsd.prog.mk	8.2 (Berkeley) 4/2/94

.if !defined(NOINCLUDE) && exists(${.CURDIR}/../Makefile.inc)
.include "${.CURDIR}/../Makefile.inc"
.endif

.SUFFIXES: .out .o .c .y .l .s .8 .7 .6 .5 .4 .3 .2 .1 .0

.8.0 .7.0 .6.0 .5.0 .4.0 .3.0 .2.0 .1.0:
	nroff -man ${.IMPSRC} > ${.TARGET}

CFLAGS+=${COPTS}

#STRIP?=	-s

BINGRP?=	bin
BINOWN?=	bin
BINMODE?=	555

LIBC?=		${DESTDIR}/usr/lib/libc.a
LIBCOMPAT?=	${DESTDIR}/usr/lib/libcompat.a
LIBCURSES?=	${DESTDIR}/usr/lib/libcurses.a
LIBDBM?=	${DESTDIR}/usr/lib/libdbm.a
LIBDES?=	${DESTDIR}/usr/lib/libdes.a
LIBL?=		${DESTDIR}/usr/lib/libl.a
LIBKDB?=	${DESTDIR}/usr/lib/libkdb.a
LIBKRB?=	${DESTDIR}/usr/lib/libkrb.a
LIBKVM?=	${DESTDIR}/usr/lib/libkvm.a
LIBM?=		${DESTDIR}/usr/lib/libm.a
LIBMP?=		${DESTDIR}/usr/lib/libmp.a
LIBNCURSES?=	${DESTDIR}/usr/lib/libncurses.a
LIBOCURSES?=	${DESTDIR}/usr/lib/libocurses.a
LIBPC?=		${DESTDIR}/usr/lib/libpc.a
LIBPLOT?=	${DESTDIR}/usr/lib/libplot.a
LIBRESOLV?=	${DESTDIR}/usr/lib/libresolv.a
LIBRPC?=	${DESTDIR}/usr/lib/librpc.a
LIBTERM?=	${DESTDIR}/usr/lib/libtermcap.a
LIBUTIL?=	${DESTDIR}/usr/lib/libutil.a

.if defined(SHAREDSTRINGS)
CLEANFILES+=strings
.c.o:
	${CC} -E ${CFLAGS} ${.IMPSRC} | xstr -c -
	@${CC} ${CFLAGS} -c x.c -o ${.TARGET}
	@rm -f x.c
.endif

.if defined(PROG)
.if defined(SRCS)

OBJS+=  ${SRCS:R:S/$/.o/g}

${PROG}: ${OBJS} ${LIBC} ${DPADD}
	${CC} ${LDFLAGS} -o ${.TARGET} ${OBJS} ${LDADD} -lc -lgcc

.else defined(SRCS)

SRCS= ${PROG}.c

${PROG}: ${SRCS} ${LIBC} ${DPADD}
	${CC} ${CFLAGS} ${LDFLAGS} \
            -o ${.TARGET} ${.CURDIR}/${SRCS} ${LDADD} -lc -lgcc

MKDEP=	-p

.endif

.if	!defined(MAN1) && !defined(MAN2) && !defined(MAN3) && \
	!defined(MAN4) && !defined(MAN5) && !defined(MAN6) && \
	!defined(MAN7) && !defined(MAN8) && !defined(NOMAN)
MAN1=	${PROG}.0
.endif
.endif
.if !defined(NOMAN)
MANALL=	${MAN1} ${MAN2} ${MAN3} ${MAN4} ${MAN5} ${MAN6} ${MAN7} ${MAN8}
.else
MANALL=
.endif
manpages: ${MANALL}

_PROGSUBDIR: .USE
.if defined(SUBDIR) && !empty(SUBDIR)
	@for entry in ${SUBDIR}; do \
		(echo "===> $$entry"; \
		if test -d ${.CURDIR}/$${entry}.${MACHINE}; then \
			${MAKE} -C ${.CURDIR}/$${entry}.${MACHINE} ${.TARGET:S/realinstall/install/:S/.depend/depend/}; \
		else \
			${MAKE} -C ${.CURDIR}/$${entry} ${.TARGET:S/realinstall/install/:S/.depend/depend/}; \
		fi); \
	done
.endif

.if !target(all)
.MAIN: all
all: ${PROG} ${MANALL} _PROGSUBDIR
.endif

.if !target(clean)
clean: _PROGSUBDIR
	rm -f a.out [Ee]rrs mklog ${PROG}.core ${PROG} ${OBJS} ${CLEANFILES}
.endif

.if !target(cleandir)
cleandir: _PROGSUBDIR
	rm -f a.out [Ee]rrs mklog ${PROG}.core ${PROG} ${OBJS} ${CLEANFILES}
	rm -f .depend ${MANALL}
.endif

# some of the rules involve .h sources, so remove them from mkdep line
.if !target(depend)
depend: .depend _PROGSUBDIR
.depend: ${SRCS}
.if defined(PROG)
	${BSDSRC}/admin/build/mkdep ${MKDEP} ${CFLAGS:M-[ID]*} ${.ALLSRC:M*.c}
.endif
.endif

.if !target(install)
.if !target(beforeinstall)
beforeinstall:
.endif
.if !target(afterinstall)
afterinstall:
.endif

realinstall: _PROGSUBDIR
.if defined(PROG)
	install -d ${DESTDIR}${BINDIR}
	@rm -f ${DESTDIR}${BINDIR}/${PROG}
	install ${STRIP} -m ${BINMODE} \
	    ${INSTALLFLAGS} ${PROG} ${DESTDIR}${BINDIR}/${PROG}
.endif
.if defined(HIDEGAME)
	(cd ${DESTDIR}/usr/games; rm -f ${PROG}; ln -s dm ${PROG}; \
	    chown games.bin ${PROG})
.endif
.if defined(LINKS) && !empty(LINKS)
	@set ${LINKS}; \
	while test $$# -ge 2; do \
		l=${DESTDIR}$$1; shift; \
		t=${DESTDIR}$$1; shift; \
		echo $$t -\> $$l; \
		rm -f $$t; \
		ln $$l $$t; \
	done; true
.endif

install: afterinstall maninstall
afterinstall: realinstall
realinstall: beforeinstall
.endif

.if !target(lint)
lint: ${SRCS} _PROGSUBDIR
.if defined(PROG)
	@${LINT} ${LINTFLAGS} ${CFLAGS} ${.ALLSRC} | more 2>&1
.endif
.endif

.if !target(obj)
.if defined(NOOBJ)
obj: _PROGSUBDIR
.else
obj: _PROGSUBDIR
	@cd ${.CURDIR}; rm -rf obj; \
	here=`pwd`; dest=${DESTDIR}/usr/obj/`echo $$here | sed 's,/.*/src/,,'`; \
	echo "$$here -> $$dest"; ln -s $$dest obj; \
	if test -d ${DESTDIR}/usr/obj -a ! -d $$dest; then \
		mkdir -p $$dest; \
	else \
		true; \
	fi;
.endif
.endif

.if !target(objdir)
.if defined(NOOBJ)
objdir: _PROGSUBDIR
.else
objdir: _PROGSUBDIR
	@cd ${.CURDIR}; \
	here=`pwd`; dest=${DESTDIR}/usr/obj/`echo $$here | sed 's,/.*/src/,,'`; \
	if test -d ${DESTDIR}/usr/obj -a ! -d $$dest; then \
		mkdir -p $$dest; \
	else \
		true; \
	fi;
.endif
.endif

.if !target(tags)
tags: ${SRCS} _PROGSUBDIR
.if defined(PROG)
	-ctags -f /dev/stdout ${.ALLSRC} | \
	    sed "s;${.CURDIR}/;;" > ${.CURDIR}/tags
.endif
.endif

.if !defined(NOMAN)
.include <bsd.man.mk>
.else
maninstall:
.endif