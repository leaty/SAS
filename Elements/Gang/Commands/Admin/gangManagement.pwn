gang_Admin(playerid, params[])
{
	new gangid, sOption[50];
	if(sscanf(params, "ds", gangid, sOption))
	    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /gang admin [gangid] [delete/name/owner/kills/deaths/wins/losses/kick/add]");

	if(!GangInfo[gangid][Exists])
        return SendClientMessage(playerid, COLOR_FALSE, "* This gang doesn't exist.");

	if(strcmp(sOption, "delete", true, 6) == 0)
	{
	    new sGangName[MAX_GANG_NAME], sSuccess[128], sWarning[128];
	    Format(sGangName, "%s", GangInfo[gangid][GangName]);

		SendGangMsg(gangid, COLOR_FALSE, "Your gang has been deleted by an administrator.");

		for(new i = 0; i < MaxSlots; i++)
		{
		    if(PlayerInfo[i][GangID] == gangid)
		    {
	  			Gang::Leave(i);
		    }
		    if(PlayerInfo[i][GangInvited] == gangid)
			{
		        PlayerInfo[i][GangInvited] = 0;
		        Format(sWarning, "* Gang %s has been deleted by an administrator, you can no longer accept your invitation.", GangInfo[gangid][GangName]);
		        SendClientMessage(i, COLOR_FALSE, sWarning);
			}
		}

		Gang::DeleteGang(gangid);

		Format(sSuccess, "* Gang %s was successfully deleted and any online members were automatically removed from the gang.", sGangName);
		SendClientMessage(playerid, COLOR_TRUE, sSuccess);

	}
	else if(strcmp(sOption, "name", true, 4) == 0)
 	{
 	    new sNewName[MAX_GANG_NAME], sOldName[MAX_GANG_NAME], sMessage[128];
      	Format(sMessage, "* Gang Name: %s", GangInfo[gangid][GangName]);

 	    if(sscanf(params, "dss", gangid, sOption, sNewName))
 	        SendClientMessage(playerid, COLOR_TITLE, sMessage);
 	    else
 	    {
 	        if(strlen(sNewName) > MAX_GANG_NAME-1)
 	            return SendClientMessage(playerid, COLOR_FALSE, "* Too long gang name.");

			Format(sOldName, "%s", GangInfo[gangid][GangName]);

			Gang::RenameGang(gangid, sOldName, sNewName);

 	        Format(sMessage, "%s was successfully changed to %s", sMessage, sNewName);
 	        SendClientMessage(playerid, COLOR_TRUE, sMessage);

 	        Format(sMessage, "Your gangs name was changed to %s by an administrator.", sNewName);
 	        SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);
		}
 	}
 	else if(strcmp(sOption, "owner", true, 5) == 0)
 	{
 	    new newownerid, sNewOwner[MAX_PLAYER_NAME], sMessage[128];
     	Format(sMessage, "* Gang Owner: %s", GangInfo[gangid][GangOwner]);

 	    if(sscanf(params, "dsd", gangid, sOption, newownerid))
 	        SendClientMessage(playerid, COLOR_TITLE, sMessage);
		else
		{
			new oldownerid = GetPlayerID(GangInfo[gangid][GangOwner]);

			if(!IsPlayerConnected(newownerid))
			    return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't connected!");

			if(PlayerInfo[newownerid][GangID] != gangid)
			    return SendClientMessage(playerid, COLOR_FALSE, "* That player isn't even in that gang!");

			if(IsPlayerConnected(oldownerid))
			{
			    PlayerInfo[oldownerid][GangLevel] = GANG_LEVEL_MEMBER;
			    SendClientMessage(oldownerid, COLOR_INFO, "* You're no longer the gang owner.");
			}

			sNewOwner = PlayerName(newownerid);

		    Gang::SetOwner(gangid, sNewOwner);

		    PlayerInfo[newownerid][GangLevel] = GANG_LEVEL_OWNER;
		    SendClientMessage(newownerid, COLOR_INFO, "* You're the new gang owner.");

		    Format(sMessage, "%s was successfully changed to %s", sMessage, PlayerName(newownerid));
		    SendClientMessage(playerid, COLOR_TRUE, sMessage);

		    Format(sMessage, "Your gang's gang owner was set to %s by an administrator.", PlayerName(newownerid));
		    SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);
		}
 	}
 	else if(strcmp(sOption, "kills", true, 5) == 0)
 	{
 	    new iNewKills, sMessage[128];
 	    Format(sMessage, "* Gang Kills: %d", GangInfo[gangid][Kills]);

   	    if(sscanf(params, "dsd", gangid, sOption, iNewKills))
        	SendClientMessage(playerid, COLOR_TITLE, sMessage);
 	    else
 	    {
 	        GangInfo[gangid][Kills] = iNewKills;

 	        Format(sMessage, "Gang %s(s) kills was successfully changed to %d", GangInfo[gangid][GangName], iNewKills);
 	        SendClientMessage(playerid, COLOR_TRUE, sMessage);
 	    }
 	}
   	else if(strcmp(sOption, "deaths", true, 6) == 0)
 	{
 	    new iNewDeaths, sMessage[128];
 	    Format(sMessage, "* Gang Deaths: %d", GangInfo[gangid][Deaths]);

   	    if(sscanf(params, "dsd", gangid, sOption, iNewDeaths))
        	SendClientMessage(playerid, COLOR_TITLE, sMessage);
 	    else
 	    {
 	        GangInfo[gangid][Deaths] = iNewDeaths;

 	        Format(sMessage, "Gang %s(s) deaths was successfully changed to %d", GangInfo[gangid][GangName], iNewDeaths);
 	        SendClientMessage(playerid, COLOR_TRUE, sMessage);
 	    }
 	}
 	else if(strcmp(sOption, "wins", true, 4) == 0)
 	{
 	    new iNewWins, sMessage[128];
 	    Format(sMessage, "* Gang Wins: %d", GangInfo[gangid][Wins]);

   	    if(sscanf(params, "dsd", gangid, sOption, iNewWins))
        	SendClientMessage(playerid, COLOR_TITLE, sMessage);
 	    else
 	    {
 	        GangInfo[gangid][Wins] = iNewWins;

 	        Format(sMessage, "Gang %s(s) wins were successfully changed to %d", GangInfo[gangid][GangName], iNewWins);
 	        SendClientMessage(playerid, COLOR_TRUE, sMessage);
 	    }
 	}
   	else if(strcmp(sOption, "losses", true, 6) == 0)
 	{
 	    new iNewLosses, sMessage[128];
 	    Format(sMessage, "* Gang Losses: %d", GangInfo[gangid][Losses]);

   	    if(sscanf(params, "dsd", gangid, sOption, iNewLosses))
        	SendClientMessage(playerid, COLOR_TITLE, sMessage);
 	    else
 	    {
 	        GangInfo[gangid][Losses] = iNewLosses;

 	        Format(sMessage, "Gang %s(s) losses were successfully changed to %d", GangInfo[gangid][GangName], iNewLosses);
 	        SendClientMessage(playerid, COLOR_TRUE, sMessage);
 	    }
 	}
 	else if(strcmp(sOption, "kick", true, 4) == 0)
 	{
		new pid, sMessage[128];
		if(sscanf(params, "dsd", gangid, sOption, pid))
		    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /gang admin [gangid] kick [playerid]");

		if(!IsPlayerConnected(pid))
		    return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't connected.");

		if(!IsGang(pid))
		    return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't even in a gang!");

		if(PlayerInfo[pid][GangID] != gangid)
		    return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't in that gang.");

		if(IsGangOwner(playerid))
		    return SendClientMessage(playerid, COLOR_FALSE, "* This player is the gang owner, you cannot kick him.");

		Gang::Leave(pid);

		GangInfo[gangid][Members]--;

		Format(sMessage, "* You've been kicked out of gang %s by an administrator.", GangInfo[gangid][GangName]);
		SendClientMessage(pid, COLOR_INFO, sMessage);

		Format(sMessage, "%s was kicked out of the gang by an administrator.", PlayerName(pid));
		SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);

		Format(sMessage, "* %s was successfully kicked out of gang %s", PlayerName(pid), GangInfo[gangid][GangName]);
		SendClientMessage(playerid, COLOR_TRUE, sMessage);
  	}
  	else if(strcmp(sOption, "add", true, 3) == 0)
   	{
   	    new pid, sMessage[128];
		if(sscanf(params, "dsd", gangid, sOption, pid))
		    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /gang admin [gangid] add [playerid]");

		if(!IsPlayerConnected(pid))
  			return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't connected.");

		if(IsGang(pid))
		    return SendClientMessage(playerid, COLOR_FALSE, "* This player is already in a gang.");

		Gang::Join(pid, gangid);
		PlayerInfo[pid][GangLevel] = GANG_LEVEL_MEMBER;

		GangInfo[gangid][Members]++;

		Format(sMessage, "%s was forced to join the gang by an administrator.", PlayerName(pid));
		SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);

		Format(sMessage, "* %s was successfully forced to join gang %s", PlayerName(pid), GangInfo[gangid][GangName]);
		SendClientMessage(playerid, COLOR_TRUE, sMessage);
   	}
	else SendClientMessage(playerid, COLOR_USAGE, "Usage: /gang admin [gangid] [delete/name/owner/kills/deaths/wins/losses/kick/add]");

	return 1;
}
