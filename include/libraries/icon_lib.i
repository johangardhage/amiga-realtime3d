	IFND	LIBRARIES_ICON_LIB_I
LIBRARIES_ICON_LIB_I	SET	1
**
**	$VER: icon_lib.i 40.1 (14.12.96)
**	Includes Release 40.13+1
**
**	Library interface offsets for Icon library
**
**	Created by Harry Sintonen. Public Domain.
**

    IFND    EXEC_FUNCDEF_I
    include 'exec/funcdef.i'
    ENDC

	FDEFINIT
	FUNCDEF	iconPrivate1
	FUNCDEF	iconPrivate2
	FUNCDEF	iconPrivate3
	FDEFINIT -$2A
	FUNCDEF	GetIcon
	FUNCDEF	iconPrivate4
	FDEFINIT -$30
	FUNCDEF	PutIcon
	FUNCDEF	FreeFreeList
	FUNCDEF	iconPrivate5
	FUNCDEF	iconPrivate6
	FUNCDEF	AddFreeList
	FUNCDEF	GetDiskObject
	FUNCDEF	PutDiskObject
	FUNCDEF	FreeDiskObject
	FUNCDEF	FindToolType
	FUNCDEF	MatchToolValue
	FUNCDEF	BumpRevision
	FUNCDEF	iconPrivate7
;--- functions in V36 or higher (Release 2.0) ---
	FUNCDEF	GetDefDiskObject
	FUNCDEF	PutDefDiskObject
	FUNCDEF	GetDiskObjectNew
;--- functions in V37 or higher (Release 2.04) ---
	FUNCDEF	DeleteDiskObject
;--- (4 function slots reserved here) ---
	FUNCDEF	iconReserved1
	FUNCDEF	iconReserved2
	FUNCDEF	iconReserved3
	FUNCDEF	iconReserved4

	ENDC	; LIBRARIES_ICON_LIB_I
