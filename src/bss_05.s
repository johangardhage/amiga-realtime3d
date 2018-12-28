******************************************************************************************
*	bss_05.s
******************************************************************************************
	include	bss_04.s

* World Frame Variables
wncoords	ds.w	1				; num vertices in world frame
* View frame vars
vtheta		ds.w	1				; rotation of view frame abouut wx
vphi		ds.w	1				; wy
vgamma		ds.w	1				; wz
Ovx		ds.w	1				; view frame x origin in world frame
Ovy		ds.w	1
Ovz		ds.w	1
* General transform matrices
w_vmatx		ds.w	9
tempmatx	ds.w	9
* joystick
joy_data	ds.w	1
* Dynamic vars
speed		ds.w	1
vtheta_inc	ds.w	1
vphi_inc	ds.w	1
vgamma_inc	ds.w	1
shearflag	ds.w	1
quitflag	ds.w	1
