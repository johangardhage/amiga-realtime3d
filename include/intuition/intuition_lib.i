	IFND	INTUITION_INTUITION_LIB_I
INTUITION_INTUITION_LIB_I	SET	1
**
**	$VER: intuition_lib.i 40.1 (24.7.96)
**	Includes Release 40.13+1
**
**	Library interface offsets for Intuition library
**
**	Created by Harry Sintonen. Public Domain.
**

    IFND    EXEC_FUNCDEF_I
    include 'exec/funcdef.i'
    ENDC

	FDEFINIT
	FUNCDEF	OpenIntuition
	FUNCDEF	Intuition
	FUNCDEF	AddGadget
	FUNCDEF	ClearDMRequest
	FUNCDEF	ClearMenuStrip
	FUNCDEF	ClearPointer
	FUNCDEF	CloseScreen
	FUNCDEF	CloseWindow
	FUNCDEF	CloseWorkBench
	FUNCDEF	CurrentTime
	FUNCDEF	DisplayAlert
	FUNCDEF	DisplayBeep
	FUNCDEF	DoubleClick
	FUNCDEF	DrawBorder
	FUNCDEF	DrawImage
	FUNCDEF	EndRequest
	FUNCDEF	GetDefPrefs
	FUNCDEF	GetPrefs
	FUNCDEF	InitRequester
	FUNCDEF	ItemAddress
	FUNCDEF	ModifyIDCMP
	FUNCDEF	ModifyProp
	FUNCDEF	MoveScreen
	FUNCDEF	MoveWindow
	FUNCDEF	OffGadget
	FUNCDEF	OffMenu
	FUNCDEF	OnGadget
	FUNCDEF	OnMenu
	FUNCDEF	OpenScreen
	FUNCDEF	OpenWindow
	FUNCDEF	OpenWorkBench
	FUNCDEF	PrintIText
	FUNCDEF	RefreshGadgets
	FUNCDEF	RemoveGadget
	FUNCDEF	ReportMouse
	FUNCDEF	Request
	FUNCDEF	ScreenToBack
	FUNCDEF	ScreenToFront
	FUNCDEF	SetDMRequest
	FUNCDEF	SetMenuStrip
	FUNCDEF	SetPointer
	FUNCDEF	SetWindowTitles
	FUNCDEF	ShowTitle
	FUNCDEF	SizeWindow
	FUNCDEF	ViewAddress
	FUNCDEF	ViewPortAddress
	FUNCDEF	WindowToBack
	FUNCDEF	WindowToFront
	FUNCDEF	WindowLimits
	FUNCDEF	SetPrefs
	FUNCDEF	IntuiTextLength
	FUNCDEF	WBenchToBack
	FUNCDEF	WBenchToFront
	FUNCDEF	AutoRequest
	FUNCDEF	BeginRefresh
	FUNCDEF	BuildSysRequest
	FUNCDEF	EndRefresh
	FUNCDEF	FreeSysRequest
	FUNCDEF	MakeScreen
	FUNCDEF	RemakeDisplay
	FUNCDEF	RethinkDisplay
	FUNCDEF	AllocRemember
	FUNCDEF	AlohaWorkbench
	FUNCDEF	FreeRemember
	FUNCDEF	LockIBase
	FUNCDEF	UnlockIBase
	FUNCDEF	GetScreenData
	FUNCDEF	RefreshGList
	FUNCDEF	AddGList
	FUNCDEF	RemoveGList
	FUNCDEF	ActivateWindow
	FUNCDEF	RefreshWindowFrame
	FUNCDEF	ActivateGadget
	FUNCDEF	NewModifyProp
;--- functions in V36 or higher (Release 2.0) ---
	FUNCDEF	QueryOverscan
	FUNCDEF	MoveWindowInFrontOf
	FUNCDEF	ChangeWindowBox
	FUNCDEF	SetEditHook
	FUNCDEF	SetMouseQueue
	FUNCDEF	ZipWindow
;--- public screens ---
	FUNCDEF	LockPubScreen
	FUNCDEF	UnlockPubScreen
	FUNCDEF	LockPubScreenList
	FUNCDEF	UnlockPubScreenList
	FUNCDEF	NextPubScreen
	FUNCDEF	SetDefaultPubScreen
	FUNCDEF	SetPubScreenModes
	FUNCDEF	PubScreenStatus
;
	FUNCDEF	ObtainGIRPort
	FUNCDEF	ReleaseGIRPort
	FUNCDEF	GadgetMouse
	FUNCDEF	intuitionPrivate1
	FUNCDEF	GetDefaultPubScreen
	FUNCDEF	EasyRequestArgs
	FUNCDEF	BuildEasyRequestArgs
	FUNCDEF	SysReqHandler
	FUNCDEF	OpenWindowTagList
	FUNCDEF	OpenScreenTagList
;	new Image functions
	FUNCDEF	DrawImageState
	FUNCDEF	PointInImage
	FUNCDEF	EraseImage
;
	FUNCDEF	NewObjectA
;
	FUNCDEF	DisposeObject
	FUNCDEF	SetAttrsA
;
	FUNCDEF	GetAttr
;
;	special set attribute call for gadgets
	FUNCDEF	SetGadgetAttrsA
;
;	for class implementors only
	FUNCDEF	NextObject
	FUNCDEF	intuitionPrivate2
	FUNCDEF	MakeClass
	FUNCDEF	AddClass
;
;
	FUNCDEF	GetScreenDrawInfo
	FUNCDEF	FreeScreenDrawInfo
;
	FUNCDEF	ResetMenuStrip
	FUNCDEF	RemoveClass
	FUNCDEF	FreeClass
	FUNCDEF	intuitionPrivate3
	FUNCDEF	intuitionPrivate4
;--- (6 function slots reserved here) ---
;--- functions in V39 or higher (Release 3) ---
	FDEFINIT -$300
	FUNCDEF	AllocScreenBuffer
	FUNCDEF	FreeScreenBuffer
	FUNCDEF	ChangeScreenBuffer
	FUNCDEF	ScreenDepth
	FUNCDEF	ScreenPosition
	FUNCDEF	ScrollWindowRaster
	FUNCDEF	LendMenus
	FUNCDEF	DoGadgetMethodA
	FUNCDEF	SetWindowPointerA
	FUNCDEF	TimedDisplayAlert
	FUNCDEF	HelpControl

	ENDC	; INTUITION_INTUITION_LIB_I
