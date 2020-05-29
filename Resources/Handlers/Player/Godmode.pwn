Godmode__Process(playerid)
{
    if(PlayerInfo[playerid][IsGod] == true)
    {
		SetPlayerHealth(playerid, 1000);
		SetPlayerArmour(playerid, 1000);
	}
}

Godmode__God(playerid)
{
	PlayerInfo[playerid][IsGod] = true;
	SetPlayerHealth(playerid, 1000);
	SetPlayerArmour(playerid, 1000);
}

Godmode__Ungod(playerid)
{
	PlayerInfo[playerid][IsGod] = false;
	SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 100.0);
}

