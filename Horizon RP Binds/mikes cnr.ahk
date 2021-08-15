#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#include lib/samp.ahk


fpslimit := 90



š::
SendInput t/gps player TankerAndrej
return

đ::
if(fpslimit == 90){
	fpslimit := 20
	SendInput t/fpslimit %fpslimit%{enter}
}else{
	fpslimit := 90
	SendInput t/fpslimit %fpslimit%{enter}
}
Sleep, 50
return

č::
SendInput t/hideout{enter}
return