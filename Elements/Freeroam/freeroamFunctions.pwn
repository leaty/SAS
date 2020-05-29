Freeroam__RandomSpawn(playerid)
{
	new iSpawn = random(sizeof(F_Spawns));
	
	SetPlayerInterior(playerid, F_Spawns_Data[iSpawn]);
	SetPlayerVirtualWorld(playerid, WORLD_FREEROAM);
	SetPlayerPos(playerid, F_Spawns[iSpawn][0], F_Spawns[iSpawn][1], F_Spawns[iSpawn][2]);
	SetPlayerFacingAngle(playerid, F_Spawns[iSpawn][3]);
	SetCameraBehindPlayer(playerid);

	return 1;
}

// type = should administrators be able to skip this check?
Freeroam__Afford(playerid, money, type)
{
	new sMessage[128];
	
	if(GetPlayerMoney(playerid) < money && (type == AFFORD_NONSKIP || !IsAdmin(playerid)) )
	{
		Format(sMessage, "* You cannot afford this, it costs $ %s.", ConvertMoney(money));
		SendClientMessage(playerid, COLOR_FALSE, sMessage);
	    return 0;
	}
	
	return 1;
}

Freeroam__Permitted(playerid, secs)
{
    new sMessage[128];
	if(GetPlayerPlayTime(playerid, MODE_FREEROAM) < secs)
	{
		Format(sMessage, "* You must've played at least %s for this feature.", ConvertTime(secs));
		SendClientMessage(playerid, COLOR_FALSE, sMessage);
	    return 0;
	}

	return 1;
}

public Freeroam_ExitSFPD(playerid)
{
	SetPlayerInterior(playerid, 0);
    SetPlayerPos(playerid, -1605.1848, 716.7462, 11.9186);
	SetPlayerFacingAngle(playerid, 356.2322);
	SetCameraBehindPlayer(playerid);
	return 1;
}

