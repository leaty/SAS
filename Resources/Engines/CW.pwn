public CWStart()
{
	new XorZ_1, XorZ_2;
	new Float:g1X, Float:g1Y, Float:g1Z, Float:g1FA;
	new Float:g2X, Float:g2Y, Float:g2Z, Float:g2FA;
	new Plus;

	ServerInfo[ClanwarStatus] = CW_RUNNING;

	for(new i = 0; i < MaxSlots; i++)
	{

	    if(PlayerInfo[i][CW] == 1)
     	{
		    /*Clanwar [1]*/
			if(ServerInfo[Clanwar] == CW1) /*Gang 1 Pos*/g1X = 2833.7576, g1Y = 2539.9944, g1Z = 17.6719, g1FA = 179.6384, /*Gang 2 Pos*/g2X = 2832.9436, g2Y = 2447.7673, g2Z = 17.6719, g2FA = 358.8864;

		    /*Clanwar [2]*/
			if(ServerInfo[Clanwar] == CW2) /*Gang 1 Pos*/g1X = 1367.4923, g1Y = 1463.7007, g1Z = 10.8203, g1FA = 268.8145, /*Gang 2 Pos*/g2X = 1502.9071, g2Y = 1462.9240, g2Z = 10.8346, g2FA = 89.6136;

		    /*Clanwar [3]*/
			if(ServerInfo[Clanwar] == CW3) /*Gang 1 Pos*/g1X = -2055.1570, g1Y = -124.7497, g1Z = 35.3059, g1FA = 178.8719, /*Gang 2 Pos*/g2X = -2057.8469, g2Y = -267.0511, g2Z = 35.3203, g2FA = 359.4820;

			//--Gang 1
		    if(ServerInfo[gID1] == PlayerInfo[i][IsGang])
		    {
		        Plus++;
				if(XorZ_1 == 0) SetPlayerPos(i, g1X+Plus, g1Y, g1Z), XorZ_1 = 1;
			    else if(XorZ_1 == 1) SetPlayerPos(i, g1X, g1Y, g1Z+Plus), XorZ_1 = 0;

                TogglePlayerSpectating(i, 0);
			    SetPlayerVirtualWorld(i, 98);
			    SetPlayerTime(i, random(23), 00);
				SetPlayerFacingAngle(i, g1FA);
				SetCameraBehindPlayer(i);
				SetPlayerColor(i, COLOR_CWGANGCHAT1);
				TogglePlayerControllable(i, 0);
				if(Plus > 5) Plus = 1;
			}
			//--Gang 2
			else if(ServerInfo[gID2] == PlayerInfo[i][IsGang])
			{
			    Plus++;
				if(XorZ_2 == 0) SetPlayerPos(i, g2X+Plus, g2Y, g2Z), XorZ_2 = 1;
			    else if(XorZ_2 == 1) SetPlayerPos(i, g2X, g2Y, g2Z+Plus), XorZ_2 = 0;

                TogglePlayerSpectating(i, 0);
			    SetPlayerVirtualWorld(i, 98);
			    SetPlayerTime(i, random(23), 00);
				SetPlayerFacingAngle(i, g2FA);
				SetCameraBehindPlayer(i);
				SetPlayerColor(i, COLOR_CWGANGCHAT2);
				TogglePlayerControllable(i, 0);
				if(Plus > 5) Plus = 1;
			}

			SetPlayerHealth(i, 100);
			SetPlayerArmour(i, 100);

			//--GIEF WEPS
			ResetPlayerWeapons(i);
			if(mWepClass == RW)
			{
				GivePlayerWeapon(i,26,100000);
				GivePlayerWeapon(i,28,100000);
			}
			else if(mWepClass == WW)
			{
				GivePlayerWeapon(i,34,100000);
				GivePlayerWeapon(i,31,100000);
				GivePlayerWeapon(i,29,100000);
				GivePlayerWeapon(i,25,100000);
			 	GivePlayerWeapon(i,24,100000);
			}
		}
	}
	ServerInfo[ClanwarRound]++;
	CW_NewRound = 0;
	CWCountDown = 10;
	CW_CDTimer = SetTimer("CW_countdown",1000,0);
	return true;
}

forward CW_countdown();
public CW_countdown()
{
	CWCountDown--;
	if(CWCountDown==0)
	{
		CWCountDown = -1;
		for(new i = 0; i < MaxSlots; i++)
		{
			PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
			if(GetPlayerVirtualWorld(i) == 98) GameTextForPlayer(i, "~g~GO~ r~!", 1000, 6);
			if(ServerInfo[gID1] == PlayerInfo[i][IsGang]) TogglePlayerControllable(i, 1);
			else if(ServerInfo[gID2] == PlayerInfo[i][IsGang]) TogglePlayerControllable(i, 1);
		}
		return 0;
	}
	else
	{
		new text[7]; format(text,sizeof(text),"~g~%d",CWCountDown);
		for(new i = 0; i < MaxSlots; i++)
		{
			PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
			if(GetPlayerVirtualWorld(i) == 98) GameTextForPlayer(i, text, 1000, 6), TogglePlayerControllable(i, 0);
		}
	}

	CW_CDTimer = SetTimer("CW_countdown",1000,0);
	return 0;
}

public CW_AwaitReply_Timer()
{
	CW_TimeCounter += 1;
	new GangID = ServerInfo[gID1], eGangID = ServerInfo[gID2], CWString[128];
	if(ServerInfo[ClanwarStatus] == CW_ACCEPTED)
	{
	    new string[3];
	    if(mWepClass == RW) string = "RW";
		else if(mWepClass == WW) string = "WW";

		format(CWString, sizeof(CWString), "A clanwar (%s) between gang %s (ID: %d) and %s (ID: %d) will start in 5 seconds! Type /cw spec to watch.", string, GetGangName(GangID), GangID, GetGangName(eGangID), eGangID);
		SendGangMsg(COLOR_CWGANGCHAT1, GangID, "** Gang Report: The gang has accepted your invitation, the CW will start in 5 seconds.");
		SendGangMsg(COLOR_CWGANGCHAT2, eGangID, "** Gang Report: Your leader has accepted the invitation, the CW will start in 5 seconds.");
		SendClientMessageToAll(COLOR_ORANGE, CWString);

		for(new i = 0; i < MaxSlots; i++)
		{
		    if(PlayerInfo[i][IsGang] == ServerInfo[gID1] || PlayerInfo[i][IsGang] == ServerInfo[gID2]) PlayerInfo[i][CW] = 1, PlayerInfo[i][CWDead] = 0;
		}

		CW_TimeCounter = 0;
	 	return KillTimer(CW_Timer), /*CW_SpecTimer = SetTimer("CW_Spec", 60, 1), */SetTimer("CWStart", 5000, 0);
	}
	else if(CW_TimeCounter == 20 && ServerInfo[ClanwarStatus] == CW_WAITING)
 	{
		SendGangMsg(COLOR_CWGANGCHAT1, GangID , "** Gang Report: The gang did not respond to your invitation of a clan war.");
		SendGangMsg(COLOR_CWGANGCHAT2, eGangID , "** Gang Report: Your leader did not respond to the invitation of a clanwar.");
		CW_End();
		CW_TimeCounter = 0;
		return KillTimer(CW_Timer);
	}
	else CW_Timer = SetTimer("CW_AwaitReply_Timer", 1000, false);
	return 0;
}

CW__End()
{
	for(new i = 0; i < MaxSlots; i++)
 	{
 	    if(PlayerInfo[i][CW] == 1)
 	    {
			SetPlayerVirtualWorld(i, 0);
			SetPlayerInterior(i, 0);
			ResetPlayerWeapons(i);
			PlayerInfo[i][CW] = 0;
			PlayerInfo[i][CWDead] = 0;
			TogglePlayerSpectating(i, 0);
			SpawnPlayer(i);
 	    }
		if(PlayerInfo[i][CWSpec] == 1)
		{
			SetPlayerVirtualWorld(i, 0);
			SetPlayerInterior(i, 0);
			ResetPlayerWeapons(i);
			PlayerInfo[i][CWSpec] = 0;
			TogglePlayerSpectating(i, 0);
			SpawnPlayer(i);
		}
 	}
 	ServerInfo[Clanwar] = 0;
 	ServerInfo[ClanwarStatus] = CW_NONE;
 	ServerInfo[ClanwarMaxRounds] = 0;
 	ServerInfo[ClanwarRound] = 0;
 	ServerInfo[gID1] = 0;
 	ServerInfo[gID2] = 0;
 	ServerInfo[g1Wins] = 0;
 	ServerInfo[g2Wins] = 0;
  	ServerInfo[g1LBPos] = 0;
   	ServerInfo[g2LBPos] = 0;
	CW_NewRound = 0;
   	KillTimer(CW_Timer);
   	KillTimer(CW_CDTimer);
   	return 1;
}

CW__CheckPlayers()
{
	new Gang1 = ServerInfo[gID1], Gang2 = ServerInfo[gID2];
	new MaxRounds = ServerInfo[ClanwarMaxRounds], Rounds = ServerInfo[ClanwarRound];
	new Gang1Wins = ServerInfo[g1Wins], Gang2Wins = ServerInfo[g2Wins];
	new Gang1TotalWins = GangInfo[Gang1][Wins], Gang2TotalWins = GangInfo[Gang2][Wins];
	new Gang1TotalLosses = GangInfo[Gang1][Losses], Gang2TotalLosses = GangInfo[Gang2][Losses];
	new Gang1Alive, Gang2Alive;
	new Gang1File[50], Gang2File[50];
 	new Set1Wins, Set2Wins;
 	new Set1Losses, Set2Losses;
	new string[128], string2[128];

	format(Gang1File, sizeof(Gang1File), "/gangs/%d.ini", Gang1);
	format(Gang2File, sizeof(Gang2File), "/gangs/%d.ini", Gang2);

	for(new i = 0; i < MaxSlots; i++)
	{
		//Gang 1
		if(PlayerInfo[i][IsGang] == Gang1 && PlayerInfo[i][CW] == 1 && PlayerInfo[i][CWDead] == 0) Gang1Alive++;
		//Gang 2
		else if(PlayerInfo[i][IsGang] == Gang2 && PlayerInfo[i][CW] == 1 && PlayerInfo[i][CWDead] == 0) Gang2Alive++;
	}

	if(Gang1Alive == 0 && Gang2Alive == 0) Rounds++, ServerInfo[ClanwarRound]++;

	if(Gang1Alive == 0 || Gang2Alive == 0)
	{
	    //-- IF FINISHED
	    if(Rounds >= MaxRounds)
	    {
	        if(Gang1Wins > Gang2Wins)
			{
				format(string, sizeof(string), "** Gang %s (ID: %d) has won with %d - %d over %s (ID: %d) in a clanwar!", GetGangName(Gang1), Gang1, Gang1Wins, Gang2Wins, GetGangName(Gang2), Gang2);
				SendClientMessageToAll(COLOR_ORANGE, string);
				SendIRCMsg(string);
				Set1Wins = Gang1TotalWins + 1;
				Set2Losses = Gang2TotalLosses + 1;
				dini_IntSet(Gang1File, "Wins", Set1Wins);
				dini_IntSet(Gang2File, "Losses", Set2Losses);
				GangLoad();
   			}
   			else if(Gang1Wins < Gang2Wins)
   			{
   			    format(string, sizeof(string), "** Gang %s (ID: %d) has won with %d - %d over %s (ID: %d) in a clanwar!", GetGangName(Gang2), Gang2, Gang2Wins, Gang1Wins, GetGangName(Gang1), Gang1);
   			    SendClientMessageToAll(COLOR_ORANGE, string);
				SendIRCMsg(string);
				Set2Wins = Gang2TotalWins + 1;
				Set1Losses = Gang1TotalLosses + 1;
				dini_IntSet(Gang2File, "Wins", Set2Wins);
				dini_IntSet(Gang1File, "Losses", Set1Losses);
				GangLoad();
   			}
   			else if(Gang1Wins == Gang2Wins)
   			{
   			    format(string, sizeof(string), "** The clanwar between %s (ID: %d) and %s (ID: %d) has ended in a tie!", GetGangName(Gang1), Gang1, GetGangName(Gang2), Gang2);
				SendClientMessageToAll(COLOR_ORANGE, string);
				SendIRCMsg(string);
  				Set1Wins = Gang1TotalWins + 1;
				Set2Wins = Gang2TotalWins + 1;
				Set1Losses = Gang1TotalLosses + 1;
				Set2Losses = Gang2TotalLosses + 1;
				dini_IntSet(Gang1File, "Wins", Set1Wins);
				dini_IntSet(Gang2File, "Wins", Set2Wins);
				dini_IntSet(Gang1File, "Losses", Set1Losses);
				dini_IntSet(Gang2File, "Losses", Set2Losses);
				GangLoad();
   			}
   			else
	 		{
	 			format(string, sizeof(string), "** The clanwar between %s (ID: %d) and %s (ID: %d) has ended.", GetGangName(Gang1), Gang1, GetGangName(Gang2), Gang2);
		 		SendClientMessageToAll(COLOR_ORANGE, string);
                SendIRCMsg(string);
			}
			//LEADERBOARD CLIMBING
			if(GangInfo[Gang1][LBPosition] > ServerInfo[g1LBPos])
			{
				if(GangInfo[Gang1][LBPosition] == 1) format(string, sizeof(string), "** Gang %s (ID: %d) has climbed all the way up to first place in the leaderboard, and has now earned the title as the best TDM Champions!", GetGangName(Gang1), Gang1);
				else format(string, sizeof(string), "** Gang %s (ID: %d) has climbed up to position %d in the leaderboard!", GetGangName(Gang1), Gang1, GangInfo[Gang1][LBPosition]);
				SendClientMessageToAll(COLOR_PINK, string);
                SendIRCMsg(string);
			}
			else if(GangInfo[Gang2][LBPosition] > ServerInfo[g2LBPos])
			{
				if(GangInfo[Gang2][LBPosition] == 1) format(string, sizeof(string), "** Gang %s (ID: %d) has climbed all the way up to first place in the leaderboard, and has now earned the title as the best TDM Champions!", GetGangName(Gang2), Gang2);
				else format(string, sizeof(string), "** Gang %s (ID: %d) has climbed up to position %d in the leaderboard!", GetGangName(Gang2), Gang2, GangInfo[Gang2][LBPosition]);
				SendClientMessageToAll(COLOR_PINK, string);
				SendIRCMsg(string);
			}
			if(GangInfo[Gang1][LBPosition] == ServerInfo[g1LBPos])
			{
			    if(GangInfo[Gang1][LBPosition] != 1) format(string, sizeof(string), "** Gang %s (ID: %d) holds their position (%d) in the leaderboard!", GetGangName(Gang1), Gang1, GangInfo[Gang1][LBPosition]);
			    else format(string, sizeof(string), "** Gang %s (ID: %d) keeps the title as the best TDM Champions!", GetGangName(Gang1), Gang1);
			    SendClientMessageToAll(COLOR_PINK, string);
			    SendIRCMsg(string);
			}
			if(GangInfo[Gang2][LBPosition] == ServerInfo[g2LBPos])
			{
   				if(GangInfo[Gang2][LBPosition] != 1) format(string, sizeof(string), "** Gang %s (ID: %d) holds their position (%d) in the leaderboard!", GetGangName(Gang2), Gang2, GangInfo[Gang2][LBPosition]);
			    else format(string, sizeof(string), "** Gang %s (ID: %d) keeps the title as the best TDM Champions!", GetGangName(Gang2), Gang2);
			    SendClientMessageToAll(COLOR_PINK, string);
			    SendIRCMsg(string);
			}
			//-
			if(GangInfo[Gang1][LBPosition] < ServerInfo[g1LBPos])
			{
				format(string2, sizeof(string2), "** Gang %s (ID: %d) dropped down to position %d in the leaderboard.", GetGangName(Gang1), Gang1, GangInfo[Gang1][LBPosition]);
				SendClientMessageToAll(COLOR_PINK, string2);
                SendIRCMsg(string);
			}
			else if(GangInfo[Gang2][LBPosition] < ServerInfo[g2LBPos])
			{
				format(string2, sizeof(string2), "** Gang %s (ID: %d) dropped down to position %d in the leaderboard.", GetGangName(Gang2), Gang2, GangInfo[Gang2][LBPosition]);
				SendClientMessageToAll(COLOR_PINK, string2);
				SendIRCMsg(string);
			}
			//-----------
   			CW_End();

		}
		else
  		{
	    	if(Gang1Alive == 0 && Gang2Alive == 0) format(string, sizeof(string), "** Round %d has ended in a tie! There's %d round(s) left.", Rounds, MaxRounds - Rounds), ServerInfo[g1Wins] += 1, ServerInfo[g2Wins]++;
            if(Gang1Alive == 0) format(string, sizeof(string), "** Round %d has been won by gang %s (ID: %d). There's %d round(s) left.", Rounds, GetGangName(Gang2), Gang2, MaxRounds - Rounds), ServerInfo[g2Wins]++;
			else if(Gang2Alive == 0) format(string, sizeof(string), "** Round %d has been won by gang %s (ID: %d). There's %d round(s) left.", Rounds, GetGangName(Gang1), Gang1, MaxRounds - Rounds), ServerInfo[g1Wins]++;

			for(new i = 0; i < MaxSlots; i++)
			{
		   		if(PlayerInfo[i][CW] == 1) CW_NewRound = 1, PlayerInfo[i][CWDead] = 0, SpawnPlayer(i);
			}

			SendClientMessageToAll(COLOR_ORANGE, string);
			SendIRCMsg(string);
			SendClientMessageToAll(COLOR_ORANGE, "** Next round will start in 5 seconds...");
			SendIRCMsg("** Next round will start in 5 seconds...");
			SetTimer("CWStart", 5000, 0);
		}
	}
	return 1;
}
