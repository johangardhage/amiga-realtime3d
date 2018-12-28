	IFND LIBRARIES_REALTIME_LIB_I
LIBRARIES_REALTIME_LIB_I	SET	1
**
**	$VER: realtime_lib.i 37.1 (11.1.98)
**	Includes Release 40.13+1
**
**	Library interface offsets for realtime library
**
**	Created by Harry Sintonen. Public Domain.
**

    IFND    EXEC_FUNCDEF_I
    include 'exec/funcdef.i'
    ENDC

	FDEFINIT
;--- functions in V37 or higher (Release 2.04) ---
;
; Locks
;
	FUNCDEF	LockRealTime
	FUNCDEF	UnlockRealTime
;
; Conductor
;
	FUNCDEF	CreatePlayerA
	FUNCDEF	DeletePlayer
	FUNCDEF	SetPlayerAttrsA
	FUNCDEF	SetConductorState
	FUNCDEF	ExternalSync
	FUNCDEF	NextConductor
	FUNCDEF	FindConductor
	FUNCDEF	GetPlayerAttrsA
	ENDC	; LIBRARIES_REALTIME_LIB_I
