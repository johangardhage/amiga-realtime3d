*****************************************************************************************
*	Core_00.s
*
*****************************************************************************************
* This fills a polygon.
* It consists of 4 parts:
* 1. the x coords of the boundary are stored in xbuf
* 2. the outline is drawn in the mask plane
* 3. the the outline is filled by the blitter
* 4. the blitter copies the mask to the bitplanes
******************************************************************************************
* Part 1. Fill the buffer with the outline.
* a3 pointer to crds_in coords list (x1,y1...xn,yn,x1,y1)
* a2 pointer to xbuf
* d0-x1: d1-y1: d2-x2: d3-y2: d4-vertex number/decision vertex
* d5-lowest y: d6-highest y/the increment: d7-edge counter
* Polygon vertices are ordered anticlockwise
******************************************************************************************
poly_fill
	bsr	blit_mask				; clear mask plane
*INITIALISE ALL VARIABLES
filxbuf
	move.w	no_in,d7
	beq	fil_end					; quit if no more edges
	move.l	coords_lst,a3
	subq.w	#1,d7					; counter of num edges
	move.w	#MINIMUM_Y,d5
	clr.w	d6					; maximum y to zero
filbuf1
	lea	xbuf,a2
	addq.w	#2,a2					; point to ascending side
	move.w	(a3)+,d0				; next x1
	move.w	(a3)+,d1				; next y1
	move.w	(a3)+,d2				; next x2
	move.w	(a3)+,d3				; next y2
	subq.w	#4,a3					; point back to x2
*FIND THE HIGHEST AND LOWEST Y VALUES: THE FILLED RANGE OF XBUF
	cmp.w	d5,d1					; test(y1-miny)
	bge	filbuf3					; miny unchanged
	move.w	d1,d5					; miny is y1
filbuf3
	cmp.w	d1,d6					; test(maxy-y1)
	bge	filbuf5					; unchanged
	move.w	d1,d6					; maxy is y1
filbuf5
	exg	d5,a5					; save miny
	exg	d6,a6					; save maxy
	clr.w	d4					; init. decision var
	moveq	#1,d6					; init. increment

* All lines fall into 2 categories: [slope<1], [slope>1].
* The difference is whether x and y are increasing or decreasing.
* See if line is ascending [slope>0] or descending [slope<0].

	cmp.w	d1,d3					; (y2-y1)=dy
	beq	y_limits				; ignore horizontal altogether
	bgt	ascend					; slope > 0
* It must be descending. Direct output to LHS of buffer. a2 must
* be reduced and we have to reverse the order of the vertices.

	exg	d0,d2					; x1 and x2
	exg	d1,d3					; y1 and y2
	subq.w	#2,a2					; point to left hand buffer
ascend
	sub.w	d1,d3					; now dy is positive

* Set up y1 as index to buffer
	lsl.w	#2,d1
	add.w	d1,a2

* Check the sign of the slope
	sub.w	d0,d2					; (x2-x1)=dx
	beq	vertical				; special case to deal with
	bgt	pos_slope

* It must have a negative slope but we deal with this by making the
* increment negative.
	neg.w	d6					; increment is negative
	neg.w	d2					; dx is positive
* Now decide if the slope is High (>1) or Low (<1).
pos_slope
	cmp.w	d2,d3					; test (dy-dx)
	bgt	hislope					; slope is > 1

* Slope is < 1 so we want to increment x every time and then
* check whether to increment y. If so this value of x must be saved
* dx is the counter. Initial error D1=2dy-dx.
* If last D -ve, then x=x=inc, dont record x, D=D+err1
* If last D +ve, then x=x+inc, y=y+inc, record this x, D=D=err2
* err1=2dy; err2=2dy-2dx
* d0=x: d2=dx: d3=dy: d6=incx.

	move.w	d2,d5
	subq.w	#1,d5					; dx-1 is the counter
	add.w	d3,d3					; 2dy=err1
	move.w	d3,d4					; 2dy
	neg.w	d2					; -dx
	add.w	d2,d4					; 2dy-dx= D1
	add.w	d4,d2					; 2dy-2dx=err2
	move.w	d0,(a2)					; save first x
inc_x
	add.w	d6,d0					; x=x+incx
	tst.w	d4					; what is the decision?
	bmi	no_stk					; dont inc y dont record x
	add.w	#4,a2					; inc y, record x. next buffer place
	move.w	d0,(a2)					; save this x
	add.w	d2,d4					; update decision D=D=err2
	bra.s	next_x
no_stk
	add.w	d3,d4					; D=D+err1
next_x
	dbra	d5,inc_x				; increment x again
	bra	y_limits

* The slope is > 1 so change the roles of dx and dy.
* This time increment y each time and record the value of x after having done so.
* Init error D1 = 2dx-dy
* If last D -ve, then y=y+inc, D=D+err1, record x
* If last D +ve, then x=x+inc, y=y+inc, D=D+err2, record x
* err1=2dx, err2=2(dx-dy)
* d2=dx: d3=dy: d6=inc: d0=x
hislope
	move.w	d3,d5
	subq.w	#1,d5					; dy-1 is counter
	add.w	d2,d2					; 2dx=err1
	move.w	d2,d4					; 2dx
	neg.w	d3					; -dy
	add.w	d3,d4					; D1=2dx-dy
	add.w	d4,d3					; 2dx-2dy=err2
	move.w	d0,(a2)					; save 1st x
inc_y
	addq.w	#4,a2					; next place in buffer
	tst.w	d4					; what is the decision
	bmi	same_x					; dont inc x
	add.w	d6,d0					; inc x
	add.w	d3,d4					; D=D+err2
	bra.s	next_y
same_x
	add.w	d2,d4					; D=D+err1
next_y
	move.w	d0,(a2)					; save x value
	dbra	d5,inc_y
	bra	y_limits
* The vertical line x is constant. dy is the counter
vertical
	move.w	d0,(a2)					; save next x
	addq.w	#4,a2					; next place in buffer
	dbra	d3,vertical				; for all y
* Restore the y limits
y_limits
	exg	d5,a5
	exg	d6,a6
next_line
	dbra	d7,filbuf1				; do rest of lines (if any left)
* This part ends with min y in d5 and max y d6
	move.w	d6,ymax
	move.w	d5,ymin
*****************************************************************************************
* PART 2. Copy the xbuf to the mask plane.
* Set up the pointer
	lea	xbuf,a0					; base address of buffer
	move.l	maskplane,a1				; base address of maak plane
	lea	msk_y_tbl,a2				; mask plane y look up table
	sub.w	d5,d6					; num pairs to set -1
	move.w	d6,d7					; is the counter
	beq	fil_end					; quit if all sides horizontal
	move.w	d5,d2					; miny is the start
	lsl.w	#2,d5					; 4*min y = offset into xbuf
	add.w	d5,a0					; for the address to start
	subq.w	#1,d2					; reduce initial y
poly2
	addq	#1,d2					; next y
	move.w	(a0)+,d0				; next x1
	move.w	(a0)+,d1				; next x2
	cmp.w	d0,d1					; test(x1-x2)
	beq	poly4					; cant draw a line with one point
	move.w	d2,d5					; pass y
	bsr	set_pix					; set the 2 pixels
poly4
	dbra	d7,poly2				; repeat for all y values
*****************************************************************************************
* PART 3. Fill in the outline
* Confine the blit to the rectangle (xmax-xmin)*(ymax-ymin).
* First xmax and xmin are recorded to define the rectangle.
	bsr	blt_chk
frme
	move.w	no_in,d7
	subq.w	#1,d7
	movea.l	coords_lst,a3				; here they are
	move.w	#MINIMUM_X,xmin				; initialise xmin
	clr.w	xmax					; and xmax
x_test
	move.w	(a3),d0					; next x
	cmp.w	xmin,d0					; test(x1-xmin)
	bgt	lnblit4					; xmin unchanged
	move.w	d0,xmin					; this is x min
lnblit4
	cmp.w	xmax,d0					; test(x1-xmax)
	blt	lnblit5					; xmax unchanged
	move.w	d0,xmax					; this x is xmax
lnblit5
	addq.l	#4,a3					; increment x pointer
	dbra	d7,x_test				; for all x

* Here's the fill blit. Several things must be found.
* Calculate the address of the bottom rh corner of the rectangle
* bltstrt contains its offset in the plane
	move.w	xmax,d0
	lsr.w	#SIXTEEN,d0				; xmax/16
	move.w	d0,d2					; save it
	add.w	d2,d2					; *2 = byte position in row
	move.w	ymax,d1
	mulu	#WIDTH,d1				; row address
	add.w	d2,d1
	ext.l	d1
	move.l	d1,bltstrt				; save offset in the plane

* address to start blit
	movea.l	maskplane,a0				; plane base address
	add.l	d1,a0					; plus offset is where blit starts
	move.l	#$dff000,a5
	move.l	a0,bltapt(a5)				; SOURCE
	move.l	a0,bltdpt(a5)				; DESTINATION

* bltmod says how much of plane to blit
	move.w	xmin,d1
	lsr.w	#SIXTEEN,d1				; xmin/16
	sub.w	d1,d0					; xmax/16 - xmin/16
	addq.w	#1,d0					; word width of window
	move.w	d0,bltwidth				; save it
	move.w	#WIDTH,d2
	add.w	d0,d0					; width in bytes
	sub.w	d0,d2					; blitmod
	move.w	d2,blitmod
	move.w	d2,bltamod(a5)				; SOURCE MODULO
	move.w	d2,bltdmod(a5)				; DESTINATON MODULO

* set the control registers for a simple descending fill.
	move.w	#$09f0,bltcon0(a5)			; USE A&D D=A (no shift)
	move.w	#$000a,bltcon1(a5)			; INCLUSIVE FILL, DESCENDING
	move.w	#$ffff,bltafwm(a5)
	move.w	#$ffff,bltalwm(a5)

* set the size and do the blit
	move.w	ymax,d0
	sub.w	ymin,d0
	addq.w	#1,d0
	lsl.w	#6,d0					; set height
	add.w	bltwidth,d0				; and width
	move.w	d0,blitsize				; sizeof blit
	move.w	d0,bltsize(a5)				; do the fill

* PART 4.
* Copy the mask to the screen bitplanes which must be set or cleared
* depending on it's colour bit.
* Only the smallest rectangle is blitted.
* The mask is used in the cookie cut function:
* If the colour bit is set, the masked region is set
* If the colour bit is clear, the masked region is cleared.
pln_cpy
	bsr	blt_chk
	move.w	#DEPTH-1,d7				; number of planes to blit
	move.w	colour,d6
	move.w	#0002,bltcon1(a5)			; COPY DESCENDING
	move.w	blitmod,d0
	move.w	d0,bltamod(a5)
	move.w	d0,bltdmod(a5)
	move.w	d0,bltbmod(a5)
	IFD	DOUBLE_BUFFERING
	move.l	workplanes,a2				; get address of planepointers list
	ELSE
	move.l	showplanes,a2				; get address of planepointers list
	ENDC
;	sub.l	#WIDTH*HEIGHT,a0			; (ready to increment in next part)
;	add.l	bltstrt,a0				; offset to draw at

nxtplane						; LOOP POINT
	bsr	blt_chk
;	add.l	#WIDTH*HEIGHT,a0			; get next bitplane base address
	move.l	(a2)+,a0				; get next address into a0
	add.l	bltstrt,a0				; and add offset to start drawing at...

* store the destination plane first, (copy to storeplane)
	move.l	a0,bltapt(a5)				; SOURCE
	move.l	storeplane,a1				; destination
	add.l	bltstrt,a1				; start position of rectangle
	move.l	a1,bltdpt(a5)				; in plane 6
	move.w	#$09f0,bltcon0(a5)			; straight copy
	move.w	blitsize,bltsize(a5)			; store destination plane
	bsr	blt_chk

* now mask region and set/clear as colour bit dictates
	movea.l	maskplane,a1				; the mask
	add.l	bltstrt,a1				; start here
	move.l	a1,bltapt(a5)				; A IS MASK
	move.l	storeplane,a1
	add.l	bltstrt,a1				; offset
	move.l	a1,bltbpt(a5)				; B IS STOREPLANE
	move.l	a0,bltdpt(a5)				; DESTINATION

* do we set or clear the masked region?
	lsr.w	#1,d6					; get colour bit into carry flag
	bcc	bltclr					; bit is zero so clear masked region

* we have to set the masked region
	move.w	#$0dfc,bltcon0(a5)			; NO SHIFT: USE A,B,D: D=A OR B
	bra	bltcopy

bltclr
* clear region
	move.w	#$0d0c,bltcon0(a5)			; NO SHIFT: USE A,B,D: D=NOT A AND B

bltcopy
	move.w	blitsize,bltsize(a5)			; perform the required blit function
	dbf	d7,nxtplane				; do all the planes
* done
fil_end
	rts
*****************************************************************************************
* Get pixel address and mask to set pixels in the mask plane which
* mark start and end of a scan line .
* d0=x1: d1=x2: d2=y1: a0=xbuf: a1=maskplane base: a2=msk y line tbl
set_pix
	lsl.w	#2,d5					; 4*y is offset in table
	movea.l	0(a2,d5.w),a3				; row address in mask plane
	move.l	a3,a4					; save it

* set pixel x1
	move.w	d0,d3					; save x1
	lsr.w	#EIGHT,d0				; byte num in row (/8)
	adda.w	d0,a3					; the byte containing the pixel
	andi.w	#$0007,d3				; pixel num in word
	subi	#7,d3
	neg.w	d3					; bit to set
	clr.w	d0
	bset	d3,d0					; this is a mask
	or.b	d0,(a3)					; set the pixel

* set pixel x2
	move.l	a4,a3					; restore row address
	move.w	d1,d3					; save x2
	lsr.w	#EIGHT,d1				; byte num in row (/8)
	adda.w	d1,a3					; the byte containing the pixel
	andi.w	#$0007,d3				; pixel num in word
	subi	#7,d3
	neg.w	d3					; bit to set
	clr.w	d0
	bset	d3,d0					; this is a mask
	or.b	d0,(a3)					; set the pixel
	rts
*****************************************************************************************
* Get the screen address of a word
* at a0=base: d0=x: d1=y:
scrn_wrd
	move.w	#WIDTH,d2				; plane width
	mulu	d1,d2					; y*width
	add.l	a0,d2					; + base
	lsr.w	#SIXTEEN,d0				; x/16
	add.w	d0,d0					; word pos in row
	ext.l	d0
	add.l	d0,d2					; address
	rts
*****************************************************************************************
* See if last blit is finished
blt_chk
	move.l	#$dff000,a5
	move.l	d7,-(sp)
blt_chk1
	move.w	dmaconr(a5),d7
	btst.l	#14,d7
	btst.l	#14,d7
	bne	blt_chk1
	move.l	(sp)+,d7
	rts
