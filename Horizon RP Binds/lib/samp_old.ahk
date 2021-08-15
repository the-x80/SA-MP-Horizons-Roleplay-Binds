#include lib/san_andreas.ahk


global hSampModule := OpenSampModuleHandle()




OpenSampModuleHandle(){
	if(hSampModule != 0){
		return hSampModule
	}
	
	if(SAProcessHandle == 0){
		SAProcessHandle := OpenProcess("GTA:SA:MP")
	}

	hSampModule := GetModuleBaseAddress("samp.dll", SAProcessHandle)
	return hSampModule
}




GetSAMPChatLine(Line, ByRef Output, timestamp=0, color=0)
{
	chatindex := 0
	FileRead, file, %A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt
	loop, Parse, file, `n, `r
	{
		if(A_LoopField)
			chatindex := A_Index
	}
	loop, Parse, file, `n, `r
	{
		if(A_Index = chatindex - line)
        {
			output := A_LoopField
			break
		}
	}
	file := ""
	if(!timestamp)
		output := RegExReplace(output, "U)^\[\d{2}:\d{2}:\d{2}\]")
	if(!color)
		output := RegExReplace(output, "Ui)\{[a-f0-9]{6}\}")
	return
}
;Returns true if chat is open
GetSampChatState(){
	return false
}
GetSampChatContents(){
	return
}

GetSampPlayerName(){
	
}
GetSampPlayerScore(){
	
}
