sas_test(playerid, params[])
{
	new weather;
	sscanf(params, "d", weather);
	SetPlayerWeather(playerid, weather);
	#pragma unused params
	return 1;
}

sas_World(playerid, params[])
{
	new worldid;

	if(sscanf(params, "d", worldid)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /world [id]");

	SetPlayerVirtualWorld(playerid, worldid);

	FormatString("* You've entered world %d.", worldid);
	SendClientMessage(playerid, COLOR_INFO, string);

 	return 1;
}

sas_AKA(playerid, params[])
{
	new sPlayer[50], sMessage[128], playerIP[50], AKA[128];

	if(sscanf(params, "s", sPlayer))
	    return SendClientMessage(playerid, COLOR_FALSE, "Usage: /aka [playername]");

	if(!Player::ExistsPlayer(sPlayer))
	    return SendClientMessage(playerid, COLOR_FALSE, "* This account does not exist.");

 	Format(sMessage, "*** AKA's of %s: ***", sPlayer);
	Format(playerIP, "%s", Player::GetUnloadedField(sPlayer, "ip"));

	MySQL_Vars
	MySQL_Format("SELECT username FROM %s WHERE ip = '%s'", Table_users, MySQL::Escape(playerIP));
	MySQL_Query
	MySQL_Result

    SendClientMessage(playerid, COLOR_TITLE, sMessage);

 	MySQL_FetchMultiRows
	{
	    MySQL_FetchRow(AKA, "username");
		SendClientMessage(playerid, COLOR_INFO, AKA);
	}

	MySQL_Free

	return 1;
}

sas_Goto(playerid, params[])
{
	new Float:X, Float:Y, Float:Z, iInterior;
	new iVehicle, worldid;
	
	if(sscanf(params, "fff", X, Y, Z))
	    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /goto [x] [y] [z] [optional:interior]");

	if(sscanf(params, "fffd", X, Y, Z, iInterior))
	    iInterior = GetPlayerInterior(playerid);
	    
    worldid = GetPlayerVirtualWorld(playerid);
	    
	if(IsPlayerInAnyVehicle(playerid))
	{
	    iVehicle = GetPlayerVehicleID(playerid);
		
	    SetVehiclePos(iVehicle, X, Y, Z);
	    LinkVehicleToInterior(iVehicle, iInterior);
	    
     	for(new i = 0; i < MaxSlots; i++)
		{
			if(!IsPlayerInAnyVehicle(i)) continue;

			if(GetPlayerVehicleID(i) == iVehicle)
		    {
		        SetPlayerPos(i, X, Y, Z);
		        SetPlayerVirtualWorld(i, worldid);
		        SetPlayerInterior(i, iInterior);
				PutPlayerInVehicle(i, iVehicle, GetPlayerVehicleSeat(i));
		    }
		}
	}
	else
	{
 		SetPlayerPos(playerid, X, Y, Z);
	    SetPlayerInterior(playerid, iInterior);
	}
	return 1;
}

