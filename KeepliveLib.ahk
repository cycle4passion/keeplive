; KeepLive Library

COMDOM(pwb, pElem, pAction :="", getby :="id") { ; 4/1/20  ----------------------------------------
try {
	 StringLower, pAction, pAction
	 if (getby = "name") ; same as getElementsByName, COMDOM(wb, "tag[0]","username","focus")
        target := pWb.document.getElementsByName(pElem)
	else ; assume getby ID
        target := pWb.document.getElementByID(pElem)
	if not target
		return
	if target.disabled := true
		target.disabled := false  ; Force through disabled controls
    ; ACTION =======================================================
    if (pAction = "exist") {
      return target 
	} else if (pAction = "value") {
		return target.value
	} else if (pAction="click") {
        target.Click()
        IEWaitReady(pwb)
    } else if (pAction = "focus") {
		target.Focus()
	} else if (pAction = "submit") {
          target.Submit()
          IEWaitReady(pWb)
	} else if (pAction == "check" or action == "uncheck") {
        if (target.type = "checkbox")
          target.checked := (pAction=="check") ? true : false
	} else ; simply set value
        target.value := pAction
	return target
}
} ; End COMDOM =======================================================

Go(Title,URL,Text := "") {
	if WinExist(Title,Text) && Title {
		WinActivate, %Title%, %Text%
	} else {
		wb := ComObjCreate("InternetExplorer.Application")
		wb.Visible := true
		wb.Navigate(URL)
		IEWaitReady(wb)
	}
	if (Title == pktitle) { ; special handle Hcare maximize to prevent fullscreening
		SysGet, Mon, MonitorWorkArea
		WinMove, %hcaretitle%, ,MonLeft, MonTop, MonRight, MonBottom 
	} else {
		gosub, POLLING ; handles Ie popups
		WinMaximize, %Title%
		PostMessage, 0x112, 0xF030,,, %Title%, 
	}
return wb
}

Go2(texts, titles := "") {
	If titles {
		SetTitleMatchMode, slow
		Loop { ; Loop various screens for login for the one closest to action
			Etitle := Escape(titles[A_Index])
			EtitleText := Escape(titleTexts[A_Index])
			found := WinExist(Etitle, EtitleText)
		} Until (found || A_Index == titles.Length())
	SetTitleMatchMode, fast
	}
	if not found {
		wb := ComObjCreate("InternetExplorer.Application")
		wb.Navigate(texts[texts.Length()])
		IEWaitReady(wb)
		wb.Visible := true
	} else {
		WinActivate, ahk_id %found%
		WinGetTitle, foundtitle, ahk_id %found%
	}
	gosub, POLLING ; handles Ie popups
	if (InStr(foundtitle, "Capital 715")) { ; special handle Hcare maximize to prevent fullscreening
		SysGet, Mon, MonitorWorkArea
		WinMove, A, ,MonLeft, MonTop, MonRight, MonBottom 
	} else { ; forceful maximize
		PostMessage, 0x112, 0xF030,,, ahk_id %found%
	}
return wb
}

IEWaitReady(wb, timeout:=10, extrawait :=0) {
	try {
		if (timeout)
			SetTimer, IEWaitTimeout, -%timeout%
		Loop
			Sleep, 50
		Until  (wb.readyState=4 && wb.document.readyState="complete" && !wb.busy)
		SetTimer, IEWaitTimeout, off
		if (extrawait)
			Sleep, % extrawait * 1000 
	}
return true

IEWaitTimeout:
SetTimer, IEWaitTimeout, off
return false
}

WinGetActiveTitle(Title := "") {
	if not Title
		WinGetActiveTitle, Title
	StringReplace, Title, Title,  %A_SPACE%-%A_SPACE%\\Remote, , All
	return Title
}

Escape(Text, includeOR := false) {
    Text := RegExReplace(Text, "\x22", "\x22")	 					; Convert " \x22 
    Text := RegExReplace(Text, "([$?+*(){}^\\\[\].])", "\$1") 	; add needed escape backslash
	if includeOR
		Text := RegExReplace(text, "[|]", "\$1") 						; optional escape |
	Text := RegExReplace(Text, "\x27", "\x27")						; Convert ' to \x27
    Text := RegExReplace(Text, "`a)\r?\n", "\n")						; all linefeed variants to \n
return text
}

ScrapeBanner(title, x1, y1, x2, y2, dryrun := false, unselect :=true) { ; scrapes multiple banners
;-------------------------------------------------------------------------------------------------
  MouseGetPos, cursorx, cursory
  priorclip := clipboard
  Winactivate, %title%
	if (dryrun)
		{
			MouseMove, %x1%, %y1%
			ToolTip, from (x:%x1% y:%y1%) to (x:%x2% y:%y2%)
			Sleep, 1000
			MouseClickDrag, Left, %x1%,%y1%,%x2%,%y2%, 0
			ToolTip, from (x:%x1% y:%y1%) to (x:%x2% y:%y2%)
			Sleep, 1000
			ToolTip
			return
		}
  MouseClickDrag, Left, %x1%,%y1%,%x2%,%y2%, 0
  clipboard =
  Send, ^c
  if unselect
	MouseClick, Left, % x2 + 1, %y2% ; clears selection
  MouseMove, %cursorx%, %cursory% ; reset cursor
  Clipwait, 1
  StringReplace, scrape, clipboard, `r`n, %A_Space%, All ; remove LF, simplifies regex
  StringReplace, scrape, scrape, %A_Space%%A_Space%, %A_Space% , All ; remove doubled whitespace
  clipboard = %priorclip% ; reset clipboard
return scrape
}

WaitFindText(x, y, w, h, err1, err0, Text,  wintitle :="", action := 1, wait := 5, postwait := 0, xoffset :=0, yoffset := 0)
{
  if (WinExist(wintitle) || wintitle == "") {
	WinGetActiveTitle, priorwin
	if %wintitle%
		WinActivate, %wintitle%
	else
		return false ; better error checking here
    start := A_TickCount
    Loop {
      elapsed := Floor((A_TickCount - start)/1000)
      if (Ok := FindText(x,y,w,h,err1,err0,Text))
      {
        CoordMode, Mouse  
        MouseGetPos, X, Y
		rx := Ok.1.x + xoffset, ry := Ok.1.y + yoffset
		comment := "<" . Ok.1.id . ">"
        if action ; note 0 used to determining exists only
        {
			if action = 1
			{
				MouseMove, %rx%, %ry%
				sleep, 20
				Send, {Click} ; Send {vk01sc000} ; both work better then MouseClick, Left, %rx%, %ry%
				MouseMove, %X%, %Y%
			}
			if action = 2
			{
				MouseMove, %rx%, %ry%
				sleep, 20
				Click
				sleep, 200
				Click
				MouseMove, %X%, %Y%
			}
			if action = 3
			{	
				if WinActive("ahk_class IEFrame") { ; ctrl-l focuses at URLbar - needed
				Send, ^l
				Sleep, 50
				}
				WinGetPos, x, y,,, A
				x:=rx-x, y:=ry-y
				ControlClick, x%x% y%y%, A
			}
			if action = 4
				MouseMove, %rx%, %ry%
        }
        Sleep % (postwait * 1000)
		WinActivate, %prior%
        break
      }
      If testing
        Tooltip %  comment . " Not Found in " . elapsed . " / " . wait . " secs"
    } Until (elapsed >= wait)

    If testing
    {
      msg := % (Ok) ?  (comment . " Found at X: " . rx . " Y: " . ry . " in " . elapsed . " / " . wait . "  secs")
        : (comment  . ": FINAL Not Found Final @ " . wait . " secs")
      Tooltip % msg
      SetTimer, WFTKillTooltip, -5000
    }
    sleep 50 ; need to allow catchup
  }
  return Ok

  WFTKillTooltip:
  Tooltip
  return
}

BetterCopy() { ; maintains current clipboard contents thru clipboard use, and returns highlighted
	clipsaved := ClipboardAll
	clipboard =
	Send ^c
	Clipwait, 1
	result := clipboard
	clipboard := clipsaved
	clipsaved =
	return result
}

BetterPaste(text) { ; maintains current clipboard through force pasted operation
	clipsaved := ClipboardAll
	clipboard  =
	clipboard := text
    ClipWait, 1
	SendPlay ^v
	Sleep 50 ; required
	clipboard := clipsaved
	clipsaved =
return 
}

RedClickThrough(force := "NADA") {
	static clickthrough = true
	if force != NADA
		clickthrough := force
	Winset, ExStyle, % ((clickthrough) ? "+0x20" : "-0x20"), Red
	clickthrough := !clickthrough
}

RedMask(force :="NADA") { ; defaults to ReClickThrough(false)
	static redmask = true
	if force != NADA
		redmask := force
	Gui, Red:Default
	Gui +LastFound  +AlwaysOnTop -Caption +ToolWindow -Resize
	  ; +E0x08000000 -DPIScale
	WinSet, Transparent, 150
	Gui, Color, Red
	SysGet, Mon, MonitorWorkArea
	nW := MonRight - MonLeft
	nH := MonBottom - MonTop
	if redmask
		Gui, Show, w%nW% h%nH%, Red
	else
		Gui, Hide
		RedClickThrough(false)
	redmask := !redmask
} ; - end Redmask --------------------------------------------------------------------------------------------

Insert:: ; Append selection to clipboard
	prior := BetterCopy()
	clipboard := clipboard . "`r`n" . prior
return

TrayTip(traytitle := "", traytext := "", traysecs := 5, trayoptions := "") {
	; Note seconds not being respected
	if traytitle and not traytext
		TrayTip, , %traytitle%, %traysecs%, %trayoptions%
	else
		TrayTip, %traytitle%, %traytext%, %traysecs%, %trayoptions%
return
}

LogErrors(error,errormsg,log:=true,msg:=false,errlog := "errlog.txt") {
	if (not error)
		return
	global logerrors
	if (msg)
		msgbox, %errormsg%`n
	errormsg := StrReplace(errormsg, "`r`n", "; ")
	errormsg := StrReplace(errormsg, "`n", "; ")
    if (log ) 
		FileAppend, %A_Now%/%A_ComputerName%/%A_UserName%: %A_ScriptName% %errormsg%`n, %errlog%
	return error
}

out(str) { ;---------------------------------------------------------------------------------------------------------------
    if Not A_IsCompiled {
		 oSciTE := ComObjActive("SciTE4AHK.Application")
		 if oSciTe {
			;if switch(str,"-c(lear)?")
			;	oSciTe.Message(0x111,420)
			;prefix  := switch(str,"-prefix",true)
			str := prefix . StrReplace(str, "`n","`n" . prefix)
			oSciTE.Output(str . "`n")
		}
    }
return
}

WinWaitCitrix(dTitle:="",timeout:=30,dW:="",dH:="",dX:="",dY:="",dColor:="",dColorAtX:="",dColorAtY:="") {
	/* Because Citrix windows are essentially graphics with which you can interact, many of the ahk window and most all of the control commands are worthless. This function allows you to wait for window with and desired combo of selection criteria for size, position, coordinates of pixel color at defined location, as well as standard title. 
	
	d = desired
	c = current
	*/
	if WinActive(dTitle) {
		s:=0
		Loop {
		  PixelGetColor, cColor, dColorAtX, dColorAtY, alt
		  WinGetActiveStats, cTitle, cW, cH, cX, cY
		  if  ((not dTitle || InStr(cTitle,dTitle)) && (not dX || cX=dX) && (not dY || cY =dY) && (not dH || cH=dH)  && (not dW || cW=dW) && (not dColor || cColor=dColor))
			return true
		  if (timout)
			sleep 1000
		} Until (A_Index >= timeout)
	}
return false
}

#+s:: ; List all Windows
	WinGet windows, List
	Loop %windows%
	{
		id := windows%A_Index%
		WinGetTitle wt, ahk_id %id%
		r .= wt . "`n"
	}
	r := RegExReplace(r, "\R(?=\R{2,})")
	MsgBox %r%
	Clipboard = %r%
return

+^s:: ; Easy window details to clipboard . 
SetTitleMatchMode, Slow
WinGetActiveStats, Title, Width, Height, X, Y
WinGetClass, Class , Title
WinGet, Hwnd, ID, A
WinGet, PID, PID, A
WinGet, Name, ProcessName, A
WinGet, Path, ProcessPath, A
WinGetText, Text, A
StatusBarGetText, SBText, 1, A
WinGet, ControlList, ControlList, A
StringReplace,ControlList, ControlList, `n, |, A
WinGet, ControlListHwnd,ControlListHwnd, A
StringReplace,ControlListHwnd, ControlListHwnd, `n, |, A
MouseGetPos, cX, cY
PixelGetColor, Color, %cX%, %cY%
SetTitleMatchMode, fast
Traytip,Window Info Scrubbed,This info has been placed on the clipboard as well,10
Text = Title: %Title%`r`nStatusBar Text: %SBText%`r`nHwnd: %HWnd%`r`nPID: %PID%`r`nName: %Name%`r`nPath: %Path%`r`nWindow X: %X%`r`nWindow Y: %Y%`r`nWindow H: %Height%`r`nWindow W: %Width%`r`nColor at cusror X%cX%/Y%cY%: %Color%`r`nControls Class: %ControlList%`r`nControls Hwnd: %ControlListHwnd%`r`nWindow Text: ==============================================`r`n%Text%`r`n==============================================
Clipboard = %Text%
msgbox, 4, Window Results, Show Results in Notepad?, 4
IfMsgBox, Yes
	gosub, notepad
else
	MsgBox, %Text%
return

notepad:
	Run, Notepad.exe
	WinWaitActive, Notepad, , 3
	If WinActive("Notepad")
		Send, ^v
return

Update(force:=false) {
	global AppVersion
	global AppName
	global GitHubVersionPath
	global GitHubRepoPath
	global GitHubRepoChanges
	Try {
		whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", GitHubVersionPath, true)
		whr.Send()
		whr.WaitForResponse()
		AvailVersion := whr.ResponseText
		if !AvailVersion {
			msgbox, Error Checking for %AppName% Update
			return
		}
		if (AvailVersion >= AppVersion || force) {
			whr.Open("GET", GitHubRepoChanges, true)
			whr.Send()
			whr.WaitForResponse()
			Changes := whr.ResponseText
			msgbox %AvailVersion% Version of %AppName% is Available`r`n`r`n%Changes%`r`nPlease be patient for Update...
			UrlDownloadToFile, %GitHubRepoPath%, Temp%A_ScriptName%
			BatchFile=
			/*
			Because you cannot delete or rename a currently running file, Design a batch file to: 
			ping to give time for this script to exit
			delete version 1 (prior version)
			rename version 2 to version 1 (new version) ; note cannot include drive/path for target
			run the new version
			delete the batch file
			*/
			(
			Ping 127.0.0.1
			Del %A_ScriptFullPath%
            Rename %A_ScriptDir%\Temp%A_ScriptName% %A_ScriptName%
			%A_ScriptFullPath%
			Del Update.bat
			)

			IfExist, Update.bat
				FileDelete,Update.bat ; Housecleaning possible priors
			FileAppend,%BatchFile%,Update.bat ; Create the bat
			MsgBox, You are now up to date on Version %AvailVersion%...Please wait for Restart ; Alert the user that the app will be down for a few seconds
            Run, Update.bat,,hide ;Run it (hidden)
            ExitApp
		} else {
			msgbox,,%AppName%, %AppName% App is Up To Date`r`nVersion %AppVersion%
		}
	}
return
}

FullUserName(username := "") {
Try {
	if not username
		username := A_UserName
	objConnection := ComObjCreate("ADODB.Connection")
	objCommand := ComObjCreate("ADODB.Command")
	objRecordset := ComObjCreate("ADODB.Recordset")
	strDomain := ComObjGet("LDAP://rootDSE").Get("defaultNamingContext")
	objConnection.Open("Provider=ADsDSOObject;")
	objCommand.ActiveConnection := objConnection
	fieldList := "givenName,sn,displayName,SAMAccountName,mail,telephoneNumber,department,st,employeeID"
	objCommand.CommandText := "SELECT " fieldList " From 'LDAP://" strDomain "' WHERE samAccountType='805306368'"
	objRecordset := objCommand.Execute()
	Loop
		{
			if (objRecordset.eof)
				break
			if objRecordset.Fields("SAMAccountName").value = username{
				return % objRecordset.Fields("givenName").value  " " objRecordset.Fields("sn").value
				break
			}
		objRecordset.MoveNext()
		}
}
return
}

CHECKWORKSTATION() { ; ---------------------------------------------------------------------
	bit 		:= (A_Is64bitOS) ? ("- 64 bit") : ("- 32 bit")
;	os 		:= RegExReplace(StringLower(A_OSVersion,"T"),"_", " ")
	mag 	:= (A_ScreenDPI=140) ? "144 dpi (150%)" : (A_ScreenDPI=110) ? "120 dpi (125%)" : (A_ScreenDPI=96) ? "96 dpi (100%)" : %A_ScreenDPI% dpi (Custom)
	if Not InStr(A_OSVersion ,requiredos)
		MsgBox, 262192, WorkStation Operating System, This application is written to interface with Windows 7 - 64 bit. Elements may fail/crash running via %os%%bit%
	if (A_ScreenWidth != requiredxres or A_ScreenHeight  != requiredyres)
		MsgBox, 262192, Workstation Resolution Settings, This application relies heavily on image searching`, For this to work accurately, screen resolution is very important. `n`nCurrent your resolution is set at %A_ScreenWidth% x %A_ScreenHeight% with DPI %A_ScreenDPI% and the application is expecting 1024 x 1280 with DPI of 96. `n`nYou should change it in Control Panel > Display > Screen Resolution. `n
	if (A_ScreenDPI  != requireddpi)
		MsgBox, 262192, Workstation Magnification Settings, This application relies heavily on image searching`, For this to work accurately, Maginifcation settings are very important. `n`nCurrent DPI is set to %mag%. `n`nYou should change it in Control Panel > Display > Make Text Larger/Smaller vs Custom Sizing Options. `n
	if (A_ScreenWidth != requiredxres or A_ScreenHeight  != requiredyres or A_ScreenDPI  != requireddpi) {
		Run control desk.cpl`,`,3
		WinActivate Display Properties
	  }
} ; End CHECKWORKSTATION------------------------------------------------------------


AHK_NOTIFYICON(wParam, lParam) ; for LeftClick access to TrayMenu
{
    global MenuOpen
    if (lParam = 0x202 || lParam = 0x205) { ; WM_LBUTTONUP ; WM_RBUTTONUP
        if (MenuOpen) { ;If left-click menu is open, close it
            Send {Esc}
        } else { ; If left-click menu is not open, open it
            Menu, Tray, Show
        } 
		;Toggle state of left-click menu (Open to close/Close to ope)
        MenuOpen := !MenuOpen
    }
    return 0
}