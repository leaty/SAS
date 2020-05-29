Player__RegisterPlayer(playerid, password[])
{
	MySQL_Vars_L
	MySQL_Format("INSERT INTO users (username, password, ip) VALUES ('%s', '%s', '%s')", MySQL::Escape(PlayerName(playerid)), MySQL::Escape(MD5_Hash(password)), MySQL::Escape(PlayerInfo[playerid][PlayerIP]));
	MySQL_Query

	if(Player::ExistsPlayer(PlayerName(playerid)))
	{
		SendClientMessage(playerid, COLOR_TRUE, "* Congratulations!");

		PlayerInfo[playerid][Registered] = TRUE;
		PlayerInfo[playerid][LoggedIn] = TRUE;

    	FormatString("* Please welcome %s to SAS!", PlayerName(playerid));
    	SendClientMessageToAll(COLOR_PUBLIC, string);
    	
    	

		FormatReport("[Player]: Account for %s successfully created.", PlayerName(playerid));
		SendReport(reportstring);
	}
	else
	{
		SendClientMessage(playerid, COLOR_FALSE, "* Failed to create account, please rejoin.");

		FormatReport("[Player]: Failed to create account for %s.", PlayerName(playerid));
		SendReport(reportstring);
		return 0;
	}

	return 1;
}

Player__LoginPlayer(playerid, password[])
{
	new userpassword[100];

	MySQL_Vars
	MySQL_Format("SELECT password FROM users WHERE username = '%s'", MySQL::Escape(PlayerName(playerid)));
	MySQL_Query
 	MySQL_Result

	MySQL_FetchPrepare
	{
		MySQL_FetchRow(userpassword, "password");
	}

	MySQL_Free

	if(strcmp(userpassword, MD5_Hash(password), false, 20) == 0)
	{
	    PlayerInfo[playerid][LoggedIn] = TRUE;
		return 1;
	}
	else
	{
	    PlayerInfo[playerid][LoggedIn] = FALSE;
		return 0;
	}
}

Player__ExistsPlayer(const player[])
{
	new Rows;

	MySQL_Vars
	MySQL_Format("SELECT * FROM users WHERE username = '%s'", MySQL::Escape(player));
	
	MySQL_Query
 	MySQL_Result
 	Rows = MySQL_NumRows;
 	MySQL_Free

	if(Rows > 0)
	{
	 	return 1;
	}
	return 0;
}

// * Name: IsBan
// * Author: iou
// * Function: checks account for isban and IP matches of previous bans
Player__IsBan(playerid)
{
	new result[20], isban;

    MySQL_Vars

	if(Player::ExistsPlayer(PlayerName(playerid)))
	{
		MySQL_Format("SELECT isban FROM %s WHERE username = '%s'", Table_users, MySQL::Escape(PlayerName(playerid)));
		
		MySQL_Query
	 	MySQL_Result

	 	MySQL_FetchPrepare
	 	{
			MySQL_FetchRow(result, "isban");
			isban = strval(result);
		}

		MySQL_Free

		if(isban == BAN_EXCEPTION)
		    return 0;
	}

	// If his account isn't banned or he doesn't have one, check if any other bans has the same IP
	if(!isban)
	{
	    new Rows;

    	MySQL_Format("SELECT * FROM %s WHERE ip = '%s'", Table_bans, MySQL::Escape(PlayerInfo[playerid][PlayerIP]));
		
		MySQL_Query
		MySQL_Result

	 	Rows = MySQL_NumRows;

		MySQL_Free

	 	// If there is, ban the player for evading
	 	if(Rows > 0)
	 	    isban = TRUE;
	}

	return isban;
}

// * Name: IsBanName
// * Author: iou
// * Function: Same as IsBan, but uses a playername instead
// * Note: Is not as effective and accurate as IsBan, but it uses no playerid
Player__IsBanName(const player[])
{
	if(!Player::ExistsPlayer(player))
	    return 0;

	new result[20], isban, playerIP[20];

	MySQL_Vars
	MySQL_Format("SELECT * FROM %s WHERE username = '%s'", Table_users, MySQL::Escape(player));
	
	MySQL_Query
 	MySQL_Result

 	MySQL_FetchPrepare
 	{
		MySQL_FetchRow(result, "isban");
		isban = strval(result);

		MySQL_FetchRow(playerIP, "ip");
	}

	MySQL_Free

	if(!isban)
	{
	    new Rows;
		MySQL_Format("SELECT * FROM %s WHERE ip = '%s'", Table_bans, MySQL::Escape(playerIP));
		
		MySQL_Query
		MySQL_Result

	 	Rows = MySQL_NumRows;

		MySQL_Free

	 	// If there is, ban the player for evading
	 	if(Rows > 0)
	 	    isban = TRUE;
	}

	return isban;
}

Player__MatchIP(playerid)
{
	new IP[20];

	MySQL_Vars
	MySQL_Format("SELECT ip FROM %s WHERE username = '%s'", Table_users, MySQL::Escape(PlayerName(playerid)));

	
	MySQL_Query
 	MySQL_Result

 	MySQL_FetchPrepare
 	{
		MySQL_FetchRow(IP, "ip");
	}

	MySQL_Free

	if(strcmp(PlayerInfo[playerid][PlayerIP], IP, false, 20) == 0) return 1;
	return 0;
}


Player__FetchData(playerid)
{
	new result[256];

	MySQL_Vars_L
	MySQL_Format("SELECT admin, \
						 lastfc, \
						 skinid, \
						 bankvalue, \
						 banklevel, \
						 propcount, \
						 lootcount, \
						 kills, \
						 deaths, \
						 gang, \
						 playtime, \
						 f_time, \
						 t_time FROM %s WHERE username = '%s'", Table_users, MySQL::Escape(PlayerName(playerid)));
	
	MySQL_Query
	MySQL_Result

	MySQL_FetchPrepare
	{
	    MySQL_FetchRow(result, "admin");
		PlayerInfo[playerid][AdminLevel] = strval(result);

		MySQL_FetchRow(result, "lastfc");
		PlayerInfo[playerid][LastFC] = strval(result);

		MySQL_FetchRow(result, "skinid");
		PlayerInfo[playerid][SkinID] = strval(result);
		
		MySQL_FetchRow(result, "bankvalue");
		PlayerInfo[playerid][BankValue] = strval(result);
		
		MySQL_FetchRow(result, "banklevel");
		PlayerInfo[playerid][BankLevel] = strval(result);

		MySQL_FetchRow(result, "kills");
		PlayerInfo[playerid][Kills] = strval(result);

		MySQL_FetchRow(result, "deaths");
		PlayerInfo[playerid][Deaths] = strval(result);
		
		MySQL_FetchRow(result, "playtime");
		PlayerInfo[playerid][PlayTime] = strval(result);
		
		MySQL_FetchRow(result, "f_time");
		PlayerInfo[playerid][F_Time] = strval(result);

		MySQL_FetchRow(result, "t_time");
		PlayerInfo[playerid][T_Time] = strval(result);
		
		MySQL_FetchRow(result, "propcount");
		PlayerInfo[playerid][TotalPropCount] = strval(result);

		MySQL_FetchRow(result, "lootcount");
		PlayerInfo[playerid][TotalLootCount] = strval(result);
		
		MySQL_FetchRow(PlayerInfo[playerid][GangName], "gang");
	}

	MySQL_Free

	FormatReport("[Player]: Successfully fetched data for %s.", PlayerName(playerid));
	SendReport(reportstring);

	return 1;
}

Player__UpdateData(playerid)
{
	if(PlayerInfo[playerid][Registered] == FALSE) return 0;
	if(PlayerInfo[playerid][LoggedIn] == FALSE) return 0;
	if(PlayerInfo[playerid][Started] == FALSE) return 0;

	MySQL_Vars_L
	MySQL_Format("UPDATE %s SET lastfc = %d, \
	                            skinid = %d, \
	                            banklevel = %d, \
	                            bankvalue = %d, \
								propcount = %d, \
								lootcount = %d, \
								kills = %d, \
								deaths = %d, \
								gang = '%s', \
								ip = '%s', \
								playtime = %d, \
								t_time = %d, \
								f_time = %d WHERE username = '%s'",
								Table_users,
								PlayerInfo[playerid][LastFC],
								PlayerInfo[playerid][SkinID],
								
								PlayerInfo[playerid][BankLevel],
								PlayerInfo[playerid][BankValue],
								PlayerInfo[playerid][TotalPropCount],
								PlayerInfo[playerid][TotalLootCount],
								PlayerInfo[playerid][Kills],
								PlayerInfo[playerid][Deaths],
								
								MySQL::Escape(PlayerInfo[playerid][GangName]),
								MySQL::Escape(PlayerInfo[playerid][PlayerIP]),
								GetPlayerPlayTime(playerid, MODE_NEUTRAL),
								GetPlayerPlayTime(playerid, MODE_TRAINING),
								GetPlayerPlayTime(playerid, MODE_FREEROAM),
								MySQL::Escape(PlayerName(playerid)));
	
	MySQL_Query

	return 1;
}

Player__ResetInfo(playerid)
{
	PlayerInfo[playerid][Registered] = 0;
	PlayerInfo[playerid][LoggedIn] = 0;
	PlayerInfo[playerid][LoginTries] = 0;
	PlayerInfo[playerid][Started] = 0;
	PlayerInfo[playerid][AdminLevel] = 0;
	//PlayerInfo[playerid][TimeAtConnect] = 0;
	PlayerInfo[playerid][PlayTime] = 0;
	PlayerInfo[playerid][F_Time] = 0;
	PlayerInfo[playerid][T_Time] = 0;
	PlayerInfo[playerid][pMode] = 0;
	PlayerInfo[playerid][WeaponSet] = 0;
	PlayerInfo[playerid][LastPM] = -1;
	PlayerInfo[playerid][LastFC] = 0;
	PlayerInfo[playerid][LastProp] = 0;
	PlayerInfo[playerid][SkinID] = 0;
	PlayerInfo[playerid][BankLevel] = 0;
	PlayerInfo[playerid][BankValue] = 0;
	PlayerInfo[playerid][Dialog] = 0;
	PlayerInfo[playerid][Menu] = Menu:-1;
	PlayerInfo[playerid][Rampid] = 4;
	PlayerInfo[playerid][Ramping] = false;
	PlayerInfo[playerid][VehFunct] = false;
	PlayerInfo[playerid][Hax] = false;
	PlayerInfo[playerid][Frozen] = false;
	PlayerInfo[playerid][Muted] = false;
	PlayerInfo[playerid][Jailed] = false;
	PlayerInfo[playerid][Spectating] = false;
	PlayerInfo[playerid][Paralyzed] = false;
	PlayerInfo[playerid][IsGod] = false;
	PlayerInfo[playerid][OnATM] = false;
	PlayerInfo[playerid][Hidden] = false;
	PlayerInfo[playerid][Switchmode] = false;
	PlayerInfo[playerid][MuteTime] = 0;
	PlayerInfo[playerid][JailTime] = 0;
	PlayerInfo[playerid][OldMuteTime] = 0;
	PlayerInfo[playerid][OldJailTime] = 0;
	PlayerInfo[playerid][SpecID] = -1;
	PlayerInfo[playerid][Kills] = 0;
	PlayerInfo[playerid][Deaths] = 0;
	PlayerInfo[playerid][GangID] = 0;
	PlayerInfo[playerid][GangLevel] = 0;
	PlayerInfo[playerid][GangInvited] = -1;
	PlayerInfo[playerid][Hardcore] = 0;
	PlayerInfo[playerid][HC_HP] = 100.0;
	PlayerInfo[playerid][HC_ARM] = 100.0;
	
	
	StrReset(PlayerInfo[playerid][GangName]);
	
	Ramping::OnReset(playerid);
	Property::OnReset(playerid);
	Loot::OnReset(playerid);

	return 1;
}

Player__AddNote(const player[], const adder[], note[])
{
	new filename[128], File:userlog;
	new year, month, day; getdate(year, month, day);
	new hour, minute, second; gettime(hour, minute, second);

	format(filename, sizeof(filename), "/userlogs/%s.txt", player);
	format(note, 300, "[%d/%d/%d][%d:%d] %s (by %s)\n", year, month, day, hour, minute, note, adder);

	userlog = fopen(filename, io_append);

	fwrite(userlog, note);
	fclose(userlog);
	
	return 1;
}

Player__Kick(kickid, const kickername[], reason[])
{
    new logtext[256];

	// Add kick to database
	MySQL_Vars_L
	MySQL_Format("INSERT INTO %s (player, reason, ip, kicker) VALUES ('%s', '%s', '%s', '%s')", Table_kicks, MySQL::Escape(PlayerName(kickid)), MySQL::Escape(reason), MySQL::Escape(PlayerInfo[kickid][PlayerIP]), MySQL::Escape(kickername));
	
	MySQL_Query
	
	Format(logtext, "+K %s", reason);

	// Does the player have an account? If yes, add a note to the player's log
	if(Player::ExistsPlayer(PlayerName(kickid)))
		Player::AddNote(PlayerName(kickid), kickername, logtext);

	FormatKick("** %s has been kicked: %s", PlayerName(kickid), reason);
	SendClientMessageToAll(COLOR_KICKBAN, kickstring);

	FormatString("%s kicked %s: %s", kickername, PlayerName(kickid), reason);
	SendAdminMsg(string);

	Kick(kickid);

	return 1;
}

Player__Ban(banid, const bannername[], reason[])
{
    new logtext[256];
    
	// Add ban to the database
	MySQL_Vars_L
	MySQL_Format("INSERT INTO %s (player, reason, ip, banner) VALUES ('%s', '%s', '%s', '%s')", Table_bans, MySQL::Escape(PlayerName(banid)), MySQL::Escape(reason), MySQL::Escape(PlayerInfo[banid][PlayerIP]), MySQL::Escape(bannername));
	
	MySQL_Query

    Format(logtext, "+B %s", reason);

	// Does the player have an account?
	if(Player::ExistsPlayer(PlayerName(banid)))
	{
		// Prevent player from joining again
		MySQL_Format("UPDATE %s SET isban = %d WHERE username = '%s'",
									Table_users,
									TRUE,
									MySQL::Escape(PlayerName(banid)));
		
		MySQL_Query

		// Add note to the player's account
		Player::AddNote(PlayerName(banid), bannername, logtext);
	}

	FormatBan("** %s has been banned: %s", PlayerName(banid), reason);
	SendClientMessageToAll(COLOR_KICKBAN, banstring);

	FormatString("%s banned %s: %s", bannername, PlayerName(banid), reason);
	SendAdminMsg(string);

	Kick(banid);

	return 1;
}

Player__Unban(const player[], const unbanner[])
{
	new playerIP[20], Rows, logtext[256];
	MySQL_Vars
	MySQL_Format("SELECT * FROM %s WHERE player = '%s'", Table_bans, MySQL::Escape(player));
	
	MySQL_Query
 	MySQL_Result

 	Rows = MySQL_NumRows;

 	MySQL_FetchPrepare
 	{
 	    MySQL_FetchRow(playerIP, "ip");
 	}

 	MySQL_Free

	if(Rows > 0)
	{

		MySQL_Format("DELETE FROM %s WHERE ip = '%s'", Table_bans, MySQL::Escape(playerIP));
  		
		MySQL_Query

		MySQL_Format("UPDATE %s SET isban = %d WHERE ip = '%s'", Table_users, FALSE, MySQL::Escape(playerIP));
		
		MySQL_Query

  		FormatReport("[Player]: %s removed ban on %s.", unbanner, player);
		SendReport(reportstring);

        Format(logtext, "+UB (by %s)", unbanner);
		Player::AddNote(player, unbanner, logtext);

	 	return 1;
	}

	return 0;
}

// Function: GetUnloadedField
// Author: iou
// Information: Retrieve any peice of data from a users account
// Notes: Returns a string, use floatstr or strval to convert.
Player__GetUnloadedField(const player[], const field[])
{
	new result[400];
	
	MySQL_Vars_L
	MySQL_Format("SELECT %s FROM %s WHERE username = '%s'", MySQL::Escape(field), Table_users, MySQL::Escape(player));
	
	MySQL_Query
	MySQL_Result
	
	MySQL_FetchPrepare
	{
		MySQL_FetchRow(result, field);
	}
	
	MySQL_Free
	
	return result;
}

// Function: SetUnloadedField
// Author: iou
// Information: Set any string peice of data on a users account
Player__SetUnloadedField(const player[], const field[], value[])
{
	MySQL_Vars_L
	MySQL_Format("UPDATE %s SET %s = '%s' WHERE username = '%s'", Table_users, MySQL::Escape(field), value, MySQL::Escape(player));
	
	MySQL_Query
	
	return 1;
}

// Integer
Player__SetUnloadedFieldInt(const player[], const field[], value)
{
	MySQL_Vars_L
	MySQL_Format("UPDATE %s SET %s = %d WHERE username = '%s'", Table_users, MySQL::Escape(field), value, MySQL::Escape(player));

	MySQL_Query

	return 1;
}

/*// Float - To be used
Player__SetUnloadedFieldFloat(const player[], const field[], Float:value)
{
	MySQL_Vars_L
	MySQL_Format("UPDATE %s SET %s = %f WHERE username = '%s'", Table_users, MySQL::Escape(field), value, MySQL::Escape(player));

	MySQL_Query

	return 1;
}*/

// Function: ShowDialog
// Author: iou
// Information: Use this instead of ShowPlayerDialog, we want to be able to see which dialog the player is using.
Player__ShowDialog(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
	PlayerInfo[playerid][Dialog] = dialogid;
	ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2);
	
	return 1;
}

// Function: OnDialogResponse
// Author: iou
// Information: This does not hide a dialog, use it under OnDialogResponse
Player__OnDialogResponse(playerid)
{
	PlayerInfo[playerid][Dialog] = 0;

	return 1;
}

// Function: GetDialog
// Author: iou
// Information: Returns the current dialog the player is using.
// NOTE: To be used.
/*Player__GetDialog(playerid)
{
	return PlayerInfo[playerid][Dialog];
}*/

Player__ShowMenu(playerid, Menu:menuid)
{
	PlayerInfo[playerid][Menu] = Menu:menuid;
	ShowMenuForPlayer(Menu:menuid, playerid);
	
	return 1;
}

Player__HideMenu(playerid, Menu:menuid)
{
	PlayerInfo[playerid][Menu] = Menu:-1;
	HideMenuForPlayer(Menu:menuid, playerid);
	
	return 1;
}

// Function: HideMarker
// Author: iou
// Information: Hides a players marker for everyone
Player__HideMarker(playerid)
{
	for(new i = 0; i < MaxSlots; i++)
	    SetPlayerMarkerForPlayer(i, playerid, (GetPlayerColor(playerid) & 0xFFFFFF00));

	return 1;
}

// Opposite of above function
Player__ShowMarker(playerid)
{
	for(new i = 0; i < MaxSlots; i++)
	    SetPlayerMarkerForPlayer(i, playerid, GetPlayerColor(playerid));

	return 1;
}

// Function: HideNameTag
// Author: iou
// Information: Hides a players nametag for everyone
Player__HideTag(playerid)
{
	for(new i = 0; i < MaxSlots; i++)
	    ShowPlayerNameTagForPlayer(i, playerid, false);

	return 1;
}

// Opposite of above function
Player__ShowTag(playerid)
{
	for(new i = 0; i < MaxSlots; i++)
	    ShowPlayerNameTagForPlayer(i, playerid, true);

	return 1;
}

// Basically what it says
stock SendMessageToAvailable(color, const string[])
{
	for(new i = 0; i < MaxSlots; i++)
	{
		if(!IsPlayerConnected(i))
		    continue;
		    
		if(!IsPlayerAvailable(i))
		    continue;

     	SendClientMessage(i, color, string);
	}
	
	return 1;
}

// Function: ClearPlayerMenus
// Author: iou
// Information: Clears whatever the player was doing, should be used before joining a minigame
stock ClearPlayerInteractions(playerid)
{
	ClearPlayerMenus(playerid);
	ClearPlayerDialogs(playerid);
	return 1;
}

// Function: ClearPlayerMenus
// Author: iou
// Information: Clears all menus for a player
stock ClearPlayerMenus(playerid)
{
	for(new i = 0; i < MAX_MENUS; i++)
	{
	    if(!IsValidMenu(Menu:i))
			continue;
			
		HideMenuForPlayer(Menu:i, playerid);
	}
	return 1;
}

// Function: ClearPlayerMenus
// Author: iou
// Information: Clears dialogs, cancels what the dialog was about (eg. CW)
// IMPORTANT NOTE: Must be updated in order to cancel other things!
stock ClearPlayerDialogs(playerid)
{
	if(PlayerInfo[playerid][Dialog] >= DIALOG_CW_INFO && PlayerInfo[playerid][Dialog] <= DIALOG_CW_ACCEPT)
	    CW::Reset();

	ShowPlayerDialog(playerid, DIALOG_CLEAR, 0, "", "", "", "");
	
	return 1;
}

// Function: IsPlayerAt
// Author: iou
// Information: Checks if the player is around specified coordinates
// returns 1/0
stock IsPlayerAt(playerid, Float:inX, Float:inY, Float:inZ)
{
	if(!IsPlayerConnected(playerid))
		return 0;
		
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	
	if( !(inX < X+1.5 || inX < X-1.5) || !(inX > X+1.5 || inX > X-1.5)
 	||  !(inY < Y+1.5 || inY < Y-1.5) || !(inY > Y+1.5 || inY > Y-1.5)
	||  !(inZ < Z+1.5 || inZ < Z-1.5) || !(inZ > Z+1.5 || inZ > Z-1.5) )
		return 0;
	
	return 1;
}

stock IsPlayerInZone(playerid, zoneid)
{
 if(zoneid == -1) return 0;
 new Float:x, Float:y, Float:z;
 GetPlayerPos(playerid,x,y,z);
 return IsXYZInZone(x, y, z, zoneid);
}

stock IsPlayerInZoneName(playerid, zonename[])
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid,x,y,z);
	for (new zoneid = 0; zoneid < MAX_ZONES; zoneid++)
	{
		if (strcompEx(zonename,zones[zoneid][zone_name],false))
		{
	 		return IsPlayerInZone(playerid, zoneid);
	 	}
	}
	return 0;
}

// Function: GetPlayerPlayTime
// Author: iou
// Params: playerid, mode (eg. MODE_FREEROAM)
stock GetPlayerPlayTime(playerid, mode)
{
	new playtime;
	
	if(mode == MODE_NEUTRAL)
		playtime = PlayerInfo[playerid][PlayTime];

	else if(mode == MODE_TRAINING)
		playtime = PlayerInfo[playerid][T_Time];

	else if(mode == MODE_FREEROAM)
		playtime = PlayerInfo[playerid][F_Time];

	
	return playtime;
}

// Function: PlayerName
// Author: iou
// Notes: Shorter way to get pNames.
stock PlayerName(playerid)
{
  	new name[24];
  	GetPlayerName(playerid, name, 24);
  	return name;
}

stock GetUserSkin(playerid)
{
	new skinid = strval(Player::GetUnloadedField(PlayerName(playerid), "skinid"));
	return skinid;
}

stock ReturnPlayer(const playerstring[])
{
	new playerid = INVALID_PLAYER_ID;

    for(new i = 0; i < MaxSlots; i++)
    {
        if(!IsPlayerConnected(i))
			continue;

        if(strcmp(playerstring, PlayerName(i), false, strlen(playerstring)) != 0)
			continue;
			
		playerid = i;
		break;
    }

	return playerid;
}

stock ReturnPlayerWithMessage( iRecieverID, sPlayerString[] )
{
	new iReturnID = INVALID_PLAYER_ID,
	    iMatches = 0,
		sReturnMessage[ 200 ];
		
	if( isNumeric( sPlayerString ) ) // A number was entered, no need to search.
	{
	    iReturnID = strval( sPlayerString ),
		iMatches = true;
	}
	else
	{
		for( new iLoopID = 0; iLoopID < MaxSlots; iLoopID++ ) // Loop through all players
		{
		    if( !IsPlayerConnected( iLoopID ) ) continue;
		    if( IsPlayerNPC( iLoopID ) ) continue;

			if( strcmp( sPlayerString, PlayerName( iLoopID ), true, strlen( sPlayerString ) ) == 0 || strfind( PlayerName( iLoopID ), sPlayerString, true ) != -1 ) // Seach every player's name.
			{
			    iReturnID = iLoopID;
			    iMatches++;

			    if( iMatches == 1 ) // Format a message
					format( sReturnMessage, sizeof( sReturnMessage ), "%s %s (%d)", sReturnMessage, PlayerName( iLoopID ), iLoopID );
				else if( iMatches > 1 && iMatches <= 5 )
				    format( sReturnMessage, sizeof( sReturnMessage ), "%s, %s (%d)", sReturnMessage, PlayerName( iLoopID ), iLoopID );
			}
		}
	}
	
	if( strlen( sPlayerString ) < 3 && !isNumeric( sPlayerString ) ) // The string's not long enough
	{
		SendClientMessage( iRecieverID, COLOR_FALSE, "* Please use at least three characters." );
		return INVALID_PLAYER_ID;
	}
	
	if( iMatches == 0 ) // No players were found
	{
	    format( sReturnMessage, sizeof( sReturnMessage ), "* No player was found matching \"%s\".", sPlayerString );
		SendClientMessage( iRecieverID, COLOR_FALSE, sReturnMessage );
		return INVALID_PLAYER_ID;
	}
	
	if( iMatches > 1 ) // If there are more than one player found, send some messages.
	{
	    new sMessage[ 256 ];
	    format( sMessage, sizeof( sMessage ), "* Too many matches for \"%s\" (%d). Please be more specific.", sPlayerString, iMatches );
	    if( iMatches <= 5 )
		    format( sReturnMessage, sizeof( sReturnMessage ), "* These were found: %s.", sReturnMessage );
		else
		    format( sReturnMessage, sizeof( sReturnMessage ), "* These were found: %s. Plus %d more.", sReturnMessage, 5 - iMatches );
		    
		SendClientMessage( iRecieverID, COLOR_FALSE, sMessage );
		SendClientMessage( iRecieverID, COLOR_FALSE, sReturnMessage );
		return INVALID_PLAYER_ID;
	}
	

	
	return iReturnID;
}

stock IsPlayer(playerid)
{
	if(PlayerInfo[playerid][AdminLevel] == LEVEL_PLAYER)
		return 1;

	return 0;
}

stock IsIdling(playerid)
{
	if( Now() - PlayerInfo[playerid][LastUpdate] > IDLE_TIME )
		return 1;
		
	return 0;
}

stock IsSpectating(playerid)
{
	if(PlayerInfo[playerid][Spectating] == true)
	    return 1;
	    
	return 0;
}

stock IsMuted(playerid)
{
	if(PlayerInfo[playerid][Muted] == true)
		return 1;
		
	return 0;
}

stock IsJailed(playerid)
{
	if(PlayerInfo[playerid][Jailed] == true)
		return 1;

	return 0;
}

stock IsTraining(playerid)
{
	if(PlayerInfo[playerid][pMode] == MODE_TRAINING)
	    return 1;

	return 0;
}

stock IsFreeroam(playerid)
{
	if(PlayerInfo[playerid][pMode] == MODE_FREEROAM)
	    return 1;

	return 0;
}

stock IsNeutral(playerid)
{
	if(PlayerInfo[playerid][pMode] == MODE_NEUTRAL)
    	return 1;

	return 0;
}

// Function: IsPlayerAvailable
// Author: iou
// Information: Only returns 1 if he isn't in any minigame or such
// NOTE: MUST BE UPDATED FOR NEWER MINIGAMES
stock IsPlayerAvailable(playerid)
{
	if(!IsPlayerConnected(playerid))
	    return 0;

	if(!PlayerInfo[playerid][LoggedIn])
		return 0;

	if(!PlayerInfo[playerid][Started])
		return 0;
		
 	if(PlayerInfo[playerid][Switchmode] == true)
		return 0;

	if(PlayerInfo[playerid][Frozen] == true)
	    return 0;
	    
	if(PlayerInfo[playerid][Jailed] == true)
	    return 0;

	if(CW::IsPlaying(playerid))
	    return 0;
	    
	if(Mini::IsPlaying(playerid))
	    return 0;
	    
	return 1;
}

// Function: IsPlayerFighting
// Author: iou
// Information: If the player was in a gun fight recently, return 1;
// Parameters: playerid of whom to check | seconds that must've passed since his last shot
stock IsPlayerFighting(playerid, seconds)
{
	if(!IsPlayerConnected(playerid))
	    return 0;
	    
	/*if(IsAdmin(playerid))
	    return 0;*/
	    
	if( (Now() - PlayerInfo[playerid][LastShot]) < seconds)
	    return 1;
	
	return 0;
}

stock IsPlayerOnline(const player[])
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(strcmp(PlayerName(i), player, false, strlen(PlayerName(i))) == 0)
	        return 1;
	}
	return 0;
}

stock GetPlayerID(const player[])
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(strcmp(PlayerName(i), player, false, MAX_PLAYER_NAME) == 0)
	        return i;
	}
	return -1;
}

stock ClearPlayerChat(playerid)
{
	for (new i = 1; i <= 120; i++)
		SendClientMessage(playerid, 0, "\n");

	return 1;
}

stock UpdatePlayerHardcoreHealth(playerid)
{
	new Float:HP, Float:Arm;
	GetPlayerHealth(playerid, HP);
	GetPlayerArmour(playerid, Arm);
	
	g_TestHardcore_HP[playerid] = HP;
	g_TestHardcore_Arm[playerid] = Arm;
}
