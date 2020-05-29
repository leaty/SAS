Timer__Init()
{
	SetTimer("MilliSec",    10,         true);
	SetTimer("OneSec", 		1000, 		true);
	SetTimer("TwoSec", 		2000, 		true);
	SetTimer("FiveSec", 	5000, 		true);
	SetTimer("TenSec", 		10000,		true);
	
	SetTimer("HalfMin", 	30000, 		true);
	SetTimer("OneMin", 		60000, 		true);
	SetTimer("TwoMin", 		120000, 	true);
	SetTimer("FiveMin", 	300000, 	true);
	SetTimer("TenMin", 		600000, 	true);
	
	SetTimer("HalfHour",	1800000, 	true);
	SetTimer("OneHour",		3600000, 	true);
	
	return 1;
}

forward MilliSec();
forward OneSec();
forward TwoSec();
forward FiveSec();
forward TenSec();
forward HalfMin();
forward OneMin();
forward TwoMin();
forward FiveMin();
forward TenMin();
forward HalfHour();
forward OneHour();

public MilliSec()
{

}

public OneSec()
{
	Player::Process();
	Freeroam::Process();
	Training::Process();
	Mini::Process();
}

public TwoSec()
{
	UpdatePlayerColors();
	UpdatePlayerMarkers();
	UpdatePlayerTags();
	
	Ramping::Process();
}

public FiveSec()
{
	Server::PlayerScores();
}

public TenSec()
{
}

public HalfMin()
{
}

public OneMin()
{
	Mute::Process();
	Jail::Process();
}

public TwoMin()
{
	Property::Process();
}

public FiveMin()
{
	News::Process();
	Server::Hour();
}

public TenMin()
{
    Server::Weather();
}

public HalfHour()
{
}

public OneHour()
{
	Gang::UpdateGangs();
}
