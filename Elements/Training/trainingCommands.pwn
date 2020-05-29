#define training_alias(%1,%2,%3,%4); if( ( strcmp( cmdtext[1], #%1, true, (%2) ) == 0) && (PlayerInfo[playerid][AdminLevel] >= %3) && ( ( cmdtext[(%2)+1] == 0 && training_%4(playerid,"") ) || ( cmdtext[(%2)+1] == 32 && training_%4(playerid, cmdtext[(%2)+2]) ) ) ) return 1;
#define training_command(%1,%2,%3); training_alias(%1,%2,%3,%1);

Training__OnCommand(playerid, cmdtext[])
{

    training_command(SwitchMode,	10,     LEVEL_PLAYER);
	training_command(TP,			2,      LEVEL_PLAYER);
	training_command(CTP,       	3,      LEVEL_PLAYER);
	training_command(Cd, 			2, 		LEVEL_PLAYER);
	training_command(Weps, 			4, 		LEVEL_PLAYER);
	training_command(Fc, 			2, 		LEVEL_PLAYER);
	training_command(Dive,      	4,      LEVEL_PLAYER);
	training_command(Cardive,   	7,      LEVEL_PLAYER);
	training_command(Ramping,       7,      LEVEL_PLAYER);
	training_command(VR,            2,      LEVEL_PLAYER);
	training_command(VF,            2,      LEVEL_PLAYER);
	training_command(NOS,           3,      LEVEL_PLAYER);
	
	
	return 0; // Let it continue the command checking in OnPlayerCommandText
}





training_SwitchMode(playerid, params[])
{
	if(!IsPlayerAvailable(playerid))
		return SendClientMessage(playerid, COLOR_FALSE, "* You cannot use this command now.");

	PlayerInfo[playerid][Switchmode] = true;
	SendClientMessage(playerid, COLOR_INFO, "Returning to mode selection after next death");
	#pragma unused params
	return 1;
}

training_Cd(playerid,params[])
{
	new param = (strval(params));
	new string[128];
	format(string,sizeof(string),"Usage: /cd [2-15]");

	if(strlen(params))
	{
 		if(param >= 2 && param <= 15)
		{
			if(CountDown == -1) {
				CountDown = param + 1;
				SetTimer("countdown",1000,0);
				return SendClientMessageToAll(COLOR_PUBLIC,"*** Countdown is starting...");
			} else return SendClientMessage(playerid,COLOR_FALSE,"ERROR: Countdown in progress.");
		}
  		else
		{
	    	SendClientMessage(playerid,COLOR_USAGE,string);
		}
	}
	else
	{
		SendClientMessage(playerid,COLOR_USAGE,string);
	}
	return 1;
}

forward countdown();
public countdown()
{
	CountDown--;
	if(CountDown==0)
	{
		CountDown = -1;
		for(new i = 0; i < MaxSlots; i++) {
			PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
			GameTextForPlayer(i, "~g~GO~ r~!", 1000, 6);
		}
		return 0;
	}
	else
	{
		new text[7]; format(text,sizeof(text),"~g~%d",CountDown);
		for(new i = 0; i < MaxSlots; i++) {
			PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
			GameTextForPlayer(i, text, 1000, 6);
		}

	}

	SetTimer("countdown",1000,0);
	return 0;
}

training_Weps(playerid, params[])
{
	ShowMenuForPlayer(StartMenu,playerid);
	TogglePlayerControllable(playerid,0);
	#pragma unused params
	return 1;
}

training_Fc(playerid, params[])
{
	new FCNumber, sMessage[128];
	Format(sMessage, "Usage: /fc [1-%d]", FCMax);
	if(sscanf(params, "i", FCNumber)) return SendClientMessage(playerid, COLOR_USAGE, sMessage);

	if(FCNumber < 1 || FCNumber > FCMax) return SendClientMessage(playerid, COLOR_USAGE, "* Invalid FightClub id.");

	FCHandler::Goto(playerid, FCNumber);

	return 1;
}

training_TP(playerid, params[])
{
	new pID;
	
	if(sscanf(params, "d", pID))
	    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /tp [playerid]");
	
	if(!IsPlayerConnected(pID))
	    return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't connected.");
	    
	if(pID == playerid)
	    return SendClientMessage(playerid, COLOR_FALSE, "* You cannot teleport to yourself!");
	    
	if(!IsTraining(pID))
	    return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't in training mode.");

	new sMessage[256];
	new Float:X, Float:Y, Float:Z, iInt;
	GetPlayerPos(pID, X, Y, Z);
	iInt = GetPlayerInterior(pID);
	SetPlayerPos(playerid, X, Y+1, Z);
	SetPlayerInterior(playerid, iInt);
	
	Format(sMessage, "* %s has been teleported to you!", PlayerName(playerid));
	SendClientMessage(pID, COLOR_INFO, sMessage);
	Format(sMessage, "* You've been teleported to %s.", PlayerName(pID));
	SendClientMessage(playerid, COLOR_TRUE, sMessage);
	
	return 1;
}

training_CTP(playerid, params[])
{
	new pID;

	if(sscanf(params, "d", pID))
	    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /ctp [playerid]");

	if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You're not in a vehicle!");

	if(!IsPlayerConnected(pID))
	    return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't connected.");

	if(pID == playerid)
	    return SendClientMessage(playerid, COLOR_FALSE, "* You cannot teleport to yourself!");

	if(!IsTraining(pID) && !IsAdmin(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't in training mode.");

	new sMessage[256];
	new Float:X, Float:Y, Float:Z, iInt, vID;
	GetPlayerPos(pID, X, Y, Z);
	iInt = GetPlayerInterior(pID);
	
	vID = GetPlayerVehicleID(playerid);
	SetVehiclePos(vID, X, Y+2, Z);
	LinkVehicleToInterior(vID, iInt);
	
 	for(new i = 0; i < MaxSlots; i++)
	{
		if(!IsPlayerInAnyVehicle(i)) continue;

		if(GetPlayerVehicleID(i) == vID)
	    {
	        SetPlayerPos(i, X, Y+2, Z);
	        SetPlayerInterior(i, iInt);
			PutPlayerInVehicle(i, vID, GetPlayerVehicleSeat(i));
	    }
	}

	Format(sMessage, "* %s has been car-teleported to you!", PlayerName(playerid));
	SendClientMessage(pID, COLOR_INFO, sMessage);
	Format(sMessage, "* You, the car, and any passengers you had has been car-teleported to %s.", PlayerName(pID));
	SendClientMessage(playerid, COLOR_TRUE, sMessage);
	return 1;
}

training_Dive(playerid, params[])
{
	if(GetPlayerInterior(playerid) != 0 && !IsAdmin(playerid)) return SendClientMessage(playerid, COLOR_FALSE, "You have to be outside to dive.");

	new Float:X, Float:Y, Float:Z;

	GetPlayerPos(playerid, X, Y, Z);
	SetPlayerPos(playerid,X,Y,Z+500);

	GivePlayerWeapon(playerid,46,1);

	#pragma unused params
	return 1;
}

training_Cardive(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_FALSE, "* You're not in a vehicle, you might want to try /dive.");
	if(GetPlayerInterior(playerid) != 0 && !IsAdmin(playerid)) return SendClientMessage(playerid, COLOR_FALSE, "You have to be outside to dive.");

	new Float:X, Float:Y, Float:Z;
	new iVehicleID;

	iVehicleID = GetPlayerVehicleID(playerid);
	GetPlayerPos(playerid, X, Y, Z);

	SetVehiclePos(iVehicleID, X, Y, Z+700);

 	for(new i = 0; i < MaxSlots; i++)
	{
		if(!IsPlayerInAnyVehicle(i)) continue;

		if(GetPlayerVehicleID(i) == iVehicleID)
	    {
	        SetPlayerPos(i, X, Y, Z+700);
			PutPlayerInVehicle(i, iVehicleID, GetPlayerVehicleSeat(i));
	    }
	}

	#pragma unused params
	return 1;
}

training_Ramping(playerid, params[])
{
	if(!PlayerInfo[playerid][Ramping])
	{
		PlayerInfo[playerid][Ramping] = true;

		SendClientMessage(playerid, COLOR_TITLE, "*** Ramping ENABLED ***");
		SendClientMessage(playerid, COLOR_INFO, "** Press CTRL to spawn a ramp");
		SendClientMessage(playerid, COLOR_INFO, "** Use '/my ramp' to set your ramp.");
		SendClientMessage(playerid, COLOR_TITLE, "****************************");
	}
	else
	{
	    PlayerInfo[playerid][Ramping] = false;
	    SendClientMessage(playerid, COLOR_FALSE, "*** Ramping DISABLED ***");
	}
	
	#pragma unused params
	return 1;
}

training_VR(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You have to be in a vehicle to use this command.");
	    
	if( (Now() - UsedTimer[playerid][usedVR]) > 60 || UsedTimer[playerid][usedVR] == 0 || IsAdmin(playerid))
	{
    	RepairVehicle(GetPlayerVehicleID(playerid));
		SendClientMessage(playerid, COLOR_TRUE, "* Vehicle repaired!");
    	
    	UsedTimer[playerid][usedVR] = Now();
	}
	else
	{
	    SendClientMessage(playerid, COLOR_FALSE, "* You can only use '/vr' once per minute.");
	}
	
	#pragma unused params
	return 1;
}

training_VF(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You have to be in a vehicle to use this command.");

	new vehicleid = GetPlayerVehicleID(playerid);

	if( (Now() - UsedTimer[playerid][usedVF]) > 60 || UsedTimer[playerid][usedVF] == 0 || IsAdmin(playerid))
	{
		new Float:X, Float:Y, Float:Z, Float:Angle;
		GetPlayerPos(playerid, X, Y, Z);
		GetVehicleZAngle(vehicleid, Angle);
		SetVehiclePos(vehicleid, X, Y, Z+1);
		SetVehicleZAngle(vehicleid, Angle);
		RepairVehicle(vehicleid);
		SendClientMessage(playerid, COLOR_TRUE, "* Vehicle flipped!");

    	UsedTimer[playerid][usedVF] = Now();
	}
	else
	{
	    SendClientMessage(playerid, COLOR_FALSE, "* You can only use '/vf' once per minute.");
	}

	#pragma unused params
	return 1;
}

training_NOS(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You have to be in a vehicle to use this command.");

	AddVehicleComponent(GetPlayerVehicleID(playerid),1008);
	
	#pragma unused params
	return 1;
}

