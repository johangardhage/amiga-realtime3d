	IFND	LIBRARIES_EXPANSION_LIB_I
LIBRARIES_EXPANSION_LIB_I	SET	1
**
**	$VER: icon_lib.i 40.1 (24.2.97)
**	Includes Release 40.13+1
**
**	Library interface offsets for Expansion library
**
**	Created by Harry Sintonen. Public Domain.
**

    IFND    EXEC_FUNCDEF_I
    include 'exec/funcdef.i'
    ENDC

	FDEFINIT
;--- functions in V33 or higher (distributed as Release 1.2) ---
	FUNCDEF	AddConfigDev
;--- functions in V36 or higher (distributed as Release 2.0) ---
	FUNCDEF	AddBootNode
;--- functions in V33 or higher (distributed as Release 1.2) ---
	FUNCDEF	AllocBoardMem
	FUNCDEF	AllocConfigDev
	FUNCDEF	AllocExpansionMem
	FUNCDEF	ConfigBoard
	FUNCDEF	ConfigChain
	FUNCDEF	FindConfigDev
	FUNCDEF	FreeBoardMem
	FUNCDEF	FreeConfigDev
	FUNCDEF	FreeExpansionMem
	FUNCDEF	ReadExpansionByte
	FUNCDEF	ReadExpansionRom
	FUNCDEF	RemConfigDev
	FUNCDEF	WriteExpansionByte
	FUNCDEF	ObtainConfigBinding
	FUNCDEF	ReleaseConfigBinding
	FUNCDEF	SetCurrentBinding
	FUNCDEF	GetCurrentBinding
	FUNCDEF	MakeDosNode
	FUNCDEF	AddDosNode
;--- functions in V36 or higher (distributed as Release 2.0) ---
	FUNCDEF	expansionPrivate1
	FUNCDEF	expansionPrivate2

	ENDC	; LIBRARIES_EXPANSION_LIB_I
