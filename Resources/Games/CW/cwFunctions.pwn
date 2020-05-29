public CW_Countdown()
{
	new gText[50], iSound;
	new Float:X, Float:Y, Float:Z;
	
	// Start
	if(CWInfo[cwCountdown] == 0)
	{
		iSound = 1057;
	    Format(gText, "~r~%s", CWStartText[random(15)]);
	    for(new i = 0; i < MaxSlots; i++)
	    {
	        if(!CW::IsInvolved(i))
	            continue;

         	GetPlayerPos(i, X, Y, Z);
			PlayerPlaySound(i, iSound, X, Y, Z);
			GameTextForPlayer(i, gText, 1500, 6);
			
			if(CW::IsPlaying(i))
			{
			    if(CWInfo[cwMode] == CW_MODE_SDM && CWInfo[cwType] == CWSDM_TYPE_HARDCORE)
			    {
					PlayerInfo[i][HC_HP] = 100.0;
    				PlayerInfo[i][HC_ARM] = 0.0;
					PlayerInfo[i][Hardcore] = 1;
			    }
			    
			    TogglePlayerControllable(i, true);
			}
	    }

		CWInfo[cwCountdown] = CW_COUNTDOWN;
	}
	// Countdown
	else
	{
		iSound = 1058;
	    Format(gText, "~g~%d", CWInfo[cwCountdown]);
 		for(new i = 0; i < MaxSlots; i++)
	    {
	        if(!CW::IsInvolved(i))
	            continue;

         	GetPlayerPos(i, X, Y, Z);
			PlayerPlaySound(i, iSound, X, Y, Z);
			GameTextForPlayer(i, gText, 1100, 6);
	    }
	    
	    CWInfo[cwCountdown]--;
	    SetTimer("CW_Countdown", 1000, false);
	}
	
	return 1;
}

public CW_DropInvite()
{
	if(CWInfo[cwStatus] != CW_STATUS_INVITED)
	    return 0;

	new gangid1 = CWTeamInfo[CW_TEAM_ONE][GangID];
	new gangid2 = CWTeamInfo[CW_TEAM_TWO][GangID];

	SendGangMsg(gangid1, GANG_COLOR_INFO, "Invitation time exceeded, they did not respond.");
	SendGangMsg(gangid2, GANG_COLOR_INFO, "Invitation time exceeded, your gang did not respond.");

	CW::Reset();

	return 1;
}

CW__Prepare()
{
	if(!CW::IsActive())
	    return 0;

	new gangid1 = CWTeamInfo[CW_TEAM_ONE][GangID];
	new gangid2 = CWTeamInfo[CW_TEAM_TWO][GangID];
	new sMessage[256], sMode[50];

	if(CWInfo[cwMode] == CW_MODE_CW)
		sMode = "An official clanwar";
 	else if(CWInfo[cwMode] == CW_MODE_TCW)
	    sMode = "A practice clanwar";
	else if(CWInfo[cwMode] == CW_MODE_SDM)
	    sMode = "A squad - based deathmatch";

	Format(sMessage, "%s between '%s' and '%s' will start in 5 seconds.", sMode, GangInfo[gangid1][GangName], GangInfo[gangid2][GangName]);
	SendNews(sMessage);
	
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!CW::IsPlaying(i))
	        continue;

		CWInfo[cwSpectators][i] = 0;
		PlayerInfo[i][Spectating] = false;
		TogglePlayerSpectating(i, false);
		TogglePlayerControllable(i, false);
		ResetPlayerWeapons(i);
	}
	
	SendCWMsg("Everyone has been frozen to prevent any bugs to occur in this war.");

	CWInfo[cwCountdown] = CW_COUNTDOWN;

	if(CWInfo[cwMode] == CW_MODE_CW || CWInfo[cwMode] == CW_MODE_TCW)
		SetTimer("CWTCW_Start", 5000, false);
 	else if(CWInfo[cwMode] == CW_MODE_SDM)
 	{
 	    // Time and weather
 	    CWInfo[cwWeather] = random(CWSDM_MAX_WEATHER*2); // *2 so sunny has a chance
 	    
 	    if(CWInfo[cwWeather] == CWSDM_WEATHER_D_RAIN)
 	    {
 	        CWInfo[cwTime] = 0;
 	        CWInfo[cwWeather] = 16;
		}
		else if(CWInfo[cwWeather] == CWSDM_WEATHER_D_FOG)
		{
		    CWInfo[cwTime] = 0;
		    CWInfo[cwWeather] = 9;
		}
		else if(CWInfo[cwWeather] == CWSDM_WEATHER_DARK)
		{
		    CWInfo[cwTime] = 0;
		    CWInfo[cwWeather] = 31;
		}
		else
		{
		    CWInfo[cwTime] = 12;
		    CWInfo[cwWeather] = 5;
 	    }
 	    
		SetTimer("SDM_Start", 5000, false);
	}
	return 1;
}

CW__CheckScore()
{
	new MaxScore = CWInfo[cwMaxScore];
	new Score1 = CWTeamInfo[CW_TEAM_ONE][Kills];
	new Score2 = CWTeamInfo[CW_TEAM_TWO][Kills];
	new gangid1 = CWTeamInfo[CW_TEAM_ONE][GangID];
	new gangid2 = CWTeamInfo[CW_TEAM_TWO][GangID];
	
	if(Score1 >= MaxScore || Score2 >= MaxScore)
	{
		new sMessage[256];
	    if(Score1 > Score2)
	    {
   			Format(sMessage, "Your gang won against '%s'! Congratulations!", GangInfo[gangid2][GangName]);
			SendGangMsg(gangid1, CW_COLOR_INFO, sMessage);
			Format(sMessage, "Your gang lost against '%s'... Try again!", GangInfo[gangid1][GangName]);
			SendGangMsg(gangid2, CW_COLOR_INFO, sMessage);

			Format(sMessage, "Gang '%s' has won the war against '%s' with a final kill-score of %d - %d!", GangInfo[gangid1][GangName], GangInfo[gangid2][GangName], Score1, Score2);

   			if(CWInfo[cwMode] == CW_MODE_CW)
	    	{
				GangInfo[gangid1][Wins]++;
				GangInfo[gangid2][Losses]++;
			}
		}
		else if(Score2 > Score1)
		{
			Format(sMessage, "Your gang won against '%s'! Congratulations!", GangInfo[gangid1][GangName]);
			SendGangMsg(gangid2, CW_COLOR_INFO, sMessage);
			Format(sMessage, "Your gang lost against '%s'... Try again!", GangInfo[gangid2][GangName]);
			SendGangMsg(gangid1, CW_COLOR_INFO, sMessage);
			
		    Format(sMessage, "Gang '%s' has won the war against '%s' with a final kill-score of %d - %d!", GangInfo[gangid2][GangName], GangInfo[gangid1][GangName], Score2, Score1);

   			if(CWInfo[cwMode] == CW_MODE_CW)
	    	{
				GangInfo[gangid2][Wins]++;
				GangInfo[gangid1][Losses]++;
			}
		}
		else
  		{
  			Format(sMessage, "The war between Gang '%s' and '%s' has ended in a draw!", GangInfo[gangid1][GangName], GangInfo[gangid2][GangName]);
		}
	    SendNews(sMessage);
	    CW::Reset();
	    return 0;
	}
	return 1;
}

CW__CheckPlayers()
{
	new pCount1, pCount2;
	new gangid1 = CWTeamInfo[CW_TEAM_ONE][GangID];
	new gangid2 = CWTeamInfo[CW_TEAM_TWO][GangID];
	
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsGang(i))
			continue;
			
	    if(!CW::IsPlaying(i))
			continue;
			
		if(PlayerInfo[i][GangID] == gangid1 && CWTeamInfo[CW_TEAM_ONE][Dead][i] == 0)
		    pCount1++;
		else if(PlayerInfo[i][GangID] == gangid2 && CWTeamInfo[CW_TEAM_TWO][Dead][i] == 0)
		    pCount2++;
	}
	
	CW::ShowTextDraws();
	
	if(pCount1 < 1)
	{
	    CW::EndRound(gangid2, gangid1);
	    return 0;
	}
	else if(pCount2 < 1)
	{
	    CW::EndRound(gangid1, gangid2);
	    return 0;
	}
	
	return 1;
}

CW__EndRound(winner, looser)
{
	new sMessage[256];
	new gangid1 = CWTeamInfo[CW_TEAM_ONE][GangID];
	new gangid2 = CWTeamInfo[CW_TEAM_TWO][GangID];
	
	CWInfo[cwMaxRounds]--;
	
	if(winner == CWTeamInfo[CW_TEAM_ONE][GangID])
	{
		    CWTeamInfo[CW_TEAM_ONE][Wins]++;
			CWTeamInfo[CW_TEAM_TWO][Losses]++;
	}
	if(winner == CWTeamInfo[CW_TEAM_TWO][GangID])
	{
		    CWTeamInfo[CW_TEAM_TWO][Wins]++;
			CWTeamInfo[CW_TEAM_ONE][Losses]++;
	}
	
	new Wins1 = CWTeamInfo[CW_TEAM_ONE][Wins];
	new Wins2 = CWTeamInfo[CW_TEAM_TWO][Wins];
	
	if(CWInfo[cwMaxRounds] < 1)
	{
	    if(Wins1 > Wins2)
	    {
   			Format(sMessage, "Your gang won against '%s'! Congratulations!", GangInfo[gangid2][GangName]);
			SendGangMsg(gangid1, GANG_COLOR_INFO, sMessage);
			Format(sMessage, "Your gang lost against '%s'... Try again!", GangInfo[gangid1][GangName]);
			SendGangMsg(gangid2, GANG_COLOR_INFO, sMessage);

			Format(sMessage, "Gang '%s' has won the war against '%s' with a final round-score of %d - %d!", GangInfo[gangid1][GangName], GangInfo[gangid2][GangName], Wins1, Wins2);

   			if(CWInfo[cwMode] == CW_MODE_CW)
	    	{
				GangInfo[gangid1][Wins]++;
				GangInfo[gangid2][Losses]++;
			}
		}
		else if(Wins2 > Wins1)
		{
			Format(sMessage, "Your gang won against '%s'! Congratulations!", GangInfo[gangid1][GangName]);
			SendGangMsg(gangid2, GANG_COLOR_INFO, sMessage);
			Format(sMessage, "Your gang lost against '%s'... Try again!", GangInfo[gangid2][GangName]);
			SendGangMsg(gangid1, GANG_COLOR_INFO, sMessage);

			Format(sMessage, "Gang '%s' has won the war against '%s' with a final round-score of %d - %d!", GangInfo[gangid2][GangName], GangInfo[gangid1][GangName], Wins2, Wins1);

   			if(CWInfo[cwMode] == CW_MODE_CW)
	    	{
				GangInfo[gangid2][Wins]++;
				GangInfo[gangid1][Losses]++;
			}
		}
		else
  		{
  			Format(sMessage, "The war between Gang '%s' and '%s' has ended in a draw!", GangInfo[gangid1][GangName], GangInfo[gangid2][GangName]);
		}
		
		SendNews(sMessage);
		SetTimer("CW_EndMatch", 500, false);
	}
	else
	{
		SendGangMsg(winner, GANG_COLOR_INFO, "Your gang won this round, keep going!");
		SendGangMsg(looser, GANG_COLOR_INFO, "Your gang lost this round.. Get back up on your feet!");
		
	    Format(sMessage, "Gang '%s' won this round. %d rounds left!", GangInfo[winner][GangName], CWInfo[cwMaxRounds]);
	    SendCWMsg(sMessage);
	    
	  	for(new i = 0; i < MaxSlots; i++)
		{
		    if(CW::IsPlaying(i))
		    {
		        CWTeamInfo[CW_TEAM_ONE][Dead][i] = 0;
		        CWTeamInfo[CW_TEAM_TWO][Dead][i] = 0;

				if(CW::IsSpectating(i))
					CW::StopWatch(i);
					
				SpawnPlayer(i);
			}
		}

		CW::ShowTextDraws();
		SetTimer("CW_NewRound", 100, false);
 	}
 	return 1;
}

forward CW_NewRound();
public CW_NewRound()
{
	if(CWInfo[cwMode] == CW_MODE_CW || CWInfo[cwMode] == CW_MODE_TCW)
		CWTCW_Spawn();
	else if(CWInfo[cwMode] == CW_MODE_SDM)
		SDM_Spawn();
}

forward CW_EndMatch();
public CW_EndMatch()
{
	CW::Reset();
}

CW__ShowTextDraws()
{
	CW::DestroyTextDraws();

	new sDraw[100];
	
	if(CWInfo[cwMode] == CW_MODE_SDM || CWInfo[cwType] == CWTCW_TYPE_ROUNDS)
	    Format(sDraw, "~g~%s ~r~vs ~g~%s ~n~~w~  Score: ~r~%d ~w~- ~r~%d", GangInfo[CWTeamInfo[CW_TEAM_ONE][GangID]][GangName], GangInfo[CWTeamInfo[CW_TEAM_TWO][GangID]][GangName], CWTeamInfo[CW_TEAM_ONE][Wins], CWTeamInfo[CW_TEAM_TWO][Wins]);
	else if(CWInfo[cwType] == CWTCW_TYPE_SCORE)
	    Format(sDraw, "~g~- %s ~r~vs ~g~%s -~n~~w~  Score: ~r~%d ~w~- ~r~%d", GangInfo[CWTeamInfo[CW_TEAM_ONE][GangID]][GangName], GangInfo[CWTeamInfo[CW_TEAM_TWO][GangID]][GangName], CWTeamInfo[CW_TEAM_ONE][Kills], CWTeamInfo[CW_TEAM_TWO][Kills]);

	CWInfo[cwDraw] = TextDrawCreate(482, 311, sDraw);
	TextDrawBackgroundColor(CWInfo[cwDraw], 255);
	TextDrawFont(CWInfo[cwDraw], 2);
	TextDrawLetterSize(CWInfo[cwDraw], 0.33, 1.5);
	TextDrawColor(CWInfo[cwDraw], -1);
	TextDrawSetOutline(CWInfo[cwDraw], 1);
	TextDrawSetProportional(CWInfo[cwDraw], 1);
	
	for(new i = 0; i < MaxSlots; i++)
	{
		if(IsTraining(i))
			TextDrawShowForPlayer(i, CWInfo[cwDraw]);
	}
	return 1;
}

CW__DestroyTextDraws()
{
	TextDrawDestroy(CWInfo[cwDraw]);
	
	for(new i = 0; i < MaxSlots; i++)
	    TextDrawHideForPlayer(i, CWInfo[cwDraw]);

	return 1;
}

CW__IsRunning()
{
	if(CWInfo[cwStatus] == CW_STATUS_RUNNING)
	    return 1;

	return 0;
}

CW__IsActive()
{
	if(CWInfo[cwStatus] == CW_STATUS_INVITED || CWInfo[cwStatus] == CW_STATUS_ACCEPTED || CWInfo[cwStatus] == CW_STATUS_RUNNING)
	    return 1;
	    
	return 0;
}

CW__IsInvited(gangid)
{
	if(CWTeamInfo[CW_TEAM_TWO][GangID] == gangid)
	    return 1;

	return 0;
}
/*
CW__HasInvited(gangid)
{
	if(CWTeamInfo[CW_TEAM_ONE][GangID] == gangid)
	    return 1;

	return 0;
}*/

CW__IsPlaying(playerid)
{
	if(!IsGang(playerid))
	    return 0;

	if(CWInfo[cwPlayers][playerid])
	    return 1;
	    
	return 0;
}

CW__IsInvolved(playerid)
{
	if(CW::IsPlaying(playerid) || CW::IsSpectating(playerid))
	    return 1;
	    
	return 0;
}

CW__IsSpectating(playerid)
{
	if(CWInfo[cwSpectators][playerid])
	    return 1;
	    
	return 0;
}

CW__IsOrganizer(playerid)
{
	if(CWInfo[cwAccepter] == playerid || CWInfo[cwInviter] == playerid)
	    return 1;
	    
	return 0;
}
/*
CW__IsGang(playerid)
{
	if(!IsGang(playerid))
	    return 0;

	if(!CW::IsActive())
	    return 0;
	    
	new gangid = PlayerInfo[playerid][GangID];
	new gangid1 = CWTeamInfo[CW_TEAM_ONE][GangID];
	new gangid2 = CWTeamInfo[CW_TEAM_ONE][GangID];

	if(gangid == gangid1 || gangid == gangid2)
	    return 1;
	    
	return 0;
}*/

CW__IsBack(playerid)
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(strlen(CWLeavers[i]) < 1)
	        continue;
	        
	    if(strcmp(PlayerName(playerid), CWLeavers[i], true, MAX_PLAYER_NAME) == 0)
	        return 1;
	}
	
	return 0;
}

CW__InviteGang(playerid, invgangid)
{
	new sMessage[256], sType[100], sLocation[100], gangid;
	
	gangid = PlayerInfo[playerid][GangID];
	
    CWTeamInfo[CW_TEAM_ONE][GangID] = gangid;
	CWTeamInfo[CW_TEAM_TWO][GangID] = invgangid;
	    
	if(CWInfo[cwMode] == CW_MODE_CW || CWInfo[cwMode] == CW_MODE_TCW)
	{
	    if(CWInfo[cwType] == CWTCW_TYPE_ROUNDS)
	        Format(sType, "Rounds: %d", CWInfo[cwMaxRounds]);
     	if(CWInfo[cwType] == CWTCW_TYPE_SCORE)
	        Format(sType, "Max Score: %d", CWInfo[cwMaxScore]);
	        
		Format(sLocation, "%s", CWLocations[CWInfo[cwLocation]][LocName]);
	}
	else if(CWInfo[cwMode] == CW_MODE_SDM)
	{
 		if(CWInfo[cwType] == CWSDM_TYPE_HARDCORE)
   			sType = "Type: Hardcore";
     	if(CWInfo[cwType] == CWSDM_TYPE_NONHARDCORE)
	        sType = "Type: Normal";
	        
	    Format(sLocation, "%s", SDMLocations[CWInfo[cwLocation]][LocName]);
	}
	
	Format(sMessage, "Your gang has been invited to %s by Gang %s (ID: %d).", CWModeNames[CWInfo[cwMode]], GangInfo[gangid][GangName], gangid);
	SendGangMsg(invgangid, GANG_COLOR_INFO, sMessage);
	SendGangMsg(invgangid, GANG_COLOR_INFO, "Accept this invitation using '/cw accept'. The invitation will be withdrawn in 15 seconds.");
	SendGangMsg(invgangid, GANG_COLOR_INFO, "When you accept, you will receive a window to choose your line-up.");
	Format(sMessage, "%s has invited Gang '%s' to %s.", PlayerName(playerid), GangInfo[invgangid][GangName], CWModeNames[CWInfo[cwMode]]);
	SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);
 	Format(sMessage, "Participants: %d", CW::CountPlayers(gangid));
 	SendGangMsg(invgangid, GANG_COLOR_INFO, sMessage);
	Format(sMessage, "Weapons: %s", CW::GetWeaponString());
	SendGangMsg(invgangid, GANG_COLOR_INFO, sMessage);
	SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);
	Format(sMessage, "Location: %s", sLocation);
	SendGangMsg(invgangid, GANG_COLOR_INFO, sMessage);
	SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);
	Format(sMessage, "%s", sType);
	SendGangMsg(invgangid, GANG_COLOR_INFO, sMessage);
	SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);
	
	SetTimer("CW_DropInvite", 15000, false);

	return 1;
}

CW__Watch(playerid)
{
	CWInfo[cwSpectators][playerid] = 1;
    PlayerInfo[playerid][Spectating] = true;
    PlayerInfo[playerid][SpecID] = 0;
    
    SendClientMessage(playerid, COLOR_TITLE, "* You're now spectating the clan war.");
    SendClientMessage(playerid, COLOR_INFO,  "* Press sprint (space) to switch between players.");
    
    CW::SpecNextPlayer(playerid);
	return 1;
}

CW__StopWatch(playerid)
{
	CWInfo[cwSpectators][playerid] = 0;
    PlayerInfo[playerid][Spectating] = false;
    PlayerInfo[playerid][SpecID] = 0;
    
    TogglePlayerSpectating(playerid, false);
    
    return 1;
}

CW__SpecNextPlayer(playerid)
{
	for(new i = PlayerInfo[playerid][SpecID] + 1; i < MaxSlots; i++)
	{
		if(!IsPlayerConnected(i))
			continue;

		if(!CW::IsPlaying(i))
		    continue;

		if(i == playerid)
		    continue;

        CW::SpecPlayer(playerid, i);
		return 1; // All done, stop right here!
	}

	// Oh, it failed? :O

	for(new i = 0; i < MaxSlots; i++)
	{
		if(!IsPlayerConnected(i))
			continue;

		if(!CW::IsPlaying(i))
		    continue;

		if(i == playerid)
		    continue;

		CW::SpecPlayer(playerid, i);
		return 1;
	}
	
	return 0;
}

CW__SpecPlayer(playerid, specid)
{
    PlayerInfo[playerid][Spectating] = true;
    PlayerInfo[playerid][SpecID] = specid;
    TogglePlayerSpectating(playerid, true);
    PlayerSpectatePlayer(playerid, specid);
    return 1;
}

CW__GivePlayerWeapons(playerid)
{
	for(new i = 0; i < CW_MAX_WEAPONS; i++)
	{
	    if(CWInfo[cwWeapons][i] == CW_WEAPON_NONE || CWInfo[cwWeapons][i] == 0)
	        continue;
	        
		GivePlayerWeapon(playerid, CWInfo[cwWeapons][i], 100000);
	}
	
	return 1;
}

CW__GetPickedWeapon(listitem)
{
	switch(listitem)
	{
		case 0: { return CW_WEAPON_NONE; } // None
		case 1: { return 9; } // Chainsaw
    	case 2: { return 23; } // Silenced 9mm
    	case 3: { return 24; } // Desert Eagle
    	case 4: { return 25; } // Shotgun
    	case 5: { return 26; } // Sawnoff Shotgun
    	case 6: { return 27; } // Combat Shotgun
    	case 7: { return 28; } // Micro SMG
	    case 8: { return 29; } // MP5
	    case 9: { return 30; } // AK-47
	    case 10: { return 31; } // M4
	    case 11: { return 32; } // Tec-9
	    case 12: { return 33; } // Country Rifle
	    case 13: { return 34; } // Sniper Rifle
	    case 14: { return 35; } // Rocket Launcher
	    case 15: { return 37; } // Flamethrower
	    case 16: { return 38; } // Minigun
	}
	return CW_WEAPON_NONE;
}

CW__GetWeaponString()
{
	new sWeapons[400];
	new sWep[50];
	new wCount;
	
	for(new i = 0; i < CW_MAX_WEAPONS; i++)
	{
	    if(CWInfo[cwWeapons][i] == 0)
			continue;

		if(CWInfo[cwWeapons][i] == CW_WEAPON_NONE)
		    continue;

        GetWeaponName(CWInfo[cwWeapons][i], sWep, sizeof(sWep));

		if(wCount == 0)
			Format(sWeapons, "%s", sWep);
		else
		    Format(sWeapons, "%s\r\n%s", sWeapons, sWep);
		    
		wCount++;
	}
	
	return sWeapons;
}

CW__CountWeapons()
{
	new iCount;
	
	for(new i = 0; i < CW_MAX_WEAPONS; i++)
 	{
 		if(CWInfo[cwWeapons][i] != 0)
			iCount++;
	}

	return iCount;
}

CW__CountPlayers(gangid)
{
	new iCount;
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(PlayerInfo[i][GangID] != gangid)
	        continue;
	        
		if(CW::IsPlaying(i))
			iCount++;
	}
	return iCount;
}

CW__GetPlayerList(gangid)
{
	new pList[400], iCount;
	
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(PlayerInfo[i][GangID] != gangid)
	        continue;

		if(!IsPlayerAvailable(i))
			continue;

        if(iCount == 0)
			Format(pList, "%d. %s", i, PlayerName(i));
		else
		    Format(pList, "%s\r\n%d. %s", pList, i, PlayerName(i));
		    
		iCount++;
	}
	
	if(iCount == 0)
	    Format(pList, "Done (%d)", CW::CountPlayers(gangid));
	else
		Format(pList, "%s\r\nDone (%d)", pList, CW::CountPlayers(gangid));

	return pList;
}

CW__GetGangList()
{
	new gCount;
	new GangList[500];
	
	GangList = "There are no online gangs.";
	
	for(new i = 1; i < MAX_GANGS+1; i++)
	{
	    if(!Gang::ExistsGang(i))
 			continue;
	        
	    if(i == CWTeamInfo[CW_TEAM_ONE][GangID])
	        continue;
	        
		if(CountOnlineGangMembers(i) < 1)
		    continue;
		
		if(gCount == 0)
			Format(GangList, "%d. %s (%d)", i, GangInfo[i][GangName], CountOnlineGangMembers(i));
		else
		    Format(GangList, "%s\r\n%d. %s (%d)", GangList, i, GangInfo[i][GangName], CountOnlineGangMembers(i));
		    
		gCount++;
	}
	
	return GangList;
}
/*
CW__GetLocationList(cwmode)
{
	new LocList[400], iCount;
	
	if(cwmode == CW_MODE_CW || cwmode == CW_MODE_TCW)
	{
		for(new i = 0; i < CW_LocCount; i++)
		{
		    if(iCount == 0)
		        Format(LocList, "%s", CWLocations[i][LocName]);
			else
				Format(LocList, "%s\r\n%s", LocList, CWLocations[i][LocName]);
				
			iCount++;
		}
	}
	else if(cwmode == CW_MODE_SDM)
	{
	    for(new i = 0; i < SDM_LocCount; i++)
	    {
 			if(iCount == 0)
		        Format(LocList, "%s", SDMLocations[i][LocName]);
			else
				Format(LocList, "%s\r\n%s", LocList, SDMLocations[i][LocName]);
				
			iCount++;
	    }
	}
	return LocList;
}*/

/*
CW__LoadLocations()
{
	new locCount, result[256];
	new iCount, sMessage[128];
	new i = 0;
	
	// CW/TCW
	locCount = MySQL::CountRows(Table_cw);

	CWTCW_LocCount = locCount;

	if(locCount < 1)
	{
	    SendReport("[CWhandler]: No existing CW/TCW locations.");
	}
	else
	{
		MySQL_Vars

		MySQL_Format("SELECT * FROM %s", Table_cw);
		
		MySQL_Query
		MySQL_Result

		MySQL_FetchMultiRows
		{
		    MySQL_FetchRow(CWLocations[i][LocName], "name");

			MySQL_FetchRow(result, "x1");
			CWLocations[i][Pos1][0] = floatstr(result);

			MySQL_FetchRow(result, "y1");
			CWLocations[i][Pos1][1] = floatstr(result);

			MySQL_FetchRow(result, "z1");
			CWLocations[i][Pos1][2] = floatstr(result);

			MySQL_FetchRow(result, "ang1");
			CWLocations[i][Pos1][3] = floatstr(result);

			MySQL_FetchRow(result, "x2");
			CWLocations[i][Pos2][0] = floatstr(result);

			MySQL_FetchRow(result, "y2");
			CWLocations[i][Pos2][1] = floatstr(result);

			MySQL_FetchRow(result, "z2");
			CWLocations[i][Pos2][2] = floatstr(result);

			MySQL_FetchRow(result, "ang2");
			CWLocations[i][Pos2][3] = floatstr(result);

   			MySQL_FetchRow(result, "xmax");
			CWLocations[i][Boundries][0] = floatstr(result);

   			MySQL_FetchRow(result, "xmin");
			CWLocations[i][Boundries][1] = floatstr(result);

   			MySQL_FetchRow(result, "ymax");
			CWLocations[i][Boundries][2] = floatstr(result);
			
			MySQL_FetchRow(result, "ymin");
			CWLocations[i][Boundries][3] = floatstr(result);
				
			i++;
			iCount++;
		}
		MySQL_Free

		Format(sMessage, "[CWHandler]: %d/%d CWTCW locations where loaded.", iCount, locCount);
		SendReport(sMessage);
	}
	// SDM
	
	i = 0;
	iCount = 0;
	locCount = MySQL::CountRows(Table_sdm);

    CWSDM_LocCount = locCount;

	if(locCount < 1)
	{
	    SendReport("[CWHandler]: No existing SDM locations.");
	}
	else
	{
	    MySQL_Vars
	    

		MySQL_Format("SELECT * FROM %s", Table_sdm);
		
		MySQL_Query
		MySQL_Result

		MySQL_FetchMultiRows
		{
		    MySQL_FetchRow(SDMLocations[i][LocName], "name");

			MySQL_FetchRow(result, "x1");
			SDMLocations[i][Pos1][0] = floatstr(result);

			MySQL_FetchRow(result, "y1");
			SDMLocations[i][Pos1][1] = floatstr(result);

			MySQL_FetchRow(result, "z1");
			SDMLocations[i][Pos1][2] = floatstr(result);

			MySQL_FetchRow(result, "ang1");
			SDMLocations[i][Pos1][3] = floatstr(result);

			MySQL_FetchRow(result, "x2");
			SDMLocations[i][Pos2][0] = floatstr(result);

			MySQL_FetchRow(result, "y2");
			SDMLocations[i][Pos2][1] = floatstr(result);

			MySQL_FetchRow(result, "z2");
			SDMLocations[i][Pos2][2] = floatstr(result);

			MySQL_FetchRow(result, "ang2");
			SDMLocations[i][Pos2][3] = floatstr(result);

   			MySQL_FetchRow(result, "xmax");
			SDMLocations[i][Boundries][0] = floatstr(result);

   			MySQL_FetchRow(result, "xmin");
			SDMLocations[i][Boundries][1] = floatstr(result);

   			MySQL_FetchRow(result, "ymax");
			SDMLocations[i][Boundries][2] = floatstr(result);

   			MySQL_FetchRow(result, "ymin");
			SDMLocations[i][Boundries][3] = floatstr(result);
			i++;
			iCount++;
		}
		MySQL_Free
		
		Format(sMessage, "[CWHandler]: %d/%d SDM locations where loaded.", iCount, locCount);
		SendReport(sMessage);
	}
	return 1;
}
*/

CW__SaveLocation()
{
	new sTable[128];

	if(CWNLInfo[cwMode] == CW_MODE_CW || CWNLInfo[cwMode] == CW_MODE_TCW)
	    sTable = Table_cw;
	    
 	if(CWNLInfo[cwMode] == CW_MODE_SDM)
	    sTable = Table_sdm;
	
	MySQL_Vars_L
	MySQL_Format("INSERT INTO %s (name, x1, y1, z1, ang1, \
		      							x2, y2, z2, ang2, \
 										xmax, xmin, ymax, ymin) VALUES ('%s', %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f)", sTable, MySQL::Escape(CWNLInfo[LocName]),
 									    CWNLInfo[Pos1][0], CWNLInfo[Pos1][1], CWNLInfo[Pos1][2], CWNLInfo[Pos1][3],
 									    CWNLInfo[Pos2][0], CWNLInfo[Pos2][1], CWNLInfo[Pos2][2], CWNLInfo[Pos2][3],
										CWNLInfo[Boundries][0], CWNLInfo[Boundries][1], CWNLInfo[Boundries][2], CWNLInfo[Boundries][3]);
	
	MySQL_Query
	
	CW::nlReset();

	return 1;
}

CW__FreezeWar()
{
	if(!CW::IsRunning())
	    return 0;
	    
    for(new i = 0; i < MaxSlots; i++)
    {
        if(CW::IsPlaying(i))
			TogglePlayerControllable(i, false);
    }
    
    CWInfo[cwFrozen] = 1;
    
	return 1;
}

CW__UnfreezeWar()
{
	if(!CW::IsRunning())
	    return 0;

	new sReset[MAX_PLAYER_NAME];
	
	sReset = "";

    for(new i = 0; i < MaxSlots; i++)
    {
        CWLeavers[i] = sReset;
        if(CW::IsPlaying(i))
			TogglePlayerControllable(i, true);
    }
    
    CWInfo[cwFrozen] = 0;

	return 1;
}

CW__Reset()
{
	CWTeamInfo[CW_TEAM_ONE][GangID] = 0;
	CWTeamInfo[CW_TEAM_ONE][Kills] = 0;
	CWTeamInfo[CW_TEAM_ONE][Deaths] = 0;
	CWTeamInfo[CW_TEAM_ONE][Wins] = 0;
	CWTeamInfo[CW_TEAM_ONE][Losses] = 0;
	CWTeamInfo[CW_TEAM_TWO][GangID] = 0;
	CWTeamInfo[CW_TEAM_TWO][Kills] = 0;
	CWTeamInfo[CW_TEAM_TWO][Deaths] = 0;
	CWTeamInfo[CW_TEAM_TWO][Wins] = 0;
	CWTeamInfo[CW_TEAM_TWO][Losses] = 0;
	
	CWInfo[cwStatus] = 0;
	CWInfo[cwMode] = 0;
	CWInfo[cwType] = 0;
	CWInfo[cwLocation] = 0;
	CWInfo[cwMaxRounds] = 0;
	CWInfo[cwMaxScore] = 0;
	CWInfo[cwCountdown] = 0;
	
	CWInfo[cwInviter] = -1;
	CWInfo[cwAccepter] = -1;
	CWInfo[cwLeavecount] = 0;
	CWInfo[cwFrozen] = 0;
	
	CW::DestroyTextDraws();
	
	for(new i = 0; i < MaxSlots; i++)
	{
		StrReset(CWLeavers[i]);
		CWTeamInfo[CW_TEAM_ONE][Dead][i] = 0;
		CWTeamInfo[CW_TEAM_TWO][Dead][i] = 0;
		
	    if(CW::IsInvolved(i))
		{
		    Hardcore::Reset(i);
		    PlayerInfo[i][Hidden] = false;
			PlayerInfo[i][Spectating] = false;
			SetPlayerTeam(i, 255);
        	SetPlayerWorldBounds(i, 20000.0000, -20000.0000, 20000.0000, -20000.0000);
        
 			if(CWInfo[cwSpectators][i] == 1)
				TogglePlayerSpectating(i, false);
			else
				SpawnPlayer(i);
		}
		
  		CWInfo[cwPlayers][i] = 0;
        CWInfo[cwSpectators][i] = 0;
	}
	
	for(new i = 0; i < CW_MAX_WEAPONS; i++)
		CWInfo[cwWeapons][i] = 0;

	return 1;
}

CW__nlReset()
{
	CWNLInfo[IsCreating] = -1;
	CWNLInfo[Step] = CW_NL_STEP_MODE;
	CWNLInfo[cwMode] = 0;
	Format(CWNLInfo[LocName], "N/A");
	
	CWNLInfo[Pos1][0] = 0.0;
	CWNLInfo[Pos1][1] = 0.0;
	CWNLInfo[Pos1][2] = 0.0;
	CWNLInfo[Pos1][3] = 0.0;
	
	CWNLInfo[Pos2][0] = 0.0;
	CWNLInfo[Pos2][1] = 0.0;
	CWNLInfo[Pos2][2] = 0.0;
	CWNLInfo[Pos2][3] = 0.0;
	
 	CWNLInfo[Boundries][0] = 0.0;
 	CWNLInfo[Boundries][1] = 0.0;
 	CWNLInfo[Boundries][2] = 0.0;
  	CWNLInfo[Boundries][3] = 0.0;
 	
 	return 1;
}

stock SendCWMsg(const string[])
{
	new sMessage[256];
	
	Format(sMessage, "[CW] %s", string);
	
	for(new i = 0; i < MaxSlots; i++)
	{
		if(!IsPlayerConnected(i))
		    continue;
		    
	    if(CW::IsPlaying(i))
	        SendClientMessage(i, CW_COLOR_INFO, sMessage);
		else if(CW::IsSpectating(i))
		    SendClientMessage(i, CW_COLOR_INFO, sMessage);
	}
	
	return 1;
}

