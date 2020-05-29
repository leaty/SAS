public SDM_Start()
{
	new sMessage[256];
	new gangid1 = CWTeamInfo[CW_TEAM_ONE][GangID];
	new gangid2 = CWTeamInfo[CW_TEAM_TWO][GangID];

	if(CountOnlineGangMembers(gangid1) < 1 || CountOnlineGangMembers(gangid2) < 1)
	{
	    Format(sMessage, "The war between '%s' and '%s' was terminated: Not enough players.", GangInfo[gangid1][GangName], GangInfo[gangid1][GangName]);
	    SendNews(sMessage);

	    CW::Reset();
	 	return 1;
	}

	for(new i = 0; i < MaxSlots; i++)
	{
	    if(CW::IsPlaying(i))
	    {
			ClearPlayerChat(i);
			
			// Randomize messages
			if(random(2) == 1)
			{
			    gangid1 = CWTeamInfo[CW_TEAM_TWO][GangID];
			    gangid2 = CWTeamInfo[CW_TEAM_ONE][GangID];
			}
			
			if(PlayerInfo[i][GangID] == gangid1)
			{
  				SendClientMessage(i, CW_COLOR_INFO, "Once again, there's an invasion of terrorists in USA...");
  				SendClientMessage(i, CW_COLOR_INFO, "U.S Military Forces was sent in to evacuate all the civilians. They succeeded.");
  				SendClientMessage(i, CW_COLOR_INFO, "Now it's up to the U.S Special Forces to clean this land from terrorists...");
  				SendClientMessage(i, CW_COLOR_INFO, "The terrorists was last seen at the big garage to the north.");
  				SendClientMessage(i, CW_COLOR_INFO, "You got ammo, you got your squad. NOW GET TO IT SOLDIER!");
			}
			else if(PlayerInfo[i][GangID] == gangid2)
			{
  				SendClientMessage(i, CW_COLOR_INFO, "Allah Akbar! We've invaded USA for justice!");
  				SendClientMessage(i, CW_COLOR_INFO, "U.S Military Forces was sent in to evacuate all the civilians. They succeeded.");
  				SendClientMessage(i, CW_COLOR_INFO, "Now we got a word about U.S Special Forces trying to beat us down to the ground.");
  				SendClientMessage(i, CW_COLOR_INFO, "We let the Military Forces beat us because we had no ammo, now we've stolen some from their ammunation stores!");
  				SendClientMessage(i, CW_COLOR_INFO, "Don't let Allah down again, give your life for our justice!");
			}
		}
	}

	CWInfo[cwStatus] = CW_STATUS_RUNNING;
	CW::ShowTextDraws();
	SDM_Spawn();
	
	return 1;
}

SDM_Spawn()
{
	new gangid1 = CWTeamInfo[CW_TEAM_ONE][GangID];
	new gangid2 = CWTeamInfo[CW_TEAM_TWO][GangID];

	new iLoc = CWInfo[cwLocation];
	new Float:X1, Float:Y1, Float:Z1, Float:Angle1;
	new Float:X2, Float:Y2, Float:Z2, Float:Angle2;
	new Float:XMax, Float:XMin, Float:YMax, Float:YMin;
	new iCount, iCount2;
	new diCount, diCount2;
	new RandSpawn = random(2);

	X1 = SDMLocations[iLoc][Pos1][0];
	Y1 = SDMLocations[iLoc][Pos1][1];
	Z1 = SDMLocations[iLoc][Pos1][2];
	Angle1 = SDMLocations[iLoc][Pos1][3];

	X2 = SDMLocations[iLoc][Pos2][0];
	Y2 = SDMLocations[iLoc][Pos2][1];
	Z2 = SDMLocations[iLoc][Pos2][2];
	Angle2 = SDMLocations[iLoc][Pos2][3];

	XMax = SDMLocations[iLoc][Boundries][0];
	XMin = SDMLocations[iLoc][Boundries][1];
	YMax = SDMLocations[iLoc][Boundries][2];
	YMin = SDMLocations[iLoc][Boundries][3];


	// Spawn, freeze etc..
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerConnected(i))
	        continue;

		if(!IsGang(i))
		    continue;

		if(gangid1 == PlayerInfo[i][GangID] && CW::IsPlaying(i))
		{
			CWInfo[cwPlayers][i] = 1;

		    if(iCount == 4)
		        iCount = 1;

			if(RandSpawn == 1)
			{
			    if(diCount == 0)
			    	SetPlayerPos(i, X1+iCount, Y1, Z1), diCount = 1;
				else if(diCount == 1)
					SetPlayerPos(i, X1, Y1+iCount, Z1), diCount = 0;

  				SetPlayerFacingAngle(i, Angle1);
			}
			else
			{
   				if(diCount == 0)
			    	SetPlayerPos(i, X2+iCount, Y2, Z2), diCount = 1;
				else if(diCount == 1)
					SetPlayerPos(i, X2, Y2+iCount, Z2), diCount = 0;

  				SetPlayerFacingAngle(i, Angle2);
			}
			
			ResetPlayerWeapons(i);

			SetPlayerTime(i, CWInfo[cwTime], 00);
			SetPlayerWeather(i, CWInfo[cwWeather]);
		    SetCameraBehindPlayer(i);
		    SetPlayerWorldBounds(i, XMax, XMin, YMax, YMin);
		    SetPlayerVirtualWorld(i, WORLD_CW);
		    SetPlayerHealth(i, 100.0);
		    SetPlayerArmour(i, 0.0);

			CW::GivePlayerWeapons(i);

			SetPlayerTeam(i, CW_TEAM_ONE);
		    TogglePlayerControllable(i, false);
				
			iCount++;
			continue;
		}
		if(gangid2 == PlayerInfo[i][GangID] && CW::IsPlaying(i))
		{
			CWInfo[cwPlayers][i] = 1;

		    if(iCount2 == 4)
		        iCount2 = 1;

			if(RandSpawn == 1)
			{
				if(diCount2 == 0)
			    	SetPlayerPos(i, X2+iCount2, Y2, Z2), diCount2 = 1;
				else if(diCount2 == 1)
					SetPlayerPos(i, X2, Y2+iCount2, Z2), diCount2 = 0;

  				SetPlayerFacingAngle(i, Angle2);
			}
			else
			{
			    if(diCount2 == 0)
			    	SetPlayerPos(i, X1+iCount2, Y1, Z1), diCount2 = 1;
				else if(diCount2 == 1)
					SetPlayerPos(i, X1, Y1+iCount2, Z1), diCount2 = 0;

  				SetPlayerFacingAngle(i, Angle1);
			}
			
			ResetPlayerWeapons(i);
			
			SetPlayerTime(i, CWInfo[cwTime], 00);
			SetPlayerWeather(i, CWInfo[cwWeather]);
		    SetCameraBehindPlayer(i);
		    SetPlayerWorldBounds(i, XMax, XMin, YMax, YMin);
		    SetPlayerVirtualWorld(i, WORLD_CW);
		    SetPlayerHealth(i, 100.0);
		    SetPlayerArmour(i, 0.0);

		    CW::GivePlayerWeapons(i);

		    SetPlayerTeam(i, CW_TEAM_TWO);
			TogglePlayerControllable(i, false);

			iCount2++;
			continue;
		}
	}

	SetTimer("CW_Countdown", 100, false);
	return 1;
}

SDM_OnRespawn(playerid)
{
    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 0.0);
    
	if(CW::CheckPlayers() == 1)
	{
	    if(CWTeamInfo[CW_TEAM_ONE][Dead][playerid] == 1 || CWTeamInfo[CW_TEAM_TWO][Dead][playerid] == 1)
			CW::Watch(playerid);
		else
		    CW::StopWatch(playerid);
	}
	
    #pragma unused playerid
	return 1;
}

SDM_OnDeath(playerid, killerid, reason)
{
	new pTeam;
	new kTeam;

	if(PlayerInfo[playerid][GangID] == CWTeamInfo[CW_TEAM_ONE][GangID])
	{
	    pTeam = CW_TEAM_ONE;
	    kTeam = CW_TEAM_TWO;
	}
	else
	{
 		pTeam = CW_TEAM_TWO;
 		kTeam = CW_TEAM_ONE;
	}
	
 	PlayerInfo[playerid][Hardcore] = 0;
	PlayerInfo[playerid][HC_HP] = 100.0;
    PlayerInfo[playerid][HC_ARM] = 0.0;

    CW::ShowTextDraws();

	PlayerInfo[playerid][Hardcore] = 0;
	CWTeamInfo[kTeam][Kills]++;
	CWTeamInfo[pTeam][Deaths]++;
    CWTeamInfo[pTeam][Dead][playerid] = 1;
    
	#pragma unused killerid, reason
	return 1;
}

