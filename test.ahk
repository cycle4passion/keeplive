#SingleInstance Force
#NoEnv

;Global variables
;Left-click and right-click menus are not open when script begins
LeftClickMenuOpen := 0

;Program Start
gosub CreateTrayMenu
OnMessage(0x404, "AHK_NOTIFYICON")
return


CreateTrayMenu:
Menu, tray, NoStandard
Menu, tray, add, RightClick, Test
Menu, tray, add
Menu, tray, add, % "Exit", ExitProgram
return

Test:
MsgBox, % A_ThisMenu . "@" . A_ThisMenuItem . "@" . A_ThisMenuItemPos
return

/*
Lexikos method of detecting Left mouse click on ToolTray (modified)


If left click and left-click menu open, close left-click menu
If left click and left-click menu not open, open left-click menu
    (and close right-click menu, if open)

If right click and right-click menu open, close right-click menu
If right click and right-click menu not open, open right-click menu
    (and close left-click menu, if open)
*/

AHK_NOTIFYICON(wParam, lParam)
{
    global LeftClickMenuOpen
    if (lParam = 0x202) { ; WM_LBUTTONUP
        if (LeftClickMenuOpen) { ;If left-click menu is open, close it
            Send {Esc}
        } else { ; If left-click menu is not open, open it
            Menu, Tray, Show
        } 
		;Toggle state of left-click menu (Open to close/Close to ope)
        LeftClickMenuOpen := !LeftClickMenuOpen
    }
    return 0
}

ExitProgram:
ExitApp