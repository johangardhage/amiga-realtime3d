*****************************************************************************************
*                                      Wrld_vw.s                                        * 
* joystick control of the view frame for Chap. 9                                        *
*****************************************************************************************
;USE_TOF EQU 1 ;when set will use WaitTOF() else WaitBOVP() (WaitTOF breaks Forbid()).
;USE_FILES        EQU 1
DOUBLE_BUFFERING EQU 1
MY_NTSC          EQU 1  If set HEIGHT = 200 else = 256.
;USE_VBLANK       EQU 1
;TESTING_VBLANK   EQU 1		switch to turn only writing loaded gfx to one bitmap
THIRTYTWOCOLOURS EQU 1
;SIXTEENCOLOURS   EQU 1
KILLTASKS        EQU 1
JOY2 EQU 1 select desired joystick routine
****************************************************************************************	
	include startup.s
 
 include core_06.s
 include data_05.s
 include bss_06.s
**************************************************************************************** 
display
	movem.l	d0-d7/a0-a6,-(sp)
	IFD KILLTASKS
	movea.l	$4.w,a6
		jsr	_LVOForbid(a6)           This wont work if you use WaitTOF().		
	ENDC

	jsr wrt_phys_tbl	
	bsr transfer
	move.w oncoords,vncoords
	move.w vncoords,wncoords
* Initialise dynamic variables
 move.w #0,Ovx view frame initial pos
 move.w #0,Ovy
 move.w #-200,Ovz
* Set up view frame base vectors
*1. iv
 lea iv,a0 align view frame axes
 move.w #$4000,(a0)+
 clr.w (a0)+
 clr.w (a0)
*2. jv
 lea jv,a0 with the world frame
 clr.w (a0)+
 move.w #$4000,(a0)+
 clr.w (a0)
*3.kv
 lea kv,a0
 clr.w (a0)+
 clr.w (a0)+
 move.w #$4000,(a0)
 
 clr.w speed start at rest
 clr.w viewflag
 
displayloop ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*
 move.l #1,frame_done        * swap copperlist and bitplane pointers. LoadView 
	IFND USE_VBLANK
	jsr	vblank_code
	ENDC	
wait_vblank                  *
 tst.l frame_done            *
 bne wait_vblank             *
*
	IFD DOUBLE_BUFFERING	
 move.l workplanes,a0        pointer to bitplane lists
 ELSEIF
 move.l showplanes,a0        pointer to alternative lists
 ENDC
 move.l #HEIGHT,d0    
 lsl.w  #SIXTYFOUR,d0									shift HEIGHT into correct register bits
 or.w   #WIDTH/2,d0											add width
 move.l #$dff000,a5
 bsr    clear_blit
*
 bsr joy_in
 bsr key_in
* adjust to new velocity
 bsr vel_adj
* Recalculate view frame base vectors and set up the world frame
* transform matrix
 bsr dircosines
* See if object is within the visible angle of view
 bsr viewtest
 tst.b viewflag              is it visible?
 beq displayloop             no try again
* construct compound object from same face at diff pos
 move.w nparts,d7
 subq #1,d7
 lea inst_angles,a0          list angles for each part
 lea inst_disp,a1            ditto displacements
* do one face at a time
instance
 move.w d7,-(sp)             save count
 move.w (a0)+,otheta
 move.w (a0)+,ophi
 move.w (a0)+,ogamma
 move.w (a1)+,Oox            next displacements
 move.w (a1)+,Ooy
 move.w (a1)+,Ooz
 movem.l a0/a1,-(sp)         save position in list
 bsr otranw                  obj to world transforms
 bsr w_tran_v                world to view transforms
 bsr illuminate
 bsr perspective
	bsr scrn_adj                centre window
 bsr polydraw                draw this face
* 
 movem.l (sp)+,a0/a1
 move.w (sp)+,d7             restore parts count
*
 tst.w quitflag											   are we fed up yet?
 bne   all_over              yes so quit...
* 
 dbra d7,instance            do all parts of the object
 bra displayloop
***************************************************************************************** 
all_over	
	IFD KILLTASKS			
	movea.l	$4.w,a6
		jsr	_LVOPermit(a6)
	ENDC
	movem.l (sp)+,d0-d7/a0-a6	
	rts
**********************************************************************************	
