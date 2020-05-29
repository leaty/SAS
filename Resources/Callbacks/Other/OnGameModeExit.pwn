public OnGameModeExit()
{
	IRC::Disconnect();
	MySQL::Disconnect();
	
	return 1;
}
