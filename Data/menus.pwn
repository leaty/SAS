new Menu:StartMenu;

Menus__Init()
{
	StartMenu = CreateMenu("Weapons",1,410,290,200,250);
	SetMenuColumnHeader(StartMenu,0,"~r~Choose a weapon");
	AddMenuItem(StartMenu,0,"Runnies (Tec9 INF)");
	AddMenuItem(StartMenu,0,"Runnies (Uzi INF)");
	AddMenuItem(StartMenu,0,"Walkies (Pump, unlimited)");
    AddMenuItem(StartMenu,0,"Walkies (Pump, limited)");
	AddMenuItem(StartMenu,0,"Walkies (Spas, unlimited)");
	AddMenuItem(StartMenu,0,"Walkies (Spas, limited");
	
}
