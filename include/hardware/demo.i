	IFND	HARDWARE_DEMO_I
HARDWARE_DEMO_I	SET	1
**
**	$VER: demo.i 39.1 (29.8.96)
**	Includes Release 40.13+1
**
**	Offsets of Amiga custom chip registers (Custom + CIA)
**
**	Now also compatible with 'hardware/custom.i'.
**	(Yes, you must include 'demo.i' instead of 'custom.i'!)
**
**	Updated by Harry Sintonen. Public Domain.
**
**	Credits must go to the original (unknown?) author of this great file!
**	Sorry, but I couldn't find your name from anywhere... ;-(
**	All handy macros and CIA stuff was made by him/her.
**

	IFD	HARDWARE_CUSTOM_I
	FAIL !! YOU CAN'T INCLUDE BOTH custom.i AND demo.i !!
	ENDC

* Setup for NOMACROS

 IFND		NOMACROS
NOMACROS	SET     0
 ENDC

* Custom chip register addresses *
Custom		EQU	$DFF000	; Custom chips base address

		rsreset
bltddat		rs.w	1	; Blitter Destination Data (DMA only)
dmaconr		rs.w	1	; DMA Enable Read
vposr		rs.w	1	; Vertical Beam Position Read
vhposr		rs.w	1	; Vert/Horiz Beam Position Read
dskdatr		rs.w	1	; Disk Data Read (DMA only)
joy0dat		rs.w	1	; Joystick/Mouse Port 0 Data (read)
joy1dat		rs.w	1	; Joystick/Mouse Port 1 Data (read)
clxdat		rs.w	1	; Collision Data (read)
adkconr		rs.w	1	; Audio/Disk Control Read
pot0dat		rs.w	1	; Pot Port 0 Data Read
pot1dat		rs.w	1	; Pot Port 1 Data Read
potgor		rs.w	1	; Pot Port Data Read
serdatr		rs.w	1	; Serial Data Input and Status Read
dskbytr		rs.w	1	; Disk Data Byte and Disk Status Read
intenar		rs.w	1	; Interrupt Enable (read)
intreqr		rs.w	1	; Interrupt REQUest (read)
dskpt		rs.w	0	; Disk Pointer (write)
dskpth		rs.w	1
dskptl		rs.w	1
dsklen		rs.w	1	; Disk Data Length
dskdat		rs.w	1	; Disk DMA Write
refptr		rs.w	1	; Refresh Pointer (write) DON'T USE!
vposw		rs.w	1	; Vert Beam Position Write DON'T USE!
vhposw		rs.w	1	; Vert/Horiz Beam Pos Write DON'T USE!
copcon		rs.w	1	; Coprocessor Control
serdat		rs.w	1	; Serial Data Output (write)
serper		rs.w	1	; Serial Period & Data Bit Control (write)
potgo		rs.w	1	; Pot Port Data (write)
joytest		rs.w	1	; JOY0DAT and JOY1DAT Write
strequ		rs.w	1	; Short Frame Vertical Strobe
strvbl		rs.w	1	; Normal Vertical Blank Stobe
strhor		rs.w	1	; Horizontal Sync Strobe
strlong		rs.w	1	; Long Raster Strobe
bltcon0		rs.w	1	; Blitter Control Register 0 (write)
bltcon1		rs.w	1	; Blitter Control Register 1 (write)
bltafwm		rs.w	1	; Source A First Word Mask (write)
bltalwm		rs.w	1	; Source A Last Word Mask (write)
bltcpt		rs.w	0	; Blitter Source C Pointer (write)
bltcpth		rs.w	1
bltcptl		rs.w	1
bltbpt		rs.w	0	; Blitter Source B Pointer (write)
bltbpth		rs.w	1
bltbptl		rs.w	1
bltapt		rs.w	0	; Blitter Source A Pointer (write)
bltapth		rs.w	1
bltaptl		rs.w	1
bltdpt		rs.w	0	; Blitter Destination Pointer (write)
bltdpth		rs.w	1
bltdptl		rs.w	1
bltsize		rs.w	1	; Blitter Start and Size (write)
bltcon0l	rs.w	1	; just write the lf values of bltcon0 (write ecs)
bltsizv		rs.w	1	; Blitter V size (write ecs)
bltsizh		rs.w	1	; Blitter start and H size (write ecs)
bltcmod		rs.w	1	; Blitter Source C Modulo (write)
bltbmod		rs.w	1	; Blitter Source B Modulo (write)
bltamod		rs.w	1	; Blitter Source A Modulo (write)
bltdmod		rs.w	1	; Blitter Destination Modulo (write)
		rs.w	1	; unused
		rs.w	1	; unused
		rs.w	1	; unused
		rs.w	1	; unused
bltcdat		rs.w	1	; Blitter Source C Data (write)
bltbdat		rs.w	1	; Blitter Source B Data (write)
bltadat		rs.w	1	; Blitter Source A Data (write)
		rs.w	1	; unused
sprhdat		rs.w	1	; Ext logic UHRES sprite pointer and data identifier (write ecs)
bplhdat		rs.w	1	; Ext logic UHRES bit plane identifier (write ecs)
deniseid	rs.w	0
lisaid		rs.w	1	; Chip revision level for Denise/Lisa (read ecs)
dsksync		rs.w	1	; Disk Sync Pattern (write)
cop1lc		rs.w	0	; Copper Program Counter 1 (write)
cop1lch		rs.w	1
cop1lcl		rs.w	1
cop2lc		rs.w	0	; Copper Program Counter 2 (write)
cop2lch		rs.w	1
cop2lcl		rs.w	1
copjmp1		rs.w	1	; Copper Jump Strobe 1
copjmp2		rs.w	1	; Copper Jump Strobe 2
copins		rs.w	1	; Copper Instruction Identity (write)
diwstrt		rs.w	1	; Display Window Start (write)
diwstop		rs.w	1	; Display Window Stop (write)
ddfstrt		rs.w	1	; Display Data Fetch Start (write)
ddfstop		rs.w	1	; Display Data Fetch Stop (write)
dmacon		rs.w	1	; DMA Control (write)
clxcon		rs.w	1	; Collision Control (write)
intena		rs.w	1	; Interrupt Enable (write)
intreq		rs.w	1	; Interrupt REQUest (write)
adkcon		rs.w	1	; Audio/Disk Control (write)
aud		rs.w	0	; custom.i compatibility
aud0		rs.w	0	; custom.i compatibility
aud0lc		rs.w	0	; Channel 0 Waveform Address (write)
aud0lch		rs.w	1
aud0lcl		rs.w	1
aud0len		rs.w	1	; Channel 0 Waveform Length (write)
aud0per		rs.w	1	; Channel 0 Period (write)
aud0vol		rs.w	1	; Channel 0 Volume (write)
aud0dat		rs.w	1	; Channel 0 Data (write)
		rs.w	1	; unused
		rs.w	1	; unused
aud1		rs.w	0	; custom.i compatibility
aud1lc		rs.w	0	; Channel 1 Waveform Address (write)
aud1lch		rs.w	1
aud1lcl		rs.w	1
aud1len		rs.w	1	; Channel 1 Waveform Length (write)
aud1per		rs.w	1	; Channel 1 Period (write)
aud1vol		rs.w	1	; Channel 1 Volume (write)
aud1dat		rs.w	1	; Channel 1 Data (write)
		rs.w	1	; unused
		rs.w	1	; unused
aud2		rs.w	0	; custom.i compatibility
aud2lc		rs.w	0	; Channel 2 Waveform Address (write)
aud2lch		rs.w	1
aud2lcl		rs.w	1
aud2len		rs.w	1	; Channel 2 Waveform Length (write)
aud2per		rs.w	1	; Channel 2 Period (write)
aud2vol		rs.w	1	; Channel 2 Volume (write)
aud2dat		rs.w	1	; Channel 2 Data (write)
		rs.w	1	; unused
		rs.w	1	; unused
aud3		rs.w	0	; custom.i compatibility
aud3lc		rs.w	0	; Channel 3 Waveform Address (write)
aud3lch		rs.w	1
aud3lcl		rs.w	1
aud3len		rs.w	1	; Channel 3 Waveform Length (write)
aud3per		rs.w	1	; Channel 3 Period (write)
aud3vol		rs.w	1	; Channel 3 Volume (write)
aud3dat		rs.w	1	; Channel 3 Data (write)
		rs.w	1	; unused
		rs.w	1	; unused
bplpt		rs.w	0	; custom.i compatibility
bpl1pt		rs.w	0	; Bitplane 1 Pointer (write)
bpl1pth		rs.w	1
bpl1ptl		rs.w	1
bpl2pt		rs.w	0	; Bitplane 2 Pointer (write)
bpl2pth		rs.w	1
bpl2ptl		rs.w	1
bpl3pt		rs.w	0	; Bitplane 3 Pointer (write)
bpl3pth		rs.w	1
bpl3ptl		rs.w	1
bpl4pt		rs.w	0	; Bitplane 4 Pointer (write)
bpl4pth		rs.w	1
bpl4ptl		rs.w	1
bpl5pt		rs.w	0	; Bitplane 5 Pointer (write)
bpl5pth		rs.w	1
bpl5ptl		rs.w	1
bpl6pt		rs.w	0	; Bitplane 6 Pointer (write)
bpl6pth		rs.w	1
bpl6ptl		rs.w	1
bpl7pt		rs.w	0	; Bitplane 7 Pointer (write aga)
bpl7pth		rs.w	1
bpl7ptl		rs.w	1
bpl8pt		rs.w	0	; Bitplane 8 Pointer (write aga)
bpl8pth		rs.w	1
bpl8ptl		rs.w	1
bplcon0		rs.w	1	; Bitplane Control Register 0 (write)
bplcon1		rs.w	1	; Bitplane Control Register 1 (write)
bplcon2		rs.w	1	; Bitplane Control Register 2 (write)
bplcon3		rs.w	1	; Bitplane Control Register 3 (write ecs)
bpl1mod		rs.w	1	; Bitplane Modulo 1 (write)
bpl2mod		rs.w	1	; Bitplane Modulo 2 (write)
bplcon4		rs.w	1	; Bit plane control reg (bitplane & sprite masks) (write aga)
clxcon2		rs.w	1	; Extended collision control reg (write aga)
bpldat		rs.w	0	; custom.i compatibility
bpl1dat		rs.w	1	; Bitplane Data Register 1 (write)
bpl2dat		rs.w	1	; Bitplane Data Register 2 (write)
bpl3dat		rs.w	1	; Bitplane Data Register 3 (write)
bpl4dat		rs.w	1	; Bitplane Data Register 4 (write)
bpl5dat		rs.w	1	; Bitplane Data Register 5 (write)
bpl6dat		rs.w	1	; Bitplane Data Register 6 (write)
bpl7dat		rs.w	1	; Bitplane Data Register 7 (write aga)
bpl8dat		rs.w	1	; Bitplane Data Register 8 (write aga)
sprpt		rs.w	0	; custom.i compatibility
spr0pt		rs.w	0	; Sprite Pointer 0 (write)
spr0pth		rs.w	1
spr0ptl		rs.w	1
spr1pt		rs.w	0	; Sprite Pointer 1 (write)
spr1pth		rs.w	1
spr1ptl		rs.w	1
spr2pt		rs.w	0	; Sprite Pointer 2 (write)
spr2pth		rs.w	1
spr2ptl		rs.w	1
spr3pt		rs.w	0	; Sprite Pointer 3 (write)
spr3pth		rs.w	1
spr3ptl		rs.w	1
spr4pt		rs.w	0	; Sprite Pointer 4 (write)
spr4pth		rs.w	1
spr4ptl		rs.w	1
spr5pt		rs.w	0	; Sprite Pointer 5 (write)
spr5pth		rs.w	1
spr5ptl		rs.w	1
spr6pt		rs.w	0	; Sprite Pointer 6 (write)
spr6pth		rs.w	1
spr6ptl		rs.w	1
spr7pt		rs.w	0	; Sprite Pointer 7 (write)
spr7pth		rs.w	1
spr7ptl		rs.w	1
spr		rs.w	0	; custom.i compatibility
spr0pos		rs.w	1	; Sprite Position 0 (write)
spr0ctl		rs.w	1	; Sprite Control 0 (write)
spr0data	rs.w	1	; Sprite Data A Register 0 (write)
spr0datb	rs.w	1	; Sprite Data B Register 0 (write)
spr1pos		rs.w	1	; Sprite Position 1 (write)
spr1ctl		rs.w	1	; Sprite Control 1 (write)
spr1data	rs.w	1	; Sprite Data A Register 1 (write)
spr1datb	rs.w	1	; Sprite Data B Register 1 (write)
spr2pos		rs.w	1	; Sprite Position 2 (write)
spr2ctl		rs.w	1	; Sprite Control 2 (write)
spr2data	rs.w	1	; Sprite Data A Register 2 (write)
spr2datb	rs.w	1	; Sprite Data B Register 2 (write)
spr3pos		rs.w	1	; Sprite Position 3 (write)
spr3ctl		rs.w	1	; Sprite Control 3 (write)
spr3data	rs.w	1	; Sprite Data A Register 3 (write)
spr3datb	rs.w	1	; Sprite Data B Register 3 (write)
spr4pos		rs.w	1	; Sprite Position 4 (write)
spr4ctl		rs.w	1	; Sprite Control 4 (write)
spr4data	rs.w	1	; Sprite Data A Register 4 (write)
spr4datb	rs.w	1	; Sprite Data B Register 4 (write)
spr5pos		rs.w	1	; Sprite Position 5 (write)
spr5ctl		rs.w	1	; Sprite Control 5 (write)
spr5data	rs.w	1	; Sprite Data A Register 5 (write)
spr5datb	rs.w	1	; Sprite Data B Register 5 (write)
spr6pos		rs.w	1	; Sprite Position 6 (write)
spr6ctl		rs.w	1	; Sprite Control 6 (write)
spr6data	rs.w	1	; Sprite Data A Register 6 (write)
spr6datb	rs.w	1	; Sprite Data B Register 6 (write)
spr7pos		rs.w	1	; Sprite Position 7 (write)
spr7ctl		rs.w	1	; Sprite Control 7 (write)
spr7data	rs.w	1	; Sprite Data A Register 7 (write)
spr7datb	rs.w	1	; Sprite Data B Register 7 (write)
color		rs.w	0	; Color Register Base
color00		rs.w	1	; Color Register 0 (write)
color01		rs.w	1	; Color Register 1 (write)
color02		rs.w	1	; Color Register 2 (write)
color03		rs.w	1	; Color Register 3 (write)
color04		rs.w	1	; Color Register 4 (write)
color05		rs.w	1	; Color Register 5 (write)
color06		rs.w	1	; Color Register 6 (write)
color07		rs.w	1	; Color Register 7 (write)
color08		rs.w	1	; Color Register 8 (write)
color09		rs.w	1	; Color Register 9 (write)
color10		rs.w	1	; Color Register 10 (write)
color11		rs.w	1	; Color Register 11 (write)
color12		rs.w	1	; Color Register 12 (write)
color13		rs.w	1	; Color Register 13 (write)
color14		rs.w	1	; Color Register 14 (write)
color15		rs.w	1	; Color Register 15 (write)
color16		rs.w	1	; Color Register 16 (write)
color17		rs.w	1	; Color Register 17 (write)
color18		rs.w	1	; Color Register 18 (write)
color19		rs.w	1	; Color Register 19 (write)
color20		rs.w	1	; Color Register 20 (write)
color21		rs.w	1	; Color Register 21 (write)
color22		rs.w	1	; Color Register 22 (write)
color23		rs.w	1	; Color Register 23 (write)
color24		rs.w	1	; Color Register 24 (write)
color25		rs.w	1	; Color Register 25 (write)
color26		rs.w	1	; Color Register 26 (write)
color27		rs.w	1	; Color Register 27 (write)
color28		rs.w	1	; Color Register 28 (write)
color29		rs.w	1	; Color Register 29 (write)
color30		rs.w	1	; Color Register 30 (write)
color31		rs.w	1	; Color Register 31 (write)
htotal		rs.w	1	; Highest number count, horiz line (VARBEAMEN=1) (write ecs)
hsstop		rs.w	1	; Horiz line pos for HSYNC stop (write ecs)
hbstrt		rs.w	1	; Horiz line pos for HBLANK start (write ecs)
hbstop		rs.w	1	; Horiz line pos for HBLANK stop (write ecs)
vtotal		rs.w	1	; Highest number count, vert line (VARBEAMEN=1) (write ecs)
vsstop		rs.w	1	; Vert line pos for VSYNC stop (write ecs)
vbstrt		rs.w	1	; Vert line pos for VBLANK start (write ecs)
vbstop		rs.w	1	; Vert line pos for VBLANK stop (write ecs)
sprhstrt	rs.w	1	; UHRES sprite vertical start (write ecs)
sprhstop	rs.w	1	; UHRES sprite vertical stop (write ecs)
bplhstrt	rs.w	1	; UHRES bit plane vertical start (write ecs)
bplhstop	rs.w	1	; UHRES bit plane vertical stop (write ecs)
hhposw		rs.w	1	; DUAL mode hires H beam counter write (write ecs)
hhposr		rs.w	1	; DUAL mode hires H beam counter read (write ecs)
beamcon0	rs.w	1	; Video Beam Control 0 (write ecs) (write ecs)
hsstrt		rs.w	1	; Horiz sync start (VARHSY) (write ecs)
vsstrt		rs.w	1	; Vert sync start  (VARVSY) (write ecs)
hcenter		rs.w	1	; Horiz pos for Vsync on interlace (write ecs)
diwhigh		rs.w	1	; display window - upper bits for strt & stop (write ecs)
bplhmod		rs.w	1	; UHRES bit plane modulo (write ecs)
sprhpt		rs.w	0	; UHRES Sprite Pointer (write ecs)
sprhpth		rs.w	1
sprhptl		rs.w	1
bplhpt		rs.w	0	; VRam (UHRES) Bitplane Pointer (write ecs)
bplhpth		rs.w	1
bplhptl		rs.w	1
		rs.w	1	; unused
		rs.w	1	; unused
		rs.w	1	; unused
		rs.w	1	; unused
		rs.w	1	; unused
		rs.w	1	; unused
fmode		rs.w	1	; Fetch mode register (write aga)
noop		rs.w	1	; No operation (NULL)

* AudChannel
ac_ptr	    EQU   $00	; ptr to start of waveform data
ac_len	    EQU   $04	; length of waveform in words
ac_per	    EQU   $06	; sample period
ac_vol	    EQU   $08	; volume
ac_dat	    EQU   $0A	; sample pair
ac_SIZEOF   EQU   $10

* SpriteDef
sd_pos	    EQU   $00
sd_ctl	    EQU   $02
sd_dataa    EQU   $04
sd_dataB    EQU   $06
sd_SIZEOF   EQU   $08

***********************************************************
* CIA addresses *

CIAA		EQU	$BFE001	; CIAA base address
CIAB		EQU	$BFD000	; CIAB base address
PRA		EQU	$000	; Peripheral Data Register for port A
PRB		EQU	$100	; Peripheral Data Register for port B
DDRA		EQU	$200	; Data Direction Register A
DDRB		EQU	$300	; Data Direction Register B
TALO		EQU	$400	; Timer A Low Byte
TAHI		EQU	$500	; Timer A High Byte
TBLO		EQU	$600	; Timer B Low Byte
TBHI		EQU	$700	; Timer B High Byte
TODLO		EQU	$800	; TOD Counter Low Byte
TODMID		EQU	$900	; TOD Counter Mid Byte
TODHI		EQU	$A00	; TOD Counter High Byte
TODHR		EQU	$B00	; Unused
SDR		EQU	$C00	; Serial Data Register
ICR		EQU	$D00	; Interrupt Control Register
CRA		EQU	$E00	; Control Register A
CRB		EQU	$F00	; Control Register B

***********************************************************
* Define the following for your coding style:
;A5CUSTOM	SET	1	; if a5 = $DFF000
;A5CUSTOMPLUS2	SET	1	; if a5 = $DFF002
;A6CUSTOM	SET	1	; if a6 = $DFF000
A6CUSTOMPLUS2	SET	1	; if a6 = $DFF002
;USEOS		SET	1	; if you want to use graphics.library
				; WaitBlit()
 IFEQ		NOMACROS
   IFND		WaitVblank
WaitVblank	MACRO	\1
.\@:
   IFD		A5CUSTOM
		move.l	4(a5),d0
   ELSE
     IFD	A5CUSTOMPLUS2
		move.l	4-2(a5),d0
     ELSE
       IFD	A6CUSTOM
		move.l	4(a6),d0
       ELSE
         IFD	A6CUSTOMPLUS2
		move.l	4-2(a6),d0
         ELSE
		move.l	$DFF004,d0
         ENDC
       ENDC
     ENDC
   ENDC
		lsr.l	#8,d0
		andi.w	#$3FF,d0
		cmp.w	\1,d0
		bne.b	.\@
		ENDM
   ENDC

   IFND		WaitBlitter
WaitBlitter	MACRO
   IFD		USEOS
		CALLGRAF	WaitBlit
   ELSE
     IFD	A5CUSTOM
		tst.w	2(a5)
.\@:		btst.b	#6,2(a5)
		bne.b	.\@
     ELSE
       IFD	A5CUSTOMPLUS2
		tst.w	(a5)
.\@:		btst.b	#6,(a5)
		bne.b	.\@
       ELSE
         IFD	A6CUSTOM
		tst.w	2(a6)
.\@:		btst.b	#6,2(a6)
		bne.b	.\@
         ELSE
           IFD	A6CUSTOMPLUS2
		tst.w	(a6)
.\@:		btst.b	#6,(a6)
		bne.b	.\@
           ELSE
		tst.w	$DFF002
.\@:		btst.b	#6,$DFF002
		bne.b	.\@
	   ENDC
	 ENDC
       ENDC
     ENDC
   ENDC
		ENDM
  ENDC

 ENDC		; IFEQ	NOMACROS

***********************************************************
; These are the lf-codes for the blitter.  With these EQUates you can
; do stuff like this:
;	move.w	#(LF_A!LF_C),bltcon0(a5)
LF_A		SET	$F0
LF_B		SET	$CC
LF_C		SET	$AA

; These are the DMA channel masks.  If you wanted set a blit up that uses
; channels A, B, and D, then you would use this:
;	move.w	#(DEST!SCRB!SRCA),bltcon0(a5)
 IFND	HARDWARE_BLIT_I
DEST		SET	$100
SRCC		SET	$200
SRCB		SET	$400
SRCA		SET	$800
 ENDC

; These are the blitter mode flags.
 IFND	HARDWARE_BLIT_I
FILL_OR		SET	$8
FILL_XOR	SET	$10
FILL_CARRYIN	SET	$4
 ENDC
COPY		SET	$0

; These are other special blitter flags.
 IFND	HARDWARE_BLIT_I
BLITREVERSE	SET	$2
 ENDC
BLITDOWN	SET	$0
BLITMAXWIDTH	SET	$0
BLITMAXHEIGHT	SET	$0

; These are the shift value shifts.
 IFND	HARDWARE_BLIT_I
ASHIFTSHIFT	SET	12
BSHIFTSHIFT	SET	12
 ENDC

; This is a macro that will set up bltcon0 and bltcon1 for you.  You
; must pass it immed. values.  It's a handy place to use the above
; EQUates. :)
;
; Example 1:
;     Say you wanted the values for a blit from A to D with no shifts.
;     Call it like this:
;		BlitCon	LF_A,SRCA,COPY,BLITDOWN,0,0,blitcon0(a5)
;
; Example 2:
;     Now you want to set up for a fill from A to D with a no shifts,
;     but you want the value put in d0.  Call it like this:
;		BlitCon	LF_A,SRCA,FILL_XOR,BLITREVERSE,0,0,d0
;
; Example 3:
;     Now you want to do a cookie cut with an A shift of 4 and a
;     B shift of 2.  Call like this:
;		BlitCon	((LF_A&LF_B)!((~LF_A)&(LF_C))),SRCA!SRCB!SRCC,COPY,
;			BLITDOWN,4,2,blitcon0(a5)

 IFEQ	NOMACROS
BlitCon		MACRO	; \1 - word of lf values, \2 - DMA chanels,
			; \3 - blit mode, \4 - blit direction
			; \5 - a shift, \6 - b shift
			; \7 - destination
		move.l	#(((\1)!(\2)!(DEST)!((\5)<<ASHIFTSHIFT))<<16)!((\3)!(\4)!((\6)<<BSHIFTSHIFT)),\7
		ENDM

; This macro takes the height and width of you blit and puts it in the nice
; form the blitter wants. :)
;
; Example 1:
;     You're blitting an area 30 words wide and 5 rasters high and you want
;     the blit to start now.  Call like this:
;		BlitSize	5,30,bltsize(a5)
;
; Example 2:
;     You're blitting an area 27 words by 200 rasters, but you want the size
;     in d6.  Call like this:
;		BlitSize	200,27,d6
;
; Example 3:
;     Now say you want a max size blit.  Call like this:
;		BlitSize	BLITMAXHEIGHT,BLITMAXWIDTH,blitsize(a5)

BlitSize	MACRO	; \1 - height in rasters, \2 - width in words
			; \3 - destination
   IFEQ	((\2)&(~$3F))!((\1)&(~$3FF))	; is blit too big?
		move.w	#((\1)*64)+(\2),\3
   ELSE					; yup.
		FAIL			; Blit size is too big!
   ENDC
		ENDM

; This is a very special routine.  It MUST have immed. data as it's params
; and it will trash d0 or if \4 is specified, it will use that.

BlitSizeECS	MACRO	; \1 - height in rasters, \2 - width in words,
			; \3 - ptr to bltsizv
			; \4 - scratch register (d0 is default)
   IFEQ	NARG-3
		move.w	#\1,d0
		swap	d0
		move.w	#\2,d0
		move.l	d0,\3
   ELSE
		move.w	#\1,\4
		swap	\4
		move.w	#\2,\4
		move.l	\4,\3
   ENDC
		ENDM

 ENDC	;NOMACROS

   ENDC  ;HARDWARE_DEMO_I
