# Created by: Michael Grünewald <michipili@gmail.com>
# $FreeBSD$

PORTNAME=	labltk
PORTVERSION=	8.06.0
CATEGORIES=	x11-toolkits
MASTER_SITES=	https://forge.ocamlcore.org/frs/download.php/1455/
PKGNAMEPREFIX=	ocaml-

MAINTAINER=	michipili@gmail.com
COMMENT=	Objective Caml interface to Tk

LICENSE=	LGPL20

USES=		gmake
HAS_CONFIGURE=	yes
MAKE_ENV+=	STAGEDIR="${STAGEDIR}"

CONFIGURE_ARGS+=	-installdir "${STAGEDIR}${PREFIX}/lib/ocaml/labltk"
CONFIGURE_ARGS+=	-installbindir "${STAGEDIR}${PREFIX}/bin"

pre-install:
	@${MKDIR} "${STAGEDIR}${PREFIX}/lib/ocaml"
	@${MKDIR} "${STAGEDIR}${PREFIX}/lib/ocaml/stublibs"

.include <bsd.port.mk>
