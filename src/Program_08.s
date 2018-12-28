*****************************************************************************************
*	Wrld_scn.s
*	A multi object scene.
* A world of multiple objects in motion. Joystick controls yaw & pitch. KB controls
* F1/F2 roll F3-F5 speed. F7 quit.
*****************************************************************************************
;USE_TOF		EQU	1			; when set will use WaitTOF() else WaitBOVP() (WaitTOF breaks Forbid()).
;USE_FILES		EQU	1
DOUBLE_BUFFERING	EQU	1
MY_NTSC			EQU	1			; If set HEIGHT = 200 else = 256.
;USE_VBLANK		EQU	1
;TESTING_VBLANK		EQU	1			; switch to turn only writing loaded gfx to one bitmap
THIRTYTWOCOLOURS	EQU	1
;SIXTEENCOLOURS		EQU	1
KILLTASKS		EQU	1
JOY3			EQU	1			; select required jstick routines
****************************************************************************************
	include	startup.s
	include	system_01.s
	include	core_07.s
	include	data_08.s
	include	bss_07.s
****************************************************************************************
display
	movem.l	d0-d7/a0-a6,-(sp)
	IFD	KILLTASKS
	movea.l	$4.w,a6
	jsr	_LVOForbid(a6)				; This wont work if you use WaitTOF().
	ENDC
	jsr	init_vars
	jsr	flg_init
	jsr	wrt_phys_tbl

displayloop ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*
	move.l	#1,frame_done				; swap copperlist and bitplane pointers. LoadView
	IFND	USE_VBLANK
	jsr	vblank_code
	ENDC
wait_vblank
	tst.l	frame_done
	bne	wait_vblank
*
	IFD	DOUBLE_BUFFERING
	move.l	workplanes,a0				; pointer to bitplane lists
	ELSEIF
	move.l	showplanes,a0				; pointer to alternative lists
	ENDC
	move.l	#HEIGHT,d0
	lsl.w	#SIXTYFOUR,d0				; shift HEIGHT into correct register bits
	or.w	#WIDTH/2,d0				; add width
	move.l	#$dff000,a5
	bsr	clear_blit
*
	bsr	dircosines
	bsr	joy_in
	bsr	in_key
	bsr	adj_vel
	bsr	scne_drw

	tst.w	quitflag				; are we fed up yet?
	bne	all_over				; yes so quit...
*
	bra	displayloop
*****************************************************************************************
all_over
	IFD	KILLTASKS
	movea.l	$4.w,a6
	jsr	_LVOPermit(a6)
	ENDC
	movem.l	(sp)+,d0-d7/a0-a6
	rts
**********************************************************************************
