WinKill: ; Written SJR 3/25/17 -------------------------------------------------------------------------------------
Hotkey, Escape, Off
MouseGetPos, x2,y2,winid,ctrlid
Gui, New, +Owner +AlwaysOnTop -Resize -SysMenu -MinimizeBox - MaximizeBox -Disabled -Caption -Border -ToolWindow
Gui,  Margin, 0, 0
Gui,  Color, AAAAAA
Gui,  Add, Picture, Icon110, Shell32.dll
Gui,  Show, X%x2% Y%y2% W32 H32 NoActivate, KillIcon
Winset, TransColor, AAAAAA, KillIcon
TrayTip("Kill Frozen Window", "Click a frozen window's CLOSE BUTTON to Kill it!`r`nClick ESCAPE to exit this Mode")
Loop {
   CoordMode, Mouse, Screen
   MouseGetPos, x, y, hWnd
   WinMove, KillIcon, , %x%, %y%

   GetKeyState,esc,Esc,P
   If esc=D
      Break
   GetKeyState,lbutton,LButton,P
   if lbutton=D
   {
      if NCHITTEST(x, y, hWnd) = "CLOSE" {
         WinKill, ahk_id %hWnd%, ,5 ; Tries for 5 seconds
      } else {
         Click
      }
      break
   }
}
GUI,Destroy
Hotkey, Escape, On
return

NCHITTEST(x, y, hWnd)
{
   HT_20 := "CLOSE"
   SendMessage, 0x84, 0, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
   Return   ErrorLevel >= 0 ? HT_%ErrorLevel% : ErrorLevel = -1 ? "TRANSPARENT" : "ERROR"
}
; End WinKill -------------------------------------------------------------------------------------
