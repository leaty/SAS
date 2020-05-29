public OnGameModeInit()
{
	print("\n");
	print("======================================");
	print("***=== SAS - San Andreas Splitmode ===***");
	print("======================================\n");
	
	MySQL::Connect();
	IRC::Connect();
	
	Server::Init();
	
	Timer::Init();
	Menus::Init();
	Player::Init();
	Admin::Init();
	
	if(ELEMENT_GANG)
		Gang::Init();

    Training::Init();
    Freeroam::Init();
	    
 	Games::Init();

	FCHandler::Init();
	Objects::Init();
	Pickups::Init();
	Vehicle::Init();
	News::Init();
	    
	UsePlayerPedAnims();
	AllowInteriorWeapons(1);
	
	new gmText[128];
	Format(gmText, "%s v%s.%s", GAMEMODE_TEXT, VERSION, BUILD);
	SetGameModeText(gmText);
	
	for ( new i = 0; i < sizeof ( ListPlayerClasses ); i++ )
	{
		AddPlayerClass(ListPlayerClasses[ i ], 775.3851, -2846.4758, 5.6095, 182.6404,0,0,0,0,0,0);
	}
	
	return 1;
}
