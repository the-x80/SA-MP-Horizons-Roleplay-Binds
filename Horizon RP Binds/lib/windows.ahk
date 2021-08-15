#Include lib/memory.ahk

global INVALID_HANDLE_VALUE := -1


OpenProcessByName(PNAME){
	winget, pid, PID, %PNAME%
	
	if(pid == 0){
		MsgBox, Unable to get program name PID
	}
	
	ProcessHandle := DllCall("OpenProcess", "UInt", 0x1F0FFF, "Char", 0, "UInt", pid, "UInt")
	if(ProcessHandle == 0){
		ErrorCode := DllCall("GetLastError", "UInt")
		MsgBox, Open process %PNAME% failed. GetLastError returned %ErrorCode%
	}
	return, ProcessHandle
}

SuspendProcess(hwnd)
{
	return DllCall("ntdll\NtSuspendProcess","uint",hwnd)
}

ResumeProcess(hwnd)
{
	return DllCall("ntdll\NtResumeProcess","uint",hwnd)
}

CloseHandle(HANDLE){
	return DllCall("CloseHandle", "UInt", HANDLE)
}
