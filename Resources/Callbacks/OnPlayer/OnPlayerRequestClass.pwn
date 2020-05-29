public OnPlayerRequestClass(playerid, classid)
{
	PlayerPlaySound(playerid, 1068, 0.0, 0.0, 0.0);
	
	if(PlayerInfo[playerid][Registered] == TRUE && PlayerInfo[playerid][Started] == FALSE) // Is player registered & did he just join? Fetch data
	{
     	PlayerInfo[playerid][SkinID] = GetUserSkin(playerid);

		if(PlayerInfo[playerid][SkinID] != 0) // Has the player picked a skin before? Set it and spawn the player.
		{
		    SetSpawnInfo(playerid, 255, PlayerInfo[playerid][SkinID], 775.3851, -2846.4758, 5.6095, 180, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
			return 1;
		}
	}

    PlayerInfo[playerid][Switchmode] = true;
	SetPlayerPos(playerid, 775.3851, -2846.4758, 5.6095);
	SetPlayerFacingAngle(playerid, 180);
	SetPlayerCameraPos(playerid, 773.5809+0.5, -2850.6118-1.5, 5.6095+4);
	SetPlayerCameraLookAt(playerid, 775.3851, -2846.4758, 5.6095);

	return 1;
}
