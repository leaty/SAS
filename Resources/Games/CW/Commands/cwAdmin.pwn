cw_Admin(playerid, params[])
{
	new sOption[50];
	
	if(sscanf(params, "s", sOption))
	    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /cw admin [end/reset/respawn]");
	    
    new sMessage[256];

	if(strcmp(sOption, "end", true, 3) == 0)
	{
	    if(!CW::IsRunning())
	        return SendClientMessage(playerid, COLOR_FALSE, "* There is no clanwar running, please try 'reset' instead.");
	        
	    new gangid1 = CWTeamInfo[CW_TEAM_ONE][GangID];
	    new gangid2 = CWTeamInfo[CW_TEAM_TWO][GangID];
	    
		Format(sMessage, "The war between '%s' and '%s' was terminated by an administrator.", GangInfo[gangid1][GangName], GangInfo[gangid2][GangName]);
	    SendNews(sMessage);

	    CW::Reset();
	}
	else if(strcmp(sOption, "reset", true, 5) == 0)
	{
	    CW::Reset();
	}
	else if(strcmp(sOption, "respawn", true, 7) == 0)
	{
 		if(!CW::IsRunning())
	        return SendClientMessage(playerid, COLOR_FALSE, "* There is no clanwar running, please try 'reset' instead.");
	
		if(CW::CountPlayers(CWTeamInfo[CW_TEAM_ONE][GangID]) < 1 || CW::CountPlayers(CWTeamInfo[CW_TEAM_TWO][GangID]) < 1)
	    	return SendClientMessage(playerid, COLOR_FALSE, "* There aren't enough players to continue this war.");
	    	
    	new ResetLeavers[MAX_PLAYER_NAME];
		ResetLeavers = "";

		for(new i = 0; i < MaxSlots; i++)
			CWLeavers[i] = ResetLeavers;

		CWInfo[cwLeavecount] = 0;

		SendCWMsg("Everyone has been respawned, keep fighting!");

		if(CWInfo[cwMode] == CW_MODE_CW || CWInfo[cwMode] == CW_MODE_TCW)
			CWTCW_Spawn();
	 	else if(CWInfo[cwMode] == CW_MODE_SDM)
			SDM_Spawn();

	}
	else SendClientMessage(playerid, COLOR_USAGE, "Usage: /cw admin [end/reset/respawn]");
	
	return 1;
}

