irccmd_banexception(conn, channel[], user[], params[])
{
	new sPlayer[50], iOption, ircstring[128];
	
	Format(ircstring, "%s !banexception [account] [0/1]", IRC_USAGE);
	if(sscanf(params, "sd", sPlayer, iOption))
	    return IRC::SendNotice(user, ircstring);
	    
	if(iOption != 0 || iOption != 1)
	    return IRC::SendNotice(user, ircstring);
	    
	Format(ircstring, "%s This account does not exist.", IRC_ERROR);
	if(!Player::ExistsPlayer(sPlayer))
	    return IRC::SendNotice(user, ircstring);

	Player::SetUnloadedFieldInt(sPlayer, "isban", iOption+1);
	    
	Format(ircstring, "%s %s is now allowed to join the server.", sPlayer, IRC_SUCCESS);
	IRC::SendNotice(user, ircstring);

	#pragma unused conn, channel
	return 1;
}

irccmd_raw(conn, channel[], user[], params[])
{
	new rawstr[256];
	FormatString("%s !raw <command>", IRC_USAGE);
	if(sscanf(params, "s", rawstr)) return IRC::SendNotice(user, string);
	
	SendRconCommand(rawstr);
	
	FormatString2("Raw Command %s: %s", user, rawstr);
	SendProAdminMsg(string2);

	#pragma unused conn, channel
	return 1;
}

irccmd_gmx(conn, channel[], user[], params[])
{
	new ircstring[128], sMessage[128], sReason[128];

	Format(ircstring, "%s !gmx <reason>", IRC_USAGE);
	if(sscanf(params, "s", sReason))
	    return IRC::SendNotice(user, ircstring);

	Format(sMessage, "%s used 'gmx'", user);
	SendAdminMsg(sMessage);

	Server::Exit(sReason);
	#pragma unused conn, channel
	return 1;
}

irccmd_ban(conn, channel[], user[], params[])
{
	new reason[256],
		PlayerID;

    FormatString("%s !ban <id> <reason>", IRC_USAGE);
	if(sscanf(params, "ds", PlayerID, reason)) return IRC::SendNotice(user, string);

 	Player::Ban(PlayerID, user, reason);

	#pragma unused conn, channel
	return 1;
}

irccmd_banip(conn, channel[], user[], params[])
{
	#pragma unused conn, channel, user, params
	return 1;
}

irccmd_unban(conn, channel[], user[], params[])
{
	new player[50];

	FormatIRC("%s !unban <playername>", IRC_USAGE);
	if(sscanf(params, "s", player)) return IRC::SendNotice(user, ircstring);
	
	FormatIRC2("%s This user isn't banned, or he/she isn't registered.", IRC_ERROR);
	if(!Player::IsBanName(player)) return IRC::SendNotice(user, ircstring2);
	    
	Player::Unban(player, user);
	
	FormatString("%s %s is now unbanned.", IRC_SUCCESS, player);
	IRC::SendNotice(user, string);

	#pragma unused conn, channel
	return 1;
}

irccmd_mysql(conn, channel[], user[], params[])
{
	new Option[50], ircstring[128];

    Format(ircstring, "%s !mysql <ordertable/altertable>", IRC_USAGE);
	if(sscanf(params, "s", Option))
		return IRC::SendNotice(user, ircstring);
		
	if(strcmp(Option, "ordertable", false, 10) == 0)
	{
	    new table[100], field[100];
	    
	    Format(ircstring, "%s !mysql ordertable <table> <field>", IRC_USAGE);
		if(sscanf(params, "sss", Option, table, field)) return IRC::SendNotice(user, ircstring);

		MySQL::ResetAutoIncrement(table);
		MySQL::ReOrderTable(table, field);
	}
	else if(strcmp(Option, "altertable", false, 7) == 0)
 	{
 	    new table[100], alterstring[256];
 	    
 	    Format(ircstring, "%s !mysql altertable <table> <addquery>", IRC_USAGE);
  		if(sscanf(params, "sss", Option, table, alterstring)) return IRC::SendNotice(user, ircstring);

  		MySQL::AlterTable(table, alterstring);
 	}

	#pragma unused conn, channel
	return 1;
}

irccmd_fakemsg(conn, channel[], user[], params[])
{
	new playerid, message[256];
	
	FormatIRC("%s !fakemsg <playerid> <message>", IRC_USAGE);
	if(sscanf(params, "ds", playerid, message))
	    return IRC::SendNotice(user, ircstring);

	for(new i = 0; i < MaxSlots; i++)
	{
	    if(PlayerInfo[i][pMode] == PlayerInfo[playerid][pMode])
			SendPlayerMessageToPlayer(i, playerid, message);
	}
	
	FormatIRC2("2[--] 7%s: 1%s", PlayerName(playerid), message);
	IRC::SendChanMsg(channel, ircstring2);

	#pragma unused conn
	return 1;
}

irccmd_account(conn, channel[], user[], params[])
{
	new player[50], variable[128], value[256];
	FormatString("%s !account <playername> <variable> <optional:value>", IRC_USAGE);
	if(sscanf(params, "ss", player, variable)) return IRC::SendNotice(user, string);

    MySQL_Vars

	if(sscanf(params, "sss", player, variable, value)) // If user didn't enter any value, show them the current value
	{
		MySQL_Format("SELECT %s FROM %s WHERE username = '%s'", MySQL::Escape(variable), Table_users, MySQL::Escape(player));
		
		MySQL_Query
		MySQL_Result
		
		MySQL_FetchPrepare
		{
		    MySQL_FetchRow(value, variable);
		}
		
		FormatIRC("%s: %s", variable, value);
		IRC::SendNotice(user, ircstring);
	}
	else
	{
	    new ircstring[256];
	    
	    if(isNumeric(value))
		{
			MySQL_Format("UPDATE %s SET %s = %d WHERE username = '%s'", Table_users, MySQL::Escape(variable), strval(value), MySQL::Escape(player));
			format(ircstring, sizeof(ircstring), "Variable %s in account %s was set to %d.", variable, player, strval(value));
		}
		else
		{
			MySQL_Format("UPDATE %s SET %s = '%s' WHERE username = '%s'", Table_users, MySQL::Escape(variable), MySQL::Escape(value), MySQL::Escape(player));
			format(ircstring, sizeof(ircstring), "Variable %s in account %s was set to %s.", variable, player, value);
		}
		
		
		MySQL_Query
		
		IRC::SendNotice(user, ircstring);
	}
	
	#pragma unused conn, channel
	return 1;
}

irccmd_changelevel(conn, channel[], user[], params[])
{
	new player[50], level, sError[128], sSuccess[128];
	Format(sError, "%s !changelevel <playername> <level>", IRC_USAGE);
	if(sscanf(params, "sd", player, level)) return IRC::SendNotice(user, sError);
	
 	Format(sError, "%s This account doesn't exist.", IRC_ERROR);
	if(!Player::ExistsPlayer(player))
		return IRC::SendNotice(user, sError);
		
	Format(sError, "%s Max level: %d", IRC_ERROR, LEVEL_MANAGEMENT);
	if(level > LEVEL_MANAGEMENT)
	    return IRC::SendNotice(user, sError);
	
	new sLevel[4][20] = { "a player", "a moderator", "an administrator", "management" };
	new type[50];

	MySQL_Vars
	
	if(IsPlayerOnline(player))
	{
	    new playerid = GetPlayerID(player);
	    
	    if(PlayerInfo[playerid][AdminLevel] > level)
     		type = "demoted";
	        
		if(PlayerInfo[playerid][AdminLevel] < level)
		    type = "promoted";
		    
		PlayerInfo[playerid][AdminLevel] = level;

		Format(sSuccess, "* You got %s to %s by management.", type, sLevel[level]);
	    SendClientMessage(playerid, COLOR_INFO, sSuccess);
	}

	MySQL_Format("UPDATE %s SET admin = %d WHERE username = '%s'", Table_users, level, MySQL::Escape(player));
	
	MySQL_Query
	
	Format(sSuccess, "%s %s is now %s.", IRC_SUCCESS, player, sLevel[level]);
	IRC::SendNotice(user, sSuccess);

	#pragma unused conn, channel
	return 1;
}

irccmd_fixbots(conn, channel[], user[], params[])
{
	IRC::Disconnect();
	IRC_Reconnect = true;
	SetTimer("IRC_FixBots", 10000, false);
	#pragma unused conn, channel, user, params
	return 1;
}

forward IRC_FixBots();
public IRC_FixBots()
{
	IRC_Reconnect = false;
	IRC::Connect();
}
