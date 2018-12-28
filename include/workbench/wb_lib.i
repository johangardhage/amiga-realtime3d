	IFND	WORKBENCH_WB_LIB_I
WORKBENCH_WB_LIB_I	SET	1
**
**	$VER: wb_lib.i 40.1 (14.12.96)
**	Includes Release 40.13+1
**
**	Library interface offsets for Workbench library
**
**	Created by Harry Sintonen. Public Domain.
**

    IFND    EXEC_FUNCDEF_I
    include 'exec/funcdef.i'
    ENDC

	FDEFINIT
	FUNCDEF	wbPrivate1
	FUNCDEF	wbPrivate2
	FUNCDEF	wbPrivate3
	FUNCDEF	AddAppWindowA
	FUNCDEF	RemoveAppWindow
	FUNCDEF	AddAppIconA
	FUNCDEF	RemoveAppIcon
	FUNCDEF	AddAppMenuItemA
	FUNCDEF	RemoveAppMenuItem
;--- functions in V39 or higher (Release 3) ---
	FUNCDEF	wbPrivate4
	FUNCDEF	WBInfo
;--- (5 function slots reserved here) ---
	FUNCDEF	wbReserved1
	FUNCDEF	wbReserved2
	FUNCDEF	wbReserved3
	FUNCDEF	wbReserved4
	FUNCDEF	wbReserved5

	ENDC	; WORKBENCH_WB_LIB_I
