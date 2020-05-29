stock IsMod(playerid)
{
	if(PlayerInfo[playerid][AdminLevel] >= LEVEL_MOD)
		return 1;

	return 0;
}

stock IsAdmin(playerid)
{
	if(PlayerInfo[playerid][AdminLevel] >= LEVEL_ADMIN)
		return 1;

	return 0;
}

stock IsManagement(playerid)
{
	if(PlayerInfo[playerid][AdminLevel] >= LEVEL_MANAGEMENT)
		return 1;

	return 0;
}

stock SendDevMsg(const player[], const bugreport[])
{

	FormatString("[Bugreport] %s: %s", player, bugreport);
	WriteToLog(LOG_DEV, string);

	FormatIRC("%s%s[Bugreport]%s %s:%s %s", IRC_COLOR_TITLE, IRC_BOLD, IRC_ENDBOLD, player, IRC_COLOR_INFO, bugreport);
	IRC::SendDevMsg(ircstring);

	return 1;
}

stock SendAdminChatMsg(playerid, const type[], const message[])
{
	new string[256], ircstring[256];
	if(strcmp(type, "Player", false, strlen(type)) == 0)
	{
		format(string, sizeof(string), "[%s] %s(%d): %s", type, PlayerName(playerid), playerid, message);
		format(ircstring, sizeof(ircstring), "%s%s[%s]%s %s(%d): %s", IRC_COLOR_ADMINCHAT, IRC_BOLD, type, IRC_ENDBOLD, PlayerName(playerid), playerid, message);
	}
	else if(strcmp(type, "Crew", false, strlen(type)) == 0)
	{
 		format(string, sizeof(string), "[%s] %s (%d): %s", type, PlayerName(playerid), playerid, message);
        format(ircstring, sizeof(ircstring), "%s%s[%s]%s %s (%d): %s", IRC_COLOR_ADMINCHAT, IRC_BOLD, type, IRC_ENDBOLD, PlayerName(playerid), playerid, message);
	}
	// Using !admin from irc, type = username
	else if(playerid == -1)
	{
		format(string, sizeof(string), "[Crew] %s (IRC): %s", type, message);
        format(ircstring, sizeof(ircstring), "%s%s[Crew]%s %s (IRC): %s", IRC_COLOR_ADMINCHAT, IRC_BOLD, IRC_ENDBOLD, type, message);
	}
	for(new i = 0; i < MaxSlots; i++)
	{
		if(IsPlayerConnected(i) == 1 && PlayerInfo[i][AdminLevel] > 0)
		{
			SendClientMessage(i, COLOR_ADMINCHAT, string);
		}
	}

	IRC::SendHOPMsg(ircstring, EchoChan);
	return 1;
}

stock SendProAdminMsg(const string[])
{
	new sMessage[256];
	format(sMessage, sizeof(sMessage), "[Management] %s", string);
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
		if(PlayerInfo[i][AdminLevel] == LEVEL_MANAGEMENT)
		{
			SendClientMessage(i, COLOR_PROADMIN, sMessage);
		}
	}
	format(sMessage, sizeof(sMessage), "%s%s[Management]%s %s", IRC_COLOR_NOTICE, IRC_BOLD, IRC_ENDBOLD, string);
	IRC::SendSOPMsg(sMessage, AdminChan);
	return 1;
}

stock SendAdminMsg(const string[])
{
   	new sMessage[256];
	format(sMessage, sizeof(sMessage), "[Admin] %s", string);
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
		if(PlayerInfo[i][AdminLevel] >= LEVEL_ADMIN)
		{
			SendClientMessage(i, COLOR_ADMIN, sMessage);
		}
	}
	format(sMessage, sizeof(sMessage), "%s%s[Admin]%s %s", IRC_COLOR_NOTICE, IRC_BOLD, IRC_ENDBOLD, string);
	IRC::SendOPMsg(sMessage, AdminChan);
	return 1;
}

stock SendModMsg(const string[])
{
   	new sMessage[256];
	format(sMessage, sizeof(sMessage), "[Mod] %s", string);
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
		if(PlayerInfo[i][AdminLevel] >= LEVEL_MOD)
		{
			SendClientMessage(i, COLOR_MOD, sMessage);
		}
	}
	format(sMessage, sizeof(sMessage), "%s%s[Mod]%s %s", IRC_COLOR_NOTICE, IRC_BOLD, IRC_ENDBOLD, string);
	IRC::SendHOPMsg(sMessage, AdminChan);
	return 1;
}
