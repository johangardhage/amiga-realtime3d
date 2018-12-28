*****************************************************************************************
* Illhide.s
*
*****************************************************************************************
;USE_TOF		EQU	1			; when set will use WaitTOF() else WaitBOVP() (WaitTOF breaks Forbid()).
;USE_FILES		EQU	1
DOUBLE_BUFFERING	EQU	1
MY_NTSC			EQU	1			; If set HEIGHT = 200 else = 256.
;USE_VBLANK		EQU	1
;TESTING_VBLANK		EQU	1			; switch to turn only writing loaded gfx to one bitmap
THIRTYTWOCOLOURS	EQU	1
;SIXTEENCOLOURS		EQU	1
;KILLTASKS		EQU	1
****************************************************************************************
	include	startup.s
	include	core_04.s
	include	data_04.s
	include	bss_04.s
****************************************************************************************
display
	movem.l	d0-d7/a0-a6,-(sp)
	IFD	KILLTASKS
	movea.l	$4.w,a6
	jsr	_LVOForbid(a6)				; This wont work if you use WaitTOF().
	ENDC
	bsr	transfer
* place object in the world frame
	move.w	#0,Oox					; on the ground
	move.w	#100,Ooz				; in front
	clr.w	Ooy					; dead centre
* initialise angles for rotation
	clr.w	otheta
	move.w	#50,ophi
	clr.w	ogamma
* set up mask plane row pointers
	jsr	wrt_phys_tbl
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
displayloop
loop5
	move.w	#360,d7
loop4
	move.w	d7,otheta
	move.w	d7,-(sp)
	IFND	USE_VBLANK
	jsr	vblank_code
	ENDC
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
	bsr	otranw
* pass on the new coords
	move.w	oncoords,d7
	move.w	d7,vncoords
	subq.w	#1,d7
	lea	wcoordsx,a0
	lea	wcoordsy,a1
	lea	wcoordsz,a2
	lea	vcoordsx,a3
	lea	vcoordsy,a4
	lea	vcoordsz,a5
loop6
	move.w	(a0)+,(a3)+
	move.w	(a1)+,(a4)+
	move.w	(a2)+,(a5)+
	dbra	d7,loop6
* Test for visibility and light intensity
	bsr	illuminate
* complete the picture
	bsr	perspective
	bsr	polydraw
all_done
	move.w	(sp)+,d7
	btst	#6,$bfe001				; are we fed up yet?
	beq	all_over				; yes so quit...
	sub.w	#4,d7					; reduce angle by required amount in degrees
	bgt	loop4					; do next angle
	bra	loop5					; start again...
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

all_over
	IFD	KILLTASKS
	movea.l	$4.w,a6
	jsr	_LVOPermit(a6)
	ENDC
	movem.l	(sp)+,d0-d7/a0-a6
	rts
**********************************************************************************
