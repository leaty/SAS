Spectate__Stop(playerid)
{
    PlayerInfo[playerid][Spectating] = false;
    PlayerInfo[playerid][SpecID] = -1;
	TogglePlayerSpectating(playerid, false);
	
	if(IsTraining(playerid))
	    SetPlayerVirtualWorld(playerid, WORLD_TRAINING);
	if(IsFreeroam(playerid))
	    SetPlayerVirtualWorld(playerid, WORLD_FREEROAM);
	    
    return 1;
}

Spectate__Player(playerid, specid)
{
    PlayerInfo[playerid][Spectating] = true;
    PlayerInfo[playerid][SpecID] = specid;
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(specid));
    TogglePlayerSpectating(playerid, true);
    PlayerSpectatePlayer(playerid, specid);
    return 1;
}

Spectate__NextPlayer(playerid)
{

	for(new i = PlayerInfo[playerid][SpecID] + 1; i < MaxSlots; i++)
	{
		if(!IsPlayerConnected(i))
			continue;
			
		if(i == playerid)
		    continue;

		Spectate::Player(playerid, i);
		return 1; // All done, stop right here!
	}

	// Oh, it failed? :O

	for(new i = 0; i < MaxSlots; i++)
	{
		if(!IsPlayerConnected(i))
			continue;

		if(i == playerid)
		    continue;

		Spectate::Player(playerid, i);
		return 1;
	}

	//Failed again?! FUCK IT! :@

	Spectate::Stop(playerid);
	return 1;
}

Spectate__OnDisconnect(playerid, reason)
{
    TogglePlayerSpectating(playerid, false);
    PlayerInfo[playerid][Spectating] = false;
    PlayerInfo[playerid][SpecID] = -1;
    #pragma unused reason
    return 1;
}

Spectate__Exit()
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    TogglePlayerSpectating(i, false);
	    PlayerInfo[i][Spectating] = false;
	    PlayerInfo[i][SpecID] = -1;
	}
	
	return 1;
}

