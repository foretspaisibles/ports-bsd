# Created by: Michael Grünewald <michipili@gmail.com>
# $FreeBSD$

PORTNAME=	camlp4
PORTVERSION=	4.02.1+1
CATEGORIES=	devel
PKGNAMEPREFIX=	ocaml-

MAINTAINER=	michipili@gmail.com
COMMENT=	Camlp4 is a system for writing extensible parsers for OCaml

LICENSE=	LGPL20

USE_GITHUB=	yes
GH_ACCOUNT=	ocaml
GH_COMMIT=	bdd88a1

USES=		gmake
HAS_CONFIGURE=	yes
MAKE_ENV+=	DESTDIR="${STAGEDIR}"
MAKE_JOBS_UNSAFE=yes

.include <bsd.port.mk>
