

PerformBuildingEnter(){
	SendChatMessage("/me moves towards the door grabbing the door knob.")
	SendChatMessage("/enter")
	
	;Read memory to figure out what interior id you just entered
}
PerformBuildingExit(){
	SendChatMessage("/me moves towards the door grabbing the door knob.")
	SendChatMessage("/exit")
	
	;Read memory to figure out what interior id you just entered
}


SaveSprunkPosition(){
	;Find the object closest to the player with id of a vending machine
	
	;Save the vending machines position to a file
	
}
FindNearestSprunkPosition(ByRef x, ByRef y, ByRef z){
	
}

