	IFND LIBRARIES_COLORWHEEL_LIB_I
LIBRARIES_COLORWHEEL_LIB_I	SET	1
**
**	$VER: colorwheel_lib.i 39.1 (11.1.98)
**	Includes Release 40.13+1
**
**	Library interface offsets for colorwheel gadget
**
**	Created by Harry Sintonen. Public Domain.
**

    IFND    EXEC_FUNCDEF_I
    include 'exec/funcdef.i'
    ENDC

	FDEFINIT
;--- functions in V39 or higher (Release 3) ---
;
; Public entries
;
	FUNCDEF	ConvertHSBToRGB
	FUNCDEF	ConvertRGBToHSB
	ENDC	; LIBRARIES_COLORWHEEL_LIB_I
