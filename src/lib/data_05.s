*****************************************************************************************
* Data_05.s
*****************************************************************************************
TRANSFORM	EQU	1

	include	data_04.s

my_datax	dc.w	100,100,0,0,20,90,20,15,45,45,15,55
		dc.w	70,55,10,10,10,10,20,20
my_datay	dc.w	0,100,100,0,15,60,87,25,40,65,74,46
		dc.w	55,61,30,5,95,60,25,74
my_dataz	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

xshear		dc.w	1,0,0,0,1,0,1,0,1
yshear		dc.w	1,0,0,1,1,0,1,0,1
zshear		dc.w	2,0,0,0,1,0,0,0,1

nparts		dc.w	6
inst_angles	dc.w	0,0,0,90,0,0,180,0,0,270,0,0,0,270,0,0,90,0
inst_disp	dc.w	0,0,0,0,100,0,0,100,100,0,0,100,100,0,0,0,0,100
