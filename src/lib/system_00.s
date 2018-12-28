*******************************************************************************************
*	System_00.s
*******************************************************************************************
* Various system tasks; wrt_phys_tbl
*		blit_mask
*		clear_blit
*		openlibraries
*		initialise_display
*		movegfx
*		Allocmem
*		GetBitMap
*		vblank_code
*		GetFile
*		FreeCop_Lists
*******************************************************************************************
* Write a table of y addresses for rows in mask plane (for speed of access).
wrt_phys_tbl
	move.l	maskplane,d0				; mask plane base
	move.w	#HEIGHT-1,d1
	lea	msk_y_tbl,a0				; get table address
luloop
	move.l	d0,(a0)+				; next row address
	add.w	#40,d0					; bytes per row
	dbf	d1,luloop
	rts
*******************************************************************************************
* Clear the mask plane of data
blit_mask
	bsr	blt_chk
	move.l	maskplane,bltdpt(a5)			; DESTINATION
	clr.w	bltdmod(a5)
	clr.w	bltcon1(a5)
	move.w	#$100,bltcon0(a5)			; turn on D
	move.w	#(HEIGHT*64)+WIDTH/2,bltsize(a5)	; clear a single plane
	bsr	blt_chk
	rts
*******************************************************************************************
* Clear a playfield of data
* a0=DESTINATION: d0=sizeof blit: a5=chipreg base
clear_blit
 move.w #DEPTH-1,d7
.nextplane
	bsr	blt_chk
	move.l	(a0)+,bltdpt(a5)			; DESTINATION
	clr.w	bltdmod(a5)
	clr.w	bltcon1(a5)
	move.w	#$100,bltcon0(a5)			; turn on D
	move.w	d0,bltsize(a5)				; clear memory
	dbra	d7,.nextplane
	rts
*******************************************************************************************
openlibraries
 	movea.l	4.w,a6
 	lea	IntuiName(pc),a1			; Open Intuition Library
 	moveq	#Version_39,d0				; version 39 or more.
 	jsr	_LVOOpenLibrary(a6)
 	move.l	d0,IntuiBase				; save result to check on later.

 	movea.l	4.w,a6
	lea	LowLevelName(pc),a1			; open lowlevel library
 	moveq	#0,d0
 	jsr	_LVOOpenLibrary(a6)
 	tst.l	d0
 	beq	.errorend				; couldn't get lowlevel
	move.l	d0,LowLevelBase

	movea.l	4.w,a6
	lea	GrafName(pc),a1				; Open Gfx Library
	moveq	#Version_36,d0				; version 33 or more.
	jsr	_LVOOpenLibrary(a6)
	tst.l	d0
	beq	.errorend				; couldn't get Gfx Library.
	move.l	d0,GrafBase
	movea.l	d0,a6
	move.l	gb_ActiView(a6),OldActiView

	lea	DosName,a1				; Open DOS Library.
	moveq	#0,d0
	movea.l	4.w,a6
	jsr	_LVOOpenLibrary(a6)
	move.l	d0,DosBase
	beq	.errorend				; couldn`t get DOS.
	rts
.errorend
	move.l	#$FFFFFFFF,d0
	rts
;----------------------------------------------------------------------------------------
initialise_display

*initialise this view
	lea	my_view,a1
	movea.l	GrafBase,a6
	jsr	_LVOInitView(a6)

*initialise the rasinfo structure
.rasinfo
	lea	my_rasinfo,a6
	move.l	#0,ri_Next(a6)
	move.l	show_bitmap,ri_BitMap(a6)		; link in the bitmap structure
	move.w	#0,ri_RxOffset(a6)
	move.w	#0,ri_RyOffset(a6)

*initialise the viewport structure
	lea	my_viewport,a0
	movea.l	GrafBase,a6
	jsr	_LVOInitVPort(a6)

*link the viewport to the view
	lea	my_view,a6
	lea	my_viewport,a0
	move.l	a0,v_ViewPort(a6)

*initialise the viewport fields
	move.w 	#dxoffset,vp_DxOffset(a0)
	move.w 	#dyoffset,vp_DyOffset(a0)
	move.w 	#vp_width,vp_DWidth(a0)
	move.w 	#vp_height,vp_DHeight(a0)
	lea	my_rasinfo,a1
	move.l	a1,vp_RasInfo(a0)

*get the color map structure
.colormap
	move.l	#DEPTH<<2,d0				; num of colors
	movea.l	GrafBase,a6
	jsr	_LVOGetColorMap(a6)
	move.l	d0,colormap
	beq	.error

*link colormap to viewport	ONLY for 1.3 or less
	lea	my_viewport,a0
	move.l	d0,vp_ColorMap(a0)

*load colors into colormap
.loadcolors
	lea	color_table,a1
	move.w 	#DEPTH<<2,d0
	movea.l	GrafBase,a6
	jsr	_LVOLoadRGB4(a6)

*build the copperlists - we need two for double buffering
	lea	my_view,a0
	lea	my_viewport,a1
	movea.l	GrafBase,a6
	jsr	_LVOMakeVPort(a6)
	lea	my_view,a1
	movea.l	GrafBase,a6
	jsr	_LVOMrgCop(a6)

*store the first one, and make the next.
	lea	my_view,a0
	move.l	v_LOFCprList(a0),showlist

	IFD	DOUBLE_BUFFERING
	move.l	#0,v_LOFCprList(a0)			; reset the previous pointer to NULL

	lea	my_rasinfo,a6
	move.l	work_bitmap,ri_BitMap(a6)		; link in the next bitmap structure

	lea	my_view,a0
	lea	my_viewport,a1
	movea.l	GrafBase,a6
	jsr	_LVOMakeVPort(a6)
	lea	my_view,a1
	movea.l	GrafBase,a6
	jsr	_LVOMrgCop(a6)

	lea	my_view,a0
	move.l	v_LOFCprList(a0),worklist
	ENDC

	rts
.error
	move.l	#-1,d0
	rts
********************************************************************************************
*move gfx data from file buffer to display bitplanes.
movegfx
	clr.l	d0
	move.l	File_Buffer,a0
	move.l	work_bitmap,a1
	move.l	#DEPTH-1,d2				; planes counter
	move.l	#bm_Planes,d0				; pick up offset to the Planes table
nextplanes
	move.l	(a1,d0),a2				; get next plane pointer
	move.l	#HEIGHT-1,d1
nextrow
	move.l	#WIDTH-1,d3
nextbyte
	move.b	(a0)+,(a2)+
	dbra	d3,nextbyte
	dbra	d1,nextrow
	addq.l	#4,d0
	dbra d2,nextplanes
	IFD TESTING_VBLANK
	rts
	ENDC
* do next bitmap
	clr.l	d0
	move.l	File_Buffer,a0
	move.l	show_bitmap,a1
	move.l	#DEPTH-1,d2				; planes counter
	move.l	#bm_Planes,d0				; pick up offset to the Planes table
nextplane1
	move.l	(a1,d0),a2				; get next plane pointer
	move.l	#HEIGHT-1,d1
nextrow1
	move.l	#WIDTH-1,d3
nextbyte1
	move.b	(a0)+,(a2)+
	dbra	d3,nextbyte1
	dbra	d1,nextrow1
	addq.l	#4,d0
	dbra d2,nextplane1
	rts
******************************************************************************************
* Call system to get some memory.
* d0=sizeof memory: d1=memory type: a4=address to store pointer
Allocmem
	movea.l	4.w,a6
	jsr	_LVOAllocMem(a6)
	tst.l	d0
	beq	.error_end 				; couldn`t get memory.
	move.l	d0,(a4)					; save pointer to memory we got.
	rts
.error_end
	move.l	#-1,d0
	rts
*****************************************************************************************
* Call system for BitMap structure
* d0=x: d1=y: d2=depth: d3=type: a0=pointer to FriendBitMap
GetBitMap
	movea.l	GrafBase,a6
	jsr	_LVOAllocBitMap(a6)
	tst.l	d0
	beq	.error_end
	move.l	d0,(a4)					; save pointer to alloc'd structure
	rts
.error_end
	move.l	#-1,d0
	rts
*--------------------------------------------------------------------------------------
FreeCop_Lists
	move.l	colormap,a0				; freeup colormap structure memory
	movea.l	GrafBase,a6
	jsr	_LVOFreeColorMap(a6)

	lea	my_viewport,a0
	movea.l	GrafBase,a6
	jsr	_LVOFreeVPortCopLists(a6)		; freeup intermediate lists

	move.l	showlist,a0
	movea.l	GrafBase,a6
	jsr	_LVOFreeCprList(a6)			; freeup hardware list

	IFD	DOUBLE_BUFFERING
	move.l	worklist,a0
	movea.l	GrafBase,a6
	jsr	_LVOFreeCprList(a6)			; freeup hardware list
 ENDC

.done
	rts

*--------------------------------------------------------------------------------------

GetFile
* Entry d1 = Filename
*	d0 = Filebuffer
	move.l	d0,-(a7)
	move.l	#MODE_OLDFILE,d2
	movea.l	DosBase,a6
	jsr	_LVOOpen(a6)
	move.l	d0,File_Handle				; save filehandle
	move.l	(a7)+,d2
	tst.l	d0
	beq.s	File_Error
	move.l	d0,d1
	move.l	#Filesize,d3
	movea.l	DosBase,a6
	jsr	_LVORead(a6)
	tst.l	d0
	bmi.s	File_Error
	move.l	d0,-(a7)
	move.l	File_Handle,d1				; get filehandle
	movea.l	DosBase,a6
	jsr	_LVOClose(a6)
	move.l	(a7)+,d0
	rts

File_Error
	moveq	#-1,d0
	rts

************************************************************************************
vblank_code
	movem.l	d0/a1/a6,-(sp)

	IFD	USE_VBLANK
	tst.l	frame_done
	beq	.vblank_done
	clr.l	frame_done
	ENDC

	IFD	DOUBLE_BUFFERING
* switch display memory pointers over
	move.l	showplanes,d0
	move.l	workplanes,showplanes
	move.l	d0,workplanes

* switch copperlists
	move.l	showlist,d0
	move.l	worklist,showlist
	move.l	d0,worklist
	ENDC

* load copperlist pointer
	lea	my_view,a1
	move.l	showlist,v_LOFCprList(a1)
	movea.l	GrafBase,a6
	jsr	_LVOLoadView(a6)

	IFND	USE_VBLANK
	clr.l	frame_done
	movea.l	GrafBase,a6
	IFD	USE_TOF					; using this will break WaitTOF()
	lea	my_view,a1
	jsr	_LVOLoadView(a6)
	jsr	_LVOWaitTOF(a6)				; wait for vblank
	ELSE
	lea	my_viewport,a0
	jsr	_LVOWaitBOVP(a6)			; use this if you don't want to break WaitTOF()
	ENDC
	ENDC

.vblank_done
	movem.l	(sp)+,d0/a1/a6
	IFD	USE_VBLANK
	moveq.w	#1,d0					; I have to do this for the OS
	ENDC
	rts
