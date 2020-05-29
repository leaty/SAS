public OnPlayerConnect(playerid)
{
	IRC::OnConnect(playerid);
	Player::OnConnect(playerid);
	return 1;
}

