sas_My(playerid, params[])
{
	My_OnCommand(playerid, params);
	return 1;
}

My_SendUsageMsg(playerid)
{
	new sUsage[128];
	
	// Neutral commands
	sUsage = "Usage: /my [stats/ramp";

	if(IsTraining(playerid))
		Format(sUsage, "%s/skin", sUsage);
	else if(IsFreeroam(playerid))
	    Format(sUsage, "%s/bank", sUsage);
	    
	Format(sUsage, "%s]", sUsage);
	
	SendClientMessage(playerid, COLOR_USAGE, sUsage);
	return 1;
}

#define my_alias(%1,%2,%3,%4); if( ( strlen(cmdtext) > 0 && strcmp(cmdtext, #%1, true, (%2) ) == 0 ) && ( PlayerInfo[playerid][pMode] == %3 || %3 == MODE_NEUTRAL ) && ( ( cmdtext[(%2)] == 0 && My_%4(playerid,"") ) || ( cmdtext[(%2)] == 32 && My_%4(playerid, cmdtext[(%2)+1]) ) ) ) return 1;

#define my_command(%1,%2,%3); my_alias(%1,%2,%3,%1);

My_OnCommand(playerid, cmdtext[])
{

	// Neutral
	my_command(Stats,       5,          MODE_NEUTRAL);
	my_command(Ramp,     	4,          MODE_NEUTRAL);
	
	// Freeroam
	my_command(Bank,        4,          MODE_FREEROAM);
	
	// Training
	my_command(Skin,        4,          MODE_TRAINING);
	
	
	
	
	return My_SendUsageMsg(playerid);
}

//==========================//
// 		  NEUTRAL	     	//
//==========================//

My_Stats(playerid, params[])
{
	new ShowStats[128], Float:Ratio;

	Ratio = floatdiv(PlayerInfo[playerid][Kills], PlayerInfo[playerid][Deaths]);

	SendClientMessage(playerid, COLOR_TITLE, "*** Your personal statistics: ***");
	Format(ShowStats, "* You've been playing on San Andreas Splitmode for %s!", ConvertTime(GetPlayerPlayTime(playerid, MODE_NEUTRAL)));
	SendClientMessage(playerid, COLOR_INFO, ShowStats);
	Format(ShowStats, "* You have killed someone %d times and died %d times. This makes your K/D Ratio %.2f", PlayerInfo[playerid][Kills], PlayerInfo[playerid][Deaths], Ratio);
	SendClientMessage(playerid, COLOR_INFO, ShowStats);
	
	if(IsGang(playerid))
	{
	    if(IsGangOwner(playerid))
	    	Format(ShowStats, "* You're the owner of a gang called '%s' (ID: %d).", GetGangName(PlayerInfo[playerid][GangID]), PlayerInfo[playerid][GangID]);
	    else
	    	Format(ShowStats, "* You're a member of a gang called '%s' (ID: %d).", GetGangName(PlayerInfo[playerid][GangID]), PlayerInfo[playerid][GangID]);

        SendClientMessage(playerid, COLOR_INFO, ShowStats);
	}
	
	Format(ShowStats, "* Time spent on Freeroam mode: %s", ConvertTime(GetPlayerPlayTime(playerid, MODE_FREEROAM)));
	SendClientMessage(playerid, COLOR_INFO, ShowStats);
	Format(ShowStats, "* Time spent on Training mode: %s", ConvertTime(GetPlayerPlayTime(playerid, MODE_TRAINING)));
	SendClientMessage(playerid, COLOR_INFO, ShowStats);
	
	Format(ShowStats, "* Total properties purchased: %d.", PlayerInfo[playerid][TotalPropCount]);
	SendClientMessage(playerid, COLOR_INFO, ShowStats);
	Format(ShowStats, "* Total looting done: %d.", PlayerInfo[playerid][TotalLootCount]);
	SendClientMessage(playerid, COLOR_INFO, ShowStats);

	SendClientMessage(playerid, COLOR_TITLE, "**********************");
	
	#pragma unused params
	return 1;
}

//==========================//
// 		  FREEROAM	     	//
//==========================//

My_Bank(playerid, params[])
{
	Bank::OnCommand(playerid, params);
	return 1;
}

//==========================//
// 		  TRAINING	     	//
//==========================//
My_Skin(playerid, params[])
{
	new Skinid;
    if(sscanf(params, "d", Skinid)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /my skin [id]");
	if(!IsValidSkin(Skinid)) return SendClientMessage(playerid, COLOR_FALSE, "* Invalid skin.");
	PlayerInfo[playerid][SkinID] = Skinid;
	SetPlayerSkin(playerid, Skinid);
	SendClientMessage(playerid, COLOR_TRUE, "* Specified skin has been set.");
	return 1;
}

My_Ramp(playerid, params[])
{
	new sMessage[128], rid;
	if(sscanf(params, "d", rid)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /my ramp [id]");
	
	if(!PlayerInfo[playerid][Ramping])
		return SendClientMessage(playerid, COLOR_FALSE, "* You must enable ramping first, type '/ramping'.");
	
	if(rid < 0 || rid >= sizeof(ramptypes))
		return SendClientMessage(playerid, COLOR_FALSE, "* Invalid ramp (0-12). ");

	if(rid == 12 && !IsAdmin(playerid))
		return SendClientMessage(playerid, COLOR_FALSE, "* Only administrators are able to use this ramp.");

	PlayerInfo[playerid][Rampid] = rid;
	
	Format(sMessage, "* Your ramp was set to %d.", rid);
	SendClientMessage(playerid, COLOR_TRUE, sMessage);
	
	return 1;
}

