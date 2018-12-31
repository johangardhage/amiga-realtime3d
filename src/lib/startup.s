***************************************************************************************
* StartUp.s : Shell to set up a display and include all files. It should be in System.s
* really but it's too much trouble...
***************************************************************************************

	bra	Start
	include	system_00.s
	include	includes.s
	include	equates.s

***************************************************************************************
Start
	movem.l	d0/a0,-(a7)				; Save argc and argv.
	suba.l	a1,a1					; Clr task name to NULL so we can...
	movea.l	4.w,a6
	jsr	_LVOFindTask(a6)			; Find this task and save the
	movea.l	d0,a4					; pointer to the task/process control block.
	tst.l	pr_CLI(a4)				; See if we came from the CLI
	bne.s	CLI_Launch				; Yes; so carry on.
	lea	pr_MsgPort(a4),a0			; Else WBench launched; Handle the startup
	movea.l	4.w,a6					; message WB sends...
	jsr	_LVOWaitPort(a6)			; Wait for the message to arrive...
	lea	pr_MsgPort(a4),a0
	jsr	_LVOGetMsg(a6)				; ..and get it. Then save it to
	move.l	d0,ReturnMsg				; reply when our process is done.

CLI_Launch
	movem.l	(a7)+,d0/a0				; Get argc and argv back.(Don't need 'em tho).

	jsr	openlibraries
	tst.l	d0
	bmi	Close_Libs

* Now ask system for screen memory and other system structures

	move.l	#sizex,d0				; PF width in pixels
	move.l	#sizey,d1				; PF height in lines
	move.l	#DEPTH,d2				; Num bitplanes reqd
	move.l	#BMF_CLEAR|BMF_DISPLAYABLE,d3
	sub.l	a0,a0
	move.l	#show_bitmap,a4
	jsr	GetBitMap
	tst.l	d0
	bmi	FreeAll
makeplaneptrs1
	clr.l	d0
	move.l	#showplanes_list,a2
	move.l	show_bitmap,a1
	move.l	#DEPTH-1,d2				; planes counter
	move.w	#bm_Planes,d0				; pick up offset to the Planes table
nextshowplane
	move.l	(a1,d0.w),a0				; get next plane pointer
	move.l	a0,(a2)+
	addq.w	#4,d0
	dbra	d2,nextshowplane

	IFD	DOUBLE_BUFFERING
	move.l	#sizex,d0				; PF width in pixels
	move.l	#sizey,d1				; PF height in lines
	move.l	#DEPTH,d2				; Num bitplanes reqd
	move.l	#BMF_CLEAR|BMF_DISPLAYABLE,d3
	sub.l	a0,a0
	move.l	#work_bitmap,a4
	jsr	GetBitMap
	tst.l	d0
	bmi	FreeAll
makeplaneptrs2
	clr.l	d0
	move.l	#workplanes_list,a2
	move.l	work_bitmap,a1
	move.l	#DEPTH-1,d2				; planes counter
	move.w	#bm_Planes,d0				; pick up offset to the Planes table
nextshowplane2
	move.l	(a1,d0.w),a0				; get next plane pointer
	move.l	a0,(a2)+
	addq.w	#4,d0
	dbra	d2,nextshowplane2
	ENDC

*Get the memory I want for file buffer
	move.l	#Filesize,d0				; file buffer.
	move.l	#MEMF_CLEAR|MEMF_CHIP,d1		; any memory, cleared to zeros.
	move.l	#File_Buffer,a4
	jsr	Allocmem
	tst.l	d0
	bmi	FreeAll

* Get memory for the mask
	move.l	#WIDTH*HEIGHT,d0			; memory size.
	move.l	#MEMF_CLEAR|MEMF_CHIP,d1		; chip memory, cleared to zeros.
	move.l	#maskplane,a4
	jsr	Allocmem
	tst.l	d0
	bmi	FreeAll

* Get memory for the storeplane
	move.l	#WIDTH*HEIGHT,d0			; memory size.
	move.l	#MEMF_CLEAR|MEMF_CHIP,d1		; chip memory, cleared to zeros.
	move.l	#storeplane,a4
	jsr	Allocmem
	tst.l	d0
	bmi	FreeAll

	IFD	USE_FILES
*load any files
	move.l	File_Buffer,d0
	move.l	#File,d1				; filename
	bsr	GetFile
	tst.l	d0
	bmi	FreeAll					; couldn`t get file.
	jsr	movegfx					; move loaded data into bitplane memory
	ENDC

	jsr	initialise_display			; get system type structures initialised

* now load two pointers that will be used to switch memory for dbuffering (video mem).
	IFD	DOUBLE_BUFFERING
	move.l	#workplanes_list,workplanes
	ENDC
	move.l	#showplanes_list,showplanes

	IFD USE_VBLANK
*add vblank interrupt routine
	lea	vblank_code,a0				; install V_40 vblank interrupt
	move.l	LowLevelBase,a6
	jsr	_LVOAddVBlankInt(a6)
	move.l	d0,intHandle
	beq	FreeAll
	ENDC

	lea	my_view,a1
	movea.l	GrafBase,a6
	jsr	_LVOLoadView(a6)
	jsr	_LVOWaitTOF(a6)				; wait for vblank
	jsr	_LVOWaitTOF(a6)

*--------------------------
; The game is now executed
	jsr	display
*--------------------------

FreeAll
	IFD USE_VBLANK
	move.l	intHandle,d1
	beq	Restore_Display
	move.l	d1,a1
	move.l	LowLevelBase,a6
	jsr	_LVORemVBlankInt(a6)
	ENDC

Restore_Display

; Do a low level restoration of the display.
	movea.l	OldActiView,a1				; get original view structure
	movea.l	GrafBase,a6
	jsr	_LVOLoadView(a6)			; & install it.
	jsr	_LVOWaitTOF(a6)				; wait for vblank
	jsr	_LVOWaitTOF(a6)
	move.l	gb_copinit(a6),cop1lc			; set copperlist ptr to original list.

	jsr	FreeCop_Lists				; free colormap and copperlists mem

; why use d1 -> a1. Because a1 wont set the flags and I want to set the Z if
; there's no address in the library or memory pointer.

	move.l	maskplane,d1				; return buffer memory to the system
	beq	Free_storeplane
	move.l	d1,a1
	move.l	#WIDTH*HEIGHT,d0
	movea.l	4.w,a6
	jsr	_LVOFreeMem(a6)

Free_storeplane
	move.l	storeplane,d1				; return buffer memory to the system
	beq	Free_BufferMem
	move.l	d1,a1
	move.l	#WIDTH*HEIGHT,d0
	movea.l	4.w,a6
	jsr	_LVOFreeMem(a6)

Free_BufferMem
	move.l	File_Buffer,d1				; return buffer memory to the system
	beq	Free_Bitmaps
	move.l	d1,a1
	move.l	#Filesize,d0
	movea.l	4.w,a6
	jsr	_LVOFreeMem(a6)

Free_Bitmaps
	movea.l	GrafBase,a6
	jsr	_LVOWaitBlit(a6)			; just in case somethings blitting
	move.l	show_bitmap,d0				; the memory we want to free??
	beq	NextBitMap
	move.l	d0,a0
	movea.l	GrafBase,a6
	jsr	_LVOFreeBitMap(a6)			; free bitmap memory

NextBitMap

 IFD DOUBLE_BUFFERING
	move.l	work_bitmap,d0				; the memory we want to free??
	beq	Close_Libs
	move.l	d0,a0
	movea.l	GrafBase,a6
	jsr	_LVOFreeBitMap(a6)			; free bitmap memory
 ENDC

Close_Libs
; Close down any Libraries we managed to open. Leave the ones we didn't!!
	move.l	LowLevelBase,d1
	move.l	d1,a1
	beq.s	Close_Graf				; was LowLevel open?
	movea.l	4.w,a6
	jsr	_LVOCloseLibrary(a6)
Close_Graf
	move.l	GrafBase,d1
	move.l	d1,a1
	beq.s	Close_DOS				; was Grafix open?
	movea.l	4.w,a6
	jsr	_LVOCloseLibrary(a6)
Close_DOS
	move.l	DosBase,d1
	move.l	d1,a1
	beq.s	Close_Intuition				; was DOS open?
	movea.l	4.w,a6
	jsr	_LVOCloseLibrary(a6)
Close_Intuition
	move.l	IntuiBase,d1
	move.l	d1,a1
	beq.s	Quit_Game				; was Intuition open?
	movea.l	4.w,a6
	jsr	_LVOCloseLibrary(a6)
Quit_Game
	moveq	#0,d0					; return code
	move.l	d0,-(a7)
	tst.l	ReturnMsg				; were we WBench launched ?
	beq.s	Quit_All				; no, so just quit
	movea.l	4.w,a6
	jsr	_LVOForbid(a6)				; yes, so return the message we got.
	movea.l	ReturnMsg(pc),a1
	jsr	_LVOReplyMsg(a6)
Quit_All
	move.l	(a7)+,d0				; pick up return code. 0 = success.
	rts						; finished!
********************************************************************************************
End_of_File
