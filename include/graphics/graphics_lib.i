	IFND	GRAPHICS_GRAPHICS_LIB_I
GRAPHICS_GRAPHICS_LIB_I	SET	1
**
**	$VER: graphics_lib.i 40.1 (8.12.96)
**	Includes Release 40.13+2
**
**	Library interface offsets for Graphics library
**
**	Created by Harry Sintonen. Public Domain.
**
**	Fixed SetRPAttrA & GetRPAttrA.
**

    IFND    EXEC_FUNCDEF_I
    include 'exec/funcdef.i'
    ENDC

	FDEFINIT
	FUNCDEF	BltBitMap
	FUNCDEF	BltTemplate
	FUNCDEF	ClearEOL
	FUNCDEF	ClearScreen
	FUNCDEF	TextLength
	FUNCDEF	Text
	FUNCDEF	SetFont
	FUNCDEF	OpenFont
	FUNCDEF	CloseFont
	FUNCDEF	AskSoftStyle
	FUNCDEF	SetSoftStyle
	FUNCDEF	AddBob
	FUNCDEF	AddVSprite
	FUNCDEF	DoCollision
	FUNCDEF	DrawGList
	FUNCDEF	InitGels
	FUNCDEF	InitMasks
	FUNCDEF	RemIBob
	FUNCDEF	RemVSprite
	FUNCDEF	SetCollision
	FUNCDEF	SortGList
	FUNCDEF	AddAnimOb
	FUNCDEF	Animate
	FUNCDEF	GetGBuffers
	FUNCDEF	InitGMasks
	FUNCDEF	DrawEllipse
	FUNCDEF	AreaEllipse
	FUNCDEF	LoadRGB4
	FUNCDEF	InitRastPort
	FUNCDEF	InitVPort
	FUNCDEF	MrgCop
	FUNCDEF	MakeVPort
	FUNCDEF	LoadView
	FUNCDEF	WaitBlit
	FUNCDEF	SetRast
	FUNCDEF	Move
	FUNCDEF	Draw
	FUNCDEF	AreaMove
	FUNCDEF	AreaDraw
	FUNCDEF	AreaEnd
	FUNCDEF	WaitTOF
	FUNCDEF	QBlit
	FUNCDEF	InitArea
	FUNCDEF	SetRGB4
	FUNCDEF	QBSBlit
	FUNCDEF	BltClear
	FUNCDEF	RectFill
	FUNCDEF	BltPattern
	FUNCDEF	ReadPixel
	FUNCDEF	WritePixel
	FUNCDEF	Flood
	FUNCDEF	PolyDraw
	FUNCDEF	SetAPen
	FUNCDEF	SetBPen
	FUNCDEF	SetDrMd
	FUNCDEF	InitView
	FUNCDEF	CBump
	FUNCDEF	CMove
	FUNCDEF	CWait
	FUNCDEF	VBeamPos
	FUNCDEF	InitBitMap
	FUNCDEF	ScrollRaster
	FUNCDEF	WaitBOVP
	FUNCDEF	GetSprite
	FUNCDEF	FreeSprite
	FUNCDEF	ChangeSprite
	FUNCDEF	MoveSprite
	FUNCDEF	LockLayerRom
	FUNCDEF	UnlockLayerRom
	FUNCDEF	SyncSBitMap
	FUNCDEF	CopySBitMap
	FUNCDEF	OwnBlitter
	FUNCDEF	DisownBlitter
	FUNCDEF	InitTmpRas
	FUNCDEF	AskFont
	FUNCDEF	AddFont
	FUNCDEF	RemFont
	FUNCDEF	AllocRaster
	FUNCDEF	FreeRaster
	FUNCDEF	AndRectRegion
	FUNCDEF	OrRectRegion
	FUNCDEF	NewRegion
	FUNCDEF	ClearRectRegion
	FUNCDEF	ClearRegion
	FUNCDEF	DisposeRegion
	FUNCDEF	FreeVPortCopLists
	FUNCDEF	FreeCopList
	FUNCDEF	ClipBlit
	FUNCDEF	XorRectRegion
	FUNCDEF	FreeCprList
	FUNCDEF	GetColorMap
	FUNCDEF	FreeColorMap
	FUNCDEF	GetRGB4
	FUNCDEF	ScrollVPort
	FUNCDEF	UCopperListInit
	FUNCDEF	FreeGBuffers
	FUNCDEF	BltBitMapRastPort
	FUNCDEF	OrRegionRegion
	FUNCDEF	XorRegionRegion
	FUNCDEF	AndRegionRegion
	FUNCDEF	SetRGB4CM
	FUNCDEF	BltMaskBitMapRastPort
	FUNCDEF	graphicsPrivate1
	FUNCDEF	graphicsPrivate2
	FUNCDEF	AttemptLockLayerRom
	FUNCDEF	GfxNew
	FUNCDEF	GfxFree
	FUNCDEF	GfxAssociate
	FUNCDEF	BitMapScale
	FUNCDEF	ScalerDiv
	FUNCDEF	TextExtent
	FUNCDEF	TextFit
	FUNCDEF	GfxLookUp
	FUNCDEF	VideoControl
	FUNCDEF	OpenMonitor
	FUNCDEF	CloseMonitor
	FUNCDEF	FindDisplayInfo
	FUNCDEF	NextDisplayInfo
	FUNCDEF	graphicsPrivate3
	FUNCDEF	graphicsPrivate4
	FUNCDEF	graphicsPrivate5
	FUNCDEF	GetDisplayInfoData
	FUNCDEF	FontExtent
	FUNCDEF	ReadPixelLine8
	FUNCDEF	WritePixelLine8
	FUNCDEF	ReadPixelArray8
	FUNCDEF	WritePixelArray8
	FUNCDEF	GetVPModeID
	FUNCDEF	ModeNotAvailable
	FUNCDEF	WeighTAMatch
	FUNCDEF	EraseRect
	FUNCDEF	ExtendFont
	FUNCDEF	StripFont
;--- functions in V39 or higher (Release 3) ---
	FUNCDEF	CalcIVG
	FUNCDEF	AttachPalExtra
	FUNCDEF	ObtainBestPenA
	FUNCDEF	graphicsPrivate6
	FUNCDEF	SetRGB32
	FUNCDEF	GetAPen
	FUNCDEF	GetBPen
	FUNCDEF	GetDrMd
	FUNCDEF	GetOutlinePen
	FUNCDEF	LoadRGB32
	FUNCDEF	SetChipRev
	FUNCDEF	SetABPenDrMd
	FUNCDEF	GetRGB32
	FUNCDEF	graphicsPrivate7
	FUNCDEF	graphicsPrivate8
	FUNCDEF	AllocBitMap
	FUNCDEF	FreeBitMap
	FUNCDEF	GetExtSpriteA
	FUNCDEF	CoerceMode
	FUNCDEF	ChangeVPBitMap
	FUNCDEF	ReleasePen
	FUNCDEF	ObtainPen
	FUNCDEF	GetBitMapAttr
	FUNCDEF	AllocDBufInfo
	FUNCDEF	FreeDBufInfo
	FUNCDEF	SetOutlinePen
	FUNCDEF	SetWriteMask
	FUNCDEF	SetMaxPen
	FUNCDEF	SetRGB32CM
	FUNCDEF	ScrollRasterBF
	FUNCDEF	FindColor
	FUNCDEF	graphicsPrivate9
	FUNCDEF	AllocSpriteDataA
	FUNCDEF	ChangeExtSpriteA
	FUNCDEF	FreeSpriteData
	FUNCDEF	SetRPAttrA
	FUNCDEF	GetRPAttrA
	FUNCDEF	BestModeIDA
;--- functions in V40 or higher (Release 3.1) ---
	FUNCDEF	WriteChunkyPixels

	ENDC	; GRAPHICS_GRAPHICS_LIB_I
