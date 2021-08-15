#include lib/windows.ahk



OnExit("ExitCleanup")


ExitCleanup(){
	if(SAProcessHandle != INVALID_HANDLE_VALUE){
		CloseHandle(SAProcessHandle)
	}
	
}



global SAProcessHandle := OpenProcessByName("GTA:SA:MP")
global PlayerPointer := GetPlayerPointer()

global CPedObjectSize := 1988
global CVehicleObjectSize := 2584


GetCheatCodeBuffer(){
	return ReadProcessMemoryArray(SAProcessHandle, 0x969110, "char", 30)
}


GetCPedAddressFromPointer(POINTER){
	if(SAProcessHandle == -1){
		MsgBox, Could not read the CPAddressFromPointer. Process handle returns INVALID_HANDLE_VALUE
		return 0
	}
	return ReadProcessMemory(SAProcessHandle, POINTER)
}
GetCPedPoolSize(){
	if(SAProcessHandle == -1){
		MsgBox, Could not read the CPAddressFromPointer. Process handle returns INVALID_HANDLE_VALUE
		return 0
	}
	PedPoolAddress := ReadProcessMemory(SAProcessHandle, 0xB74490)
	
	
	return ReadProcessMemory(SAProcessHandle, PedPoolAddress + 12)
}
GetCPedAddressFromPool(Index){
	if(SAProcessHandle == -1){
		MsgBox, Could not read the CPAddressFromPointer. Process handle returns INVALID_HANDLE_VALUE
		return 0
	}
	if(Index >= GetCPedPoolSize()){
		return -1
	}
	PedPoolAddress := ReadProcessMemory(SAProcessHandle, 0xB74490)
	FirstPedInPool := ReadProcessMemory(SAProcessHandle, PedPoolAddress+0)
	return FirstPedInPool+(1988*Index)
}
GetPlayerPointer(){
	if(SAProcessHandle == -1){
		MsgBox, Could not read the CPAddressFromPointer. Process handle returns INVALID_HANDLE_VALUE
		return 0
	}
	return ReadProcessMemory(SAProcessHandle, 0xB6F5F0)
}
GetCPedPosition(Index, ByRef xPos, ByRef yPos, ByRef zPos){
	if(SAProcessHandle == -1){
		MsgBox, Could not read the CPAddressFromPointer. Process handle returns INVALID_HANDLE_VALUE
		return 0
	}
	
	PlayerAddress := GetCPedAddressFromPool(Index)
	
	PosStructPointer := ReadProcessMemory(SAProcessHandle, PlayerAddress+0x14)
	
	xPos := ReadProcessMemory(SAProcessHandle, PosStructPointer+0x30, "float")
	yPos := ReadProcessMemory(SAProcessHandle, PosStructPointer+0x34, "float")
	zPos := ReadProcessMemory(SAProcessHandle, PosStructPointer+0x38, "float")
}



GetPlayerStateCheck(){
	return ReadProcessMemory(SAProcessHandle, GetPlayerPointer()+1132) & 0xff
}
IsPlayerInVehicle(){
	CVehiclePoolStart := ReadProcessMemory(SAProcessHandle, 0xB6F980 )
	CVehiclePoolUsage := ReadProcessMemory(SAProcessHandle, 0xB74494 ) 
	CVehiclePoolSize := ReadProcessMemory(SAProcessHandle, CVehiclePoolUsage + 12) 
	
	loop, %CVehiclePoolSize%{
		VehicleIndex := A_Index-1
		DriverPointer := ReadProcessMemory(SAProcessHandle, CVehiclePoolStart + (CVehicleObjectSize * VehicleIndex) + 1120)
		if(DriverPointer == PlayerPointer){
			return true
		}
		
		loop, 9{
			SeatIndex := A_Index-1
			PassengerPointer := ReadProcessMemory(SAProcessHandle, CVehiclePoolStart + (CVehicleObjectSize * (VehicleIndex-1)) + 1124 + SeatIndex*4)
			if(PassengerPointer == PlayerPointer){
				return true
			}
		}
	}
	
	return false
}
GetPlayerVehicle(){
	CVehiclePoolStart := ReadProcessMemory(SAProcessHandle, 0xB6F980 )
	CVehiclePoolUsage := ReadProcessMemory(SAProcessHandle, 0xB74494 ) 
	CVehiclePoolSize := ReadProcessMemory(SAProcessHandle, CVehiclePoolUsage + 12) 
	
	loop, %CVehiclePoolSize%{
		VehicleIndex := A_Index-1
		DriverPointer := ReadProcessMemory(SAProcessHandle, CVehiclePoolStart + (CVehicleObjectSize * VehicleIndex) + 1120)
		if(DriverPointer == PlayerPointer){
			return CVehiclePoolStart + (CVehicleObjectSize * VehicleIndex)
		}
		
		loop, 9{
			SeatIndex := A_Index-1
			PassengerPointer := ReadProcessMemory(SAProcessHandle, CVehiclePoolStart + (CVehicleObjectSize * (VehicleIndex-1)) + 1124 + SeatIndex*4)
			if(PassengerPointer == PlayerPointer){
				return CVehiclePoolStart + (CVehicleObjectSize * VehicleIndex)
			}
		}
	}
	
	return 0
}




GetCVehicle(Index){
	CVehiclePoolStart := ReadProcessMemory(SAProcessHandle, 0xB6F980 )
	CVehiclePoolUsage := ReadProcessMemory(SAProcessHandle, 0xB74494 ) 
	CVehiclePoolSize := ReadProcessMemory(SAProcessHandle, CVehiclePoolUsage + 12) 
	
	if(Index >= CVehiclePoolSize){
		return -1
	}
	
	return CVehiclePoolStart + (CVehicleObjectSize * Index)
}

GetCVehicleID(ADDRESS){
	return ReadProcessMemory(SAProcessHandle, ADDRESS+34, "Short")
}

GetCVehiclePos(ADDRESS, ByRef xPos, ByRef yPos, ByRef zPos){
	TransformStructure := ReadProcessMemory(SAProcessHandle, ADDRESS + 20)
	
	xPos := ReadProcessMemory(SAProcessHandle, TransformStructure+48, "float")
	yPos := ReadProcessMemory(SAProcessHandle, TransformStructure+52, "float")
	zPos := ReadProcessMemory(SAProcessHandle, TransformStructure+56, "float")
}
GetCVehicleRot(ADDRESS, ByRef xRot, ByRef yRot, ByRef zRot){
	TransformStructure := ReadProcessMemory(SAProcessHandle, ADDRESS + 20)
	
	xRot := ReadProcessMemory(SAProcessHandle, TransformStructure+0) * 0.900000000000001
	yRot := ReadProcessMemory(SAProcessHandle, TransformStructure+4) * 0.900000000000001
	zRot := ReadProcessMemory(SAProcessHandle, TransformStructure+8) * 0.900000000000001
}
GetCVehicleVelocity(ADDRESS, ByRef xVel, ByRef yVel, ByRef zVel){
	TransformStructure := ReadProcessMemory(SAProcessHandle, ADDRESS + 20)
	
	xVel := ReadProcessMemory(SAProcessHandle, ADDRESS+68)
	yVel := ReadProcessMemory(SAProcessHandle, ADDRESS+72)
	zVel := ReadProcessMemory(SAProcessHandle, ADDRESS+76)
}

GetCVehicleEngineState(ADDRESS){
	result := ReadProcessMemory(SAProcessHandle, ADDRESS+1064, "char", 1)
	engineState := (result&16)>>4
	return engineState
}
GetCVehicleLightsState(ADDRESS){
}
GetCVehicleDoorState(ADDRESS, DOORID){
	
}
GetCVehicleBonnetState(ADDRESS){
}
GetCVehicleBootState(ADDRESS){
}

GetCVehicleHealth(ADDRESS){
	return ReadProcessMemory(SAProcessHandle, ADDRESS+1216, "float")
}

;Handling
GetCVehicleHandling(VEHICLEID){
	FileRead, fData, data/vehid.csv
	VehicleIDs := StrSplit(StrReplace(fData, " "), ",")
	VehicleCount := VehicleIDs.MaxIndex()
		
	loop %VehicleCount%{
		CurrentVehicleID := ReadProcessMemory(SAProcessHandle, 0xC2B9DC + (224 * (A_Index-1)), "int")
		
		if(CurrentVehicleID != (VEHICLEID-400)){
			continue
		}
		
		handlingAddr := 0xC2B9DC + (224 * (A_Index-1))
		
		return 0xC2B9DC + (224 * (A_Index-1))
	}
	return -1
}
GetCVehicleHandlingMass(VEHICLEID){
	return ReadProcessMemory(SAProcessHandle, GetCVehicleHandling(VEHICLEID) + 0x4, "float")
}
GetCVehicleHandlingTurnMass(VEHICLEID){
	return ReadProcessMemory(SAProcessHandle, GetCVehicleHandling(VEHICLEID) + 0xC, "float")
}
GetCVehicleHandlingDragMulty(VEHICLEID){
	return ReadProcessMemory(SAProcessHandle, GetCVehicleHandling(VEHICLEID) + 0x10, "float")
}