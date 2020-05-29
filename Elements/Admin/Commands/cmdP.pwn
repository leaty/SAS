sas_P(playerid, params[])
{
	new sPlayer[50], iPlayer, CMD[256];
	if(sscanf(params, "ss", sPlayer, CMD))
	{
		SendClientMessage(playerid, COLOR_TITLE, "Usage: /p [id/name] [action]");

		if(IsManagement(playerid))
			SendClientMessage(playerid, COLOR_INFO, "superfix, supernuke, freeze, unfreeze");
		if(IsAdmin(playerid))
		    SendClientMessage(playerid, COLOR_INFO, "burn, drop, nuke, kill, health, armour");
		if(IsMod(playerid))
		    SendClientMessage(playerid, COLOR_INFO, "fix, eng, swear, spec, mute, unmute, jail, unjail, hp");
		    
		return 1;
	}

	/*if(isNumeric(sPlayer))
        iPlayer = strval(sPlayer);
	else
	    iPlayer = ReturnPlayer(sPlayer);*/
	    
	iPlayer = ReturnPlayerWithMessage( playerid, sPlayer );
	
	if( iPlayer == INVALID_PLAYER_ID )
	    return true;
	
	return P_OnCommand(playerid, iPlayer, CMD);
}

#define p_alias(%1,%2,%3,%4); if( ( strlen(cmdtext) > 0 && strcmp(cmdtext, #%1, true, (%2) ) == 0 ) && ( PlayerInfo[playerid][AdminLevel] >= %3 ) && ( ( cmdtext[(%2)] == 0 && p_%4(playerid, iPlayer,"") ) || ( cmdtext[(%2)] == 32 && p_%4(playerid, iPlayer, cmdtext[(%2)+1]) ) ) ) return 1;

#define p_command(%1,%2,%3); p_alias(%1,%2,%3,%1);

P_OnCommand(playerid, iPlayer, cmdtext[])
{
	if(!IsPlayerConnected(iPlayer) /*|| iPlayer == INVALID_PLAYER_ID*/) return SendClientMessage(playerid, COLOR_FALSE, "* This player isn't connected.");
	if(PlayerInfo[playerid][AdminLevel] < PlayerInfo[iPlayer][AdminLevel]) return SendClientMessage(playerid, COLOR_FALSE, "* This player has a higher level than you, thus immune to your commands.");
	if(PlayerInfo[playerid][Registered] == 0 || PlayerInfo[playerid][LoggedIn] == 0 && strcmp(cmdtext, "fix", true, 3) != 0) return SendClientMessage(playerid, COLOR_FALSE, "* This player is not registered, or not logged in. You can only use 'fix' on this player.");

	//		  Command           Len     	Admin Level

	p_command(Superfix,			8,			LEVEL_MANAGEMENT);
	p_command(Supernuke,        9,      	LEVEL_MANAGEMENT);
	p_command(Freeze,           6,      	LEVEL_MANAGEMENT);
	p_command(Unfreeze,         8,      	LEVEL_MANAGEMENT);
	
	p_command(Gun,              3,      	LEVEL_ADMIN);
	p_command(Burn,             4,      	LEVEL_ADMIN);
	p_command(Drop,             4,          LEVEL_ADMIN);
	p_command(Nuke,             4,          LEVEL_ADMIN);
	p_command(Kill,             4,          LEVEL_ADMIN);
	p_command(Health,           6,          LEVEL_ADMIN);
	p_command(Armour,           6,          LEVEL_ADMIN);

	p_command(Fix,              3,          LEVEL_MOD);
	p_command(Eng,              3,          LEVEL_MOD);
	p_command(Swear,            5,          LEVEL_MOD);
	p_command(Spec,             4,          LEVEL_MOD);
	p_command(Mute,             4,          LEVEL_MOD);
	p_command(Unmute,           6,          LEVEL_MOD);
	p_command(Jail,             4,          LEVEL_MOD);
	p_command(Unjail,           6,          LEVEL_MOD);
	p_command(HP,               2,          LEVEL_MOD);
	p_command(Cash,             4,          LEVEL_MOD);


	return SendClientMessage(playerid, COLOR_FALSE, "* This command does not exist, or it's above your rights to perform it.");
}

p_Superfix(playerid, iPlayer, params[])
{
	new sMessage[128];
	
	Player::UpdateData(iPlayer);
	Player::ResetInfo(iPlayer);
	
	PlayerInfo[iPlayer][Registered] = 1;
	PlayerInfo[iPlayer][LoggedIn] = 0;
	
	SpawnPlayer(iPlayer);
	SendClientMessage(iPlayer, COLOR_TRUE, "* Your account has been fixed, please login again.");
	
	Format(sMessage, "%s has super-fixed %s (ID: %d).", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendAdminMsg(sMessage);
	
	#pragma unused params
	return 1;
}

p_Supernuke(playerid, iPlayer, params[])
{
	new Float:X, Float:Y, Float:Z, sMessage[128];
	GetPlayerPos(iPlayer, X, Y, Z);

	CreateExplosion(X, Y, Z+1, 7, 10.0);
	CreateExplosion(X, Y+1, Z, 7, 10.0);
	CreateExplosion(X+1, Y, Z, 7, 10.0);
	CreateExplosion(X+1, Y, Z, 7, 10.0);
	
	CreateExplosion(X, Y, Z+8, 7, 10.0);
	CreateExplosion(X, Y+8, Z, 7, 10.0);
	CreateExplosion(X+8, Y, Z, 7, 10.0);
	
	CreateExplosion(X, Y, Z+16, 7, 10.0);
	CreateExplosion(X, Y+16, Z, 7, 10.0);
	CreateExplosion(X+16, Y, Z, 7, 10.0);
	
	CreateExplosion(X, Y, Z+10, 7, 10.0);
	CreateExplosion(X, Y, Z+10, 7, 10.0);
	CreateExplosion(X, Y, Z+10, 7, 10.0);
	CreateExplosion(X, Y, Z+10, 7, 10.0);

	Format(sMessage, "%s has super-nuked %s (ID: %d).", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendAdminMsg(sMessage);

	#pragma unused params
	return 1;
}

p_Freeze(playerid, iPlayer, params[])
{
	new sMessage[128];

	PlayerInfo[iPlayer][Frozen] = true;
	TogglePlayerControllable(iPlayer, false);
	SendClientMessage(iPlayer, COLOR_TRUE, "* You've been frozen.");

	Format(sMessage, "%s has freezed %s (ID: %d).", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendAdminMsg(sMessage);

	#pragma unused params
	return 1;
}

p_Unfreeze(playerid, iPlayer, params[])
{
	new sMessage[128];
	
	PlayerInfo[iPlayer][Frozen] = false;
	TogglePlayerControllable(iPlayer, true);
	SendClientMessage(iPlayer, COLOR_TRUE, "* You've been unfrozen.");
	
	Format(sMessage, "%s has unfreezed %s (ID: %d).", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendAdminMsg(sMessage);
	
	#pragma unused params
	return 1;
}

p_Gun(playerid, iPlayer, params[])
{
	new iWeaponID, iAmmo;
	
	if(sscanf(params, "dd", iWeaponID, iAmmo))
		return SendClientMessage(playerid, COLOR_USAGE, "Usage: /p [id/name] gun [weapon id] [ammo]");
	
	if(!IsValidWeapon(iWeaponID))
		return SendClientMessage(playerid, COLOR_FALSE, "* Invalid weapon ID!");
	
	GivePlayerWeapon(iPlayer, iWeaponID, iAmmo);
	
	SendClientMessage(playerid, COLOR_TRUE, "* Done.");

	return 1;
}

p_Burn(playerid, iPlayer, params[])
{
	if(IsPlayerInAnyVehicle(iPlayer))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You cannot burn a player who's inside a vehicle.");
	    
	new Float:X, Float:Y, Float:Z, sMessage[128];
	GetPlayerPos(iPlayer, X, Y, Z);
	CreateExplosion(X, Y, Z+2, 1, 10);
	
	Format(sMessage, "%s has burned %s (ID: %d).", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendAdminMsg(sMessage);
	
	#pragma unused params
	return 1;
}

p_Drop(playerid, iPlayer, params[])
{
	new Float:X, Float:Y, Float:Z, sMessage[128];
	
	PlayerInfo[iPlayer][Paralyzed] = true;
	
	GetPlayerPos(iPlayer, X, Y, Z);
	SetPlayerPos(iPlayer, X, Y, Z+40);
	
	Format(sMessage, "%s has dropped %s (ID: %d).", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendAdminMsg(sMessage);
	
	#pragma unused params
	return 1;
}

p_Nuke(playerid, iPlayer, params[])
{
	new Float:X, Float:Y, Float:Z, sMessage[128];
	GetPlayerPos(iPlayer, X, Y, Z);

	CreateExplosion(X, Y, Z+1, 7, 10.0);
	CreateExplosion(X, Y+1, Z, 7, 10.0);
	CreateExplosion(X+1, Y, Z, 7, 10.0);
	CreateExplosion(X+1, Y, Z, 7, 10.0);
	
	Format(sMessage, "%s has nuked %s (ID: %d).", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendAdminMsg(sMessage);
	
	#pragma unused params
	return 1;
}

p_Kill(playerid, iPlayer, params[])
{
	new sMessage[128];
	
	SetPlayerHealth(iPlayer, 0);
	
	Format(sMessage, "%s has killed %s (ID: %d).", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendAdminMsg(sMessage);
	
	#pragma unused params
	return 1;
}

p_Health(playerid, iPlayer, params[])
{
	new Float:Health, sMessage[128];

	if(sscanf(params, "f", Health))
	    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /p [id/name] health [value]");

	SetPlayerHealth(iPlayer, Health);

	Format(sMessage, "%s has set %s's (ID: %d) health to %f.", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendAdminMsg(sMessage);
	
	return 1;
}

p_Armour(playerid, iPlayer, params[])
{
	new Float:Armour, sMessage[128];
	
	if(sscanf(params, "f", Armour))
	    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /p [playerid] armour [value]");
	    
	SetPlayerArmour(iPlayer, Armour);

	Format(sMessage, "%s has set %s's (ID: %d) armour to %f.", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendAdminMsg(sMessage);

	return 1;
}

p_Fix(playerid, iPlayer, params[])
{
	new sMessage[128];
	
	SpawnPlayer(iPlayer);
	SendClientMessage(iPlayer, COLOR_TRUE, "* You've been fixed.");
	
	Format(sMessage, "%s has fixed %s (ID: %d).", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendModMsg(sMessage);
	
	#pragma unused params
	return 1;
}

p_Eng(playerid, iPlayer, params[])
{
	new sMessage[128];
	
	SendClientMessage(iPlayer, COLOR_FALSE, "==========================================");
	SendClientMessage(iPlayer, COLOR_INFO, "You've been warned for non-english.");
	SendClientMessage(iPlayer, COLOR_INFO, "We prefer english in the mainchat, please try to");
	SendClientMessage(iPlayer, COLOR_INFO, "use /pm for other languages as much as you can.");
	SendClientMessage(iPlayer, COLOR_FALSE, "==========================================");
	
	Format(sMessage, "%s has warned %s (ID: %d) for 'eng'.", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendModMsg(sMessage);
	
	#pragma unused params
	return 1;
}

p_Swear(playerid, iPlayer, params[])
{
	new sMessage[128];
	
	SendClientMessage(iPlayer, COLOR_FALSE, "==========================================");
	SendClientMessage(iPlayer, COLOR_INFO, "You've been warned for swearing/racism.");
	SendClientMessage(iPlayer, COLOR_INFO, "Swearing/Racism is strictly forbidden in this server.");
	SendClientMessage(iPlayer, COLOR_INFO, "Continue with this and you will be muted.");
	SendClientMessage(iPlayer, COLOR_FALSE, "==========================================");
	
	Format(sMessage, "%s has warned %s (ID: %d) for 'swear/racism'.", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendModMsg(sMessage);
	
	#pragma unused params
	return 1;
}

p_Spec(playerid, iPlayer, params[])
{
	new sMessage[128];
	
	Spectate::Player(playerid, iPlayer);
	
	Format(sMessage, "%s is now spectating %s (ID: %d).", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendModMsg(sMessage);
	
	SendClientMessage(playerid, COLOR_INFO, "* Press jump to switch between players.");
	SendClientMessage(playerid, COLOR_INFO, "* Use /specoff to stop spectating.");

	#pragma unused params
	return 1;
}

p_Mute(playerid, iPlayer, params[])
{
	new sReason[128];

	if(sscanf(params, "s", sReason))
	    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /p [id/name] mute [reason]");
	
	Mute::Mute(iPlayer, playerid, sReason);
	
	return 1;
}

p_Unmute(playerid, iPlayer, params[])
{
	new sMessage[128];
	Format(sMessage, "%s has unmuted %s (ID: %d).", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendModMsg(sMessage);
	
	Mute::Unmute(iPlayer);
	
	#pragma unused params
	return 1;
}

p_Jail(playerid, iPlayer, params[])
{
	new sReason[128];

	if(sscanf(params, "s", sReason))
	    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /p [id/name] mute [reason]");

	Jail::Jail(iPlayer, playerid, sReason);

	return 1;
}

p_Unjail(playerid, iPlayer, params[])
{
	new sMessage[128];

	Format(sMessage, "%s has unjailed %s (ID: %d).", PlayerName(playerid), PlayerName(iPlayer), iPlayer);
	SendModMsg(sMessage);

	Jail::Unjail(iPlayer);
	
	#pragma unused params
	return 1;
}

p_HP(playerid, iPlayer, params[])
{
	new Float:Health, Float:Armour;
	new sMessage[128];
	
	GetPlayerHealth(iPlayer, Health);
	GetPlayerArmour(iPlayer, Armour);
	
	Format(sMessage, "-- %s's HP: --", PlayerName(iPlayer));
	SendClientMessage(playerid, COLOR_TITLE, sMessage);
	Format(sMessage, "Health: %.1f", Health);
	SendClientMessage(playerid, COLOR_INFO, sMessage);
	Format(sMessage, "Armour: %.1f", Armour);
	SendClientMessage(playerid, COLOR_INFO, sMessage);
	
	#pragma unused params
	return 1;
}

p_Cash(playerid, iPlayer, params[])
{
	new sMessage[128], Cash;
	
	if(sscanf(params, "d", Cash))
	{
		Format(sMessage, "* %s's cash: %d", PlayerName(iPlayer), GetPlayerMoney(iPlayer));
		return SendClientMessage(playerid, COLOR_INFO, sMessage);
	}
	
	if(!IsAdmin(playerid))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You do not have the required permissions to do this.");
	
	SetPlayerMoney(iPlayer, Cash);
	
	Format(sMessage, "%s has set %s's (ID: %d) cash to: %d", PlayerName(playerid), PlayerName(iPlayer), iPlayer, Cash);
	SendAdminMsg(sMessage);
	return 1;
}

