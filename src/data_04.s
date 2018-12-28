******************************************************************************************
* data_04.s
******************************************************************************************
	include	data_03.s

ill_vecx	dc.w	-100
ill_vecy	dc.w	-16384					; LIGHT SHINING FROM +Y TO -Y
ill_vecz	dc.w	0
vwpointz	dc.w	-100
illkey		dc.w	2
intr_col	dc.w	0,1,0,0,1,1

OTHER_PALETTE	EQU	1					; to use with illumination
