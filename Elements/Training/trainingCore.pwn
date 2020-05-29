new T_Enter;

new T_Hour;
new T_Weather;

Training__Init()
{
	T_Enter = CreatePickup(1559, 1, 779.3582, -2852.7295, 5.6095, -1); // Training pickup at the door
	Create3DTextLabel("TRAINING MODE", COLOR_TITLE, 779.3582, -2852.7295, 5.6095, 40.0, WORLD_SELECTION);
	
	T_Hour = 12;
	
	return 1;
}

// Runs every second so don't add anything big in here or it might blowup
Training__Process()
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerAvailable(i))
	        continue;

		if(!IsTraining(i))
		    continue;

		SetPlayerTime(i, T_Hour, 00);
		SetPlayerWeather(i, T_Weather);
	}
}

Training__OnStart(playerid)
{
    PlayerInfo[playerid][T_StartTime] = Now();

	ClearPlayerChat(playerid);
	PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
	
	SetPlayerTime(playerid, T_Hour, 0);
	SetPlayerVirtualWorld(playerid, WORLD_TRAINING);
	SetPlayerMoney(playerid, 0);
	
	SendClientMessage(playerid, COLOR_TITLE, "* Welcome to the Training mode!");
	SendClientMessage(playerid, COLOR_INFO, "** SAS Gamemode is in an early Alpha stage, please report any bugs using /dev");
	SendClientMessage(playerid, COLOR_INFO, "** However, spamming /dev will result in a ban.");
	
	if(IsPlayer(playerid))
		Player::OnStart(playerid);
	if(IsMod(playerid))
 		Admin::OnStart(playerid);

	Gang::OnStart(playerid);
 		
	if(CW::IsRunning())
	{
	    if(CW::OnStart(playerid)) // Did the player disconnect during a cw? STOP HERE
			return 1;
	}

	SendClientMessage(playerid, COLOR_INFO, "* Please choose a weaponset.");

	if(!PlayerInfo[playerid][LastFC])
		FCHandler::Goto(playerid, 1);
	else
	    FCHandler::Goto(playerid, PlayerInfo[playerid][LastFC]);

	ShowMenuForPlayer(StartMenu, playerid);
	
	TogglePlayerControllable(playerid, 0);

	return 1;
}

Training__OnRespawn(playerid)
{
	SetPlayerVirtualWorld(playerid, WORLD_TRAINING);
    FCHandler::Goto(playerid, PlayerInfo[playerid][LastFC]);

   	if(!PlayerInfo[playerid][WeaponSet])
	{
		ShowMenuForPlayer(StartMenu,playerid);
		TogglePlayerControllable(playerid,0);
	}
	else if(PlayerInfo[playerid][WeaponSet] == 1)
	{
		Tec9(playerid,0);
	}
	else if(PlayerInfo[playerid][WeaponSet] == 2)
	{
		Uzi(playerid,0);
	}
	else if(PlayerInfo[playerid][WeaponSet] == 3)
	{
    	WalkiesPumpUnlimited(playerid,0);
	}
	else if(PlayerInfo[playerid][WeaponSet] == 4)
	{
    	WalkiesPumpLimited(playerid,0);
	}
	else if(PlayerInfo[playerid][WeaponSet] == 5)
	{
    	WalkiesSpasUnlimited(playerid,0);
	}
	else if(PlayerInfo[playerid][WeaponSet] == 6)
	{
    	WalkiesSpasLimited(playerid,0);
	}

	return 1;
}

Training__OnDeath(playerid, killerid, reason)
{
    new msg[128];
  	if (killerid != INVALID_PLAYER_ID)
	{
	    new Float:HP, Float:Arm;
	    GetPlayerHealth(killerid, HP);
		GetPlayerArmour(killerid, Arm);
	    FormatString("** %s %s %s (HP: %.1f Arm: %.1f) (Distance: %.1f ft) (Weapon: %s).", PlayerName(killerid), RandomKillMsg(), PlayerName(playerid), HP , Arm, GetDistanceBetweenPlayers(playerid, killerid), GetDeathReasonMsg(playerid, killerid, reason));
        SendClientMessageToAll(COLOR_DEATHMSG, string);
	}
	else
	{
		switch (reason)
		{
			case 53:
			{
				format(msg, sizeof(msg), "** %s died. (Drowned)", PlayerName(playerid));
			}
			case 54:
			{
				format(msg, sizeof(msg), "** %s died. (Collision)", PlayerName(playerid));
			}
			default:
			{
				format(msg, sizeof(msg), "** %s died.", PlayerName(playerid));
			}
		}
		SendClientMessageToAll(COLOR_DEATHMSG, msg);
	}
	
	return 1;
}

Training__OnText(playerid, const text[])
{
 	#pragma unused playerid, text
	return 1;
}

Training__OnUpdate(playerid)
{
	#pragma unused playerid
	return 1;
}

Training__OnPickup(playerid, pickupid)
{
	#pragma unused playerid, pickupid
	return 0;
}

Training__OnMenu(playerid, Menu:pmenu, row)
{
	if(pmenu == StartMenu)
	{
	    TogglePlayerControllable(playerid,1);
	    switch(row)
	    {
	        case 0: Tec9(playerid,1), PlayerInfo[playerid][WeaponSet] = 1;
	        case 1:
	        {
	            Uzi(playerid,1);
	            PlayerInfo[playerid][WeaponSet] = 2;
	        }
	        case 2:
	        {
	            WalkiesPumpUnlimited(playerid,1);
	            PlayerInfo[playerid][WeaponSet] = 3;
	        }
	        case 3:
	        {
	            WalkiesPumpLimited(playerid,1);
	            PlayerInfo[playerid][WeaponSet] = 4;
	        }
	        case 4:
	        {
	            WalkiesSpasUnlimited(playerid,1);
	            PlayerInfo[playerid][WeaponSet] = 5;
	        }
	        case 5:
			{
			    WalkiesSpasLimited(playerid,1);
			    PlayerInfo[playerid][WeaponSet] = 6;
			}
	    }
	    return 1;
	}
	return 0;
}

Training__OnDialog(playerid, dialogid, response, listitem, inputtext[])
{
	#pragma unused playerid, dialogid, response, listitem, inputtext
	return 0;
}

Training__Hour()
{
	T_Hour = 12;
}

Training__Weather()
{
	T_Weather = 10;
}

#include trainingCommands.pwn
#include trainingFunctions.pwn
#include Handlers/FC.pwn
