#define NONCHEAT_MAX_WEAPONS   		200

new NonCheatWeapons[MaxSlots][NONCHEAT_MAX_WEAPONS];

public Anti_Process()
{
	Anti::Weapons();
}

Anti__Init()
{
	SetTimer("Anti_Process", 3000, true);
	return 1;
}

Anti__Weapons()
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    
	}
	return 1;
}

stock GiveSafeWeapon(playerid, weaponid, ammo)
{
	NonCheatWeapons[playerid][weaponid] = 1;
	GivePlayerWeapon(playerid, weaponid, ammo);
	
	return 1;
}

stock ResetSafeWeapon(playerid)
{
	for(new i = 0; i < 54; i++)
		NonCheatWeapons[playerid][i] = 0;

	return 1;
}



