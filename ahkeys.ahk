#Persistent
#SingleInstance Force

SetCapsLockState AlwaysOff

Menu Tray, NoStandard
Menu Tray, Tip, Keys
Menu Tray, Add, Quit Keys, Exit

OnExit("useExitFunc")

hotkeyCtrlEnd := "^e"
hotkeyCtrlHome := "^a"
hotkeyCtrlLeft := "^h"
hotkeyCtrlRight := "^j"
hotkeyDown := "j"
hotkeyEnd := "e"
hotkeyHome := "a"
hotkeyLeft := "h"
hotkeyPgDn := "d"
hotkeyPgUp := "u"
hotkeyRight := "l"
hotkeyUp := "k"

global hotkeys
		:= Object(hotkeyCtrlEnd, "^{End}"
		, hotkeyCtrlHome, "^{Home}"
		, hotkeyCtrlLeft, "^{Left}"
		, hotkeyCtrlRight, "^{Right}"
		, hotkeyDown, "{Down}"
		, hotkeyEnd, "{End}"
		, hotkeyHome, "{Home}"
		, hotkeyLeft, "{Left}"
		, hotkeyPgDn, "{PgDn}"
		, hotkeyPgUp, "{PgUp}"
		, hotkeyRight, "{Right}"
		, hotkeyUp, "{Up}")

#If GetKeyState("CapsLock", "P") == 1
{
	for key, action in hotkeys {
		Hotkey % key, send
	}
	F4:: exitapp
}
#If

*CapsLock::
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

useExitFunc() {
	SetCapsLockState Off
}

send() {
	Send % hotkeys[A_ThisHotkey]
}
