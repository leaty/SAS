new ServerRestart;

Server__Init()
{
	return 1;
}

Server__Exit(reason[])
{
    new sMessage[128];
	Admin::Exit();
	Player::Exit();
	CW::Exit();
	Spectate::Exit();
	Gang::Exit();
	
	ServerRestart = 5;
	
	Format(sMessage, "* Server will restart: %s", reason);
	SendClientMessageToAll(COLOR_FALSE, sMessage);
	
	SetTimer("Server_Restart", 1000, true);

	return 1;
}

forward Server_Restart();
public Server_Restart()
{
	if(ServerRestart > 0)
	{
	    new sMessage[128];
		Format(sMessage, "* Server restart (%d seconds).", ServerRestart);
		SendClientMessageToAll(COLOR_FALSE, sMessage);
		ServerRestart--;
	}
	else
	{
		SendClientMessageToAll(COLOR_FALSE, "* Saving, please wait...");
		SendRconCommand("gmx");
	}
}

Server__PlayerScores()
{
	for(new i = 0; i < MaxSlots; i++)
		if(IsPlayerConnected(i))
		    SetPlayerScore(i, GetPlayerMoney(i));
		
	return 1;
}

// Runs every 5 minutes
Server__Hour()
{
	Training::Hour();
	Freeroam::Hour();
}

// Runs every 10 minutes
Server__Weather()
{
	Training::Weather();
	Freeroam::Weather();
}

