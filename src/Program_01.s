*****************************************************************************************
*	Polydraw.s
*	This is the shell for the first program in the book.
*****************************************************************************************
;USE_TOF		EQU	1			; when set will use WaitTOF() else WaitBOVP() (WaitTOF breaks Forbid()).
;USE_FILES		EQU	1
DOUBLE_BUFFERING	EQU	1
;MY_NTSC		EQU	1			; If set HEIGHT = 200 else = 256.
;USE_VBLANK		EQU	1
;TESTING_VBLANK		EQU	1			; switch to turn only writing loaded gfx to one bitmap
;THIRTYTWOCOLOURS	EQU	1
SIXTEENCOLOURS		EQU	1
KILLTASKS		EQU	1
*****************************************************************************************
	incdir	src/lib
	incdir	sources:src/lib/
	include	startup.s
	include	core_00.s
	include	data_00.s
	include	bss_00.s
*****************************************************************************************
display
	movem.l	d0-d7/a0-a6,-(sp)
	IFD	KILLTASKS
	movea.l	$4.w,a6
	jsr	_LVOForbid(a6)				; This wont work if you use WaitTOF().
	ENDC
	jsr	wrt_phys_tbl

displayloop
	lea	coords,a0				; get triangle data base
	eor.l	#4,toggle
	move.l	toggle,d0				; swap triangles
	add.l	d0,a0
	move.l	(a0),coords_lst				; store the address

	move.w	#8,d1
	add.w	d0,d1
	move.w	d1,colour				; change colour
	move.w	#3,no_in

	move.l	#1,frame_done
	IFND	USE_VBLANK
	jsr	vblank_code
	ENDC

wait_vblank
	tst.l	frame_done
	bne	wait_vblank

	IFD	DOUBLE_BUFFERING
	move.l	workplanes,a0				; Clear the workplanes
	ELSE
	move.l	showplanes,a0				; Clear the workplanes
	ENDC
	move.l	#HEIGHT,d0				; Clear all planes
	lsl.w	#SIXTYFOUR,d0				; shift HEIGHT into correct register bits
	or.w	#WIDTH/2,d0				; add width
	move.l	#$dff000,a5
	bsr	clear_blit

	bsr	poly_fill

	btst	#6,$bfe001				; are we fed up yet?
	bne	displayloop				; no, not yet....

	IFD	KILLTASKS
	movea.l	$4.w,a6
	jsr	_LVOPermit(a6)
	ENDC
	movem.l	(sp)+,d0-d7/a0-a6
	rts
**********************************************************************************
*Triangle coords
toggle		dc.l	4
my_coords	dc.w	100,160,150,70,190,140,100,160
my_inv_coords	dc.w	100,80,160,160,170,90,100,80
coords
		dc.l	my_coords
		dc.l	my_inv_coords
