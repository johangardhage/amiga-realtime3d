*****************************************************************************************
*	BSS_01
*****************************************************************************************
	include	bss_00.s

* Polygon attributes
crds_in		ds.w	100				; input coords
crds_out	ds.w	100				; output as above
no_out		ds.w	1				; output number
colr_lst	ds.w	20				; list of polygon colours
clp_xmax	ds.w	1				; clip frame limits
clp_xmin	ds.w	1
clp_ymin	ds.w	1
clp_ymax	ds.w	1
