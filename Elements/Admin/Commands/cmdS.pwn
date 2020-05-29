sas_S(playerid, params[])
{
	if(strlen(params) < 1)
	{
	    SendClientMessage(playerid, COLOR_TITLE, "Usage: /s [cmd]");
		if(IsManagement(playerid))
			SendClientMessage(playerid, COLOR_INFO, "gmx");
		if(IsAdmin(playerid))
		    SendClientMessage(playerid, COLOR_INFO, "ramping");

		return 1;
	}
	
	S_OnCommand(playerid, params);
	
	return 1;
}

#define s_alias(%1,%2,%3,%4); if( ( strlen(cmdtext) > 0 && strcmp(cmdtext, #%1, true, (%2) ) == 0 ) && ( PlayerInfo[playerid][AdminLevel] >= %3 ) && ( ( cmdtext[(%2)] == 0 && s_%4(playerid,"") ) || ( cmdtext[(%2)] == 32 && s_%4(playerid, cmdtext[(%2)+1]) ) ) ) return 1;

#define s_command(%1,%2,%3); s_alias(%1,%2,%3,%1);

S_OnCommand(playerid, cmdtext[])
{

	s_command(GMX,      3,      LEVEL_MANAGEMENT);
	s_command(Ramping,  7,      LEVEL_ADMIN);
	
	return SendClientMessage(playerid, COLOR_FALSE, "* This command does not exist, or it's above your rights to perform it.");
}

s_GMX(playerid, params[])
{
	new sMessage[128], sReason[128];
	
	if(sscanf(params, "s", sReason))
	    return SendClientMessage(playerid, COLOR_FALSE, "Usage: /s gmx [reason]");
	
	Format(sMessage, "%s used 'gmx'", PlayerName(playerid));
	SendAdminMsg(sMessage);
	
	Server::Exit(sReason);
	return 1;
}

s_Ramping(playerid, params[])
{
	new sMessage[128];

	if(RampingEnabled)
	{
	    RampingEnabled = false;
	    
		Format(sMessage, "%s disabled ramping.", PlayerName(playerid));
		SendAdminMsg(sMessage);
	}
 	else
	{
	    RampingEnabled = true;

		Format(sMessage, "%s enabled ramping.", PlayerName(playerid));
		SendAdminMsg(sMessage);
	}
	
	#pragma unused params
	return 1;
}

