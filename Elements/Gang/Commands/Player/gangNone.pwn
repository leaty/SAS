gang_Create(playerid, params[])
{
	new gangid, sError[128], sSuccess[128], sNews[128], gangname[MAX_GANG_NAME];
	
	if(sscanf(params, "s", gangname))
		return SendClientMessage(playerid, COLOR_USAGE, "Usage: /gang create [gangname]");
		
	Format(sError, "* The gang name can only be %d characters long!", MAX_GANG_NAME);
	if(strlen(gangname) > MAX_GANG_NAME-1)
	    return SendClientMessage(playerid, COLOR_FALSE, sError);
		
	// Does the gang already exist? Prevent overwrite
	if(Gang::DBExistsGang(gangname))
		return SendClientMessage(playerid, COLOR_FALSE, "* This gang already exists, please use another gangname.");
		
	// Is the ganglimit reached?
	if(GangCount >= MAX_GANGS)
		return SendClientMessage(playerid, COLOR_FALSE, "* Sorry, the gang limit is reached. Please report to crew by using @report.");

	// Create the gang and retrieve it's gangid               *colorid
	gangid = Gang::CreateGang(PlayerName(playerid), gangname, playerid);
	
	// The gang was not created! :(
	if(gangid < 1)
		return SendClientMessage(playerid, COLOR_FALSE, "* Something wen't wrong! Your gang was not created, please report to crew using @report.");

	Gang::Join(playerid, gangid);
	PlayerInfo[playerid][GangLevel] = GANG_LEVEL_OWNER;

	GangInfo[gangid][Members]++;

	Format(sNews, "Gang %s (ID: %d) was just created by %s!", gangname, gangid, PlayerName(playerid));
	SendNews(sNews);

	Format(sSuccess, "%s has joined the gang.", PlayerName(playerid));
	SendGangMsg(gangid, GANG_COLOR_INFO, sSuccess);

	SendClientMessage(playerid, COLOR_INFO, "** Your gang stats are now active! This means that kills, deaths, clanwar wins and losses");
	SendClientMessage(playerid, COLOR_INFO, "** against another gang are counted! Wins and losses are also counted into the leaderboard!");
 	SendClientMessage(playerid, COLOR_INFO, "** Invite friends to your gang by using /gang invite [playerid]!");
 	SendClientMessage(playerid, COLOR_INFO, "** See /gang for other useful commands.");
	return 1;
}

gang_Join(playerid, params[])
{
	new gangid, sMessage[128];

	if(sscanf(params, "d", gangid))
		return SendClientMessage(playerid, COLOR_USAGE, "Usage: /gang join [gangid]");

	if(PlayerInfo[playerid][GangInvited] < 1)
	    return SendClientMessage(playerid, COLOR_FALSE, "* You've not been invited to any gang.");

	if(PlayerInfo[playerid][GangInvited] != gangid)
		return SendClientMessage(playerid, COLOR_FALSE, "* You've not been invited to this gang.");
		
	if(!Gang::ExistsGang(gangid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* This gang does not exist.");

	Gang::Join(playerid, gangid);
	PlayerInfo[playerid][GangLevel] = GANG_LEVEL_MEMBER;
	
	GangInfo[gangid][Members]++;

	Format(sMessage, "* You're now a member of gang %s!", GangInfo[gangid][GangName]);
	SendClientMessage(playerid, COLOR_TRUE, sMessage);

	Format(sMessage, "%s has joined the gang.", PlayerName(playerid));
	SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);
	
	SendClientMessage(playerid, COLOR_INFO, "** You can now use the gangchat by using !yourtext.");
	SendClientMessage(playerid, COLOR_INFO, "** Any of your kills/deaths against another gang will be counted into this gangs stats.");
	SendClientMessage(playerid, COLOR_INFO, "** View your gang's stats by using '/gang stats', or view another gang's stats with '/gang info [gangid]'");
	SendClientMessage(playerid, COLOR_INFO, "** A full list of all current gangs can be viewed with '/gang list'");

	return 1;
}

