;########################################################################
;##                                                          DIRECTIVES                                                                     ##
;########################################################################
#NoEnv									; Environment variables support are trouble
#SingleInstance, Force				; Only 1
#Persistent								; Keep Live
#WinActivateForce					; Make WinActivate aggressive
#MaxThreadsPerHotkey 2
SetNumLockState,AlwaysOn
SetCapsLockState, Off
DetectHiddenText, On				; Maximize findability
DetectHiddenWindows, On	; Maximize findability
SendMode Input						; Most reliable of all the input modes.
SetDefaultMouseSpeed, 0		; Make mouse motions very fast
SetTitleMatchMode, RegEx    	; I always use Regex for everything
;########################################################################
;##                                                          GLOBALS                                                                         ##
;########################################################################
global AppName							:= SubStr(A_ScriptName,1,-4)
global AppVersion						:= 0.92
global GitHubVersionPath			:= "https://raw.githubusercontent.com/cycle4passion/keeplive/master/Version.txt"
global GitHubRepoPath				:= "https://github.com/cycle4passion/keeplive/blob/master/Keeplive.exe"
global GitHubRepoChanges		:= "https://raw.githubusercontent.com/cycle4passion/keeplive/master/ChangeLog.txt"
global idleevery							:= 1000*60*4		; refreshed every 4 minutes if inactive
global forceevery							:= 1000*60*8		; forces refresh every 8 minute even if active
global forceevery							:= 1000*60*8		; forces refresh every 8 minute even if active
global starttime							:= A_TickCount
global centitle								:= "Update|Chart"
global cenurl								:= "https://portal.vaurology.net/Citrix/PortalWebExplicit/"
global cctitle								:= "Hyperspace - RI UROLOGY"
; CC Active = "Hyperspace - RI UROLOGY", ""
; CC Login = "Hyperspace - edc", ""
; Citrix Main = "Citrix XenApp - Applications", "https://access.bshsi.org/XenAppRemote/site/default.aspx"
;| Citrix Production = "CitrixXenApp - Applications" , "https://access.bshsi.org/XenAppRemote/site/default.aspx?CTX_CurrentFolder=%5cConnectCare%5cPROD"
;| Citrix Connectcare = "CitrixXenApp - Applications" , "https://access.bshsi.org/XenAppRemote/site/default.aspx?CTX_CurrentFolder=%5cConnectCare"
; Citrix Main = "Citrix XenApp - Applications", "https://access.bshsi.org/XenAppRemote/site/default.aspx?CTX_CurrentFolder=%5c"
; Citrix 2F = "Bon Secours", "https://access.bshsi.org/cgi/login"
; Login = "Bon Secours", "https://access.bshsi.org/vpn/index.html"
global ccurl									:= "https://access.bshsi.org/"
global pktitle								:= "Capital 715 Desktop"
global pkurl									:= "https://capital.vdi.medcity.net/"
global nccntitle							:= "NCCN|www.nccn.org"
global nccnurl								:= "https://www.nccn.org/store/Login/Login.aspx"
global syntitle								:= "http://synapse|http://pacs"
global synurl								:= "http://synapse/explore.asp"
global LocationDone					:= false
global testing								:=  Not A_IsCompiled
;########################################################################
;##                                                          AUTOEXEC                                                                       ##
;########################################################################
gosub, HOTKEYREG
gosub, RESETMODIFIERS
;gosub, LOADLOCATION
gosub, TRAYMENU
gosub, SEARCHMENU
SetTimer, POLLING, % (1000 * 3)  													; Polling for Popups every 3 seconds
SetTimer, KeepLive, % (1000 * 60 * 1)    											; Keeplive checks every minute
OnMessage(0x219, "WM_DEVICECHANGE") 									; for removables
OnMessage(0x404, "AHK_NOTIFYICON") 										; for left click Tray
;########################################################################
;##                                                          INCLUDES                                                                        ##
;########################################################################
#include FindTextLib.ahk
#include KeepliveLib.ahk
#include AutoRunCD.ahk
#include Winkill.ahk
;########################################################################
;##                                                               TODO                                                                         ##
;########################################################################
; Escape on Docs click update but does not stay open?
; BSIAccept Terms - acting odd, click sometimes, not others, submitting?
; markdown for  synapse anomoly alrert 426742
; http://synapse/explore.asp?path=/All%20Patients&filter=internalPatientUID=641274
; No reading profile found for display.
; site names from registry?
; HCA DO not ask again o nthis device fails
; Redmask
; Esc does not maximize centricity
; check keeplive beep inside known open CC and/or pk
; implement go2
; username add special menu items for admin
; Test autoupdate
; Help as Markdown/GitHub
; Waitfindtext not shwoing comment on polling I accept
; autoclocik OK for reminder CC
; polling getting maximized instead of checked
; Keeplive not reverting to cencrity - worked with Chart open
; Hcare to Cen?
; Fix closeall
; Clarify Logging
; OK CC MSG - Hyperspace - edc , cehck OK if active
;########################################################################
return

F8::


	ccTitles := ["Hyperspace - RI UROLOGY","Hyperspace - edc","Citrix XenApp - Applications","Citrix XenApp - Applications","Citrix XenApp - Applications","Citrix XenApp - Applications","Bon Secours","Bon Secours"]
	ccTexts := ["","","https://access.bshsi.org/XenAppRemote/site/default.aspx","https://access.bshsi.org/XenAppRemote/site/default.aspx?CTX_CurrentFolder=%5cConnectCare%5cPROD","https://access.bshsi.org/XenAppRemote/site/default.aspx?CTX_CurrentFolder=%5cConnectCare","https://access.bshsi.org/XenAppRemote/site/default.aspx?CTX_CurrentFolder=%5c","https://access.bshsi.org/cgi/login",	"https://access.bshsi.org/cgi/login","https://access.bshsi.org/vpn/index.html"]
	
	cenTitles := [""]
	cenTexts := [""]


;"HCA Healthcare, Inc. - Identity Federation Login", "https://capital.vdi.medcity.net/"
	;pkTitles := ["Capital 715 Desktop - Desktop Viewer",]
	;pkTexts := ["",]
	Go2(ccTexts, ccTitles)
return

STARTUPAPPS: ;------------------------------------------------------------------------------
	TrayTip(AppName, "Auto-Loading...Please be patient!")
	Gosub, Synapse
	Gosub, HCare
	Gosub, Connectcare
	Gosub, Centricity
	TrayTip("Autoloading of applications has concluded...`n`nGo Ahead and login to everything.")
return ; End STARTUPAPPS -------------------------------------------------------------------

POLLING: ;------------------------------------------------------------------------------------
; Polling not live on testing because it prevents debug of everything else
	if testing
		return
	; Centricity --------------------------------------------------------------------------------
	; Login
	if WinWaitCitrix("Centricity Practice Solution",0,656,429) {
		Send, %A_Username%{Tab}
		 start := A_TickCount
		while (WinWaitCitrix("Centricity Practice Solution",0,656,429) && FindText(412-150000, 345-150000, 412+150000, 345+150000, 0, 0, "|<LocOfCareBlank>**50$69.0000000Tzzzs000000200000000000E00007U0000200000kT0000E000046800020000tskTQwkE0005Y40P8a200004UUDFw0E0000Y63+8020000gUlnFUkE000743vu7a200000000000E0000000000200000000000E0000000000200000000000E0000000000200000000000E0000000000200000000000Tzzzw")) {
			sleep, 100
			if Floor((A_TickCount - start)/1000) > 20
				return
		}
		if (WaitFindText(655-150000, 578-150000, 655+150000, 578+150000, 0, 0,"|<LocOfCare>*145$68.000000A000000Y00041s0000800010W000nbnbUQwE7CQE4Z548Y40+8YD9FF2910SXs4GIIEWEE8cU14Z548Y2++87TDCF1l0SyVtU","Centricity Practice Solution",1,0,0,50)) {
			RegRead, location, HKLM, SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine, Site-Name
			if (location = "Emporia")
				locationindex = 1
			else if (location = "Hanover")
				locationindex = 2
			else if (location = "MensWell")
				locationindex = 3
			else if (location = "PrinceGeorge")
				locationindex = 4
			else if (location = "Reynolds")
				locationindex = 5
			else if (location = "SPASC")
				locationindex = 6
			else if(location = "StonyPoint")
				locationindex = 7
			else if(location = "Tappahanock")
				locationindex = 8
			if (locationindex) {
				keys := "{PgUp}{Down " . locationindex . "}{Tab}"
				Send, %keys%				
			}
		}
		return
	}

	if WinActive("End Update") {  ; note 0.03 tolerance need to handle not unchecking, comma 0 only tries once
		WaitFindText(848-150000, 676-150000, 848+150000, 676+150000, 0.3, 0,"|<CenSignClinListChanges>*161$71.0000000000000000zzU000000001011t00000002024E000000040484xs70000808Q+OEH0000E0E6IoUU0000U0U6dd100001012BHG280002027mSY3U00040400800000080803k000000E0E000000000zzU00000000000000004","End Update",1,0)
	}
	
	If WinExist("Practice Solution 12")
		WinHide, Practice Solution 12 ; Hide the Useless Centricity Window
	
	; ? killing open centricity
	;If WinExist("Centricity Practice Solution -") ; Hide minimizes, Kill this mostly Useless Centricity Window
	;	WinKill, Centricity Practice Solution -
	
	If WinActive("Security Alert","In the future`, do not show this warning") {
		Send, ~i{Tab 2}{Enter}
	}
	
	;if WinActive("Security Alert","?") {
	;	ControlClick, Yes, Security Alert ; NOT SURE THIS IS WORKING
	;}
	
	
	
	If WinActive("Synapse", "Save changes to")
		Send, {Enter}
	
	  If WinActive ("Warning : Monitor Calibration Needed") { ; Works fine, for Synapse
		ControlClick, Button2, Warning : Monitor Calibration Needed
		Send, {Enter} ; ControlClick, Button1 Fails for OK, no Alt option
	}
	
	If WinActive (" Synapse Anomaly Alert") {
		Send, {Tab}{Space}{Tab}{Return}
	}
	
	; Connectcare -------------------------------------------------------------------------------
	If WinActive (Escape("Workspace Limit Reached - \\Remote"))
		Send, {Enter}
	
	If WinActive ("Bon Secours", Escape("https://access.bshsi.org/vpn/index.html"))
		WaitFindText(711-150000, 630-150000, 711+150000, 630+150000, 0.1, 0,"|<BSIAcceptTerms>*168$69.zzU00000000404000000000U0U000000004040E0000450U0U200000Vc4040EQtnriDtU0U24odmmVhw040ETX7qIBDU0U24odkmVdw040Eytnra7BU0U00000k00404000006000zzU000000004","Bon Secours",1,0,0,-30)
	; BSIAccept Terms - acting odd, click sometimes, not others, submitting?

	If WinActive("Assign Me") { ; Connectcare
		Send, Consulting Provider{Tab}!A
	}
	
	return
;HCA ----------------------------------------------------------------------------------
	if WinActive("HCA Healthcare, Inc") { ; note 0.03 tolerance need to handle not unchecking
		WaitFindText(37-150000, 340-150000, 37+150000, 340+150000, 0, 0.03,"|<HCADontAskAgainOnThisDevice>*161$71.00003zy000000000404000000000808000000000E0E07s000000U0U08M0000010100EMw000020200UG80000404010gM0000808021ME0000E0E042kU0000U0U08BX000010100El400003zy00z1l","HCA Healthcare, Inc",1,0.1)
	}
	
return ; End POLLING -------------------------------------------------------------------------

ScrapeCenBanner(ByRef id := "", ByRef dob := "", ByRef lastname := "", ByRef firstname := "") { ;------------------------------------------------------------------------------
  IfWinNotExist, Chart -
  {
      TrayTip("Abort: Centricity Chart for a Specific Patient is not Open!")
      return false
  }
  ; Use Centricity >> to localize banner
  if (ok := WaitFindText(189-150000, 152-150000, 189+150000, 152+150000, 0, 0,"|<Centricity2Arrows>*158$22.zzzXzzyDzzszzzXzzyDzzszzzXzzyDzzsxrzXaTyAnzsaTzUnzy9bzsnDzXaTyDRzszzzXzzyDzzszzzXzzyDzzszzzW","Chart -",4)) {
	xoffset := 20, yoffset :=10 ; offset to get to upper left corner of banner
	selectxoffset :=600, selectyoffset=30 ; width of selected area
	x1 := ok.1.x + xoffset, y1 := ok.1.y + yoffset, x2 := x1 + selectxoffset, y2 := y1 + selectyoffset
	scrape := ScrapeBanner("Chart - ", x1, y1, x2, y2)
	; https://regex101.com/r/Ryv4eD/4
	; ^(?<FN>(?<ABBR>(?:ST|)\.\s)?[a-z]+)\s+(?<NN>['|"].*['|"]\s+)?(?<MI>[a-z.]{1,2}\s+)?(?<LN>.*?)\s+\(.*
	singleordoublequotes 	:= chr(39) . "|" . chr(34) 
	regname 	:= "i)" . "^(?<FN>(?<ABBR>(?:ST|)\.\s)?[a-z']+)\s+(?<NN>[" . singleordoublequotes . "].*[" . singleordoublequotes . "]\s+)?(?<MI>[a-z.']{1,2}\s+)?(?<LN>.*?)\s+\(.*"
	id 				:= RegExReplace(scrape, "(?:.*)\(#\s*?(?<ID>\d+)\s*?\)(?:.*)" , "${ID}")
	dob			    := RegExReplace(scrape, "(?:.*)DOB:\s+(?<DOB>\d+\/\d+\/\d+)(?:.*)" , "${DOB}") 
	firstname		:= RegExReplace(scrape, regname, "${FN}")
	lastname		:= RegExReplace(scrape, regname, "${LN}")
	if  not (dob and lastname and firstname and id) {
		Traytip("Problem with Centricity Demographic Scraping")
		if IsFunc("LogErrors")
			LogErrors(true,"scrape: " . scrape . ", Firstname: " . firstname . ", Lastname: " . lastname . ", ID#" . id . ", DOB: " . dob)
		} else {
			Traytip("Scraped, Now Searching...", "FN:`t" . firstname . "`r`nLN:`t" . Lastname . "`r`nID#`t" . id . "`r`nDOB:`t" . dob, -20)
		return true
		}
	} else {
		Traytip("","Problem with FindText component Demographic Scraping")
	}
	return false
}

CONNECTCARESEARCH: ; from Centricity
	; NOTE: this requires default Connectcare Theme - (Epic button>My Setting>Themes>Default)
	If ScrapeCenBanner(vuid,dob,lastname,firstname) {
		if (not WinExist("Patient Lookup")) 	{ ; Press Patient Station Button
			Ok := WaitFindText(308-150000, 35-150000, 308+150000, 35+150000, 0, 0,"|<PtStation>*117$50.z87W09008G2AU20025kVQtoQSV8A2F9AaTW0sUGG960U18wYWFU88GF98YM224YGH960kSBwoQFU",cctitle)
		if (not Ok)
			return
		}
		Send, %lastname%`,%firstname%{Tab 4}%dob%!f
		Sleep, 1000 ; wait for patient options
		Send, {Enter} ; Select first entry, should be good with LN, FN and DOB
		Sleep, 1000 ; wait for patient chart to open
		IfWinActive, Workspace Limit Reached
			Send, {Enter}
		IfWinActive, Patient Select  ; close failed search, close search
		{
			Send, {Esc}
			Winactivate, Chart|Update
			Traytip("Connectcare: Patient not found.")
			return
		}
		; Else patient found and Click "Results Review"
		Sleep, 500 ; Wait needed to allow CC to catch up
		WaitFindText(49-150000, 432-150000, 49+150000, 432+150000, 0, 0,	"|<ResultsReview>*140$71.000000000000000000000000000000000000000000000000000000000000000000000000004E0Dk01000009U0NU0001lsqLj0l7AoQqnNgaP1aPN9hca3NAk3tWGK9TbamMw6nywjvU3BYkMAq1tM7gmP9aENalWP5kwyHbUlb34Q80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000U",cctitle)
		return 
	}


F7::
CenToHCare:
return
/*
If ScrapeCenBanner(vuid,dob,lastname,firstname) {
	WaitFindText(169-150000, 139-150000, 169+150000, 139+150000, 0, 0, "|<PKPatientSearchTab>*136$68.000000000000000000000004U010w0000U1000EMU0008CuCDC48swxnsYYGN1UF9gom994WE7YE/8AiGT8Y09wSW28YY2911E8cUW994WkMYKOB8jOC8a3ksuVm8000000000000000000000000000000000000000000000000000000008"),pktitle,1,0)

	if (WaitFindText(45-150000, 245-150000, 45+150000, 245+150000, 0, 0, "|<PKLastname>*176$44.01U0000k0M0010A063tts301UqnM0k0k1i60A0A3ttU3031a6M0k0kPta0A0Drnlk3U",pktitle,1,0,30))
	{
	WaitFindText(82,327,150000,150000,0,0,"|<Lastname>*191$25.M000A000a3ttv1han06sNUTDAkNVaMBwnDrnlo",test,,1,,50)
	Send, ^a%lastname%{Tab}^a%firstname%{Tab}^a%dob%{Enter}
	Sleep, 1000 ; cant add to Sx because multithread
	}
	return
   WaitFindText(478,514,150000,150000,0,0,"|<Visit>*135$35.kK0M0oVU001dWNlyDvAYmM5aHAAk/BaSN0oSA6m3yQP9g2EkbmA5Y",test,,2)
	MouseClick, L, 0, 20, 1,,,R
	 WaitFindText(100,861,150000,150000,0,0,"|<AddToPatientList>*191$70.70MC300z02M0w1UsQ03C0M03kyTXvsAPvySDbPi7RUlhqvRqNisRb3CTPxqNavVqQDnxjzzqPi7NkkRqz3XRysRr3VrPhyCzTUvsC3xySU",test,,1,1)
	  WaitFindText(526,568,150000,150000,0,0,"|<Add>*191$23.C0MAS0kMwTbnsrRavanArBazyPBXhrP3Dbw",test,,1,1)
	  WaitFindText(85,221,150000,150000,0,0,"|<PatientListTab>*191$53.S04004805a100AM08/BzLjQkjsrkIdOlVEVA7dyZX2x2MPLV/64S4kSxuLDfqA00000000M00000000Q",test,,1)
}

return

} ; End HCARE -----------------------------------------------------------------------------
*/
CENSEARCH: ; coming from Connectcare or PK
	If Not WinExist(centitle) {
		Traytip("Centricity is not Running, aborting...")
		return
	}
	if (Winactive(cctitle))
		scraped := ConnectcareScrape(firstname, lastname, dob)
	if (Winactive(pktitle)) {
		scraped := PKScrape(firstname, lastname, yob, true)
		return
	}
	if (scraped) {
		WinActivate, %centitle%
		TrayTip("Looking for:`t" . lastname . ", " . firstname . "`r`nBorn:`t`t" . dob . yob, ,20)
		Send, {Escape}
		Sleep, 750 ; required or missed
		if not WinActive("Find Patient") {
			Send, ^f ; close update if open and bring up find dialog
			WinWait, FindPatient, , 1
		}
		if WinActive("Find Patient")
			Send, !bName!f%lastname%`,%firstname%!s
	}
return

ConnectcareScrape(ByRef firstname, ByRef lastname, ByRef dob, showdata := false) { ;  Requires Default Theme
	If Not WinExist("Hyperspace") {
		Traytip("Connectcare Must Be Running, and a Patient already chosen.")
		return false 
	}
	WinActivate, %cctitle%
	; find left edge position by search MRN: above CSN:
	if (left := FindText(114-150000, 127-150000, 114+150000, 127+150000, 0, 0,"|<CCMRNCSN>*177$30.MNyAMMNXAMQtXCPQdX+MIdy/MJdY9MHda9sH9X8sH9V8P00000000000000000000000000000000000000007VslU8mAlUMK4tgE30dUE1shUE0AZUMK4bU8mAXUU"))
	{
		x1 := left.1.x - 5, y1 := left.1.y - 25
		; find right edge by getting position
		if (right := FindText(226-150000, 110-150000, 226+150000, 110+150000, 0, 0, "|<CCStatusAdmit>*170$36.NY0E00EiSu9tM4mG98742G900YSG9sEYWG88EYaHP8D6yNtt00000000000000000000000000000000000000000000000060E0P160E031D3rqTV96qPP194KFP1TYKFP1EYKFP1EqqFP1knqFPVU"))
		{
			x2 := right.1.x - 5, y2 := right.1.y + 20
			if (ccscrape := ScrapeBanner(cctitle,x1,y1,x2,y2)) {
				dob := RegExReplace(ccscrape, "(?:.*)(\d\d\/\d\d\/\d\d\d\d)(?:.*)" , "$1") 
				firstname := RegExReplace(ccscrape, "i)^([a-z\.]+),\s+([a-z\.]+)(?:.*)", "$2")
				lastname := RegExReplace(ccscrape, "i)^([a-z\.]+),\s+([a-z\.]+)(?:.*)", "$1")
				if showdata
					Traytip, Scrape Connectcare ,% ("FN:`t" . firstname . "`nLN:`t" . lastname . "`nDOB:`t" . dob)
				if  (lastname and firstname and dob)
					return true
			}
		}
	}
	TrayTip("Problem Scraping Demographics from Connectcare")
	return false
}

PKScrape(ByRef firstname, ByRef lastname, ByRef yob, showdata := false) {
	Winactivate, %hcaretitle%
	If (refresh:=FindText(312-150000, 164-150000, 312+150000, 164+150000, 0, 0,"|<PKRefresh>*162$23.zzzy00040008080E0M0UDs10zs23zU4D608Q9kEs3UVm710AS20zs43zU83y0E300U20100020004000Dzzzs"))
	{
		x1  := refresh.1.x + 20
		y1 := refresh.1.y -10
		x2 := x1 + 300
		y2 := y1
		if (hcascrape := ScrapeBanner(pktitle, x1, y1, x2, y2)) {
				firstname := RegExReplace(hcascrape, "^(?<lastname>.*),\s+(?<firstname>\w+)\s+(\w\.\s+)?\((?<age>\d+)Y.*", "${firstname}")
				lastname := RegExReplace(hcascrape, "^(?<lastname>.*),\s(?<firstname>\w+)\s(\w\.\s)?\((?<age>\d+)Y.*", "${lastname}")
				age := RegExReplace(hcascrape, "^(?<lastname>.*),\s(?<firstname>\w+)\s(\w\.\s)?\((?<age>\d+)Y.*", "${age}")
				yob := A_Year - age
				clipboard := lastname
				if  not (lastname and firstname and dob)  and not InStr(lastname, "No Patient Selected") {
					if showdata
						Traytip, Scrape Hcare ,% ("FN:`t" . firstname . "`nLN:`t" . lastname . "`nBorn in:`t" . yob)
					return true
				}
		}
	}
	Traytip("Problem Scraping HCA Demographics")
	return false
}

HOTKEYREG: ;------------------------------------------------------------------------------
$Pause:: ; Allows resetting modifier keys in case they get hosed somehow.
RESETMODIFIERS:
	SetCapsLockState, Off
	SetNumLockState, AlwaysOn
	SetScrollLockState, Off
	Send {Ctrl Up}{Shift Up}{Alt Up}{LWin Up}{RWin Up}
	If (A_ThisHotkey  = "$Pause")
		Pause
return

+Pause:: ; SHIFT-PAUSE: toggle testing
	testing := not testing
	TrayTip(testing ? "Testing - On" : "Testing - Off") 
return

$!Pause:: ; ALT-PAUSE: force polling used when not compiled
	TrayTip("Forced Polling - Uncompiled")
	gosub, POLLING
return

$+#Pause:: ; SHIFT-WIN-PAUSE: checking timing w/o firing
#Pause:: ; WIN-PAUSE force checklive
KEEPLIVE:
;-------------------------------------------------------------------------------------------------------------------------------------------
elapsed := (A_TickCount - starttime)
if (testing) {
	tt := "KeepLive : " . ((elapsed > forceevery) || (A_TimeIdle > idleevery) || (A_ThisLabel  = "#Pause") ? "TRUE" : "FALSE") 
	t :=  "Last update: " . (lastupdate ? lastupdate : "Never") . " - " . Round(elapsed/1000/60,1) . " mins ago`r`n" . ((A_ThisLabel  = "#Pause") ? "TRUE" : "FALSE") . " - " . " Hotkey: Win-Pause`r`n" . ((elapsed > forceevery) ? "TRUE" : "FALSE") . " Elapsed: " . Round(elapsed/1000/60,1) . " ?> forceevery: " . Round(forceevery/1000/60,1) . "`r`n" . ((A_TimeIdle > idleevery) ? "TRUE" : "FALSE") .  " TimeIdyl: " . Round(A_TimeIdle/1000.60,1) . " ?> idleevery: " . Round(idleevery/1000/60,1)
		TrayTip(tt,t,30)
		;FileAppend, %tt% - %t%`n, C:\users\srhamy\Desktop\keeplive.txt
		out("After " . Round(elapsed/1000/60,1) . " mins KeepLive last checked at " . (lastupdate ? lastupdate : "Never") . ":`tHotkey: " . (A_ThisLabel  = "#Pause") . ", Idle: " . (A_TimeIdle > idleevery) . ",  Force: " . (elapsed > forceevery) ) ; doesnt fire if compiled
}

if (elapsed > forceevery) || (A_TimeIdle > idleevery) || (A_ThisLabel  = "#Pause")
{
	;RedMask(true)
	if ((elapsed > forceevery) && (WinExist(cctitle) || WinExist(pktitle))) { ; sound beep and pause before overtaking user
		SoundBeep
		Sleep, 1000
	}
	priorwin := WinGetActiveTitle()
	MouseGetPos, X, Y
	FormatTime, lastupdate, , h:mm:ss
	Send {NumLock} ; toggle numberlock to reset A_TimeIdle; -  pause needed to prevent windows popup about Togglekeys
	Sleep, 250
	Send {NumLock} 
	starttime := A_TickCount ; reset force timer
	; BSRefresh ------------------------------------------------------------
	;RedClickThrough(true)
	WaitFindText(43-150000, 37-150000, 43+150000, 37+150000, 0, 0,"|<EpicButton>*144$54.7zk0w0000DzU0w0000DzU00A000D0TwtzU00C0zzzzk7zTzyTzXk3yTywDz003yS0sDz001wQ0sTz3U0sTzzzzzU0Ezzzvrz000zzznXw00001k00000003k00000003k000000U", cctitle,2)
	; HCARefresh -------------------------------------------------------------
	WaitFindText(51-150000, 48-150000, 51+150000, 48+150000, 0, 0, "|<Launchpad>*170$61.zzzzzvzzzzDzzzzxzzzzbzzzzyzzzznwRqbVFcwS1xqvBranhrQzvRirrPrvSTVirPvhvVjDirPhxqxirbrNhqSvArNU8C6vVRUsC3zzzzzzrzzzzzzzzzvzzzzzzzzzxzzzk", pktitle,2)
	WaitFindText(311-150000, 163-150000, 311+150000, 163+150000, 0, 0, "|<Refresh>*149$13.0E0A1z1zlzlsksHw1yEsMwTwTw7w1U0E4",pktitle,1, 0.2)
	;--------------------------------------------------------------------------
	;RedClickThrough(false)
	WinActivate, %priorwin% ; reset window
	MouseMove, X, Y ; reset cursor
	;RedMask(false)
}
return ; END KEEPLIVE ------------------------------------------------------------------------------------------------------------------------

$ScrollLock::
	Send #d ; BossKey Hide/Show Desktop
return

$PrintScreen::
	Send #+s ; scrape screen area instead of copy whole screen
return
	
$CapsLock::  ; this is required to reset Capslock after Hyper-Trigger
	KeyWait, CapsLock
	If (A_PriorKey="CapsLock")
		SetCapsLockState, % GetKeyState("CapsLock","T") ? "Off" : "On"
return

	#If, GetKeyState("CapsLock", "P")
		c:: gosub, Connectcare
		h:: gosub, HCare
		g:: gosub, Google
		k:: gosub, WinKill
		l:: gosub, STARTUPAPPS
		n:: Gosub, NCCN
		s:: gosub, SearchServices
		v:: gosub, Centricity
		y:: Gosub, Synapse
	#If
return

$Escape:: ; $ keeps Send, {Escape} from triggering this 
	KeyWait, Escape, U, T3
	If (ErrorLevel = 1)
		gosub, RESTART
	if WinActive("Centricity Practice Solution Browser") {
		WinKill, Centricity Practive Solution Browser
		UpdateExist(true)	
	} else if WinActive("Update") { ; if update is open, go to patient Chart>Documents
		Send, {Escape}
		WinActivate, Chart
		gosub, CenChart
		gosub, CenDocuments
	} else if UpdateExist() { ; if update available, Go Update
		UpdateExist(true)
	} else if WinActive("Chart",,"Chart Desktop") { ; If Chart active, go to Chart Desktop>Summary (no update avaialble)
		gosub, CenChartDesktop
		gosub, CenSummary
	}  else if WinActive("Chart Desktop") { ; Already on Chart Desktop, Assure on Summary
		gosub, CenSummary
	} else { ; send through Esc to other apps; try to default back to Centricity
		Send, {Escape}
		gosub, Centricity  ; default back to centiricty if running
	}
return

UpdateExist(Click := false) {
	Text := "|<CenEndUpdate>*180$36.DzzzzwTzzzzyzzzzzzzzzzzzzzzznzzs7znzzvzznzzvsC3zzvtYnzzs9YnzzvtYnzzvtYnzzvtYnzzs1a3zzzzzzzzzzzzzzzzzzzzzzzzzTzzzzyDzzzzwU"
	if Click {
		Winactivate, Update
		WaitFindText(166-150000, 235-150000, 166+150000, 235+150000, 0, 0, Text, "Chart", 1, 0, 0, -75)
	} else
		return FindText(166-150000, 235-150000, 166+150000, 235+150000, 0, 0, Text)
}	

CenChartDesktop: ; note works for normal and highlights (0.2)
WaitFindText(65-150000, 779-150000, 65+150000, 779+150000, 0.2, 0, "|<CenChartDesktop>*165$71.zbzzzzzzxzzz1DzyTUzzvvzwuTzwzAzzrrztw660SQkkg367tDYnwxBBHQYjnT/btuMSCv9TakLDno2ARbGTBAiTb9z+PgYuONQzAn6KL9A4q2wS3kVi36DzzzzzzzzzzwzzzzzzzzzzztU",centitle,1,0.1)
return 

CenSummary: ; note works for normal and highlights (0.2)
WinWaitActive, Chart Desktop
WaitFindText(49-150000, 189-150000, 49+150000, 189+150000, 0.2, 0, "|<CenSummary>*129$61.T000000000Mk00000000A/CzQTiT6wTVbQnAv8nzDwniNaNkNVgDNrAnAtwkq1gvaNaRaMDFqRnAnCnA7DVytaNbTa3U000000001k000000000k000000000MU",centitle,1,0.1)
return

CenChart: ; note works for normal and highlights (0.2)
WaitFindText(55-150000, 808-150000, 55+150000, 808+150000, 0.2, 0, "|<CenChart>*163$52.znzzzzzzz1DzyTzzztozztzzzzbkMM1zzzyz9waTzzznwrmtzzzzDnM/bzzzyTBAiTzzztoomtzzzzkHM/lzzzy",centitle,1,0.1)

CenDocuments: ; note works for normal and highlights (0.2)
WinWaitActive, Chart,, Chart Desktop
WaitFindText(66-150000, 439-150000, 66+150000, 439+150000, 0.2, 0,"|<CenDocuments>*127$71.00000000A00000000000M003VtaTi7btxw01a3AnglglX803M6NaRXNnC006kAnAvynaDU0BUNaNq1bA300NUnAni/CN603VtyNb7qQzs04",centitle,1,0.1)
return

TRAYMENU: ; ------------------------------------------------------------------------
If A_IsCompiled
	Menu, Tray, NoStandard
Menu, Tray,Add, &Search Menu (Hyper-S), SEARCHSERVICES
Menu, Tray,Add, &Google Search (Hyper-G), GOOGLE
Menu, Tray,Add, Window &Killer (Hyper-K), WINKILL
Menu, Tray,Add
Menu, Tray,Add, &VU Centricity (Hyper-V), CENTRICITY
Menu, Tray,Add, &Connectcare (Hyper-C), CONNECTCARE
Menu, Tray,Add, Synapse (Hyper-Y), SYNAPSE
Menu, Tray,Add, &HCare (Hyper-H), HCARE
Menu, Tray,Add, &NCCN (Hyper-N), NCCN
Menu, Tray,Add
if (A_UserName == "srhamy") {
	Menu, Tray, Add, &Force Online Application Update, FORCEUPDATE
	Menu, Tray, Add, Check/Perform Online Application Update, UPDATE
	Menu, Tray, Add
}
Menu, Tray,Add, Restart %AppName% (Hold Escape), RESTART
Menu, Tray,Add, Startup Work Apps (Hyper-L), STARTUPAPPS
Menu, Tray,Add, Close All/LogOff, CloseLogOff
Menu, Tray,Add, Quit, EXIT
Menu, Tray, Click, 1
Menu, Tray, Tip, %AppName% - v%AppVersion% - Scott Rhamy
If Not A_IsCompiled
	Menu, Tray, Icon, vu.ico ; , 1, 1 to always use on pause, etc
return

SearchMenu:  ;------------------------------------------------------------------------------
	; Create the popup menu by adding some items to it.
	Menu, SearchMenu, Add, Search Within...,SearchMenuHandler
	Menu, SearchMenu, Default, Search Within...
	Menu, SearchMenu, Icon, Search Within..., Shell32.dll, 23
	Menu, SearchMenu, Add  ; Add a separator line.
	Menu, SearchMenu, Add, &Connectcare, SearchMenuHandler
	Menu, SearchMenu, Add, &HCare, SearchMenuHandler
	Menu, SearchMenu, Add, &VU Centricity, SearchMenuHandler
	Menu, SearchMenu, Add, S&ynapse, SearchMenuHandler
	Menu, SearchMenu, Add, &Google, SearchMenuHandler
return

SearchServices:  ;------------------------------------------------------------------------------
	if  not (WinActive(centitle) && WinExist(cctitle))
	Menu, SearchMenu, Disable, &Connectcare
	if  not (WinActive(centitle) && WinExist(pktitle))
		Menu, SearchMenu, Disable, &HCare
	if  not (WinActive(centitle) && WinExist(syntitle))
		Menu, SearchMenu, Disable, S&ynapse
	if  not ((WinActive(cctitle) || WinActive(pktitle)) && WinExist(centitle))
		Menu, SearchMenu, Disable, &VU Centricity
	Menu, SearchMenu, Show 	
return

SearchMenuHandler:
	if InStr(A_ThisMenuItem,"Search") 
		return ; dummy SearchMenu Label
	If A_ThisMenuItem = &Connectcare
		Gosub, ConnectcareSearch
	If A_ThisMenuItem = S&ynapse
		Gosub, SynapseSearch
	If A_ThisMenuItem = &HCare
		Gosub, CenToHCare
	If A_ThisMenuItem = &VU Centricity
		Gosub, CenSearch
	If A_ThisMenuItem = &Google
		gosub, Google
return
;-----------------------------------------------------------------------------

Centricity: ;-----------------------------------------------------------------
	WinMinimize, Centricity Practice Solution - ; Minimize Main Window - where schedules are
	Go(centitle,cenurl)
return

Connectcare: ; -------------------------------------------------------------
	if (Not WinExist(cctitle) and WinExist("Hyperspace")) { ; logout happened, wait for user to re-log in
		Winactivate, Hyperspace
		return
	}
	Go(cctitle,ccurl)
return

HCare: ; -------------------------------------------------------------------
if (not WinExist(pktitle) && WinExist("Citrix Receiver", "https://capital.vdi.medcity.net/Citrix/XRDCWeb/")) {
	WinActivate, "Citrix Receiver", "https://capital.vdi.medcity.net/Citrix/XRDCWeb/"
	; FIX ME BELOW!
} else if (not WinExist(pktitle) && WinExist("HCA Healthcare, Inc.", "https://ap.idf.medcity.net/IdentityFederationPortal/Login/FormLogin/HCA")) {
	WinActivate, "HCA Healthcare", "https://ap.idf.medcity.net/IdentityFederationPortal/Login/FormLogin/HCA"
} else { 
	Go(pktitle,pkurl)
}
return

Synapse: ; -----------------------------------------------------------------
	Go("ahk_exe iexplore.exe",synurl,"synapse|pacs")
return

SynapseSearch: ; ---------------------------------------------------------
	if ScrapeCenBanner(vuid,dob,lastname,firstname) {
		Go("",synurl) ; empty forces new window
		SetTimer, SynKill, % (-1000*60*5) ; 5 minute auto-kill
		;Sleep, 1000 ; needed else others run too quickly, consider ready.
		WinWaitActive, "ahk_exe iexplore.exe", "synapse", 1
		ControlSend, , {Enter}, A ; , ahk_exe iexplore.exe  ; Send, {Enter} 
		WinWaitActive, ("ahk_exe iexplore.exe", "epath", 1
		ControlSend, , {Enter}, A ; , ahk_exe iexplore.exe  ; Send, {Enter}
	return
	SynKill:
	Loop {
		WinClose, ahk_exe iexplore.exe, synapse
		WinClose, ahk_exe iexplore.exe, epath	
	} Until (Not WinExist("ahk_exe iexplore.exe","synapse") and not WinExist("ahk_exe iexplore.exe","epath"))
		return
	}
return

NCCN: ; ------------------------------------------------------------------
	nccn := Go(nccntitle,nccnurl)
	COMDOM(nccn, "txtEmail", "cancer@uro.com")
	COMDOM(nccn, "txtPassword", "urology ")
	COMDOM(nccn, "blnRemember", "check")
	COMDOM(nccn, "btnLogin", "click")
return

Google: ; ----------------------------------------------------------------
	Go("","http://www.google.com/#&q=" . BetterCopy()) ; empty first parmater forces new search window
return

FORCEUPDATE:
	Update(true)
return

UPDATE:
	Update()
return

CLOSELOGOFF:  ;------------------------------------------------------------------------------
MsgBox, 8241, , Do you really wish to Close All running applications and Auto Log-Off in 5 Seconds?, 5
IfMsgBox, Ok
{
	WinGet, ID, List, , , Program Manager
	Loop, %ID%
	   {
		  this_id:=id%a_index%
		  WinGetTitle, This_Title, ahk_id %This_ID%
		  WinClose, %This_Title%
		  WinKill, %This_Title%
	   }
	msgbox, 8241, Shutting Down!, Press "Cancel" if you do not wish to LogOff in 5 seconds, 5
	IfMsgBox Yes, Shutdown, 0
	IfMsgbox Timeout, Shutdown, 0
	Exit
}
return

RESTART: ;-------------------------------------------------------------------------
	SoundBeep
	TrayTip("Restarting " . AppName)
	Sleep 2500
	Reload
return

EXIT: ;------------------------------------------------------------------------------
	ExitApp
return


/*
 * * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\Keeplive.exe
Created_Date=1
[ICONS]
Icon_1=%In_Dir%\vu.ico
Icon_3=%In_Dir%\vupause.ico
Icon_4=%In_Dir%\vupause.ico

* * * Compile_AHK SETTINGS END * * *
*/