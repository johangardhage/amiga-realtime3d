*****************************************************************************************
*	ClipFrame.s
* A program to clip and fill a polygon to a window (clip frame) which is defined by the
* limits clp_xmin, clp_xmax, clp_ymin, clp_ymax.
*****************************************************************************************
;USE_TOF		EQU	1			; when set will use WaitTOF() else WaitBOVP() (WaitTOF breaks Forbid()).
;USE_FILES		EQU	1
DOUBLE_BUFFERING	EQU	1
;MY_NTSC		EQU	1			; If set HEIGHT = 200 else = 256.
;USE_VBLANK		EQU	1
;TESTING_VBLANK		EQU	1			; switch to turn only writing loaded gfx to one bitmap
;THIRTYTWOCOLOURS	EQU	1
SIXTEENCOLOURS		EQU	1
;KILLTASKS		EQU	1
****************************************************************************************
	include	startup.s
	include	data_00.s
	include	bss_01.s
	include	core_01.s
****************************************************************************************
display
	movem.l	d0-d7/a0-a6,-(sp)
	IFD	KILLTASKS
	movea.l	$4.w,a6
	jsr	_LVOForbid(a6)				; This wont work if you use WaitTOF().
	ENDC
	jsr	wrt_phys_tbl

displayloop
	IFND	USE_VBLANK
	jsr	vblank_code
	ENDC
*****************************************************************************************
* The next few lines should be retained for all programs as they clear the workplanes of
* old data, this routine is called at the start of drw1_shw2 & drw2_shw1 in the book.
* (DON'T look for these I haven't used them!).

	IFD	DOUBLE_BUFFERING
	move.l	workplanes,a0				; Clear the workplanes
	ELSEIF
	move.l	showplanes,a0				; Clear the workplanes
	ENDC
	move.l	#HEIGHT,d0				; Clear all planes
	lsl.w	#SIXTYFOUR,d0				; shift HEIGHT into correct register bits
	or.w	#WIDTH/2,d0				; add width
	move.l	#$dff000,a5
	bsr	clear_blit
*****************************************************************************************
	move.w	#12-1,d7 				; six pairs of coords for vertices
	lea 	crds_in,a0 				; destination
	move.l	a0,a3 					; ready for drawing
	lea 	my_data,a1 				; from here
clp_loop
	move.w	(a1)+,(a0)+ 				; transfer them all
	dbra	d7,clp_loop

	move.w	#5,no_in
	move.w	my_colour,colour
	move.w	my_xmin,clp_xmin
	move.w	my_xmax,clp_xmax
	move.w	my_ymin,clp_ymin
	move.w	my_ymax,clp_ymax

 bsr clip
	bsr poly_fill

	btst	#6,$bfe001				; are we fed up yet?
	bne 	displayloop				; no, not yet....

	IFD	KILLTASKS
	movea.l	$4.w,a6
	jsr	_LVOPermit(a6)
	ENDC
	movem.l	(sp)+,d0-d7/a0-a6
	rts
**********************************************************************************
my_data		dc.w	20,100,200,20,300,80,260,180,140,180,20,100
my_colour	dc.w	15
my_xmin		dc.w	50
my_xmax		dc.w	270
my_ymin		dc.w	50
my_ymax		dc.w	150
