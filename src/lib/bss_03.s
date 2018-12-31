*****************************************************************************************
*	bss_03.s variables for the simple rotations demo
*****************************************************************************************
	include	bss_02.s

otheta		ds.w	1				; the rotation of object coords about wx
ophi		ds.w	1				; ditto wy
ogamma		ds.w	1				; ditt wz
ocoordsx	ds.w	200				; vertex x coords
ocoordsy	ds.w	200				; ditto y
ocoordsz	ds.w	200				; ditto z
oncoords	ds.w	1				; number
Oox		ds.w	1				; object origin x coord in world frame
Ooy		ds.w	1				; ditto y
Ooz		ds.w	1				; ditto z
* WORLD FRAME VARIABLES
wcoordsx	ds.w	200
wcoordsy	ds.w	200
wcoordsz	ds.w	200
* VARIABLES FOR THE O_W TRANSFORM
o_wmatx		ds.w	9				; the matrix elements
* GENERAL VARIABLES
stheta		ds.w	1				; trig functions of the current angle
ctheta		ds.w	1
sphi		ds.w	1
cphi		ds.w	1
sgamma		ds.w	1
cgamma		ds.w	1
