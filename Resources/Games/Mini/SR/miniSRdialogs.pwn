public Mini__SR_OnDialog(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_MINI_GAMES:
		{
		    // Setup
		    if(response)
		    {
		        MiniInfo[miniGame] = listitem;
		        MiniInfo[miniLocation] = 7; // set blueberry acres
		        MiniInfo[miniHardcore] = true;
		        Mini::StartSignup(playerid); // START THE SIGNUP
		    }
		    // Close
		    else if(!response)
		    {
				Mini::Reset();
		    }
		    
		    return 1;
		}
	}
	return 0;
}

