public OnPlayerDeath(playerid, killerid, reason)
{
    SetPlayerHealth(playerid, 100); // Fixes the death but still alive bug
    
	SendDeathMessage(killerid, playerid, reason);

	IRC::OnDeath(playerid, killerid, reason);

 	if(CW::IsPlaying(playerid) && CW::IsRunning())
	    return CW::OnDeath(playerid, killerid, reason);
	    
	if(Mini::IsPlaying(playerid) && Mini::IsRunning())
 		return Mini::OnDeath(playerid, killerid, reason);

	if(IsPlayer(playerid))
		Player::OnDeath(playerid, killerid, reason);

	if(IsMod(playerid))
	    Admin::OnDeath(playerid, killerid, reason);

	if(IsTraining(playerid))
	    Training::OnDeath(playerid, killerid, reason);

	if(IsFreeroam(playerid))
	    Freeroam::OnDeath(playerid, killerid, reason);

	if(IsGang(playerid))
		Gang::OnDeath(playerid, killerid, reason);

	return 1;
}

