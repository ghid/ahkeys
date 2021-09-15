#Persistent
#SingleInstance Force
ListLines Off
SetBatchLines -1
SetKeyDelay -1

#Include <Object>
#Include <System>

#IncludeAgain *i %A_AppData%\AHKeys-extensions.ahk

SetCapsLockState AlwaysOff

; Menu Tray, NoStandard
Menu Tray, Tip, Keys
Menu Tray, Add, Quit AHKeys, Exit

OnExit("useExitFunc", 1)

hotkeys := initHotkeys()

; See also: https://kbdlayout.info/kbdgr/scancodes
; ahklint-ignore-begin:W004,I001
<^>!SC01E::Send ä
<^>!+SC01E::Send Ä
<^>!SC016::Send ü
<^>!+SC016::Send Ü
<^>!SC018::Send ö
<^>!+SC018::Send Ö
<^>!SC01F::Send ß
+SC00B::Send *
SC00C::Send -
+SC00C::Send _
SC00D::Sendraw % "+"
+SC00D::Send % "="
SC01A::Send [
+SC01A::Sendraw {
SC01B::Send ]
+SC01B::Sendraw }
SC027::Send % ";"
+SC027::Send :
SC028::Send '
+SC028::Send "
+SC02B::Send ~
SC056::Send \
+SC056::Send |
+SC033::Send <
+SC034::Send >
SC035::Send /
+SC035::Send ?
; ahklint-ignore-end

*CapsLock::
    OutputDebug % Format("CapsLock: {:s} Hotkey: {:s} Prior Hotkey: {:s}"
            , GetKeyState("CapsLock", "T"), A_ThisHotkey, A_PriorHotkey)
	if (A_ThisHotkey == A_PriorHotkey
			&& A_TimeSincePriorHotkey < 300
			&& A_TimeSincePriorHotkey > 100
			&& A_TimeSincePriorHotkey != 250) {
		if GetKeyState("CapsLock", "T") {
			SetCapsLockState Off
		} else {
			SetCapsLockState On
		}
	}
Return

Exit:
ExitApp

initHotkeys() {
	hotkeys := getAvailableMappings()
	for key, action in hotkeys {
		OutputDebug %key% -> %action%
		Hotkey % key, send
	}
	return hotkeys
}

getAvailableMappings() {
	ahkeysRcFile := System.which(""
			, [A_WorkingDir, A_AppData, A_AppDataCommon]
			, "ahkeysrc")
	if (ahkeysRcFile == "") {
		hotkeys := defaultMappings()
		Object.serialize(hotkeys, A_AppData "\.ahkeysrc")
	} else {
		hotkeys := Object.deserialize(ahkeysRcFile)
	}
	return hotkeys
}

defaultMappings() {
	mappings := Object("^e", "^{End}"
			, "^a", "^{Home}"
			, "^h", "^{Left}"
			, "^j", "^{Right}"
			, "j", "{Down}"
			, "e", "{End}"
			, "a", "{Home}"
			, "h", "{Left}"
			, "d", "{PgDn}"
			, "u", "{PgUp}"
			, "l", "{Right}"
			, "k", "{Up}"
			, "F1", "%helpAHKeys"
			, "F4", "%quitAHKeys")
	return mappings
}

useExitFunc() {
    OutputDebug %A_ThisFunc%
	SetCapsLockState Off
    ; showWindowsTerminal(A_DetectHiddenWindows)
}

send() {
	global hotkeys
	#If GetKeyState("CapsLock", "P") == 1
	{
		action := hotkeys[A_ThisHotkey]
		if (SubStr(action, 1, 1) != "%") {
			Send % hotkeys[A_ThisHotkey]
			sleep 1
			return
		}
		OutputDebug % SubStr(action, 2)
		Func(SubStr(action, 2)).call()
		return
	}
	Send %A_ThisHotkey%
}

quitAHKeys() {
	exitapp
}

helpAHKeys() {
    global hotkeys
    keyInfo := "Leader key: CapsLock`n"
	for key, action in hotkeys {
		OutputDebug %key% -> %action%
        keyInfo .= "`n" key ": " action
	}
	MsgBox % keyInfo
}
