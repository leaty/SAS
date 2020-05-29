public Mini__Countdown()
{
	new gText[50], iSound;
	new Float:X, Float:Y, Float:Z;

	// Start
	if(MiniInfo[miniCountdown] == 0)
	{
		iSound = 1057;
	    Format(gText, "~r~%s", MiniStartText[random(sizeof(MiniStartText))]);
	    for(new i = 0; i < MaxSlots; i++)
	    {
	        if(!Mini::IsPlaying(i))
	            continue;

         	GetPlayerPos(i, X, Y, Z);
			PlayerPlaySound(i, iSound, X, Y, Z);
			GameTextForPlayer(i, gText, 1500, 6);

			TogglePlayerControllable(i, true);
	    }

		MiniInfo[miniCountdown] = MINI_COUNTDOWN;
	}
	// Countdown
	else
	{
		iSound = 1058;
	    Format(gText, "~g~%d", MiniInfo[miniCountdown]);
 		for(new i = 0; i < MaxSlots; i++)
	    {
	        if(!Mini::IsPlaying(i))
	            continue;

         	GetPlayerPos(i, X, Y, Z);
			PlayerPlaySound(i, iSound, X, Y, Z);
			GameTextForPlayer(i, gText, 1100, 6);
	    }

	    MiniInfo[miniCountdown]--;
	    SetTimer("Mini__Countdown", 1000, false);
	}

	return 1;
}

Mini__StartSignup(playerid)
{
	new sMessage[128], miniName[100];

	MiniInfo[miniTeam][playerid] = MINI_TEAM_ONE;
	MiniInfo[miniPlayers][playerid] = true;
	MiniInfo[miniStatus] = MINI_STATUS_SIGNUP;

	Format(sMessage, "%s has started %s (%s).", PlayerName(playerid), MiniRealNames[MiniInfo[miniGame]], MiniNames[MiniInfo[miniGame]]);
	SendAdminMsg(sMessage);


	Format(miniName, "%s", MiniRealNames[MiniInfo[miniGame]]);
	
	if(MiniInfo[miniHardcore] == true)
		Format(miniName, "%s HC", miniName);
		
	if(MiniInfo[miniRespawn] == true)
        Format(miniName, "%s R (%d)", miniName, MiniInfo[miniScore]);
        

	Format(sMessage, "* %s - %s is signing up! Type '/signup' to join!", miniName, SDMLocations[MiniInfo[miniLocation]][LocName]);
	SendClientMessageToAll(MINI_COLOR_TITLE, sMessage);

	CallMiniPrepare("Prepare");
	SetTimer(sFunct, 15000, false);
	
	return 1;
}

Mini__End(const reason[])
{
	new sMessage[128];
	
	Format(sMessage, "%s was terminated (%s).", MiniNames[MiniInfo[miniGame]], reason);
	SendNews(sMessage);
	
	Mini::Reset();
	return 1;
}

Mini__DropPlayer(playerid, const reason[])
{
	new sMessage[128];

	MiniInfo[miniTeam][playerid] = 0;
	MiniInfo[miniPlayers][playerid] = false;
	MiniInfo[miniKills][playerid] = 0;
	MiniInfo[miniLastSpawn][playerid] = 0;

	Hardcore::Reset(playerid);
	SetPlayerTeam(playerid, 255);
	SetPlayerWorldBounds(playerid, 20000.0000, -20000.0000, 20000.0000, -20000.0000);
	
	SpawnPlayer(playerid);
	
	Format(sMessage, "%s dropped out of %s (%s).", PlayerName(playerid), MiniNames[MiniInfo[miniGame]], reason);
	SendNews(sMessage);
	
	return 1;
}

Mini__CheckPlayers()
{
	new iCount, iTeam1, iTeam2;
	
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!Mini::IsPlaying(i))
	        continue;
	        
		if(MiniInfo[miniGame] == MINI_GAME_SDM)
		{
			if(MiniInfo[miniTeam][i] == MINI_TEAM_ONE)
				iTeam1++;
			else if(MiniInfo[miniTeam][i] == MINI_TEAM_TWO)
			    iTeam2++;
		}
		else
		    iCount++;
	}
	
	if(MiniInfo[miniGame] == MINI_GAME_SDM)
	{
	    if(iTeam1 < 1 || iTeam2 < 1)
			return 1;
	}
	else
	{
	    if(iCount < 2)
	        return 1;
	}
	
	return 0;
}

Mini__CheckScore()
{

	if(MiniInfo[miniTeamScore1] >= MiniInfo[miniScore] || MiniInfo[miniTeamScore2] >= MiniInfo[miniScore])
		return 1;

	return 0;
	
}

Mini__Reset()
{

	Mini::OnReset();

	MiniInfo[miniGame] = 0;
	MiniInfo[miniScore] = 0;
	MiniInfo[miniTeamScore1] = 0;
	MiniInfo[miniTeamScore2] = 0;
	MiniInfo[miniCountdown] = 0;
	MiniInfo[miniRespawn] = false;
	MiniInfo[miniHardcore] = false;
	MiniInfo[miniProcess] = false;

	for(new i = 0; i < MaxSlots; i++)
	{
	    MiniInfo[miniKills][i] = 0;
		MiniInfo[miniLastSpawn][i] = 0;
	
		if(!Mini::IsPlaying(i))
			continue;
			
		MiniInfo[miniTeam][i] = 0;
		MiniInfo[miniPlayers][i] = false;
		SetPlayerWorldBounds(i, 20000.0000, -20000.0000, 20000.0000, -20000.0000);
		Hardcore::Reset(i);
		SetPlayerTeam(i, 255);
		
		if(!IsPlayerConnected(i))
			continue;

		if(MiniInfo[miniStatus] == MINI_STATUS_SIGNUP)
		    continue;
		    
		SpawnPlayer(i);
	}
	
	MiniInfo[miniStatus] = MINI_STATUS_NONE;
	
	return 1;
}

Mini__GetGameList()
{
	new sList[256];
	
	for(new i = 0; i < sizeof(MiniNames); i++)
	{
	    if(i == 0)
	    	Format(sList, "%s", MiniRealNames[i]);
		else
		    Format(sList, "%s\n%s", sList, MiniRealNames[i]);
	}
	
	return sList;
}

Mini__IsRunning()
{
	if(MiniInfo[miniStatus] == MINI_STATUS_RUNNING)
	    return 1;
	    
	return 0;
}

Mini__IsSigningUp()
{
	if(MiniInfo[miniStatus] == MINI_STATUS_SIGNUP)
	    return 1;

	return 0;
}

Mini__IsSettingUp()
{
	if(MiniInfo[miniStatus] == MINI_STATUS_SETUP)
		return 1;
		
	return 0;
}

Mini__IsNone()
{
	if(MiniInfo[miniStatus] == MINI_STATUS_NONE)
	    return 1;

	return 0;
}

Mini__IsPlaying(playerid)
{
	if(MiniInfo[miniPlayers][playerid])
	    return 1;
	    
	return 0;
}

SendMiniMsg(const string[])
{
	new sMessage[256];

	Format(sMessage, "[%s] %s", MiniNames[MiniInfo[miniGame]], string);

	for(new i = 0; i < MaxSlots; i++)
	{
		if(!IsPlayerConnected(i))
		    continue;

	    if(!Mini::IsPlaying(i))
	        continue;
	        
     	SendClientMessage(i, MINI_COLOR_INFO, sMessage);
	}
	
	return 1;
}

