#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\..\..\Helmut Fischer\MKT\Helmut Fischer.ico
#AutoIt3Wrapper_Res_Comment=Made by Dang
#AutoIt3Wrapper_Res_Description=Tool for semi auto input calibration STD for Gold Application
#AutoIt3Wrapper_Res_Fileversion=2.0.1.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_ProductName=Auto Input STD v2
#AutoIt3Wrapper_Res_ProductVersion=2.0.1
#AutoIt3Wrapper_Res_CompanyName=FIVI
#AutoIt3Wrapper_Res_LegalCopyright=Dang Nguyen
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 Version:		2.0.1
 Author:		Dang Nguyen

 Script Function:
	Semi Auto Input Calibration STD for Gold Application

#ce ----------------------------------------------------------------------------

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <msgboxconstants.au3>
#include <EditConstants.au3>
#include <Array.au3>
#include <Json.au3>

#Region ### START Koda GUI section ###
Global $AutoInputSTD = GUICreate("Auto Input STD v2", 414, 141, -1, -1)
GUISetIcon("C:\Users\DANG\OneDrive\Helmut Fischer\MKT\Helmut Fischer.ico", -1)
Global $MenuFile = GUICtrlCreateMenu("File")
Global $MenuAbout = GUICtrlCreateMenuItem("About", $MenuFile)
Global $MenuExit = GUICtrlCreateMenuItem("Exit", $MenuFile)
Global $MenuConfig = GUICtrlCreateMenu("Config")
Global $MenuSTD = GUICtrlCreateMenuItem("STD Set", $MenuConfig)
Global $MenuProduct = GUICtrlCreateMenu("Product", $MenuConfig)
Global $MenuGJ = GUICtrlCreateMenuItem("Gold Jewelry", $MenuProduct)
Global $MenuGG = GUICtrlCreateMenuItem("Gold Global", $MenuProduct)
Global $MenuRJ = GUICtrlCreateMenuItem("Rh/Jewelry", $MenuProduct)
GUISetFont(12, 400, 0, "Be Vietnam Pro")
Global $Label = GUICtrlCreateLabel("Select product", 24, 16, 368, 53, $SS_CENTER)
GUICtrlSetFont(-1, 20, 400, 0, "Be Vietnam Pro")
Global $GoldJewelry = GUICtrlCreateRadio("Gold Jewelry", 16, 78, 129, 25)
Global $GoldGlobal = GUICtrlCreateRadio("Gold Global", 152, 78, 129, 25)
Global $RhJewelry = GUICtrlCreateRadio("Rh/Jewelry", 282, 78, 129, 25)
Global $AutoInputSTD_AccelTable[1][2] = [["4", $MenuAbout]]
GUISetAccelerators($AutoInputSTD_AccelTable)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global Const $config_app = @ScriptDir & "\CONFIG_App.ini"
Global Const $config_std = @ScriptDir & "\CONFIG_STD.ini"

Global Const $check_app = FileExists($config_app)
Global Const $check_std = FileExists($config_std)

Global Const $cVersion = "2.0.1"
Global Const $cIdVersion = 201

While 1
	$nMsg = GUIGetMsg()
	checkUpdate()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $MenuAbout
			MsgBox(64 + 262144,"Thông tin phiên bản","Tool tự động input giá trị tấm chuẩn version 2" & @CRLF & "Made by Dang")

		Case $MenuExit
			Exit

		Case $MenuSTD
			MsgBox(64 + 262144,"","Chức năng đang được phát triển ..." & @CRLF & @CRLF & "Để chỉnh sửa số lượng tấm chuẩn và giá trị tấm chuẩn, vui lòng thay đổi giá trị trong file CONFIG_STD.ini")

		Case $MenuGJ
			GJEditor()

		Case $MenuGG
			GGEditor()

		Case $MenuRJ
			RJEditor()

		Case $GoldJewelry
			GUICtrlSetState($GoldJewelry,$GUI_DISABLE)
			GUICtrlSetState($GoldGlobal,$GUI_DISABLE)
			GUICtrlSetState($RhJewelry,$GUI_DISABLE)
			GUICtrlSetState($MenuFile,$GUI_DISABLE)
			GUICtrlSetState($MenuConfig,$GUI_DISABLE)
			;GUISetState(@SW_DISABLE,$AutoInputSTD)
			If $check_app Then
				If $check_std Then

					Local $numberElement = IniRead($config_app,"GoldJewelry","No","") ;Khai báo số lượng ứng dụng đo
					Local $numberSTD = IniRead($config_std,"STD","No","") ;Khai báo số lượng tấm chuẩn
					Local $e1 = IniRead($config_app,"GoldJewelry","E1","") ;Nguyên tố đầu tiên trong ứng dụng
					Local $App = [$e1] ;Tạo 1 mảng chứa danh sách các nguyên tố trong ứng dụng
					Local $appName = $e1 ;Khai báo tên chứa danh sách các nguyên tố

					;Hàm for để lấy toàn bộ danh sách các nguyên tố đưa vào biến $appName và mảng $App
					For $i = 2 to $numberElement
						Local $element = IniRead($config_app,"GoldJewelry","E" & $i,"")
						_ArrayAdd($App,$element)
						$appName = $appName & "-" & $element
					Next

					Local $ask = MsgBox(1 + 262144,"","Xác nhận ứng dụng Gold Jewelry ???" & @CRLF & @CRLF &  $appName)

					If $ask = $idcancel Then
						MsgBox(16 + 262144,"","CANCELED !!!")
					Else
						For $j = 1 to $numberSTD
							Local $std = "STD" & $j
							Start()
						Next
					EndIf

				Else
					MsgBox(16 + 262144,"Lỗi","Không tìm thấy file CONFIG_STD")
				EndIf
			Else
				MsgBox(16 + 262144,"Lỗi","Không tìm thấy file CONFIG_App")
			EndIf
			GUICtrlSetState($GoldJewelry,$GUI_ENABLE)
			GUICtrlSetState($GoldGlobal,$GUI_ENABLE)
			GUICtrlSetState($RhJewelry,$GUI_ENABLE)
			GUICtrlSetState($MenuFile,$GUI_ENABLE)
			GUICtrlSetState($MenuConfig,$GUI_ENABLE)
			;GUISetState(@SW_ENABLE,$AutoInputSTD)

		Case $GoldGlobal
			GUICtrlSetState($GoldJewelry,$GUI_DISABLE)
			GUICtrlSetState($GoldGlobal,$GUI_DISABLE)
			GUICtrlSetState($RhJewelry,$GUI_DISABLE)
			GUICtrlSetState($MenuFile,$GUI_DISABLE)
			GUICtrlSetState($MenuConfig,$GUI_DISABLE)
			If $check_app Then
				If $check_std Then

					Local $numberElement = IniRead($config_app,"GoldGlobal","No","") ;Khai báo số lượng ứng dụng đo
					Local $numberSTD = IniRead($config_std,"STD","No","") ;Khai báo số lượng tấm chuẩn
					Local $e1 = IniRead($config_app,"GoldGlobal","E1","") ;Nguyên tố đầu tiên trong ứng dụng
					Local $App = [$e1] ;Tạo 1 mảng chứa danh sách các nguyên tố trong ứng dụng
					Local $appName = $e1 ;Khai báo tên chứa danh sách các nguyên tố

					;Hàm for để lấy toàn bộ danh sách các nguyên tố đưa vào biến $appName và mảng $App
					For $i = 2 to $numberElement
						Local $element = IniRead($config_app,"GoldGlobal","E" & $i,"")
						_ArrayAdd($App,$element)
						$appName = $appName & "-" & $element
					Next

					Local $ask = MsgBox(1 + 262144,"","Xác nhận ứng dụng Gold Global ???" & @CRLF & @CRLF &  $appName)

					If $ask = $idcancel Then
						MsgBox(16 + 262144,"","CANCELED !!!")
					Else
						For $j = 1 to $numberSTD
							Local $std = "STD" & $j
							Start()
						Next
					EndIf

				Else
					MsgBox(16 + 262144,"Lỗi","Không tìm thấy file CONFIG_STD")
				EndIf
			Else
				MsgBox(16 + 262144,"Lỗi","Không tìm thấy file CONFIG_App")
			EndIf
			GUICtrlSetState($GoldJewelry,$GUI_ENABLE)
			GUICtrlSetState($GoldGlobal,$GUI_ENABLE)
			GUICtrlSetState($RhJewelry,$GUI_ENABLE)
			GUICtrlSetState($MenuFile,$GUI_ENABLE)
			GUICtrlSetState($MenuConfig,$GUI_ENABLE)

		Case $RhJewelry
			GUICtrlSetState($GoldJewelry,$GUI_DISABLE)
			GUICtrlSetState($GoldGlobal,$GUI_DISABLE)
			GUICtrlSetState($RhJewelry,$GUI_DISABLE)
			GUICtrlSetState($MenuFile,$GUI_DISABLE)
			GUICtrlSetState($MenuConfig,$GUI_DISABLE)
			If $check_app Then
				If $check_std Then

					Local $numberElement = IniRead($config_app,"RhJewelry","No","") ;Khai báo số lượng ứng dụng đo
					Local $numberSTD = IniRead($config_std,"STD","No","") ;Khai báo số lượng tấm chuẩn
					Local $e1 = IniRead($config_app,"RhJewelry","E1","") ;Nguyên tố đầu tiên trong ứng dụng
					Local $App = [$e1] ;Tạo 1 mảng chứa danh sách các nguyên tố trong ứng dụng
					Local $appName = $e1 ;Khai báo tên chứa danh sách các nguyên tố

					;Hàm for để lấy toàn bộ danh sách các nguyên tố đưa vào biến $appName và mảng $App
					For $i = 2 to $numberElement
						Local $element = IniRead($config_app,"RhJewelry","E" & $i,"")
						_ArrayAdd($App,$element)
						$appName = $appName & "-" & $element
					Next

					Local $ask = MsgBox(1 + 262144,"","Xác nhận ứng dụng Rh/Jewelry ???" & @CRLF & @CRLF &  $appName)

					If $ask = $idcancel Then
						MsgBox(16 + 262144,"","CANCELED !!!")
					Else
						For $j = 1 to $numberSTD
							Local $std = "STD" & $j
							Start()
						Next
					EndIf

				Else
					MsgBox(16 + 262144,"Lỗi","Không tìm thấy file CONFIG_STD")
				EndIf
			Else
				MsgBox(16 + 262144,"Lỗi","Không tìm thấy file CONFIG_App")
			EndIf
			GUICtrlSetState($GoldJewelry,$GUI_ENABLE)
			GUICtrlSetState($GoldGlobal,$GUI_ENABLE)
			GUICtrlSetState($RhJewelry,$GUI_ENABLE)
			GUICtrlSetState($MenuFile,$GUI_ENABLE)
			GUICtrlSetState($MenuConfig,$GUI_ENABLE)

	EndSwitch
WEnd

; Function move - Begin
Func movedown()
	Sleep(100)
	Send("{DOWN}")
	Sleep(100)
EndFunc
Func moveup()
	Sleep(100)
	Send("{UP}")
	Sleep(100)
EndFunc
Func moveright()
	Sleep(100)
	Send("{RIGHT}")
	Sleep(100)
EndFunc
; Function move - End

; Run Tool - Start
Func Start()
	Local $Label = IniRead($config_std,$std,"Label","")

	Local $sdtList = []
	Local $uStdList = []
	For $k = 1 to $numberElement
		Local $stdListElement = IniRead($config_std,$std,$App[$k-1],"")
		Local $uStdListElement = IniRead($config_std,$std,"u" & $App[$k-1],"")
		_ArrayAdd($sdtList,$stdListElement)
		_ArrayAdd($uStdList,$uStdListElement)
	Next
	;_ArrayDisplay($sdtList)
	;_ArrayDisplay($uStdList)

	Local $askSTD = MsgBox(1 + 262144,"","Tấm chuẩn " & $j & " - " & $Label)
	If $askSTD = $idcancel Then
		Return
	EndIf
	For $l = 1 to $numberElement
		If $l = $numberElement Then
			Send($sdtList[$l])
			moveright()
		Else
		Send($sdtList[$l])
		movedown()
		EndIf
	Next
	For $m = $numberElement to 1 Step -1
		If $m = 1 Then
			Send($uStdList[$m])
		Else
			Send($uStdList[$m])
			moveup()
		EndIf
	Next
	MsgBox(0 + 262144,"","Nhập label")
	Send($Label)
	Sleep(2000)
EndFunc
; Run Tool - End

;Check update
Func checkUpdate()
	Local $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")
	Local $oServer = "https://dang2d.github.io/js/std.json"
	$oHTTP.open("GET",$oServer,False)
	$oHTTP.send()
	$oHTTP.WaitForResponse

	$res = $oHTTP.ResponseText ;Giá trị trả về dạng JSON
	$json = Json_Decode($res) ;Decode JSON
	$nVersion = Json_Get($json, '[0]["version"]')
	$nIdVersion = Json_Get($json, '[0]["id-version"]')
	$url = Json_Get($json, '[0]["url"]')
	If $nIdVersion > $cIdVersion Then
		$askUpdate = MsgBox(64 + 262144,"Checking for update","A new version is avaiable: v" & $nVersion & @CRLF & @CRLF & "Click OK to go to the download page")
		If $askUpdate = $idok Then
			ShellExecute($url)
			Exit
		EndIf
	EndIf
EndFunc

;Gold Jewelry Editor - START
Func GJEditor()
	Local $GJNoElement = IniRead($config_app,"GoldJewelry","No","")
	Local $GJElementList = []
	For $i = 1 to 10
		Local $GJElement = IniRead($config_app,"GoldJewelry","E" & $i,"")
		_ArrayAdd($GJElementList,$GJElement)
	Next

	#Region ### START Koda GUI section ### Form=c:\users\dang\onedrive\learning\autoit\fivi\auto-input-calibration-std-set\autoinputstd_gj.kxf
	Local $GJ = GUICreate("Gold Jewelry Application Editor", 629, 506, -1, -1)
	GUISetIcon("C:\Users\DANG\OneDrive\Helmut Fischer\MKT\Helmut Fischer.ico", -1)
	GUISetFont(12, 400, 0, "Be Vietnam Pro")
	Local $GJLable = GUICtrlCreateLabel("Gold Jewelry", 30, 0, 509, 126, $SS_CENTER)
	GUICtrlSetFont(-1, 60, 400, 0, "Be Vietnam Pro")
	Local $Label1 = GUICtrlCreateLabel("No. of Element (max 10 elements)", 30, 152, 441, 45)
	GUICtrlSetFont(-1, 20, 400, 0, "Be Vietnam Pro")
	Local $Label2 = GUICtrlCreateLabel("(Outside range, leave it blank)", 30, 208, 241, 28)
	Local $Label3 = GUICtrlCreateLabel("1st", 30, 265, 29, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE1 = GUICtrlCreateInput($GJElementList[1], 30, 310, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label4 = GUICtrlCreateLabel("-", 80, 310, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $InputNoElement = GUICtrlCreateInput($GJNoElement, 480, 152, 121, 49, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 20, 400, 0, "Be Vietnam Pro")
	Local $BLoad = GUICtrlCreateButton("Load", 480, 352, 123, 49, BitOR($BS_DEFPUSHBUTTON,$BS_CENTER))
	GUICtrlSetFont(-1, 20, 400, 0, "Be Vietnam Pro")
	Local $BSave = GUICtrlCreateButton("Save", 480, 428, 123, 49, BitOR($BS_DEFPUSHBUTTON,$BS_CENTER))
	GUICtrlSetFont(-1, 20, 400, 0, "Be Vietnam Pro")
	Local $Label5 = GUICtrlCreateLabel("2nd", 110, 265, 39, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE2 = GUICtrlCreateInput($GJElementList[2], 110, 310, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label6 = GUICtrlCreateLabel("-", 160, 310, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label7 = GUICtrlCreateLabel("3rd", 190, 265, 36, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE3 = GUICtrlCreateInput($GJElementList[3], 190, 310, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label8 = GUICtrlCreateLabel("-", 240, 310, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label9 = GUICtrlCreateLabel("4th", 270, 265, 36, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE4 = GUICtrlCreateInput($GJElementList[4], 270, 310, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label10 = GUICtrlCreateLabel("-", 320, 310, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label11 = GUICtrlCreateLabel("5th", 350, 265, 36, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE5 = GUICtrlCreateInput($GJElementList[5], 350, 310, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label13 = GUICtrlCreateLabel("6th", 30, 390, 36, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE6 = GUICtrlCreateInput($GJElementList[6], 30, 435, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label14 = GUICtrlCreateLabel("-", 75, 435, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label15 = GUICtrlCreateLabel("7th", 110, 390, 34, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE7 = GUICtrlCreateInput($GJElementList[7], 110, 435, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label16 = GUICtrlCreateLabel("-", 160, 435, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label17 = GUICtrlCreateLabel("8th", 190, 390, 35, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE8 = GUICtrlCreateInput($GJElementList[8], 190, 435, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label18 = GUICtrlCreateLabel("-", 240, 435, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label19 = GUICtrlCreateLabel("9th", 270, 390, 36, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE9 = GUICtrlCreateInput($GJElementList[9], 270, 435, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label20 = GUICtrlCreateLabel("-", 320, 435, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label21 = GUICtrlCreateLabel("10th", 350, 390, 43, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE10 = GUICtrlCreateInput($GJElementList[10], 350, 435, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg1 = GUIGetMsg()
		Switch $nMsg1
			Case $GUI_EVENT_CLOSE ;Khi nhấn tắt cửa sổ
				$askSave = MsgBox(1 + 32 + 262144,"","Các thiết lập có thể chưa được lưu, xác nhận thoát?")
				If $askSave = $idcancel Then

				Else
					MsgBox(64 + 262144,"","Vui lòng khởi động lại ứng dụng")
					Exit
				EndIf

			Case $BLoad ;Khi nhấn Load button
				MsgBox(64 + 262144,"Success","This is a joke button." & @CRLF & "Why do you need a Load button meanwhile the data are already loaded? Haha")

			Case $BSave ;Khi nhấn Save button
				IniWrite($config_app,"GoldJewelry","E1",GUICtrlRead($InputE1))
				IniWrite($config_app,"GoldJewelry","E2",GUICtrlRead($InputE2))
				IniWrite($config_app,"GoldJewelry","E3",GUICtrlRead($InputE3))
				IniWrite($config_app,"GoldJewelry","E4",GUICtrlRead($InputE4))
				IniWrite($config_app,"GoldJewelry","E5",GUICtrlRead($InputE5))
				IniWrite($config_app,"GoldJewelry","E6",GUICtrlRead($InputE6))
				IniWrite($config_app,"GoldJewelry","E7",GUICtrlRead($InputE7))
				IniWrite($config_app,"GoldJewelry","E8",GUICtrlRead($InputE8))
				IniWrite($config_app,"GoldJewelry","E9",GUICtrlRead($InputE9))
				IniWrite($config_app,"GoldJewelry","E10",GUICtrlRead($InputE10))

				Sleep(500)
				MsgBox(64 + 262144,"Success","Thiết lập lưu thành công." & @CRLF & "Vui lòng khởi động lại ứng dụng")
				Exit
		EndSwitch
	WEnd
EndFunc
;Gold Jewelry Editor - END

;Gold Global Editor - START
Func GGEditor()
	Local $GGNoElement = IniRead($config_app,"GoldGlobal","No","")
	Local $GGElementList = []
	For $i = 1 to 25
		Local $GGElement = IniRead($config_app,"GoldGlobal","E" & $i,"")
		_ArrayAdd($GGElementList,$GGElement)
	Next

	#Region ### START Koda GUI section ### Form=C:\Users\DANG\OneDrive\Learning\AutoIT\FIVI\Auto-Input-Calibration-STD-Set\AutoInputSTD_GG.kxf
	Local $GG = GUICreate("Gold Global Application Editor", 676, 747, -1, -1)
	GUISetIcon("C:\Users\DANG\OneDrive\Helmut Fischer\MKT\Helmut Fischer.ico", -1)
	GUISetFont(12, 400, 0, "Be Vietnam Pro")
	Local $GJLabel = GUICtrlCreateLabel("Gold Global", 30, 0, 617, 126, $SS_CENTER)
	GUICtrlSetFont(-1, 60, 400, 0, "Be Vietnam Pro")
	Local $Label1 = GUICtrlCreateLabel("No. of Element (max 10 elements)", 30, 152, 441, 45)
	GUICtrlSetFont(-1, 20, 400, 0, "Be Vietnam Pro")
	Local $Label2 = GUICtrlCreateLabel("(Outside range, leave it blank)", 30, 208, 241, 28)
	Local $Label3 = GUICtrlCreateLabel("1st", 30, 265, 40, 28, $SS_CENTER)
	Local $InputE1 = GUICtrlCreateInput($GGElementList[1], 30, 310, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label4 = GUICtrlCreateLabel("-", 80, 310, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $InputNoElement = GUICtrlCreateInput($GGNoElement, 480, 152, 121, 49, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 20, 400, 0, "Be Vietnam Pro")
	Local $BLoad = GUICtrlCreateButton("Load", 464, 336, 123, 49, BitOR($BS_DEFPUSHBUTTON,$BS_CENTER))
	GUICtrlSetFont(-1, 20, 400, 0, "Be Vietnam Pro")
	Local $BSave = GUICtrlCreateButton("Save", 464, 412, 123, 49, BitOR($BS_DEFPUSHBUTTON,$BS_CENTER))
	GUICtrlSetFont(-1, 20, 400, 0, "Be Vietnam Pro")
	Local $Label5 = GUICtrlCreateLabel("2nd", 110, 265, 40, 28, $SS_CENTER)
	Local $InputE2 = GUICtrlCreateInput($GGElementList[2], 110, 310, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label6 = GUICtrlCreateLabel("-", 160, 310, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label7 = GUICtrlCreateLabel("3rd", 190, 265, 40, 28, $SS_CENTER)
	Local $InputE3 = GUICtrlCreateInput($GGElementList[3], 190, 310, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label8 = GUICtrlCreateLabel("-", 240, 310, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label9 = GUICtrlCreateLabel("4th", 270, 265, 40, 28, $SS_CENTER)
	Local $InputE4 = GUICtrlCreateInput($GGElementList[4], 270, 310, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label10 = GUICtrlCreateLabel("-", 320, 310, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label11 = GUICtrlCreateLabel("5th", 350, 265, 40, 28, $SS_CENTER)
	Local $InputE5 = GUICtrlCreateInput($GGElementList[5], 350, 310, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label13 = GUICtrlCreateLabel("6th", 30, 390, 40, 28, $SS_CENTER)
	Local $InputE6 = GUICtrlCreateInput($GGElementList[6], 30, 435, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label14 = GUICtrlCreateLabel("-", 80, 435, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label15 = GUICtrlCreateLabel("7th", 110, 390, 40, 28, $SS_CENTER)
	Local $InputE7 = GUICtrlCreateInput($GGElementList[7], 110, 435, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label16 = GUICtrlCreateLabel("-", 160, 435, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label17 = GUICtrlCreateLabel("8th", 190, 390, 40, 28, $SS_CENTER)
	Local $InputE8 = GUICtrlCreateInput($GGElementList[8], 190, 435, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label18 = GUICtrlCreateLabel("-", 240, 435, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label19 = GUICtrlCreateLabel("9th", 270, 390, 40, 28, $SS_CENTER)
	Local $InputE9 = GUICtrlCreateInput($GGElementList[9], 270, 435, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label20 = GUICtrlCreateLabel("-", 320, 435, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label21 = GUICtrlCreateLabel("10th", 350, 390, 40, 28, $SS_CENTER)
	Local $InputE10 = GUICtrlCreateInput($GGElementList[10], 350, 435, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label12 = GUICtrlCreateLabel("11st", 30, 515, 40, 28, $SS_CENTER)
	Local $InputE11 = GUICtrlCreateInput($GGElementList[11], 30, 560, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label22 = GUICtrlCreateLabel("-", 80, 560, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label23 = GUICtrlCreateLabel("12nd", 110, 515, 40, 28, $SS_CENTER)
	Local $InputE12 = GUICtrlCreateInput($GGElementList[12], 110, 560, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label24 = GUICtrlCreateLabel("-", 160, 560, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label25 = GUICtrlCreateLabel("13rd", 190, 515, 40, 28, $SS_CENTER)
	Local $InputE13 = GUICtrlCreateInput($GGElementList[13], 190, 560, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label26 = GUICtrlCreateLabel("-", 240, 560, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label27 = GUICtrlCreateLabel("14th", 270, 515, 40, 28, $SS_CENTER)
	Local $InputE14 = GUICtrlCreateInput($GGElementList[14], 270, 560, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label28 = GUICtrlCreateLabel("-", 320, 560, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label29 = GUICtrlCreateLabel("15th", 350, 515, 40, 28, $SS_CENTER)
	Local $InputE15 = GUICtrlCreateInput($GGElementList[15], 350, 560, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label30 = GUICtrlCreateLabel("16th", 30, 640, 40, 28, $SS_CENTER)
	Local $InputE16 = GUICtrlCreateInput($GGElementList[16], 30, 685, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label31 = GUICtrlCreateLabel("-", 80, 689, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label32 = GUICtrlCreateLabel("17th", 110, 640, 40, 28, $SS_CENTER)
	Local $InputE17 = GUICtrlCreateInput($GGElementList[17], 110, 685, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label33 = GUICtrlCreateLabel("-", 160, 689, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label34 = GUICtrlCreateLabel("18th", 190, 640, 40, 28, $SS_CENTER)
	Local $InputE18 = GUICtrlCreateInput($GGElementList[18], 190, 685, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label35 = GUICtrlCreateLabel("-", 240, 689, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label36 = GUICtrlCreateLabel("19th", 270, 640, 40, 28, $SS_CENTER)
	Local $InputE19 = GUICtrlCreateInput($GGElementList[19], 270, 685, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label37 = GUICtrlCreateLabel("-", 320, 689, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label38 = GUICtrlCreateLabel("20th", 350, 640, 40, 28, $SS_CENTER)
	Local $InputE20 = GUICtrlCreateInput($GGElementList[20], 350, 685, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label39 = GUICtrlCreateLabel("21st", 438, 517, 40, 28, $SS_CENTER)
	Local $InputE21 = GUICtrlCreateInput($GGElementList[21], 438, 562, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label40 = GUICtrlCreateLabel("-", 496, 562, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label41 = GUICtrlCreateLabel("22nd", 526, 517, 40, 28, $SS_CENTER)
	Local $InputE22 = GUICtrlCreateInput($GGElementList[22], 526, 562, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label43 = GUICtrlCreateLabel("23rd", 438, 637, 40, 28, $SS_CENTER)
	Local $InputE23 = GUICtrlCreateInput($GGElementList[23], 438, 682, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label44 = GUICtrlCreateLabel("-", 488, 682, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label45 = GUICtrlCreateLabel("24th", 518, 637, 40, 28, $SS_CENTER)
	Local $InputE24 = GUICtrlCreateInput($GGElementList[24], 518, 682, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label46 = GUICtrlCreateLabel("-", 568, 682, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label47 = GUICtrlCreateLabel("25th", 602, 637, 40, 28, $SS_CENTER)
	Local $InputE25 = GUICtrlCreateInput($GGElementList[25], 602, 682, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				$askSave = MsgBox(1 + 32 + 262144,"","Các thiết lập có thể chưa được lưu, xác nhận thoát?")
				If $askSave = $idcancel Then

				Else
					MsgBox(64 + 262144,"","Vui lòng khởi động lại ứng dụng")
					Exit
				EndIf

			Case $BLoad
				MsgBox(64 + 262144,"Success","This is a joke button." & @CRLF & "Why do you need a Load button meanwhile the data are already loaded? Haha")

			Case $BSave
				IniWrite($config_app,"GoldGlobal","E1",GUICtrlRead($InputE1))
				IniWrite($config_app,"GoldGlobal","E2",GUICtrlRead($InputE2))
				IniWrite($config_app,"GoldGlobal","E3",GUICtrlRead($InputE3))
				IniWrite($config_app,"GoldGlobal","E4",GUICtrlRead($InputE4))
				IniWrite($config_app,"GoldGlobal","E5",GUICtrlRead($InputE5))
				IniWrite($config_app,"GoldGlobal","E6",GUICtrlRead($InputE6))
				IniWrite($config_app,"GoldGlobal","E7",GUICtrlRead($InputE7))
				IniWrite($config_app,"GoldGlobal","E8",GUICtrlRead($InputE8))
				IniWrite($config_app,"GoldGlobal","E9",GUICtrlRead($InputE9))
				IniWrite($config_app,"GoldGlobal","E10",GUICtrlRead($InputE10))
				IniWrite($config_app,"GoldGlobal","E11",GUICtrlRead($InputE11))
				IniWrite($config_app,"GoldGlobal","E12",GUICtrlRead($InputE12))
				IniWrite($config_app,"GoldGlobal","E13",GUICtrlRead($InputE13))
				IniWrite($config_app,"GoldGlobal","E14",GUICtrlRead($InputE14))
				IniWrite($config_app,"GoldGlobal","E15",GUICtrlRead($InputE15))
				IniWrite($config_app,"GoldGlobal","E16",GUICtrlRead($InputE16))
				IniWrite($config_app,"GoldGlobal","E17",GUICtrlRead($InputE17))
				IniWrite($config_app,"GoldGlobal","E18",GUICtrlRead($InputE18))
				IniWrite($config_app,"GoldGlobal","E19",GUICtrlRead($InputE19))
				IniWrite($config_app,"GoldGlobal","E20",GUICtrlRead($InputE20))
				IniWrite($config_app,"GoldGlobal","E21",GUICtrlRead($InputE21))
				IniWrite($config_app,"GoldGlobal","E22",GUICtrlRead($InputE22))
				IniWrite($config_app,"GoldGlobal","E23",GUICtrlRead($InputE23))
				IniWrite($config_app,"GoldGlobal","E24",GUICtrlRead($InputE24))
				IniWrite($config_app,"GoldGlobal","E25",GUICtrlRead($InputE25))

				Sleep(500)
				MsgBox(64 + 262144,"Success","Thiết lập lưu thành công." & @CRLF & "Vui lòng khởi động lại ứng dụng")
				Exit
		EndSwitch
	WEnd
EndFunc
;Gold Global Editor - END

;Rh/Jewelry Editor - START
Func RJEditor()
	Local $RJNoElement = IniRead($config_app,"RhJewelry","No","")
	Local $RJElementList = []
	For $i = 1 to 10
		Local $RJElement = IniRead($config_app,"RhJewelry","E" & $i,"")
		_ArrayAdd($RJElementList,$RJElement)
	Next

	#Region ### START Koda GUI section ### Form=c:\users\dang\onedrive\learning\autoit\fivi\auto-input-calibration-std-set\autoinputstd_gj.kxf
	Local $RJ = GUICreate("Rh/Jewelry Application Editor", 629, 506, -1, -1)
	GUISetIcon("C:\Users\DANG\OneDrive\Helmut Fischer\MKT\Helmut Fischer.ico", -1)
	GUISetFont(12, 400, 0, "Be Vietnam Pro")
	Local $RJLable = GUICtrlCreateLabel("Rh/Jewelry", 30, 0, 509, 126, $SS_CENTER)
	GUICtrlSetFont(-1, 60, 400, 0, "Be Vietnam Pro")
	Local $Label1 = GUICtrlCreateLabel("No. of Element (max 10 elements)", 30, 152, 441, 45)
	GUICtrlSetFont(-1, 20, 400, 0, "Be Vietnam Pro")
	Local $Label2 = GUICtrlCreateLabel("(Outside range, leave it blank)", 30, 208, 241, 28)
	Local $Label3 = GUICtrlCreateLabel("1st", 30, 265, 29, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE1 = GUICtrlCreateInput($RJElementList[1], 30, 310, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label4 = GUICtrlCreateLabel("-", 80, 310, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $InputNoElement = GUICtrlCreateInput($RJNoElement, 480, 152, 121, 49, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 20, 400, 0, "Be Vietnam Pro")
	Local $BLoad = GUICtrlCreateButton("Load", 480, 352, 123, 49, BitOR($BS_DEFPUSHBUTTON,$BS_CENTER))
	GUICtrlSetFont(-1, 20, 400, 0, "Be Vietnam Pro")
	Local $BSave = GUICtrlCreateButton("Save", 480, 428, 123, 49, BitOR($BS_DEFPUSHBUTTON,$BS_CENTER))
	GUICtrlSetFont(-1, 20, 400, 0, "Be Vietnam Pro")
	Local $Label5 = GUICtrlCreateLabel("2nd", 110, 265, 39, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE2 = GUICtrlCreateInput($RJElementList[2], 110, 310, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label6 = GUICtrlCreateLabel("-", 160, 310, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label7 = GUICtrlCreateLabel("3rd", 190, 265, 36, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE3 = GUICtrlCreateInput($RJElementList[3], 190, 310, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label8 = GUICtrlCreateLabel("-", 240, 310, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label9 = GUICtrlCreateLabel("4th", 270, 265, 36, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE4 = GUICtrlCreateInput($RJElementList[4], 270, 310, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label10 = GUICtrlCreateLabel("-", 320, 310, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label11 = GUICtrlCreateLabel("5th", 350, 265, 36, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE5 = GUICtrlCreateInput($RJElementList[5], 350, 310, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label13 = GUICtrlCreateLabel("6th", 30, 390, 36, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE6 = GUICtrlCreateInput($RJElementList[6], 30, 435, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label14 = GUICtrlCreateLabel("-", 75, 435, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label15 = GUICtrlCreateLabel("7th", 110, 390, 34, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE7 = GUICtrlCreateInput($RJElementList[7], 110, 435, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label16 = GUICtrlCreateLabel("-", 160, 435, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label17 = GUICtrlCreateLabel("8th", 190, 390, 35, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE8 = GUICtrlCreateInput($RJElementList[8], 190, 435, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label18 = GUICtrlCreateLabel("-", 240, 435, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label19 = GUICtrlCreateLabel("9th", 270, 390, 36, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE9 = GUICtrlCreateInput($RJElementList[9], 270, 435, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label20 = GUICtrlCreateLabel("-", 320, 435, 17, 36, $SS_CENTER)
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	Local $Label21 = GUICtrlCreateLabel("10th", 350, 390, 43, 33, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 0, "Be Vietnam Pro")
	Local $InputE10 = GUICtrlCreateInput($RJElementList[10], 350, 435, 40, 40, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
	GUICtrlSetFont(-1, 16, 400, 0, "Be Vietnam Pro")
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg1 = GUIGetMsg()
		Switch $nMsg1
			Case $GUI_EVENT_CLOSE ;Khi nhấn tắt cửa sổ
				$askSave = MsgBox(1 + 32 + 262144,"","Các thiết lập có thể chưa được lưu, xác nhận thoát?")
				If $askSave = $idcancel Then

				Else
					MsgBox(64 + 262144,"","Vui lòng khởi động lại ứng dụng")
					Exit
				EndIf

			Case $BLoad ;Khi nhấn Load button
				MsgBox(64 + 262144,"Success","This is a joke button." & @CRLF & "Why do you need a Load button meanwhile the data are already loaded? Haha")

			Case $BSave ;Khi nhấn Save button
				IniWrite($config_app,"RhJewelry","E1",GUICtrlRead($InputE1))
				IniWrite($config_app,"RhJewelry","E2",GUICtrlRead($InputE2))
				IniWrite($config_app,"RhJewelry","E3",GUICtrlRead($InputE3))
				IniWrite($config_app,"RhJewelry","E4",GUICtrlRead($InputE4))
				IniWrite($config_app,"RhJewelry","E5",GUICtrlRead($InputE5))
				IniWrite($config_app,"RhJewelry","E6",GUICtrlRead($InputE6))
				IniWrite($config_app,"RhJewelry","E7",GUICtrlRead($InputE7))
				IniWrite($config_app,"RhJewelry","E8",GUICtrlRead($InputE8))
				IniWrite($config_app,"RhJewelry","E9",GUICtrlRead($InputE9))
				IniWrite($config_app,"RhJewelry","E10",GUICtrlRead($InputE10))

				Sleep(500)
				MsgBox(64 + 262144,"Success","Thiết lập lưu thành công." & @CRLF & "Vui lòng khởi động lại ứng dụng")
				Exit
		EndSwitch
	WEnd
EndFunc
;Rh/Jewelry Editor - END