public CWTCW_Start()
{
	new sMessage[256];
	new gangid1 = CWTeamInfo[CW_TEAM_ONE][GangID];
	new gangid2 = CWTeamInfo[CW_TEAM_ONE][GangID];
	
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
			ClearPlayerInteractions(i);
		}
	}
	
	SendCWMsg("Teamwork is the key to success, show em' hell!");
	
	CWInfo[cwStatus] = CW_STATUS_RUNNING;
	CWTCW_Spawn();
	CW::ShowTextDraws();
	
	return 1;
}

CWTCW_Spawn()
{
	new gangid1 = CWTeamInfo[CW_TEAM_ONE][GangID];
	new gangid2 = CWTeamInfo[CW_TEAM_TWO][GangID];
	
	new iLoc = CWInfo[cwLocation];
	new Float:X1, Float:Y1, Float:Z1, Float:Angle1;
	new Float:X2, Float:Y2, Float:Z2, Float:Angle2;
	new Float:XMax, Float:XMin, Float:YMax, Float:YMin;
	new iCount, iCount2;
	new diCount, diCount2;

	X1 = CWLocations[iLoc][Pos1][0];
	Y1 = CWLocations[iLoc][Pos1][1];
	Z1 = CWLocations[iLoc][Pos1][2];
	Angle1 = CWLocations[iLoc][Pos1][3];

	X2 = CWLocations[iLoc][Pos2][0];
	Y2 = CWLocations[iLoc][Pos2][1];
	Z2 = CWLocations[iLoc][Pos2][2];
	Angle2 = CWLocations[iLoc][Pos2][3];

	XMax = CWLocations[iLoc][Boundries][0];
	XMin = CWLocations[iLoc][Boundries][1];
	YMax = CWLocations[iLoc][Boundries][2];
	YMin = CWLocations[iLoc][Boundries][3];


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

		    if(diCount == 0)
		    	SetPlayerPos(i, X1+iCount, Y1, Z1), diCount = 1;
			else if(diCount == 1)
				SetPlayerPos(i, X1, Y1+iCount, Z1), diCount = 0;
				
			SetPlayerFacingAngle(i, Angle1);
			
            ResetPlayerWeapons(i);

			SetPlayerHealth(i, 100.0);
		    SetPlayerArmour(i, 100.0);

		    SetCameraBehindPlayer(i);
		    SetPlayerWorldBounds(i, XMax, XMin, YMax, YMin);
			SetPlayerVirtualWorld(i, WORLD_CW);

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

			if(diCount2 == 0)
		    	SetPlayerPos(i, X2+iCount2, Y2, Z2), diCount2 = 1;
			else if(diCount2 == 1)
				SetPlayerPos(i, X2, Y2+iCount2, Z2), diCount2 = 0;

			SetPlayerFacingAngle(i, Angle2);

            ResetPlayerWeapons(i);

			SetPlayerHealth(i, 100.0);
		    SetPlayerArmour(i, 100.0);
		    SetCameraBehindPlayer(i);
		    SetPlayerWorldBounds(i, XMax, XMin, YMax, YMin);
            SetPlayerVirtualWorld(i, WORLD_CW);

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

CWTCW_Respawn(playerid)
{
	if(!IsPlayerConnected(playerid))
        return 0;

	if(!IsGang(playerid))
	    return 0;
	    
	new gangid1 = CWTeamInfo[CW_TEAM_ONE][GangID];
	new gangid2 = CWTeamInfo[CW_TEAM_TWO][GangID];

	new iLoc = CWInfo[cwLocation];
	new Float:X, Float:Y, Float:Z, Float:Angle;
	new Float:XMax, Float:XMin, Float:YMax, Float:YMin;
	new Teamid;

	if(gangid1 == PlayerInfo[playerid][GangID] && CW::IsPlaying(playerid))
	{
		X = CWLocations[iLoc][Pos1][0];
		Y = CWLocations[iLoc][Pos1][1];
		Z = CWLocations[iLoc][Pos1][2];
		Angle = CWLocations[iLoc][Pos1][3];
		Teamid = CW_TEAM_ONE;
 	}
	else if(gangid2 == PlayerInfo[playerid][GangID] && CW::IsPlaying(playerid))
	{
		X = CWLocations[iLoc][Pos2][0];
		Y = CWLocations[iLoc][Pos2][1];
		Z = CWLocations[iLoc][Pos2][2];
		Angle = CWLocations[iLoc][Pos2][3];
		Teamid = CW_TEAM_TWO;
	}
	
	XMax = CWLocations[iLoc][Boundries][0];
	XMin = CWLocations[iLoc][Boundries][1];
	YMax = CWLocations[iLoc][Boundries][2];
	YMin = CWLocations[iLoc][Boundries][3];
	
	// Spawn, freeze etc..

	CWInfo[cwPlayers][playerid] = 1;

	ResetPlayerWeapons(playerid);

	SetPlayerHealth(playerid, 100.0);
 	SetPlayerArmour(playerid, 100.0);

	SetPlayerPos(playerid, X, Y, Z);
	SetPlayerFacingAngle(playerid, Angle);
    SetCameraBehindPlayer(playerid);
    SetPlayerWorldBounds(playerid, XMax, XMin, YMax, YMin);
    SetPlayerVirtualWorld(playerid, WORLD_CW);
    CW::GivePlayerWeapons(playerid);
    SetPlayerTeam(playerid, Teamid);

	return 1;
}

CW_OnRespawn(playerid)
{
	if(CWInfo[cwType] == CWTCW_TYPE_SCORE)
	{
		CWTCW_Respawn(playerid);
	}
	else if(CWInfo[cwType] == CWTCW_TYPE_ROUNDS)
	{
	    if(CW::CheckPlayers() == 1)
	    {
		    if(CWTeamInfo[CW_TEAM_ONE][Dead][playerid] == 1 || CWTeamInfo[CW_TEAM_TWO][Dead][playerid] == 1)
		    	CW::Watch(playerid);
			else
			    CW::StopWatch(playerid);
		}
	}
	return 1;
}

CW_OnDeath(playerid, killerid, reason)
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

	CWTeamInfo[kTeam][Kills]++;
	CWTeamInfo[pTeam][Deaths]++;
	
	if(CWInfo[cwType] == CWTCW_TYPE_SCORE)
	{
	    if(CW::CheckScore())
    		CW::ShowTextDraws();
 	}
 	else if(CWInfo[cwType] == CWTCW_TYPE_ROUNDS)
 	{
 	    CW::ShowTextDraws();
      	CWTeamInfo[pTeam][Dead][playerid] = 1;
 	}

	#pragma unused killerid, reason
	return 1;
}

TCW_OnRespawn(playerid)
{
	if(CWInfo[cwType] == CWTCW_TYPE_SCORE)
	{
		CWTCW_Respawn(playerid);
	}
	else if(CWInfo[cwType] == CWTCW_TYPE_ROUNDS)
	{
	    if(CW::CheckPlayers() == 1)
	    {
		    if(CWTeamInfo[CW_TEAM_ONE][Dead][playerid] == 1 || CWTeamInfo[CW_TEAM_TWO][Dead][playerid] == 1)
		    	CW::Watch(playerid);
			else
			    CW::StopWatch(playerid);
		}
	}
	return 1;
}

TCW_OnDeath(playerid, killerid, reason)
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

	CWTeamInfo[kTeam][Kills]++;
	CWTeamInfo[pTeam][Deaths]++;

	if(CWInfo[cwType] == CWTCW_TYPE_SCORE)
	{
	    if(CW::CheckScore())
    		CW::ShowTextDraws();
 	}
 	else if(CWInfo[cwType] == CWTCW_TYPE_ROUNDS)
 	{
 	    CW::ShowTextDraws();
 	    CWTeamInfo[pTeam][Dead][playerid] = 1;
 	}

	#pragma unused killerid, reason
	return 1;
}
