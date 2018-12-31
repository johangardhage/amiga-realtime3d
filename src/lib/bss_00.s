************************************************************************************
*	BSS_00.s
*	Put all the variables you want to use in here
************************************************************************************
* POLYGON VARIABLES
colour		ds.w	1				; current colour
no_in		ds.w	1				; number of polygon vertices
xmin		ds.w	1				; limits
xmax		ds.w	1				; for
ymin		ds.w	1				; xbuf
ymax		ds.w	1
coords_lst	ds.l	1

* BITPLANE VARIABLES
maskplane	ds.l	1				; base addresses
storeplane	ds.l	1
log_screen	ds.l	1
msk_y_tbl	ds.l	200				; scan line addresses
xbuf		ds.l	200				; x buffer
bltstrt		ds.l	1
bltwidth	ds.w	1
blitsize	ds.w	1
blitmod		ds.w	1
showplanes_list	ds.l	DEPTH				; a list of pointers to each of the bitplanes per playfield
workplanes_list	ds.l	DEPTH

		IFD	A500
scrn1_base	ds.l	1
scrn2_base	ds.l	1
cl1adr		ds.l	1
cl2adr		ds.l	1
cladr		ds.l	1
oldcop		ds.l	1
		ENDC

gfxversion	ds.w	1				; lib version
vbi_flag	ds.w	1
show_bitmap	ds.l	1				; BitMap structure pointers
work_bitmap	ds.l	1
showlist	ds.l	1				; Copperlist pointes
worklist	ds.l	1
showplanes	ds.l	1				; VIDEO Ram pointers
workplanes	ds.l	1
draw_buffer	ds.l	1				; Bitplane sized memory to construct objects in
frame_done	ds.l	1				; flag to indicate frame finished

File_Handle	ds.l	1
File_Buffer	ds.l	1

DosBase		ds.l	1
GrafBase	ds.l	1
IntuiBase	ds.l	1
LowLevelBase	ds.l	1
OldActiView	ds.l	1
intHandle	ds.l	1				; V40 interrupt handle
colormap	ds.l	1
ReturnMsg	ds.l	1				; For system to use when we quit

* SYSTEM STRUCTURES I WANT TO USE.
		EVEN
vblank		ds.b	IS_SIZE				; store interrupt structure here.
		EVEN
my_view		ds.b	v_SIZEOF
		EVEN
my_viewport	ds.b	vp_SIZEOF
		EVEN
my_rasinfo	ds.b	ri_SIZEOF
