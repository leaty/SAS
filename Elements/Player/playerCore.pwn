#define IDLE_TIME           10

enum PlayerData
{
	Registered,
	LoggedIn,
	LoginTries,
	Started,
	
	TimeAtConnect,
	PlayTime,
	
	F_StartTime,
	F_Time,
	
	T_StartTime,
	T_Time,
	
	AdminLevel,
	
	pMode,
	PlayerIP[20],
	WeaponSet,
	SkinID,
	
	LastUpdate,
	LastFC,
	LastProp,
	LastShot,
	LastPM,
	
	BankLevel,
	BankValue,
	
	TotalPropCount,
	TotalLootCount,
	
	Dialog,
	Menu:Menu,

	Ramp,
	Rampid,
	bool:Ramping,
	bool:VehFunct,
	bool:Hax,
	bool:Frozen,
	bool:Muted,
	bool:Jailed,
	bool:Spectating,
	bool:Paralyzed,
	bool:IsGod,
	bool:OnATM,
	bool:Hidden,
	bool:Switchmode,

	MuteTime,
	JailTime,
	OldMuteTime,
	OldJailTime,
	
	SpecID,

	Kills,
	Deaths,

	GangID,
	GangName[6],
	GangLevel,
	GangInvited,
	
	Hardcore,
	Float:HC_HP,
	Float:HC_ARM
};

new PlayerInfo[MaxSlots][PlayerData];

Player__Init()
{
	MySQL::ResetAutoIncrement(Table_users);
	MySQL::ReOrderTable(Table_users, "userid");

	return 1;
}

Player__Exit()
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(IsPlayerConnected(i))
			Player::UpdateData(i);
	}
	return 1;
}

// Runs every second
Player__Process()
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerConnected(i))
			continue;
		    
		if(!IsIdling(i) && PlayerInfo[i][Started])
		{
		    PlayerInfo[i][PlayTime]++;

			if(IsTraining(i))
			    PlayerInfo[i][T_Time]++;
			if(IsFreeroam(i))
			    PlayerInfo[i][F_Time]++;
		}
	}
	
	return 1;
}

Player__OnConnect(playerid)
{
	new sMessage[256];
	
	Player::ResetInfo(playerid);
	
	PlayerInfo[playerid][TimeAtConnect] = Now();

	Format(sMessage, "* %s (ID: %d) has joined the server.", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_HIDE, sMessage);
	
	GetPlayerIp(playerid, PlayerInfo[playerid][PlayerIP], 20);

	// If account exists, set registered to 1
	if(Player::ExistsPlayer(PlayerName(playerid)))
		PlayerInfo[playerid][Registered] = TRUE;
	else
		PlayerInfo[playerid][Registered] = FALSE;

	
	if(Player::IsBan(playerid))
	    return Player::Ban(playerid, "Server", "Evading");

	if(!PlayerInfo[playerid][Registered])
	{
		Format(sMessage, "* Welcome to San Andreas Splitmode %s, please select your desired skin to begin.", PlayerName(playerid));
		SendClientMessage(playerid, COLOR_TITLE, sMessage);
		SendClientMessage(playerid, COLOR_INFO, "** Idea & Gamemode by iou & Lithirm.");
		SendClientMessage(playerid, COLOR_INFO, "** Sponsored by tHO (www.teamoutlaws.net).");
	}
	else
	{
 		Format(sMessage, "* Welcome back to San Andreas Splitmode %s!", PlayerName(playerid));
		SendClientMessage(playerid, COLOR_TITLE, sMessage);
		SendClientMessage(playerid, COLOR_INFO, "** Idea & Gamemode by iou & Lithirm.");
		SendClientMessage(playerid, COLOR_INFO, "** Sponsored by tHO (www.teamoutlaws.net).");

		PlayerInfo[playerid][SkinID] = GetUserSkin(playerid);
	}
	
	return 1;
}

Player__OnDisconnect(playerid, reason)
{
	FormatString("* %s (ID: %d) has left the server (%s).", PlayerName(playerid), playerid, aDisconnectNames[reason]);
	SendClientMessageToAll(COLOR_HIDE, string);

	return 1;
}

Player__OnRespawn(playerid)
{
	if(IsNeutral(playerid)) // Isn't player in any mode?
		SetPlayerPos(playerid, 775.3851, -2846.4758, 5.6095), SetPlayerFacingAngle(playerid, 180);

	return 1;
}

Player__OnStart(playerid)
{
    PlayerInfo[playerid][Switchmode] = false;
	PlayerInfo[playerid][SkinID] = GetPlayerSkin(playerid);
	return 1;
}

Player__OnDeath(playerid, killerid, reason)
{
	PlayerInfo[killerid][Kills]++;
	PlayerInfo[playerid][Deaths]++;
	
	#pragma unused reason
	return 1;
}

Player__OnText(playerid, const text[])
{
    new sMessage[128], sFade[256];

	if(IsMuted(playerid))
	{
		Format(sMessage, "* You're muted and cannot speak for another %d minutes.", PlayerInfo[playerid][MuteTime]);
	    SendClientMessage(playerid, COLOR_FALSE, sMessage);
	    return 0;
	}
	
	new ModeName[50];

	if(PlayerInfo[playerid][pMode] == MODE_TRAINING) ModeName = "Training";
	if(PlayerInfo[playerid][pMode] == MODE_FREEROAM) ModeName = "Freeroam";

    Format(sFade, 	 "[%s] %s (%d): %s", 	  ModeName, PlayerName(playerid), playerid, text);
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
	return 1;
}

Player__OnFire(playerid)
{
    if(GetPlayerWeapon(playerid) >= 16)
        PlayerInfo[playerid][LastShot] = Now();

    if(CW::IsPlaying(playerid))
		CW::OnFire(playerid);
		
	if(Mini::IsPlaying(playerid))
	    Mini::OnFire(playerid);
    
	return 1;
}

#include playerFunctions.pwn
#include playerCommands.pwn

