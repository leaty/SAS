irccmd_pm(conn, channel[], user[], params[])
{
	new PlayerID,
		PM[256];
	
	FormatString("%s !pm <playerid> <message>", IRC_USAGE);
	if(sscanf(params, "ds", PlayerID, PM)) return IRC::SendNotice(user, string);
	
	FormatString2("PM from %s (IRC): %s", user, PM);
	SendClientMessage(PlayerID, COLOR_PM_FROM, string2);
	
	FormatIRC("%sPM to %s (%d): %s", IRC_COLOR_PM, PlayerName(PlayerID), PlayerID, PM);
	IRC::SendNotice(user, ircstring);

	#pragma unused conn, channel
	return 1;
}

irccmd_msg(conn, channel[], user[], params[])
{
	new Message[256], ircstring[256];
	
	Format(ircstring, "%s !msg <message>", IRC_USAGE);
	if(sscanf(params, "s", Message)) return IRC::SendNotice(user, ircstring);

	Format(ircstring, "%s%s%s(--):%s%s %s", IRC_COLOR_NAME, IRC_BOLD, user, IRC_ENDBOLD, IRC_COLOR_TEXT, Message);
	IRC::SendChanMsg(channel, ircstring);
	
	Format(ircstring, "%s (IRC): %s", user, Message);
	SendClientMessageToAll(COLOR_IRCTOIG, ircstring);

	#pragma unused conn, channel
 	return 1;
}

irccmd_cmds(conn, channel[], user[], params[])
{
	new sircLevel[1], ircLevel;
	IRC_GetUserChannelMode(conn, channel, user, sircLevel);

	ircLevel = GetIRCLevel(sircLevel);

	if(ircLevel >= IRC_LEVEL_MANAGEMENT)
	{
		IRC_Say(conn, user, "!raw,!ban,!unban,!mysql");
		IRC_Say(conn, user, "!fakemsg,!account,!changelevel");
	}
	if(ircLevel >= IRC_LEVEL_ADMIN)
	{
	    IRC_Say(conn, user, "!why,!set,!changenick");
	}
	if(ircLevel >= IRC_LEVEL_MOD)
	{
	    IRC_Say(conn, user, "!say,!kick,!admin");
	}
	if(ircLevel >= IRC_LEVEL_VIP)
	{

	}
	if(ircLevel >= IRC_LEVEL_NONE)
	{
		IRC_Say(conn, user, "!pm !msg !cmds !getid !players");
	}
	#pragma unused params
	return 1;
}

irccmd_commands(conn, channel[], user[], params[])
{
	new sircLevel[1], ircLevel;
	IRC_GetUserChannelMode(conn, channel, user, sircLevel);

	ircLevel = GetIRCLevel(sircLevel);

	if(ircLevel >= IRC_LEVEL_MANAGEMENT)
	{
		IRC_Say(conn, user, "!raw,!ban,!unban,!mysql");
		IRC_Say(conn, user, "!fakemsg,!account,!changelevel");
	}
	if(ircLevel >= IRC_LEVEL_ADMIN)
	{
	    IRC_Say(conn, user, "!why,!set,!changenick");
	}
	if(ircLevel >= IRC_LEVEL_MOD)
	{
	    IRC_Say(conn, user, "!say,!kick,!admin");
	}
	if(ircLevel >= IRC_LEVEL_VIP)
	{

	}
	if(ircLevel >= IRC_LEVEL_NONE)
	{
		IRC_Say(conn, user, "!pm !msg !cmds !getid !players");
	}

	#pragma unused params
	return 1;
}

irccmd_getid(conn, channel[], user[], params[])
{
	new player[50];
	
	FormatIRC("%s !getid <playername>", IRC_USAGE);
	if(sscanf(params, "s", player)) return IRC::SendNotice(user, ircstring);
	
	new Result[256], matches;
	
	for(new i = 0; i < MaxSlots; i++)
	{
		if(strfind(PlayerName(i), player, true, 0) != -1)
		{
		    if(!matches)
		    	format(Result, sizeof(Result), "%s(%d)", PlayerName(i), i);
			else
			    format(Result, sizeof(Result), "%s, %s(%d)", Result, PlayerName(i), i);

			matches++;
		}
		
		if(matches == 10)
		    break;
	}
	
	if(!matches)
		format(Result, sizeof(Result), "%s%sNo matches found.%s", IRC_COLOR_FALSE, IRC_BOLD, IRC_ENDBOLD);
	else
	    format(Result, sizeof(Result), "%s%sMatches (%d):%s%s %s", IRC_COLOR_TITLE, IRC_BOLD, matches, IRC_ENDBOLD, IRC_COLOR_INFO, Result);

	IRC::SendChanMsg(channel, Result);
	
	#pragma unused conn
	return 1;
}

irccmd_players(conn, channel[], user[], params[])
{
	new Result[256], playerCount;
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(!playerCount)
	        	format(Result, sizeof(Result), "%s", PlayerName(i));
			else
			    format(Result, sizeof(Result), "%s, %s", Result, PlayerName(i));
			    
       		playerCount++;
		}
	}
	
	format(Result, sizeof(Result), "%s%sPlayers (%d/%d):%s%s %s", IRC_COLOR_TITLE, IRC_BOLD, playerCount, MaxSlots, IRC_ENDBOLD, IRC_COLOR_INFO, Result);
	IRC::SendChanMsg(channel, Result);

	#pragma unused conn, params, user
	return 1;
}

irccmd_changepass(conn, channel[], user[], params[])
{
	new OldPass[128], NewPass[128], AccPass[128], NickName[128], ircstring[128];

	Format(ircstring, "%s !changepass [account] [oldpass] [newpass]", IRC_USAGE);
	if(sscanf(params, "sss", NickName, OldPass, NewPass))
	    return IRC_Say(conn, user, ircstring);
	    
	Format(ircstring, "%s This account does not exist.", IRC_ERROR);
	if(!Player::ExistsPlayer(NickName))
	    return IRC_Say(conn, user, ircstring);
	    
 	Format(ircstring, "%s Password too short (min %d).", IRC_ERROR, MIN_PASSWORD);
	if(strlen(NewPass) < MIN_PASSWORD)
	    return IRC_Say(conn, user, ircstring);
	    
	Format(ircstring, "%s Password too long (max %d).", IRC_ERROR, MAX_PASSWORD);
    if(strlen(NewPass) > MAX_PASSWORD)
        return IRC_Say(conn, user, ircstring);
	    
	OldPass = MD5_Hash(OldPass);
    NewPass = MD5_Hash(NewPass);

	Format(AccPass, "%s", Player::GetUnloadedField(NickName, "password"));

	Format(ircstring, "%s The password you entered does not match.", IRC_ERROR);
	if(strcmp(OldPass, AccPass, false, 20) != 0)
	    return IRC_Say(conn, user, ircstring);

	Player::SetUnloadedField(NickName, "password", NewPass);

	Format(ircstring, "%s Password has been changed.", IRC_SUCCESS);
	IRC_Say(conn, user, ircstring);
	
	#pragma unused channel
	return 1;
}



