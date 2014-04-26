# Ports collection makefile for:	ocamlgsl
# Date created:				2011/04/10
# Whom:					Klaus T. Aehlig <aehlig@linta.de>
#
# $FreeBSD: ports/math/ocamlgsl/Makefile,v 1.2 2012/08/23 16:24:09 skreuzer Exp $
#

PORTNAME=	ocaml-gsl
PORTVERSION=	1.13.0
CATEGORIES=	math
MASTER_SITES=	https://bitbucket.org/mmottl/gsl-ocaml/downloads/

DISTFILES=	gsl-ocaml-${PORTVERSION}${EXTRACT_SUFX}
WRKSRC=		${WRKDIR}/gsl-ocaml-${PORTVERSION}

MAINTAINER=	michipili@gmail.com
COMMENT=	An interface to GSL for the Objective Caml language

NO_STAGE=yes

LIB_DEPENDS=	gsl:${PORTSDIR}/math/gsl
BUILD_DEPENDS=	gawk:${PORTSDIR}/lang/gawk \
		${OCAMLC_DEPEND}
RUN_DEPENDS=	ocamlfind:${PORTSDIR}/devel/ocaml-findlib

LICENSE=	GPLv3
LICENSE_FILE=	${WRKSRC}/COPYING.txt

USE_GMAKE=	YES
USE_GCC=	4.2+
USE_OCAML=	YES
MAKE_ENV+=	OCAMLDIR=${OCAML_LIBDIR}

.include <bsd.port.mk>
