public OnPlayerSelectedMenuRow(playerid, row)
{
	new Menu:pMenu = GetPlayerMenu(playerid);

	if ( ( IsTraining(playerid) )
	&& ( Training::OnMenu(playerid, pMenu, row) ) )
		return 1;
		
 	if ( ( IsFreeroam(playerid) )
	&& ( Freeroam::OnMenu(playerid, pMenu, row) ) )
		return 1;

	return 1;
}
