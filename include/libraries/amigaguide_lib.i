	IFND LIBRARIES_AMIGAGUIDE_LIB_I
LIBRARIES_AMIGAGUIDE_LIB_I	SET	1
**
**	$VER: amigaguide_lib.i 39.1 (11.1.98)
**	Includes Release 40.13+1
**
**	Library interface offsets for amigaguide library
**
**	Created by Harry Sintonen. Public Domain.
**

    IFND    EXEC_FUNCDEF_I
    include 'exec/funcdef.i'
    ENDC

	FDEFINIT
;--- functions in V40 or higher (Release 3.1) ---
	FUNCDEF	amigaguidePrivate1
;
; Public entries
;
	FUNCDEF	LockAmigaGuideBase
	FUNCDEF	UnlockAmigaGuideBase
	FUNCDEF	amigaguidePrivate2
	FUNCDEF	OpenAmigaGuideA
	FUNCDEF	OpenAmigaGuideAsyncA
	FUNCDEF	CloseAmigaGuide
	FUNCDEF AmigaGuideSignal
	FUNCDEF	GetAmigaGuideMsg
	FUNCDEF	ReplyAmigaGuideMsg
	FUNCDEF	SetAmigaGuideContextA
	FUNCDEF	SendAmigaGuideContextA
	FUNCDEF	SendAmigaGuideCmdA
	FUNCDEF	SetAmigaGuideAttrsA
	FUNCDEF	GetAmigaGuideAttr
	FUNCDEF	amigaguidePrivate3
	FUNCDEF	LoadXRef
	FUNCDEF	ExpungeXRef
	FUNCDEF	AddAmigaGuideHostA
	FUNCDEF	RemoveAmigaGuideHostA
	FUNCDEF	amigaguidePrivate4
	FUNCDEF	amigaguidePrivate5
	FUNCDEF	amigaguidePrivate6
	FUNCDEF	amigaguidePrivate7
	FUNCDEF	amigaguidePrivate8
	FUNCDEF	amigaguidePrivate9
	FUNCDEF	amigaguidePrivate10
	FUNCDEF	amigaguidePrivate11
	FUNCDEF	amigaguidePrivate12
	FUNCDEF	amigaguidePrivate13
	FUNCDEF	GetAmigaGuideString
	ENDC	; LIBRARIES_AMIGAGUIDE_LIB_I
