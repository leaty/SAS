/*

	This file holds premade dialogs for a minigame, edit for your liking.
	Please go through it firmly, only use what's needed and what options you want for your minigame.

	Below shows the order of the current dialogs in this example minigame, '>' means (if previous == true) whilst '>>' means next section

	Respawn -> Score ->> Hardcore ->> Location

*/


public Mini__SDM_OnDialog(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_MINI_GAMES:
		{
		    // Setup
		    if(response)
		    {
		        MiniInfo[miniGame] = listitem;
          		Player::ShowDialog(playerid, DIALOG_MINI_RESPAWN, DIALOG_STYLE_LIST, "Respawn", "Respawn ON\nRespawn OFF", "Select", "Cancel");
		    }
		    // Close
		    else if(!response)
		    {
				Mini::Reset();
		    }
		    
		    return 1;
		}
	
	    case DIALOG_MINI_RESPAWN:
	    {
			// Select
			if(response)
			{
				if(listitem == 0)
				{
				    MiniInfo[miniRespawn] = true;
					Player::ShowDialog(playerid, DIALOG_MINI_SCORE, DIALOG_STYLE_INPUT, "Max Score", "Winning score? (min: 5 | max: 20)", "Done", "Back");
				}
				else
				{
				    MiniInfo[miniRespawn] = false;
					Player::ShowDialog(playerid, DIALOG_MINI_HARDCORE, DIALOG_STYLE_LIST, "Hardcore", "Hardcore ON\nHardcore OFF", "Select", "Back");
				}
			}
			// Cancel
			else if(!response)
			{
				Mini::Reset();
				SendClientMessage(playerid, COLOR_FALSE, "* Minigame was canceled.");
			}
			
			return 1;
		}
		
		case DIALOG_MINI_SCORE:
		{
		    // Done
		    if(response)
		    {
				if(!isNumeric(inputtext) || strval(inputtext) > MINI_SDM_MAX_SCORE || strval(inputtext) < MINI_SDM_MIN_SCORE)
				{
				    SendClientMessage(playerid, COLOR_FALSE, "* Invalid score.");
					Player::ShowDialog(playerid, DIALOG_MINI_SCORE, DIALOG_STYLE_INPUT, "Max Score", "Winning score? (min: 5 | max: 20)", "Done", "Back");
				}
				else
				{
					MiniInfo[miniScore] = strval(inputtext);
					Player::ShowDialog(playerid, DIALOG_MINI_HARDCORE, DIALOG_STYLE_LIST, "Hardcore", "Hardcore ON\nHardcore OFF", "Select", "Back");
				}
		    }
		    // Back
		    else if(!response)
		    {
                Player::ShowDialog(playerid, DIALOG_MINI_RESPAWN, DIALOG_STYLE_LIST, "Respawn", "Respawn ON\nRespawn OFF", "Select", "Cancel");
		    }
		    
		    return 1;
		}
		
		case DIALOG_MINI_HARDCORE:
		{
		    // Select
		    if(response)
		    {
		        if(listitem == 0)
		        	MiniInfo[miniHardcore] = true;
				else
				    MiniInfo[miniHardcore] = false;
				    
				Player::ShowDialog(playerid, DIALOG_MINI_LOCATION, DIALOG_STYLE_LIST, "Location", Games::GetSDMLocationList(), "Start!", "Back");
		    }
		    // Back
		    else if(!response)
		    {
                 Player::ShowDialog(playerid, DIALOG_MINI_RESPAWN, DIALOG_STYLE_LIST, "Respawn", "Respawn ON\nRespawn OFF", "Select", "Cancel");
		    }
		    
		    return 1;
		}
		
		case DIALOG_MINI_LOCATION:
		{
  			// Select
		    if(response)
		    {
				MiniInfo[miniLocation] = listitem;
				Mini::StartSignup(playerid); // START THE SIGNUP
		    }
		    // Back
		    else if(!response)
		    {
                 Player::ShowDialog(playerid, DIALOG_MINI_HARDCORE, DIALOG_STYLE_LIST, "Hardcore", "Hardcore ON\nHardcore OFF", "Select", "Back");
		    }
		    
		    return 1;
		}
	}
	return 0;
}

