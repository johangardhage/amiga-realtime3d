	IFND	DEVICES_CIA_I
DEVICES_CIA_I	SET	1
**
**	$VER: cia.i 36.3 (14.12.96)
**	Includes Release 40.13+1
**
**	Cia resource name strings (+ function offsets).
**
**	(C) Copyright 1985-1993 Commodore-Amiga Inc.
**		All Rights Reserved
**
**	New version by Harry Sintonen. Public Domain.
**

    IFND    EXEC_TYPES_I
    INCLUDE 'exec/types.i'
    ENDC

    IFND    EXEC_LIBRARIES_I
    INCLUDE 'exec/libraries.i'
    ENDC

**
** Library vector offset definitions
**
	IFND	_LVOAddICRVector
	LIBINIT LIB_BASE
	LIBDEF	AddICRVector		;-6
	LIBDEF	RemICRVector		;-12
	LIBDEF	AbleICR			;-18
	LIBDEF	SetICR			;-24
	ENDC

CIAANAME	MACRO
		DC.B	'ciaa.resource',0
		ENDM

CIABNAME	MACRO
		DC.B	'ciab.resource',0
		ENDM

	ENDC	; DEVICES_CIA_I
