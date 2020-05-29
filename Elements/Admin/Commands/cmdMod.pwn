sas_Spec(playerid, params[])
{
	new sPlayer[50], iPlayer;
	if(sscanf(params, "s", sPlayer))
		return SendClientMessage(playerid, COLOR_TITLE, "Usage: /spec [playerid/playername]");

	if(isNumeric(sPlayer))
        iPlayer = strval(sPlayer);
	else
	    iPlayer = ReturnPlayer(sPlayer);
	    
	P_OnCommand(playerid, iPlayer, "spec");
	return 1;
}

sas_Specoff(playerid, params[])
{
	if(PlayerInfo[playerid][Spectating] == false)
	    return SendClientMessage(playerid, COLOR_FALSE, "* You're not spectating!");
	    
	Spectate::Stop(playerid);
	#pragma unused params
	return 1;
}

sas_Kick(playerid, params[])
{
    if(!PlayerInfo[playerid][AdminLevel]) return false;

	new id, reason[128];

	if(sscanf(params, "ds", id, reason)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /kick [playerid] [reason]");

	Player::Kick(id, PlayerName(playerid), reason);

	return 1;
}

sas_Ban(playerid, params[])
{
	new id, reason[128];
	if(sscanf(params, "ds", id, reason)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /ban [playerid] [reason]");

	if(IsAdmin(playerid))
		Player::Ban(id, PlayerName(playerid), reason);

	else if(IsMod(playerid))
	{
		FormatString("* Your request to ban %s for '%s' has been made.", PlayerName(id), reason);
	    SendClientMessage(playerid, COLOR_TRUE, string);
		FormatString2("%s requested a ban on %s for: %s", PlayerName(playerid), PlayerName(id), reason);
	    SendAdminMsg(string2);
	}

	return 1;
}

sas_Show(playerid, params[])
{
	new sOption[50];
	if(sscanf(params, "s", sOption)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /show [eng/caps/report/swear]");
	
	if(strcmp(sOption, "eng", true, 3) == 0)
	{
 		SendClientMessage(playerid, COLOR_FALSE, "=============================");
	    SendClientMessage(playerid, COLOR_INFO,  "We prefer english in the mainchat, please try to");
		SendClientMessage(playerid, COLOR_INFO,  "use /pm for other languages as much as you can..");
	    SendClientMessage(playerid, COLOR_FALSE, "=============================");
	    return 1;
 	}
 	else if(strcmp(sOption, "caps", true, 4) == 0)
  	{
 		SendClientMessage(playerid, COLOR_FALSE, "=============================");
	    SendClientMessage(playerid, COLOR_INFO,  "Please do not use CAPITAL letters.");
	    SendClientMessage(playerid, COLOR_FALSE, "=============================");
	    return 1;
  	}
	else if(strcmp(sOption, "report", true, 6) == 0)
	{
		SendClientMessage(playerid, COLOR_FALSE, "=============================");
	    SendClientMessage(playerid, COLOR_INFO,  "Do not report rulebreakers in the mainchat! Please use @report id/name reason.");
	    SendClientMessage(playerid, COLOR_FALSE, "=============================");
	    return 1;
	}
	else if(strcmp(sOption, "swear", true, 5) == 0)
	{
 		SendClientMessage(playerid, COLOR_FALSE, "=============================");
	    SendClientMessage(playerid, COLOR_INFO,  "Do not swear at, flame or insult other players. Watch your language.");
	    SendClientMessage(playerid, COLOR_FALSE, "=============================");
		return 1;
	}
	else SendClientMessage(playerid, COLOR_USAGE, "Usage: /show [eng/caps/report/swear]");
	return 1;
}

sas_Heal(playerid, params[])
{
    if(!PlayerInfo[playerid][AdminLevel]) return false;
    
    new id;
    
	if(sscanf(params, "d", id))
	{
	    SetPlayerHealth(playerid, 100);
	    SetPlayerArmour(playerid, 100);
	}
	else
	{
	    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_FALSE, "* Invalid playerid.");

		SetPlayerHealth(id, 100);
		SetPlayerArmour(id, 100);
		
		FormatString("%s healed %s.", PlayerName(playerid), PlayerName(id));
		SendModMsg(string);
	}
	
	return 1;
}

sas_Acmds(playerid, params[])
{
	if(IsManagement(playerid))
	{
		SendClientMessage(playerid, COLOR_TITLE, "** Management Commands **");
		SendClientMessage(playerid, COLOR_INFO, "/s, /goto");
	}
	if(IsAdmin(playerid))
	{
		SendClientMessage(playerid, COLOR_TITLE, "** Admin Commands **");
		SendClientMessage(playerid, COLOR_INFO, "/v, /f, /cf, /move, /create, /miniend, /minireset");
 	}
    if(IsMod(playerid))
 	{
 		SendClientMessage(playerid, COLOR_TITLE, "** Mod Commands **");
		SendClientMessage(playerid, COLOR_INFO, "/p, /kick, /ban, /show");
		SendClientMessage(playerid, COLOR_INFO, "/heal, /acmds, /world");
		SendClientMessage(playerid, COLOR_TITLE, "------------------------");
 	}

	#pragma unused params
	return 1;
}

