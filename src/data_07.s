*****************************************************************************************
*	data_07.s
*	Control matrices for rotation
*****************************************************************************************
* +ve rotation about the view frame x axis (LEFT) by 5 degrees.
rot_x_pos	dc.w	16384,0,0,0,16322,1428,0,-1428,16322

* -ve rotation about the xv axis (RIGHT)
rot_x_neg	dc.w	16384,0,0,0,16322,-1428,0,1428,16322

* +ve rotation about the yv axis (UP)
rot_y_pos	dc.w	16322,0,-1428,0,16384,0,1428,0,16322

* -ve rotation about the yv axis (DOWN)
rot_y_neg	dc.w	16322,0,1428,0,16384,0,-1428,0,16322

* +ve rotation about the zv axis (ROLL RIGHT)
rot_z_pos	dc.w	16322,1428,0,-1428,16322,0,0,0,16384

* -+ve rotation about the zv axis (ROLL LEFT)
rot_z_pos	dc.w	16322,-1428,0,1428,16322,0,0,0,16384
