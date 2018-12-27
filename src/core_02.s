******************************************************************************************
*                                     Core_02.s
*                                 Perspective stuff
******************************************************************************************
 include core_01.s
 
perspective
 move.w vncoords,d7 any points to do?
 beq prs_end
 subq.w #1,d7 counter
 lea vcoordsx,a0
 lea vcoordsy,a1
 lea vcoordsz,a2
 lea scoordsx,a4
 lea scoordsy,a5
 link a6,#-32      open 16 word frame
prs_crd
 moveq #3,d6
 lea persmatx,a3
prs_elmnt
 move.w (a0),d0
 move.w (a1),d1
 move.w (a2),d2
 muls (a3)+,d0
 muls (a3)+,d1
 muls (a3)+,d2
 add.l d1,d0
 add.l d2,d0
 move.w #1,d1
 muls (a3)+,d1
 add.l d1,d0
 move.l d0,-(a6)
 dbra d6,prs_elmnt
 move.l (a6)+,d3
 bne prs_ok
 addq #1,d3
prs_ok
 addq.l #4,a6
 move.l (a6)+,d4
 divs d3,d4
 add.w #160,d4
 move.w d4,(a4)+
 move.l (a6)+,d4
 divs d3,d4
 sub.w #199,d4
 neg.w d4
 move.w d4,(a5)+
 addq.l #2,a0
 addq.l #2,a1
 addq.l #2,a2
 dbra d7,prs_crd
 unlk a6
prs_end
 rts
 
polydraw
 move.w npoly,d7
 beq polydraw5
 subq #1,d7
 lea scoordsx,a0
 lea scoordsy,a1
 lea sedglst,a2
 lea snedges,a3
 lea col_lst,a4
polydraw2
 move.w (a4)+,d0
 cmp.w #$1f,d0
 ble polydraw3
 
 move.w (a3)+,d0
 addq.w #1,d0
 add d0,d0
 adda.w d0,a2
 bra polydraw4
polydraw3
 move.w d0,colour
 move.w (a3)+,d0
 beq polydraw3
 move.w d0,no_in
 lea crds_in,a5
 
polydraw1
 move.w (a2)+,d1
 lsl #1,d1
 move.w 0(a0,d1.w),(a5)+ 
 move.w 0(a1,d1.w),(a5)+
 dbra d0,polydraw1
 movem.l d7/a0-a4,-(sp)
 bsr clip
 bsr poly_fill
 movem.l (sp)+,d7/a0-a4
polydraw4
 dbra d7,polydraw2
polydraw5
 rts
 




