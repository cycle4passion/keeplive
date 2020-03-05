
;*******************************************************************************
;Removables: ; Autorun EXE on CDs, autokill apps on ejecy
; Written Scott Rhamy 3/15/17
; References:

;*******************************************************************************

; eject fires autorun before ejectkill - check again, I might have fixed??
; autorun failing, unsure why ? b/c tooltip fires

WM_DEVICECHANGE( wParam, lParam ) { ; https://autohotkey.com/board/topic/18652-help-required-on-bitwise-operation/
	Global Drv
	Static DBT_DEVICEARRIVAL := 0x8000
	Static DBT_DEVICEREMOVALCOMPLETE := 0x8004
	Static DBT_DEVTYP_VOLUME := 0x2
	dbch_devicetype := NumGet(lParam+4) 
	
	If ( (wParam = DBT_DEVICEARRIVAL OR wParam = DBT_DEVICEREMOVALCOMPLETE ) AND dbch_devicetype = DBT_DEVTYP_VOLUME ) {
	  dbcv_unitmask := NumGet(lParam+12 ) 
	  Loop 32
		If ( ( dbcv_unitmask >> (A_Index-1) & 1) = 1 )
		 {
		   Drv := Chr(64+A_Index)
		   Break
		 }     
		 if (wParam = DBT_DEVICEARRIVAL) {
			;Send,{Shift down} ; holding shift prevents autorun
			; https://autohotkey.com/board/topic/17587-is-there-a-way-to-stop-auto-runauto-play-from-auto-running/#12171
			;SetTimer,killshift,-10000 ; release shift in 10 secs prevents native autorun
			DriveGet, type, type, %Drv%:
			if (type = "CDROM")
				RunCDExe(Drv)
		}
		 if (wParam = DBT_DEVICEREMOVALCOMPLETE) {
			Sleep, 10000
			CloseProcesses(Drv)
		}
	} 
	Return true
}

;killshift:
;Send,{Shift up}
;Return

RunCDExe(newdrive :="") {
;newdrive := "D"
	Loop Files, %newdrive%:\*.exe
		exe =  %A_LoopFileFullPath%
	If A_Index > 1 
	{
		Traytip,No Auto-Run Performed, More than 1 executable found on Drive %newdrive%, 3
		run, search-ms:query=type:.exe&crumb=location:%newdrive%:\,Nonrecursive& ; need nonrecusive working
	} else {
		Traytip,, Auto-Loading %exe%, 2
		run, %exe%, , Max UseErrorLevel
		if ErrorLevel = ERROR
			TrayTip Error#%ErrorLevel% while Running %exe%
	}
return
}

CloseProcesses(olddrive := "") {
	Traytip,,Killing Executables from CD Drive %olddrive%:\, 3
	for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
	{
	   path  := % process.CommandLine
	   name := % process.Name
	   StringGetPos, p, path, %olddrive%:\
		If ((p=0 or p=1) and (A_ScriptFullPath != path and A_ScriptFullPath !="path"))  ;handles quoted/unquoted, and prevents closing self
			Process, Close, % Process.Name
		}
return
} ; End Removables -------------------------------------------------------------
