#define TP_MONEY            			2500
#define CTP_MONEY           			5000
#define DIVE_MONEY          			2500
#define CARDIVE_MONEY                   5000
#define RAMPING_MONEY                   50000
#define VR_MONEY                        5000
#define VF_MONEY                        10000
#define NOS_MONEY                       10000

#define BANK_BASIC_MONEY                1000
#define BANK_BUSINESS_MONEY             100000
#define BANK_PROFESSIONAL_MONEY         1000000

#define AFFORD_NONSKIP             0
#define AFFORD_SKIP                1

#define MAX_F_SPAWNS        20

new F_Enter; // Pickup

new F_Hour;
new F_Weather;

new F_SFPD_HQ_ENTER; // Pickup
new F_SFPD_HQ_EXIT; // Pickup

new Float:F_Spawns[MAX_F_SPAWNS][4] =
{
	{ -1841.742553, 1087.542114, 46.078125, 0.998188 },
	{ -1987.080200, 1118.092407, 54.120059, 270.568634 },
	{ -2198.910400, 959.775085, 80.000000, 334.261016 },
	{ -2084.954589, 300.826934, 35.409236, 144.225051 },
	{ -1902.744140, 211.811630, 35.139583, 34.272968 },
	{ -1970.329101, 137.769393, 27.687500, 89.897865 },
	{ -2131.271484, 150.539993, 35.390663, 262.662689 },
	{ -2506.882812, 752.871948, 39.585937, 181.583755 },
	{ -2540.484375, 833.919799, 52.093750, 359.470672 },
	{ -2540.139892, 950.057556, 65.825706, 221.729736 },
	{ -2572.687255, 851.826354, 59.899650, 273.623138 },
	{ -2495.004394, 1002.676635, 78.359375, 270.204193 },
	{ -2493.626953, 1007.584777, 78.359375, 271.431427 },
	{ -2620.878662, 71.751998, 4.335937, 269.543640 },
	{ -2538.779052, -306.481903, 27.277915, 76.752403 },
	{ -2482.295898, -284.790069, 40.543792, 85.944229 },
	{ -2660.676025, 880.087341, 79.773796, 0.383084 },
	{ -2706.422607, 376.829071, 4.968332, 180.845108 },
	{ -2650.622558, 376.288940, 6.156250, 89.461494 },
	{ -2640.938720, 182.961196, 4.328989, 359.581298 }
};

new F_Spawns_Data[MAX_F_SPAWNS] =
{
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0
};

forward Freeroam_ExitSFPD(playerid);

Freeroam__Init()
{
	F_Enter = CreatePickup(1559, 1, 775.3981, -2856.2834, 5.6095, WORLD_SELECTION); // Freeroam pickup at the door
	Create3DTextLabel("FREEROAM MODE", COLOR_TITLE, 775.3981, -2856.2834, 5.6095, 40.0, WORLD_SELECTION);

	F_Hour = 12;
	
	Bank::Init();
	Property::Init();
	Loot::Init();
	
	// Pickups to enter/exit the SF Police Dept Interior
	F_SFPD_HQ_ENTER = CreatePickup(1559, 1, -1605.5327, 710.6368, 13.8672, WORLD_FREEROAM);
	F_SFPD_HQ_EXIT = CreatePickup(1559, 1, 246.4190, 107.0112, 1003.2257, WORLD_FREEROAM);
	
	return 1;
}

// Runs every 2 seconds so don't add anything big in here or it might blowup
Freeroam__Process()
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerAvailable(i))
	        continue;
	        
		if(!IsFreeroam(i))
		{
		    RemovePlayerMapIcon(i, MAPICON_F_SFPD);
			RemovePlayerMapIcon(i, MAPICON_F_BANK);
		    continue;
		}
		
		SetPlayerTime(i, F_Hour, 00);
		SetPlayerWeather(i, F_Weather);
		SetPlayerMapIcon(i, MAPICON_F_SFPD, -1592.2551, 694.4343, 48.9347, 30, 0);
		SetPlayerMapIcon(i, MAPICON_F_BANK, -1605.0851, 715.9724, 48.9375, 52, 0);
	}
}

Freeroam__OnStart(playerid)
{
	PlayerInfo[playerid][F_StartTime] = Now();

	ClearPlayerChat(playerid);
	PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
	SetPlayerTime(playerid, F_Hour, 0);

	Freeroam::RandomSpawn(playerid);
	
	SendClientMessage(playerid, COLOR_TITLE, "* Welcome to the Freeroam mode!");
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
	
	SetPlayerMoney(playerid, 250);

	GivePlayerWeapon(playerid, 28, 200); // UZI
	GivePlayerWeapon(playerid, 26, 80); // SAWNOFF
	GivePlayerWeapon(playerid, 31, 100); // M4

    return 1;
}

Freeroam__OnRespawn(playerid)
{
	SetPlayerMoney(playerid, 250);
	
	GivePlayerWeapon(playerid, 28, 200); // UZI
	GivePlayerWeapon(playerid, 26, 80); // SAWNOFF
	GivePlayerWeapon(playerid, 31, 100); // M4
	
    Freeroam::RandomSpawn(playerid);
    Loot::OnSpawn(playerid);

	return 1;
}

Freeroam__OnDeath(playerid, killerid, reason)
{
    new sMessage[256];
  	if (killerid != INVALID_PLAYER_ID)
	{
	    new Float:HP, Float:Arm;
	    GetPlayerHealth(killerid, HP);
		GetPlayerArmour(killerid, Arm);
	    Format(sMessage, "** You got %s by %s (HP: %.1f Arm: %.1f) (Distance: %.1f ft) (Weapon: %s).", RandomKillMsg(), PlayerName(killerid), HP , Arm, GetDistanceBetweenPlayers(playerid, killerid), GetDeathReasonMsg(playerid, killerid, reason));
        SendClientMessage(playerid, COLOR_DEATHMSG, sMessage);
        Format(sMessage, "** You %s %s (HP: %.1f Arm: %.1f) (Distance: %.1f ft) (Weapon: %s).", RandomKillMsg(), PlayerName(playerid), HP , Arm, GetDistanceBetweenPlayers(playerid, killerid), GetDeathReasonMsg(playerid, killerid, reason));
        SendClientMessage(killerid, COLOR_DEATHMSG, sMessage);
	}
	else
	{
		switch (reason)
		{
			case 53:
			{
				SendClientMessage(playerid, COLOR_DEATHMSG, "** You died. (Drowned)");
			}
			case 54:
			{
				SendClientMessage(playerid, COLOR_DEATHMSG, "** You died. (Collision)");
			}
			default:
			{
				SendClientMessage(playerid, COLOR_DEATHMSG, "** You died.");
			}
		}
	}
	
	Loot::OnDeath(playerid, killerid);

	return 1;
}

Freeroam__OnText(playerid, const text[])
{
    #pragma unused playerid, text
	return 1;
}

Freeroam__OnUpdate(playerid)
{
	Loot::OnUpdate(playerid);
	return 1;
}

Freeroam__OnPickup(playerid, pickupid)
{

	if(pickupid == F_SFPD_HQ_ENTER)
	{
		if(IsPlayerFighting(playerid, 15))
		    return SendClientMessage(playerid, COLOR_FALSE, "* You cannot enter San Fierro's Police Department because you've recently been to a gunfight.");

	    if(!IsPlayerAvailable(playerid))
	        return SendClientMessage(playerid, COLOR_FALSE, "* You cannot enter San Fierro's Police Department at this time, please try again later.");

		SetPlayerInterior(playerid, 10);
		SetPlayerPos(playerid, 246.5850, 113.0371, 1003.2188);
		SetPlayerFacingAngle(playerid, 359.8772);
		SetCameraBehindPlayer(playerid);
		
		SendClientMessage(playerid, COLOR_INFO, "* You've entered San Fierro's Police Department.");

		return 1;
	}

	if(pickupid == F_SFPD_HQ_EXIT)
	{
	    SetTimerEx("Freeroam_ExitSFPD", 1000, false, "%d", playerid);
		return 1;
	}

	if(Bank::PickupIsATM(pickupid))
	{
 		Bank::OnATM(playerid);
 		return 1;
	}
	
	if(Bank::PickupIsBank(pickupid))
	{
	    Bank::OnBank(playerid);
	    return 1;
	}

    if(Property::PickupIsProp(pickupid))
	{
    	Property::OnProp(playerid, pickupid);
		return 1;
	}
	
	return 0;
}

Freeroam__OnMenu(playerid, Menu:pmenu, row)
{
	if(Bank::OnMenu(playerid, pmenu, row))
		return 1;

	return 0;
}

Freeroam__OnDialog(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_LOOT:
		{
			Loot::OnDialog(playerid, response, listitem, inputtext);
			return 1;
		}
		case DIALOG_FREEROAM_SWITCHMODE:
		{
		    if(response)
		    {
     			PlayerInfo[playerid][Switchmode] = true;
				SendClientMessage(playerid, COLOR_INFO, "Returning to mode selection after next death");
		    }
		    return 1;
		}
	}

	return 0;
}

Freeroam__Hour()
{
	if(F_Hour == 23)
		F_Hour = 0;
	else
 		F_Hour++;
	
	return 1;
}

Freeroam__Weather()
{
	F_Weather = ValidWeathers[random(sizeof(ValidWeathers))];
}

#include freeroamCommands.pwn
#include freeroamFunctions.pwn
#include Handlers\Help.pwn
#include Handlers\Bank.pwn
#include Handlers\Property.pwn
#include Handlers\Loot.pwn

