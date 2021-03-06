#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; 在指定OU中创建组
; *****************************************************************************
#include  <AD.au3>
#include  <ButtonConstants.au3>
#include  <GUIConstantsEx.au3>
#include  <WindowsConstants.au3>

; 打开Active Directory连接
_AD_Open()

Global $iReply = msgbox(308, "Active Directory Functions", "This script creates a group in the OU you specify." & @CRLF & @CRLF & _
		"Are you sure you want to change the Active Directory?")
If $iReply <> 6 Then Exit

; 获取当前用户的OU
Global $sFQDN = _AD_SamAccountNameToFQDN()
Global $sParentOU = StringMid($sFQDN, StringInStr($sFQDN, ",OU=") + 1)

; 输入OU和组
#region ### START Koda GUI section ### Form=
Global $Form1 = GUICreate("Active Directory Functions", 714, 124)
GUICtrlCreateLabel("Enter the target OU (FQDN):", 8, 10, 231, 17)
GUICtrlCreateLabel("Enter the group name (without leading CN=):", 8, 42, 231, 17)
Global $IOU = GUICtrlCreateInput($sParentOU, 241, 8, 459, 21)
Global $IGroup = GUICtrlCreateInput("", 241, 40, 459, 21)
Global $BOK = GUICtrlCreateButton("Create group", 8, 72, 121, 33)
Global $BCancel = GUICtrlCreateButton("Cancel", 628, 72, 73, 33, BitOR($GUI_SS_DEFAULT_BUTTON, $BS_DEFPUSHBUTTON))
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	Global $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $BCancel
			Exit
		Case $BOK
			Global $sOU = GUICtrlRead($IOU)
			Global $sGroup = GUICtrlRead($IGroup)
			ExitLoop
	EndSwitch
WEnd

; 创建组
Global $iValue = _AD_CreateGroup($sOU, $sGroup)
If $iValue = 1 Then
	msgbox(64, "Active Directory Functions", "Group'" & $sGroup & "'successfully created")
ElseIf @error = 1 Then
	msgbox(64, "Active Directory Functions", "Group'" & $sGroup & "'already exists")
ElseIf @error = 2 Then
	msgbox(64, "Active Directory Functions", "OU'" & $sOU & "'does not exist")
Else
	msgbox(64, "Active Directory Functions", "Return code'" & @error & "'from Active Directory")
EndIf

; 关闭Active Directory连接
_AD_Close()

