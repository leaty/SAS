sas_Hax(playerid, params[])
{
	new sMessage[128];
	
	if(PlayerInfo[playerid][Hax] == true)
	{
	    PlayerInfo[playerid][Hax] = false;
		Godmode::God(playerid);
		
	    Format(sMessage, "%s has disabled his/her HAX.", PlayerName(playerid));
 	}
 	else if(PlayerInfo[playerid][Hax] == false)
 	{
  		PlayerInfo[playerid][Hax] = true;
		Godmode::God(playerid);
  				
	    Format(sMessage, "%s has enabled his/her HAX.", PlayerName(playerid));
 	}
 	
  	SendAdminMsg(sMessage);
  	
  	#pragma unused params
  	return 1;
}

sas_Hardcore(playerid, params[])
{
	new Float:HP, Float:Arm;
	GetPlayerHealth(playerid, HP);
	GetPlayerArmour(playerid, Arm);
	
	if(!PlayerInfo[playerid][Hardcore])
	{
	    PlayerInfo[playerid][HC_HP] = HP;
	    PlayerInfo[playerid][HC_ARM] = Arm;
	    PlayerInfo[playerid][Hardcore] = 1;
	    SendClientMessage(playerid, COLOR_FALSE, "* HARDCORE MODE ENABLED.");
 	}
 	else if(PlayerInfo[playerid][Hardcore])
 	{
	    PlayerInfo[playerid][Hardcore] = 0;
	    PlayerInfo[playerid][HC_HP] = 100.0;
	    PlayerInfo[playerid][HC_ARM] = 100.0;
	    SendClientMessage(playerid, COLOR_FALSE, "* HARDCORE MODE DISABLED.");
 	}
	#pragma unused params
	return 1;
}

sas_God(playerid, params[])
{
	new pID, sMessage[256];
	
	if(sscanf(params, "d", pID))
	{
		if(PlayerInfo[playerid][IsGod] == true)
		{
			Godmode::Ungod(playerid);
		    Format(sMessage, "%s has disabled his/her GODMODE.", PlayerName(playerid));
		    SendAdminMsg(sMessage);
			SendClientMessage(playerid, COLOR_TRUE, "* You've disabled your GODMODE.");
		}
		else if(PlayerInfo[playerid][IsGod] == false)
		{
		    Godmode::God(playerid);
		    Format(sMessage, "%s has enabled his/her GODMODE.", PlayerName(playerid));
		    SendAdminMsg(sMessage);
			SendClientMessage(playerid, COLOR_TRUE, "* You've enabled your GODMODE.");
		}
	}
	else
	{
 		if(PlayerInfo[pID][IsGod] == true)
		{
			Godmode::Ungod(pID);
		    Format(sMessage, "%s has disabled %s's GODMODE.", PlayerName(playerid), PlayerName(pID));
		    SendAdminMsg(sMessage);
		}
		else if(PlayerInfo[pID][IsGod] == false)
		{
		    Godmode::God(pID);
		    Format(sMessage, "%s has enabled %s's GODMODE.", PlayerName(playerid), PlayerName(pID));
		    SendAdminMsg(sMessage);
		}
	}
	return 1;
}

sas_V(playerid, params[])
{
    new sOption[50];
    
    if(sscanf(params, "s", sOption))
	{
		SendClientMessage(playerid, COLOR_TITLE, "Usage: /v [action]");
        SendClientMessage(playerid, COLOR_INFO,  "spawn, fetch");
		SendClientMessage(playerid, COLOR_INFO,  "delete, break, cleanup");
        return 1;
 	}
    else if(strcmp(sOption, "spawn", true, 5) == 0)
    {
    	if(!IsManagement(playerid)) return SendClientMessage(playerid, COLOR_FALSE, "* Only management can spawn vehicles. Try /v fetch.");
    	
        new sCarName[50];
        
		if(sscanf(params, "ss", sOption, sCarName)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /v spawn [car name]");

		if(TempVehicles >= MAX_TEMP_VEHICLES)
		    return SendClientMessage(playerid, COLOR_FALSE, "* You cannot spawn more temporary vehicles.");
		
		new vehicle = Vehicle::GetModelFromName(sCarName);
	    if(vehicle < 400 || vehicle > 611) return SendClientMessage(playerid, COLOR_FALSE, "Invalid vehicle name!");

		if(IsPlayerInAnyVehicle(playerid))
		    RemovePlayerFromVehicle(playerid);

		new Float:spawnX, Float:spawnY, Float:spawnZ, wID, vID, Int;

		wID = GetPlayerVirtualWorld(playerid);
		Int = GetPlayerInterior(playerid);
	    GetPlayerPos(playerid, spawnX, spawnY, spawnZ);
	    new tempVeh = CreateVehicle(vehicle, spawnX, spawnY, spawnZ+2, 90, -1, -1, 100);
	    
	    TempVehicle[TempVehicles++] = tempVeh;

		PutPlayerInVehicle(playerid, tempVeh, 0);
	    vID = GetPlayerVehicleID(playerid);
	    SetVehicleVirtualWorld(vID, wID);
		LinkVehicleToInterior(vID, Int);
	    PutPlayerInVehicle(playerid, tempVeh, 0);

	   	FormatString("%s has spawned a(n) %s on his/her location.", PlayerName(playerid), VehicleNames[vehicle - 400]);
	   	SendAdminMsg(string);

        return 1;
    }
    else if(strcmp(sOption, "fetch", true, 5) == 0)
	{
        new sCarName[50], sMessage[256], Float:X, Float:Y, Float:Z, iInterior, iWorld, iVehicle, iModel;
		if(sscanf(params, "ss", sOption, sCarName)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /v fetch [car name]");

		iVehicle = Vehicle::GetPermVehicleID(sCarName);
		
		if(iVehicle == -1)
		    return SendClientMessage(playerid, COLOR_FALSE, "* No matches found, or the last vehicle of it's kind is already being used by someone else.");
		    
		iModel = Vehicles_Data[Vehicle::GetPermArrayID(iVehicle)][0] - 400;
		    
		if(IsPlayerInAnyVehicle(playerid))
		    RemovePlayerFromVehicle(playerid);

		GetPlayerPos(playerid, X, Y, Z);
		iInterior = GetPlayerInterior(playerid);
		iWorld = GetPlayerVirtualWorld(playerid);
		
		SetVehiclePos(iVehicle, X, Y, Z+2);
		SetVehicleVirtualWorld(iVehicle, iWorld);
		LinkVehicleToInterior(iVehicle, iInterior);
		RepairVehicle(iVehicle);
		
		PutPlayerInVehicle(playerid, iVehicle, 0);
		
 		Format(sMessage, "%s has fetched a(n) %s to his/her location.", PlayerName(playerid), VehicleNames[iModel]);
		SendAdminMsg(sMessage);

		return 1;
	}
	else if(strcmp(sOption, "delete", true, 6) == 0)
	{
	    if(!IsPlayerInAnyVehicle(playerid))
	        return SendClientMessage(playerid, COLOR_FALSE, "* You have to be inside the vehicle you want to remove.");

		new VehicleID, sMessage[256];

		VehicleID = GetPlayerVehicleID(playerid);
	        
		if(!Vehicle::IsTemp(VehicleID))
		    return SendClientMessage(playerid, COLOR_FALSE, "* This isn't a temporary vehicle. You can use '/v break' to respawn this vehicle.");

		TempVehicles--;
		DestroyVehicle(TempVehicle[VehicleID]);
		Format(sMessage, "%s used 'delete' on a temporary vehicle (%d).", PlayerName(playerid), VehicleID);
		
		return 1;
	}
	else if(strcmp(sOption, "break", true, 5) == 0)
	{
 		if(!IsPlayerInAnyVehicle(playerid))
	        return SendClientMessage(playerid, COLOR_FALSE, "* You have to be inside the vehicle you want to respawn.");

		new VehicleID, sMessage[256];
		VehicleID = GetPlayerVehicleID(playerid);
		SetVehicleToRespawn(VehicleID);
		
		Format(sMessage, "%s used 'break' on vehicle %d.", PlayerName(playerid), VehicleID);
		SendAdminMsg(sMessage);
	}
	else if(strcmp(sOption, "cleanup", true, 7) == 0)
	{
		new sMessage[256];
		
	    for(new i = 0; i < MAX_TEMP_VEHICLES; i++)
	    {
	        DestroyVehicle(TempVehicle[i]);
	    }
	    
	    TempVehicles = 0;
	    
   		Format(sMessage, "%s destroyed all temporary created vehicles.", PlayerName(playerid));
		SendAdminMsg(sMessage);
	}
	else if(strcmp(sOption, "f", true, 1) == 0)
 	{
 	    new sMessage[256], sCrap[10], iPlayer;
 	    
		if(sscanf(sOption, "sd", sCrap, iPlayer))
		{
            if(PlayerInfo[playerid][VehFunct] == true)
			{
			    PlayerInfo[playerid][VehFunct] = false;
			    Format(sMessage, "%s turned off his/her vehicle functions.", PlayerName(playerid));
			    SendAdminMsg(sMessage);
			    SendClientMessage(playerid, COLOR_TRUE, "* Your vehicle functions was turned off.");
			}
			else
			{
			    PlayerInfo[playerid][VehFunct] = true;
			    Format(sMessage, "%s turned on his/her vehicle functions.", PlayerName(playerid));
			    SendAdminMsg(sMessage);
			    SendClientMessage(playerid, COLOR_TRUE, "* Your vehicle functions was turned on.");
			}
		}
		else
		{
            if(PlayerInfo[iPlayer][VehFunct] == true)
			{
			    PlayerInfo[iPlayer][VehFunct] = false;
			    Format(sMessage, "%s turned off %s's vehicle functions.", PlayerName(playerid), PlayerName(iPlayer));
			    SendAdminMsg(sMessage);
			    SendClientMessage(iPlayer, COLOR_TRUE, "* Your vehicle functions was turned off.");
			}
			else
			{
			    PlayerInfo[iPlayer][VehFunct] = true;
			    Format(sMessage, "%s turned on %s's vehicle functions.", PlayerName(playerid), PlayerName(iPlayer));
			    SendAdminMsg(sMessage);
			    SendClientMessage(iPlayer, COLOR_TRUE, "* Your vehicle functions was turned on.");
			}
		}
 	}
    else
    {
  		SendClientMessage(playerid, COLOR_TITLE, "Usage: /v [action]");
        SendClientMessage(playerid, COLOR_INFO, "spawn, fetch, delete, break, cleanup");
    }
    
	return 1;
}

sas_F(playerid, params[])
{
	new id;

	if(sscanf(params, "d", id)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /f [playerid]");

	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_FALSE, "* Invalid playerid.");

	new Float:X, Float:Y, Float:Z;
	new worldid, Int;
	GetPlayerPos(playerid, X, Y, Z);
	worldid = GetPlayerVirtualWorld(playerid);
	Int = GetPlayerInterior(playerid);

	SetPlayerPos(id, X, Y, Z+2);
	SetPlayerVirtualWorld(id, worldid);
	SetPlayerInterior(id, Int);

	SendClientMessage(id, COLOR_INFO, "* You've been fetched by an administrator.");

	FormatString("%s fetched %s.", PlayerName(playerid), PlayerName(id));
	SendAdminMsg(string);

    return 1;
}

sas_Cf(playerid, params[])
{
	new id;

	if(sscanf(params, "d", id)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /cf [playerid]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_FALSE, "* Invalid playerid.");
	if(!IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't in any vehicle.");
	if(GetPlayerVehicleSeat(id) != 0) return SendClientMessage(playerid, COLOR_FALSE, "* This player is a passenger, carfetch denied.");

	new Float:X, Float:Y, Float:Z;
	new VehicleID, worldid, Int;

	GetPlayerPos(playerid, X, Y, Z);
	worldid = GetPlayerVirtualWorld(playerid);
	Int = GetPlayerInterior(playerid);

	VehicleID = GetPlayerVehicleID(id);

	SetVehiclePos(VehicleID, X, Y, Z+2);
	SetVehicleVirtualWorld(VehicleID, worldid);
	LinkVehicleToInterior(VehicleID, Int);

	for(new i = 0; i < MaxSlots; i++)
	{
		if(!IsPlayerInAnyVehicle(i)) continue;

		if(GetPlayerVehicleID(i) == VehicleID)
	    {
	        SetPlayerPos(i, X, Y, Z+2);
	        SetPlayerVirtualWorld(i, worldid);
	        SetPlayerInterior(i, Int);
			PutPlayerInVehicle(i, VehicleID, GetPlayerVehicleSeat(i));
	    }
	}

	SendClientMessage(id, COLOR_INFO, "* You, the car, and any passengers you had has been fetched by an administrator.");

	FormatString("%s carfetched %s.", PlayerName(playerid), PlayerName(id));
	SendAdminMsg(string);

	return 1;
}

sas_Move(playerid, params[])
{
	new Coord[1], gVal[100], Val;
	new Float:X, Float:Y, Float:Z;
	if(sscanf(params, "ss", Coord, gVal)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /move [x/y/z] [amount]");

	GetPlayerPos(playerid, X, Y, Z);


	if(IsPlayerInAnyVehicle(playerid))
	{
	    new iVehicleID;
	    iVehicleID = GetPlayerVehicleID(playerid);
	    
   		if(gVal[0] == '-')
		{
		    Val = strval(gVal[1]);
	   		if(Val == 0) return SendClientMessage(playerid, COLOR_FALSE, "How is that going to help?");

			if(Coord[0] == 'x') SetVehiclePos(iVehicleID, X-Val, Y, Z);
			if(Coord[0] == 'y') SetVehiclePos(iVehicleID, X, Y-Val, Z);
			if(Coord[0] == 'z') SetVehiclePos(iVehicleID, X, Y, Z-Val);
		}
		else
		{
		    Val = strval(gVal);
			if(Val == 0) return SendClientMessage(playerid, COLOR_FALSE, "How is that going to help?");

			if(Coord[0] == 'x' && Val > 0) SetVehiclePos(iVehicleID, X+Val, Y, Z);
			if(Coord[0] == 'y' && Val > 0) SetVehiclePos(iVehicleID, X, Y+Val, Z);
			if(Coord[0] == 'z' && Val > 0) SetVehiclePos(iVehicleID, X, Y, Z+Val);
		}
		
 		for(new i = 0; i < MaxSlots; i++)
		{
			if(!IsPlayerInAnyVehicle(i)) continue;

			if(GetPlayerVehicleID(i) == iVehicleID)
		    {
				PutPlayerInVehicle(i, iVehicleID, GetPlayerVehicleSeat(i));
		    }
		}
	}
	else
 	{
		if(gVal[0] == '-')
		{
		    Val = strval(gVal[1]);
	   		if(Val == 0) return SendClientMessage(playerid, COLOR_FALSE, "How is that going to help?");

			if(Coord[0] == 'x') SetPlayerPos(playerid, X-Val, Y, Z);
			if(Coord[0] == 'y') SetPlayerPos(playerid, X, Y-Val, Z);
			if(Coord[0] == 'z') SetPlayerPos(playerid, X, Y, Z-Val);
		}
		else
		{
		    Val = strval(gVal);
			if(Val == 0) return SendClientMessage(playerid, COLOR_FALSE, "How is that going to help?");

			if(Coord[0] == 'x' && Val > 0) SetPlayerPos(playerid, X+Val, Y, Z);
			if(Coord[0] == 'y' && Val > 0) SetPlayerPos(playerid, X, Y+Val, Z);
			if(Coord[0] == 'z' && Val > 0) SetPlayerPos(playerid, X, Y, Z+Val);
		}
	}
	return 1;
}

sas_APM(playerid, params[])
{
	if(APM == true)
	{
		APM = false;
		
		SendClientMessageToAll(COLOR_FALSE, "==========================================");
		SendClientMessageToAll(COLOR_INFO,  "The announcement is over, you can now speak again!");
		SendClientMessageToAll(COLOR_INFO,  "We are very sorry for any inconvenience, thank you for your time.");
		SendClientMessageToAll(COLOR_FALSE, "==========================================");
	}
	else if(APM == false)
	{
	    APM = true;

   		for(new i = 0; i < MaxSlots; i++)
			ClearPlayerChat(i);


		SendClientMessageToAll(COLOR_FALSE, "==========================================");
		SendClientMessageToAll(COLOR_INFO,  "An administrator is going to give an important announcement.");
		SendClientMessageToAll(COLOR_INFO, 	"During this period, you will not be able to speak.");
		SendClientMessageToAll(COLOR_INFO,  "Please concentrate on listening for a little while.");
		SendClientMessageToAll(COLOR_FALSE, "==========================================");
	}
	
	#pragma unused playerid, params
	return 1;
}

// Administrators only have access on the testserver
sas_Create(playerid, params[])
{
	new Option[50];

	#if TEST == 0
        if(sscanf(params, "s", Option)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /create [fc/pickup/property]");
	#elseif TEST == 1
		if(sscanf(params, "s", Option)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /create [fc/pickup/property/spawn/vehicle/bank/atm]");
	#endif

	if(strcmp(Option, "fc", true, 2) == 0)
	{
		if(!IsManagement(playerid))
	        return SendClientMessage(playerid, COLOR_FALSE, "* Only management can create this.");

		new FCName[256], sMessage[256];

		if(sscanf(params, "ss", Option, FCName)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /create fc [fcname]");

		if(FCHandler::Create(FCName, playerid))
		{
			Format(sMessage, "%s has successfully created FC '%s' (ID: %d).", PlayerName(playerid), FCName, FCMax);
			SendAdminMsg(sMessage);

			Format(sMessage, "FightClub '%s' was just created, type /fc %d to check it out!", FCName, FCMax);
   			SendNews(sMessage);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_FALSE, "* Something wen't wrong, the new FightClub was not created.");
		}
	}
	else if(strcmp(Option, "pickup", true, 6) == 0)
	{
 		if(!IsManagement(playerid))
	        return SendClientMessage(playerid, COLOR_FALSE, "* Only management can create this.");

	    new modelname[10];
		new modelid;
	    if(sscanf(params, "ss", Option, modelname)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /create pickup [health/armour]");

		if(strcmp(modelname, "health", true, 6) == 0) modelid = 1240;
		else if(strcmp(modelname, "armour", true, 6) == 0) modelid = 1242;
		else return SendClientMessage(playerid, COLOR_USAGE, "Usage: /create pickup [health/armour]");

		Pickups::Create(playerid, modelid);

		FormatString("%s has successfully created a Pickup.", PlayerName(playerid));
		SendAdminMsg(string);

		SendClientMessage(playerid, COLOR_TRUE, "* Pickup created and added to database.");
	}
	else if(strcmp(Option, "property", true, 8) == 0)
	{
	    if(!IsManagement(playerid))
	        return SendClientMessage(playerid, COLOR_FALSE, "* Only management can create this.");

		new sMessage[256], PropName[128], prize, earn;

		if(sscanf(params, "sdds", Option, prize, earn, PropName))
		    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /create property [prize] [earnings] [name]");

		if(strlen(PropName) > 128)
		    return SendClientMessage(playerid, COLOR_FALSE, "* Property name too long, max 128 characters.");

		if(!Property::Create(playerid, PropName, prize, earn))
		    return SendClientMessage(playerid, COLOR_FALSE, "* Oops, something went wrong, the property was not saved to the database.");

		Format(sMessage, "%s created a new property called %s.", PlayerName(playerid), PropName);
		SendAdminMsg(sMessage);

		SendClientMessage(playerid, COLOR_TRUE, "* Success! Property with the following data was added to the database:");
		Format(sMessage, "Name: %s", PropName);
		SendClientMessage(playerid, COLOR_INFO, sMessage);
		Format(sMessage, "Prize: $ %s", ConvertMoney(prize));
		SendClientMessage(playerid, COLOR_INFO, sMessage);
		Format(sMessage, "Earnings: $ %s", ConvertMoney(earn));
		SendClientMessage(playerid, COLOR_INFO, sMessage);
	}
	#if TEST == 1
		else if(strcmp(Option, "spawn", true, 5) == 0)
		{
		    new Float:X, Float:Y, Float:Z, Float:Angle, iInterior;
		    new sSpawnString[256], sMessage[128], filename[128], File:spawn;

			GetPlayerPos(playerid, X, Y, Z);
			GetPlayerFacingAngle(playerid, Angle);

			iInterior = GetPlayerInterior(playerid);

			filename = "/other/spawns.txt";
			spawn = fopen(filename, io_append);

			Format(sSpawnString, "{ %f, %f, %f, %f },\n", X, Y, Z, Angle);
	        fwrite(spawn, sSpawnString);
			fclose(spawn);

			filename = "/other/spawns_data.txt";
			spawn = fopen(filename, io_append);

			Format(sSpawnString, "{ %d },\n", iInterior);
	        fwrite(spawn, sSpawnString);
			fclose(spawn);

			Format(sMessage, "%s has successfully saved a spawn.", PlayerName(playerid));
			SendAdminMsg(sMessage);
		}
	 	else if(strcmp(Option, "vehicle", true, 7) == 0)
		{
		    new Float:X, Float:Y, Float:Z, Float:Angle, iVehicle, iInterior, iWorld, iModel;
		    new sVehicleString[256], sMessage[128], filename[128], File:vehicle;

			if(!IsPlayerInAnyVehicle(playerid))
			    return SendClientMessage(playerid, COLOR_FALSE, "* You must be in the vehicle you want saved.");

			iVehicle = GetPlayerVehicleID(playerid);

			GetVehiclePos(iVehicle, X, Y, Z);
			GetVehicleZAngle(iVehicle, Angle);
			iModel = GetVehicleModel(iVehicle);

			iInterior = GetPlayerInterior(playerid);
			iWorld = GetPlayerVirtualWorld(playerid);


			filename = "/other/vehicles_pos.txt";
			vehicle = fopen(filename, io_append);

			Format(sVehicleString, "{ %f, %f, %f, %f },\n", X, Y, Z, Angle);
	        fwrite(vehicle, sVehicleString);
			fclose(vehicle);

			filename = "/other/vehicles_data.txt";
			vehicle = fopen(filename, io_append);

			Format(sVehicleString, "{ %d, %d, %d },\n", iModel, iInterior, iWorld);
	        fwrite(vehicle, sVehicleString);
			fclose(vehicle);

			Format(sMessage, "%s has successfully saved a vehicle.", PlayerName(playerid));
			SendAdminMsg(sMessage);
		}
		else if(strcmp(Option, "atm", true, 3) == 0)
		{
	 		new Float:X, Float:Y, Float:Z, Float:Angle;
			new sATMString[256], sMessage[128], filename[128], File:atm;

			GetPlayerPos(playerid, X, Y, Z);
			GetPlayerFacingAngle(playerid, Angle);
			GetPlayerInterior(playerid);

	  		filename = "/other/atm.txt";
			atm = fopen(filename, io_append);

			Format(sATMString, "{ %f, %f, %f, %f },\n", X, Y, Z-0.4, Angle);
			fwrite(atm, sATMString);
			fclose(atm);

			CreateObject(2942, X, Y, Z-0.4, 0, 0, Angle);

			Format(sMessage, "%s has successfully saved an ATM.", PlayerName(playerid));
			SendAdminMsg(sMessage);
			SendClientMessage(playerid, COLOR_TRUE, "* ATM saved, but remember that the object you're seeing right now is only a preview.");
		}
		else SendClientMessage(playerid, COLOR_USAGE, "Usage: /create [fc/pickup/property/spawn/vehicle/bank/atm]");
	#elseif TEST == 0
	else SendClientMessage(playerid, COLOR_USAGE, "Usage: /create [fc/pickup/property]");
	#endif

	return 1;
}
