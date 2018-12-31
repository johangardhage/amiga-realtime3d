***************************************************************************************
* Polygon.equates
*
***************************************************************************************
ExecBase	equ	$0004
Version_39	equ	39				; for Intuition
Version_36	equ	36				; for Grafix

QUIT		equ	$FFFF

sizex		equ	320
		IFD	MY_NTSC
sizey		equ	200
		ELSEIF
sizey		equ	256
		ENDC

WIDTH		equ	sizex/8
HEIGHT		equ	sizey

		IFD	TWOCOLOURS
DEPTH		EQU	1
		ENDC
		IFD	FOURCOLOURS
DEPTH		EQU	2
		ENDC
		IFD	EIGHTCOLOURS
DEPTH		EQU	3
		ENDC
		IFD	SIXTEENCOLOURS
DEPTH		EQU	4
		ENDC
		IFD	THIRTYTWOCOLOURS
DEPTH		EQU	5
		ENDC

vp_width	equ	sizex
vp_height	equ	sizey
dxoffset	equ	0
dyoffset	equ	0
Filesize	equ	(WIDTH*HEIGHT*DEPTH)

MINIMUM_Y	EQU	199
MINIMUM_X	EQU	319

EIGHT		equ	3				; *8,/8 when shifting
SIXTEEN		equ	4				; *16 or /16 when shifting
SIXTYFOUR	equ	6				; *64,/64 for shifting
NUM_VERTICES	equ	8
