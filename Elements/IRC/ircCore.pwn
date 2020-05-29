//#define IrcServer "204.8.223.240" * Used if gtanet is inaccessible

#define IRC_MAX_BOTNAME         	20


enum IRCData
{
	Group[3],
	EchoConnection[6]
};


new IRCInfo[IRCData];
new bool:IRC_Reconnect;
new IRCBotNames[IRC_MAX_BOTS][IRC_MAX_BOTNAME] =
{
#if TEST == 0
	// Takes care of commands
	{"SASBot"},

	// Chat messages
	{"iownu"},
	{"uowni"},
	
	// Admin messages
	{"iowni"},
	{"uownu"}

#else

	{"SASTest"}

#endif
};


forward IRC_ConnectBot(iBot);


IRC__Connect()
{
	new ConDelay = 1000;

	#if TEST == 0

		IRCInfo[Group][IRC_GROUP_ECHO] = IRC_CreateGroup();
		IRCInfo[Group][IRC_GROUP_ADMIN] = IRC_CreateGroup();
		IRCInfo[Group][IRC_GROUP_COMMAND] = IRC_CreateGroup();
	
	    for(new i = 0; i < IRC_MAX_BOTS; i++)
	    {
			SetTimerEx("IRC_ConnectBot", ConDelay, false, "d", i);
			ConDelay += 1000;
		}
		
	#else
	
		IRCInfo[Group][0] = IRC_CreateGroup();
		SetTimerEx("IRC_ConnectBot", ConDelay, false, "d", 0);
		
	#endif

	return true;
}

IRC__Disconnect()
{
	#if TEST == 0
	
	    IRC_Quit(IRCInfo[EchoConnection][0], "BAI");
		IRC_Quit(IRCInfo[EchoConnection][1], "BAI");
		IRC_Quit(IRCInfo[EchoConnection][2], "BAI");
		IRC_Quit(IRCInfo[EchoConnection][3], "BAI");
		IRC_Quit(IRCInfo[EchoConnection][4], "BAI");
		
	#else
	
		IRC_Quit(IRCInfo[EchoConnection][0], "BAI");

	#endif

    return 1;
}

public IRC_ConnectBot(iBot)
{
	IRCInfo[EchoConnection][iBot] = IRC_Connect(IrcServer, IrcPort, IRCBotNames[iBot], BotRealName, BotUserName, false, "localhost");
	return 1;
}

public IRC_OnConnect(botid)
{
	new rawtext[256];

	if(strlen(EchoChan) != 0)
		IRC_JoinChannel(botid, EchoChan);


	// If this is the public server, only connect one bot to dev chan so it can pipe out /dev messages.
	#if TEST == 0
	
		if(strlen(DevChan) != 0 && botid == IRCInfo[EchoConnection][1])
	    	IRC_JoinChannel(botid, DevChan, DevPass);
	    	
	#elseif TEST == 1
	
		if(strlen(DevChan) != 0)
	    	IRC_JoinChannel(botid, DevChan, DevPass);
	    	
	#endif
	
	    
	if(strlen(AdminChan) != 0)
		IRC_JoinChannel(botid, AdminChan, AdminPass);

	#if TEST == 0
	
		if(IRCInfo[EchoConnection][0] == botid) 		Format(rawtext, "mode %s +B", IRCBotNames[0]);
		else if(IRCInfo[EchoConnection][1] == botid) 	Format(rawtext, "mode %s +B", IRCBotNames[1]);
		else if(IRCInfo[EchoConnection][2] == botid) 	Format(rawtext, "mode %s +B", IRCBotNames[2]);
		else if(IRCInfo[EchoConnection][3] == botid) 	Format(rawtext, "mode %s +B", IRCBotNames[3]);
 		else if(IRCInfo[EchoConnection][4] == botid) 	Format(rawtext, "mode %s +B", IRCBotNames[4]);

	#else
	
 		Format(rawtext, "mode %s +B", IRCBotNames[0]);
	
	#endif

	IRC_SendRaw(botid, rawtext);

	Format(rawtext, "privmsg nickserv identify %s", BotPass);
	IRC_SendRaw(botid, rawtext);

	return 1;
}

public IRC_OnDisconnect(botid)
{
	IRC_RemoveFromGroup(IRCInfo[Group][IRC_GROUP_COMMAND], botid);
	IRC_RemoveFromGroup(IRCInfo[Group][IRC_GROUP_ADMIN], botid);
	IRC_RemoveFromGroup(IRCInfo[Group][IRC_GROUP_ECHO], botid);
	
	// Have we manually requested to reconnect the bots? STOP
	if(IRC_Reconnect == true)
	    return 1;
	
	#if TEST == 0
	
	 	if(IRCInfo[EchoConnection][0] == botid)			SetTimerEx("IRC_ConnectBot", 5000, false, "d", 0);
	  	else if(IRCInfo[EchoConnection][1] == botid)	SetTimerEx("IRC_ConnectBot", 5000, false, "d", 1);
 	  	else if(IRCInfo[EchoConnection][2] == botid)	SetTimerEx("IRC_ConnectBot", 5000, false, "d", 2);
	  	else if(IRCInfo[EchoConnection][3] == botid)	SetTimerEx("IRC_ConnectBot", 5000, false, "d", 3);
		else if(IRCInfo[EchoConnection][4] == botid)    SetTimerEx("IRC_ConnectBot", 5000, false, "d", 4);

	#else
	
	    SetTimerEx("IRC_ConnectBot", 5000, false, "d", 0);
	
	#endif

	return 1;
}

public IRC_OnJoinChannel(botid, channel[])
{
	#if TEST == 0
	
	    if(IRCInfo[EchoConnection][0] == botid)			IRC_AddToGroup(IRCInfo[Group][IRC_GROUP_COMMAND], botid);
		else if(IRCInfo[EchoConnection][1] == botid)	IRC_AddToGroup(IRCInfo[Group][IRC_GROUP_ECHO], botid);
		else if(IRCInfo[EchoConnection][2] == botid)	IRC_AddToGroup(IRCInfo[Group][IRC_GROUP_ECHO], botid);
		else if(IRCInfo[EchoConnection][3] == botid)	IRC_AddToGroup(IRCInfo[Group][IRC_GROUP_ADMIN], botid);
		else if(IRCInfo[EchoConnection][4] == botid)    IRC_AddToGroup(IRCInfo[Group][IRC_GROUP_ADMIN], botid);

	#else
	
	    IRC_AddToGroup(IRCInfo[Group][0], botid);

	#endif

	return 1;
}

public IRC_OnLeaveChannel(botid, channel[], message[])
{

    str_switch(channel)
    {
        str_case(EchoChan):
		{
			IRC_JoinChannel(botid, channel, ChanPass);
			return 1;
		}
        str_case(AdminChan):
		{
			IRC_JoinChannel(botid, channel, AdminPass);
			return 1;
		}
		str_case(DevChan):
		{
			IRC_JoinChannel(botid, channel, DevPass);
			return 1;
		}
	}
   
    IRC_Quit(botid, "brb :w");
   
	return 1;
}

public IRC_OnUserNotice(botid, recipient[], user[], host[], message[])
{
	if(strcmp(user,"NickServ", true) == 0 || strcmp(user,"ChanServ", true) == 0 || strcmp(user,"OperServ", true) == 0 || strcmp(user,"HostServ", true) == 0 || strcmp(user,"MemoServ", true) == 0 || strcmp(user,"BotServ", true) == 0)
	{
	    if(strlen(AdminChan) != 0)
	    {
	        new ircstring[256];
 			Format(ircstring, "<%s> %s", user, message);
			WriteToLog(LOG_IRC, ircstring);
		}
	}

	return 1;
}

public IRC_OnReceiveRaw(botid, message[])
{

	if (strfind(message, ":PING") != -1) return 1;
	if (strfind(message, ":VERSION") != -1) return 1;
	if (strfind(message, ":TIME") != -1) return 1;
	
	return 1;
}

public IRC_OnUserJoinChannel(botid, channel[], user[], host[])
{
	#pragma unused botid, channel, user, host
	return 1;
}

public IRC_OnUserLeaveChannel(botid, channel[], user[], host[], message[])
{
	
	#pragma unused botid, channel, user, host, message
	return 1;
}

public IRC_OnUserDisconnect(botid, user[], host[], message[])
{

	#pragma unused botid, user, host, message
	return true;
}

public IRC_OnUserNickChange(botid, oldnick[], newnick[], host[])
{
	
	#pragma unused botid, oldnick, newnick, host
	return true;
}

// OnPlayer
IRC__OnConnect(playerid)
{
	FormatIRC("%s*** %s has joined the server.", IRC_COLOR_TRUE, PlayerName(playerid));
	IRC::SendEchoMsg(ircstring);

	if(strlen(AdminChan) != 0)
	{
		new IP[256];
		GetPlayerIp(playerid,IP,256);
    	FormatIRC2("%s*** %s has joined the server. (%s)", IRC_COLOR_TRUE, PlayerName(playerid), IP);
    	IRC::SendAdminMsg(ircstring2);
	}
	return 1;
}

IRC__OnDisconnect(playerid, reason)
{
	FormatIRC("%s*** %s has left the server. (%s)", IRC_COLOR_FALSE, PlayerName(playerid), aDisconnectNames[reason]);
	IRC::SendEchoMsg(ircstring);

	if(strlen(AdminChan) != 0)
	{
		{
	    	new current = Now() - PlayerInfo[playerid][TimeAtConnect];
			FormatIRC2("%s*** %s has left the server. (%s) (%s)", IRC_COLOR_FALSE, PlayerName(playerid), aDisconnectNames[reason], ConvertTime(current));
			IRC::SendAdminMsg(ircstring2);
		}
	}
	return 1;
}

IRC__OnText(playerid, const text[])
{
	new ircstring[256];
	Format(ircstring, "%s%s%s(%d):%s%s %s", IRC_COLOR_NAME, IRC_BOLD, PlayerName(playerid), playerid, IRC_ENDBOLD, IRC_COLOR_TEXT, text);
	IRC::SendEchoMsg(ircstring);

	return 1;
}

IRC__OnSpawn(playerid)
{

	#pragma unused playerid
	return 1;
}

IRC__OnDeath(playerid, killerid, reason)
{
    new Float:X, Float:Y, Float:Z;
    new sMessage[128], sAdminMessage[256], CurrentZone[256];

	GetPlayerPos(playerid, X, Y, Z);
	CurrentZone = GetZoneName(X, Y, Z);

 	if (killerid != INVALID_PLAYER_ID)
	{
 		Format(sMessage, "%s*** %s %s %s. (%s)", IRC_COLOR_DEATH, PlayerName(killerid), aKillMsg[random(13)], PlayerName(playerid), GetDeathReasonMsg(playerid, killerid, reason));
 		Format(sAdminMessage, "%s (Distance: %.1f ft - Location: %s)", sMessage, GetDistanceBetweenPlayers(playerid,killerid), CurrentZone);
	}
	else
	{
		switch (reason)
		{
			case 53: { Format(sMessage, "%s*** %s died. (Drowned)", IRC_COLOR_DEATH, PlayerName(playerid)); }
			case 54: { Format(sMessage, "%s*** %s died. (Collision)", IRC_COLOR_DEATH, PlayerName(playerid)); }
			default: { Format(sMessage, "%s*** %s died.", IRC_COLOR_DEATH, PlayerName(playerid)); }
		}
		
		Format(sAdminMessage, "%s (Location: %s)", sMessage, CurrentZone);
	}

    if(strlen(EchoChan) != 0)
		IRC_GroupSay(IRCInfo[Group][IRC_GROUP_ECHO], EchoChan, sMessage);
		
	if(strlen(AdminChan) != 0)
		IRC_GroupSay(IRCInfo[Group][IRC_GROUP_ADMIN], AdminChan, sAdminMessage);

	return 1;
}


#include ircFunctions.pwn
#include ircCommands.pwn
#include Commands\Admin\ircManagement.pwn
#include Commands\Admin\ircAdmin.pwn
#include Commands\Admin\ircMod.pwn
#include Commands\Player\ircVip.pwn
#include Commands\Player\ircNormal.pwn
