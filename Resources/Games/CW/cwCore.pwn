#define CW_TEAMS                2
#define CW_TEAM_ONE             0
#define CW_TEAM_TWO             1

#define CW_STATUS_NONE		    	0
#define CW_STATUS_INVITED       	1
#define CW_STATUS_ACCEPTED      	2
#define CW_STATUS_RUNNING       	3

#define CW_END_REASON_DENY      	0
#define CW_END_REASON_ADMIN	    	1
#define CW_END_REASON_PLAYERS   	2
#define CW_END_REASON_ORGANIZERS    3

#define CW_MODE_CW              	0
#define CW_MODE_TCW             	1
#define CW_MODE_SDM             	2

#define CWTCW_TYPE_ROUNDS       	0
#define CWTCW_TYPE_SCORE        	1
#define CWTCW_MAX_ROUNDS        	5
#define CWTCW_MAX_SCORE         	30

#define CWSDM_TYPE_HARDCORE     	0
#define CWSDM_TYPE_NONHARDCORE  	1
#define CWSDM_MAX_ROUNDS            5
#define CWSDM_MAX_WEATHER           4
#define CWSDM_WEATHER_D_RAIN         0
#define CWSDM_WEATHER_D_FOG          1
#define CWSDM_WEATHER_DARK          2
#define CWSDM_WEATHER_SUN           3

#define CW_MAX_WEAPONS          	5
#define CW_WEAPON_NONE          	1
#define CW_WEAPON_CLASS_RW      	0
#define CW_WEAPON_CLASS_WW      	1
#define CW_WEAPON_CLASS_CUSTOM  	2

#define CW_COUNTDOWN        		5
#define CW_COLOR_INFO 				0xFF8000FF

#define CW_NL_STEP_MODE         	0
#define CW_NL_STEP_NAME         	1
#define CW_NL_STEP_POS1      		2
#define CW_NL_STEP_POS2         	3
#define CW_NL_STEP_B_XMAX       	4
#define CW_NL_STEP_B_XMIN       	5
#define CW_NL_STEP_B_YMAX       	6
#define CW_NL_STEP_B_YMIN       	7

forward CWTCW_Start();
forward SDM_Start();
forward CW_Countdown();
forward CW_DropInvite();

new CWStartText[15][30] =
{
    {"Kill em all!!"},
    {"Blast em!!"},
    {"Humiliate em!!"},
    {"Win this shit!"},
    {"Work as a team!"},
    {"Drop em all!!"},
    {"Lets show em!"},
    {"Ez em!"},
    {"They aint shit!"},
    {"Go get em!"},
    {"Waste em all!!"},
    {"Smash em!!"},
    {"Smoke em!"},
    {"RAGE!!"},
    {"Show them!"}
};

enum CWData
{
	cwStatus,
	cwMode,
	cwType,
	cwWeather,
	cwTime,
	cwLocation,
	cwMaxRounds,
	cwMaxScore,
	cwCountdown,
	
	cwInviter,
	cwAccepter,
	cwPlayers[MaxSlots],
	cwLeavecount,
	cwFrozen,
	
	cwWeapons[CW_MAX_WEAPONS],
	cwSpectators[MaxSlots],
	
	Text:cwDraw
};

enum CWTeamData
{
	GangID,
	
	Kills,
	Deaths,

	Wins,
	Losses,
	Dead[MaxSlots]
};

enum CWNewLocationData
{
	IsCreating,
	Step,
	
	cwMode,
	LocName[128],
	
	Float:Pos1[4],
	Float:Pos2[4],
	Float:Boundries[4]
};

new CWInfo[CWData];
new CWTeamInfo[CW_TEAMS][CWTeamData];
new CWLeavers[MaxSlots][MAX_PLAYER_NAME];

new CW_ModeList[256];
new CW_WeaponClasses[128], CW_WeaponList[300];
new CWTCW_TypeList[128];
new CWSDM_TypeList[128];

new CWNLInfo[CWNewLocationData];

new CWModeNames[][30] = {
	{"an official clanwar"},
 	{"a practice clanwar"},
 	{"a squad - based deathmatch"}
};

CW__Init()
{
	MySQL::ReOrderTable(Table_sdm, "id");

	CW::Reset();
	CW::nlReset();
	CW::LoadObjects();
	
	CW_ModeList = "Clanwar\r\nTraining Clanwar\r\nSquad Deathmatch";
	
	CW_WeaponClasses = "Running Weapons (Sawnoff, Uzi)\r\nWalking Weapons (Deagle, Sniper, M4, Combat Shotgun)\r\nCustom";
 	CW_WeaponList = "None\nChainsaw\nSilenced 9mm\nDesert Eagle\nShotgun\nSawn-off Shotgun\nCombat Shotgun\nMicro SMG (Uzi)\nMP5\nAK-47\nM4 Carbine\nTec-9\nCountry Rifle\nSniper Rifle\nRocket Launcher\nFlamethrower\nMinigun";

    CWTCW_TypeList = "Rounds (respawn OFF | most rounds)\r\nScore (respawn ON | most kills)";
    CWSDM_TypeList = "Hardcore (5x damage)\r\nNormal";

	return 1;
}

CW__Exit()
{
	CW::Reset();
	return 1;
}

CW__OnStart(playerid)
{
	if(!IsGang(playerid))
		return 0;
	
	if(CW::IsBack(playerid))
	{
	    CWInfo[cwPlayers][playerid] = 1;
		CWInfo[cwLeavecount]--;
	    
		if(CWInfo[cwLeavecount] < 1)
		{
			CW::UnfreezeWar();
			SendCWMsg("All players have rejoined, the war will now continue.");

			if(CWInfo[cwMode] == CW_MODE_CW || CWInfo[cwMode] == CW_MODE_TCW)
			    CWTCW_Spawn();
			else if(CWInfo[cwMode] == CW_MODE_SDM)
			    SDM_Spawn();
		}
		return 1;
	}
	return 0;
}

CW__OnDisconnect(playerid, reason)
{
	if(CW::IsRunning())
	{
	    new sMessage[256], pName[MAX_PLAYER_NAME];
	    
	    if(CW::IsPlaying(playerid))
		{
	    	if(CWInfo[cwFrozen] == 0)
	    	{
		    	Format(sMessage, "The clanwar has been temporarily paused due to %s leaving the server.", PlayerName(playerid));
	    		SendCWMsg(sMessage);
		    	SendCWMsg("All players will automatically respawn when the player(s) comes back.");
				SendCWMsg("If not, the organizers of this war are able to use '/cw respawn' or '/cw end'");
				CW::FreezeWar();
			}
			else
			{
				Format(sMessage, "%s has left the war (%s).", PlayerName(playerid), aDisconnectNames[reason]);
				SendCWMsg(sMessage);
			}
			GetPlayerName(playerid, pName, sizeof(pName));
			CWLeavers[playerid] = pName;
			CWInfo[cwLeavecount]++;
			CWInfo[cwPlayers][playerid] = 0;
			
			if(CW::CountPlayers(CWTeamInfo[CW_TEAM_ONE][GangID]) < 1 && CW::CountPlayers(CWTeamInfo[CW_TEAM_TWO][GangID]) < 1)
			{
			    Format(sMessage, "The war between Gang '%s' and '%s' has been terminated: No players.");
			    SendNews(sMessage);

			    CW::Reset();
			}
		}

		if(CW::IsSpectating(playerid))
			CWInfo[cwSpectators][playerid] = 0;
	}
	
	#pragma unused playerid, reason
	return 1;
}

CW__OnRespawn(playerid)
{
	if(!CW::IsRunning())
	    return 0;
	    
	if(CWInfo[cwMode] == CW_MODE_CW) CW_OnRespawn(playerid);
	else if(CWInfo[cwMode] == CW_MODE_TCW) TCW_OnRespawn(playerid);
	else if(CWInfo[cwMode] == CW_MODE_SDM) SDM_OnRespawn(playerid);
		
	return 1;
}

CW__OnDeath(playerid, killerid, reason)
{
	if(!CW::IsRunning())
	    return 0;
	    
	if(CWInfo[cwMode] == CW_MODE_CW) CW_OnDeath(playerid, killerid, reason);
	else if(CWInfo[cwMode] == CW_MODE_TCW) TCW_OnDeath(playerid, killerid, reason);
	else if(CWInfo[cwMode] == CW_MODE_SDM) SDM_OnDeath(playerid, killerid, reason);

	return 1;
}

CW__OnFire(playerid)
{
	if(CWInfo[cwMode] == CW_MODE_SDM)
	{
	    for(new i = 0; i < MaxSlots; i++)
	    {
	        if(!CW::IsPlaying(i))
	            continue;
	        
	        if(PlayerInfo[playerid][GangID] != PlayerInfo[i][GangID])
	    		SetPlayerMarkerForPlayer(i, playerid, (0xF90013FF & 0xF90013FF) );

		}
	}
	return 1;
}

CW__UpdateMarker(playerid)
{
	if(CWInfo[cwMode] == CW_MODE_SDM)
	{
	    for(new i = 0; i < MaxSlots; i++)
	    {
	        if(!CW::IsPlaying(i))
	            continue;
	            
            if(PlayerInfo[playerid][GangID] == PlayerInfo[i][GangID])
    			SetPlayerMarkerForPlayer(i, playerid, 0x20FF00FF);
			else
				SetPlayerMarkerForPlayer(i, playerid, (0xF90013FF & 0xFFFFFF00) );
		}
	}
}


CW__UpdateTag(playerid)
{
	if(CWInfo[cwMode] == CW_MODE_SDM)
	{
	    for(new i = 0; i < MaxSlots; i++)
	    {
	        if(!CW::IsPlaying(i))
	            continue;

            if(PlayerInfo[playerid][GangID] == PlayerInfo[i][GangID])
    			ShowPlayerNameTagForPlayer(i, playerid, true);
			else
                ShowPlayerNameTagForPlayer(i, playerid, false);
		}
	}
}

/*CW__OnText(playerid, const text[])
{
	#pragma unused playerid, text
	return 1;
}*/

#include cwObjects.pwn
#include cwFunctions.pwn
#include cwDialogs.pwn
#include cwCommands.pwn
#include Commands/cwManagement.pwn
#include Commands/cwAdmin.pwn
#include Commands/cwPlayer.pwn
#include Modes/CWTCW.pwn
#include Modes/SDM.pwn

