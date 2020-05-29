public OnPlayerSpawn(playerid)
{
	IRC::OnSpawn(playerid);

	// Does the player have an account? Login!
	if(PlayerInfo[playerid][Registered] == TRUE && PlayerInfo[playerid][LoggedIn] == FALSE)
	{
	    SetPlayerVirtualWorld(playerid, WORLD_SELECTION);
		SetPlayerPos(playerid, 775.3851, -2846.4758, 5.6095);
		SetPlayerFacingAngle(playerid, 180);
		
    	// Auto login if IP Match
		if(Player::MatchIP(playerid) == TRUE)
		{
			Player::FetchData(playerid);
			PlayerInfo[playerid][LoggedIn] = TRUE;
			SendClientMessage(playerid, COLOR_INFO, "** I remember you! You've been automatically logged in.");
            FormatIRC("%s*** %s%s%s has logged in.", IRC_COLOR_TRUE, IRC_BOLD, PlayerName(playerid), IRC_ENDBOLD);
            IRC::SendEchoMsg(ircstring);
		}
		// Login dialog if IP doesn't Match
		else
		{
		    new LoginText[256];
		    Format(LoginText, DIALOG_LOGIN_TEXT, PlayerName(playerid)); // Format string to add the players name in the dialog message
			Player::ShowDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "* Login", LoginText, "Identify!", "Quit");
		}
		return 1;
	}
	// No account? Register!
	else if(PlayerInfo[playerid][Registered] == FALSE && PlayerInfo[playerid][LoggedIn] == FALSE)
	{
	    SetPlayerVirtualWorld(playerid, WORLD_SELECTION);
		SetPlayerPos(playerid, 775.3851, -2846.4758, 5.6095);
		SetPlayerFacingAngle(playerid, 180);
		
	    Player::ShowDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "* Register", DIALOG_REGISTER_TEXT, "Register!", "Quit");
		return 1;
	}
	// Switch mode
	else if(PlayerInfo[playerid][Switchmode] == true)
	{
		Player::UpdateData(playerid);
	    Player::ResetInfo(playerid);
		Player::FetchData(playerid);
		
 		PlayerInfo[playerid][Registered] = 1;
		PlayerInfo[playerid][LoggedIn] = 1;
	    
 		SetPlayerVirtualWorld(playerid, WORLD_SELECTION);
		SetPlayerPos(playerid, 775.3851, -2846.4758, 5.6095);
		SetPlayerFacingAngle(playerid, 180);
	}
	// Respawn
	else if(PlayerInfo[playerid][Started])
	{
	    SetPlayerSkin(playerid, PlayerInfo[playerid][SkinID]);
	    
	    // Let the cw handler do whatever it wants
		if(CW::IsPlaying(playerid) && CW::IsRunning())
	    	return CW::OnRespawn(playerid); 
	    	
		if(Mini::IsPlaying(playerid) && Mini::IsRunning())
		    return Mini::OnRespawn(playerid);

		// Is the player jailed? Respawn him in jail.
		if(PlayerInfo[playerid][Jailed])
	    	return Jail::OnRespawn(playerid);

		if(IsPlayer(playerid))
			Player::OnRespawn(playerid);

		if(IsMod(playerid))
			Admin::OnRespawn(playerid);

		if(IsGang(playerid))
		    Gang::OnRespawn(playerid);

		if(IsTraining(playerid))
		    Training::OnRespawn(playerid);

		if(IsFreeroam(playerid))
		    Freeroam::OnRespawn(playerid);
	}

	return 1;
}
