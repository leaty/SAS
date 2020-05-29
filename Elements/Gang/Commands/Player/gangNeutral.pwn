gang_Info(playerid, params[])
{
	new gangid;
	
	if(sscanf(params, "d", gangid))
		return SendClientMessage(playerid, COLOR_USAGE, "Usage: /gang info [gangid]");

	if(!Gang::ExistsGang(gangid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* There's no gang with that id.");
		
	new sInfo[256], Float:Ratio;

	Ratio = floatdiv(GangInfo[gangid][Kills], GangInfo[gangid][Deaths]);

	Format(sInfo, "*** Gang %s: ***", GangInfo[gangid][GangName]);
	SendClientMessage(playerid, COLOR_TITLE, sInfo);
	Format(sInfo, "* This gang is owned by %s and has currently %d of it's %d members online.", GangInfo[gangid][GangOwner], CountOnlineGangMembers(gangid), GangInfo[gangid][Members]);
	SendClientMessage(playerid, COLOR_INFO, sInfo);
	Format(sInfo, "* Together they've killed %d and died %d times which makes their K/D Ratio %.2f", GangInfo[gangid][Kills], GangInfo[gangid][Deaths], Ratio);
	SendClientMessage(playerid, COLOR_INFO, sInfo);
	Format(sInfo, "* They have won %d clanwars and lost %d times which puts them on position number %d in the leaderboard.", GangInfo[gangid][Wins], GangInfo[gangid][Losses], Gang::GetLeaderBoardPos(gangid));
	SendClientMessage(playerid, COLOR_INFO, sInfo);
	SendClientMessage(playerid, COLOR_TITLE, "----------------");
	return 1;
}

gang_List(playerid, params[])
{
	new sLine[256];
	
	SendClientMessage(playerid, COLOR_TITLE, "*** Gang List: ***");
	
	for(new i = 1; i < MAX_GANGS + 1; i++)
	{
	    if(!Gang::ExistsGang(i))
	        continue;
	        
		Format(sLine, "%d. %s (%d/%d)", i, GangInfo[i][GangName], CountOnlineGangMembers(i), GangInfo[i][Members]);
		SendClientMessage(playerid, COLOR_INFO, sLine);
	}
	
	SendClientMessage(playerid, COLOR_TITLE, "---------------");
	#pragma unused params
	return 1;
}


