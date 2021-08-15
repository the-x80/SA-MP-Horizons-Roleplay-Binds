#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance
; #Warn  ; Enable warnings to assist with detecting common errors.

#include lib/samp.ahk
#include lib/samp_old.ahk
#include lib/ahk_sock.ahk
#include lib/horizonrp_api.ahk

CharacterJob := ""


SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

OnExit("ScriptExit")

;Main loop
;This is not implemented yet.
;For now the code is not well optimized. 
;There are ways of speeding up the hotkey with whole structure read and then using offsets internally in the script


ScriptExit(ExitReason, ExitCode){
	
}

ReadChatlog(){
	LogText := ""
	FileRead, LogText, *t C:\Users\AMD-PC\Documents\GTA San Andreas User Files\SAMP\chatlog.txt
	return StrSplit(LogText, "`n")
}

UpdateStats(){
	addMessageToChatWindow("Stats update start")
	
	sendChatMessage("/stats")
	Sleep, 500
	
	LogText := ""
	FileRead, LogText, *t C:\Users\AMD-PC\Documents\GTA San Andreas User Files\SAMP\chatlog.txt
	
	LogTextLines := StrSplit(LogText, "`n")
	
	Loop, parse, LogText, `n{
		TextLine := ""
		StringTrimLeft, TextLine, %A_LoopField%, 11
		if(%A_LoopField% == "___________________________________________________________________________________________________" && readStats == false){
			readStats := true
		}
		if(%A_LoopField% == "___________________________________________________________________________________________________" && readStats == true){
			readStats := false
		}
		
		
		
		if(readStats == true){
			
		}
	}
	
	addMessageToChatWindow("Stats update finished")
}

ReadPlayerStats(){
	
}
WritePlayerStats(){
	
}

activatedBinds := true


$1::
if(activatedBinds == false){
	SendInput 1
}


if(isInChat() == true){
	SendInput 1
}else{
	sendChatMessage("/enter")
}
return
$2::
if(activatedBinds == false){
	SendInput 2
}


if(isInChat() == true){
	SendInput 2
}else{
	sendChatMessage("/exit")
}
return



š::
if(IsPlayerInVehicle() == false){
	;Player is on foot
	SendInput t/help{enter}
}else{
	;Player is in vehicle
	if(GetCVehicleEngineState(GetPlayerVehicle()) == 0){
		SendInput t/car engine{enter}
		SendInput t/me turns on the vehicles engine.{enter}
	}else{
		SendInput t/car engine{enter}
		SendInput t/me turns off the vehicles engine.{enter}
	}
}
return


đ::
if(isInChat() == false){
	if(CharacterJob == "ArmsDealer" || CharacterJob == "Craftsman"){
		sendChatMessage("/getmats")
		sendChatMessage("/me sees a package on the floor.")
		sendChatMessage("/me places a bit of cash on the floor and picks the package up.")
	}
	else if(CharacterJob == "Trucker"){
		sendChatMessage("/loadshipment")
	}else{
		sendChatMessage("/me doesent know what to do with her life.")
	}
}else{
	SendInput đ
}
return

č::
if(IsPlayerInVehicle()){
	CurrentVehicleID := GetCVehicleID(GetPlayerVehicle())

	fMass := GetCVehicleHandlingMass(CurrentVehicleID)

	SendInput t/b Current vehicle mass read from handling data is %fMass%
}
return

$ć::
if(isInChat() == false){
	sendChatMessage("/me pulls out a weapon out of the holster")
	sendChatMessage("/me cocks the weapon to ready it for firing")
}else{
	SendInput ć
}
return

$0::
if(isInChat() == false){
	sendChatMessage("/s This is a ROBBERY. Pull over now or we will be forced to open fire.")
}else{
	SendInput 0
}
return

$t::
if(isInChat()==false){
	chatOpen := true
}else{
	
}
SendInput t
return

$Enter::
if(isInChat() == true){
	
	SendInput {LCtrl Down}
	SendInput {A Down}
	Sleep, 50
	SendInput {A Up}
	SendInput {C Down}
	Sleep, 50
	SendInput {C Up}
	SendInput {LCtrl Up}
	
	SendInput {Backspace}
	SendInput {Esc}
	
	
	
	command := StrSplit(Clipboard, " ")
	if(command[1] == ".help"){
		
	}
	else if(command[1] == "/setjob"){
		CharacterJob := command[2]
		addMessageToChatWindow("Job set to " + command[2])
	}
	else if(command[1] == "/update"){
		UpdateStats()
	}
	else if(command[1] == "/getmats"){
		SendInput t/getmats{enter}
		SendInput t/me sees a package on the floor.{enter}
		SendInput t/me places a bit of cash on the floor and picks the package up.{enter}
	}
	else if(command[1] == "lol"){
		SendInput t/me laughs out loudly{enter}
	}
	else{
		SendInput t%Clipboard%
	}
}else{
	
}
SendInput {Enter}
return

$Esc::
if(isInChat() == true){
	chatOpen := false
}
SendInput {Esc}
return

$NumpadDiv::
if(isInChat() == true){
	SendInput /
}
activatedBinds := !activatedBinds
return

