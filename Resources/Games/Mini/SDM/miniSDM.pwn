#define MINI_SDM_SPAWNPROTECT_TIME          5

#define MINI_SDM_MIN_SCORE                  5
#define MINI_SDM_MAX_SCORE                  20

#define MINI_SDM_SQUAD_COLOR                0x0BFC00FF

new Mini_SDM_Weathers[4][2] =
{

//    	time     weather
	{ 	  0, 	    16       },
 	{ 	  0, 	    9        },
 	{ 	  0, 	    31       },
 	{ 	  12, 	    5        }

};

public Mini__SDM_Process()
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerConnected(i))
	        continue;

		if(!Mini::IsPlaying(i))
		    continue;
		    
		if(MiniInfo[miniLastSpawn][i] == 0)
		    continue;
		    

		// Spawn protection ON
  		ResetPlayerWeapons(i);
		SetPlayerHealth(i, 100.0); // higher will bug the hardcore and kill the player
		SetPlayerArmour(i, 10000000.0); // instead of health
		
		if(MiniInfo[miniHardcore] == true)
		{
			PlayerInfo[i][HC_HP] = 100.0;
			PlayerInfo[i][HC_ARM] = 0.0;
			PlayerInfo[i][Hardcore] = 0;
		}
		    
		if(Now() - MiniInfo[miniLastSpawn][i] < MINI_SDM_SPAWNPROTECT_TIME)
		    continue;
		    

		//Spawn protection OFF
		MiniInfo[miniLastSpawn][i] = 0;
		Mini::SDM_GiveWeapons(i);
		SetPlayerHealth(i, 100.0);
		SetPlayerArmour(i, 0.0);

		if(MiniInfo[miniHardcore] == true)
		{
			PlayerInfo[i][HC_HP] = 100.0;
			PlayerInfo[i][HC_ARM] = 0.0;
			PlayerInfo[i][Hardcore] = 1;
		}
		
		
	}
}

public Mini__SDM_Prepare()
{
	if(Mini::CheckPlayers())
		Mini::End("Not enough players");
	else
	{
		MiniInfo[miniStatus] = MINI_STATUS_RUNNING;
 		MiniInfo[miniCountdown] = MINI_COUNTDOWN;
 		
 		MiniInfo[miniWeather] = random(sizeof(Mini_SDM_Weathers));
 		
		for(new i = 0; i < MaxSlots; i++)
		{
		    if(!IsPlayerConnected(i))
		        continue;
		        
			if(!Mini::IsPlaying(i))
			    continue;
			    
		    TogglePlayerControllable(i, false);
    		SetPlayerVirtualWorld(i, WORLD_MINI);
		}
		
		SendMiniMsg("Everyone has been frozen to prevent any bugs from occuring.");

	    SetTimer("Mini__SDM_Start", 4000, false);
		SetTimer("Mini__Countdown", 4020, false);
	}
	
	return 1;
}

public Mini__SDM_Start()
{

	MiniInfo[miniProcess] = true;

	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerConnected(i))
	        continue;
	        
		if(!Mini::IsPlaying(i))
		    continue;

		if(MiniInfo[miniTeam][i] == MINI_TEAM_ONE)
		{
		
		    ClearPlayerChat(i);
			
			SpawnPlayer(i);

			
   			SetPlayerTime(		i, 	Mini_SDM_Weathers[MiniInfo[miniWeather]][0], 00);
			SetPlayerWeather(	i,  Mini_SDM_Weathers[MiniInfo[miniWeather]][1]);

			
			MiniInfo[miniLastSpawn][i] = Now();

			TogglePlayerControllable(i, false);
			
			SendClientMessage(i, MINI_COLOR_INFO, "Once again, there's an invasion of terrorists in USA...");
			SendClientMessage(i, MINI_COLOR_INFO, "U.S Marines was sent in to evacuate all the civilians. They succeeded.");
			SendClientMessage(i, MINI_COLOR_INFO, "Now it's up to the U.S Special Forces to clean this land from terrorists...");

			SendClientMessage(i, MINI_SDM_SQUAD_COLOR, "");
			
		}
		else if(MiniInfo[miniTeam][i] == MINI_TEAM_TWO)
		{
		
		    ClearPlayerChat(i);
			
			SpawnPlayer(i);
			
			
			SetPlayerTime(		i, 	Mini_SDM_Weathers[MiniInfo[miniWeather]][0], 00);
			SetPlayerWeather(	i,  Mini_SDM_Weathers[MiniInfo[miniWeather]][1]);
			
			
			MiniInfo[miniLastSpawn][i] = Now();

			TogglePlayerControllable(i, false);
			
			SendClientMessage(i, MINI_COLOR_INFO, "Once again, there's an invasion of terrorists in USA...");
			SendClientMessage(i, MINI_COLOR_INFO, "U.S Marines was sent in to evacuate all the civilians. They succeeded.");
			SendClientMessage(i, MINI_COLOR_INFO, "Now it's up to the U.S Special Forces to clean this land from terrorists...");

			SendClientMessage(i, MINI_SDM_SQUAD_COLOR, "");

		}
		else
		    Mini::DropPlayer(i, "bugged");

	}
	
	Mini::SDM_SendSquadMessage(MINI_TEAM_ONE, "Alright guys, this is it.");
	Mini::SDM_SendSquadMessage(MINI_TEAM_ONE, "Use *yourtexthere to communicate.");
	Mini::SDM_SendSquadMessage(MINI_TEAM_ONE, "Stick together and remember to check your corners.");
	Mini::SDM_SendSquadMessage(MINI_TEAM_ONE, "Lets move out!");
	
	Mini::SDM_SendSquadMessage(MINI_TEAM_TWO, "Alright guys, this is it.");
	Mini::SDM_SendSquadMessage(MINI_TEAM_TWO, "Use *yourtexthere to communicate.");
	Mini::SDM_SendSquadMessage(MINI_TEAM_TWO, "Stick together and remember to check your corners.");
	Mini::SDM_SendSquadMessage(MINI_TEAM_TWO, "Lets move out!");
}

public Mini__SDM_OnSignup(playerid)
{
	new sMessage[256];

	MiniInfo[miniPlayers][playerid] = true;

	if(Mini::IsSigningUp())
	{
		if(Mini::SDM_CountSquad(MINI_TEAM_ONE) > Mini::SDM_CountSquad(MINI_TEAM_TWO))
		    MiniInfo[miniTeam][playerid] = MINI_TEAM_TWO;
		else
		    MiniInfo[miniTeam][playerid] = MINI_TEAM_ONE;
		    
		Format(sMessage, "%s has signed up for %s!", PlayerName(playerid), MiniNames[MiniInfo[miniGame]]);
		SendNews(sMessage);
	}
	else SendClientMessage(playerid, COLOR_FALSE, "* You cannot use this right now.");
	
	return 1;
}

public Mini__SDM_OnSpawn(playerid)
{
	/*if(MiniInfo[miniRespawn] == false)
		return 0;*/

	MiniInfo[miniLastSpawn][playerid] = Now();
		
    if(MiniInfo[miniTeam][playerid] == MINI_TEAM_ONE)
    {
    	SetPlayerPos(playerid, SDMLocations[MiniInfo[miniLocation]][Pos1][0], SDMLocations[MiniInfo[miniLocation]][Pos1][1], SDMLocations[MiniInfo[miniLocation]][Pos1][2]);
	    SetPlayerFacingAngle(playerid, SDMLocations[MiniInfo[miniLocation]][Pos1][3]);
	}
	else
	{
	    SetPlayerPos(playerid, SDMLocations[MiniInfo[miniLocation]][Pos2][0], SDMLocations[MiniInfo[miniLocation]][Pos2][1], SDMLocations[MiniInfo[miniLocation]][Pos2][2]);
	    SetPlayerFacingAngle(playerid, SDMLocations[MiniInfo[miniLocation]][Pos2][3]);
	}
	
	SetPlayerWorldBounds(playerid, SDMLocations[MiniInfo[miniLocation]][Boundries][0], SDMLocations[MiniInfo[miniLocation]][Boundries][1], SDMLocations[MiniInfo[miniLocation]][Boundries][2], SDMLocations[MiniInfo[miniLocation]][Boundries][3]);
	
	SetPlayerHealth(playerid, 100.0); // higher will bug the hardcore and kill the player
	SetPlayerArmour(playerid, 10000000.0); // instead of health

	return 1;
}

public Mini__SDM_OnDeath(playerid, killerid, reason)
{
	if(MiniInfo[miniHardcore] == true)
		Hardcore::Reset(playerid);
	
	if(MiniInfo[miniRespawn] == false)
	{
	
		if(killerid != INVALID_PLAYER_ID)
		{
			MiniInfo[miniKills][killerid]++;
			Mini::DropPlayer(playerid, "KIA");
		}
		else
		{
		    Mini::DropPlayer(playerid, "died");
	    }
	    
		if(Mini::CheckPlayers())
			Mini::SDM_End();
			
	}
	else if(MiniInfo[miniRespawn] == true)
	{
		if(killerid != INVALID_PLAYER_ID)
			MiniInfo[miniKills][killerid]++;
	
	    if(MiniInfo[miniTeam][playerid] == MINI_TEAM_ONE)
			MiniInfo[miniTeamScore2]++;
	    else
            MiniInfo[miniTeamScore1]++;
	
	    if(Mini::CheckScore())
	        Mini::SDM_End();
	}
	
	SetPlayerWorldBounds(playerid, 20000.0000, -20000.0000, 20000.0000, -20000.0000);
	
	return 1;
}

public Mini__SDM_OnText(playerid, const text[])
{
	new sMessage[256];
	
	Format(sMessage, "%s: %s", PlayerName(playerid), text[1]);
	Mini::SDM_SendSquadMessage(MiniInfo[miniTeam][playerid], sMessage);
	return 1;
}

public Mini__SDM_OnFire(playerid)
{

    for(new i = 0; i < MaxSlots; i++)
    {
 		if(!IsPlayerConnected(i))
            continue;

        if(!Mini::IsPlaying(i))
            continue;

        if(MiniInfo[miniTeam][i] != MiniInfo[miniTeam][playerid])
    		SetPlayerMarkerForPlayer(i, playerid, (0xF90013FF & 0xF90013FF) );

	}
	
	return 1;
}

public Mini__SDM_OnKey(playerid, newkeys, oldkeys)
{
	return 0;
}

public Mini__SDM_UpdateMarker(playerid)
{

    for(new i = 0; i < MaxSlots; i++)
    {
        if(!IsPlayerConnected(i))
            continue;

        if(!Mini::IsPlaying(i))
            continue;

        if(MiniInfo[miniTeam][i] == MiniInfo[miniTeam][playerid])
			SetPlayerMarkerForPlayer(i, playerid, 0x20FF00FF);
		else
			SetPlayerMarkerForPlayer(i, playerid, (0xF90013FF & 0xFFFFFF00) );
	}

	return 1;
}


public Mini__SDM_UpdateTag(playerid)
{

    for(new i = 0; i < MaxSlots; i++)
    {
 		if(!IsPlayerConnected(i))
            continue;

        if(!Mini::IsPlaying(i))
            continue;

        if(MiniInfo[miniTeam][i] == MiniInfo[miniTeam][playerid])
			ShowPlayerNameTagForPlayer(i, playerid, true);
		else
            ShowPlayerNameTagForPlayer(i, playerid, false);
	}

	return 1;
}

public Mini__SDM_OnReset()
{
	return 0;
}


Mini__SDM_GiveWeapons(playerid)
{
	GivePlayerWeapon(playerid, 16, 1); // 1 grenade
 	GivePlayerWeapon(playerid, 4, 1);
	GivePlayerWeapon(playerid, 31, 1000000);
	GivePlayerWeapon(playerid, 34, 10);
}

/*Mini__SDM_PreparePlayerSpawn(playerid, team)
{
    ResetPlayerWeapons(playerid);
    
    if(team == MINI_TEAM_ONE)
    {
	    SetSpawnInfo(playerid, team, PlayerInfo[playerid][SkinID],
		SDMLocations[MiniInfo[miniLocation]][Pos1][0], SDMLocations[MiniInfo[miniLocation]][Pos1][1], SDMLocations[MiniInfo[miniLocation]][Pos1][2], SDMLocations[MiniInfo[miniLocation]][Pos1][3],
		4, 1,
		31, 1000000,
		34, 10);
	}
	else
	{
 		SetSpawnInfo(playerid, team, PlayerInfo[playerid][SkinID],
		SDMLocations[MiniInfo[miniLocation]][Pos2][0], SDMLocations[MiniInfo[miniLocation]][Pos2][1], SDMLocations[MiniInfo[miniLocation]][Pos2][2], SDMLocations[MiniInfo[miniLocation]][Pos2][3],
		4, 1,
		31, 1000000,
		34, 10);
	}
	
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 0.0);

	Mini::SDM_GiveWeapons(playerid);

  	if(MiniInfo[miniHardcore] == true)
    {
		PlayerInfo[playerid][HC_HP] = 100.0;
		PlayerInfo[playerid][HC_ARM] = 0.0;
		PlayerInfo[playerid][Hardcore] = 1;
    }
	
	return 1;
}*/

Mini__SDM_End()
{
    new sMessage[256];
    new MostKills1 = Mini::SDM_MostKillsID(MINI_TEAM_ONE), MostKills2 = Mini::SDM_MostKillsID(MINI_TEAM_TWO);

	if(MiniInfo[miniRespawn] == false)
	{
	    if(Mini::SDM_CountSquad(MINI_TEAM_ONE) > Mini::SDM_CountSquad(MINI_TEAM_TWO))
	    {
			Mini::SDM_SendSquadMessage(MINI_TEAM_ONE, "We won!");
			Mini::SDM_SendSquadMessage(MINI_TEAM_TWO, "Ahh crap, we lost..");
			SendNews("Team 1 just won the SDM Minigame!");
			Format(sMessage, "Most kills by %s: %d", PlayerName(MostKills1), MiniInfo[miniKills][MostKills1]);
			SendMiniMsg(sMessage);
		}
		else if(Mini::SDM_CountSquad(MINI_TEAM_TWO) > Mini::SDM_CountSquad(MINI_TEAM_ONE))
		{
			Mini::SDM_SendSquadMessage(MINI_TEAM_TWO, "We won!");
			Mini::SDM_SendSquadMessage(MINI_TEAM_ONE, "Ahh crap, we lost..");
			SendNews("Team 2 just won the SDM Minigame!");
			Format(sMessage, "Most kills by %s: %d", PlayerName(MostKills2), MiniInfo[miniKills][MostKills2]);
			SendClientMessageToAll(MINI_COLOR_INFO, sMessage);
		}
		else
		{
	        SendNews("The SDM Minigame resulted in a tie!");
		}
	}
	else if(MiniInfo[miniRespawn] == true)
	{
	    new Score1 = MiniInfo[miniTeamScore1], Score2 = MiniInfo[miniTeamScore2];

		if(Score1 > Score2)
		{
			Mini::SDM_SendSquadMessage(MINI_TEAM_ONE, "We won!");
			Mini::SDM_SendSquadMessage(MINI_TEAM_TWO, "Ahh crap, we lost..");
			
			Format(sMessage, "Team 1 just won the SDM Minigame with a final kill-score of %d-%d!", Score1, Score2);
			SendNews(sMessage);
			Format(sMessage, "Most kills by %s: %d", PlayerName(MostKills1), MiniInfo[miniKills][MostKills1]);
			SendMiniMsg(sMessage);
		}
		else if(Score2 > Score1)
		{
			Mini::SDM_SendSquadMessage(MINI_TEAM_TWO, "We won!");
			Mini::SDM_SendSquadMessage(MINI_TEAM_ONE, "Ahh crap, we lost..");
			
			Format(sMessage, "Team 2 just won the SDM Minigame with a final kill-score of %d-%d!", Score2, Score1);
			SendNews(sMessage);
			Format(sMessage, "Most kills by %s: %d", PlayerName(MostKills2), MiniInfo[miniKills][MostKills2]);
			SendClientMessageToAll(MINI_COLOR_INFO, sMessage);
		}
		else
		{
		    SendNews("The SDM Minigame resulted in a tie!");
		}
	}
	
	Mini::Reset();
	return 1;
}

Mini__SDM_CountSquad(team)
{
	new iCount;
	
	for(new i = 0; i < MaxSlots; i++)
	{
		if(!IsPlayerConnected(i))
		    continue;
		    
		if(!Mini::IsPlaying(i))
		    continue;
		    
		if(MiniInfo[miniTeam][i] != team)
		    continue;
		    
  		iCount++;
	}
	
	return iCount;
}

Mini__SDM_MostKillsID(team)
{
	new KillCount, pid;

	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerConnected(i))
	        continue;
	        
		if(!Mini::IsPlaying(i))
		    continue;
		    
		if(MiniInfo[miniTeam][i] != team)
		    continue;
		    
		if(MiniInfo[miniKills][i] < KillCount)
		    continue;

        KillCount = MiniInfo[miniKills][i];
        pid = i;
	}
	
	return pid;
}

Mini__SDM_SendSquadMessage(team, const string[])
{
	new sMessage[256];
	Format(sMessage, "(SQUAD) %s", string);

	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!Mini::IsPlaying(i))
	        continue;

		if(MiniInfo[miniTeam][i] != team)
		    continue;

		SendClientMessage(i, MINI_SDM_SQUAD_COLOR, sMessage);
	}

	return 1;
}

#include miniSDMdialogs.pwn

