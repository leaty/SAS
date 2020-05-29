irccmd_addnote(conn, channel[], user[], params[])
{
	new player[30], note[256], ircstring[128];
	
	if(sscanf(params, "ss", player, note))
	{
	    Format(ircstring, "%s !addnote <playername> <note>", IRC_USAGE);
 		return IRC::SendNotice(user, ircstring);
	}
	
	Format(ircstring, "%s This player doesn't exist.", IRC_ERROR);
	if(!Player::ExistsPlayer(player))
	    return IRC::SendNotice(user, ircstring);
	
	Format(note, "+N %s", note);
	
	Player::AddNote(player, user, note);
	
    Format(ircstring, "%s New note was added to %s.", IRC_SUCCESS, player);
	IRC::SendNotice(user, ircstring);
	
	#pragma unused conn, channel
	return 1;
}

irccmd_why(conn, channel[], user[], params[])
{
	new player[30], event[128], iCount;
	if(sscanf(params, "ss", player, event))
 	{
		FormatIRC("%s !why <playername> <event>", IRC_USAGE);
 		return IRC::SendNotice(user, ircstring);
  	}

	new result[256], showresult[256], filename[128], File:userlog;
	
	Format(filename, "/userlogs/%s.txt", player);

	if(!fexist(filename))
 		return IRC_Say(conn, user, "No records found.");
	
	userlog = fopen(filename, io_read);

	while(fread(userlog, result))
	{
	    if(strfind(result, event, false, 0) != -1)
	    {
		    Format(showresult, "%s%s%s%s", IRC_COLOR_INFO, IRC_BOLD, result, IRC_BOLD);
			IRC_Say(conn, user, showresult);
			iCount++;
		}
	}
	
	fclose(userlog);
	
	if(iCount < 1)
 		return IRC_Say(conn, user, "No records found.");
	
	/*
	//If there are, sort them and pipe them out one message at a time
	for(new i = 0; i < strlen(notes); i++)
	{
		start = strfind(notes, "~", true, charpos) + 1;
		end = strfind(notes, "~", true, charpos+1);

		// If no notes are left, quit loopin'
		if(start == -1 || end == -1)
		    break;

		charpos = end;

		strmid(result, notes, start, end, sizeof(result));

		IRC::SendNotice(user, result);
	}*/

	#pragma unused conn, channel
	return 1;
}

irccmd_changenick(conn, channel[], user[], params[])
{
	new oldnick[MAX_PLAYER_NAME], newnick[MAX_PLAYER_NAME], olduserlog[128], newuserlog[128], logtext[256];
	FormatIRC("%s !changenick <oldnick> <newnick>", IRC_USAGE);
	if(sscanf(params, "ss", oldnick, newnick)) return IRC::SendNotice(user, ircstring);

    FormatIRC2("%s Max 20 chars.", IRC_ERROR);
	if(strlen(oldnick) > MAX_PLAYER_NAME || strlen(newnick) > MAX_PLAYER_NAME)
		return IRC::SendNotice(user, ircstring2);
		
    FormatString("%s This account doesn't exist.", IRC_ERROR);
	if(!Player::ExistsPlayer(oldnick))
		return IRC::SendNotice(user, string);
		
  	FormatString2("%s An account with username %s already exists.", IRC_ERROR, newnick);
	if(Player::ExistsPlayer(newnick))
		return IRC::SendNotice(user, string2);
		
	for(new i = 1; i < GangCount + 1; i++)
	{
	    if(strcmp(GangInfo[i][GangOwner], oldnick, true, MAX_PLAYER_NAME) == 0)
	    {
			GangInfo[i][GangOwner] = newnick;
			break;
		}
	}

	Format(logtext, "+NC %s to %s", oldnick, newnick);
    Player::AddNote(oldnick, user, logtext);

	Format(olduserlog, "/userlogs/%s.txt", oldnick);
	Format(newuserlog, "/userlogs/%s.txt", newnick);
	fcopytextfile(olduserlog, newuserlog);
		
	MySQL_Vars
	MySQL_Format("UPDATE %s SET username = '%s' WHERE username = '%s'", Table_users, MySQL::Escape(newnick), MySQL::Escape(oldnick));
	
	MySQL_Query

	format(string, sizeof(string), "%s is now known as %s!", oldnick, newnick);
	SendNews(string);
		
	if(IsPlayerOnline(oldnick))
	{
	    new playerid = GetPlayerID(oldnick);
	    SetPlayerName(playerid, newnick);
	    
	    format(string2, sizeof(string2), "* Your account's nickname was changed to %s by an administrator.", newnick);
    	SendClientMessage(playerid, COLOR_TRUE, string2);
    	SendClientMessage(playerid, COLOR_INFO, "** Was this wrong? Do you want your old nick back?");
		SendClientMessage(playerid, COLOR_INFO, "** Please report to crew using @report [text].");
	}

	#pragma unused conn, channel
	return 1;
}

irccmd_set(conn, channel[], user[], params[])
{
	new Option[50];
	
	sscanf(params, "s", Option);
	    
	if(strcmp(Option, "time", true, 4) == 0)
 	{
		new iTime;
 	    FormatIRC("%s !set time <time>", IRC_USAGE);
	  	if(sscanf(params, "sd", Option, iTime)) return IRC::SendNotice(user, ircstring);

		SetWorldTime(iTime);

		FormatString("%s set the time to %d.", user, iTime);
		SendAdminMsg(string);
 	}
 	else if(strcmp(Option, "weather", true, 7) == 0)
 	{
 	    new WeatherID;
	  	FormatIRC("%s !weather <weatherid>", IRC_USAGE);
		if(sscanf(params, "sd", Option, WeatherID)) return IRC::SendNotice(user, ircstring);

		SetWeather(WeatherID);

		FormatString("%s set the weather to %d", user, WeatherID);
		SendAdminMsg(string);
 	}
 	else
	{
		FormatIRC("%s !set <time/weather>", IRC_USAGE);
	  	return IRC::SendNotice(user, ircstring);
	}
	#pragma unused conn, channel
	return 1;
}
