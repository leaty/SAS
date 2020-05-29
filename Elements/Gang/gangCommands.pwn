/*#define gang_alias(%1,%2,%3,%4,%5); if(strlen(cmdtext) > 0
	&& strcmp(cmdtext, #%1, true, (%2)) == 0
 	&& PlayerInfo[playerid][AdminLevel] >= %3
  	&& PlayerInfo[playerid][GangLevel] == %4 ) return gang_%5(playerid, cmdtext[(%2)+1]);
*/

#define gang_alias(%1,%2,%3,%4,%5); if( ( strlen(cmdtext) > 0 && strcmp(cmdtext, #%1, true, (%2) ) == 0 ) && ( PlayerInfo[playerid][AdminLevel] >= %3 ) && ( ( %4 == GANG_LEVEL_NEUTRAL ) || ( PlayerInfo[playerid][GangLevel] == %4 ) || ( %4 == GANG_LEVEL_GANG && IsGang(playerid) ) ) && ( ( cmdtext[(%2)] == 0 && gang_%5(playerid,"") ) || ( cmdtext[(%2)] == 32 && gang_%5(playerid, cmdtext[(%2)+1]) ) ) ) return 1;

#define gang_command(%1,%2,%3,%4); gang_alias(%1,%2,%3,%4,%1);

Gang__OnCommand(playerid, cmdtext[])
{
	//Management
	gang_command(Admin,         5,      LEVEL_MANAGEMENT,   GANG_LEVEL_NEUTRAL);

	//Admin

	//Mod
	
	//Gang owner
	gang_command(Delete,        6,      LEVEL_PLAYER,       GANG_LEVEL_OWNER);
	gang_command(Invite,        6,      LEVEL_PLAYER,       GANG_LEVEL_OWNER);
	gang_command(Kick,          4,      LEVEL_PLAYER,       GANG_LEVEL_OWNER);
	gang_command(Settings,      8,      LEVEL_PLAYER,       GANG_LEVEL_OWNER);
	
	//Gang member
	gang_command(Leave,         5,      LEVEL_PLAYER,       GANG_LEVEL_MEMBER);

	//Gang member/owner
	gang_command(Stats,         5,      LEVEL_PLAYER,       GANG_LEVEL_GANG);

	//Non gang && Player
	gang_command(Create,        6,		LEVEL_PLAYER, 		GANG_LEVEL_NONE);
	gang_command(Join,          4,      LEVEL_PLAYER,       GANG_LEVEL_NONE);

	gang_command(Info,          4,      LEVEL_PLAYER,       GANG_LEVEL_NEUTRAL);
	gang_command(List,          4,      LEVEL_PLAYER,       GANG_LEVEL_NEUTRAL);

	return Gang::ShowUsageMsg(playerid);
}


sas_Gang(playerid, params[])
{
	if(ELEMENT_GANG)
		return Gang::OnCommand(playerid, params);
		
	return 0;
}

Gang__ShowUsageMsg(playerid)
{
	new sUsage[128], adminUsage[128], gangUsage[128], sMessage[128];
	
	Format(sUsage, "Usage: /gang [");

	if(IsAdmin(playerid)) Format(adminUsage, "admin/");

	if(!IsGang(playerid))
		gangUsage = "create/join/";
	else if(IsGangOwner(playerid))
		gangUsage = "delete/invite/kick/settings/stats/";
	else if(IsGang(playerid))
		gangUsage = "leave/stats/";

 	Format(sMessage, "%s%s%sinfo/list]", sUsage, adminUsage, gangUsage);
 	SendClientMessage(playerid, COLOR_USAGE, sMessage);
 	
	return 1;
}

