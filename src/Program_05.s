*****************************************************************************************
*	otranw.s
*	Simple rotations for chapter six.
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
	include	core_03.s
	include	data_03.s
	include	bss_03.s
****************************************************************************************
display
	movem.l	d0-d7/a0-a6,-(sp)
	IFD	KILLTASKS
	movea.l	$4.w,a6
	jsr	_LVOForbid(a6)				; This wont work if you use WaitTOF().
	ENDC
* transfer all the data
	move.w	my_npoly,d7				; number of polygons
	move.w	d7,npoly				; save it
	subq.w	#1,d7					; for dbra counter
	move.w	d7,d0					; save it
	lea	my_nedges,a0
	lea	my_colour,a2
	lea	snedges,a1
	lea	col_lst,a3
loop0
	move.w	(a0)+,(a1)+				; transfer edge number
	move.w	(a2)+,(a3)+				; transfer colours
	dbra	d0,loop0

* calculate the number of vertices altogether
	move.w	d7,d0					; restore count
	lea	my_nedges,a6
	clr	d1
	clr	d2
loop1
	add.w	(a6),d1
	add.w	(a6)+,d2				; total number of vertices
	addq.w	#1,d2
	dbra	d0,loop1
* move the edge list
	subq.w	#1,d2					; counter
	lea	my_edglst,a0
	lea	sedglst,a1
loop2
	move.w	(a0)+,(a1)+
	dbra	d2,loop2
* and the coords list
	move.w	d1,oncoords
	subq.w	#1,d1
	lea	ocoordsx,a1
	lea	my_datax,a0
	lea	ocoordsy,a3
	lea	my_datay,a2
	lea	ocoordsz,a5
	lea	my_dataz,a4

loop3
	move.w	(a0)+,(a1)+
	move.w	(a2)+,(a3)+
	move.w	(a4)+,(a5)+
	dbra	d1,loop3
* and the window limits
	move.w	my_xmin,clp_xmin
	move.w	my_xmax,clp_xmax
	move.w	my_ymin,clp_ymin
	move.w	my_ymax,clp_ymax
* PLACE OBJECT IN WORLD FRAME (POSITION IT)!
	move.w	#100,Oox				; in the air
	move.w	#50,Ooz					; in front
	clr.w	Ooy					; dead centre
* initialise for rotation
	clr.w	otheta					; init angles
	move.w	#50,ophi				; tilt up 50 degrees
	clr.w	ogamma

	jsr	wrt_phys_tbl

* start the rotation about the zw axis (can't rotate about others or we'll see
* the back of the object).
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*
displayloop
loop5
	move.w	#360,d7
loop4
	move.w	d7,ogamma				; next angle gamma
	move.w	d7,-(sp)
*
	bsr	otranw					; do rotational transform
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
* complete the picture
	bsr	perspective

	move.l	#1,frame_done
	IFND	USE_VBLANK
	jsr	vblank_code
	ENDC

wait_vblank
	tst.l	frame_done
	bne	wait_vblank

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
