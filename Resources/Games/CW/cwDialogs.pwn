CW__OnDialog(playerid, dialogid, response, listitem, const inputtext[])
{
	switch(dialogid)
	{
	    case DIALOG_CW_INFO:
		{
	        if(response) // Continue
	        {
	            Player::OnDialogResponse(playerid);
	            
	            Player::ShowDialog(playerid, DIALOG_CW_MODE, DIALOG_STYLE_LIST, "CW - Mode", CW_ModeList, "Select", "Back");
	        }
	        else if(!response) // Cancel
	        {
	        	Player::OnDialogResponse(playerid);
	        	
				CW::Reset();
	            SendClientMessage(playerid, COLOR_FALSE, "* Your invitation was cancelled.");
	        }
	        return 1;
	    }
		//====== ON MODE SELECTION =====
	    case DIALOG_CW_MODE:
	    {
	        if(response) // Select
	        {
	            Player::OnDialogResponse(playerid);
				if(listitem == CW_MODE_CW && !IsGangOwner(playerid))
				{
				    SendClientMessage(playerid, COLOR_FALSE, "* You must be the gang owner to organize an official clan war.");
                    Player::ShowDialog(playerid, DIALOG_CW_MODE, DIALOG_STYLE_LIST, "CW - Mode", CW_ModeList, "Select", "Back");
				}
				else
				{
					CWInfo[cwMode] = listitem;
					if(listitem == CW_MODE_CW || listitem == CW_MODE_TCW)
						Player::ShowDialog(playerid, DIALOG_CWTCW_TYPE, DIALOG_STYLE_LIST, "CW - Type", CWTCW_TypeList, "Select", "Back");
					else if(listitem == CW_MODE_SDM)
                        Player::ShowDialog(playerid, DIALOG_CWSDM_TYPE, DIALOG_STYLE_LIST, "CW - Type", CWSDM_TypeList, "Select", "Back");
				}
			}
   			else if(!response) // Back
	        {
	            Player::OnDialogResponse(playerid);
	            
                Player::ShowDialog(playerid, DIALOG_CW_INFO, DIALOG_STYLE_MSGBOX, "* CW - Information", "** Before you go ahead and invite a gang, please read the following notes:\
																				 \n  * You can choose between different types of modes to challenge another gang with.\
																				 \n  * CW is the Official one (wins and losses will be counted), only the gang owner can choose this.\
																				 \n  * Available settings of the different modes may differ from eachother.", "Continue", "Cancel");
			}
			return 1;
	    }
	    //====== ON WEAPON SELECTION =====
	    case DIALOG_CW_WEAPON_CLASS:
	    {
	        if(response)
	        {
	            Player::OnDialogResponse(playerid);
	            
				if(listitem == CW_WEAPON_CLASS_CUSTOM)
				{
				    new sTitle[50];
					Format(sTitle, "CW - Weapon (%d/%d)", CW::CountWeapons()+1, CW_MAX_WEAPONS);
				    Player::ShowDialog(playerid, DIALOG_CW_WEAPON_CUSTOM, DIALOG_STYLE_LIST, sTitle, CW_WeaponList, "Select", "Back");
				}
				else
				{
				    if(listitem == CW_WEAPON_CLASS_RW)
				    {
						CWInfo[cwWeapons][0] = 28;
						CWInfo[cwWeapons][1] = 26;
						CWInfo[cwWeapons][2] = CW_WEAPON_NONE;
                        CWInfo[cwWeapons][3] = CW_WEAPON_NONE;
                        CWInfo[cwWeapons][4] = CW_WEAPON_NONE;
					}
					else if(listitem == CW_WEAPON_CLASS_WW)
				    {
						CWInfo[cwWeapons][0] = 24;
						CWInfo[cwWeapons][1] = 34;
						CWInfo[cwWeapons][2] = 31;
                        CWInfo[cwWeapons][3] = 27;
                        CWInfo[cwWeapons][4] = CW_WEAPON_NONE;
					}
					Player::ShowDialog(playerid, DIALOG_CW_TEAM, DIALOG_STYLE_LIST, "CW - LineUp (shows available gang members)", CW::GetPlayerList(PlayerInfo[playerid][GangID]), "Select", "Back");
				}
			}
   			else if(!response)
	        {
	            Player::OnDialogResponse(playerid);
	        
				if(CWInfo[cwMode] == CW_MODE_CW || CWInfo[cwMode] == CW_MODE_TCW)
				    Player::ShowDialog(playerid, DIALOG_CWTCW_LOCATION, DIALOG_STYLE_LIST, "CW - Location", Games::GetCWLocationList(), "Select", "Back");
				else if(CWInfo[cwMode] == CW_MODE_SDM)
				    Player::ShowDialog(playerid, DIALOG_CWSDM_LOCATION, DIALOG_STYLE_LIST, "CW - Location", Games::GetSDMLocationList(), "Select", "Back");
			}
			return 1;
	    }
	    case DIALOG_CW_WEAPON_CUSTOM:
	    {
	        new wCount = CW::CountWeapons();
	        
	        if(response)
	        {
	        	Player::OnDialogResponse(playerid);
	        
	    		new sTitle[50];
					
	            if(wCount < 1 && listitem == 0)
	            {
				    SendClientMessage(playerid, COLOR_FALSE, "* You must select at least one weapon.");
				    Format(sTitle, "CW - Weapon (%d/%d)", wCount+1, CW_MAX_WEAPONS);
				    Player::ShowDialog(playerid, DIALOG_CW_WEAPON_CUSTOM, DIALOG_STYLE_LIST, sTitle, CW_WeaponList, "Select", "Back");
				    return 1;
				}
	            
				CWInfo[cwWeapons][wCount] = CW::GetPickedWeapon(listitem);
	            
	            if(wCount+1 >= CW_MAX_WEAPONS)
                	Player::ShowDialog(playerid, DIALOG_CW_TEAM, DIALOG_STYLE_LIST, "CW - LineUp (shows available gang members)", CW::GetPlayerList(PlayerInfo[playerid][GangID]), "Select", "Back");
				else
				{
				    Format(sTitle, "CW - Weapon (%d/%d)", wCount+2, CW_MAX_WEAPONS);
    				Player::ShowDialog(playerid, DIALOG_CW_WEAPON_CUSTOM, DIALOG_STYLE_LIST, sTitle, CW_WeaponList, "Select", "Back");
				}
			}
   			else if(!response)
	        {
	            Player::OnDialogResponse(playerid);
	            
				for(new i = 0; i < CW_MAX_WEAPONS; i++)
    				CWInfo[cwWeapons][i] = 0;
    				
                Player::ShowDialog(playerid, DIALOG_CW_WEAPON_CLASS, DIALOG_STYLE_LIST, "CW - Weapon Class", CW_WeaponClasses, "Select", "Back");
			}
			return 1;
	    }
	    //====== ON CW OR TCW TYPE SELECTION =====
	    case DIALOG_CWTCW_TYPE:
	    {
	        if(response) // Select
	        {
	            Player::OnDialogResponse(playerid);
	            
				CWInfo[cwType] = listitem;
				
			    new CWTCWRounds[128], CWTCWScore[128];
			    Format(CWTCWRounds, "* How many rounds? Max: %d", CWTCW_MAX_ROUNDS);
			    Format(CWTCWScore, "Maximum score? Max: %d", CWTCW_MAX_SCORE);
				if(listitem == CWTCW_TYPE_ROUNDS)
			    	Player::ShowDialog(playerid, DIALOG_CWTCW_ROUNDS, DIALOG_STYLE_INPUT, "CW - Rounds", CWTCWRounds, "Select", "Back");
				else if(listitem == CWTCW_TYPE_SCORE)
			    	Player::ShowDialog(playerid, DIALOG_CWTCW_SCORE, DIALOG_STYLE_INPUT, "CW - Score", CWTCWScore, "Select", "Back");
			}
   			else if(!response) // Back
	        {
	            Player::OnDialogResponse(playerid);
	            
                Player::ShowDialog(playerid, DIALOG_CW_MODE, DIALOG_STYLE_LIST, "CW - Mode", CW_ModeList, "Select", "Back");
			}
			return 1;
	    }
	    //====== ON CW OR TCW ROUNDS SELECTION =====
	    case DIALOG_CWTCW_ROUNDS:
	    {
	        if(response) // Select
	        {
	            Player::OnDialogResponse(playerid);
	            
	            if(!isNumeric(inputtext) || strval(inputtext) > CWTCW_MAX_ROUNDS || strval(inputtext) < 1)
				{
				    SendClientMessage(playerid, COLOR_FALSE, "* Invalid round.");

				    new CWTCWRounds[128];
  				    Format(CWTCWRounds, "* How many rounds? Max: %d", CWTCW_MAX_ROUNDS);
					Player::ShowDialog(playerid, DIALOG_CWTCW_ROUNDS, DIALOG_STYLE_INPUT, "CW - Rounds", CWTCWRounds, "Select", "Back");
					return 1;
				}
				
				CWInfo[cwMaxRounds] = strval(inputtext);
				Player::ShowDialog(playerid, DIALOG_CWTCW_LOCATION, DIALOG_STYLE_LIST, "CW - Location", Games::GetCWLocationList(), "Select", "Back");
			}
   			else if(!response) // Back
	        {
	            Player::OnDialogResponse(playerid);
	            
			    Player::ShowDialog(playerid, DIALOG_CWTCW_TYPE, DIALOG_STYLE_LIST, "CW - Type", CWTCW_TypeList, "Select", "Back");
			}
			return 1;
	    }
	    //====== ON CW OR TCW SCORE SELECTION =====
	    case DIALOG_CWTCW_SCORE:
	    {
	        if(response)
	        {
	            Player::OnDialogResponse(playerid);
	            
         		if(!isNumeric(inputtext) || strval(inputtext) > CWTCW_MAX_SCORE || strval(inputtext) < 1)
				{
				    SendClientMessage(playerid, COLOR_FALSE, "* Invalid maxscore.");

				    new CWTCWScore[128];
  				    Format(CWTCWScore, "Maximum score? Max: %d", CWTCW_MAX_SCORE);
					Player::ShowDialog(playerid, DIALOG_CWTCW_SCORE, DIALOG_STYLE_INPUT, "CW - Score", CWTCWScore, "Select", "Back");
					return 1;
				}
				
				CWInfo[cwMaxScore] = strval(inputtext);
				Player::ShowDialog(playerid, DIALOG_CWTCW_LOCATION, DIALOG_STYLE_LIST, "CW - Location", Games::GetCWLocationList(), "Select", "Back");
			}
   			else if(!response)
	        {
	            Player::OnDialogResponse(playerid);
	            
	            Player::ShowDialog(playerid, DIALOG_CWTCW_TYPE, DIALOG_STYLE_LIST, "CW - Type", CWTCW_TypeList, "Select", "Back");
			}
			return 1;
	    }
	    //====== ON CW OR TCW LOCATION SELECTION =====
	    case DIALOG_CWTCW_LOCATION:
	    {
	        if(response)
	        {
	            Player::OnDialogResponse(playerid);
	            
    			CWInfo[cwLocation] = listitem;
    			Player::ShowDialog(playerid, DIALOG_CW_WEAPON_CLASS, DIALOG_STYLE_LIST, "CW - Weapon Class", CW_WeaponClasses, "Select", "Back");
			}
   			else if(!response)
	        {
	            Player::OnDialogResponse(playerid);
	            
				Player::ShowDialog(playerid, DIALOG_CWTCW_TYPE, DIALOG_STYLE_LIST, "CW - Type", CWTCW_TypeList, "Select", "Back");
			}
			return 1;
	    }
	    //====== ON SDM TYPE SELECTION =====
	    case DIALOG_CWSDM_TYPE:
	    {
	        if(response)
	        {
	            Player::OnDialogResponse(playerid);
	            
	            CWInfo[cwType] = listitem;
	            
			    new SDMRounds[128];
			    Format(SDMRounds, "* How many rounds? Max: %d", CWSDM_MAX_ROUNDS);
			    Player::ShowDialog(playerid, DIALOG_CWSDM_ROUNDS, DIALOG_STYLE_INPUT, "CW - Rounds", SDMRounds, "Select", "Back");
			}
   			else if(!response)
	        {
	            Player::OnDialogResponse(playerid);
	            
                Player::ShowDialog(playerid, DIALOG_CW_MODE, DIALOG_STYLE_LIST, "CW - Mode", CW_ModeList, "Select", "Back");
			}
			return 1;
	    }
	    //====== ON SDM ROUNDS SELECTION =====
	    case DIALOG_CWSDM_ROUNDS:
	    {
	        if(response)
	        {
	            Player::OnDialogResponse(playerid);
	            
	            if(!isNumeric(inputtext) || strval(inputtext) > CWSDM_MAX_ROUNDS || strval(inputtext) < 1)
	            {
	                SendClientMessage(playerid, COLOR_FALSE, "* Invalid round.");
	                
	                new SDMRounds[128];
				    Format(SDMRounds, "* How many rounds? Max: %d", CWSDM_MAX_ROUNDS);
				    Player::ShowDialog(playerid, DIALOG_CWSDM_ROUNDS, DIALOG_STYLE_INPUT, "CW - Rounds", SDMRounds, "Select", "Back");
				    return 1;
				}
				
				CWInfo[cwMaxRounds] = strval(inputtext);
				Player::ShowDialog(playerid, DIALOG_CWSDM_LOCATION, DIALOG_STYLE_LIST, "CW - Location", Games::GetSDMLocationList(), "Select", "Back");
			}
   			else if(!response)
	        {
	            Player::OnDialogResponse(playerid);
	            
                Player::ShowDialog(playerid, DIALOG_CWSDM_TYPE, DIALOG_STYLE_LIST, "CW - Type", CWSDM_TypeList, "Select", "Back");
			}
			return 1;
	    }
	    //====== ON SDM LOCATION SELECTION =====
	    case DIALOG_CWSDM_LOCATION:
	    {
	        if(response)
	        {
	            Player::OnDialogResponse(playerid);
	            
				CWInfo[cwLocation] = listitem;
    			Player::ShowDialog(playerid, DIALOG_CW_WEAPON_CLASS, DIALOG_STYLE_LIST, "CW - Weapon Class", CW_WeaponClasses, "Select", "Back");
			}
   			else if(!response)
	        {
	            Player::OnDialogResponse(playerid);
	            
                Player::ShowDialog(playerid, DIALOG_CWSDM_TYPE, DIALOG_STYLE_LIST, "CW - Type", CWSDM_TypeList, "Select", "Back");
			}
			return 1;
	    }
	    case DIALOG_CW_TEAM:
	    {
	        if(response)
	        {
	            Player::OnDialogResponse(playerid);
	            
	            if(strcmp(inputtext, "Done", false, 4) == 0)
	            {
	                Player::ShowDialog(playerid, DIALOG_CW_INVITE, DIALOG_STYLE_LIST, "CW - Invite", CW::GetGangList(), "Invite!", "Back");
				}
				else
				{
				    new pID, sID[50], sTrash[50], Input[256];
					Format(Input, "%s", inputtext);
				    sscanf(Input, "ss", sID, sTrash);
				    
					pID = strval(sID);
					
					if(!IsPlayerAvailable(pID))
						SendClientMessage(playerid, COLOR_FALSE, "* This player is not available anymore, he/she might have joined another minigame or such.");
					else
						CWInfo[cwPlayers][pID] = 1;
						
					Player::ShowDialog(playerid, DIALOG_CW_TEAM, DIALOG_STYLE_LIST, "CW - LineUp (shows available gang members)", CW::GetPlayerList(PlayerInfo[playerid][GangID]), "Select", "Back");
				}
			}
	        else if(!response)
			{
			    Player::OnDialogResponse(playerid);
			    
   				for(new i = 0; i < CW_MAX_WEAPONS; i++)
	                CWInfo[cwWeapons][i] = 0;
	                
				for(new i = 0; i < MaxSlots; i++)
					if(PlayerInfo[playerid][GangID] == PlayerInfo[i][GangID])
					    CWInfo[cwPlayers][i] = 0;
	                
			 	Player::ShowDialog(playerid, DIALOG_CW_WEAPON_CLASS, DIALOG_STYLE_LIST, "CW - Weapon Class", CW_WeaponClasses, "Select", "Back");
			}
			return 1;
		}
		case DIALOG_CW_ACCEPT:
		{
		    if(response)
		    {
		        Player::OnDialogResponse(playerid);

	            if(strcmp(inputtext, "Done", false, 4) == 0)
	            {
	                CW::Prepare();
				}
				else
				{
					new gangid = PlayerInfo[playerid][GangID];
					new engangid = CWTeamInfo[CW_TEAM_ONE][GangID];
					
					if(CW::CountPlayers(gangid) >= CW::CountPlayers(engangid))
					{
					    SendClientMessage(playerid, COLOR_FALSE, "* You cannot select more players than the other team has! Please select 'Done' in the list.");
					    Player::ShowDialog(playerid, DIALOG_CW_ACCEPT, DIALOG_STYLE_LIST, "CW - Line-Up (shows available gang members)", CW::GetPlayerList(gangid), "Select", "Deny");
					    return 1;
					}
					
				    new pID, sID[50], sTrash[50], Input[256];
					Format(Input, "%s", inputtext);
				    sscanf(Input, "ss", sID, sTrash);

					pID = strval(sID);
					
					if(!IsPlayerAvailable(pID))
						SendClientMessage(playerid, COLOR_FALSE, "* This player is not available anymore, he/she might have joined another minigame or such.");
					else
						CWInfo[cwPlayers][pID] = 1;
						
					Player::ShowDialog(playerid, DIALOG_CW_ACCEPT, DIALOG_STYLE_LIST, "CW - LineUp (shows available gang members)", CW::GetPlayerList(PlayerInfo[playerid][GangID]), "Select", "Deny");
				}
				return 1;
			}
			else if(!response)
			{
			    Player::OnDialogResponse(playerid);
			    
  				new gangid = PlayerInfo[playerid][GangID];
				new engangid = CWTeamInfo[CW_TEAM_ONE][GangID];
				new sMessage[256];

				Format(sMessage, "%s has denied Gang %s's invitation.", PlayerName(playerid), GangInfo[engangid][GangName]);
				SendGangMsg(gangid, GANG_COLOR_INFO, sMessage);
				Format(sMessage, "%s from Gang '%s' has denied your gang's invitation.", PlayerName(playerid), GangInfo[gangid][GangName]);
			    SendGangMsg(engangid, GANG_COLOR_INFO, sMessage);
			    
				CW::Reset();
			}
		}
	    //====== ON INVITE =====
	    case DIALOG_CW_INVITE:
	    {
	        if(response)
	        {
	            Player::OnDialogResponse(playerid);
	            
	            new sGangID[50], sTrash[50], Input[256];
				Format(Input, "%s", inputtext);
				sscanf(Input, "ss", sGangID, sTrash);
				
				if(strval(sGangID) < 1)
				{
				    SendClientMessage(playerid, COLOR_FALSE, "* Sorry, there are no gangs online.");
				    CW::Reset();
				    return 1;
				}

				new gangid = strval(sGangID);
				
				CW::InviteGang(playerid, gangid);
			}
   			else if(!response)
	        {
	            Player::OnDialogResponse(playerid);
	            
  				for(new i = 0; i < CW_MAX_WEAPONS; i++)
	                CWInfo[cwWeapons][i] = 0;

				for(new i = 0; i < MaxSlots; i++)
					if(PlayerInfo[playerid][GangID] == PlayerInfo[i][GangID])
					    CWInfo[cwPlayers][i] = 0;
	            
		    	Player::ShowDialog(playerid, DIALOG_CW_WEAPON_CLASS, DIALOG_STYLE_LIST, "CW - Weapon Class", CW_WeaponClasses, "Select", "Back");
			}
			return 1;
	    }
	}
	return 1;
}

