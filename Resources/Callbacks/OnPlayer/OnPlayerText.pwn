public OnPlayerText(playerid, text[])
{
	new sError[128];

	// If an administrator is giving an announcement and the player isn't admin, return false;
    if(APM == true && !IsAdmin(playerid))
	{
	    SendClientMessage(playerid, COLOR_FALSE, "* An administrator is giving an announcement so your rights to speak are currently revoked.");
		return 0;
    }

	// If player is muted and he isn't an admin or above, return false
    if(PlayerInfo[playerid][Muted] && !IsAdmin(playerid))
    {
		Format(sError, "* You're currently muted and will be automatically unmuted in %d minutes.", PlayerInfo[playerid][MuteTime]);
        SendClientMessage(playerid, COLOR_FALSE, sError);
		return 0;
    }

	// Is it an admin message?
	if(text[0] == '@')
	{
		new Type[20];

		if(IsPlayer(playerid)) // The player is not a crew-member and does not see these messages, so, let's give one
		{
		    new sMessage[256];

		    Type = "Player";
		    format(sMessage, sizeof(sMessage), "* Your message has been sent to the crew: %s", text[1]);
		    SendClientMessage(playerid, COLOR_ADMINCHAT, sMessage);
		}
		else Type = "Crew";

  		SendAdminChatMsg(playerid, Type, text[1]);

		return 0;
	}
	
	// Is it a global message?
	if(text[0] == '#')
	{
	    new sMessage[256];

 		if(IsTraining(playerid))
			Format(sMessage, "[Training] %s (%d): %s", PlayerName(playerid), playerid, text[1]);

	    if(IsFreeroam(playerid))
			Format(sMessage, "[Freeroam] %s (%d): %s", PlayerName(playerid), playerid, text[1]);

        SendClientMessageToAll(COLOR_FADE, sMessage);
        return 0;
	}
	
	// Is it a gang message?
	if(text[0] == '!')
	{
		if(Gang::OnText(playerid, text))
			return 0;
	}
	
	// Is it for a minigame perhaps?
	if(text[0] == '*')
	{
	    if(Mini::OnText(playerid, text))
			return 0;
	}
	

	// Is the player just a player and is he allowed to speak? OK Send to irc!
	if(IsPlayer(playerid))
	    if(Player::OnText(playerid, text))
    		IRC::OnText(playerid, text);

	// Is the player a moderator or above and is he allowed to speak? OK Send to irc!
	if(IsMod(playerid))
	    if(Admin::OnText(playerid, text))
	        IRC::OnText(playerid, text);

	if(IsTraining(playerid))
	    Training::OnText(playerid, text);

	if(IsFreeroam(playerid))
	    Freeroam::OnText(playerid, text);

	return 0;
}
