*****************************************************************************************
*                                   Core_07.s                                           *
*                           subroutines for chapter 10                                  *
*****************************************************************************************
 include core_06.s
 
scne_drw          ; draw a scene of several primitives
 bsr patch_ext      select the local scene
 bsr sight_tst      select only the visible ones
 bsr vis_srt        sort in depth order
 bsr drw_it         draw them in depth order
 rts
*****************************************************************************************
* Extract the tile patch. Put the 16 tiles in a list at patch_lst
patch_ext
 move.w oposx,d0 observers x pos
 move.w oposy,d1
 move.w oposz,d2
* Find position in world. Keep to range 4096
 andi.w #$fff,d0   range x
 andi.w #$fff,d1   range y
 andi.w #$fff,d2   range z
 move.w d0,oposx   restore x etc..
 move.w d1,oposy
 move.w d2,oposz
 move.w d1,d3
 move.w d2,d4
* Find coords of patch centre=local world origin
 lsr.w  #8,d1 
 move.w d1,Ty      y coord. in 16*16 layout
 lsr.w  #8,d2
 move.w d2,Tz      z coord
* Coords of view frame, referenced to this origin
 lsl.w  #8,d1      Ty*256
 lsl.w  #8,d2      Tz*256
 sub.w  d1,d3      oposy-Ty*256 = Ovy
 move.w d3,Ovy
 sub.w  d2,d4      opoz-Tz*256 = Ovz
 move.w d4,Ovz
 move.w oposx,Ovx (the height is universal)

* Fetch the attributes of the 16 surrounding tiles from the map and calculate their world
* coords. Store the data in a record/structure with the format:-
* WORD 1 : HIBYTE - graphics attribute
*          LOBYTE - clear
* WORD 2 : Voz tile centre z in view frame coords
* WORD 3 : tile y in local world coords
* WORD 4 : ditto z
* Ty & Tz are the patch centre coords = local world origins.
 
 move.w  Ty,d0
 move.w  Tz,d1
* A 4*$ patch of tiles centred on the Ty,Tz are retrieved
 move.w  #-2,d5          z offset of start tile
 lea     map_base,a0
 lea     patch_lst,a1    the local list of 4*4
 move.w  #3,d7           4 z values
tile_lp1
 move.w  #-2,d4          reset start yoffset
 move.w  #3,d6           4 y values
 move.w  d1,d3           origin Tz
 add.w   d5,d3           +offset = next z
 andi.w  #$f,d3          stay in range 0-15
 lsl.w  #4,d3            *16
tile_lp2
 move   d0,d2            origin Ty
 add.w  d4,d2            +offset = next y
 andi.w #$f,d2           stay in range 0-15
 add.w  d3,d2            16*z+y = tile address in map
 move.b 0(a0,d2.w),d2    fetch attribute in low byte
 swap   d2               of high word
 clr.w  d2               0 for low word
 lsl.l  #8,d2            everything into high word
 move.l d2,(a1)+         store the first half of the record
* Calculate the tile local coords: Ooy & Ooz. Coords are offset*256.
 movem.l d4/d5,-(sp)     stack offsets
 lsl    #8,d4            yoffset*256
 swap   d4               in high word
 lsl    #8,d5            zoffset*256
 move.w d5,d4            in low word
 move.l d4,(a1)+
 movem.l (sp)+,d4/d5     restore offsets
 addq   #1,d4            next y offset
 dbra   d6,tile_lp2      for all tiles in this row
 addi.w #1,d5            next z offset
 dbra   d7,tile_lp1      for all rows
 rts
******************************************************************************************
sight_tst
 lea    patch_lst,a0     pointer to source list
 lea    vis_lst,a1       list of visible tiles
 lea    vis_cnt,a2       count of previous
 clr.w  (a2)             zero count
 move.w #15,d7           16 tiles in a patch
 clr.w  Oox              all tiles are on the ground
sight_tst1
 move.w 4(a0),d0                                        
 addi.w #128,d0
 move.w d0,Ooy           tile
 move.w 6(a0),d0
 addi.w #128,d0
 move.w d0,Ooz           centres
 movem.l d7/a0-a2,-(sp)
  bsr    testview        is tile within filed of vision
 movem.l (sp)+,d7/a0-a2
 tst.b  viewflag         visible?
 beq    nxt_tile
 addq.w #1,(a2)          yes, increment visible count
 move.w Voz,2(a0)        save the depth for sorting
 move.l (a0),(a1)+       transfer 1st half to visible list
 move.l 4(a0),(a1)+      2nd half
nxt_tile
 addq   #8,a0            point to next record
 dbra   d7,sight_tst1    for all tiles
 rts
******************************************************************************************
*Test whether the primitive is visible.
* Tile centre (Oox, Ooy, Ooz) transformed to view coords then tested. Correct for 2^14.
testview
 moveq.l #2,d6          3 rows in matrix
 lea     w_vmatx,a3     init max pointer
 link    a6,#-6         3 words to store temporarily
 move.w  Oox,d3
 move.w  Ooy,d4
 move.w  Ooz,d5
 sub.w   Ovx,d3         Oox-Ovx rel to the view frame
 sub.w   Ovy,d4         Ooy-Ovy
 sub.w   Ovz,d5         Ooz-Ovz
tranv0
 move d3,d0 restore
 move d4,d1
 move d5,d2
 muls (a3)+,d0 *Mi1
 muls (a3)+,d1 *Mi2
 muls (a3)+,d2 *Mi3
 add.l d1,d0
 add.l d2,d0 *Mi1+*Mi2+*Mi3
 lsl.l #2,d0
 swap d0 /2^14
 move.w d0,-(a6) save it
 dbra d6,tranv0 repeat for 3 elements
 move.w (a6)+,d3 off my stack becomes Voz
 move.w (a6)+,d2 off my stack becomes Voy (centre in view frame)
 move.w (a6)+,d1 off my stack becomes Vox
 move.w d3,Voz
 move.w d2,Voy
 move.w d1,Vox
 unlk a6
* Clip Ovz. To be visible must have 50<Voz<2000
* This test only looks at depth.
 cmp.w #50,d3 test(Voz-50)
 bmi notvis fail
 cmp.w #2000,d3 test(Voz-2000)
 bpl notvis fail
 st viewflag we can see it
 rts
notvis
 sf viewflag can't see it
 rts
*****************************************************************************************
* Order the visible tiles in orderof decreasing Voz (the distance of the tile centre from
* the view frame origin). Largest Voz's (furthest) should be drawn first.
vis_srt
 move.w vis_cnt,d7 number to do
 beq srt_quit
 subq #1,d7
 beq srt_quit
 subq #1,d7
* Bubble sort
vis_srt1
 lea vis_lst+2,a0 pointer to 1st record Voz
 movea.l a0,a1
 addq.l #8,a1 pointer to 2nd Voz
 move d7,d6 reset count
 clr.w srt_flg
vis_srt2
 cmpm.w (a0)+,(a1)+ test(Voz2-Voz1)
 ble no_swap 1st is farther
 move.l -4(a0),d0 fetch 1st record
 move.l (a0),d1
 move.l -4(a1),-4(a0) make
 move.l (a1),(a0) 2nd the 1st
 move.l d0,-4(a1) & 1st
 move.l d1,(a1) 2nd
 st srt_flg
no_swap
 addq.l #6,a0 point to next record Voz
 addq.l #6,a1 and the one follwing
 dbra d6,vis_srt2
 tst.w srt_flg
 beq srt_quit
 bra vis_srt1
srt_quit
 rts
*****************************************************************************************
drw_it
* draw the visible tiles
 move.w vis_cnt,d7
 beq drw_it_out
 subq.w #1,d7
 lea vis_lst,a0 ptr to list
drw_it1
 movem.l d7/a0,-(sp)
 bsr set_prim drw next prim
 movem.l (sp)+,d7/a0
 addq.l #8,a0 next record
 dbra d7,drw_it1
drw_it_out
 rts
*****************************************************************************************
* Set up next primitive for drawing; pointer to record in a0.
* 1. DO BACKGROUND
set_prim
 move.l a0,-(sp) save ptr
 bsr ldup_bkg
 bsr otranw obj->world
 bsr w_tran_v world->view
* Background always visible at a constant illumination level
 movea.l (sp)+,a0 restore ptr
 move.w (a0),d0 1st word of record
 move.l a0,-(sp) save pointer
 lsr.w #8,d0 top byte
 lsr.w #4,d0 top nibble is colour 
 move.w d0,col_lst the final colours
 move.w d0,col_lst+2
 bsr perspective
 bsr scrn_adj centre it
 bsr polydraw
*2. Draw the object
 movea.l (sp)+,a6 restore pointer
 bsr ldup_obj
 bsr otranw
 bsr w_tran_v
 bsr illuminate
 bsr perspective
 bsr scrn_adj
 bsr polydraw
 rts
*****************************************************************************************
* Load background data as program data. Background is a grid.
ldup_bkg
 move.w #2,npoly 2 rectangles
 move.l #$40004,snedges 4 edges in each
 lea sedglst,a2 edgelist 0,1,2,3,0,4,5,6,7,4
 move.l #1,(a2)+ edges 0,1
 move.l #$20003,(a2)+ 2,3
 move.l #4,(a2)+ 0,4
 move.l #$50006,(a2)+ 5,6
 move.l #$70004,(a2)+ 7,4
* The background vertices define a cross. All x coords are zero.
 lea ocoordsx,a2  vertex coords x =
 move.l #0,(a2)+ 0,0
 move.l #0,(a2)+ 0,0
 move.l #0,(a2)+ 0,0
 move.l #0,(a2)  0,0
 lea ocoordsy,a2 y =
 move.l #$ff800080,(a2)+ -128,128
 move.l #$80ff80,(a2)+ 128,-128
 move.l #$fffcfffc,(a2)+ -4,-4
 move.l #$40004,(a2) 4,4
 lea ocoordsz,a2
 move.l #$40004,(a2)+ 4,4
 move.l #$fffcfffc,(a2)+ -4,-4
 move.l #$ff800080,(a2)+ -128,128
 move.l #$80ff80,(a2)+ 128,-128
 move.w #8,oncoords
 move.w #8,vncoords 
 move.w #8,wncoords
* The tile centre in the world frame is Oox=0 and the contents of the 3rd & 4th
* words of the records.
 move.w #0,Oox
 move.w 4(a0),Ooy 3rd word
 addi.w #128,Ooy
 move.w 6(a0),Ooz 4th word
 addi.w #128,Ooz
 clr.w otheta no orientation
 clr.w ophi
 clr.w ogamma
 rts
****************************************************************************************
* This has no label in the book and therefore it seems unlikely that it will ever be used.
 move.w #1,npoly 1 rectangles
 move.l #$4,snedges 4 edges
 lea    sedglst,a2 edgelist 0,1,2,3,0
 move.l #1,(a2)+ edges 0,1
 move.l #$20003,(a2)+ 2,3
 move.l #0,(a2)+ 0,4
* The background vertices are the corners of the tile.
 lea ocoordsx,a2 vertex coords x =
 move.l #0,(a2)+ 0,0
 move.l #0,(a2)+ 0,0
 move.l #0,(a2)+ 0,0
 move.l #0,(a2)+  0,0
 lea ocoordsy,a2 y =
 clr.l (a2)+
 move.l #$ff00ff,(a2)
 lea ocoordsz,a2
 move.l #$ff,(a2)+ 0,255
 move.l #$ff0000,(a2)+ 255,0
 move.w #4,oncoords
 move.w #4,vncoords 
 move.w #4,wncoords
* The tile centre in the world frame is Oox=0 and the contents of the 3rd & 4th
* words of the records.
 move.w #0,Oox
 move.w 4(a0),Ooy 3rd word
 move.w 6(a0),Ooz 4th word
 clr.w otheta no orientation
 clr.w ophi
 clr.w ogamma
 rts
****************************************************************************************
ldup_obj
* Find out what type of object it is.
 move.w (a6),d0 top word
 lsr.w #8,d0 top byte
 andi.w #$f,d0 low nibble is type (call it n)
 lsl.w #2,d0 *4 for offset
 lea primitive,a5 ptr to vector table
 movea.l 0(a5,d0.w),a5 ptr to type n lists
 movea.l 4(a5),a2 pointer to npolyn
 move.w (a2),d7 got it
 move.w d7,npoly
 subq.w #1,d7
 move d7,d0
 movea.l 8(a5),a0 ptr to nedge list
 movea.l a0,a4 saved
 lea snedges,a1 destination
 move.l (a5),a2 ptr to intrinsic colours
 lea srf_col,a3 dest
obj_lp1
 move.w (a0)+,(a1)+ transfer edge numbers
 move.w (a2)+,(a3)+ transfer intrinsic colours
 dbra d0,obj_lp1
* Calculate total number of edges
 move.w d7,d0 retore count
 clr d1
 clr d2
obj_lp2
 add.w (a4)+,d2 number of edges
 addq #1,d2 and with last repeated
 dbra d0,obj_lp2 
* Move the edge list
 subq #1,d2 counter
 movea.l 12(a5),a0 edglstn, the source
 lea sedglst,a1 dest
obj_lp3
 move.w (a0)+,(a1)+ pass it
 dbra d2,obj_lp3
* and the coords list
 movea.l 28(a5),a0 ptr to num vertices
 move.w (a0),d1 num vertices
 move.w d1,oncoords
 move.w d1,vncoords
 move.w d1,wncoords
 subq #1,d1 counter
 movea.l 16(a5),a0 ptr to object x
 lea ocoordsx,a1
 movea.l 20(a5),a2 object y
 lea ocoordsy,a3
 movea.l 24(a5),a4 object z
 movea.l a5,a6
 lea ocoordsz,a5
obj_lp4
 move.w (a0)+,(a1)+
 move.w (a2)+,(a3)+
 move.w (a4)+,(a5)+
 dbra d1,obj_lp4
* Increment the rotation angle
 bsr next_rot
 addi.w #128,Ooy
 addi.w #128,Ooz
 rts
*****************************************************************************************
* Increment the rotation of the object.
next_rot
 movea.l 32(a6),a0 ptr to angle and flag
 move.l (a0),d0 top word is flag, bottom is angle
 move.l d0,d1
 andi.l #$ffff,d0 the angle
 addi.w #2,d0 increment it
 cmp #360,d0
 blt obj_lp5
 subi #360,d0 
obj_lp5
 move.w d0,2(a0) next angle
* see what angles to rotate
 swap d1
 andi.w #$f,d1 flag in lo nib
* flags are set:bit 0= xrot 1=yrot 2=zrot
 lsl.w #2,d1 offset
 lea rot_vec,a0 ptr to jump table
 move.l 0(a0,d1.w),a0
 jmp (a0)
rot_vec
 dc.l no_rot,rotx,roty,rotxy,rotz,rotxz,rotyz,rotxyz
no_rot rts
rotx
 move.w d0,otheta
 rts
roty
 move.w d0,ophi
 rts
rotxy
 move.w d0,otheta
 move.w d0,ophi
 rts
rotz
 move.w d0,ogamma
 rts
rotxz
 move.w d0,otheta
 move.w d0,ogamma
 rts
rotyz
 move.w d0,ophi
 move.w d0,ogamma
 rts
rotxyz
 move.w d0,otheta
 move.w d0,ophi
 move.w d0,ogamma
 rts
****************************************************************
* These are the rotations the joystick reader sends us here.
rot_down
 lea rot_y_neg,a0 ptr to ctrl matrix
 bsr ctrl_view
 rts
rot_up
 lea rot_y_pos,a0 ptr to ctrl matrix
 bsr ctrl_view
 rts
rot_left
 lea rot_x_pos,a0 ptr to ctrl matrix
 bsr ctrl_view
 rts 
rot_right
 lea rot_x_neg,a0 ptr to ctrl matrix
 bsr ctrl_view
 rts
roll_left
 lea rot_z_neg,a0 ptr to ctrl matrix
 bsr ctrl_view
 rts
roll_right
 lea rot_z_pos,a0 ptr to ctrl matrix
 bsr ctrl_view
 rts
ctrl_view
* multiply the control matrix poited to by a0 by the view matrix
* to calculate the new elements of the view base vectors.
* 1.base vector iv
 lea w_vmatx,a1 ptr to view matrix
 lea iv,a2 ptr to view frame base vector
 move.w #2,d6 3 elements to iv
 movea.l a1,a3 set view ptr
iv_loop
 move.w (a3),d1    next view elements
 move.w 6(a3),d2  
 move.w 12(a3),d3
 muls (a0),d1
 muls 2(a0),d2
 muls 4(a0),d3
 add.l d2,d1
 add.l d3,d1
 lsl.l #2,d1
 swap d1
 move.w d1,(a2)+ next element in base vector
 addq.l #2,a3 next column in base vector
 dbra d6,iv_loop
*2. No need to do jv; it's calculated from the other two.
*3. base vector kv
 lea kv,a2
 move.w #2,d6
 movea.l a1,a3
kv_loop
 move.w (a3),d1
 move.w 6(a3),d2  
 move.w 12(a3),d3
 muls 12(a0),d1
 muls 14(a0),d2
 muls 16(a0),d3
 add.l d2,d1
 add.l d3,d1
 lsl.l #2,d1
 swap d1
 move.w d1,(a2)+ next element in base vector
 addq.l #2,a3 next column in base vector
 dbra d6,kv_loop
 rts
*****************************************************************************************
* Set the velocity components
adj_vel
 lea kv,a0
 move.w #14,d7
 move.w speed,d0
 lsl.w #4,d0
 move d0,d1
 move d0,d2
 muls (a0),d0 v*VZx
 lsr.l d7,d0
 add.w d0,oposx xw speed component
 bpl adj1
 clr.w oposx oposx must be > 0
adj1
 muls 2(a0),d1 v*VZy
 lsr.l d7,d1
 add.w d1,oposy yw speed component
 muls 4(a0),d2 v*VZz
 lsr.l d7,d2
 add.w d2,oposz zw speed component
 rts
 

 
 


 
 


 
 
 


 
 

 
 
 
 
