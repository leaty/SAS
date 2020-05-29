gang_Invite(playerid, params[])
{
	new pid, gangid, sMessage[128];

	gangid = PlayerInfo[playerid][GangID];

	if(sscanf(params, "d", pid))
		return SendClientMessage(playerid, COLOR_USAGE, "Usage: /gang invite [playerid]");

	if(!IsPlayerConnected(pid))
		return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't connected.");

	PlayerInfo[pid][GangInvited] = gangid;

	Format(sMessage, "%s has been invited to join the gang.", PlayerName(pid));
	SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);

	Format(sMessage, "* You've been invited to join gang %s (ID: %d). If you wish to accept, type /gang join %d", GangInfo[gangid][GangName], gangid, gangid);
	SendClientMessage(pid, COLOR_INFO, sMessage);
	
	if(IsGang(pid))
	    SendClientMessage(pid, COLOR_INFO, "* However, as you're already in a gang you must use '/gang leave' first to be able to join.");

	return 1;
}

gang_Kick(playerid, params[])
{
	new gangid, pid, sMessage[128];
	if(sscanf(params, "d", pid))
		return SendClientMessage(playerid, COLOR_USAGE, "Usage: /gang kick [playerid]");

	if(!IsPlayerConnected(pid))
		return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't connected.");

	if(!IsGang(pid))
		return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't even in a gang!");

	gangid = PlayerInfo[playerid][GangID];

	if(PlayerInfo[pid][GangID] != gangid)
		return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't in that gang.");

	if(PlayerInfo[pid][GangLevel] == GANG_LEVEL_OWNER)
		return SendClientMessage(playerid, COLOR_FALSE, "* This player is the gangs owner, you cannot kick him.");

	Gang::Leave(pid);

	GangInfo[gangid][Members]--;

	Format(sMessage, "* You've been kicked out of gang %s by the gang owner.", GangInfo[gangid][GangName]);
	SendClientMessage(pid, COLOR_INFO, sMessage);

	Format(sMessage, "%s was kicked out of the gang by the gang owner.", PlayerName(pid));
	SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);

	Format(sMessage, "* %s was successfully kicked out of gang %s", PlayerName(pid), GangInfo[gangid][GangName]);
	SendClientMessage(playerid, COLOR_TRUE, sMessage);

	return 1;
}

gang_Settings(playerid, params[])
{
	new gangid, sSetting[50], sMessage[128];
	
	gangid = PlayerInfo[playerid][GangID];
	
	if(sscanf(params, "s", sSetting))
	    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /gang settings [owner/color]");
	    
	if(strcmp(sSetting, "owner", true, 5) == 0)
	{
	    new newownerid, sNewOwner[MAX_PLAYER_NAME];
	    
	    if(sscanf(params, "sd", sSetting, newownerid))
	        return SendClientMessage(playerid, COLOR_USAGE, "Usage: /gang settings owner [newownerid]");
	        
		if(!IsPlayerConnected(newownerid))
		    return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't connected.");

		if(PlayerInfo[newownerid][GangID] != gangid)
		    return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't in your gang.");
		    
		sNewOwner = PlayerName(newownerid);
		    
		PlayerInfo[playerid][GangLevel] = GANG_LEVEL_MEMBER;
		PlayerInfo[newownerid][GangLevel] = GANG_LEVEL_OWNER;

		GangInfo[gangid][GangOwner] = sNewOwner;
		
		Format(sMessage, "* You've given your place as the gang owner to %s.", sNewOwner);
		SendClientMessage(newownerid, COLOR_INFO, sMessage);
		Format(sMessage, "* %s has given his place as gang owner to you.", PlayerName(playerid));
		SendClientMessage(newownerid, COLOR_INFO, sMessage);
		
		Format(sMessage, "%s has given his place as the gang owner to %s.", PlayerName(playerid), sNewOwner);
		SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);
	}
	else if(strcmp(sSetting, "color", true, 5) == 0)
	{
	    new colorid;
	    
	    if(sscanf(params, "sd", sSetting, colorid))
	        return SendClientMessage(playerid, COLOR_USAGE, "Usage: /gang settings color [0-199]");

		if(!IsManagement(playerid) && (colorid < 0 || colorid > 199))
		    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /gang settings color [0-199]");

		if(!IsManagement(playerid) && (colorid == 98 || colorid == 99))
		    return SendClientMessage(playerid, COLOR_FALSE, "* You cannot use that color.");

		if(GangColorUsed(colorid))
		    return SendClientMessage(playerid, COLOR_FALSE, "* This color is already used by another gang.");

		GangInfo[gangid][ColorID] = colorid;
		
		Format(sMessage, "Color was changed to %d", colorid);
		SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);
	}
	else SendClientMessage(playerid, COLOR_USAGE, "Usage: /gang settings [owner/color]");
	
	return 1;
}

gang_Delete(playerid, params[])
{
	Player::ShowDialog(playerid, DIALOG_GANG_DELETE, DIALOG_STYLE_MSGBOX, "* Delete gang", "* Are you sure you want to delete this gang\n\
																						 \n  ** Gang statistics will be lost forever.\
																						 \n  ** Gang members will be forced to leave.\
																						 \n  ** Someone else will be able to create a gang using this name.", "Yes.", "No.");
	#pragma unused params
	return 1;
}

