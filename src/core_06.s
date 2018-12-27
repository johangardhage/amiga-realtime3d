*****************************************************************************************
*                                     Core_06.s                                         *
*                             subroutines for Chapter 9                                 *
*****************************************************************************************
CORE6 EQU 1
 
 include core_05.s

* Find the direction cosines for the transform from the world frame to view frame. 
* These are components of the view frame base vectors in the world frame.
* To avoid accumulating errors they are regenerated and normalised to a magnitude of:
* 2^14.
dircosines
 lea    iv,a0
 lea    jv,a1
 lea    kv,a2
* Kv is normalised
 move.w (a2),d0
 move.w 2(a2),d1
 move.w 4(a2),d2
  bsr   nrm_vec
 move.w d0,(a2)         new components
 move.w d1,2(a2)
 move.w d2,4(a2)
* calc vj from cross product of vk & vi using subroutine AxB.
* A pointer in a2: B pointer in a0:
  bsr   AxB
 move.w d0,(a1)
 move.w d1,2(a1)
 move.w d2,4(a1)
* finally the cross product of kv & jv is used for iv.
 lea    jv,a2
 lea    kv,a0
  bsr   AxB
 lea    iv,a1
 move.w d0,(a1)        regenerated iv
 move.w d1,2(a1)
 move.w d2,4(a1)
* The components of the view frame base vectors in the world frame are the elements
* of the transform matrix required for the world to view transform.
 lea w_vmatx,a0
 lea iv,a1
 lea jv,a2
 lea kv,a3
 move.w (a1)+,(a0)+ matrix elements of the view transform
 move.w (a1)+,(a0)+
 move.w (a1)+,(a0)+
 move.w (a2)+,(a0)+
 move.w (a2)+,(a0)+
 move.w (a2)+,(a0)+
 move.w (a3)+,(a0)+
 move.w (a3)+,(a0)+
 move.w (a3)+,(a0)+
 rts
*****************************************************************************************
AxB
 move.w 2(a2),d0 Ay
 muls   4(a0),d0 bz*Ay
 move.w 4(a2),d1 Az
 muls   2(a0),d1 By*Az
 sub.l  d1,d0    Bz*Ay-By*Ax
* 2nd component
 move.w 4(a2),d1 Az
 muls   (a0),d1  Bx*Az
 move.w (a2),d2  Ax
 muls   4(a0),d2 Bz*Ax
 sub.l  d2,d1    Bx*Az-Bz*Ax
* 3rd component
 move.w (a2),d2  Ax
 muls   2(a0),d2 By*Ax
 move.w 2(a2),d3 Ay
 muls   (a0),d3  Bx*Ay
 sub.l  d3,d2    By*Ax-Bx*Ay
* Reduce them to < word size by dividing by 2^14
 move   #14,d7
 lsr.l  d7,d0
 lsr.l  d7,d1
 lsr.l  d7,d2
* normalise them
 bsr    nrm_vec
 rts
*****************************************************************************************
* Do a rotation of the view frame about one of the view frame axes in the world frame.
* The direction cosines for the axis are the base vector components.

* First a rotation about the view frame x-axis, vx.
rot_vx
 lea    iv,a0        the axis of rotation
 move.w vxangle,d1   the angle to rotate
  bsr   v_rot_matx    construct the rotation matrix
* only jv and kv are affected
 lea    jv,a0        1st transform
  bsr   rot_view
 lea    kv,a0        2nd transform
  bsr   rot_view
 rts
*--------------------------------------------------
rot_vy
 lea    jv,a0
 move.w vyangle,d1
 bsr    v_rot_matx
* only iv and kv are affected
 lea    iv,a0        1st transform
  bsr   rot_view
 lea    kv,a0        2nd transform
  bsr   rot_view
 rts
*--------------------------------------------------
rot_vz
 lea    kv,a0
 move.w vzangle,d1
 bsr    v_rot_matx
* only iv and kv are affected
 lea    iv,a0        1st transform
  bsr   rot_view
 lea    jv,a0        2nd transform
  bsr   rot_view
 rts
*--------------------------------------------------
* Rotate a view frame base vector. The vector is pointed to by a0. Since it is
* a unit vector it is specified by three components which are the direction cosines.
* (nx, ny, nz).
rot_view
 moveq #2,d6            rows in matrix
 lea   vrot_matx,a3
 link  a6,#-6
rot_vw1
 move.w (a0),d0        nx components
 move.w 2(a0),d1       ny
 move.w 4(a0),d2       nz
 muls   (a3)+,d0       nx*Mi1
 muls   (a3)+,d1       ny*Mi2
 muls   (a3)+,d2       nz*Mi3
 add.l  d1,d0
 add.l  d2,d0
 lsl.l  #2,d0
 swap   d0
 move.w d0,-(a6)
 dbra   d6,rot_vw1
 
 move.w (a6)+,4(a0)   z
 move.w (a6)+,2(a0)   y
 move.w (a6)+,(a0)    x
 unlk   a6
 rts
***************************************************************************************
* Construct the rotation matrix for rotations about an arbitrary axis specified by a
* unit vector with components (direction cosines) n1, n2, n3.
* ENTRY: Pointer to direction cosines in a0: Angle in d0.
v_rot_matx
 lea vrot_matx,a6
 bsr sincos
 move.w d2,d6        sine delta
 move.w d3,d7        cos delta
* elements M12 and M21
 move   #16384,d5
 move   d5,d0
 move.w (a0),d1      n1
 muls   2(a0),d1     n1*n2
 lsl.l  #2,d1
 swap   d1
 sub.w  d7,d0        1-cosdelta
 move   d0,d4
 muls   d1,d0
 lsl.l  #2,d0
 swap   d0           n1*n2(1-cosdelta)
 move   d0,d2
 move.w 4(a0),d1     n3
 muls   d6,d1        n3*sindelta
 lsl.l  #2,d1
 swap   d1
 sub.w  d1,d0        n1*n2(1-cosdelta)-n3*sindelta
 move.w d0,2(a6)     M12
 add.w  d1,d2        n1*n2(1-cosdelta)+n3*sindelta
 move.w d2,6(a6)     M21
* elements M13 and M31
 move   d4,d0        1-cosdelta
 muls   (a0),d0      n1*(1-cosdelta)
 lsl.l  d0
 swap   d0
 muls   4(a0),d0     n1*n3(1-cosdelta)
 lsl.l  #2,d0
 swap   d0
 move   d0,d2
 move.w 2(a0),d1     n2
 muls   d6,d1        n2*sindelta
 lsl.l  #2,d1
 swap   d1
 add.w  d1,d0        n1*n3(1-cosdelta)+n2*sindelta
 move.w d0,4(a6)     M13
 sub.w  d1,d2        n1*n3(1-cosdelta)-n2*sindelta
 move.w d2,12(a6)    M31
* elements M23 and M32
 move   d4,d0        1-cosdelta
 muls   2(a0),d0     n2*(1-cosdelta)
 lsl.l  #2,d0
 swap   d0
 muls   4(a0),d0     n2*n3(1-cosdelta)
 lsl.l  #2,d0
 swap   d0
 move   d0,d2
 move.w (a0),d1      n1
 muls   d6,d1        n1*sindelta
 lsl.l  #2,d1
 swap   d1
 sub.w  d1,d0        n2*n3(1-cosdelta)-n1*sindelta
 move.w d0,10(a6)    M23
 add.w  d1,d2        n2*n3(1-cosdelta)+n1*sindelta
 move.w d2,14(a6)    M32
* elemnt M11
 move.w (a0),d1      n1
 muls   d1,d1        n1*n1
 lsl.l  #2,d1
 swap   d1
 move   d5,d2        1
 sub.w  d1,d2        1-n1*n1
 muls   d7,d2        (1-n1*n1)cosdelta
 lsl.l  #2,d2
 swap   d2
 add.w  d2,d1        n1*n1+(1-n1*n1)cosdelta
 move.w d1,(a6)      M11
* element M22
 move.w 2(a0),d1     n2
 muls   d1,d1        n2*n2
 lsl.l  #2,d1
 swap   d1
 move   d5,d2        1
 sub.w  d1,d2        1-n2*n2
 muls   d7,d2        (1-n2*n2)cosdelta
 lsl.l  #2,d2
 swap   d2
 add.w  d2,d1        n2*n2+(1-n2*n2)cosdelta
 move.w d1,8(a6)     M22
* element M33
 move.w 4(a0),d1     n3
 muls   d1,d1        n3*n3
 lsl.l  #2,d1
 swap   d1
 move   d5,d2
 sub.w  d1,d2        1-n3*n3
 muls   d7,d2        (1-n3*n3)cosdelta
 lsl.l  #2,d2
 swap   d2
 add.w  d2,d1        n3*n3+(1-n3*n3)cosdelta
 move.w d1,16(a6)    M33
 rts
************************************************************************
w_tran_v
 move.w wncoords,d7
 ext.l d7 any to do?
 beq w_tranv3
 subq.w #1,d7
 lea wcoordsx,a0
 lea wcoordsy,a1
 lea wcoordsz,a2
 lea vcoordsx,a3
 lea vcoordsy,a4
 lea vcoordsz,a5
 exg   a3,d3        save cos we're short of registers
 link  a6,#-6       save 3 words
w_tranv1
 moveq.l #2,d6     3 rows in matrix
 lea w_vmatx,a3    init max pointer
* calculate the next vx, vy and vz
w_tranv2
 move.w (a0),d0          wx
 move.w (a1),d1          wy
 move.w (a2),d2          wz
 sub.w  Ovx,d0    
 sub.w  Ovy,d1     
 sub.w  Ovz,d2     
 muls   (a3)+,d0         wx*Mi1
 muls   (a3)+,d1         wy*Mi2
 muls   (a3)+,d2         wz*Mi3
 
 add.l  d1,d0
 add.l  d2,d0            wx*Mi+wy*Mi2+wz*Mi3
 lsl.l  #2,d0
 swap   d0
 move.w d0,-(a6)
 dbra   d6,w_tranv2     repeat for 3 elements
 
 move.w (a6)+,(a5)+
 move.w (a6)+,(a4)+
 exg    a3,d3           restore vx, save matx pointer
 move.w (a6)+,(a3)+
 exg    a3,d3           save vx, restore matx pointer
 addq.l #2,a0           point to next wx
 addq.l #2,a1           wy
 addq.l #2,a2           wz
 dbra   d7,w_tranv1     repeat for all ocoords
 unlk   a6              close frame
w_tranv3
 rts
****************************************************************************************
* Set the velocity components
vel_adj
 lea     kv,a0
 moveq.l #14,d7         ready to divide by 2^14
 move.w  speed,d0
 lsl.w   #3,d0          scale it
 move    d0,d1
 move    d0,d2
 muls    (a0),d0        v*VZx
 lsr.l   d7,d0          /2^14
 add.w   d0,Ovx         xw speed component
 muls    2(a0),d1       v*VZy
 lsr.l   d7,d1
 add.w   d1,Ovy         zw speed component
 muls    4(a0),d2       v*VZz
 lsr.l   d7,d2
 add.w   d2,Ovz
 rts
****************************************************************************************
* test whether the primitive is vsible. see whether its centre (oox,Ooy,Ooz) lies within
* the angle of visibilty. Oox, Ooy and Ooz are transformed to view coords and then tested.
viewtest
 moveq.l #2,d6 rows in matrix
 lea     w_vmatx,a3
 link    a6,#-6
 move.w  Oox,d3
 addi.w  #50,d3
 move.w  Ooy,d4
 addi.w  #50,d4
 move.w  Ooz,d5
 addi.w  #50,d5
 sub.w   Ovx,d3       Oox-Ovx relative to the view frame
 sub.w   Ovy,d4
 sub.w   Ovz,d5
tran0v
 move    d3,d0
 move    d4,d1
 move    d5,d2
 muls    (a3)+,d0     *Mi1
 muls    (a3)+,d1     *Mi2
 muls    (a3)+,d2     *Mi3
 add.l   d1,d0
 add.l   d2,d0        *Mi1+*Mi2+*Mi3
 lsl.l   #2,d0
 swap    d0
 move.w  d0,-(a6) 
 dbra    d6,tran0v   repeat for three elements
 
 move.w  (a6)+,d3    Voz
 move.w  (a6)+,d2    Voy
 move.w  (a6)+,d1    Vox
 move.w  d3,Voz
 move.w  d2,Voy
 move.w  d1,Vox
 unlk    a6
* Clip Ovz. For visibility must have 100<Voz<2000
 cmpi.w  #100,d3     test(Voz-100)
 bmi     invis
 cmpi.w  #2000,d3    test(Voz-2000)
 bpl     invis
* is it within the view angle?
 addi.w  #100,d3     Voz+100
 add.w   d3,d3       *2
 add.w   d3,d3       *4
 add.w   d3,d3       *8
* First test horizontal position
 tst.w   d2          is Voy +ve or -ve
 bpl     pos_y
 neg.w   d2 
pos_y
 cmp.w   d2,d3       Voy is +, (test(8*(Voz+100)_Voy))
 bmi invis
* Test vertical position
 tst.w   d1 Vox
 bpl     pos_x
 neg.w   d1
pos_x
 cmp.w   d1,d3       test(8(Voz+100)-Vox)
 bmi     invis
* It IS visible
 st      viewflag
 rts
* It is INVISIBLE
invis
 sf      viewflag
 rts
**************************************************************************************
*Adjust screen coords so that view frame (0,0) is at centre
scrn_adj
 move.w  vncoords,d7
 beq     adj_end
 subq.w  #1,d7
 lea     scoordsy,a0
adj_loop
 subi.w  #100,(a0)+
 dbra    d7,adj_loop
adj_end
 rts 
 
 
 


 
