cw_Watch(playerid, params[])
{
	if(!CW::IsRunning())
	    return SendClientMessage(playerid, COLOR_FALSE, "* There's no clanwar running!");
	    
	if(CW::IsSpectating(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You're already spectating a clanwar.");
	    
	CWInfo[cwSpectators][playerid] = 1;
	SetPlayerVirtualWorld(playerid, WORLD_CW);

	CW::Watch(playerid);
	
	SendClientMessage(playerid, COLOR_INFO, "* Use '/cw stopwatch' to stop watching.");
	#pragma unused params
	return 1;
}

cw_Stopwatch(playerid, params[])
{
	if(!CW::IsSpectating(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You're not spectating a clanwar.");
	    
	CWInfo[cwSpectators][playerid] = 0;
	
	CW::StopWatch(playerid);
	#pragma unused params
	return 1;
}

cw_Invite(playerid, params[])
{
	if(!IsGang(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You must be in a gang to use these commands. Type '/gang' for more information.");
	    
	if(CW::IsActive())
	    return SendClientMessage(playerid, COLOR_FALSE, "* It seems a clanwar is already running or it is pending acceptance. Try '/cw watch'");
	    
	Player::ShowDialog(playerid, DIALOG_CW_INFO, DIALOG_STYLE_MSGBOX, "* CW - Information", "* Before you go ahead and invite a gang, please read the following notes:\n \
																				 \n  ** You can choose between different types of modes to challenge another gang with.\
																				 \n  ** CW is the Official one (wins and losses will be counted), only the gang owner can choose this.\
																				 \n  ** Available settings of the different modes may differ from eachother.", "Continue", "Cancel");
	CWInfo[cwInviter] = playerid;
	CWInfo[cwPlayers][playerid] = 1;
	CWInfo[cwStatus] = CW_STATUS_INVITED;
	CWTeamInfo[CW_TEAM_ONE][GangID] = PlayerInfo[playerid][GangID];
	
	#pragma unused params
	return 1;
}

cw_Accept(playerid, params[])
{
	if(!IsGang(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You must be in a gang to use these commands. Type '/gang' for more information.");
	    
	new gangid = PlayerInfo[playerid][GangID];
	
	if(CW::IsRunning())
	    return SendClientMessage(playerid, COLOR_FALSE, "* It seems a clanwar is already running. Try '/cw watch'");
	
	if(!CW::IsInvited(gangid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* Your gang hasn't been invited to any type of clanwar.");
	
	if(CWInfo[cwStatus] == CW_STATUS_ACCEPTED)
	    return SendClientMessage(playerid, COLOR_FALSE, "* Your gang has already accepted this invitation.");
	
	if(CWInfo[cwMode] == CW_MODE_CW && !IsGangOwner(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You must be the gang owner to accept an official clanwar.");
	
	CWInfo[cwAccepter] = playerid;
	CWInfo[cwPlayers][playerid] = 1;
	CWInfo[cwStatus] = CW_STATUS_ACCEPTED;
	
	Player::ShowDialog(playerid, DIALOG_CW_ACCEPT, DIALOG_STYLE_LIST, "CW - LineUp (shows available gang members)", CW::GetPlayerList(gangid), "Select", "Deny");
	
	#pragma unused params
	return 1;
}

/*cw_Deny(playerid, params[])
{
	new gangid = PlayerInfo[playerid][GangID];
	new engangid = CWTeamInfo[CW_TEAM_ONE][GangID];
	new sMessage[256];

	if(!CW::IsInvited(gangid))
 		return SendClientMessage(playerid, COLOR_FALSE, "* Your gang has not been invited to this war.");
 		
	if(CWInfo[cwMode] == CW_MODE_CW && !IsGangOwner(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You must be the gang owner to accept an official clanwar.");

 		
	Format(sMessage, "%s has denied Gang %s's invitation.", PlayerName(playerid), GangInfo[engangid][GangName]);
	SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);
	Format(sMessage, "%s from Gang '%s' has denied your gang's invitation.", PlayerName(playerid), GangInfo[gangid][GangName]);
    SendGangMsg(engangid, GANG_COLOR_INFO, sMessage);
    
	CW::Reset();
	 	
	#pragma unused params
	return 1;
}*/

cw_Respawn(playerid, params[])
{
	if(!IsGang(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You must be in a gang to use these commands. Type '/gang' for more information.");
	    
	/*if(!CWInfo[cwFrozen])
		return SendClientMessage(playerid, COLOR_FALSE, "* This command is only available whilst a war is frozen.");*/

	if(CWInfo[cwInviter] != playerid && CWInfo[cwAccepter] != playerid)
	    return SendClientMessage(playerid, COLOR_FALSE, "* This command is only available for the organizers of this war.");

	if(CW::CountPlayers(CWTeamInfo[CW_TEAM_ONE][GangID]) < 1 || CW::CountPlayers(CWTeamInfo[CW_TEAM_TWO][GangID]) < 1)
	    return SendClientMessage(playerid, COLOR_FALSE, "* There aren't enough players to continue this war, you can either wait or use '/cw end'.");

	new ResetLeavers[MAX_PLAYER_NAME];
	ResetLeavers = "";

	for(new i = 0; i < MaxSlots; i++)
	{
		CWLeavers[i] = ResetLeavers;
		
		CW::StopWatch(i);
	}
	CWInfo[cwLeavecount] = 0;
	
	SendCWMsg("Everyone has been respawned, keep fighting!");

	if(CWInfo[cwMode] == CW_MODE_CW || CWInfo[cwMode] == CW_MODE_TCW)
		CWTCW_Spawn();
 	else if(CWInfo[cwMode] == CW_MODE_SDM)
		SDM_Spawn();

	#pragma unused params
	return 1;
}

cw_End(playerid, params[])
{
	if(!IsGang(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You must be in a gang to use these commands. Type '/gang' for more information.");
	    
    new sMessage[256];
    new gangid1 = CWTeamInfo[CW_TEAM_ONE][GangID];
    new gangid2 = CWTeamInfo[CW_TEAM_TWO][GangID];
    
    /*if(!CWInfo[cwFrozen])
		return SendClientMessage(playerid, COLOR_FALSE, "* This command is only available whilst a war is frozen.");*/

	if(CWInfo[cwInviter] != playerid && CWInfo[cwAccepter] != playerid)
	    return SendClientMessage(playerid, COLOR_FALSE, "* This command is only available for the organizers of this war.");

	Format(sMessage, "The war between '%s' and '%s' was terminated by an organizer.", GangInfo[gangid1][GangName], GangInfo[gangid2][GangName]);
    SendNews(sMessage);
    
    CW::Reset();

	#pragma unused params
	return 1;
}

