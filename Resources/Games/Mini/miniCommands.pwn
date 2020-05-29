sas_MiniEnd(playerid, params[])
{
	if(!Mini::IsRunning())
	    return SendClientMessage(playerid, COLOR_FALSE, "* There's no minigame running, try '/minireset'.");
	    
	Mini::End("admin");
	#pragma unused params
	return 1;
}

sas_MiniReset(playerid, params[])
{
	Mini::Reset();
	#pragma unused playerid, params
	return 1;
}

sas_Leave(playerid, params[])
{
	if(!Mini::IsPlaying(playerid))
		return SendClientMessage(playerid, COLOR_FALSE, "* You're not in any minigame!");

	if(IsPlayerFighting(playerid, 10))
		return SendClientMessage(playerid, COLOR_FALSE, "* To prevent laming, you cannot use this command until you've stopped fighting.");


	Mini::DropPlayer(playerid, "left");
	
	if(Mini::CheckPlayers())
	    Mini::End("Not enough players");
	
	#pragma unused params
	return 1;
}

sas_Signup(playerid, params[])
{
	if(Mini::IsPlaying(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You're already signed up!");

	if(IsPlayerFighting(playerid, 15))
		return SendClientMessage(playerid, COLOR_FALSE, "* To prevent laming, you cannot use this command until you've stopped fighting.");

	if(Mini::IsRunning())
	    return SendClientMessage(playerid, COLOR_FALSE, "* Too late! The minigame has already started.");
	    
	if(Mini::IsSettingUp())
		return SendClientMessage(playerid, COLOR_FALSE, "* There's no minigame running!");
	    
	if(Mini::IsNone())
		return SendClientMessage(playerid, COLOR_FALSE, "* There's no minigame running, try '/minigames'.");


	if(Mini::IsSigningUp())
	{
		Mini::OnSignup(playerid);
	}

	#pragma unused params
	return 1;
}

sas_Minigames(playerid, params[])
{
	if(Mini::IsRunning())
	    return SendClientMessage(playerid, COLOR_FALSE, "* There's already a minigame running, you cannot start a new one until the current one is over.");

	if(Mini::IsSettingUp())
		return SendClientMessage(playerid, COLOR_FALSE, "* Someone is already setting up a minigame, please wait.");

    if(Mini::IsSigningUp())
        return SendClientMessage(playerid, COLOR_FALSE, "* There's already a minigame signing up, try '/signup'");

	MiniInfo[miniStatus] = MINI_STATUS_SETUP;

	Player::ShowDialog(playerid, DIALOG_MINI_GAMES, DIALOG_STYLE_LIST, "Minigames", Mini::GetGameList(), "Setup", "Close");
	
	#pragma unused params
	return 1;
}

sas_ForceJoin(playerid, params[])
{
    if(!Mini::IsSigningUp())
        return SendClientMessage(playerid, COLOR_FALSE, "* Start the minigame first.");

	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerConnected(i) || MiniInfo[miniPlayers][i])
	        continue;
	        
	    Mini::OnSignup(i);
	}
	
	SendClientMessage(playerid, COLOR_TRUE, "Everyone was forced to join the minigame.");
	
 	#pragma unused params
	return 1;
}

