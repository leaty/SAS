/*****************************************************************************************************
*
* 	This file is part of the SAS San Andreas: Multiplayer gamemode source code.
*
*   While none of this source code is free nor available for purchase by this time,
*   developers are permitted to take out small parts IF they have permission from the source code holder.
*
* 	In a nutshell; you are not allowed to copy more than a single method from our source-code for your own purposes.
*   However, larger peices, components or handlers originating from our source, can be discussed.
*   For any of the above actions, you MUST contact the source code holder.
*
*
*	SAS has to be compiled with pawno.
*  	The compiler itself is available on SVN.
*
*
*   Information:
*   Functionality:
*   Original Author:
*
*
*   @copyright (c) SAS 2010
*
******************************************************************************************************/

//Note: File includes are at the end of the file

#define MAX_GANGS               	50
#define MAX_GANG_NAME               5 			+1
#define MAX_GANG_INVITES

#define GANG_LEVEL_NEUTRAL          4 // Any level
#define GANG_LEVEL_GANG             3 // Member or Owner
#define GANG_LEVEL_NONE          	0 // Not in any gang
#define GANG_LEVEL_MEMBER        	1 // Member
#define GANG_LEVEL_OWNER         	2 // Owner

#define GANG_DENIED_NOGANG          0
#define GANG_DENIED_ADMINLEVEL   	1
#define GANG_DENIED_GANGLEVEL       2

#define GANG_COLOR_INFO         	0xA948CDFF
#define GANG_COLOR_MSG          	0x73A8FFFF



//0x73A8BDFF

enum GangData
{
	GangName[MAX_GANG_NAME],
	GangOwner[MAX_PLAYER_NAME],
	
	ColorID,
	Exists,
	Members,

	Kills,
	Deaths,

	Wins,
	Losses
}

new GangInfo[MAX_GANGS+10][GangData];
new GangCount;

Gang__Init()
{
	for(new i = 1; i < MAX_GANGS + 1; i++)
	{
		ResetGangInfo(i);
	}
	
	Gang::LoadGangs();

	return 1;
}

Gang__Exit()
{
    Gang::UpdateGangs();

	return 1;
}

Gang__OnDisconnect(playerid, reason)
{
	new sMessage[128];
	new gangid = PlayerInfo[playerid][GangID];

	Format(sMessage, "%s has left the gang (%s).", PlayerName(playerid), aDisconnectNames[reason]);
	SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);

	return 1;
}

Gang__OnStart(playerid)
{
	if(strlen(PlayerInfo[playerid][GangName]) < 1)
	    return 0;
	    
	new sMessage[128];

	new gangid = GetGangID(PlayerInfo[playerid][GangName]);
	
	if(!Gang::DBExistsGang(PlayerInfo[playerid][GangName]))
	{
		Gang::Leave(playerid);
	    SendClientMessage(playerid, GANG_COLOR_INFO, "[Gang] Your gang does not exist anymore, it has been deleted and you've automatically left the gang.");
	}
	else
	{
	    Gang::Join(playerid, gangid);
	    PlayerInfo[playerid][GangLevel] = GANG_LEVEL_MEMBER;
		Format(sMessage, "%s has joined the gang.", PlayerName(playerid));
		SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);
		
 		if(strcmp(PlayerName(playerid), GangInfo[gangid][GangOwner], false, MAX_PLAYER_NAME) == 0)
	   		PlayerInfo[playerid][GangLevel] = GANG_LEVEL_OWNER;
   	}
	   
	return 1;
}

Gang__OnRespawn(playerid)
{
    #pragma unused playerid
	return 1;
}

Gang__OnDeath(playerid, killerid, reason)
{
	if(killerid == INVALID_PLAYER_ID)
	    return 0;
	    
    if(!IsGang(killerid))
		return 0;
		
	if(PlayerInfo[playerid][GangID] == PlayerInfo[killerid][GangID])
	    return 0;
		
	new gangid = PlayerInfo[playerid][GangID];
	new kgangid = PlayerInfo[killerid][GangID];
		
	GangInfo[gangid][Deaths]++;
	GangInfo[kgangid][Kills]++;
	
	#pragma unused reason
	return 1;
}

Gang__OnText(playerid, const text[])
{
	if(!IsGang(playerid))
	    return 0;

	new sMessage[256];
	new gangid = PlayerInfo[playerid][GangID];
	
	Format(sMessage, "%s: %s", PlayerName(playerid), text[1]);
	SendGangMsg(gangid, GANG_COLOR_MSG, sMessage);
	return 1;
}


#include gangFunctions.pwn
#include gangDialogs.pwn
#include gangCommands.pwn
#include Commands/Admin/gangManagement.pwn
#include Commands/Admin/gangAdmin.pwn
#include Commands/Admin/gangMod.pwn
#include Commands/Player/gangOwner.pwn
#include Commands/Player/gangMember.pwn
#include Commands/Player/gangNone.pwn
#include Commands/Player/gangNeutral.pwn

