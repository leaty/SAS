public OnPlayerDisconnect(playerid, reason)
{
	IRC::OnDisconnect(playerid, reason);

	if(IsPlayer(playerid))
		Player::OnDisconnect(playerid, reason);

	if(IsMod(playerid))
	    Admin::OnDisconnect(playerid, reason);

	if(IsGang(playerid))
		Gang::OnDisconnect(playerid, reason);

	if(CW::IsInvolved(playerid))
	    CW::OnDisconnect(playerid, reason);

	if(Mini::IsPlaying(playerid))
	    Mini::OnDisconnect(playerid, reason);

	if(IsSpectating(playerid))
	    Spectate::OnDisconnect(playerid, reason);

	Player::UpdateData(playerid);
	Player::ResetInfo(playerid);

	return 1;
}

