#define CallMiniPrepare(%1);			new sFunct[128]; Format(sFunct, "Mini__%s_%s", MiniNames[MiniInfo[miniGame]], #%1);
#define CallMini(%1,					CallLocalFunction(sFunct, %1,
						

#define MINI_STATUS_NONE                0
#define MINI_STATUS_SETUP               1
#define MINI_STATUS_SIGNUP              2
#define MINI_STATUS_RUNNING             3

#define MINI_GAME_SDM                   0

#define MINI_TEAM_ONE                   1
#define MINI_TEAM_TWO                   2

#define MINI_COUNTDOWN                  5

#define MINI_COLOR_TITLE                0xC000FFFF
#define MINI_COLOR_INFO                 0xFF8000FF

enum MiniData
{

	miniStatus,
	miniGame,
	miniScore,
	
	miniLocation,
	miniWeather,
	
	miniTeamScore1,
	miniTeamScore2,
	
	miniTeam[MaxSlots],
	bool:miniPlayers[MaxSlots],
	miniKills[MaxSlots],
	minipScore[MaxSlots],
	
	bool:miniDead[MaxSlots],
	
	miniLastSpawn[MaxSlots],
	miniLastDeath[MaxSlots],
	
	miniCountdown,
	
	bool:miniRespawn,
	bool:miniHardcore,
	bool:miniProcess

};

new MiniInfo[MiniData];

new MiniStartText[11][30] =
{
    {"Kill em all!!"},
    {"Blast em!!"},
    {"Humiliate em!!"},
    {"Drop em!!"},
    {"Ez em!"},
    {"Go get em!"},
    {"Waste em all!!"},
    {"Smash em!!"},
    {"Smoke em!"},
    {"RAGE!!"},
    {"Show them!"}
};

// All minigame's names, also handles all calls such as Mini::[insertmininame]_call
new MiniNames[2][128] =
{
	{	"SDM"	},
	{   "SR"    }
};

new MiniRealNames[2][128] =
{
	{   "Squad Deathmatch"  },
	{   "Squad Rush"        }
};

forward Mini__Countdown();

forward Mini__SDM_Process();
forward Mini__SDM_Prepare();
forward Mini__SDM_Start();
forward Mini__SDM_OnSignup(playerid);
forward Mini__SDM_OnSpawn(playerid);
forward Mini__SDM_OnDeath(playerid, killerid, reason);
forward Mini__SDM_OnText(playerid, const text[]);
forward Mini__SDM_OnFire(playerid);
forward Mini__SDM_OnKey(playerid, newkeys, oldkeys);
forward Mini__SDM_UpdateMarker(playerid);
forward Mini__SDM_UpdateTag(playerid);
forward Mini__SDM_OnDialog(playerid, dialogid, response, listitem, inputtext[]);
forward Mini__SDM_OnReset();

forward Mini__SR_Process();
forward Mini__SR_Prepare();
forward Mini__SR_Start();
forward Mini__SR_OnSignup(playerid);
forward Mini__SR_OnSpawn(playerid);
forward Mini__SR_OnDeath(playerid, killerid, reason);
forward Mini__SR_OnText(playerid, const text[]);
forward Mini__SR_OnFire(playerid);
forward Mini__SR_OnKey(playerid, newkeys, oldkeys);
forward Mini__SR_UpdateMarker(playerid);
forward Mini__SR_UpdateTag(playerid);
forward Mini__SR_OnDialog(playerid, dialogid, response, listitem, inputtext[]);
forward Mini__SR_OnReset();


Mini__Init()
{
	Mini::Reset();
	Mini::LoadObjects();
	return 1;
}

// Runs every second if a minigame is running && miniProcess == true
Mini__Process()
{
	if(!Mini::IsRunning())
		return 0;

	if(MiniInfo[miniProcess] == false)
		return 0;

	CallMiniPrepare("Process");
	return CallMini("", "");
}

Mini__OnDisconnect(playerid, reason)
{
	Mini::DropPlayer(playerid, "disconnected");

	if(Mini::CheckPlayers())
	    Mini::End("Not enough players");

	#pragma unused reason
	return 1;
}

Mini__OnSignup(playerid)
{
	CallMiniPrepare("OnSignup");
	return CallMini("d", playerid);
}

Mini__OnDialog(playerid, dialogid, response, listitem, inputtext[])
{

	if(dialogid == DIALOG_MINI_GAMES)
	{
	    MiniInfo[miniGame] = listitem;
	    
		if(!response)
		{
	    	Mini::Reset();
    		return 1;
		}
	}
	
	
	CallMiniPrepare("OnDialog");
	
	if(strlen(inputtext) < 1)
    	return CallMini("dddds", playerid, dialogid, response, listitem, " ");

	return CallMini("dddds", playerid, dialogid, response, listitem, inputtext);
}

Mini__OnRespawn(playerid)
{
	CallMiniPrepare("OnSpawn");
	return CallMini("d", playerid);
}

Mini__OnDeath(playerid, killerid, reason)
{
	CallMiniPrepare("OnDeath");
	return CallMini("ddd", playerid, killerid, reason);
}

Mini__OnText(playerid, const text[])
{
    if(!Mini::IsPlaying(playerid))
        return 0;
        
	CallMiniPrepare("OnText");
	return CallMini("ds", playerid, text);
}

Mini__OnFire(playerid)
{
	CallMiniPrepare("OnFire");
	return CallMini("d", playerid);
}

Mini__OnKey(playerid, newkeys, oldkeys)
{
	CallMiniPrepare("OnKey");
	return CallMini("ddd", playerid, newkeys, oldkeys);
}

Mini__UpdateMarker(playerid)
{
	CallMiniPrepare("UpdateMarker");
	return CallMini("d", playerid);
}


Mini__UpdateTag(playerid)
{
	CallMiniPrepare("UpdateTag");
	return CallMini("d", playerid);
}

Mini__OnReset()
{
	CallMiniPrepare("OnReset");
	return CallMini("", "");
}

#include miniCommands.pwn
#include miniFunctions.pwn
#include miniObjects.pwn
#include SDM/miniSDM.pwn
#include SR/miniSR.pwn


