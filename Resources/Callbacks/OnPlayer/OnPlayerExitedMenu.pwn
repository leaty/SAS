public OnPlayerExitedMenu(playerid)
{
    TogglePlayerControllable(playerid, true);

	new Menu:pMenuExit = PlayerInfo[playerid][Menu];
	
	if(pMenuExit == ATMMenu_1 || pMenuExit == ATMMenu_2 || pMenuExit == ATMMenu_3)
	    return Bank::OnMenuExit(playerid);
	    
	return 1;
}
