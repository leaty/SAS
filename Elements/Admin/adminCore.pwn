Admin__Init()
{
	MySQL::ResetAutoIncrement(Table_users);
	MySQL::ReOrderTable(Table_users, "userid");

	return 1;
}

Admin__Exit()
{
	return 1;
}

Admin__OnDisconnect(playerid, reason)
{
	FormatString("* %s (ID: %d) has left the server (%s).", PlayerName(playerid), playerid, aDisconnectNames[reason]);
	SendClientMessageToAll(COLOR_HIDE, string);
	
	return 1;
}

Admin__OnStart(playerid)
{
    PlayerInfo[playerid][Switchmode] = false;
    PlayerInfo[playerid][SkinID] = GetPlayerSkin(playerid);
	return 1;
}

Admin__OnRespawn(playerid)
{

	if(IsNeutral(playerid)) // Isn't player in any mode?
		SetPlayerPos(playerid, 775.3851, -2846.4758, 5.6095), SetPlayerFacingAngle(playerid, 180);

	return 1;
}

Admin__OnDeath(playerid, killerid, reason)
{
	PlayerInfo[killerid][Kills]++;
	PlayerInfo[playerid][Deaths]++;
	#pragma unused reason
	return 1;
}

Admin__OnText(playerid, const text[])
{
    new sMessage[256], sFade[256];

	if(APM == true)
	{
		Format(sMessage, "{%06x}Admin %s: {%06x}%s", StripAlpha(0x5762EAFF), PlayerName(playerid), StripAlpha(0x57A0EEFF), text); // These colors will have nothing to do with anything else, thus undefined
		SendClientMessageToAll(COLOR_EMBED, sMessage);
	}
	else
	{
		if(IsMuted(playerid))
		{
			Format(sMessage, "* You're muted and cannot speak for another %d minutes.", PlayerInfo[playerid][MuteTime]);
		    SendClientMessage(playerid, COLOR_FALSE, sMessage);
		    return 0;
		}
		
		new ModeName[50];

		if(PlayerInfo[playerid][pMode] == MODE_TRAINING) ModeName = "Training";
		if(PlayerInfo[playerid][pMode] == MODE_FREEROAM) ModeName = "Freeroam";

	    Format(sFade, "[%s] %s (%d): %s", ModeName, PlayerName(playerid), playerid, text);
   		Format(sMessage, "{%06x}%d {%06x}%s: {%06x}%s", StripAlpha( COLOR_PLAYER_ID ), playerid, StripAlpha( GetPlayerColor(playerid) ), PlayerName(playerid), StripAlpha( COLOR_PLAYER_TEXT ), text); // These colors will have nothing to do with anything else, thus undefined
	    
		for(new i = 0; i < MaxSlots; i++)
		{
			if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
			{
			    SendClientMessage(i, COLOR_EMBED, sMessage);
			    continue;
			}

			if(i == playerid)
				continue;

	    	if((IsTraining(i) && IsFreeroam(playerid)) || (IsFreeroam(i) && IsTraining(playerid)))
		 		SendClientMessage(i, COLOR_FADE, sFade);
		}
 	}

	return 1;
}

#include adminFunctions.pwn
#include Commands\cmdManagement.pwn
#include Commands\cmdAdmin.pwn
#include Commands\cmdMod.pwn
#include Commands\cmdP.pwn
#include Commands\cmdS.pwn

