#if TEST == 1
sas_Admin(playerid, params[])
{
	if(PlayerInfo[playerid][AdminLevel] >= LEVEL_ADMIN)
	    return SendClientMessage(playerid, COLOR_FALSE, "* You're already an administrator!");
	    
	new sMessage[128];
	
	Format(sMessage, "%s has made himself admin for testing purposes.", PlayerName(playerid));
	SendAdminMsg(sMessage);
	
	PlayerInfo[playerid][AdminLevel] = LEVEL_ADMIN;
	
	SendClientMessage(playerid, COLOR_TRUE, "* Okay, you've now got administrative privileges,");
	SendClientMessage(playerid, COLOR_INFO, "* remember that these rights are only for testing purposes!");
	SendClientMessage(playerid, COLOR_INFO, "* Use /unadmin to become a player again.");

	#pragma unused params
	return 1;
}

sas_UnAdmin(playerid, params[])
{
	if(PlayerInfo[playerid][AdminLevel] == LEVEL_PLAYER)
	    return SendClientMessage(playerid, COLOR_FALSE, "* You're already a player!");

	new sMessage[128];

	Format(sMessage, "%s has made himself a player again.", PlayerName(playerid));
	SendAdminMsg(sMessage);
	
	PlayerInfo[playerid][AdminLevel] = LEVEL_PLAYER;

	SendClientMessage(playerid, COLOR_TRUE, "* Etminhax gone!");

    #pragma unused params
	return 1;
}
#endif


sas_Kill(playerid, params[])
{
	SetPlayerHealth(playerid, 0);
	#pragma unused params
	return 1;
}

sas_Commands(playerid, params[])
{
	SendClientMessage(playerid, COLOR_TITLE, "** Commands **");
	
	if(IsFreeroam(playerid))
		SendClientMessage(playerid, COLOR_INFO, "Freeroam: /help, /ramping, /tp, /ctp, /vr, /vf, /nos, /dive, /cardive");
		
	if(IsTraining(playerid))
		SendClientMessage(playerid, COLOR_INFO, "Training: /fc, /ramping, /cd, /weps, /tp, /vr, /vf, /nos, /dive");
		
	SendClientMessage(playerid, COLOR_INFO, "Global: /switchmode, /my, /kill, /dev, /gang, /cw, /minigames");
	SendClientMessage(playerid, COLOR_TITLE, "----------------");
	#pragma unused playerid, params
	return 1;
}

sas_Cmds(playerid, params[])
{
	return sas_Commands(playerid, params);
}

sas_PM(playerid, params[])
{
	new pid, sPlayer[24], sMessage[256], sPersonalMsg[256];
	
	if(sscanf(params, "ss", sPlayer, sMessage))
		return SendClientMessage(playerid, COLOR_USAGE, "Usage: /pm [name/id] [message]");
	    
	pid = ReturnPlayerWithMessage(playerid, sPlayer);
	
	if(pid == INVALID_PLAYER_ID || !IsPlayerConnected(pid))
	    return 1;
	    
	if(pid == playerid)
	    return SendClientMessage(playerid, COLOR_FALSE, "* You cannot PM yourself!");
	    
	Format(sPersonalMsg, "PM from %s (%d): %s", PlayerName(playerid), playerid, sMessage);
	SendClientMessage(pid, COLOR_PM_FROM, sPersonalMsg);
	SendClientMessage(pid, 0xDADADA96, "You can use /r to quickly reply to this personal message.");
	
	Format(sPersonalMsg, "PM to %s (%d): %s", PlayerName(pid), pid, sMessage);
	SendClientMessage(playerid, COLOR_PM_TO, sPersonalMsg);
	
	PlayerInfo[pid][LastPM] = playerid;
	PlayerInfo[playerid][LastPM] = pid;
	
	return 1;
}

sas_R(playerid, params[])
{
 	new pid = PlayerInfo[playerid][LastPM];
 	new sMessage[256], sPersonalMsg[256];

	if(sscanf(params, "s", sMessage))
		return SendClientMessage(playerid, COLOR_USAGE, "Usage: /r [message]");

	if(pid == -1)
	    return SendClientMessage(playerid, COLOR_FALSE, "* You haven't received any personal messages!");

	if(pid == playerid || (!IsPlayerConnected(pid)) )
	{
	    PlayerInfo[playerid][LastPM] = -1;
	    PlayerInfo[pid][LastPM] = -1;
	    return SendClientMessage(playerid, COLOR_FALSE, "* The player you are trying to reach is unavailable.");
 	}
 	
	Format(sPersonalMsg, "PM from %s (%d): %s", PlayerName(playerid), playerid, sMessage);
	SendClientMessage(pid, COLOR_PM_FROM, sPersonalMsg);
	SendClientMessage(pid, 0xDADADA96, "You can use /r to quickly reply to this personal message.");

	Format(sPersonalMsg, "PM to %s (%d): %s", PlayerName(pid), pid, sMessage);
	SendClientMessage(playerid, COLOR_PM_TO, sPersonalMsg);
	
	PlayerInfo[pid][LastPM] = playerid;
	PlayerInfo[playerid][LastPM] = pid;
	
	return 1;
}

sas_Dev(playerid, params[])
{
	new sMessage[256];
	if(sscanf(params, "s", sMessage)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /dev [bugreport]");

	FormatString("* Your bugreport was sent to the developers: %s", sMessage);
	SendClientMessage(playerid, COLOR_TRUE, string);
	
	SendDevMsg(PlayerName(playerid), sMessage);

	return 1;
}

#include Commands\cmdMy.pwn

