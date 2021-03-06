#include <GuiEdit.au3>
#include <GuiStatusBar.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

$Debug_Ed = False ; 检查传递给 Edit 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hStatusBar, $hEdit, $hGUI
	Local $sWow64 = ""
	If @AutoItX64 Then $sWow64 = "\Wow6432Node"
	Local $sFile = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE" & $sWow64 & "\AutoIt v3\AutoIt", "InstallDir") & "\include\_ReadMe_.txt"
	Local $aPartRightSide[6] = [50, 130, 210, 290, 378, -1], $tRect

	; 创建 GUI
	$hGUI = GUICreate("Edit Set RECTEx", 400, 300)
	$hEdit = GUICtrlCreateEdit("", 2, 2, 394, 268, BitOR($ES_WANTRETURN, $WS_VSCROLL))
	$hStatusBar = _GUICtrlStatusBar_Create($hGUI, $aPartRightSide)
	_GUICtrlStatusBar_SetIcon($hStatusBar, 5, 97, "shell32.dll")
	_GUICtrlStatusBar_SetText($hStatusBar, "Rect")
	GUISetState()

	; 获取 RectEx
	$tRect = _GUICtrlEdit_GetRECTEx($hEdit)
	DllStructSetData($tRect, "Left", DllStructGetData($tRect, "Left") + 10)
	DllStructSetData($tRect, "Top", DllStructGetData($tRect, "Top") + 10)
	DllStructSetData($tRect, "Right", DllStructGetData($tRect, "Right") - 10)
	DllStructSetData($tRect, "Bottom", DllStructGetData($tRect, "Bottom") - 10)

	; 添加文本
	_GUICtrlEdit_AppendText($hEdit, FileRead($sFile))
	_GUICtrlEdit_LineScroll($hEdit, 0, _GUICtrlEdit_GetLineCount($hEdit) * - 1)

	; 设置 RectEx
	_GUICtrlEdit_SetRECTEx($hEdit, $tRect)

	; 获取 RectEx
	$tRect = _GUICtrlEdit_GetRECTEx($hEdit)
	_GUICtrlStatusBar_SetText($hStatusBar, "Left: " & DllStructGetData($tRect, "Left"), 1)
	_GUICtrlStatusBar_SetText($hStatusBar, "Topt: " & DllStructGetData($tRect, "Top"), 2)
	_GUICtrlStatusBar_SetText($hStatusBar, "Right: " & DllStructGetData($tRect, "Right"), 3)
	_GUICtrlStatusBar_SetText($hStatusBar, "Bottom: " & DllStructGetData($tRect, "Bottom"), 4)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
