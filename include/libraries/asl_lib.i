	IFND	LIBRARIES_ASL_LIB_I
LIBRARIES_ASL_LIB_I	SET	1
**
**	$VER: asl_lib.i 38.3 (25.11.97)
**	Includes Release 40.13+1
**
**	Library interface offsets for asl library
**
**	Created by Harry Sintonen. Public Domain.
**

    IFND    EXEC_FUNCDEF_I
    include 'exec/funcdef.i'
    ENDC

	FDEFINIT
;--- functions in V38 or higher (distributed as Release 2.1) ---
; OBSOLETE -- Please use the generic requester functions instead
	FUNCDEF	AllocFileRequest
	FUNCDEF	FreeFileRequest
	FUNCDEF	RequestFile
	FUNCDEF	AllocAslRequest
	FDEFINIT -$30
	FUNCDEF	AllocAslRequestTags
	FUNCDEF	FreeAslRequest
	FUNCDEF	AslRequest
	FDEFINIT -$3c
	FUNCDEF	AslRequestTags
	ENDC	; LIBRARIES_ASL_LIB_I
