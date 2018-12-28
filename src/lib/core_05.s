******************************************************************************************
*	Core_05.s
* A set of subroutines for transforming world coords. Including rotations of vtheta
* vphi and vgamma about the x,y and z axes as well as x, y and z shears.
*
******************************************************************************************
	include	core_04.s
* The matrix for the rotations is constructed.
* convert rotation angles to sin & cos and store for rotation matrix.
wtranv_1
	bsr	view_trig				; find the sines and cosines
* construct transform matrix wtranv.
	lea	stheta,a0
	lea	ctheta,a1
	lea	sphi,a2
	lea	cphi,a3
	lea	sgamma,a4
	lea	cgamma,a5
	lea	w_vmatx,a6
* do element WM11
	move.w	(a3),d0					; cphi
	muls	(a5),d0					; cphi*cgamma
	lsl.l	#2,d0
	swap	d0
	move.w	d0,(a6)+				; WM11
* do element WM12
	move.w	(a1),d0					; ctheta
	muls	(a4),d0					; ctheta*sgamma
	move.w	(a0),d1					; stheta
	muls	(a2),d1					; stheta*sphi
	lsl.l	#2,d1
	swap	d1
	muls	(a5),d1					; stheta*sphi*cgamma
	add.l	d0,d1					; stheta*sphi*cgamma + ctheta*sgamma
	lsl.l	#2,d1
	swap	d1
	move.w	d1,(a6)+
* do WM13
	move.w	(a0),d0					; stheta
	muls	(a4),d0					; stheta * sgamma
	move.w	(a1),d1					; ctheta
	muls	(a2),d1					; ctheta*sphi
	lsl.l	#2,d1
	swap	d1
	muls	(a5),d1					; ctheta*sphi*cgamma
	sub.l	d1,d0					; stheta*sgamma - ctheta*sphi*cgamma
	lsl.l	#2,d0
	swap	d0
	move.w	d0,(a6)+
* do WM21
	move.w	(a3),d0					; cphi
	muls	(a4),d0					; ctheta*sgamma
	lsl.l	#2,d0
	swap	d0
	neg	d0
	move.w	d0,(a6)+
* do WM22
	move.w	(a1),d0					; ctheta
	muls	(a5),d0					; ctheta*cgamma
	move.w	(a0),d1					; stheta
	muls	(a2),d1					; stheta*sphi
	lsl.l	#2,d1
	swap	d1
	muls	(a4),d1					; stheta**sphi*sgamma
	sub.l	d1,d0					; ctheta*cgamma-stheta*sgamma
	lsl.l	#2,d0
	swap	d0
	move.w	d0,(a6)+
* do WM23
	move.w	(a0),d0					; stheta
	muls	(a5),d0					; stheta*cgamma
	move.w	(a1),d1					; ctheta
	muls	(a2),d1					; ctheta*sphi
	lsl.l	#2,d1
	swap	d1
	muls	(a4),d1					; ctheta*sphi*sgamma
	add.l	d0,d1
	lsl.l	#2,d1
	swap	d1
	move.w	d1,(a6)+
* do WM31
	move.w	(a2),(a6)+
* do WM32
	move.w	(a3),d0					; cphi
	muls	(a0),d0					; cphi*stheta
	lsl.l	#2,d0
	swap	d0
	neg	d0
	move.w	d0,(a6)+
* do WM33
	move.w	(a1),d0					; ctheta
	muls	(a3),d0					; ctheta*cphi
	lsl.l	#2,d0
	swap	d0
	move.w	d0,(a6)+
	rts
*****************************************************************************************
* PART 2: Transform the World coords to view coords.
wtranv_2
	move.w	wncoords,d7
	ext.l	d7					; any to do?
	beq	wtranv3
	subq.w	#1,d7
	lea	wcoordsx,a0
	lea	wcoordsy,a1
	lea	wcoordsz,a2
	lea	vcoordsx,a3
	lea	vcoordsy,a4
	lea	vcoordsz,a5
	exg	a3,d3					; save cos we're short of registers
	link	a6,#-6					; save 3 words
wtranv1
	moveq.l	#2,d6					; 3 rows in matrix
	lea	w_vmatx,a3				; init max pointer
* calculate the next wx, wy and wz
wtranv2
	move.w	(a0),d0					; wx
	move.w	(a1),d1					; wy
	move.w	(a2),d2					; wz
	sub.w	#50,d0					; wx-50
	sub.w	#50,d1					; wy-50
	sub.w	#50,d2					; wz-50
	muls	(a3)+,d0				; wx*Mi1
	muls	(a3)+,d1				; wy*Mi2
	muls	(a3)+,d2				; wz*Mi3

	add.l	d1,d0
	add.l	d2,d0					; wx*Mi+wy*Mi2+wz*Mi3
	lsl.l	#2,d0
	swap	d0
	move.w	d0,-(a6)
	dbra	d6,wtranv2				; repeat for 3 elements

	move.w	(a6)+,d0
	add.w	Ovz,d0
	move.w	d0,(a5)+				; becomes vz
	move.w	(a6)+,(a4)+
	exg	a3,d3					; restore vx, save matx pointer
	move.w	(a6)+,d0
	add.w	#100,d0
	move.w	d0,(a3)+				; becomes vx
	exg	a3,d3					; save vx, restore matx pointer
	addq.l	#2,a0					; point to next wx
	addq.l	#2,a1					; wy
	addq.l	#2,a2					; wz
	dbra	d7,wtranv1				; repeat for all ocoords
	unlk	a6					; close frame
wtranv3
	rts
*
* Calculate the sines and cosines of the view angles
view_trig
	move.w	vtheta,d1				; theta
	bsr	sincos
	move.w	d2,stheta				; sine
	move.w	d3,ctheta				; cosine
	move.w	vphi,d1
	bsr	sincos
	move.w	d2,sphi
	move.w	d3,cphi
	move.w	vgamma,d1				; gamma
	bsr	sincos
	move.w	d2,sgamma
	move.w	d3,cgamma
	rts
*
* Read jstick and update vars accordingly.
joy_in
	move.w	$dff00c,d0				; read jstick register
* convert value to angle totals
angle_speed
	btst	#8,d0					; up or left?
	beq	dwn_rt					; nope
	btst	#9,d0					; left?
	beq	up
	bra	left
dwn_rt
	btst	#0,d0					; down or right?
	beq	joy_out
	btst	#1,d0					; right?
	beq	down
	bra	right
joy_out
	rts
	IFD	JOY1
* set up the increments to angles +/-10 is the limit
up
	subq.w	#2,vphi_inc
	rts
down
	addq.w	#2,vphi_inc
	rts
left
	addq.w	#2,vtheta_inc
	rts
right
	subq.w	#2,vtheta_inc
	rts
	ENDC
	IFD	JOY2
up
	move.w	#350,vyangle
	bsr	rot_vy
	rts
down
	move.w	#10,vyangle
	bsr	rot_vy
	rts
left
	move.w	#10,vxangle
	bsr	rot_vx
	rts
right
	move.w	#350,vxangle
	bsr	rot_vx
	rts
	ENDC
	IFD	JOY3
up
	bsr	rot_down
	rts
down
	bsr	rot_up
	rts
left
	bsr	rot_left
	rts
right
	bsr	rot_right
	rts
	ENDC
	IFD	JOY4
up
	move.w	#-5,vphi_inc
	rts
down
	move.w	#5,vphi_inc
	rts
left
	move.w	#5,vtheta_inc
	rts
right
	move.w	#-5,vtheta_inc
	rts
	ENDC
**************************************************************
angle_update
	move.w	vtheta_inc,d0
	bmi	vth_neg
	beq	chk_phi
	subq.w	#1,vtheta_inc
	cmp.w	#25,vtheta_inc
	ble	chk_phi
	move.w	#25,vtheta_inc
	bra	chk_phi
vth_neg
	addq.w	#1,vtheta_inc
	cmp.w	#-25,vtheta_inc
	bge	chk_phi
	move.w	#-25,vtheta_inc
chk_phi
	move.w	vphi_inc,d0
	bmi	vph_neg
	beq	chk_out
	subq.w	#1,vphi_inc
	cmp.w	#25,vphi_inc
	ble	chk_out
	move.w	#25,vphi_inc
	bra	chk_out
vph_neg
	addq.w	#1,vphi_inc
	cmp.w	#-25,vphi_inc
	bge	chk_out
	move.w	#-25,vphi_inc
chk_out
* update vtheta
	move.w	vtheta,d0				; the previous angle
	add.w	vtheta_inc,d0				; increase by increment
	bgt	thta_1					; check it lies between 0 and 360
	add	#360,d0
	bra	thta_2
thta_1
	cmp.w	#360,d0
	blt	thta_2
	sub	#360,d0
thta_2
	move.w	d0,vtheta				; becomes the current angle
* update vphi
	move.w	vphi,d0
	add.w	vphi_inc,d0
	bgt	phi_1
	add	#360,d0
	bra	phi_2
phi_1
	cmp.w	#360,d0
	blt	phi_2
	sub	#360,d0
phi_2
	move.w	d0,vphi
	rts
*****************************************************************************************
key_in
in_key
	clr.w	d0
	move.b	$bfec01,d0
	cmp.b	#$5f,d0
	beq	f1
	cmp.b	#$5d,d0
	beq	f2
	cmp.b	#$5b,d0
	beq	f3
	cmp.b	#$59,d0
	beq	f4
	cmp.b	#$57,d0
	beq	f5
	cmp.b	#$55,d0
	beq	f6
	cmp.b	#$53,d0
	beq	f7
	rts
	IFD	JOY3
f1	bsr	roll_left
	rts
f2	bsr	roll_right
	rts
f3	move.w	#-2,speed
	rts
f4	move.w	#2,speed
	rts
f5	move.w	#3,speed
	rts
f6	move.w	#0,speed				; stop
	rts
f7	move.w	#QUIT,quitflag
	rts
	ELSE
f1	move.w	#-1,speed				; reverse
	rts
f2	move.w	#1,speed				; forward
	rts
f3	bchg.b	#2,shearflag				; toggle x shearflag
	rts
f4	bchg.b	#1,shearflag				; toggle yshearflag
	rts
f5	bchg.b	#0,shearflag				; toggle z shearflag
	rts
f6	move.w	#0,speed				; stop
	rts
f7	move.w	#QUIT,quitflag
	rts
	ENDC
******************************************************************************************
* concatenate the shear with the rotation
shear
	clr	d0
	move.b	shearflag,d0				; flag is lower 3 bits
	and	#$f,d0
* there are 8 possibilities 111 - 000, xyz respectively
	lea	shear_jump,a0
	lsl.w	#2,d0					; get offset
	move.l	0(a0,d0.w),a0
	jmp	(a0)
shear_jump
	dc.l	null,z,y,user1,x,user2,user3,user4
null
	rts
z
	lea	zshear,a0
	lea	w_vmatx,a1
	bsr	concat
	rts
y
	lea	yshear,a0
	lea	w_vmatx,a1
	bsr	concat
	rts
user1
	rts
x
	lea	xshear,a0
	lea	w_vmatx,a1
	bsr	concat
	rts
user2	rts
user3	rts
user4	rts
*
* Multiply two 3x3 matrices pointed to by a0 and a1
* order is (a1)x(a0) with result sent to temp store at (a2)
* (a0) is in column order whilw (a1) and (a2) are in row order, of word length elements.
* Finally (a2) is copied to (A1).
concat
	lea	tempmatx,a2
	move.w	#2,d7					; 3 rows
conc1
	move.w	#2,d6
	movea.l	a0,a3					; reset shear pointer
conc2
	move.w	(a1),d1
	ext.l	d1
	lsr.l	#1,d1
	move.w	2(a1),d2
	ext.l	d2
	lsr.l	#1,d2
	move.w	4(a1),d3
	ext.l	d3
	lsr.l	#1,d3
	muls	(a3)+,d1
	muls	(a3)+,d2
	muls	(a3)+,d3
	add.w	d2,d1
	add.w	d3,d1
	move.w	d1,(a2)+				; next product element
	dbra	d6,conc2				; do all elements in row
	addq.w	#6,a1					; point to next row
	dbra	d7,conc1				; for al rowa
* transfer result back to rotation matrix
	lea	tempmatx,a0
	lea	w_vmatx,a1
	move.w	#8,d7					; num elements -1
conloop
	move.w	(a0)+,(a1)+
	dbra	d7,conloop
	rts
* set the velocity components
speed_adj
	move.w	speed,d0
	lsl.w	#3,d0					; scale it
	move.w	Ovz,d1
	cmp.w	#10,Ovz
	bgt	adj_out
	move.w	#10,Ovz
adj_out
	add.w	d0,Ovz
	rts
