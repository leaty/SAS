Hax__SuperJump(playerid)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	SetPlayerPos(playerid, X, Y, Z+10);
	return 1;
}

