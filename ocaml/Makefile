# Created by: Kiriyama Kazuhiko <kiri@kiri.toba-cmt.ac.jp>
# $FreeBSD$

PORTNAME=	ocaml
PORTVERSION=	4.01.0
CATEGORIES=	lang
MASTER_SITES=	http://caml.inria.fr/pub/distrib/${DISTNAME:R}/ \
		${MASTER_SITE_GENTOO}
MASTER_SITE_SUBDIR=	distfiles
PKGNAMESUFFIX=	${SFX}
DISTFILES=	${DISTNAME}${EXTRACT_SUFX}
EXTRACT_ONLY=	${DISTNAME}${EXTRACT_SUFX}

MAINTAINER=	michipili@gmail.com
COMMENT=	The Objective Caml compiler and programming environment

LICENSE=		QPL10 LGPL20
LICENSE_COMB=		multi
LICENSE_NAME_QPL10=	Q Public License, Version 1.0
LICENSE_FILE_QPL10=	${WRKSRC}/LICENSE
LICENSE_PERMS_QPL10=	auto-accept

USE_BZIP2=	yes
REINPLACE_ARGS=	-i ""
HAS_CONFIGURE=	yes
ALL_TARGET=	world.opt
STRIP=
SSP_UNSAFE=	yes
MAKE_JOBS_UNSAFE=	yes

CONFIGURE_ARGS=	-verbose -prefix "${PREFIX}" \
		-cc "${CC} ${CFLAGS}" \
		-as "${AS} ${ASFLAGS}" \
		-aspp "${CC} -c" \
		-partialld "${LD} -r"
OPTIONS_DEFINE=	OPT_DEF THREADS TK X11
OPTIONS_DEFAULT=	THREADS TK X11
OPT_DEF_DESC=	Use system-optimized binaries by default
TK_DESC=	LablTk library (requires X11 support)

MODOPT=		camlp4o camlp4r ocamlc ocamldep ocamldoc ocamllex ocamlopt
PATTERN=	[[:space:]]*(do|then)?[[:space:]]*)(\$$\(CP\)|cp)([[:space:]]

CONFLICTS=	metaocaml-[0-9]*

NO_STAGE=	yes
.include <bsd.port.options.mk>

.if ${ARCH:Mpowerpc*}
ARCH=	power
PLIST_SUB+=	PROF="@comment "
.else
PLIST_SUB+=	PROF=""
.endif

.if ${ARCH} == sparc64
BROKEN=	ocamlc.opt seg-faults on ${ARCH}, please try to fix
.endif

.if ${PORT_OPTIONS:MDOCS}
DOCSDISTNAME=	${DISTNAME:C/([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+)/\1.\2/}
DISTFILES+=	${DOCSDISTNAME}-refman-html.tar.gz \
		${DOCSDISTNAME}-refman.ps.gz \
		${DOCSDISTNAME}-refman.pdf
EXTRACT_ONLY+=	${DOCSDISTNAME}-refman-html.tar.gz
PLIST_SUB+=	DOC=""
PORTDOCS=	htmlman ${DOCSDISTNAME}-refman.ps.gz ${DOCSDISTNAME}-refman.pdf
.else
PLIST_SUB+=	DOC="@comment "
.endif

.if ${PORT_OPTIONS:MTHREADS}
PLIST_SUB+=	THREADS=""
THR_CPP=	${PTHREAD_CFLAGS}
THR_LD=		${PTHREAD_LIBS}
.else
PLIST_SUB+=	THREADS="@comment "
THR_CPP=	#empty
THR_LD=		#empty
CONFIGURE_ARGS+=-no-pthread
.endif

.if ${PORT_OPTIONS:MX11}
PLIST_SUB+=	X11=""
USE_XORG=	x11
CONFLICTS+=	ocaml-nox11-[0-9]*
CONFIGURE_ARGS+=-x11include ${LOCALBASE}/include -x11lib ${LOCALBASE}/lib
.else
PLIST_SUB+=	X11="@comment "
SFX=		-nox11
CONFLICTS+=	ocaml-[0-9]*
CONFIGURE_ARGS+=-no-graph
.endif

.if ${PORT_OPTIONS:MTK}
. if ${PORT_OPTIONS:MEXAMPLES}
PORTEXAMPLES=	examples_camltk examples_labltk
.endif
. if ! ${PORT_OPTIONS:MX11}
IGNORE=	: TK support requires X11 support
. endif
USES+=		tk:84+
PLIST_SUB+=	TK=""
CONFIGURE_ARGS+=	-tkdefs \
			"-I${TCL_INCLUDEDIR} -I${TK_INCLUDEDIR} ${THR_CPP}" \
			-tklibs "-L${LOCALBASE}/lib -ltk${TK_VER:S|.||} \
			-ltcl${TCL_VER:S|.||} ${THR_LD}"
.else
PLIST_SUB+=	TK="@comment "
CONFIGURE_ARGS+=-no-tk
.endif

.include <bsd.port.pre.mk>
.include "${FILESDIR}/manfiles"

post-extract:
.if ${ARCH} == power
	${MV} ${WRKSRC}/asmrun/power-elf.S ${WRKSRC}/asmrun/power-bsd.S
.endif

post-patch:
	@${REINPLACE_CMD} \
		-e '\|MKLIB=|s|ar rc|${AR} rc|' \
		-e '\|RANLIB|s|ranlib|${RANLIB}|' \
		-e '\|bytecclinkopts=|s|""|"${LDFLAGS}"|' \
		-e "\|nativecclinkopts=|s|''|\"${LDFLAGS:C/-Wl,//}\"|" \
		-e '\|mksharedlib=|s|$$bytecc|& $$bytecclinkopts|' \
		-e 's|-lbfd -ldl|-lbfd $$dllib|' \
		${WRKSRC}/configure
# don't hardcode gcc for depend target
	@${REINPLACE_CMD} -e 's|gcc|$$(CC)|' \
		${WRKSRC}/*/Makefile \
		${WRKSRC}/*/*/Makefile
.if ${PORT_OPTIONS:MTK}
	@${REINPLACE_CMD} -e 's|/usr/bin/wish|${WISH}|' \
		${WRKSRC}/otherlibs/labltk/examples_labltk/hello.tcl
.endif

post-configure:
# CFLAGS safeness
	@${REINPLACE_CMD} -E \
		-e 's|(BYTECCCOMPOPTS[ \t]*=.*)|\1 ${CFLAGS} ${THR_CPP}|' \
		-e 's|(NATIVECCCOMPOPTS[ \t]*=.*)|\1 ${CFLAGS} ${THR_CPP}|' \
		-e '/^PTHREAD_LINK/s,-pthread,${THR_LD},g' \
		${WRKSRC}/config/Makefile

# INSTALL* safeness (which preserves the correct permissions despite
# user's umask(1)
	@${FIND} ${WRKDIR} -type f -name Makefile -print0 | \
		${XARGS} -0 -n 5 -x ${REINPLACE_CMD} -E \
		-e 's,\$$\(ARCH\),${ARCH:sparc64=sparc},g'	\
		-e 's,^(${PATTERN}+.*INSTALLDIR),\1\$${BSD_INSTALL_DATA} \4,' \
		-e 's,^(${PATTERN}+.*BINDIR),\1\$${BSD_INSTALL_PROGRAM} \4,' \
		-e 's,^(${PATTERN}+.*LIBDIR),\1\$${BSD_INSTALL_DATA} \4,' \
		-e 's,(${PATTERN}+.*(MANDIR|MANODIR|MANEXT)),\1\$${BSD_INSTALL_MAN} \4,'

check test: install
	@cd ${WRKSRC}/testsuite; ${RM} -f _log; for d in tests/* ; do \
	${SETENV} ${MAKE_ENV} ${MAKE_CMD} ${MAKE_ARGS} one DIR=$${d} \
	2>&1 | tee -a _log || ${TRUE} ; done ; \
	${SETENV} ${MAKE_ENV} ${MAKE_CMD} ${MAKE_ARGS} report

post-install:
	@${TOUCH} ${PREFIX}/lib/ocaml/ocamldoc/custom/.keep
.if ${PORT_OPTIONS:MTK} && ${PORT_OPTIONS:MEXAMPLES}
	@${MKDIR} ${EXAMPLESDIR}
	@(cd ${WRKSRC}/otherlibs/labltk && \
		${COPYTREE_SHARE} examples_labltk ${EXAMPLESDIR} \
		"! -name .ignore" && \
		${COPYTREE_SHARE} examples_camltk ${EXAMPLESDIR} \
		"! -name .ignore")
.endif
.if ${PORT_OPTIONS:MDOCS}
	${MKDIR} ${DOCSDIR}
	(cd ${WRKDIR} && ${COPYTREE_SHARE} htmlman ${DOCSDIR})
	${INSTALL_DATA} ${_DISTDIR}${DOCSDISTNAME}-refman.ps.gz ${DOCSDIR}
	${INSTALL_DATA} ${_DISTDIR}${DOCSDISTNAME}-refman.pdf ${DOCSDIR}
.endif

.for PROG in camlp4o.opt camlp4of.opt camlp4oof.opt camlp4orf.opt \
	camlp4r.opt camlp4rf.opt ocamlc.opt ocamldep.opt ocamldoc.opt \
	ocamllex.opt ocamlopt.opt ocamlrun ocamlyacc
	@${STRIP_CMD} ${PREFIX}/bin/${PROG}
.endfor

# Fix permissions for ld.conf
	@${CHMOD} 644 ${PREFIX}/lib/ocaml/ld.conf

# Do we want .opt version of tools to be the default ?
.if ${PORT_OPTIONS:MOPT_DEF}
. for module in ${MODOPT}
#	First, we save bytecode version
	@${MV} ${PREFIX}/bin/${module} ${PREFIX}/bin/${module}.byte

#	Next make .opt version be the default one (via link)
	@${LN} ${PREFIX}/bin/${module}.opt ${PREFIX}/bin/${module}
	@${ECHO_CMD} "bin/${module}.byte" >> ${TMPPLIST}
	@${ECHO_CMD} "@exec ${LN} %D/${module}.opt %D/${module}" >> ${TMPPLIST}
. endfor
.endif

.include <bsd.port.post.mk>
