#define MODE_NEUTRAL_alias(%1,%2,%3,%4,%5); if( ( strcmp( cmdtext[1], #%1, true, (%2) ) == 0) && (PlayerInfo[playerid][AdminLevel] >= %3 && AllowCommand(playerid, %4) == 1 ) && ( ( cmdtext[(%2)+1] == 0 && sas_%5(playerid,"") ) || ( cmdtext[(%2)+1] == 32 && sas_%5(playerid, cmdtext[(%2)+2]) ) ) ) return 1;
#define MODE_TRAINING_alias(%1,%2,%3,%4,%5); if( ( strcmp( cmdtext[1], #%1, true, (%2) ) == 0) && (PlayerInfo[playerid][AdminLevel] >= %3 && AllowCommand(playerid, %4) == 1 ) && ( ( cmdtext[(%2)+1] == 0 && training_%5(playerid,"") ) || ( cmdtext[(%2)+1] == 32 && training_%5(playerid, cmdtext[(%2)+2]) ) ) ) return 1;
#define MODE_FREEROAM_alias(%1,%2,%3,%4,%5); if( ( strcmp( cmdtext[1], #%1, true, (%2) ) == 0) && (PlayerInfo[playerid][AdminLevel] >= %3 && AllowCommand(playerid, %4) == 1 ) && ( ( cmdtext[(%2)+1] == 0 && freeroam_%5(playerid,"") ) || ( cmdtext[(%2)+1] == 32 && freeroam_%5(playerid, cmdtext[(%2)+2]) ) ) ) return 1;

#define sas_command(%1,%2,%3,%4); %4_alias(%1,%2,%3,%4,%1);


public OnPlayerCommandText(playerid, cmdtext[])
{
	#pragma tabsize 0

	new sMessage[256];
	
	// If APM has been activated, only an administrator or above will be able to use commands.
	// This will get people to listen to the announcement more effectively.
	if(APM == true && !IsAdmin(playerid))
		return SendClientMessage(playerid, COLOR_FALSE, "* You cannot use any commands whilst an announcement is going on.");
		

	// If a player hasn't logged in, deny his usage of commands.
	if(!PlayerInfo[playerid][LoggedIn])
		return SendClientMessage(playerid, COLOR_FALSE, "* You have to register and login before using any commands.");
		
	// If the player has used /switchmode, deny commands to be sure he doesn't join a minigame etc..
	if(PlayerInfo[playerid][Switchmode] == true && !IsAdmin(playerid) && strcmp(cmdtext, "/kill", true, 5) != 0)
	    return SendClientMessage(playerid, COLOR_FALSE, "* You can only use /kill when switching modes.");

	// If the player is still in the login room, deny his usage of commands until he've entered a mode.
	if(!PlayerInfo[playerid][Started])
		return SendClientMessage(playerid, COLOR_FALSE, "* Please enter a mode first.");
		
    // If a player is jailed, deny his usage of commands.
	if(PlayerInfo[playerid][Jailed] && !IsAdmin(playerid))
	{
		Format(sMessage, "* You cannot use commands in jail, you will be released in %d minutes.", PlayerInfo[playerid][JailTime]);
	    return SendClientMessage(playerid, COLOR_FALSE, sMessage);
	}
	
	// If a player is frozen, deny his usage of commands.
	if(PlayerInfo[playerid][Frozen] && !IsAdmin(playerid))
		return SendClientMessage(playerid, COLOR_FALSE, "* You cannot use commands whilst frozen.");
	
	
	// Is the player playing a clanwar? Jump off to /cw
	if(CW::IsPlaying(playerid) && !IsAdmin(playerid))
 		return CW::OnCommand(playerid, cmdtext[1]);

	if(Mini::IsPlaying(playerid) && strcmp(cmdtext[1], "leave", true, 5) && strcmp(cmdtext[1], "kill", true, 4) && !IsAdmin(playerid))
		return SendClientMessage(playerid, COLOR_FALSE, "* You cannot use any other command than '/leave' & '/kill' whilst in a minigame.");

	
	#if REPORT_CMDS == 1
		if(!IsManagement(playerid))
		{
			FormatString("[CMD]: %s (%d) typed: '%s'", PlayerName(playerid), playerid, cmdtext);
			SendProAdminMsg(string);
		}
	#endif
	
	
	
	//Management
	sas_command(test,       4,      LEVEL_MANAGEMENT,       MODE_NEUTRAL);
	sas_command(Goto,       4,      LEVEL_MANAGEMENT,       MODE_NEUTRAL);
	sas_command(AKA,        3,      LEVEL_MANAGEMENT,       MODE_NEUTRAL);
	sas_command(S,          1,      LEVEL_MANAGEMENT,       MODE_NEUTRAL);
	sas_command(World, 		5, 		LEVEL_MANAGEMENT,		MODE_NEUTRAL);
	sas_command(News,       4,      LEVEL_MANAGEMENT,       MODE_NEUTRAL);
	sas_command(ForceJoin,  9,      LEVEL_MANAGEMENT,       MODE_NEUTRAL);
	
	//Admin
	sas_command(V,   		1, 		LEVEL_ADMIN,			MODE_NEUTRAL);
	sas_command(F, 			1,    	LEVEL_ADMIN,			MODE_NEUTRAL);
	sas_command(Cf, 		2,   	LEVEL_ADMIN,			MODE_NEUTRAL);
	sas_command(Hax,        3,      LEVEL_ADMIN,            MODE_NEUTRAL);
	sas_command(God,        3,      LEVEL_ADMIN,            MODE_NEUTRAL);
	sas_command(APM,        3,      LEVEL_ADMIN,            MODE_NEUTRAL);
	sas_command(Move, 		4, 		LEVEL_ADMIN,			MODE_NEUTRAL);
	sas_command(Hardcore,   8,      LEVEL_ADMIN,            MODE_NEUTRAL);
	sas_command(Create, 	6, 		LEVEL_ADMIN,			MODE_NEUTRAL);
	sas_command(MiniEnd,    7,      LEVEL_ADMIN,            MODE_NEUTRAL);
	sas_command(MiniReset,  9,      LEVEL_ADMIN,            MODE_NEUTRAL);

	//Mod
	sas_command(P,   		1,  	LEVEL_MOD, 				MODE_NEUTRAL);
	sas_command(Spec,       4,      LEVEL_MOD,              MODE_NEUTRAL);
	sas_command(Specoff,    7,      LEVEL_MOD,              MODE_NEUTRAL);
	sas_command(Kick, 		4, 		LEVEL_MOD,				MODE_NEUTRAL);
	sas_command(Ban, 		3,  	LEVEL_MOD,				MODE_NEUTRAL);
	sas_command(Show, 		4, 		LEVEL_MOD,				MODE_NEUTRAL);
	sas_command(Heal, 		4, 		LEVEL_MOD,				MODE_NEUTRAL);
	sas_command(Acmds, 		5, 		LEVEL_MOD,				MODE_NEUTRAL);

	//Player
	
	//--Neutral--
	sas_command(Commands,  	8,      LEVEL_PLAYER,			MODE_NEUTRAL);
	sas_command(Cmds,      	4,      LEVEL_PLAYER,			MODE_NEUTRAL);
	sas_command(R,          1,      LEVEL_PLAYER,           MODE_NEUTRAL);
	sas_command(PM,         2,      LEVEL_PLAYER,           MODE_NEUTRAL);
	sas_command(Dev, 		3,  	LEVEL_PLAYER,			MODE_NEUTRAL);
 	sas_command(Kill,       4,      LEVEL_PLAYER,           MODE_NEUTRAL);
	sas_command(My, 		2, 		LEVEL_PLAYER,			MODE_NEUTRAL);
	sas_command(Gang,       4,      LEVEL_PLAYER,           MODE_NEUTRAL);
	sas_command(CW,			2,     	LEVEL_PLAYER,			MODE_NEUTRAL);
	
	#if TEST == 1
 	sas_command(Admin,      5,      LEVEL_PLAYER,           MODE_NEUTRAL);
 	sas_command(UnAdmin,    7,      LEVEL_PLAYER,           MODE_NEUTRAL);
	#endif
	
	//--Minigames--
	sas_command(Leave,      5,      LEVEL_PLAYER,           MODE_NEUTRAL);
	sas_command(Signup,     6,      LEVEL_PLAYER,           MODE_NEUTRAL);
	sas_command(Minigames,  9,      LEVEL_PLAYER,           MODE_NEUTRAL);
	
	
	//--Training--
	if(IsTraining(playerid))
		if(Training::OnCommand(playerid, cmdtext))
			return 1;


	//--Freeroam--
	if(IsFreeroam(playerid))
		if(Freeroam::OnCommand(playerid, cmdtext))
		    return 1;


	return SendClientMessage(playerid, COLOR_FALSE, "* Unknown command, please see /commands.");
}

AllowCommand(playerid, pmode)
{
	if(PlayerInfo[playerid][pMode] != pmode && pmode != MODE_NEUTRAL)
		return 0;

	return 1;
}
