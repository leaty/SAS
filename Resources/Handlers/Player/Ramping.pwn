/********************************************************************************
*                                                                               *
*  Las Venturas Playground - Ramping Handler			            			*
*                                                                           	*
*  Handles ramping stuff upon pressing a key							 	    *
*                                                                               *
*  @copyright Copyright (c) 2006-2010 Las Venturas Playground                   *
*  @author    Jay						                                        *
*  @package   Handlers                                                          *
*  @version   $Id: Ramping.pwn 1279 2010-11-30 16:17:06Z Jay $                                                              *
*                                                                               *
********************************************************************************/

// Note: there are future plans to rewrite this system.

new iPlayerRampTime[MaxSlots];

Ramping::Process()
{
	for(new i = 0; i < MaxSlots; i++)
	{
	 	if (iPlayerRampTime[i] > 0)
		{
			if (Now() - iPlayerRampTime [i] > 2)
				Ramping::Remove(i);
		}
	}
}

// Called from OnPlayerKeyStateChange
Ramping::OnKey(playerid)
{
	// Is Ramping disabled, globally?
	if ( RampingEnabled == false && !IsAdmin(playerid) )
	{
		SendClientMessage(playerid,COLOR_FALSE, "* Ramping has been temporary disabled by an administrator.");
		return;
	}

	new
		Float:fPosX,
		Float:fPosY,
		Float:fPosZ,
		Float:fAngle,
		Float:fDistance;

	GetPlayerPos(playerid, fPosX, fPosY, fPosZ);

	fDistance = GetOptimumRampDistance(playerid) + 7;

	fAngle = GetXYInFrontOfPlayer(playerid, fPosX, fPosY, fDistance);

	// We also have to check for anti ramp abuse...

	#if RAMPING_ABUSE == 1
		if(IsPlayer(playerid))
		{
			for(new i = 0; i < MaxSlots; i++)
			{
				if(!IsPlayerConnected(i))
					continue;

				if(IsPlayerNPC(i))
				    continue;

				if(!IsPlayerStreamedIn(i, playerid))
				    continue;

				if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid))
					continue;

				if(IsPlayerInVehicle(i,GetPlayerVehicleID(playerid)))
					continue;

				if(!IsPlayerInRangeOfPoint(i, 20.0, fPosX, fPosY, fPosZ))
					continue;

				new
					szRampMsg[75];

				format(szRampMsg, 75, "* You cannot spawn a ramp because %s is in the way!", PlayerName(i));
				SendClientMessage(playerid, COLOR_FALSE, szRampMsg);
				return;
			}
		}
	#endif

	switch (PlayerInfo[playerid][Rampid])
	{
		case 1:
		{
			fPosZ -= 0.5;
		}

		case 2:
		{
			fAngle -= 90.0;
			
			if (fAngle < 0.0)
				fAngle += 360.0;

			fPosZ += 0.5;
		}

		case 12:
		{
			fAngle -= 90.0;
			
			if (fAngle < 0.0)
				fAngle += 360.0;
		}
	}

	/*
	if(PlayerInfo[playerid][Ramp] != -1)
	{
		DestroyDynamicObject(PlayerInfo[playerid][Ramp]);
		PlayerInfo[playerid][Ramp] = -1;
	}*/
	
	Ramping::Remove(playerid);
	iPlayerRampTime[playerid] = Now();
	
	if(PlayerInfo[playerid][Rampid] == 12)
	{
		if(!IsAdmin(playerid))
		{
			SendClientMessage(playerid, COLOR_FALSE, "* You have to be an admin to spawn this ramp! Change your ramp using /my ramp.");
			return;
		}
		
		new Float:vX, Float:vY, Float:vZ;
		
		GetVehicleVelocity(GetPlayerVehicleID(playerid), vX, vY, vZ);
		PlayerInfo[playerid][Ramp] = CreateDynamicObject(ramptypes[PlayerInfo[playerid][Rampid]], fPosX, fPosY, fPosZ - 0.5, 0.0, 0.0, fAngle);
		SetVehicleVelocity(GetPlayerVehicleID(playerid), vX, vY, vZ+0.1);
	}
	else
	{
		switch(PlayerInfo[playerid][Rampid])
		{
			case 2: 	PlayerInfo[playerid][Ramp] = CreateDynamicObject(ramptypes[PlayerInfo[playerid][Rampid]],  fPosX-1, fPosY, fPosZ - 0.5, 0.0, 0.0, fAngle); // fixes a bug with it spawning slightly to the left!
			case 6: 	PlayerInfo[playerid][Ramp] = CreateDynamicObject(ramptypes[PlayerInfo[playerid][Rampid]],  fPosX, fPosY, fPosZ, 0.0, 0.0, fAngle);
			case 7: 	PlayerInfo[playerid][Ramp] = CreateDynamicObject(ramptypes[PlayerInfo[playerid][Rampid]],  fPosX, fPosY, fPosZ, 0.0, 0.0, fAngle);
			case 8: 	PlayerInfo[playerid][Ramp] = CreateDynamicObject(ramptypes[PlayerInfo[playerid][Rampid]],  fPosX, fPosY, fPosZ - 0.5, 0.0, 0.0, fAngle+180);
			case 9: 	PlayerInfo[playerid][Ramp] = CreateDynamicObject(ramptypes[PlayerInfo[playerid][Rampid]],  fPosX, fPosY, fPosZ + 0.7, 0.0, 0.0, fAngle);
			case 10: 	PlayerInfo[playerid][Ramp] = CreateDynamicObject(ramptypes[PlayerInfo[playerid][Rampid]],  fPosX, fPosY, fPosZ, 0.0, 0.0, fAngle+90);
			case 11: 	PlayerInfo[playerid][Ramp] = CreateDynamicObject(ramptypes[PlayerInfo[playerid][Rampid]],  fPosX, fPosY, fPosZ, 0.0, 0.0, fAngle+15);
			case 12: 	PlayerInfo[playerid][Ramp] = CreateDynamicObject(ramptypes[PlayerInfo[playerid][Rampid]],  fPosX, fPosY, fPosZ + 1.4, 0.0, 0.0, fAngle+90);
			default: 	PlayerInfo[playerid][Ramp] = CreateDynamicObject(ramptypes[PlayerInfo[playerid][Rampid]],  fPosX, fPosY, fPosZ - 0.5, 0.0, 0.0, fAngle);
		}
	}
}

Ramping::Remove(playerid)
{
	if(PlayerInfo[playerid][Ramp] != -1)
	{
		DestroyDynamicObject(PlayerInfo[playerid][Ramp]);
		iPlayerRampTime[playerid] = 0;
		PlayerInfo[playerid][Ramp] = -1;
	}
	
	return 1;
}

Ramping::OnReset(playerid)
{
	Ramping::Remove(playerid);
	return 1;
}


forward Float:GetOptimumRampDistance(playerid);
stock Float:GetOptimumRampDistance(playerid)
{
	new ping = GetPlayerPing(playerid), Float:dist;
	dist = floatpower(ping, 0.25);
	dist = dist*4.0;
	dist = dist+5.0;
	return dist;
}

// Returns 1 if a vehicle is ramping valid, 0 otherwise
stock IsVehicleRampingValid(n_Model)
{
	if(n_Model < 400 || n_Model > 613)
	    return 0;


	n_Model = GetVehicleModel(GetPlayerVehicleID(playerid));

	if (n_Model == 417 || n_Model == 425 ||
	n_Model == 447 || n_Model == 460 ||
	n_Model == 469 || n_Model == 476 ||
	n_Model == 487 || n_Model == 488 ||
	n_Model == 497 || n_Model == 511 ||
	n_Model == 512 || n_Model == 513 ||
	n_Model == 519 || n_Model == 520 ||
	n_Model == 548 || n_Model == 553 ||
	n_Model == 563 || n_Model == 577 ||
	n_Model == 592 || n_Model == 593)
	{
		return 0;
	}
	// We're still here. It's valid!
	return 1;
}

