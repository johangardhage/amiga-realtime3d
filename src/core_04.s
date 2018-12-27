m*****************************************************************************************
* Core_04.s
* 
*****************************************************************************************
 include core_03.s
 
illuminate
calc_nrm
 move.w npoly,d7
 beq    nrm_out
 subq   #1,d7           counter
 lea    vcoordsx,a0
 lea    vcoordsy,a1
 lea    vcoordsz,a2
 lea    sedglst,a3
 lea    snedges,a4
 lea    snormlst,a5
* calculate the surface normal unit vectors
next_nrm
 move.l a5,-(sp)       save pointer to normals list
 move.w (a3),a5        first vertex of next surface
 move.w 2(a3),a6       second vertex
 add    a5,a5          *2 for offset
 add    a6,a6 again
 move.w 0(a0,a6.w),d1  x2
 sub.w  0(a0,a5.w),d1  x2-x1 = A12x
 move.w 0(a1,a6.w),d2  y2
 sub.w  0(a1,a5.w),d2  y2-y1 = A12y
 move.w 0(a2,a6.w),d3  z2
 sub.w  0(a2,a5.w),d3  z2-z1 = A12z
 move   a6,a5
 move.w 4(a3),a6       third vertex
 add    a6,a6          *2 for offset
 move.w 0(a0,a6.w),d4  x3
 sub.w  0(a0,a5.w),d4  x3-x2 = A23x
 move.w 0(a1,a6.w),d5  y3
 sub.w  0(a1,a5.w),d5  y3-y2 = A23y
 move.w 0(a2,a6.w),d6  z3
 sub.w  0(a2,a5.w),d6  z3-z2 = A23z
 movea.w d2,a5         save
 muls   d6,d2
 movea.w d3,a6         save
 muls   d5,d3          ditto
 sub.l  d2,d3          Bx
 move.l d3,-(sp)       save to stack
 move.w a5,d2          restore
 move.w a6,d3          restore
 movea.w d3,a5         save
 muls   d4,d3
 movea.w d1,a6
 muls   d6,d1
 sub.l  d3,d1          By
 move.l d1,-(sp)       save it
 move.w a6,d1          restore
* last component -  no need to save values
 muls   d5,d1
 muls   d4,d2
 sub.l  d1,d2          Bz
 move.l d2,-(sp)       save it
 movem.l (sp)+,d4-d6   Bx in d6, By in d5 and Bz in d4
nrm_cmpt
 lsr.l  #2,d4          /4 to prevent overspill
 lsr.l  #2,d5
 lsr.l  #2,d6
 move.w d4,d0
 move.w d5,d1
 move.w d6,d2
 move.l d7,-(sp)       save
 bsr    nrm_vec        calculate unit vectors bx, by, bz
 move.l (sp)+,d7       restore
 move.w d0,d4
 move.w d1,d5
 move.w d2,d6
 move.l (sp)+,a5       retore pointer to normals list
 move.w d6,(a5)+       save nx
 move.w d5,(a5)+       save ny
 move.w d4,(a5)+       save nz
 move.w (a4)+,d0       num vertices in this surface
 add    #1,d0          edge list always repeats the first
 add    d0,d0          *2 for offset
 adda.w d0,a3          adjust pointer to next surface
 dbra   d7,next_nrm    do all surfaces
nrm_out
vis_ill
* Find visibility and level of illumination of surface by taking the scalar
* product of the surface normal vector with the line of sight vector from viewpoint
* and illumination respectively.
 move.w npoly,d7
 subq.w #1,d7
 lea    vcoordsx,a0
 lea    vcoordsy,a1
 lea    vcoordsz,a2
 lea    sedglst,a4
 lea    snedges,a3
 lea    snormlst,a5
 lea    slumlst,a6
 move.w ill_vecx,d0
 move.w ill_vecy,d1
 move.w ill_vecz,d2
* line of sight vector is taken between the first vertex on the surface and viewpoint
next_ill
 move.w (a4),d6        1st point on next surface
 add    d6,d6 for      offset
 move.w 0(a0,d6.w),d3  is line of sight x cmpnt, x1s 
 move.w 0(a1,d6.w),d4  yLs 
 move.w 0(a2,d6.w),d5  z
 sub.w  vwpointz,d5     zls: vpoint lies on -zv axis
 muls   (a5),d3        nx*sx
 muls   2(a5),d4       ny*sy
 muls   4(a5),d5       nz*sz
 add.l  d4,d3
 add.l  d5,d3          scalar product
 bmi    visible        negative if surface visible
* it is hidden
 move.w #$20,(a6)+     set illumination for hidden
ill_tidy
 addq.w #6,a5          update normals pointer
 move.w (a3)+,d5       current num edges
 addq   #1,d5          first vertex is repeated
 add    d5,d5          2 bytes per word
 adda.w d5,a4          update edge list pointer
 dbra   d7,next_ill
 bra    set_colr
* The surface is visible so find illumination level.
visible
 move.w d0,d3          copy illum vector
 move.w d1,d4
 move.w d2,d5
 muls   (a5),d3        nx*illx
 muls   2(a5),d4       ny*illy
 muls   4(a5),d5       nz*illz
 add.l  d4,d3
 add.l  d5,d3          -2^28<scalar prod <+2^28
 add.l  #$11100000,d3  0 < scalar prod < 2^29
 move.w #24,d4
 lsr.l  d4,d3
 cmp.w  #$1f,d3        keep in range 0 to $1f
 ble    vis_1          correct
 move.w #$1f,d3        for
 bra    ill_save       errors
vis_1
 cmp.w  #0,d3
 bge    ill_save
 clr    d3
ill_save
 move.w d3,(a6)+      save it
 bra    ill_tidy      next ...
*
*
set_colr
 move.w npoly,d7
 subq.w #1,d7
 move.w illkey,d0     how many shades per colour
 lea slumlst,a0       levels of illumination
 lea srf_col,a1
 lea col_lst,a2       colour for display
 move.w #5,d6
 sub.w d0,d6          5-illkey
next_col
 move.w (a0)+,d1      next illumination
 cmp.w #$1f,d1        is it hidden
 ble set_col no
 move.w #$20,(a2)+    it is, set flag
 addq.l #2,a1         point to next intrinsic colour
 bra set_next
set_col
 lsr.w  d0,d1          divide by 0, 2 or 4
 move.w (a1)+,d2       the intrinsic colour
 rol.b  d6,d2          0 or 0, 16 or 0,8,16,24 = base
 add.w  d1,d2          illumination + colour base
 bgt    pass_col
 move.w #1,d2         avoid background
pass_col
 move.w d2,(a2)+      = final colour
set_next
 dbra d7,next_col
 rts 
 
*****************************************************************************************
transfer
 move.w my_npoly,d7
 move.w d7,npoly
 subq.w #1,d7           counter
 move.w d7,d0
 lea my_nedges,a0
 lea snedges,a1
 lea intr_col,a2        intrinsic colours
 lea srf_col,a3         program    intrinsic colours
loop0
 move.w (a0)+,(a1)+     transfer edge numbers
 move.w (a2)+,(a3)+     transfer intrinsic colours
 dbra d0,loop0
* calculate the number of vertices altogether
 move.w d7,d0
 lea my_nedges,a6
 clr d1
 clr d2
loop1
 add.w (a6),d1
 add.w (a6)+,d2
 addq #1,d2
 dbra d0,loop1
* move the edge list
 subq #1,d2 counter
 lea my_edglst,a0
 lea sedglst,a1
loop2
 move.w (a0)+,(a1)+
 dbra d2,loop2
* and the coords list
 move.w d1,oncoords
 subq.w #1,d1
 lea ocoordsx,a1
 lea my_datax,a0
 lea ocoordsy,a3
 lea my_datay,a2
 lea ocoordsz,a5
 lea my_dataz,a4
loop3
 move.w (a0)+,(a1)+
 move.w (a2)+,(a3)+
 move.w (a4)+,(a5)+
 dbra d1,loop3
* and the window limits
 move.w my_xmin,clp_xmin
 move.w my_xmax,clp_xmax
 move.w my_ymin,clp_ymin
 move.w my_ymax,clp_ymax
 rts
*****************************************************************************************
* normalise a vector: unormalised components in d0,d1,d2
* return normalised components
nrm_vec
* save the component squares
 move d0,d3
 move d1,d4
 move d2,d5
 muls d0,d0
 muls d1,d1
 muls d2,d2
* sum of squares
 add.l d1,d0
 add.l d2,d0
* calculate the magnitude
 bsr sqrt
* multiply the components by 2^14
 move.w #14,d7
 ext.l d3
 ext.l d4
 ext.l d5
 lsl.l d7,d3
 lsl.l d7,d4
 lsl.l d7,d5
* divide by magnitude to derive normalised components
 divs d0,d3
 divs d0,d4
 divs d0,d5
* return normalised components
 move.w d3,d0
 move.w d4,d1
 move.w d5,d2
 rts
*****************************************************************************************
* Find the sqrt of a long word N in d0 in three iterations: sqrt=1/2(squrt+N/squrt) 
* approximate starting value found from highest bit in d0: Result passed in d0.W
sqrt
 tst.l d0
 beq sqrt2        quit if zero
 move.w #31,d7    31 bits to examine
sqrt1
 btst d7,d0       is this bit set?
 dbne d7,sqrt1
 lsr.w #1,d7      bit is set: 2^d7/2 approx root
 bset d7,d7       raise 2 to this power
 move.l d0,d1 
 divs d7,d1       N/squrt
 add d1,d7        squrt+N/squrt
 lsr.w #1,d7      /2 gives new trial value
 move.l d0,d1     N
 divs d7,d1
 add d1,d7
 lsr.w #1,d7      second result
 move.l d0,d1
 divs d7,d1
 add d1,d7
 lsr.w #1,d7      final result
 move.w d7,d0
sqrt2
 rts
*****************************************************************************************
 
 
 

