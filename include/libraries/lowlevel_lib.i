	IFND	LIBRARIES_LOWLEVEL_LIB_I
LIBRARIES_LOWLEVEL_LIB_I  SET 1
**
**	$VER: lowlevel_lib.i 40.1 (11.1.98)
**	Includes Release 40.13+1
**
**	Library interface offsets for lowlevel library
**
**	Created by Harry Sintonen. Public Domain.
**

    IFND    EXEC_FUNCDEF_I
    include 'exec/funcdef.i'
    ENDC

	FDEFINIT
;--- functions in V40 or higher (Release 3.1) ---
;
; CONTROLLER HANDLING
;
	FUNCDEF	ReadJoyPort
;
; LANGUAGE HANDLING
;
	FUNCDEF	GetLanguageSelection
	FUNCDEF	lowlevelPrivate1
;
; KEYBOARD HANDLING
;
	FUNCDEF	GetKey
	FUNCDEF	QueryKeys
	FUNCDEF	AddKBInt
	FUNCDEF	RemKBInt
;
; SYSTEM HANDLING
;
	FUNCDEF	SystemControlA
;
; TIMER HANDLING
;
	FUNCDEF	AddTimerInt
	FUNCDEF	RemTimerInt
	FUNCDEF	StopTimerInt
	FUNCDEF	StartTimerInt
	FUNCDEF	ElapsedTime
;
; VBLANK HANDLING
;
	FUNCDEF	AddVBlankInt
	FUNCDEF	RemVBlankInt
	FUNCDEF	lowlevelPrivate2
	FUNCDEF	lowlevelPrivate3
;
; MORE CONTROLLER HANDLING
;
	FUNCDEF	SetJoyPortAttrsA
	FUNCDEF	lowlevelPrivate4
	FUNCDEF	lowlevelPrivate5
	FUNCDEF	lowlevelPrivate6
	FUNCDEF	lowlevelPrivate7
	FUNCDEF	lowlevelPrivate8

	ENDC	; LIBRARIES_LOWLEVEL_LIB_I
