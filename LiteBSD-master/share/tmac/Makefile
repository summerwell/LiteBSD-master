#	@(#)Makefile	8.1 (Berkeley) 6/8/93

FILES=	tmac.andoc tmac.s tmac.e
MSRCS=  doc doc-ditroff doc-common doc-nroff doc-syms

LINKS=	${BINDIR}/tmac/tmac.andoc ${BINDIR}/tmac/tmac.an
NOOBJ=	noobj

# old macros not currently installed...
# OFILES=	tmac.a tmac.cp tmac.r

all clean cleandir depend lint tags:

beforeinstall:
	install -d ${DESTDIR}${BINDIR}/tmac
	for i in ${MSRCS}; do \
		rm -f ${DESTDIR}${BINDIR}/tmac/tmac.$$i; \
		sed -f strip.sed < $$i > ${DESTDIR}${BINDIR}/tmac/tmac.$$i; \
		chmod 444 ${DESTDIR}${BINDIR}/tmac/tmac.$$i; \
	done
	install -c -m 444 ${FILES} ${DESTDIR}${BINDIR}/tmac


.include <bsd.prog.mk>
