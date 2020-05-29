public OnPlayerUpdate(playerid)
{
	PlayerInfo[playerid][LastUpdate] = Now();

	if(PlayerInfo[playerid][Hardcore])
		Hardcore::Process(playerid);

	if(PlayerInfo[playerid][IsGod] == true)
	    Godmode::Process(playerid);
	    
	if(IsTraining(playerid))
	    Training::OnUpdate(playerid);
	    
	if(IsFreeroam(playerid))
	    Freeroam::OnUpdate(playerid);

	return 1;
}
