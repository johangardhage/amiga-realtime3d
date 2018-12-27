*****************************************************************************************
*                                       Trnsfrms.s                                      * 
*                                     Various 3D transforms                             *
* Uses Joystick to rotate on the x & y axes.
* Function keys F1 -> F7: 1 zoom in: 2 zoom out: 3,4,5 shear x,y,z: 6 stop zoom:
*                         7 Quit.
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
JOY1 EQU 1       select desired joystick routine
****************************************************************************************	
	include startup.s
 
 include core_05.s
 include data_05.s
 include bss_05.s
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
 move.w #-50,Ovx view frame initial pos
 move.w #0,Ovy
 move.w #150,Ovz
 clr.w vtheta
 clr.w vphi
 clr.w vgamma
 clr.w shearflag
 move.w #25,vtheta_inc    initial rotation values
 move.w #25,vphi_inc
 clr.w speed
	
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
* adjust to new rotation angles and speed
 bsr angle_update
 bsr speed_adj
* construct compound object from same face at diff pos
 move.w nparts,d7
 subq #1,d7
 lea inst_angles,a0       list angles for each part
 lea inst_disp,a1         ditto displacements
* do one face at a time
instance
 move.w d7,-(sp)          save count
 move.w (a0)+,otheta
 move.w (a0)+,ophi
 move.w (a0)+,ogamma
 move.w (a1)+,Oox         next displacements
 move.w (a1)+,Ooy
 move.w (a1)+,Ooz
 movem.l a0/a1,-(sp)      save position in list
 bsr otranw               obj to world transforms
 bsr wtranv_1             construct rotation transform
 bsr shear
 bsr wtranv_2             transform points
 bsr illuminate
 bsr perspective
	
 bsr polydraw
* 
 movem.l (sp)+,a0/a1
 move.w (sp)+,d7             restore parts count
*
 tst.w quitflag											 are we fed up yet?
 bne.s   all_over                 yes so quit...
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
