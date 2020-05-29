gang_Leave(playerid, params[])
{
	new sMessage[128];
	new gangid = PlayerInfo[playerid][GangID];
	
	Gang::Leave(playerid);
	
	GangInfo[gangid][Members]--;
	
	SendClientMessage(playerid, COLOR_TRUE, "* You've left the gang.");
	    
	Format(sMessage, "%s has left the gang.", PlayerName(playerid));
	SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);

	#pragma unused params
	return 1;
}

gang_Stats(playerid, params[])
{
	new gangid, sStats[256], Float:Ratio;
	
	gangid = PlayerInfo[playerid][GangID];
	
	Ratio = floatdiv(GangInfo[gangid][Kills], GangInfo[gangid][Deaths]);

	SendClientMessage(playerid, COLOR_TITLE, "*** Gang Statistics ***");
	Format(sStats, "* Your gang is owned by %s and has currently %d of it's %d members online.", GangInfo[gangid][GangOwner], CountOnlineGangMembers(gangid), GangInfo[gangid][Members]);
	SendClientMessage(playerid, COLOR_INFO, sStats);
	Format(sStats, "* Together you've killed %d and died %d times which makes your K/D Ratio %.2f", GangInfo[gangid][Kills], GangInfo[gangid][Deaths], Ratio);
	SendClientMessage(playerid, COLOR_INFO, sStats);
	Format(sStats, "* You've won %d clanwars and lost %d times which puts you on position number %d in the leaderboard.", GangInfo[gangid][Wins], GangInfo[gangid][Losses], Gang::GetLeaderBoardPos(gangid));
	SendClientMessage(playerid, COLOR_INFO, sStats);
	SendClientMessage(playerid, COLOR_TITLE, "-------------------");
	#pragma unused params
	return 1;
}

