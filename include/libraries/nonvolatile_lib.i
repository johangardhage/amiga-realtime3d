	IFND LIBRARIES_NONVOLATILE_LIB_I
LIBRARIES_NONVOLATILE_LIB_I	SET	1
**
**	$VER: nonvolatile_lib.i 40.1 (11.1.98)
**	Includes Release 40.13+1
**
**	Library interface offsets for nonvolatile library
**
**	Created by Harry Sintonen. Public Domain.
**

    IFND    EXEC_FUNCDEF_I
    include 'exec/funcdef.i'
    ENDC

	FDEFINIT
;--- functions in V40 or higher (Release 3.1) ---
	FUNCDEF	GetCopyNV
	FUNCDEF	FreeNVData
	FUNCDEF	StoreNV
	FUNCDEF	DeleteNV
	FUNCDEF	GetNVInfo
	FUNCDEF	GetNVList
	FUNCDEF	SetNVProtection
	ENDC	; LIBRARIES_NONVOLATILE_LIB_I
