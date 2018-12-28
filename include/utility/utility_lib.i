	IFND	UTILITY_UTILITY_LIB_I
UTILITY_UTILITY_LIB_I	SET	1
**
**	$VER: utility_lib.i 39.1 (14.8.96)
**	Includes Release 40.13+1
**
**	Library interface offsets for Utility library
**
**	Created by Harry Sintonen. Public Domain.
**

   FDEFINIT
   FUNCDEF  FindTagItem 
   FUNCDEF  GetTagData 
   FUNCDEF  PackBoolTags 
   FUNCDEF  NextTagItem 
   FUNCDEF  FilterTagChanges 
   FUNCDEF  MapTags 
   FUNCDEF  AllocateTagItems 
   FUNCDEF  CloneTagItems 
   FUNCDEF  FreeTagItems 
   FUNCDEF  RefreshTagItemClones 
   FUNCDEF  TagInArray 
   FUNCDEF  FilterTagItems 
   FUNCDEF  CallHookPkt 
   FUNCDEF  __utilspace1 ;--- (1 function slot reserved here) ---
   FUNCDEF  __utilspace2 ;--- (1 function slot reserved here) ---
   FUNCDEF  Amiga2Date 
   FUNCDEF  Date2Amiga 
   FUNCDEF  CheckDate 
   FUNCDEF  SMult32 
   FUNCDEF  UMult32 
   FUNCDEF  SDivMod32 
   FUNCDEF  UDivMod32 
   FUNCDEF  Stricmp 
   FUNCDEF  Strnicmp 
   FUNCDEF  ToUpper 
   FUNCDEF  ToLower 
   FUNCDEF  ApplyTagChanges 
   FUNCDEF  __utilspace3 ;--- (1 function slot reserved here) ---
   FUNCDEF  SMult64 
   FUNCDEF  UMult64 
   FUNCDEF  PackStructureTags 
   FUNCDEF  UnpackStructureTags 
   FUNCDEF  AddNamedObject
   FUNCDEF  AllocNamedObjectA
   FUNCDEF  AttemptRemNamedObject
   FUNCDEF  FindNamedObject
   FUNCDEF  FreeNamedObject
   FUNCDEF  NamedObjectName
   FUNCDEF  ReleaseNamedObject
   FUNCDEF  RemNamedObject
   FUNCDEF  GetUniqueID
   FUNCDEF  __utilspace4 ;--- (1 function slot reserved here) ---
   FUNCDEF  __utilspace5 ;--- (1 function slot reserved here) ---
   FUNCDEF  __utilspace6 ;--- (1 function slot reserved here) ---
   FUNCDEF  __utilspace7 ;--- (1 function slot reserved here) ---

	ENDC	; UTILITY_UTILITY_LIB_I
