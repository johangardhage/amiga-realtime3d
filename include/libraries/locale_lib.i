	IFND	LIBRARIES_LOCALE_LIB_I
LIBRARIES_LOCALE_LIB_I  SET 1
**
**	$VER: locale_lib.i 40.1 (11.1.98)
**	Includes Release 40.13+1
**
**	Library interface offsets for locale library
**
**	Created by Harry Sintonen. Public Domain.
**

    IFND    EXEC_FUNCDEF_I
    include 'exec/funcdef.i'
    ENDC

	FDEFINIT
;--- functions in V38 or higher (Release 2.1) ---
	FUNCDEF	localePrivate1
	FUNCDEF	CloseCatalog
	FUNCDEF	CloseLocale
	FUNCDEF	ConvToLower
	FUNCDEF	ConvToUpper
	FUNCDEF	FormatDate
	FUNCDEF	FormatString
	FUNCDEF	GetCatalogStr
	FUNCDEF	GetLocaleStr
	FUNCDEF	IsAlNum
	FUNCDEF	IsAlpha
	FUNCDEF	IsCntrl
	FUNCDEF	IsDigit
	FUNCDEF	IsGraph
	FUNCDEF	IsLower
	FUNCDEF	IsPrint
	FUNCDEF	IsPunct
	FUNCDEF	IsSpace
	FUNCDEF	IsUpper
	FUNCDEF	IsXDigit
	FUNCDEF	OpenCatalogA
	FUNCDEF	OpenLocale
	FUNCDEF	ParseDate
	FUNCDEF	localePrivate2
	FUNCDEF	StrConvert
	FUNCDEF	StrnCmp
	FUNCDEF	localePrivate3
	FUNCDEF	localePrivate4
	FUNCDEF	localePrivate5
	FUNCDEF	localePrivate6
	FUNCDEF	localePrivate7
	FUNCDEF	localePrivate8
	ENDC	; LIBRARIES_LOCALE_LIB_I
