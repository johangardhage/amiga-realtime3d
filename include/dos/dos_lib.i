	IFND	DOS_DOS_LIB_I
DOS_DOS_LIB_I	SET	1
**
**	$VER: dos_lib.i 39.1 (15.12.96)
**	Includes Release 40.13+1
**
**	Library interface offsets for DOS library
**
**	(C) Copyright 1985-1993 Commodore-Amiga, Inc.
**	    All Rights Reserved
**
**	New version by Harry Sintonen. Public Domain.
**	V39 functions were missing.
**

reserve EQU	4
vsize	EQU	6
count	SET	-vsize*(reserve+1)
LIBENT	MACRO
_LVO\1	EQU	count
count	SET	count-vsize
	ENDM
CLONENT	MACRO
_LVO\1	EQU	_LVO\2
	ENDM

*
*
*
   LIBENT   Open
   LIBENT   Close
   LIBENT   Read
   LIBENT   Write
   LIBENT   Input
   LIBENT   Output
   LIBENT   Seek
   LIBENT   DeleteFile
   LIBENT   Rename
   LIBENT   Lock
   LIBENT   UnLock
   LIBENT   DupLock
   LIBENT   Examine
   LIBENT   ExNext
   LIBENT   Info
   LIBENT   CreateDir
   LIBENT   CurrentDir
   LIBENT   IoErr
   LIBENT   CreateProc
   LIBENT   Exit
   LIBENT   LoadSeg
   LIBENT   UnLoadSeg
   LIBENT   dosPrivate1
   CLONENT  GetPacket,dosPrivate1
   LIBENT   dosPrivate2
   CLONENT  QueuePacket,dosPrivate2
   LIBENT   DeviceProc
   LIBENT   SetComment
   LIBENT   SetProtection
   LIBENT   DateStamp
   LIBENT   Delay
   LIBENT   WaitForChar
   LIBENT   ParentDir
   LIBENT   IsInteractive
   LIBENT   Execute

   ; V36+ functions:

   LIBENT   AllocDosObject
   CLONENT  AllocDosObjectTagList,AllocDosObject
   LIBENT   FreeDosObject
   LIBENT   DoPkt
   LIBENT   SendPkt
   LIBENT   WaitPkt
   LIBENT   ReplyPkt
   LIBENT   AbortPkt
   LIBENT   LockRecord
   LIBENT   LockRecords
   LIBENT   UnLockRecord
   LIBENT   UnLockRecords
   LIBENT   SelectInput
   LIBENT   SelectOutput
   LIBENT   FGetC
   LIBENT   FPutC
   LIBENT   UnGetC
   LIBENT   FRead
   LIBENT   FWrite
   LIBENT   FGets
   LIBENT   FPuts
   LIBENT   VFWritef
   LIBENT   VFPrintf
   LIBENT   Flush
   LIBENT   SetVBuf
   LIBENT   DupLockFromFH
   LIBENT   OpenFromLock
   LIBENT   ParentOfFH
   LIBENT   ExamineFH
   LIBENT   SetFileDate
   LIBENT   NameFromLock
   LIBENT   NameFromFH
   LIBENT   SplitName
   LIBENT   SameLock
   LIBENT   SetMode
   LIBENT   ExAll
   LIBENT   ReadLink
   LIBENT   MakeLink
   LIBENT   ChangeMode
   LIBENT   SetFileSize
   LIBENT   SetIoErr
   LIBENT   Fault
   LIBENT   PrintFault
   LIBENT   ErrorReport
   LIBENT   dosReserved01
   LIBENT   Cli
   LIBENT   CreateNewProc
   CLONENT  CreateNewProcTagList,CreateNewProc
   LIBENT   RunCommand
   LIBENT   GetConsoleTask
   LIBENT   SetConsoleTask
   LIBENT   GetFileSysTask
   LIBENT   SetFileSysTask
   LIBENT   GetArgStr
   LIBENT   SetArgStr
   LIBENT   FindCliProc
   LIBENT   MaxCli
   LIBENT   SetCurrentDirName
   LIBENT   GetCurrentDirName
   LIBENT   SetProgramName
   LIBENT   GetProgramName
   LIBENT   SetPrompt
   LIBENT   GetPrompt
   LIBENT   SetProgramDir
   LIBENT   GetProgramDir
   LIBENT   System
   CLONENT  SystemTagList,System
   LIBENT   AssignLock
   LIBENT   AssignLate
   LIBENT   AssignPath
   LIBENT   AssignAdd
   LIBENT   RemAssignList
   LIBENT   GetDeviceProc
   LIBENT   FreeDeviceProc
   LIBENT   LockDosList
   LIBENT   UnLockDosList
   LIBENT   AttemptLockDosList
   LIBENT   RemDosEntry
   LIBENT   AddDosEntry
   LIBENT   FindDosEntry
   LIBENT   NextDosEntry
   LIBENT   MakeDosEntry
   LIBENT   FreeDosEntry
   LIBENT   IsFileSystem
   LIBENT   Format
   LIBENT   Relabel
   LIBENT   Inhibit
   LIBENT   AddBuffers
   LIBENT   CompareDates
   LIBENT   DateToStr
   LIBENT   StrToDate
   LIBENT   InternalLoadSeg
   LIBENT   InternalUnLoadSeg
   LIBENT   NewLoadSeg
   CLONENT  NewLoadSegTagList,NewLoadSeg
   LIBENT   AddSegment
   LIBENT   FindSegment
   LIBENT   RemSegment
   LIBENT   CheckSignal
   LIBENT   ReadArgs
   LIBENT   FindArg
   LIBENT   ReadItem
   LIBENT   StrToLong
   LIBENT   MatchFirst
   LIBENT   MatchNext
   LIBENT   MatchEnd
   LIBENT   ParsePattern
   LIBENT   MatchPattern
   LIBENT   dosPrivate3
   LIBENT   FreeArgs
   LIBENT   dosReserved02
   LIBENT   FilePart
   LIBENT   PathPart
   LIBENT   AddPart
   LIBENT   StartNotify
   LIBENT   EndNotify
   LIBENT   SetVar
   LIBENT   GetVar
   LIBENT   DeleteVar
   LIBENT   FindVar
   LIBENT   dosPrivate4
   LIBENT   CliInitNewcli
   LIBENT   CliInitRun
   LIBENT   WriteChars
   LIBENT   PutStr
   LIBENT   VPrintf
   LIBENT   dosReserved03
   LIBENT   ParsePatternNoCase
   LIBENT   MatchPatternNoCase
   LIBENT   dosPrivate5
   LIBENT   SameDevice

   ; V39+ functions:

   LIBENT   ExAllEnd
   LIBENT   SetOwner
   LIBENT   dosReserved04
   LIBENT   dosReserved05
   LIBENT   dosReserved06
   LIBENT   dosReserved07
   LIBENT   dosReserved08
   LIBENT   dosReserved09
   LIBENT   dosReserved0A
   LIBENT   dosReserved0B

	ENDC	; DOS_DOS_LIB_I
