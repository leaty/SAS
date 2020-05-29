stock Tec9(playerid,msg)
{
    ResetPlayerWeapons(playerid);
    GivePlayerWeapon(playerid,26,100000);
	GivePlayerWeapon(playerid,32,100000);
	GivePlayerWeapon(playerid,24,100000);
	if(msg == 1)
	{
		SendClientMessage(playerid,COLOR_TRUE,"* Weapons Granted.");
	}
}
stock Uzi(playerid,msg)
{
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid,26,100000);
	GivePlayerWeapon(playerid,28,100000);
	GivePlayerWeapon(playerid,24,100000);
	if(msg == 1)
	{
		SendClientMessage(playerid,COLOR_TRUE,"* Weapons Granted.");
	}
}
stock WalkiesPumpUnlimited(playerid,msg)
{
	ResetPlayerWeapons(playerid);
    GivePlayerWeapon(playerid,34,100000);
	GivePlayerWeapon(playerid,31,100000);
	GivePlayerWeapon(playerid,29,100000);
	GivePlayerWeapon(playerid,25,100000);
 	GivePlayerWeapon(playerid,24,100000);
 	if(msg == 1)
	{
 		SendClientMessage(playerid,COLOR_TRUE,"* Weapons Granted.");
 	}
}
stock WalkiesPumpLimited(playerid,msg)
{
    ResetPlayerWeapons(playerid);
    GivePlayerWeapon(playerid,34,10);
	GivePlayerWeapon(playerid,31,100);
	GivePlayerWeapon(playerid,29,300);
	GivePlayerWeapon(playerid,25,50);
 	GivePlayerWeapon(playerid,24,500);
 	if(msg == 1)
	{
 		SendClientMessage(playerid,COLOR_TRUE,"* Weapons Granted.");
 	}
}
stock WalkiesSpasLimited(playerid,msg)
{
    ResetPlayerWeapons(playerid);
    GivePlayerWeapon(playerid,34,10);
	GivePlayerWeapon(playerid,31,100);
	GivePlayerWeapon(playerid,29,300);
	GivePlayerWeapon(playerid,27,21);
 	GivePlayerWeapon(playerid,24,500);
 	if(msg == 1)
	{
 		SendClientMessage(playerid,COLOR_TRUE,"* Weapons Granted.");
 	}
}
stock WalkiesSpasUnlimited(playerid,msg)
{
    ResetPlayerWeapons(playerid);
    GivePlayerWeapon(playerid,34,100000);
	GivePlayerWeapon(playerid,31,100000);
	GivePlayerWeapon(playerid,29,100000);
	GivePlayerWeapon(playerid,27,100000);
 	GivePlayerWeapon(playerid,24,100000);
    if(msg == 1)
	{
 		SendClientMessage(playerid,COLOR_TRUE,"* Weapons Granted.");
 	}
}

