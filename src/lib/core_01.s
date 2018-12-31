*****************************************************************************************
*	Core_01.s
*
* A version of the Sutherland-Hodgman clipping algorithm.
* It goea around the the polygon clipping it against one boundary at a time. It goes
* around four times in all.
* a0=crds_in: a1=crds_out: a2=no_out: a3=saved(crds_out):
* d0=current limit: d1=x1: d2=y1: d3=x2: d4=y2: d5=(saved)x2: d6=(saved)y2:
*****************************************************************************************
	include	core_00.s

* First clip against xmin.
clip
	bsr	clip_ld1				; set up pointers
	tst.w	d7					; any sides to clip?
	beq	clip_end				; not this time...

* do first point as a special case.
	move.w	(a0)+,d5				; 1st x
	move.w	(a0)+,d6				; 1st y
	move.w	clp_xmin,d0				; limit
	cmp.w	d0,d5					; test(x1-xmin)
	bge	xmin_save				; inside limit
	bra	xmin_update				; outside limit

* do succesive vertices in turn
xmin_next
	move.w	(a0)+,d3				; x2
	move.w	(a0)+,d4				; y2
	move.w	d3,d5					; save x2
	move.w	d4,d6					; save y2

* now test for position
	sub.w	d0,d3					; x2-xmin
	bge	xmin_x2in				; x2 is in

* x2 is inside, find x1
	sub.w	d0,d1					; x1-xmin
	blt	xmin_update				; both x2 and x1 are outside

* x2 is out but x1 is in so find intersection, needs d1=dx1(+ve):d3=dx2(-ve)
* d2=y1: d4=y2:
* find the y intercept and save it.
	bsr	y_intercept

* but because it's out, don't save x2.
	bra	xmin_update
xmin_x2in

* x2 is in but where is x1? GOD KNOWS!!
	sub.w	d0,d1					; x1-xmin
	bge	xmin_save				; both x1 and x2 are in

* x2 is in but x1 is out so find intercept, but need -ve one in d3, so swap
	exg	d1,d3
	exg	d2,d4
	bsr	y_intercept
xmin_save
	move.w	d5,(a1)+				; save x
	move.w	d6,(a1)+				; save y
	addq.w	#1,(a2)					; inc count
xmin_update
	move.w	d5,d1					; x1=x2
	move.w	d6,d2					; y1=y2
	dbra	d7,xmin_next

* The last point must be the same as the first
	movea.l	a3,a4					; pointer to first x
	subq	#4,a1					; point to last x
	cmpm.l	(a4)+,(a1)+				; check first and last x and y
	beq	xmin_dec				; already the same
	move.l	(a3),(a1)				; move first to last
	bra	clip_xmax
xmin_dec
	tst.w	(a2)					; if count
	beq	clip_xmax				; is not already zero
	subq.w	#1,(a2)					; reduce it

* Now clip against xmax. Essentially the same as above except that the order
* of subtraction is reversed so that the same subroutine can be used to find
* the intercept.
clip_xmax
	bsr	clip_ld2				; set up pointers
	tst.w	d7					; any to do?
	beq	clip_ymin				; no...

* do first point as a special case.
	move.w	(a0)+,d5				; 1st x
	move.w	(a0)+,d6				; 1st y
	move.w	clp_xmax,d0
	cmp.w	d5,d0					; test (xmax-x1)
	bge	xmax_save				; inside limit
	bra	xmax_update				; outside limit

* do succesive vertices in turn
xmax_next
	move.w	(a0)+,d3				; x2
	move.w	(a0)+,d4				; y2
	move.l	d3,d5					; save x2
	move	d4,d6					; save y2

* now test for position
	sub.w	d0,d3
	neg.w	d3					; xmax-x2
	bge	xmax_x2in				; x2 is in

* x2 is outside. where is x1?
	sub.w	d0,d1
	neg.w	d1					; xmax-x1
	blt	xmax_update				; both x2 and x1 are out

* x2 is out but x1 is in so find intersection
* needs dx1(+ve) in d1, and dx2(-ve) in d3, y1 in d2 and y2 in d4
* find the intercept and save it.

	bsr	y_intercept
* but because its out dont save x2
	bra	xmax_update

* x2 is in but where is x1
xmax_x2in
	sub.w	d0,d1
	neg.w	d1					; xmax-x1
	bge	xmax_save				; both x1 and x2 are in

* x2 is in but x1 is out so find intercept
* but must have the -ve one in d3,so switch
	exg	d1,d3
	exg	d2,d4
	bsr	y_intercept

xmax_save
	move.w	d5,(a1)+				; save x
	move.w	d6,(a1)+				; save y
	addq.w	#1,(a2)					; inc count
xmax_update
	move	d5,d1					; x1=x2
	move	d6,d2					; y1=y2
	dbra	d7,xmax_next

* the last point must be the same as the first

	movea.l	a3,a4					; pointer to first x
	subq	#4,a1					; point to last x
	cmpm.l	(a4)+,(a1)+				; check 1st and last x and y
	beq	xmax_dec				; already the same
	move.l	(a3),(a1)				; move first to last
	bra	clip_ymin
xmax_dec
	tst.w	(a2)					; if count
	beq	clip_ymin				; is not already zero
	subq.w	#1,(a2)					; reduce it

clip_ymin
	bsr	clip_ld1				; set up pointers
	tst.w	d7					; any to do?
	beq	clip_ymax				; no...
* do first point as a special case
	move.w	(a0)+,d5				; ist x
	move.w	(a0)+,d6				; 1st y
	move.w	clp_ymin,d0				; this limit
	cmp.w	d0,d6					; test (y1-ymin)
	bge	ymin_save				; inside limit
	bra	ymin_update				; outside limit
* do successive vertices in turn
ymin_next
	move.w	(a0)+,d3				; x2
	move.w	(a0)+,d4				; y2
	move	d3,d5					; save x2
	move	d4,d6					; save x1
* now test for position
	sub.w	d0,d4					; y2-xmin
	bge	ymin_y2in				; y2 is in
* y2 is outside where is y1?
	sub.w	d0,d2					; y1-xmin
	blt	ymin_update				; both y2 and y1 are out

* y2 is out but y1 is in so find intersection
* needs x1 in d1, x2 in d3, dy1 in d2 and dy2 in d4
* find the intercept and save it
	bsr	x_intercept

* but because its out, dont save y2
	bra	ymin_update
ymin_y2in

* y2 is in but where is y1
	sub.w	d0,d2					; y1-ymin
	bge	ymin_save				; both y1 and y2 are in

* y2 is in but y1 is out so find intercept
* but must have the -ve one in d4 so switch
	exg	d1,d3
	exg	d2,d4
	bsr	x_intercept
ymin_save
	move.w	d5,(a1)+				; save x
	move.w	d6,(a1)+				; save y
	addq.w	#1,(a2)					; increment no
ymin_update
	move	d5,d1					; x1=x2
	move	d6,d2					; y1=y2
	dbra	d7,ymin_next

* the last point must be the same as the first
	movea.l	a3,a4					; pointer to first x
	subq.w	#4,a1					; point to last x
	cmpm.l	(a4)+,(a1)+				; check first and last x and y
	beq	ymin_dec				; already the same
	move.l	(a3),(a1)				; move first to last
	bra	clip_ymax
ymin_dec
	tst.w	(a2)					; if count
	beq	clip_ymax				; is not already zero
	subq.w	#1,(a2)					; reduce it
clip_ymax
	bsr	clip_ld2
	tst.w	d7					; any to do?
	beq	clip_end				; no...
* do first point as a special case
	move.w	(a0)+,d5				; 1st x
	move.w	(a0)+,d6				; 1st y
	move.w	clp_ymax,d0
	cmp.w	d6,d0					; test(ymax-y1)
	bge	ymax_save
	bra	ymax_update
* do vertices in turn
ymax_next
	move.w	(a0)+,d3				; x2
	move.w	(a0)+,d4				; y2
	move	d3,d5					; save x2
	move	d4,d6					; save y2
* test for position
	sub.w	d0,d4
	neg.w	d4					; ymax-y2
	bge	ymax_y2in
* y2 is outside where is y1?
	sub.w	d0,d2
	neg.w	d2					; ymax-y1
	blt	ymax_update				; both x2 and x1 are out
* y2 is out but y1 is in so find intersection
	bsr	x_intercept
	bra	ymax_update
ymax_y2in
*y2 is in but where is y1?
	sub.w	d0,d2
	neg.w	d2					; ymax-y1
	bge	ymax_save				; both y1 and y2 are in
* y2 is in but y1 is out so find intercept
	exg	d1,d3
	exg	d2,d4
	bsr	x_intercept
ymax_save
	move.w	d5,(a1)+				; save x
	move.w	d6,(a1)+				; save y
	addq.w	#1,(a2)					; increment num
ymax_update
	move.w	d5,d1					; x1=x2
	move.w	d6,d2					; y1=y2
	dbra	d7,ymax_next

* the last point must be the same as the first
	movea.l	a3,a4					; pointer to first x
	subq.w	#4,a1					; point to last x
	cmpm.l	(a4)+,(a1)+				; check first and last x and y
	beq	ymax_dec				; already the same
	move.l	(a3),(a1)				; move first to last
	bra	clip_end
ymax_dec
	tst.w	(a2)					; if count
	beq	clip_end				; is not already zero
	subq.w	#1,(a2)					; reduce it
clip_end
	lea	crds_in,a0
	move.l	a0,coords_lst
	rts

clip_ld1
	lea	crds_in,a0				; pointer to vertex coords before
	lea	crds_out,a1				; and after this clip
	move.l	a1,a3					; saved
	move.w	no_in,d7				; this many sides before
	lea	no_out,a2				; where the number after is stored
	clr.w	no_out
	rts

clip_ld2
	lea	crds_out,a0				; pointer to vertex coords before
	lea	crds_in,a1				; and after this clip
	move.l	a1,a3					; saved
	move.w	no_out,d7				; this many sides before
	lea	no_in,a2				; where the number after is stored
	clr.w	no_in
	rts

y_intercept
	tst.w	d1
	beq	yint_out
	tst.w	d3
	beq	yint_out
	movem	d5/d6,-(sp)
yint_in
	move.w	d2,d6
	add.w	d4,d6
	asr.w	#1,d6
	move.w	d1,d5
	add.w	d3,d5
	asr.w	#1,d5
	beq	yint_end
	bgt	yint_loop
	move	d5,d3
	move	d6,d4
	bra	yint_in
yint_loop
	move	d5,d1
	move	d6,d2
	bra	yint_in
yint_end
	move.w	d0,(a1)+
	move.w	d6,(a1)+
	addq.w	#1,(a2)
	movem	(sp)+,d5/d6
yint_out
	rts

x_intercept
	tst.w	d2
	beq	xint_out
	tst.w	d4
	beq	xint_out
	movem	d5/d6,-(sp)
xint_in
	move	d1,d5					; x1
	add.w	d3,d5					; x1+x2
	asr.w	#1,d5					; ()/2=,x> a possible intercept
	move	d2,d6					; dy1
	add.w	d4,d6					; dy1+dy2
	asr.w	#1,d6					; (dy1+dy2)/2 =<dy>
	beq	xint_end				; if <dy>=0. boundry reached
	bgt	xint_loop				; if not loop again
	move	d6,d4					; unless <dy> is -ve and becomes dy2
	move	d5,d3					; and <x> becomes x2
	bra	xint_in					; and try again
xint_loop
	move	d5,d1					; <x> is new dx1
	move	d6,d2					; and <dy> is new dy1
	bra	xint_in

xint_end
	move.w	d5,(a1)+				; store intercept <x>
	move.w	d0,(a1)+				; and the y as new vertex coords
	addq.w	#1,(a2)					; and increment the vertex count
	movem	(sp)+,d5/d6
xint_out
	rts						; next vertex
* Leaves with a list of vertex coords at coords_in
* the number of polygon sides at no_in
*****************************************************************************************
