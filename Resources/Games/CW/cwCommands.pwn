#define cw_alias(%1,%2,%3,%4); if( ( strlen(cmdtext) > 0 && strcmp(cmdtext, #%1, true, (%2) ) == 0 ) && ( PlayerInfo[playerid][AdminLevel] >= %3 ) && ( ( cmdtext[(%2)] == 0 && cw_%4(playerid,"") ) || ( cmdtext[(%2)] == 32 && cw_%4(playerid, cmdtext[(%2)+1]) ) ) ) return 1;
#define cw_command(%1,%2,%3); cw_alias(%1,%2,%3,%1);


CW__OnCommand(playerid, cmdtext[])
{
	if(!GAMES_CLANWAR)
	    return SendClientMessage(playerid, COLOR_FALSE, "* The CW Handler is currently disabled.");

	// Is the player playing a clanwar?
	if(CW::IsPlaying(playerid))
	{
	    if(strcmp(cmdtext, "kill", true, 4) == 0)
	    	return sas_Kill(playerid, cmdtext[5]);
	
	    // Isn't he the organizer? (inviter/accepter) Deny! Else only let him use Respawn or End
		if(!CW::IsOrganizer(playerid))
			return SendClientMessage(playerid, COLOR_FALSE, "* You cannot use any other command than '/kill' whilst in a clanwar.");

		if(strcmp(cmdtext, "cw", true, 2) == 0)
		{
			// Since it was called directly from OnPlayerCommandText, we must remove /cw manually
			format(cmdtext, 128, "%s", cmdtext[2+1]);
			
			cw_command(Respawn,     7,      LEVEL_PLAYER);
			cw_command(End,    		3,      LEVEL_PLAYER);
			
		}
		
		if(!IsAdmin(playerid))
			return SendClientMessage(playerid, COLOR_FALSE, "* You can only use '/cw respawn' and '/cw end'");
	}
	
	
	// Is the player spectating the clanwar?
	if(CW::IsSpectating(playerid))
	{
 		cw_command(Stopwatch,	9,      LEVEL_PLAYER);
 		
 		if(!IsAdmin(playerid))
			return SendClientMessage(playerid, COLOR_FALSE, "* You can only use '/cw stopwatch' whilst watching the clanwar.");
	}
	
	
	if(IsPlayerFighting(playerid, 10))
	    return SendClientMessage(playerid, COLOR_FALSE, "* To prevent laming, you cannot use this command until you've stopped fighting.");
	
	
	cw_command(NL,          2,      LEVEL_MANAGEMENT);
    cw_command(Admin,       5,      LEVEL_ADMIN);
    cw_command(Watch,		5,      LEVEL_PLAYER);


 	cw_command(Invite,      6,      LEVEL_PLAYER);
    cw_command(Accept,      6,      LEVEL_PLAYER);
    //cw_command(Deny,        4,      LEVEL_PLAYER);
    
    
    


	return CW::ShowUsageMsg(playerid);
}

sas_CW(playerid, params[])
{
	if(GAMES_CLANWAR)
		return CW::OnCommand(playerid, params);
		
	return 0;
}

CW__ShowUsageMsg(playerid)
{
	new sUsage[256], sAdminUsage[50], sOrganizeUsage[50], sNeutralUsage[50], sMessage[128];
	
	Format(sUsage, "Usage: /cw [");
	
	if(IsManagement(playerid))
		sAdminUsage = "admin/nl/";
	else if(IsAdmin(playerid))
	   sAdminUsage = "admin/";

	if(CWInfo[cwFrozen] && CW::IsOrganizer(playerid))
	    sOrganizeUsage = "respawn/end";
	else if(!CW::IsPlaying(playerid))
		sNeutralUsage = "watch/invite/accept";
		
	Format(sMessage, "%s%s%s%s]", sUsage, sAdminUsage, sOrganizeUsage, sNeutralUsage);
	SendClientMessage(playerid, COLOR_USAGE, sMessage);
	
	return 1;
}




