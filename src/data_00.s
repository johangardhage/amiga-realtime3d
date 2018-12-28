*****************************************************************************************
* Data.s
* This is where the those constants that are common to ALL these files are kept.
*****************************************************************************************
*STRING CONSTANTS
LowLevelName	dc.b	'lowlevel.library',0
		EVEN
WBench_Name	dc.b	'Workbench',0
		EVEN
GrafName	dc.b	'graphics.library',0
		EVEN
IntuiName	dc.b	'intuition.library',0
		EVEN
DosName		dc.b	'dos.library',0
		EVEN
;File		dc.b	'DATA:Polyback.bin',0
		EVEN
color_table
	IFND	OTHER_PALETTE
	dc.w	$0000					; color 0
	dc.w	$0d00
	dc.w	$0f00
	dc.w	$0f80
	dc.w	$0f90
	dc.w	$0fb0
	dc.w	$0fd0
	dc.w	$0ff0
	dc.w	$0bf0
	dc.w	$08e0
	dc.w	$00f0
	dc.w	$02c0
	dc.w	$00b1
	dc.w	$00bb
	dc.w	$00db
	dc.w	$01fb					; color 15
	ELSEIF
* blues
	dc.w	0,$011f,$011d,$011b,$0119,$0117,$0115,$0113
* reds
	dc.w	$0f11,$0d11,$0b11,$0911,$0711,$0511,$0411,$0311
	ENDC

 	IFD	THIRTYTWOCOLOURS
 	IFND	OTHER_PALETTE
	dc.w	$06fe					; color 16
	dc.w	$06ce
	dc.w	$000f
	dc.w	$061f
	dc.w	$006d
	dc.w	$091f
	dc.w	$0c1f
	dc.w	$0f1f
	dc.w	$0fac
	dc.w	$0db9
	dc.w	$0c80
	dc.w	$0a87
	dc.w	$0ccc
	dc.w	$0999
	dc.w	$0fff
	dc.w	$0000
	ELSEIF
* greens
	dc.w	$01f1,$01d1,$01b1,$0191,$0171,$0151,$0131,$0121
* greys
	dc.w	$0fff,$0ddd,$0bbb,$0999,$0777,$0555,$0333,$0222
	ENDC
	ENDC
