ReadProcessMemory(ProcessHandle, MADDRESS, MTYPE = "int", MSIZE = 4)
{
	
	if(ProcessHandle == -1){
		MsgBox, ReadProcessMemory()::Process handle is invalid -1
	}
	if(ProcessHandle == 0){
		MsgBox, ReadProcessMemory()::Process handle is invalid 0
	}
	
	;Single equals operator is used to make the comparrison non case sensitive
	StringCaseSense, Off
	if(MTYPE = "int" || MTYPE = "float"){
		MSIZE := 4
	}
	if(MTYPE = "short"){
		MSIZE := 2
	}
	
	VarSetCapacity(MVALUE,MSIZE,0)
	hResult := DllCall("ReadProcessMemory","UInt",ProcessHandle,"UInt",MADDRESS,"Str",MVALUE,"UInt",MSIZE,"UInt *",&readBytesCount)
	
	if(hResult == 0){
		ErrorCode := ErrorCode := DllCall("GetLastError", "UInt")
		if(ErrorCode := 299){
			;Partial copy error. Not sure how to handle it for now. Just print the error in a MsgBox
			MsgBox, ReadProcessMemory failed. Partial read error. Error code:%ErrorCode%`nProcessHandle:%ProcessHandle%`nAddress:%MADDRESS%`nNaumber of bytes requested:%MSIZE%`nNumber of bytes read:%readBytesCount%
		}else{
			MsgBox, ReadProcessMemory failed. \nProcessHandle:%ProcessHandle%\nAddress:%MADDRESS%\nError code:%ErrorCode%
		}
	}
	
	result := NumGet(MVALUE, MTYPE)
	
	return, result
}

ReadProcessMemoryArray(ProcessHandle, MADDRESS, MTYPE = "int", MCOUNT := 1, MSIZE = 4)
{
	
	if(ProcessHandle == -1){
		MsgBox, ReadProcessMemory()::Process handle is invalid -1
	}
	if(ProcessHandle == 0){
		MsgBox, ReadProcessMemory()::Process handle is invalid 0
	}
	
	;Single equals operator is used to make the comparrison non case sensitive
	StringCaseSense, Off
	if(MTYPE = "int" || MTYPE = "float"){
		MSIZE := 4
	}
	if(MTYPE = "short"){
		MSIZE := 2
	}
	if(MTYPE = "char"){
		MSIZE := 1
	}
	
	loop %MCOUNT%{
		MVALUE := ReadProcessMemory(ProcessHandle, MADDRESS, MTYPE)
		result[A_Index] := NumGet(MVALUE, MTYPE)
	}
	return, result
}

WriteProcessMemory(ProcessHandle, MADDRESS, Value, MTYPE = "int", MSIZE = 4)
{
	VarSetCapacity(finalvalue, MSIZE, 0)
	NumPut(writevalue, finalvalue, 0, MTYPE)
	return DllCall("WriteProcessMemory", "Uint", ProcessHandle, "Uint", address, "Uint", &finalvalue, "Uint", MSIZE, "Uint", 0)
}



MemoryGetAddrPID(PID, DllName)
{
    VarSetCapacity(me32, 548, 0)
    NumPut(548, me32)
    snapMod := DllCall("CreateToolhelp32Snapshot", "Uint", 0x00000008, "Uint", PID)
    if (snapMod = -1)
        Return 0
    if (DllCall("Module32First", "Uint", snapMod, "Uint", &me32))
	{
		Loop
       	{
            If (!DllCall("lstrcmpi", "Str", DllName, "UInt", &me32 + 32)) {
                DllCall("CloseHandle", "UInt", snapMod)
                Return NumGet(&me32 + 20)
            }
        }
		Until !DllCall("Module32Next", "Uint", snapMod, "UInt", &me32)
    }
    DllCall("CloseHandle", "Uint", snapMod)
    Return 0
}