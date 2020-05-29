irccmd_say(conn, channel[], user[], params[])
{
	new Text[256];
	
	FormatString("%s !say <text>", IRC_USAGE);
	if(sscanf(params, "s", Text)) return IRC::SendNotice(user, string);
	
	FormatString2("Moderator %s on IRC: %s", user, Text);
	SendClientMessageToAll(COLOR_NOTICE, string2);

	#pragma unused conn, channel
	return 1;
}

irccmd_kick(conn, channel[], user[], params[])
{
    new reason[256],
		PlayerID;

    FormatString("%s !kick <command>", IRC_USAGE);
	if(sscanf(params, "ds", PlayerID, reason)) return IRC::SendNotice(user, string);

 	Player::Kick(PlayerID, user, reason);

	#pragma unused conn, channel
	return 1;
}

irccmd_admin(conn, channel[], user[], params[])
{
	new Message[256];
	
	FormatString("%s !admin <message>", IRC_USAGE);
	if(sscanf(params, "s", Message)) return IRC::SendNotice(user, string);
	
    SendAdminChatMsg(-1, user, Message);

    #pragma unused conn, channel
	return 1;
}
