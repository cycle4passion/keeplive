Gui, +LastFound +AlwaysOnTop +Disabled +ToolWindow -Caption

WinSet, Transparent, 1

Gui, 2:+Owner1

Gui, 2:Add, Text,,Close this window to continue.

Gui, Show, w%A_ScreenWidth% h%A_ScreenHeight%

Gui, 2:Show,,Modal?

return

2GuiClose:

 ExitApp