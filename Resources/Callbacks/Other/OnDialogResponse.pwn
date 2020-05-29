public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    Player::OnDialogResponse(playerid);

	switch(dialogid)
	{
	//==========================//
	//    REGISTER / LOGIN      //
	//==========================//
	    case DIALOG_REGISTER:
	    {
	        if(response)
	        {
	            Player::OnDialogResponse(playerid);
	            
				if(strlen(inputtext) < MIN_PASSWORD)
				{
   					Player::ShowDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "* Register", DIALOG_REGISTER_TEXT, "Register!", "Quit");
					SendClientMessage(playerid, COLOR_FALSE, "* Password too short! Minimum is 4.");
			    	
   				}
   				else if(strlen(inputtext) > MAX_PASSWORD)
   				{
   				    Player::ShowDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "* Register", DIALOG_REGISTER_TEXT, "Register!", "Quit");
   				    SendClientMessage(playerid, COLOR_FALSE, "* Password too long! Maximum is 30.");
   				}
   				else
   				{
                    if(Player::RegisterPlayer(playerid, inputtext))
                    {
                    	Player::FetchData(playerid);
   		                FormatIRC("%s*** %s%s%s has registered.", IRC_COLOR_TRUE, IRC_BOLD, PlayerName(playerid), IRC_ENDBOLD);
						IRC::SendEchoMsg(ircstring);
					}
				}
			}
			else if(!response)
			{
			    Player::OnDialogResponse(playerid);
			    
			    Player::Kick(playerid, SERVERKICKBAN, "Didn't register.");
			}
			
			return 1;
	    }
	    case DIALOG_LOGIN:
	    {
	        if(response)
	        {
	            Player::OnDialogResponse(playerid);
	            
	            Player::LoginPlayer(playerid, inputtext);

				//If failed to login
	            if(!PlayerInfo[playerid][LoggedIn])
				{
					PlayerInfo[playerid][LoginTries]++;
					FormatString("* Login failed, you have used [%d/%d] tries.", PlayerInfo[playerid][LoginTries], MaxLoginTries);
					SendClientMessage(playerid, COLOR_FALSE, string);
					
					// Launch dialog again if player has tries left
					if(PlayerInfo[playerid][LoginTries] < MaxLoginTries) ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "* Login", DIALOG_LOGIN_TEXT, "Identify!", "Quit");
	            }
	            //If successfully logged in
	            else
	            {
					Player::FetchData(playerid);
	                SendClientMessage(playerid, COLOR_TRUE, "* Oh, so it is you! Didn't recognise you at first.. Welcome back!");
	                FormatIRC("%s*** %s%s%s has logged in.", IRC_COLOR_TRUE, IRC_BOLD, PlayerName(playerid), IRC_ENDBOLD);
	                IRC::SendEchoMsg(ircstring);
	            }
	            
	            // If player reached maximum tries
				if(PlayerInfo[playerid][LoginTries] == MaxLoginTries)
				{
					Player::Kick(playerid, SERVERKICKBAN, "Failed login.");
				}
	        }
  			else if(!response)
			{
				Player::OnDialogResponse(playerid);
			
			    Player::Kick(playerid, SERVERKICKBAN, "Didn't login.");
			}
			
			return 1;
	    }
	    case DIALOG_MODE:
	    {
	        if(response)
	        {
	   			PlayerPlaySound(playerid, 1069, 0.0, 0.0, 0.0);
				PlayerInfo[playerid][Started] = TRUE;
				
				if(PlayerInfo[playerid][pMode] == MODE_TRAINING)
					Training::OnStart(playerid);
				else if(PlayerInfo[playerid][pMode] == MODE_FREEROAM)
				    Freeroam::OnStart(playerid);
				
			}
			return 1;
	    }
	    case DIALOG_GANG_DELETE: return Gang::OnDialog(playerid, dialogid, response, listitem, inputtext);
	}
	
	if ( ( dialogid >= DIALOG_CW_INFO && dialogid <= DIALOG_CW_ACCEPT )
	&& ( CW::OnDialog(playerid, dialogid, response, listitem, inputtext) ) )
	    return 1;
	    
 	if ( ( dialogid >= DIALOG_MINI_GAMES && dialogid <= DIALOG_MINI_LOCATION )
	&& ( Mini::OnDialog(playerid, dialogid, response, listitem, inputtext) ) )
	    return 1;

	if ( ( IsTraining(playerid) )
	&& ( Training::OnDialog(playerid, dialogid, response, listitem, inputtext) ) )
	    return 1;
	    
	if ( ( IsFreeroam(playerid) )
 	&& ( Freeroam::OnDialog(playerid, dialogid, response, listitem, inputtext) ) )
	    return 1;

	/*
		case DIALOG_CW_INFO: return CW::OnDialog(playerid, dialogid, response, listitem, inputtext);
		case DIALOG_CW_MODE: return CW::OnDialog(playerid, dialogid, response, listitem, inputtext);
		
		case DIALOG_CW_WEAPON_CLASS: return CW::OnDialog(playerid, dialogid, response, listitem, inputtext);
		case DIALOG_CW_WEAPON_CUSTOM: return CW::OnDialog(playerid, dialogid, response, listitem, inputtext);
		
  		case DIALOG_CWTCW_TYPE: return CW::OnDialog(playerid, dialogid, response, listitem, inputtext);
        case DIALOG_CWTCW_ROUNDS: return CW::OnDialog(playerid, dialogid, response, listitem, inputtext);
        case DIALOG_CWTCW_SCORE: return CW::OnDialog(playerid, dialogid, response, listitem, inputtext);
        case DIALOG_CWTCW_LOCATION: return CW::OnDialog(playerid, dialogid, response, listitem, inputtext);

 		case DIALOG_CWSDM_TYPE: return CW::OnDialog(playerid, dialogid, response, listitem, inputtext);
        case DIALOG_CWSDM_ROUNDS: return CW::OnDialog(playerid, dialogid, response, listitem, inputtext);
		case DIALOG_CWSDM_LOCATION: return CW::OnDialog(playerid, dialogid, response, listitem, inputtext);
  		case DIALOG_CW_TEAM: return CW::OnDialog(playerid, dialogid, response, listitem, inputtext);
    	case DIALOG_CW_ACCEPT: return CW::OnDialog(playerid, dialogid, response, listitem, inputtext);
        case DIALOG_CW_INVITE: return CW::OnDialog(playerid, dialogid, response, listitem, inputtext);
 	*/
	return 1;
}

