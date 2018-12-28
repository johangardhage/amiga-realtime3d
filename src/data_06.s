*****************************************************************************************
*	data_06.s
*	Data for chapter 10
*****************************************************************************************
	include	data_05.s				; (ensure we include data_03.s as well).

* The vector table of graphics primitives in 8 shades of 4 colours.
primitive	dc.l	prim0,prim1,prim2,prim3,prim4,prim5

* Now follow the vector tables for each primitive.

prim0							; A simple block
	dc.l	colrs0,npoly0,nedg0,edglst0,prm0x,prm0y,prm0z,npts0,theta0
colrs0	dc.w	1,1,1,1,1
npoly0	dc.w	5
nedg0	dc.w	4,4,4,4,4
edglst0	dc.w	0,1,2,3,0,3,2,4,5,3,5,4,6,7,5,7,6,1,0,7,1,6,4,2,1
prm0x	dc.w	0,50,50,0,70,0,70,0
prm0y	dc.w	-6,-6,6,6,6,6,-6,-6
prm0z	dc.w	-6,-6,-6,-6,6,6,6,6
npts0	dc.w	8
theta0	dc.l	$10000

prim1							; An inverted pyramid
	dc.l	colrs1,npoly1,nedg1,edglst1,prm1x,prm1y,prm1z,npts1,theta1
colrs1	dc.w	2,2,2,2,3
npoly1	dc.w	5
nedg1	dc.w	3,3,3,3,4
edglst1	dc.w	0,1,2,0,0,2,3,0,0,3,4,0,0,4,1,0,1,4,3,2,1
prm1x	dc.w	0,75,75,75,75
prm1y	dc.w	0,-32,32,32,-32
prm1z	dc.w	0,-32,-32,32,32
npts1	dc.w	5
theta1	dc.l	$10000

prim2							; A nugget.
	dc.l	colrs2,npoly2,nedg2,edglst2,prm2x,prm2y,prm2z,npts2,theta2
colrs2	dc.w	1,1,0,1,0,0,1,0,1,1,0,1,0,1
npoly2	dc.w	14
nedg2	dc.w	4,4,4,4,4,4,4,4,4,4,4,4,4,4
edglst2	dc.w	1,6,4,2,1,0,1,2,3,0,3,2,4,5,3,4,6,7,5,4,6,1,0,7,6,8,0,3,11,8,3
	dc.w	5,10,11,3,5,7,9,10,5,7,0,8,9,7,8,11,13,12,8,11,10,14,13,11,10,9
	dc.w	15,14,10,9,8,12,15,9,12,13,14,15,12
prm2x	dc.w	40,60,60,40,60,40,60,40,20,20,20,20,0,0,0,0
prm2y	dc.w	-30,-10,10,30,10,30,-10,-30,-30,-30,30,30,-10,10,10,-10
prm2z	dc.w	-30,-10,-10,-30,10,30,10,30,-30,30,30,-30,-10,-10,10,10
npts2	dc.w	16
theta2	dc.l	$70000

prim3							; A Tee.
	dc.l	colrs3,npoly3,nedg3,edglst3,prm3x,prm3y,prm3z,npts3,theta3
colrs3	dc.w	2,2,2,2,2,2,2,2,2,2
npoly3	dc.w	10
nedg3	dc.w	4,4,4,4,4,4,4,4,4,4
edglst3	dc.w	0,1,2,3,0,3,2,4,7,3,4,5,6,7,4,5,1,0,6,5
	dc.w	8,11,14,15,8,13,14,11,10,13,12,13,10,9,12,8,15,12,9,8
	dc.w	12,15,14,13,12,10,11,8,9,10
prm3x	dc.w	0,45,45,0,45,45,0,0,70,45,45,70,45,45,70,70
prm3y	dc.w	-10,-10,10,10,10,-10,-10,10,128,128,128,128,-128,-128,-128,-128
prm3z	dc.w	-10,-10,-10,-10,10,10,10,10,10,10,-10,-10,10,-10,-10,10
npts3	dc.w	16
theta3	dc.l	$10000

prim4							; A roller
	dc.l	colrs4,npoly4,nedg4,edglst4,prm4x,prm4y,prm4z,npts4,theta4
colrs4	dc.w	1,0,1,0,1,0,1,1
npoly4	dc.w	8
nedg4	dc.w	4,4,4,4,4,4,6,6
edglst4	dc.w	1,2,8,7,1,0,1,7,6,0,5,0,6,11,5,4,5,11,10,4,3,4,10,9,3
	dc.w	2,3,9,8,2,4,3,2,1,0,5,4,6,7,8,9,10,11,6
prm4x	dc.w	0,40,40,0,-40,-40,0,40,40,0,-40,-40
prm4y	dc.w	-8,-8,-8,-8,-8,-8,8,8,8,8,8,8
prm4z	dc.w	-45,-20,20,45,20,-20,-45,-20,20,45,20,-20
npts4	dc.w	12
theta4	dc.l	$20000

prim5							; Another roller
	dc.l	colrs5,npoly5,nedg5,edglst5,prm5x,prm5y,prm5z,npts5,theta5
colrs5	dc.w	3,2,3,2,3,2,3,3
npoly5	dc.w	8
nedg5	dc.w	4,4,4,4,4,4,6,6
edglst5	dc.w	1,2,8,7,1,0,1,7,6,0,5,0,6,11,5,4,5,11,10,4,3,4,10,9,3
	dc.w	2,3,9,8,2,4,3,2,1,0,5,4,6,7,8,9,10,11,6
prm5x	dc.w	0,40,40,0,-40,-40,0,40,40,0,-40,-40
prm5y	dc.w	-8,-8,-8,-8,-8,-8,8,8,8,8,8,8
prm5z	dc.w	-45,-20,20,45,20,-20,-45,-20,20,45,20,-20
npts5	dc.w	12
theta5	dc.l	$40000
