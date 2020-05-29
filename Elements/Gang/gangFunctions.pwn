Gang__CreateGang(const owner[MAX_PLAYER_NAME], const gangname[MAX_GANG_NAME], playerid)
{
	new gangid = GetNewGangID();
	new colorid = playerid;
	
	if(GangColorUsed(colorid))
	    colorid = GetNewGangColor();

	MySQL_Vars
	MySQL_Format("INSERT INTO %s (gangid, gangname, gangowner, colorid, members) VALUES (%d, '%s', '%s', %d, 1)", Table_gangs, gangid, MySQL::Escape(gangname), MySQL::Escape(owner), colorid);
	MySQL_Query
	
	// It failed to add it to database?! STOP!
	if(!Gang::DBExistsGang(gangname))
	    return 0;

	// Success! Add the gang to the ingame variables!
	GangInfo[gangid][Exists] = 1;
	GangInfo[gangid][GangName] = gangname;
	GangInfo[gangid][GangOwner] = owner;
	GangInfo[gangid][ColorID] = colorid;
	
	GangCount++;

	return gangid;
}

Gang__DeleteGang(gangid)
{
	if(Gang::ExistsGang(gangid))
	{
		MySQL_Vars
		MySQL_Format("DELETE FROM %s WHERE gangid = %d", Table_gangs, gangid);
		MySQL_Query
		
		ResetGangInfo(gangid);
 	}
 	
 	if(!Gang::ExistsGang(gangid))
		return 1;
		
	return 0;
}
// Checks in the database
Gang__DBExistsGang(const gangname[])
{
	new Rows;
	
	MySQL_Vars
	MySQL_Format("SELECT * FROM %s WHERE gangname = '%s'", Table_gangs, MySQL::Escape(gangname));
	MySQL_Query
	MySQL_Result
	
	Rows = MySQL_NumRows;
	MySQL_Free
	
	if(Rows > 0)
	    return 1;
	
	return 0;
}
// Checks in the ingame variables
Gang__ExistsGang(gangid)
{
	if(GangInfo[gangid][Exists])
	    return 1;

	return 0;
}

Gang__RenameGang(gangid, oldname[MAX_GANG_NAME], newname[MAX_GANG_NAME])
{

	MySQL_Vars
	MySQL_Format("UPDATE %s SET gangname = '%s' WHERE gangname = '%s'", Table_gangs, MySQL::Escape(newname), MySQL::Escape(oldname));
	MySQL_Query
	
	MySQL_Format("UPDATE %s SET gang = '%s' WHERE gang = '%s'", Table_users, MySQL::Escape(newname), MySQL::Escape(oldname));
	
	MySQL_Query
	
	GangInfo[gangid][GangName] = newname;
	
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(strcmp(PlayerInfo[i][GangName], oldname, false, strlen(oldname)) == 0)
			PlayerInfo[i][GangName] = newname;
	}
	
	return 1;
}

Gang__SetOwner(gangid, owner[MAX_PLAYER_NAME])
{
	
	MySQL_Vars
	MySQL_Format("UPDATE %s SET gangowner = '%s' WHERE gangname = '%s'", Table_gangs, MySQL::Escape(owner), MySQL::Escape(GangInfo[gangid][GangName]));
	MySQL_Query
	
	GangInfo[gangid][GangOwner] = owner;
	
	return 1;
}

Gang__LoadGangs()
{
	new result[128];
	new gangCount;
	new Rows;
	
	// Reset global var
	GangCount = 0;
	
	gangCount = MySQL::CountRows(Table_gangs);
	
	if(gangCount < 1)
	{
	    SendReport("[GangHandler]: No existing gangs.");
	    return 0; 
	}
	
	MySQL_Vars
	
	for(new i = 1; i < MAX_GANGS + 1; i++)
	{

		MySQL_Format("SELECT * FROM %s WHERE gangid = %d", Table_gangs, i);
		MySQL_Query
	  	MySQL_Result

		Rows = MySQL_NumRows;
		
		if(Rows < 1) continue;

	  	MySQL_FetchPrepare
	  	{
	  	    MySQL_FetchRow(GangInfo[i][GangName], "gangname");

	  	    MySQL_FetchRow(GangInfo[i][GangOwner], "gangowner");

			MySQL_FetchRow(result, "colorid");
			GangInfo[i][ColorID] = strval(result);
	  	    
			MySQL_FetchRow(result, "members");
			GangInfo[i][Members] = strval(result);
			
			MySQL_FetchRow(result, "kills");
			GangInfo[i][Kills] = strval(result);
			
			MySQL_FetchRow(result, "deaths");
			GangInfo[i][Deaths] = strval(result);
			
			MySQL_FetchRow(result, "wins");
			GangInfo[i][Wins] = strval(result);
			
			MySQL_FetchRow(result, "losses");
			GangInfo[i][Losses] = strval(result);
	  	}

	 	MySQL_Free
	 	
	 	GangInfo[i][Exists] = TRUE;
	 	
	 	// Global var
	 	GangCount++;
 	}
 	
 	
 	Format(result, "[GangHandler]: %d gangs were successfully loaded.", GangCount);
	SendReport(result);
	
	return 1;
}

Gang__UpdateGangs()
{
	new result[128], UpCount;

	MySQL_Vars_L
	
	for(new i = 1; i < MAX_GANGS + 1; i++)
	{
	    if(!GangInfo[i][Exists])
	        continue;

	    MySQL_Format("UPDATE %s SET gangname = '%s', \
								 	gangowner = '%s', \
								 	colorid = %d, \
								  	members = %d, \
								  	kills = %d, \
									deaths = %d, \
									wins = %d, \
									losses = %d WHERE gangname = '%s'",
									Table_gangs,
									MySQL::Escape(GangInfo[i][GangName]),
									MySQL::Escape(GangInfo[i][GangOwner]),
									GangInfo[i][ColorID],
									GangInfo[i][Members],
									GangInfo[i][Kills],
									GangInfo[i][Deaths],
									GangInfo[i][Wins],
									GangInfo[i][Losses],
									MySQL::Escape(GangInfo[i][GangName]));
	    
	    MySQL_Query
	    
	    UpCount++;
	}
	
	Format(result, "[GangHandler]: %d/%d gangs were successfully updated.", UpCount, GangCount);
	SendReport(result);
	return 1;
}


Gang__GetLeaderBoardPos(gangid)
{
	new iLeader = 1;
	new Float:Ratio, Float:enemyRatio;
	
	Ratio = floatdiv(GangInfo[gangid][Wins], GangInfo[gangid][Losses]);
	
	for(new i = 1; i < MAX_GANGS + 1; i++)
	{
	    if(!GangInfo[gangid][Exists])
	        continue;
	        
	    enemyRatio = floatdiv(GangInfo[i][Wins], GangInfo[i][Losses]);
	    
	    if(Ratio < enemyRatio)
	        iLeader--;
	        
		if(Ratio > enemyRatio)
		    iLeader++;
	}
	
 	if(iLeader < 1)
		iLeader = 1;
		
	return iLeader;
}

Gang__Leave(playerid)
{
	PlayerInfo[playerid][GangID] = 0;
	StrReset(PlayerInfo[playerid][GangName]);
	PlayerInfo[playerid][GangLevel] = GANG_LEVEL_NONE;
	return 1;
}

Gang__Join(playerid, gangid)
{
 	new gangname[MAX_GANG_NAME];
 	Format(gangname, "%s", GangInfo[gangid][GangName]);
 	
	PlayerInfo[playerid][GangID] = gangid;
	PlayerInfo[playerid][GangLevel] = GANG_LEVEL_MEMBER;
	PlayerInfo[playerid][GangName] = gangname;
	return 1;
}

stock SendGangMsg(gangid, color, const message[])
{
	new sMessage[256];
	
	Format(sMessage, "[Gang] %s", message);

	for(new i = 0; i < MaxSlots; i++)
 	{
 	    if(!IsPlayerConnected(i))
 	        continue;
 	        
		if(PlayerInfo[i][GangID] != gangid)
		    continue;
		
		SendClientMessage(i, color, sMessage);
 	}
 	return 1;
}

stock GangColorUsed(colorid)
{
	for(new i = 1; i < MAX_GANGS + 1; i++)
	{
		if(GangInfo[i][ColorID] == colorid)
		    return 1;
	}
	return 0;
}

stock GetNewGangColor()
{
	new colorid;
	for(new i = 0; i < MaxColors; i++)
	{
	    if(i == 98 || i == 99)
	        continue;
	        
	    if(!GangColorUsed(i))
		{
		    colorid = i;
			break;
		}
	}
	
	return colorid;
}

stock GetNewGangID()
{
	new gangid;
	for(new i = 1; i < MAX_GANGS + 1; i++)
 	{
 	    if(GangInfo[i][Exists])
 	        continue;

      	gangid = i;
		break;
 	}
	return gangid;
}

stock GetGangID(const gangname[])
{
	for(new i = 1; i < MAX_GANGS + 1; i++)
	{
 		if(!GangInfo[i][Exists])
 	        continue;
 	        
	    if(strcmp(GangInfo[i][GangName], gangname, false, MAX_GANG_NAME) == 0)
			return i;
	}

	return 0;
}

stock GetGangName(gangid)
{
	new sGang[MAX_GANG_NAME];
	Format(sGang, "%s", GangInfo[gangid][GangName]);
	return sGang;
}

stock IsGang(playerid)
{
	if(PlayerInfo[playerid][GangID] != 0)
	    return 1;

	return 0;
}

stock IsGangOwner(playerid)
{
	if(PlayerInfo[playerid][GangLevel] == GANG_LEVEL_OWNER)
	    return 1;

	return 0;
}

stock CountOnlineGangMembers(gangid)
{
	new iCount;
	
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerConnected(i))
	        continue;
	        
	    if(PlayerInfo[i][GangID] == gangid)
	    	iCount++;
	}
	return iCount;
}


stock IsGangColorUsed(colorid)
{
	for(new i = 1; i < MAX_GANGS + 1; i++)
	{
	    if(GangInfo[i][ColorID] == colorid)
	        return 1;
	}
	
	return 0;
}

stock ResetGangInfo(gangid)
{
	StrReset(GangInfo[gangid][GangOwner]);
	StrReset(GangInfo[gangid][GangName]);
	
	GangInfo[gangid][Exists] = 0;
    GangInfo[gangid][ColorID] = -1;
	GangInfo[gangid][Members] = 0;
	GangInfo[gangid][Kills] = 0;
	GangInfo[gangid][Deaths] = 0;
	GangInfo[gangid][Wins] = 0;
	GangInfo[gangid][Losses] = 0;
	
	if(GangCount > 0)
		GangCount--;
	else if(GangCount < 0)
	    GangCount = 0;
	
	return 1;
}
