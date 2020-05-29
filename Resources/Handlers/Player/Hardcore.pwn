Hardcore__Process(playerid)
{
	new Float:HP, Float:Arm;
	GetPlayerHealth(playerid, HP);
	GetPlayerArmour(playerid, Arm);
	
	if(HP < PlayerInfo[playerid][HC_HP])
	{
    	//if(HP > 10.0)
		Hardcore::UpdateHealth(playerid);
	}
	if(Arm < PlayerInfo[playerid][HC_ARM])
	{
		Hardcore::UpdateArmour(playerid);
	}
}

Hardcore__UpdateHealth(playerid)
{
	new Float:HP, Float:newHP;
    GetPlayerHealth(playerid, HP);
    
    newHP = PlayerInfo[playerid][HC_HP] - HP;
    newHP = newHP*5;
    newHP = PlayerInfo[playerid][HC_HP] - newHP;
	/*
	if(newHP < 10.0)
	{
	    SetPlayerHealth(playerid, 5.0);
	}
	else
	{
	    PlayerInfo[playerid][HC_HP] = newHP;
		SetPlayerHealth(playerid, newHP);
	}*/
	
 	PlayerInfo[playerid][HC_HP] = newHP;
	SetPlayerHealth(playerid, newHP);
}

Hardcore__UpdateArmour(playerid)
{
	new Float:Arm, Float:newArm;
    GetPlayerArmour(playerid, Arm);

	newArm = PlayerInfo[playerid][HC_ARM] - Arm;
    newArm = newArm*5;
	newArm = PlayerInfo[playerid][HC_ARM] - newArm;

    PlayerInfo[playerid][HC_ARM] = newArm;
    SetPlayerArmour(playerid, newArm);
}

Hardcore__Reset(playerid)
{
    PlayerInfo[playerid][Hardcore] = 0;
	PlayerInfo[playerid][HC_HP] = 100.0;
    PlayerInfo[playerid][HC_ARM] = 100.0;
}
