#define MAX_JAIL_LOCATIONS          3

new Float:JailLocations[MAX_JAIL_LOCATIONS][4] =
{
	{193.5457, 174.4168, 1003.0234, 358.5274},
	{197.5872, 174.2254, 1003.0234, 0.0001},
	{198.5437, 162.6753, 1003.0300, 178.4399}
};

Jail__Process() // Runs every minute
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsJailed(i))
	        continue;

		PlayerInfo[i][JailTime]--;

		if(PlayerInfo[i][JailTime] < 1)
			Jail::Unjail(i);
	}

	return 1;
}

Jail__Jail(playerid, jailerid, reason[])
{
	new sMessage[128], logtext[256];
	
	PlayerInfo[playerid][JailTime] = PlayerInfo[playerid][OldJailTime] + DEFAULT_JAIL_ADDITION;
	PlayerInfo[playerid][OldJailTime] += DEFAULT_JAIL_ADDITION;
	
	// Was the player already muted? Extend and do not send any newsmessage.
	if(PlayerInfo[playerid][Jailed] == true)
	{
		Format(sMessage, "%s has extended %s's (ID: %d) jail for %d minutes: %s", PlayerName(jailerid), PlayerName(playerid), playerid, PlayerInfo[playerid][JailTime], reason);
		SendModMsg(sMessage);
		Format(sMessage, "* Your jailtime has been extended to %d minutes.", PlayerInfo[playerid][JailTime]);
		SendClientMessage(playerid, COLOR_FALSE, sMessage);
	}
	else
	{
		Format(sMessage, "%s has jailed %s (ID: %d) for %d minutes: %s", PlayerName(jailerid), PlayerName(playerid), playerid, PlayerInfo[playerid][JailTime], reason);
		SendModMsg(sMessage);
		Format(sMessage, "%s has been jailed: %s", PlayerName(playerid), reason);
		SendNews(sMessage);
		Format(sMessage, "* You've been jailed for %d minutes: %s.", PlayerInfo[playerid][JailTime], reason);
		SendClientMessage(playerid, COLOR_FALSE, sMessage);
		SendClientMessage(playerid, COLOR_FALSE, "* Due to lack of cells, you might have to share it with another person. Don't drop the soap.");
		
		Format(logtext, "+J %s - %d mins", reason, PlayerInfo[playerid][JailTime]);
		Player::AddNote(PlayerName(playerid), PlayerName(jailerid), logtext);
		
		Jail::OnRespawn(playerid);
	}
	
	PlayerInfo[playerid][Jailed] = true;
	
	return 1;
}

Jail__Unjail(playerid)
{
	new sMessage[128];
	
    PlayerInfo[playerid][Jailed] = false;
    
   	Format(sMessage, "%s has been unjailed.", PlayerName(playerid));
	SendNews(sMessage);
	SendClientMessage(playerid, COLOR_TRUE, "* You've been unjailed.");

	SpawnPlayer(playerid);
	return 1;
}

Jail__OnRespawn(playerid)
{
	new pos = random(MAX_JAIL_LOCATIONS);
	
	SetPlayerPos(playerid, JailLocations[pos][0], JailLocations[pos][1], JailLocations[pos][2]);
	SetPlayerFacingAngle(playerid, JailLocations[pos][3]);
	SetCameraBehindPlayer(playerid);
	SetPlayerInterior(playerid, 3);
	
	SetPlayerHealth(playerid, 40.0);
	SetPlayerArmour(playerid, 0.0);
	
	ResetPlayerWeapons(playerid);
	
	return 1;
}

