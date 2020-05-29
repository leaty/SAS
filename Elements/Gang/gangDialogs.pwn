Gang__OnDialog(playerid, dialogid, response, listitem, const inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_GANG_DELETE:
		{
		    if(response)
		    {
		    	Player::OnDialogResponse(playerid);
		    	
    			new sWarning[128];
		        new gangid = PlayerInfo[playerid][GangID];
		        
		        SendGangMsg(gangid, COLOR_FALSE, "Your gang has been deleted by the gangowner, you've automatically left the gang.");

				for(new i = 0; i < MaxSlots; i++)
				{
				    if(PlayerInfo[i][GangID] == gangid)
				    {
			  			PlayerInfo[i][GangID] = 0;
						PlayerInfo[i][GangLevel] = GANG_LEVEL_NONE;
				    }
				    if(PlayerInfo[i][GangInvited] == gangid)
					{
				        PlayerInfo[i][GangInvited] = 0;
				        Format(sWarning, "* Gang %s has been deleted, you can no longer accept your invitation.", GangInfo[gangid][GangName]);
				        SendClientMessage(i, COLOR_FALSE, sWarning);
					}
				}

				Gang::DeleteGang(gangid);
          		SendClientMessage(playerid, COLOR_TRUE, "* Your gang has been successfully deleted.");
	  		}
		    else if(!response)
		    {
		        Player::OnDialogResponse(playerid);
		        
		        SendClientMessage(playerid, COLOR_FALSE, "* Deletion was canceled.");
		    }
		}
	}
	#pragma unused listitem, inputtext
	return 1;
}

