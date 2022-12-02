#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
Local $before
Local $after
;$before = WinActive("TEM Imaging & Analysis - supervisor")
; activate the window
Local $my_window = "TEM Imaging & Analysis"
WinActivate($my_window)
WinWaitActive($my_window, "", 5)
$after = WinActive($my_window)
Sleep(1000)
If $after <> 0 Then
   ExportSeries()
   SetExportParameters()
EndIf

Func ExportSeries()
   Local $my_window = "TEM Imaging & Analysis"
   $my_control = "[CLASS:AfxWnd140;INSTANCE:25]"
   ;This control is dynamic and ControlClick does not work.
   ;ControlClick($my_window,"",$my_control)
   Local $aWinPos = WinGetPos($my_window)
   ; This only works if Export Series Shortcut is expanded
   Local $aExportPos[2] = [49, 290]
   MouseClick($MOUSE_CLICK_LEFT, $aWinPos[0]+$aExportPos[0],$aWinPos[1]+$aExportPos[1])
   Sleep(1000)
   ;Select current series to exported. only one choice. Just click ok
   $my_control = "[CLASS:Button;INSTANCE:1]"
   ControlClick("Select Series to Export","",$my_control)
EndFunc

Func SetExportParameters()
   ;Set export parameters
   $sTitle = "Set export parameters"
   ;Generic Grid
   $sControl = "[CLASS:GXWND;INSTANCE:1]"
   $aWinPos = WinGetPos($sTitle)
   $aConPos = ControlGetPos($sTitle, "", $sControl)
   MsgBox(0, "window position", $aWinPos[0] & "," & $aWinPos[1] & " Control" & $aConPos[0] & "," & $aConPos[1])
   ;Filename Control
   ;Won't work: ControlSetText($sTitle,"","[CLASS:Edit;INSTANCE:1]", "newfilename",0)
   ;Use Mouse Click and KeySend
   If $CmdLine[0] > 0 Then
	  Local $sTargetCode = $CmdLine[1]
   Else
	  Local $sTargetCode = 'test_t'
   EndIf
   Local $aPos[2] = [$aWinPos[0]+$aConPos[0]+360,$aWinPos[1]+$aConPos[1]+71]
   MouseClick($MOUSE_CLICK_LEFT, $aPos[0],$aPos[1])
   Sleep(200)
   Send("{END}")
   For $i = 1 To 25
	  Send("{BS}")
	  Sleep(50)
   Next
   Sleep(200)
   Send($sTargetCode)
   Send("{TAB}")

   ; File Format Control could not setText.  Probably not getting the string correctly.
   Local $aPos[2] = [$aWinPos[0]+$aConPos[0]+220,$aWinPos[1]+$aConPos[1]+91]
   MouseClick($MOUSE_CLICK_LEFT, $aPos[0],$aPos[1])
   ; Raw Binary
   MouseClick($MOUSE_CLICK_LEFT, $aPos[0],$aPos[1]+50)
   Sleep(500)
   ;OK
   ControlClick($sTitle,"","[CLASS:Button;INSTANCE:1]")
EndFunc
