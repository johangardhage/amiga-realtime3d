  *****************************************************************************************
*                    Core_03.s (subroutines for chapter six).                           *
*****************************************************************************************
*               sincos - returns the sine and cosine of given angle
*               otranw - transforms obj coords to world coords.
*****************************************************************************************
 include core_02.s
 
* The sine and cosine of an angle are found. The sintable covers the positive quadrant  *
* 0-90 degrees and can be used to generate any sin or cos in the range 0 - 360 degrees  *
* d1=angle in degrees. Returns sin in d2; cos in d3.
sincos
 lea sintable,a5
 cmp #360,d1            test(angle-360)
 bmi less360
 sub #360,d1            make it less than 360
less360
 cmp #270,d1            test(angle-270)
 bmi less270
 bsr over270
 rts
less270
 cmp #180,d1            test(angle-180)
 bmi less180
 bsr over180
 rts
less180
 cmp #90,d1
 bmi less90
 bsr over90
 rts
less90
 add d1,d1              *2 for offset into table
 move.w 0(a5,d1.w),d2   get sine
 subi #180,d1           cos(angle)=sin(90-angle)
 neg  d1                offset into table for cosine
 move.w 0(a5,d1.w),d3   cosine
 rts
over270
 subi #360,d1
 neg  d1                360-angle
 add  d1,d1             table offset
 move.w 0(a5,d1.w),d2   get sine
 neg  d2
 subi #180,d1           cos(angle)=sin(90-angle)
 neg  d1                offset into table for cosine
 move.w 0(a5,d1.w),d3   cosine
 rts
over180
 subi #180,d1
 add  d1,d1             table offset
 move.w 0(a5,d1.w),d2   get sine
 neg  d2
 subi #180,d1           cos(angle)=sin(90-angle)
 neg  d1                offset into table for cosine
 move.w 0(a5,d1.w),d3   cosine
 neg  d3
 rts
over90
 subi #180,d1
 neg  d1                 360-angle
 add  d1,d1              table offset
 move.w 0(a5,d1.w),d2   get sine
 subi #180,d1           cos(angle)=sin(90-angle)
 neg  d1                offset into table for cosine
 move.w 0(a5,d1.w),d3   cosine
 neg  d3
 rts
******************************************************************************************
* The subroutines for transforming object coords to to world coords.                     *
* Includes rotations given by otheta, ophi and ogamma about the world axes wx,wy,wz and  *
* a displacement Oox, Ooy, Ooz relative to the world origin.                             *
* Part 1. Construct the matrix for the rotations.                                        *
******************************************************************************************
* Convert object rotation angles and store for rotation matrix.
otranw
 move.w otheta,d1 
 bsr    sincos
 move.w d2,stheta
 move.w d3,ctheta
 move.w ophi,d1
 bsr    sincos
 move.w d2,sphi
 move.w d3,cphi
 move.w ogamma,d1
 bsr    sincos
 move.w d2,sgamma
 move.w d3,cgamma
* construct transform matrix otranw. (all elements end up doubled)
 lea stheta,a0
 lea ctheta,a1
 lea sphi,a2
 lea cphi,a3
 lea sgamma,a4
 lea cgamma,a5
 lea o_wmatx,a6         matrix
* do element OM11
 move.w (a3),d0         cphi
 muls   (a5),d0         cphi*cgamma
 lsl.l  #2,d0
 swap   d0              /2^14
 move.w d0,(a6)+        OM11
* do OM12
 move.w (a3),d0         cphi
 muls   (a4),d0         cphi*sgamma
 neg.l  d0
 lsl.l  #2,d0
 swap   d0              /2^14
 move.w d0,(a6)+        OM12
* do OM13
 move.w (a2),(a6)+      sphi
* do OM21
 move.w (a1),d0         ctheta
 muls   (a4),d0         ctheta*sgamma
 move.w (a0),d1         stheta
 muls   (a2),d1         stheta*sphi
 lsl.l  #2,d1
 swap   d1
 muls   (a5),d1         stheta*sphi*cgamma
 add.l  d1,d0           stheta*sphi*cgamma + ctheta*sgamma
 lsl.l  #2,d0
 swap   d0
 move.w d0,(a6)+
* do OM22
 move.w (a1),d0         ctheta
 muls   (a5),d0         ctheta*cgamma
 move.w (a0),d1         stheta
 muls   (a2),d1         stheta*sphi
 lsl.l  #2,d1
 swap   d1
 muls   (a4),d1         stheta*sphi*sgamma
 sub.l  d1,d0           ctheta*cgamma - stheta*sphi*sgamma
 lsl.l  #2,d0
 swap   d0
 move.w d0,(a6)+
* do OM23
 move.w (a0),d0         stheta
 muls   (a3),d0         stheta * cphi
 neg.l  d0
 lsl.l  #2,d0
 swap   d0
 move.w d0,(a6)+
* do OM31
 move.w (a0),d0         stheta
 muls   (a4),d0         stheta*sgamma
 move.w (a1),d1         ctheta
 muls   (a2),d1         ctheta*sphi
 lsl.l  #2,d1
 swap   d1
 muls   (a5),d1         ctheta*sphi*cgamma
 sub.l  d1,d0           stheta*sgamma-ctheta*sphi*cgamma
 lsl.l  #2,d0
 swap   d0
 move.w d0,(a6)+
* do OM32
 move.w (a0),d0        stheta
 muls   (a5),d0        stheta*cgamma
 move.w (a1),d1        ctheta
 muls   (a2),d1        ctheta*sphi
 lsl.l  #2,d1
 swap   d1
 muls   (a4),d1        ctheta*sphi*sgamma
 add.l  d1,d0
 lsl.l  #2,d0
 swap   d0
 move.w d0,(a6)+
* do OM33
 move.w (a1),d0        ctheta
 muls   (a3),d0        ctheta*cphi
 lsl.l  #2,d0
 swap   d0
 move.w d0,(a6)+
*****************************************************************************************
* PART 2: transform object coords to world coords. matrix elements are 2^14 and must be *
* adjusted when we're finished.
 move.w oncoords,d7  number
 ext.l  d7           any to do ?
 beq    otranw3
 subq.w #1,d7        adjust counter for dbra
 lea    ocoordsx,a0
 lea    ocoordsy,a1
 lea    ocoordsz,a2
 lea    wcoordsx,a3
 lea    wcoordsy,a4
 lea    wcoordsz,a5
 exg    a3,d3        save address(  not enough a regs!!)
 link a6,#-6         stack frame of 3 words

otranw1
 moveq.l #2,d6       3 rows in the matrix
 lea     o_wmatx,a3  point at matrix
* calculate the next wx,wy and wz
otranw2
 move.w (a0),d0      ox
 move.w (a1),d1      oy
 move.w (a2),d2      oz
 muls   (a3)+,d0     ox*MI1
 muls   (a3)+,d1     oy*MI2
 muls   (a3)+,d2     oz*MI3
 add.l  d1,d0
 add.l  d2,d0
 lsl.l  #2,d0
 swap   d0
 move.w d0,-(a6)     save it
 dbra   d6,otranw2   repeat for three elements
 
 move.w (a6)+,d0
 add.w  Ooz,d0       add displacement
 move.w d0,(a5)+     becomes wz
 move.w (a6)+,d0
 add.w  Ooy,d0
 move.w d0,(a4)+     becomes wy
 exg    a3,d3        restore wx, save matrix pointer
 move.w (a6)+,d0
 add.w  Oox,d0
 move.w d0,(a3)+     becomes wx
 exg    a3,d3        save wx restore matrix pointer
 addq.l #2,a0        point to next ox
 addq.l #2,a1        oy
 addq.l #2,a2        oz
 dbra   d7,otranw1   repeat for all coords 
 unlk   a6
otranw3 
 rts
 
 
 
 
 