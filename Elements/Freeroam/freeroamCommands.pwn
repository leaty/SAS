#define freeroam_alias(%1,%2,%3,%4); if( ( strcmp( cmdtext[1], #%1, true, (%2) ) == 0) && (PlayerInfo[playerid][AdminLevel] >= %3) && ( ( cmdtext[(%2)+1] == 0 && freeroam_%4(playerid,"") ) || ( cmdtext[(%2)+1] == 32 && freeroam_%4(playerid, cmdtext[(%2)+2]) ) ) ) return 1;
#define freeroam_command(%1,%2,%3); freeroam_alias(%1,%2,%3,%1);

Freeroam__OnCommand(playerid, cmdtext[])
{

	freeroam_command(SwitchMode, 	10,     LEVEL_PLAYER);
	freeroam_command(Help,          4,      LEVEL_PLAYER);
	freeroam_command(Prop,		 	4,      LEVEL_PLAYER);
	freeroam_command(Property,   	8,      LEVEL_PLAYER);
	freeroam_command(TP,         	2,      LEVEL_PLAYER);
	freeroam_command(CTP,        	3,      LEVEL_PLAYER);
	freeroam_command(Dive,       	4,      LEVEL_PLAYER);
	freeroam_command(Cardive,    	7,      LEVEL_PLAYER);
	freeroam_command(Ramping,       7,      LEVEL_PLAYER);
	freeroam_command(VR,            2,      LEVEL_PLAYER);
	freeroam_command(VF,            2,      LEVEL_PLAYER);
	freeroam_command(NOS,           3,      LEVEL_PLAYER);
	
	
	return 0;
}


freeroam_SwitchMode(playerid, params[])
{
	if(!IsPlayerAvailable(playerid))
		return SendClientMessage(playerid, COLOR_FALSE, "* You cannot use this command now.");

	Player::ShowDialog(playerid, DIALOG_FREEROAM_SWITCHMODE, DIALOG_STYLE_MSGBOX, "* Switchmode", "Are you sure you want to switch modes?\n \
																							\n ** You will loose any properties you own. \
																							\n ** Money that goes unbanked will be lost.", "Yes", "No");
																							
	#pragma unused params
	return 1;
}

freeroam_TP(playerid, params[])
{
	if(IsPlayerFighting(playerid, 20) && !IsAdmin(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* To prevent laming, you cannot use this command until you've stopped fighting.");
	
	if(!Freeroam::Afford(playerid, TP_MONEY, AFFORD_SKIP))
	    return 1;
	    
	new sPlayer[24], iPlayer, sMessage[128];
	
	if(sscanf(params, "s", sPlayer))
	    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /tp [name/id]");
	    
	iPlayer = ReturnPlayerWithMessage(playerid, sPlayer);

	if(iPlayer == INVALID_PLAYER_ID)
	    return true;
	    
 	if(iPlayer == playerid)
	    return SendClientMessage(playerid, COLOR_FALSE, "* You cannot teleport to yourself!");
	    
	if(!IsFreeroam(iPlayer))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You can only teleport to players who are in the same mode.");
	    
	new Float:X, Float:Y, Float:Z, iInterior;
	GetPlayerPos(iPlayer, X, Y, Z);
	iInterior = GetPlayerInterior(iPlayer);
	
	SetPlayerPos(playerid, X+1, Y, Z);
	SetPlayerInterior(playerid, iInterior);
	
	Format(sMessage, "* %s has teleported to you!", PlayerName(playerid));
	SendClientMessage(iPlayer, COLOR_INFO, sMessage);
	Format(sMessage, "* You've teleported to %s!", PlayerName(iPlayer));
	SendClientMessage(playerid, COLOR_TRUE, sMessage);
	
	if(!IsAdmin(playerid))
		GivePlayerMoney(playerid, -TP_MONEY);
	
	return 1;
}

freeroam_CTP(playerid, params[])
{
	if(IsPlayerFighting(playerid, 20) && !IsAdmin(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* To prevent laming, you cannot use this command until you've stopped fighting.");

	if(!Freeroam::Afford(playerid, CTP_MONEY, AFFORD_SKIP))
	    return 1;

	new sPlayer[24], iPlayer, sMessage[128];

	if(sscanf(params, "s", sPlayer))
	    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /ctp [name/id]");

	iPlayer = ReturnPlayerWithMessage(playerid, sPlayer);

	if(iPlayer == INVALID_PLAYER_ID)
	    return true;
	    
	if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You're not in a vehicle!");

	if(iPlayer == playerid)
	    return SendClientMessage(playerid, COLOR_FALSE, "* You cannot teleport to yourself!");

	if(!IsFreeroam(iPlayer))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You can only teleport to players who are in the same mode.");

	new Float:X, Float:Y, Float:Z, iInt, vID;
	GetPlayerPos(iPlayer, X, Y, Z);
	iInt = GetPlayerInterior(iPlayer);

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

	Format(sMessage, "* %s has car-teleported to you!", PlayerName(playerid));
	SendClientMessage(iPlayer, COLOR_INFO, sMessage);
	Format(sMessage, "* You, the car, and any passengers you had has been car-teleported to %s.", PlayerName(iPlayer));
	SendClientMessage(playerid, COLOR_TRUE, sMessage);
	
	if(!IsAdmin(playerid))
		GivePlayerMoney(playerid, -CTP_MONEY);

	return 1;
}

freeroam_Dive(playerid, params[])
{
	if(IsPlayerFighting(playerid, 20) && !IsAdmin(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* To prevent laming, you cannot use this command until you've stopped fighting.");

	if(!Freeroam::Afford(playerid, DIVE_MONEY, AFFORD_SKIP))
	    return 1;

	if(GetPlayerInterior(playerid) != 0 && !IsAdmin(playerid)) return SendClientMessage(playerid, COLOR_FALSE, "You have to be outside to dive.");



	new Float:X, Float:Y, Float:Z;

	GetPlayerPos(playerid, X, Y, Z);
	SetPlayerPos(playerid,X,Y,Z+500);

	GivePlayerWeapon(playerid,46,1);
	
	if(!IsAdmin(playerid))
		GivePlayerMoney(playerid, -DIVE_MONEY);
	
	#pragma unused params
	return 1;
}

freeroam_Cardive(playerid, params[])
{
	if(IsPlayerFighting(playerid, 20) && !IsAdmin(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* To prevent laming, you cannot use this command until you've stopped fighting.");
	    
	if(!Freeroam::Afford(playerid, CARDIVE_MONEY, AFFORD_SKIP))
	    return 1;

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
	
	if(!IsAdmin(playerid))
		GivePlayerMoney(playerid, -CARDIVE_MONEY);
	
	#pragma unused params
	return 1;
}

freeroam_Ramping(playerid, params[])
{
	if(!Freeroam::Afford(playerid, RAMPING_MONEY, AFFORD_SKIP))
		return 1;
		
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
	    SendClientMessage(playerid, COLOR_TITLE, "*** Ramping DISABLED ***");
	}
	
 	if(!IsAdmin(playerid))
		GivePlayerMoney(playerid, -RAMPING_MONEY);
		
 	#pragma unused params
 	return 1;
}

freeroam_VR(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You have to be in a vehicle to use this command.");
	    
 	if(!Freeroam::Afford(playerid, VR_MONEY, AFFORD_SKIP))
		return 1;

	if( (Now() - UsedTimer[playerid][usedVR] > 60) || UsedTimer[playerid][usedVR] == 0 || IsAdmin(playerid))
	{
    	RepairVehicle(GetPlayerVehicleID(playerid));
		SendClientMessage(playerid, COLOR_TRUE, "* Vehicle repaired!");

    	UsedTimer[playerid][usedVR] = Now();
	}
	else
	{
	    SendClientMessage(playerid, COLOR_FALSE, "* You can only use '/vr' once per minute.");
	}
	
	if(!IsAdmin(playerid))
		GivePlayerMoney(playerid, -VR_MONEY);

	#pragma unused params
	return 1;
}

freeroam_VF(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You have to be in a vehicle to use this command.");
	    
 	if(!Freeroam::Afford(playerid, VF_MONEY, AFFORD_SKIP))
		return 1;

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
	
	if(!IsAdmin(playerid))
		GivePlayerMoney(playerid, -VF_MONEY);

	#pragma unused params
	return 1;
}

freeroam_NOS(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You have to be in a vehicle to use this command.");

	if(!Freeroam::Afford(playerid, NOS_MONEY, AFFORD_SKIP))
		return 1;

	AddVehicleComponent(GetPlayerVehicleID(playerid),1008);

	if(!IsAdmin(playerid))
		GivePlayerMoney(playerid, -NOS_MONEY);

	#pragma unused params
	return 1;
}

