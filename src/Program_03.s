*****************************************************************************************
*	perspect.s
*	perspective view of an A monolith
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
	include	core_02.s
	include	data_01.s
	include	bss_02.s
****************************************************************************************
display
	movem.l	d0-d7/a0-a6,-(sp)
	IFD	KILLTASKS
	movea.l	$4.w,a6
	jsr	_LVOForbid(a6)				; This wont work if you use WaitTOF().
	ENDC
* Transfer data from the data file to variables locations:
* First the edge numbes and colours.
	move.w	my_npoly,d7				; number of polygons
	beq	all_over				; quit if none found...
	move.w	d7,npoly				; or d7 becomes
	subq.w	#1,d7					; the counter
	move.w	d7,d0					; save it.
	lea	my_nedges,a0				; source
	lea	snedges,a1				; destination
	lea	my_colour,a2				; source
	lea	col_lst,a3				; destination
loop0
	move.w	(a0)+,(a1)+				; copy edge numbers
	move.w	(a2)+,(a3)+				; copy colours
	dbra	d0,loop0

* now do edge list and coords...
	move.w	d7,d0					; counter
	lea	my_nedges,a6
	clr	d1
	clr	d2
loop1
	add.w	(a6),d1
	add.w	(a6)+,d2
	addq.w	#1,d2					; last one repeated each time
	dbra	d0,loop1

	subq.w	#1,d2					; counter
	lea	my_edglst,a0
	lea	sedglst,a1
loop2
	move.w	(a0)+,(a1)+
	dbra	d2,loop2

	move.w	d1,vncoords
	subq	#1,d1					; counter
	lea	vcoordsx,a1
	lea	my_datax,a0
	lea	vcoordsy,a3
	lea	my_datay,a2
	lea	vcoordsz,a5
	lea	my_dataz,a4

loop3
	move.w	(a0)+,(a1)+
	move.w	(a2)+,(a3)+
	move.w	(a4)+,(a5)+
	dbra	d1,loop3

* clip frame boundaries
	move.w	my_xmin,clp_xmin
	move.w	my_xmax,clp_xmax
	move.w	my_ymin,clp_ymin
	move.w	my_ymax,clp_ymax

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
	bsr	perspective
	bsr	polydraw

	btst	#6,$bfe001				; are we fed up yet?
	bne	displayloop				; no, not yet....
all_over
	IFD	KILLTASKS
	movea.l	$4.w,a6
	jsr	_LVOPermit(a6)
	ENDC
	movem.l	(sp)+,d0-d7/a0-a6
	rts
**********************************************************************************
