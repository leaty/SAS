#define MINI_SR_TICKETS                     Mini::SDM_CountSquad(Mini_SR_Info[SR_Attackers])*5

#define MINI_SR_SCORE_KILL              	30
#define MINI_SR_SCORE_TEAMKILL              -35
#define MINI_SR_SCORE_PLANT             	150
#define MINI_SR_SCORE_DEFUSE            	150

#define MINI_SR_MCOM_TIME                   40
#define MINI_SR_MCOM_PLANT_TIME             3
#define MINI_SR_MCOM_DEFUSE_TIME            5
#define MINI_SR_MCOM_NEUTRAL                0
#define MINI_SR_MCOM_PLANTED                1
#define MINI_SR_MCOM_DESTROYED              2

#define MINI_SR_SQUAD_COLOR                	0x0BFC00FF

#define MINI_SR_RESPAWN_TIME                10
#define MINI_SR_SPAWNPROTECT_TIME           3

/* Set in mapicons.pwn
#define MAPICON_MINI_SR_MCOM                3
*/

enum Mini_SR_Data
{
 	SR_Attackers,
 	SR_Defenders,
 	SR_Tickets,
 	SR_Score[MaxSlots],
 	SR_Respawn_Time[MaxSlots],
 	SR_MCOM,
 	SR_MCOM_Object,
 	SR_MCOM_Time,
 	SR_MCOM_Time_Action[MaxSlots],
 	bool:SR_MCOM_Action[MaxSlots],
 	
 	Float:SR_DeathX[MaxSlots],
 	Float:SR_DeathY[MaxSlots],
 	Float:SR_DeathZ[MaxSlots],
 	Float:SR_DeathXk[MaxSlots],
 	Float:SR_DeathYk[MaxSlots],
 	Float:SR_DeathZk[MaxSlots]
};

new Mini_SR_Info[Mini_SR_Data];

public Mini__SR_Process()
{
	new gText[128];
	
	if(Mini_SR_Info[SR_MCOM] == MINI_SR_MCOM_PLANTED)
	{
	    if(MINI_SR_MCOM_TIME - Mini_SR_Info[SR_MCOM_Time] < 2)
	    {
	        Mini_SR_Info[SR_MCOM] = MINI_SR_MCOM_DESTROYED;
	        Mini::SR_End();
	        return 1;
	    }
	    else
	    {
			Mini_SR_Info[SR_MCOM_Time]++;
		}
	}

	for(new i = 0; i < MaxSlots; i++)
	{
	
		if(!IsPlayerConnected(i))
	        continue;

		if(!Mini::IsPlaying(i))
		    continue;
		    
		if(Mini_SR_Info[SR_MCOM] == MINI_SR_MCOM_PLANTED)
			SetPlayerMapIcon(i, MAPICON_MINI_SR_MCOM,
			SRLocations[MiniInfo[miniLocation]][MCOM][0],
			SRLocations[MiniInfo[miniLocation]][MCOM][1],
			SRLocations[MiniInfo[miniLocation]][MCOM][2],
			1, COLOR_FALSE, MAPICON_GLOBAL);
		else
			SetPlayerMapIcon(i, MAPICON_MINI_SR_MCOM,
			SRLocations[MiniInfo[miniLocation]][MCOM][0],
			SRLocations[MiniInfo[miniLocation]][MCOM][1],
			SRLocations[MiniInfo[miniLocation]][MCOM][2],
			1, COLOR_TRUE, MAPICON_GLOBAL);

		// Plant/defuse
		if(Mini_SR_Info[SR_MCOM_Action][i] == true && IsPlayerAt(i, SRLocations[MiniInfo[miniLocation]][MCOM][0], SRLocations[MiniInfo[miniLocation]][MCOM][1], SRLocations[MiniInfo[miniLocation]][MCOM][2]))
		{
		    if(MiniInfo[miniTeam][i] == Mini_SR_Info[SR_Attackers] && Mini_SR_Info[SR_MCOM] == MINI_SR_MCOM_NEUTRAL)
			{
			    if(Mini_SR_Info[SR_MCOM_Time_Action][i] >= MINI_SR_MCOM_PLANT_TIME)
			    {
			        Mini_SR_Info[SR_MCOM_Action][i] = false;
			        Mini_SR_Info[SR_MCOM_Time_Action][i] = 0;
			        Mini_SR_Info[SR_Score][i] += MINI_SR_SCORE_PLANT;
			        Format(gText, "~g~+%d", MINI_SR_SCORE_PLANT);
			        GameTextForPlayer(i, gText, 1000, 4);
			        Mini_SR_Info[SR_MCOM] = MINI_SR_MCOM_PLANTED;
			        SendMiniMsg("Bomb has been planted.");
			        
					for(new i2 = 0; i2 < MaxSlots; i2++)
					{
   						if(!IsPlayerConnected(i2))
					        continue;

						if(!Mini::IsPlaying(i2))
						    continue;
						    
						PlayerPlaySound(i2, 1183, SRLocations[MiniInfo[miniLocation]][MCOM][0], SRLocations[MiniInfo[miniLocation]][MCOM][1], SRLocations[MiniInfo[miniLocation]][MCOM][2]);
					}
			        
					Mini::SDM_SendSquadMessage(Mini_SR_Info[SR_Defenders], "Oh shit! Get in there and defuse it!");
					Mini::SDM_SendSquadMessage(Mini_SR_Info[SR_Defenders], "We cannot loose this MCOM Station!");
					
					Mini::SDM_SendSquadMessage(Mini_SR_Info[SR_Attackers], "Good job, now don't let them defuse it!");
			    }
			    else
			    {
				    Format(gText, "~b~Planting..%d", MINI_SR_MCOM_PLANT_TIME - Mini_SR_Info[SR_MCOM_Time_Action][i]);
				    GameTextForPlayer(i, gText, 2000, 4);
				    Mini_SR_Info[SR_MCOM_Time_Action][i]++;
	       		}
			}
			else if(MiniInfo[miniTeam][i] == Mini_SR_Info[SR_Defenders] && Mini_SR_Info[SR_MCOM] == MINI_SR_MCOM_PLANTED)
			{
			    if(Mini_SR_Info[SR_MCOM_Time_Action][i] >= MINI_SR_MCOM_DEFUSE_TIME)
			    {
			        Mini_SR_Info[SR_MCOM_Action][i] = false;
			        Mini_SR_Info[SR_MCOM_Time_Action][i] = 0;
			        Mini_SR_Info[SR_Score][i] += MINI_SR_SCORE_DEFUSE;
			        Format(gText, "~g~+%d", MINI_SR_SCORE_DEFUSE);
			        GameTextForPlayer(i, gText, 1000, 4);
			        Mini_SR_Info[SR_MCOM] = MINI_SR_MCOM_NEUTRAL;
			        Mini_SR_Info[SR_MCOM_Time] = 0;
			        SendMiniMsg("Bomb defused.");
			        
  					for(new i2 = 0; i2 < MaxSlots; i2++)
					{
   						if(!IsPlayerConnected(i2))
					        continue;

						if(!Mini::IsPlaying(i2))
						    continue;

						PlayerPlaySound(i2, 1184, 0.0, 0.0, 0.0);
					}
			        
			        Mini::SDM_SendSquadMessage(Mini_SR_Info[SR_Defenders], "Excellent! Now don't let them get in there again.");
			        
			        Mini::SDM_SendSquadMessage(Mini_SR_Info[SR_Attackers], "Shit! We need to get in there again!");
			    }
			    else
			    {
				    Format(gText, "~b~Defusing..%d", MINI_SR_MCOM_DEFUSE_TIME - Mini_SR_Info[SR_MCOM_Time_Action][i]);
				    GameTextForPlayer(i, gText, 2000, 4);
				    Mini_SR_Info[SR_MCOM_Time_Action][i]++;
	       		}
			}
		}
		else
		{
		    Mini_SR_Info[SR_MCOM_Action][i] = false;
			Mini_SR_Info[SR_MCOM_Time_Action][i] = 0;
		}

		if(MiniInfo[miniDead][i] == true)
		{
			if(Mini_SR_Info[SR_Respawn_Time][i] < 1)
			{
			    MiniInfo[miniDead][i] = false;
			    SpawnPlayer(i);
			}
			else
		    {
				Format(gText, "~y~Respawning in..%d", Mini_SR_Info[SR_Respawn_Time][i]);
		 		GameTextForPlayer(i, gText, 2000, 4);
				Mini_SR_Info[SR_Respawn_Time][i]--;
			}
		}

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

		if(Now() - MiniInfo[miniLastSpawn][i] < MINI_SR_SPAWNPROTECT_TIME)
		    continue;


		//Spawn protection OFF
		MiniInfo[miniLastSpawn][i] = 0;
		Mini::SR_GiveWeapons(i);
		SetPlayerHealth(i, 100.0);
		SetPlayerArmour(i, 0.0);

		if(MiniInfo[miniHardcore] == true)
		{
			PlayerInfo[i][HC_HP] = 100.0;
			PlayerInfo[i][HC_ARM] = 0.0;
			PlayerInfo[i][Hardcore] = 1;
		}
		
	}

	return 1;
}

public Mini__SR_Prepare()
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

		Mini::SR_Init();
	    SetTimer("Mini__SR_Start", 4000, false);
		SetTimer("Mini__Countdown", 4020, false);
	}
	
	return 1;
}

public Mini__SR_Start()
{
	MiniInfo[miniProcess] = true;

	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerConnected(i))
	        continue;

		if(!Mini::IsPlaying(i))
		    continue;

		if(MiniInfo[miniTeam][i] == Mini_SR_Info[SR_Defenders])
		{

		    ClearPlayerChat(i);

			SpawnPlayer(i);

   			SetPlayerTime(		i, 	Mini_SDM_Weathers[MiniInfo[miniWeather]][0], 00);
			SetPlayerWeather(	i,  Mini_SDM_Weathers[MiniInfo[miniWeather]][1]);


			MiniInfo[miniLastSpawn][i] = Now();

			TogglePlayerControllable(i, false);

			SendClientMessage(i, MINI_COLOR_INFO, "Rebels have been spotted not far away from here, they will try to attack our MCOM Stations.");
			SendClientMessage(i, MINI_COLOR_INFO, "These are U.S Military Communication boxes with expensive satelite dishes.");
			SendClientMessage(i, MINI_COLOR_INFO, "It's up to us to defend these, do not fail.");

			SendClientMessage(i, MINI_SDM_SQUAD_COLOR, "");

		}
		else if(MiniInfo[miniTeam][i] == Mini_SR_Info[SR_Attackers])
		{

		    ClearPlayerChat(i);

			SpawnPlayer(i);


			SetPlayerTime(		i, 	Mini_SDM_Weathers[MiniInfo[miniWeather]][0], 00);
			SetPlayerWeather(	i,  Mini_SDM_Weathers[MiniInfo[miniWeather]][1]);


			MiniInfo[miniLastSpawn][i] = Now();

			TogglePlayerControllable(i, false);

			SendClientMessage(i, MINI_COLOR_INFO, "We have to cut these MCOM's out so the rest of the Rebellion can attack with surprise and avoid reinforcements.");
			SendClientMessage(i, MINI_COLOR_INFO, "These are U.S Military Communication boxes with expensive satelite dishes.");
			SendClientMessage(i, MINI_COLOR_INFO, "Failing this mission, will cause a team in the Rebellion a great loss as they're already advancing towards a target.");

			SendClientMessage(i, MINI_SDM_SQUAD_COLOR, "");

		}
		else
		    Mini::DropPlayer(i, "bugged");

	}

	Mini::SDM_SendSquadMessage(Mini_SR_Info[SR_Defenders], "Alright guys, defend the MCOM Station at all costs, show no mercy.");
	Mini::SDM_SendSquadMessage(Mini_SR_Info[SR_Defenders], "Use *yourtexthere to communicate.");
	Mini::SDM_SendSquadMessage(Mini_SR_Info[SR_Defenders], "Set up defensive positions, move out!");

	Mini::SDM_SendSquadMessage(Mini_SR_Info[SR_Attackers], "Alright guys, lets get that bomb in place.");
	Mini::SDM_SendSquadMessage(Mini_SR_Info[SR_Attackers], "Use *yourtexthere to communicate.");
	Mini::SDM_SendSquadMessage(Mini_SR_Info[SR_Attackers], "Stick to the plan, move out!");

	return 1;
}

public Mini__SR_OnSignup(playerid)
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

public Mini__SR_OnSpawn(playerid)
{
	if(MiniInfo[miniDead][playerid] == true)
	{
	    Mini::SR_DeathCam(playerid);
	    return 1;
	}
	
	MiniInfo[miniLastSpawn][playerid] = Now();

	new DefendSide = SRLocations[MiniInfo[miniLocation]][DefSide];

	if(DefendSide == 1)
	{
	    if(MiniInfo[miniTeam][playerid] == Mini_SR_Info[SR_Defenders])
	    {
	    	SetPlayerPos(playerid, SDMLocations[MiniInfo[miniLocation]][Pos1][0], SDMLocations[MiniInfo[miniLocation]][Pos1][1], SDMLocations[MiniInfo[miniLocation]][Pos1][2]);
		    SetPlayerFacingAngle(playerid, SDMLocations[MiniInfo[miniLocation]][Pos1][3]);
		}
		else
		{
		    SetPlayerPos(playerid, SDMLocations[MiniInfo[miniLocation]][Pos2][0], SDMLocations[MiniInfo[miniLocation]][Pos2][1], SDMLocations[MiniInfo[miniLocation]][Pos2][2]);
		    SetPlayerFacingAngle(playerid, SDMLocations[MiniInfo[miniLocation]][Pos2][3]);
		}
	}
	else
	{
 		if(MiniInfo[miniTeam][playerid] == Mini_SR_Info[SR_Attackers])
	    {
	    	SetPlayerPos(playerid, SDMLocations[MiniInfo[miniLocation]][Pos1][0], SDMLocations[MiniInfo[miniLocation]][Pos1][1], SDMLocations[MiniInfo[miniLocation]][Pos1][2]);
		    SetPlayerFacingAngle(playerid, SDMLocations[MiniInfo[miniLocation]][Pos1][3]);
		}
		else
		{
		    SetPlayerPos(playerid, SDMLocations[MiniInfo[miniLocation]][Pos2][0], SDMLocations[MiniInfo[miniLocation]][Pos2][1], SDMLocations[MiniInfo[miniLocation]][Pos2][2]);
		    SetPlayerFacingAngle(playerid, SDMLocations[MiniInfo[miniLocation]][Pos2][3]);
		}
	}

	SetPlayerWorldBounds(playerid, SDMLocations[MiniInfo[miniLocation]][Boundries][0], SDMLocations[MiniInfo[miniLocation]][Boundries][1], SDMLocations[MiniInfo[miniLocation]][Boundries][2], SDMLocations[MiniInfo[miniLocation]][Boundries][3]);

	SetPlayerHealth(playerid, 100.0); // higher will bug the hardcore and kill the player
	SetPlayerArmour(playerid, 10000000.0); // instead of health
	
	return 1;
}

public Mini__SR_OnDeath(playerid, killerid, reason)
{
    new gText[128];

	if(MiniInfo[miniHardcore] == true)
		Hardcore::Reset(playerid);

	if(killerid != INVALID_PLAYER_ID)
	{
	    if(MiniInfo[miniTeam][playerid] == MiniInfo[miniTeam][killerid])
	    {
    		Mini_SR_Info[SR_Score][killerid] += MINI_SR_SCORE_TEAMKILL;

	        Format(gText, "~g~+%d", MINI_SR_SCORE_TEAMKILL);
	        GameTextForPlayer(killerid, gText, 1000, 4);
	 	}
	 	else
	 	{
			MiniInfo[miniKills][killerid]++;
	    	Mini_SR_Info[SR_Score][killerid] += MINI_SR_SCORE_KILL;

	        Format(gText, "~g~+%d", MINI_SR_SCORE_KILL);
	        GameTextForPlayer(killerid, gText, 1000, 4);
		}
	}
	
    if(MiniInfo[miniTeam][playerid] == MINI_TEAM_ONE)
		MiniInfo[miniTeamScore2]++;
    else
        MiniInfo[miniTeamScore1]++;
        
	if(MiniInfo[miniTeam][playerid] == Mini_SR_Info[SR_Attackers])
	    Mini_SR_Info[SR_Tickets]--;

    if(Mini_SR_Info[SR_Tickets] < 1)
        Mini::SR_End();
        
   	SetPlayerWorldBounds(playerid, 20000.0000, -20000.0000, 20000.0000, -20000.0000);

	MiniInfo[miniDead][playerid] = true;
	Mini_SR_Info[SR_Respawn_Time][playerid] = MINI_SR_RESPAWN_TIME;

	new Float:X, Float:Y, Float:Z;

	GetPlayerPos(playerid, X, Y, Z);
	Mini_SR_Info[SR_DeathX][playerid] = X;
	Mini_SR_Info[SR_DeathY][playerid] = Y;
	Mini_SR_Info[SR_DeathZ][playerid] = Z;
	GetPlayerPos(killerid, X, Y, Z);
	Mini_SR_Info[SR_DeathXk][playerid] = X;
	Mini_SR_Info[SR_DeathYk][playerid] = Y;
	Mini_SR_Info[SR_DeathZk][playerid] = Z;
	
	Mini::SR_DeathCam(playerid);
	
	return 1;
}

public Mini__SR_OnText(playerid, const text[])
{
	new sMessage[256];

	Format(sMessage, "%s: %s", PlayerName(playerid), text[1]);
	Mini::SDM_SendSquadMessage(MiniInfo[miniTeam][playerid], sMessage);
	return 1;
}

public Mini__SR_OnFire(playerid)
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

public Mini__SR_OnKey(playerid, newkeys, oldkeys)
{


	if(PRESSED(KEY_CROUCH))
	{
		Mini_SR_Info[SR_MCOM_Action][playerid] = true;
	}
	else if(RELEASED(KEY_CROUCH))
	{
	    Mini_SR_Info[SR_MCOM_Action][playerid] = false;
	    Mini_SR_Info[SR_MCOM_Time_Action][playerid] = 0;
	}
	
	return 1;
}

public Mini__SR_UpdateMarker(playerid)
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


public Mini__SR_UpdateTag(playerid)
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

public Mini__SR_OnReset()
{
	for(new i = 0; i < MaxSlots; i++)
	{
		if(!IsPlayerConnected(i))
	        continue;

		if(!Mini::IsPlaying(i))
		    continue;

		PlayerPlaySound(i, 1184, 0.0, 0.0, 0.0);
		RemovePlayerMapIcon(i, MAPICON_MINI_SR_MCOM);
	}
	

	DestroyDynamicObject(Mini_SR_Info[SR_MCOM_Object]);
	return 1;
}


Mini__SR_Init()
{
	new team = random(2);
	
	if(team == 1)
	{
	    Mini_SR_Info[SR_Attackers] = MINI_TEAM_ONE;
	    Mini_SR_Info[SR_Defenders] = MINI_TEAM_TWO;
	}
	else
	{
	    Mini_SR_Info[SR_Attackers] = MINI_TEAM_TWO;
	    Mini_SR_Info[SR_Defenders] = MINI_TEAM_ONE;
	}
	
    Mini_SR_Info[SR_Tickets] = MINI_SR_TICKETS;
	Mini_SR_Info[SR_MCOM] = MINI_SR_MCOM_NEUTRAL;
	Mini_SR_Info[SR_MCOM_Time] = 0;

	for(new i = 0; i < MaxSlots; i++)
	{
	    Mini_SR_Info[SR_Score][i] = 0;
	    Mini_SR_Info[SR_MCOM_Time_Action] = 0;
        Mini_SR_Info[SR_MCOM_Action] = false;
 	}

	Mini_SR_Info[SR_MCOM_Object] = CreateDynamicObject(964, SRLocations[MiniInfo[miniLocation]][MCOM][0], SRLocations[MiniInfo[miniLocation]][MCOM][1], SRLocations[MiniInfo[miniLocation]][MCOM][2], SRLocations[MiniInfo[miniLocation]][MCOM][3], SRLocations[MiniInfo[miniLocation]][MCOM][4], SRLocations[MiniInfo[miniLocation]][MCOM][5], WORLD_MINI);
}

Mini__SR_DeathCam(playerid)
{
	SetPlayerVirtualWorld(playerid, WORLD_MINI);
	SetPlayerPos(playerid, Mini_SR_Info[SR_DeathX][playerid], Mini_SR_Info[SR_DeathY][playerid], Mini_SR_Info[SR_DeathZ][playerid]-100.0);
	SetPlayerCameraPos(playerid, Mini_SR_Info[SR_DeathX][playerid], Mini_SR_Info[SR_DeathY][playerid], Mini_SR_Info[SR_DeathZ][playerid]);
	SetPlayerCameraLookAt(playerid, Mini_SR_Info[SR_DeathXk][playerid], Mini_SR_Info[SR_DeathYk][playerid], Mini_SR_Info[SR_DeathZk][playerid]);
}

Mini__SR_GiveWeapons(playerid)
{
	GivePlayerWeapon(playerid, 16, 1); // 1 grenade
 	GivePlayerWeapon(playerid, 4, 1);
	GivePlayerWeapon(playerid, 31, 1000000);
	GivePlayerWeapon(playerid, 34, 30);
}

Mini__SR_End()
{
    new sMessage[256];
    new MostScore1 = Mini::SR_MostScoreID(Mini_SR_Info[SR_Attackers]), MostScore2 = Mini::SR_MostScoreID(Mini_SR_Info[SR_Defenders]);
	//new Float:X, Float:Y, Float:Z;
	
	if(Mini_SR_Info[SR_MCOM] == MINI_SR_MCOM_DESTROYED)
	{
		Mini::SDM_SendSquadMessage(Mini_SR_Info[SR_Attackers], "Nailed em! We destroyed their MCOM station, returning home, Alpha out.");
		Mini::SDM_SendSquadMessage(Mini_SR_Info[SR_Defenders], "Damnit! The MCOM station was destroyed, returning to base, Bravo out.");
		SendNews("MCOM Station was destroyed, the attackers won the Squad Rush Minigame!");
		Format(sMessage, "%s earned the Ace Pin for the most score: %d", PlayerName(MostScore1), Mini_SR_Info[SR_Score][MostScore1]);
		SendMiniMsg(sMessage);
	}
	else if(Mini_SR_Info[SR_MCOM] != MINI_SR_MCOM_DESTROYED)
	{
		Mini::SDM_SendSquadMessage(Mini_SR_Info[SR_Defenders], "Nailed em! We destroyed their MCOM station, returning home, Alpha out.");
		Mini::SDM_SendSquadMessage(Mini_SR_Info[SR_Attackers], "Damnit! The MCOM was destroyed, returning to base, Bravo out.");
		SendNews("MCOM Station still stands, the defenders won the Squad Rush Minigame!");
		Format(sMessage, "%s earned the Ace Pin for the most score: %d", PlayerName(MostScore2), Mini_SR_Info[SR_Score][MostScore2]);
		SendMiniMsg(sMessage);
	}
	
	for(new i = 0; i < MaxSlots; i++)
	{
		if(!IsPlayerConnected(i))
	        continue;

		if(!Mini::IsPlaying(i))
		    continue;
		    
		Format(sMessage, "Your personal score: %d", Mini_SR_Info[SR_Score][i]);
		SendClientMessage(i, MINI_COLOR_INFO, sMessage);
		
		//GetPlayerPos(i, X, Y, Z);
		//PlayerPlaySound(i, 1159, X, Y, Z);
		PlayerPlaySound(i, 1159, 0.0, 0.0, 0.0);
  	}

	Mini::Reset();
	return 1;
}

Mini__SR_MostScoreID(team)
{
	new ScoreCount, pid;

	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerConnected(i))
	        continue;

		if(!Mini::IsPlaying(i))
		    continue;

		if(MiniInfo[miniTeam][i] != team)
		    continue;

		if(Mini_SR_Info[SR_Score][i] < ScoreCount)
		    continue;

        ScoreCount = Mini_SR_Info[SR_Score][i];
        pid = i;
	}

	return pid;
}

#include miniSRdialogs.pwn

