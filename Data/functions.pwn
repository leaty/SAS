forward Float:GetDistanceBetweenPlayers(p1, p2);
forward Float:GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance);

#define ToUpper(%0) \
    (((%0) >= 'a' && (%0) <= 'z') ? ((%0) & ~0x20) : (%0))

#define ToLower(%0) \
    (((%0) >= 'A' && (%0) <= 'Z') ? ((%0) | 0x20) : (%0))

stock UpperToLower(string[])
{
	for(new i; i < strlen(string); i++)
 	{
	 	if ( string[i] > 64 && string[i] < 91 )
		 string[i] += 32;
	}
	return string;
}

// Function: ConvertTime
// Author: iou
// Notes: Converts seconds to a string of hours, minutes and seconds.
stock ConvertTime(seconds)
{
	new hours,mins,secs,string[100];
	hours = floatround(seconds / 3600);
	mins = floatround((seconds / 60) - (hours * 60));
	secs = floatround(seconds - ((hours * 3600) + (mins * 60)));
	
	if(hours >= 1) 		Format(string, "%d Hour(s)", hours);
	if(mins >= 1)
	{
	    if(strlen(string) > 0)
			Format(string, "%s %02d Mins", string, mins);
		else
		    Format(string, "%02d Mins", mins);
	}
	if(secs >= 1)
	{
	    if(strlen(string) > 0)
			Format(string, "%s %02d Secs", string, secs);
		else
		    Format(string, "%02d Secs", secs);
	}
	
	if(strlen(string) < 1)
		Format(string, "%d Secs", secs);
	
	return string;
}

stock TakePlayerMoney(playerid, money)
{
	GivePlayerMoney(playerid, -money);
	return 1;
}

// Function: RandomKillMsg
// Author: Kase
// Notes: Returns a string
stock RandomKillMsg()
{
	return aKillMsg[random(12)];
}

stock IsValidSkin(skinid)
{
	#define	MAX_BAD_SKINS   22

	new badSkins[MAX_BAD_SKINS] = {
		3, 4, 5, 6, 8, 42, 65, 74, 86,
		119, 149, 208, 265, 266, 267,
		268, 269, 270, 271, 272, 273, 289
	};

	if  (skinid < 0 || skinid > 299) return false;
	for (new i = 0; i < MAX_BAD_SKINS; i++) {
	    if (skinid == badSkins[i]) return false;
	}

	#undef MAX_BAD_SKINS
	return true;
}

stock GetComponentName(id)
{
	new CName[50];
	if(id == 1009) CName = "2x Nitrous";
	else if(id == 1008) CName = "5x Nitrous";
	else if(id == 1010) CName = "10x Nitrous";
	else if(id == 1082) CName = "Import (Wheels)";
	else if(id == 1085) CName = "Atomic (Wheels)";
	else if(id == 1096) CName = "Ahab (Wheels)";
	else if(id == 1097) CName = "Virtual (Wheels)";
	else if(id == 1098) CName = "Access (Wheels)";
	else if(id == 1025) CName = "Off road (Wheels)";
	else if(id == 1013) CName = "Round Fog Lamp";
	else if(id == 1020) CName = "Large exhaust";
	else if(id == 1021) CName = "Medium exhaust";
	else if(id == 1022) CName = "Small exhaust";
	else if(id == 1019) CName = "Twin exhaust";
	else if(id == 1006) CName = "Roof Scoop";
	else if(id == 1001) CName = "Win (Spoiler)";
	else if(id == 1003) CName = "Alpha (Spoiler)";
	else if(id == 1007) CName = "Side Skirt";
	else if(id == 1086) CName = "Bass Boost";
	else if(id == 1087) CName = "Hydraulics";
	else if(id == 1002) CName = "Drag (Spoiler)";
	else if(id == 1016) CName = "Worx (Spoiler)";
	else if(id == 1023) CName = "Fury (Spoiler)";
	else if(id == 1018) CName = "Upswept exhaust";
	else if(id == 1143) CName = "Oval Hood Vent";
	else if(id == 1145) CName = "Square Hood Vent";
	else if(id == 1024) CName = "Square Fog Lamps";
	else if(id == 1004) CName = "Champ Scoop";
	else if(id == 1015) CName = "Race (Spoiler)";
	else if(id == 1000) CName = "Pro (Spoiler)";
	else if(id == 1011) CName = "Race Scoop";
	else if(id == 1014) CName = "Champ (Spoiler)";
	else CName = "Unknown";
	return CName;
}

stock GetWeaponIDFromName(WeaponName[])
{
	new wid;
    if(IsNumeric(WeaponName))
    {
        wid = strval(WeaponName);
        return wid;
	}
	if(strfind("molotov",WeaponName,true)!=-1) return 18;
	for(new i = 0; i <= 46; i++)
	{
		switch(i)
		{
			case 0,19,20,21,44,45: continue;
			default:
			{
				new name[24];
				GetWeaponName(i,name,24);
				if(strfind(name,WeaponName,true)!=-1)
				return i;
			}
		}
	}
	return -1;
}

stock Float:GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);
	if (IsPlayerInAnyVehicle(playerid)) GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	else GetPlayerFacingAngle(playerid, a);
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
	return a;
}

public Float:GetDistanceBetweenPlayers(p1, p2)
{
	new Float:x1,Float:y1,Float:z1;
	new Float:x2,Float:y2,Float:z2;

	if(!IsPlayerConnected(p1) || !IsPlayerConnected(p2))
		return -1.00;


	GetPlayerPos(p1,x1,y1,z1);
	GetPlayerPos(p2,x2,y2,z2);

	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}


stock GetZoneName(Float:x, Float:y, Float:z)
{
	new name[MAX_ZONE_NAME] = "Unknown";
	if ((x == 0.0) && (y = 0.0)) return name;
	for (new zoneid = 0; zoneid < MAX_ZONES; zoneid++)
	{
	 if (IsInZone(x, y, z, zoneid))
		{
   			copyEx(name,zones[zoneid][zone_name],strlen(zones[zoneid][zone_name]));
   			return name;
		}
	}
	return name;
}

stock IsInZone(Float:x, Float:y, Float:z, zoneid)
{
 if(zoneid == -1) return 0;
 if(x >= zones[zoneid][zone_minx] && x < zones[zoneid][zone_maxx]
 && y >= zones[zoneid][zone_miny] && y < zones[zoneid][zone_maxy]
 && z >= zones[zoneid][zone_minz] && z < zones[zoneid][zone_maxz])
 {
 	return 1;
 }
 return 0;
}

stock SendNews(const news[])
{
	new newnews[256];
	
	format(newnews, sizeof(newnews), "[News] %s", news);
	SendClientMessageToAll(COLOR_NEWS, newnews);
	
	format(newnews, sizeof(newnews), "%s%s[News]%s %s", IRC_COLOR_TRUE, IRC_BOLD, IRC_ENDBOLD, news);
	IRC::SendEchoMsg(newnews);
	return 1;
}

stock SendReport(const reporttext[])
{

    FormatIRC("%s,1%s%s", IRC_COLOR_FALSE, IRC_BOLD, reporttext);

	for(new i = 0; i < MaxSlots; i++)
	{
		if(IsPlayerConnected(i) == 1 && IsPlayerAdmin(i))
		{
			SendClientMessage(i, COLOR_REPORT, reporttext);
		}
	}
	
	WriteToLog(LOG_HANDLER, reporttext);
	
	#if REPORT_HANDLERS == 1
		IRC::SendSOPMsg(ircstring, AdminChan);
	#endif
	
	return 1;
}

stock WriteToLog(const file[], const text[])
{
	new File:log=fopen(file, io_append);
	new output[256];
	format(output, sizeof(output), "%s\n", text);
 	fwrite(log, output);
    fclose(log);
    return 1;
}

stock MinutesToHours(Minutes)
{
	new string[128];
	new Hours, Mins, Multi;
	Hours = Minutes / 60;
	Multi = Hours * 60;
	Mins = Minutes - Multi;

	format(string, sizeof(string), "%d hours and %d minutes.", Hours, Mins);
	return string;
}

stock ConvertMoney(amount)
{
	new string[ 256 ],
	    str[ 50 ],
		j;

	format( str, sizeof( str ), "%d", amount );
	j = strlen( str ) - 4;

	for( new i = strlen( str ) - 1; i >= 0; i-- )
	{

	    format( str, sizeof( str ), "%d", amount );

	    if( i != j )
	        format( string, sizeof( string ), "%s%s", str[ i ], string );

		if( i == j )
		    format( string, sizeof( string ), "%s,%s", str[ i ], string ), j -= 3;

	    amount -= strval( str[ i ] );
	    amount /= 10;
	}

	return string;
}

stock bool:IsValidWeapon(weaponid)
{
	if(weaponid == 19 || weaponid == 20 || weaponid == 21 || weaponid < 0 || weaponid > 46) return false;
	return true;
}

stock GetDeathReasonMsg(playerid, killerid, reason)
{
    new reasonMsg[80];
	switch (reason)
	{
		case 0:
		{
			reasonMsg = "Unarmed";
		}
		case 1:
		{
			reasonMsg = "Brass Knuckles";
		}
		case 2:
		{
			reasonMsg = "Golf Club";
		}
		case 3:
		{
			reasonMsg = "Night Stick";
		}
		case 4:
		{
			reasonMsg = "Knife";
		}
		case 5:
		{
			reasonMsg = "Baseball Bat";
		}
		case 6:
		{
			reasonMsg = "Shovel";
		}
		case 7:
		{
			reasonMsg = "Pool Cue";
		}
		case 8:
		{
			reasonMsg = "Katana";
		}
		case 9:
		{
			reasonMsg = "Chainsaw";
		}
		case 10:
		{
			reasonMsg = "Dildo";
		}
		case 11:
		{
			reasonMsg = "Dildo";
		}
		case 12:
		{
			reasonMsg = "Vibrator";
		}
		case 13:
		{
			reasonMsg = "Vibrator";
		}
		case 14:
		{
			reasonMsg = "Flowers";
		}
		case 15:
		{
			reasonMsg = "Cane";
		}
		case 22:
		{
			reasonMsg = "Pistol";
		}
		case 23:
		{
			reasonMsg = "Silenced Pistol";
		}
		case 24:
		{
			reasonMsg = "Desert Eagle";
		}
		case 25:
		{
			reasonMsg = "Shotgun";
		}
		case 26:
		{
			reasonMsg = "Sawn-off Shotgun";
		}
		case 27:
		{
			reasonMsg = "Combat Shotgun";
		}
		case 28:
		{
		    if(IsPlayerInAnyVehicle(playerid))
		    {
		        if (GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
				{
				    reasonMsg = "Drive By (MAC-10)";
				}
				else
				{
				    reasonMsg = "MAC-10";
				}
			}
			else
			{
				reasonMsg = "MAC-10";
			}
		}
		case 29:
		{
		    if(IsPlayerInAnyVehicle(playerid))
		    {
		        if (GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
				{
				    reasonMsg = "Drive By (MP5)";
				}
				else
				{
				    reasonMsg = "MP5";
				}
			}
			else
			{
				reasonMsg = "MP5";
			}
		}
		case 30:
		{
			reasonMsg = "AK-47";
		}
		case 31:
		{
			if (GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
			{
				switch (GetVehicleModel(GetPlayerVehicleID(killerid)))
				{
					case 447:
					{
						reasonMsg = "Sea Sparrow Machine Gun";
					}
					default:
					{
						reasonMsg = "M4";
					}
				}
			}
			else
			{
				reasonMsg = "M4";
			}
		}
		case 32:
		{
		    if(IsPlayerInAnyVehicle(playerid))
		    {
		        if (GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
				{
				    reasonMsg = "Drive By (TEC-9)";
				}
				else
				{
				    reasonMsg = "TEC-9";
				}
			}
			else
			{
				reasonMsg = "TEC-9";
			}
		}
		case 33:
		{
			reasonMsg = "Rifle";
		}
		case 34:
		{
			reasonMsg = "Sniper Rifle";
		}
		case 37:
		{
			reasonMsg = "Fire";
		}
		case 38:
		{
			if (GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
			{
				switch(GetVehicleModel(GetPlayerVehicleID(killerid)))
				{
					case 425:
					{
						reasonMsg = "Hunter Machine Gun";
					}
					default:
					{
						reasonMsg = "Minigun";
					}
				}
			}
			else
			{
				reasonMsg = "Minigun";
			}
		}
		case 41:
		{
			reasonMsg = "Spraycan";
		}
		case 42:
		{
			reasonMsg = "Fire Extinguisher";
		}
		case 49:
		{
			reasonMsg = "Vehicle Collision";
		}
		case 50:
		{
			if (GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
			{
				switch(GetVehicleModel(GetPlayerVehicleID(killerid)))
				{
					case 417, 425, 447, 465, 469, 487, 488, 497, 501, 548, 563:
					{
						reasonMsg = "Helicopter Blades";
					}
					default:
					{
						reasonMsg = "Vehicle Collision";
					}
				}
			}
			else
			{
				reasonMsg = "Vehicle Collision";
			}
		}
		case 51:
		{
			if (GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
			{
				switch(GetVehicleModel(GetPlayerVehicleID(killerid)))
				{
					case 425:
					{
						reasonMsg = "Hunter Rockets";
					}
					case 432:
					{
						reasonMsg = "Rhino Turret";
					}
					case 520:
					{
						reasonMsg = "Hydra Rockets";
					}
					default:
					{
						reasonMsg = "Explosion";
					}
				}
			}
			else
			{
				reasonMsg = "Explosion";
			}
		}
		default:
		{
			reasonMsg = "Unknown";
		}
	}
	
	return reasonMsg;
}

stock CountSubStringByChar(const string[], const checker[])
{
	new subCount;
	for(new i = 0; i < strlen(string); i++)
 	{
 	    if(string[i] == checker[0])
			subCount++;
 	}
 	
 	return subCount;
}
/*----------------------------------------------------------------------------*-
Function:
	sscanf
Params:
	string[] - String to extract parameters from.
	format[] - Parameter types to get.
	{Float,_}:... - Data return variables.
Return:
	0 - Successful, not 0 - fail.
Notes:
	A fail is either insufficient variables to store the data or insufficient
	data for the format string - excess data is disgarded.

	A string in the middle of the input data is extracted as a single word, a
	string at the end of the data collects all remaining text.

	The format codes are:

	c - A character.
	d, i - An integer.
	h, x - A hex number (e.g. a colour).
	f - A float.
	s - A string.
	z - An optional string.
	pX - An additional delimiter where X is another character.
	'' - Encloses a litteral string to locate.
	u - User, takes a name, part of a name or an id and returns the id if they're connected.

	Now has IsNumeric integrated into the code.

	Added additional delimiters in the form of all whitespace and an
	optioanlly specified one in the format string.
-*----------------------------------------------------------------------------*/

stock sscanf(string[], format[], {Float,_}:...)
{
	#if defined isnull
		if (isnull(string))
	#else
		if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
	#endif
		{
			return format[0];
		}
	#pragma tabsize 4
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (string[stringPos] && string[stringPos] <= ' ')
	{
		stringPos++;
	}
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if ('0' <= ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return -1;
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					num = 0,
					ch = string[stringPos];
				do
				{
					stringPos++;
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						default:
						{
							return -1;
						}
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{

				new changestr[16], changepos = 0, strpos = stringPos;
				while(changepos < 16 && string[strpos] && string[strpos] != delim)
				{
					changestr[changepos++] = string[strpos++];
    				}
				changestr[changepos] = '\0';
				setarg(paramPos,0,_:floatstr(changestr));
			}
			case 'p':
			{
				delim = format[formatPos++];
				continue;
			}
			case '\'':
			{
				new
					end = formatPos - 1,
					ch;
				while ((ch = format[++end]) && ch != '\'') {}
				if (!ch)
				{
					return -1;
				}
				format[end] = '\0';
				if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
				{
					if (format[end + 1])
					{
						return -1;
					}
					return 0;
				}
				format[end] = '\'';
				stringPos = ch + (end - formatPos);
				formatPos = end + 1;
			}
			case 'u':
			{
				new
					end = stringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = string[++end]) && ch != delim)
				{
					if (num)
					{
						if ('0' <= ch <= '9')
						{
							id = (id * 10) + (ch - '0');
						}
						else
						{
							num = false;
						}
					}
				}
				if (num && IsPlayerConnected(id))
				{
					setarg(paramPos, 0, id);
				}
				else
				{
					#if !defined foreach
						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
						#define __SSCANF_FOREACH__
					#endif
					string[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - stringPos;
					foreach (Player, playerid)
					{
						GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, string[stringPos], true, id))
						{
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num)
					{
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					string[end] = ch;
					#if defined __SSCANF_FOREACH__
						#undef foreach
						#undef __SSCANF_FOREACH__
					#endif
				}
				stringPos = end;
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != delim)
					{
						setarg(paramPos, i++, ch);
					}
					if (!i)
					{
						return -1;
					}
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' ')
		{
			stringPos++;
		}
		while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' '))
		{
			stringPos++;
		}
		paramPos++;
	}
	do
	{
		if ((delim = format[formatPos++]) > ' ')
		{
			if (delim == '\'')
			{
				while ((delim = format[formatPos++]) && delim != '\'') {}
			}
			else if (delim != 'z')
			{
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}

