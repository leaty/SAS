//==========================//
// IRC Bot Initialization   //
//==========================//

/*
IRC__Test(playerid)
{
	new sMessage[256];

	for(new i = 0; i < 6; i++)
	{
		Format(sMessage, "%d %s", IRCBotInfo[i][EchoConnection], IRCBotInfo[i][BotName]);
		SendClientMessage(playerid, COLOR_FALSE, sMessage);
	}
	
	return 1;
}*/

IRC__AccessDenied(user[])
{
	new Denied[128];
	Format(Denied, "* You do not have the required permissions to use this command.");
	IRC::SendNotice(user, Denied);
	return true;
}

IRC__SendNotice(const user[], const string[])
{
 	IRC_GroupNotice(IRCInfo[Group][IRC_GROUP_COMMAND], user, string);
	return 1;
}

IRC__SendEchoMsg(const string[])
{
    IRC_GroupSay(IRCInfo[Group][IRC_GROUP_ECHO], EchoChan, string);
    return 1;
}

IRC__SendDevMsg(const string[])
{
    IRC_GroupSay(IRCInfo[Group][IRC_GROUP_ECHO], DevChan, string);
    return 1;
}

IRC__SendChanMsg(channel[], const string[])
{
	IRC_GroupSay(IRCInfo[Group][IRC_GROUP_ECHO], channel, string);
	return 1;
}

IRC__SendAdminMsg(const string[])
{
    IRC_GroupSay(IRCInfo[Group][IRC_GROUP_ADMIN], AdminChan, string);
    return 1;
}

IRC__SendSOPMsg(const string[], const channel[])
{
    new sChannel[256];
    sChannel = IRC_SOP;
    strcat(sChannel, channel);
	IRC_GroupSay(IRCInfo[Group][IRC_GROUP_ADMIN],sChannel,string); // COMMAND GROUP because that bot is &
	return 1;
}

IRC__SendOPMsg(const string[], const channel[])
{
    new sChannel[256];
    sChannel = IRC_OP;
    strcat(sChannel, channel);
	IRC_GroupSay(IRCInfo[Group][IRC_GROUP_ADMIN],sChannel,string);
	return 1;
}

IRC__SendHOPMsg(const string[], const channel[])
{
    new sChannel[256];
    sChannel = IRC_HOP;
    strcat(sChannel, channel);
	IRC_GroupSay(IRCInfo[Group][IRC_GROUP_ADMIN],sChannel,string);
	return 1;
}

stock IsPlayerVoi(conn,channel[],user[])
{
	new ircLevel[4];
	IRC_GetUserChannelMode(conn, channel, user, ircLevel);
	if(!strcmp(ircLevel, "+", true, 1) == 0)
		return true;

	return false;
}

stock IsPlayerHop(conn,channel[],user[])
{
	new ircLevel[4];
	IRC_GetUserChannelMode(conn, channel, user, ircLevel);
	if(!strcmp(ircLevel, "%", true, 1) == 0)
		return true;

	return false;
}

stock IsPlayerOp(conn,channel[],user[])
{
	new ircLevel[4];
	IRC_GetUserChannelMode(conn, channel, user, ircLevel);
	if(!strcmp(ircLevel, "@", true, 1) == 0)
		return true;

	return false;
}

stock IsPlayerSop(conn, channel[], user[])
{
	new playerlevel[4];
	IRC_GetUserChannelMode(conn, channel, user, playerlevel);
	if(!strcmp(ircLevel, "~", true, 1) == 0)
		return true;

	return false;
}

stock IsPlayerOwner(conn, channel[], user[])
{
	new playerlevel[4];
	IRC_GetUserChannelMode(conn, channel, user, playerlevel);
	if(!strcmp(playerlevel, "~", true,1)) return true;
	return false;
}

stock copyEx(dest[],source[],count)
{
  dest[0]=0;
  if (count<0) return false;
  if (count>strlen(source)) count=strlen(source);
  new i=0;
  for (i=0;i<count;i++) {
	dest[i]=source[i];
	if (source[i]==0) return true;
  }
  dest[count]=0;
  return true;
}

stock strcompEx(str1[],str2[],bool:ignorecase)
{
	if ((!strlen(str1)) && (!strlen(str2))) return 1;
	if (!strlen(str1)) return 0;
	if (!strlen(str2)) return 0;
	if (strcmp(str1,str2,ignorecase) == 0)
	{
	    return 1;
	}
	return 0;
}

stock IsStringIP(string[])
{
	new icnt;
	new port;
	for(new i=0,j=strlen(string);i<j;i++){
		if(string[i] == '.') icnt++;
		else if(string[i] ==':') port++;
	}
	if(icnt == 3){
		if(port == 1) return 2;
		else if(port == 0) return 1;
	}
	return 0;
}




