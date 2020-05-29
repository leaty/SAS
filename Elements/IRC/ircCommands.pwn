#define irc_alias(%1,%2,%3,%4); if ( strcmp( message[1], #%1, true, (%2) ) == 0 ) \
	{ \
		if ( ircLevel < %3 ) return IRC::AccessDenied(user); \
		if ( ( message[(%2)+1] == 0 ) && ( irccmd_%4(botid,recipient,user,"") ) \
		|| ( ( message[(%2)+1] == 32 ) && ( irccmd_%4(botid,recipient,user,message[(%2)+2]) ) ) ) return true; \
 	}

#define irc_command(%1,%2,%3); irc_alias(%1,%2,%3,%1);


GetIRCLevel(const sircLevel[])
{
	if(sircLevel[0] == '~')
	    return IRC_LEVEL_MANAGEMENT;
	    
	if(sircLevel[0] == '&')
	    return IRC_LEVEL_MANAGEMENT;

	if(sircLevel[0] == '@')
	    return IRC_LEVEL_ADMIN;

	if(sircLevel[0] == '%')
	    return IRC_LEVEL_MOD;

	if(sircLevel[0] == '+')
	    return IRC_LEVEL_VIP;

	if(sircLevel[0] == '-')
	    return IRC_LEVEL_NONE;

 	return IRC_LEVEL_NONE;
}

public IRC_OnUserSay(botid, recipient[], user[], host[], message[])
{
	if(message[0] != '!')
		return true;

    new sircLevel[1], ircLevel;
    IRC_GetUserChannelMode(botid, recipient, user, sircLevel); // Get the user's irc level
	ircLevel = GetIRCLevel(sircLevel); // Convert irc level to an integer level
	
	irc_command(fixbots,		7,			IRC_LEVEL_MANAGEMENT);
	
	if(strcmp(recipient, IRCBotNames[0], false, IRC_MAX_BOTNAME) == 0)
	{
	    irc_command(changepass,     10,         IRC_LEVEL_NONE);
	}
	else if(botid == IRCInfo[EchoConnection][0])
	{
	    // Management
	    irc_command(banexception,   12,         IRC_LEVEL_MANAGEMENT);
		irc_command(raw,			3,			IRC_LEVEL_MANAGEMENT);
		irc_command(gmx,            3,          IRC_LEVEL_MANAGEMENT);
		irc_command(ban,			3,			IRC_LEVEL_MANAGEMENT);
		irc_command(banip,			5,			IRC_LEVEL_MANAGEMENT);
		irc_command(unban,			5,			IRC_LEVEL_MANAGEMENT);
		irc_command(mysql,			5,			IRC_LEVEL_MANAGEMENT);
		irc_command(fakemsg,		7,			IRC_LEVEL_MANAGEMENT);
		irc_command(account,		7,			IRC_LEVEL_MANAGEMENT);
		irc_command(changelevel,    11,         IRC_LEVEL_MANAGEMENT);

		// Admin
		irc_command(addnote,		7,			IRC_LEVEL_ADMIN);
		irc_command(why,			3,			IRC_LEVEL_ADMIN);
		irc_command(set,			3,			IRC_LEVEL_ADMIN);
		irc_command(changenick,		10,			IRC_LEVEL_ADMIN);

		// Mod
		irc_command(say,			3,			IRC_LEVEL_MOD);
		irc_command(kick,			4,			IRC_LEVEL_MOD);
		irc_command(admin,			5,			IRC_LEVEL_MOD);

		// Vip

		// Normal
		irc_command(pm, 			2,			IRC_LEVEL_NONE);
		irc_command(msg, 			3,			IRC_LEVEL_NONE);
		irc_command(cmds,			4,			IRC_LEVEL_NONE);
		irc_command(commands,		8,			IRC_LEVEL_NONE);
		irc_command(getid,			5,			IRC_LEVEL_NONE);
		irc_command(players,		7,			IRC_LEVEL_NONE);
	}

	return true;
}

//=======================//
//========= End =========//
//=======================//
