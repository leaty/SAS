Mute__Process() // Runs every minute
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsMuted(i))
	        continue;

		PlayerInfo[i][MuteTime]--;
		
		if(PlayerInfo[i][MuteTime] < 1)
			Mute::Unmute(i);
	}
	
	return 1;
}

Mute__Mute(playerid, muterid, reason[])
{
    new sMessage[128], logtext[256];
    
   	PlayerInfo[playerid][MuteTime] = PlayerInfo[playerid][OldMuteTime] + DEFAULT_MUTE_ADDITION;
	PlayerInfo[playerid][OldMuteTime] += DEFAULT_MUTE_ADDITION;
    
    // Is this player muted already? Display some other messages.
    if(PlayerInfo[playerid][Muted] == true)
    {
  		Format(sMessage, "%s has extended %s's (ID: %d) mute for %d minutes: %s", PlayerName(muterid), PlayerName(playerid), playerid, PlayerInfo[playerid][MuteTime], reason);
		SendModMsg(sMessage);
		Format(sMessage, "* Your mutetime has been extended to %d minutes.", PlayerInfo[playerid][MuteTime]);
		SendClientMessage(playerid, COLOR_FALSE, sMessage);
	}
	else
	{
		Format(sMessage, "%s has muted %s (ID: %d) for %d minutes: %s", PlayerName(muterid), PlayerName(playerid), playerid, PlayerInfo[playerid][MuteTime], reason);
		SendModMsg(sMessage);
	   	Format(sMessage, "%s has been muted: %s", PlayerName(playerid), reason);
		SendNews(sMessage);
		Format(sMessage, "* You've been muted for %d minutes: %s.", PlayerInfo[playerid][MuteTime], reason);
		SendClientMessage(playerid, COLOR_FALSE, sMessage);
		
		Format(logtext, "+M %s - %d mins", reason, PlayerInfo[playerid][MuteTime]);
		Player::AddNote(PlayerName(playerid), PlayerName(muterid), logtext);
    }
    
	PlayerInfo[playerid][Muted] = true;

	return 1;
}

Mute__Unmute(playerid)
{
	new sMessage[128];
	
    PlayerInfo[playerid][Muted] = false;
    
	Format(sMessage, "%s has been unmuted.", PlayerName(playerid));
	SendNews(sMessage);
	SendClientMessage(playerid, COLOR_TRUE, "* You've been unmuted.");
	
    return 1;
}

