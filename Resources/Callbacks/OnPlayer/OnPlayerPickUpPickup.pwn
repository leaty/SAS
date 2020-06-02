public OnPlayerPickUpPickup(playerid, pickupid)
{
    if(pickupid == T_Enter) // Training pickup at the door
    {
		if(!ELEMENT_TRAINING)
        	return SendClientMessage(playerid, COLOR_FALSE, "* Training mode is currently closed.");

 		
		PlayerInfo[playerid][pMode] = MODE_TRAINING;

		Player::ShowDialog(playerid, DIALOG_MODE, DIALOG_STYLE_MSGBOX, "Training Mode", "* Mode features:\n \
			\n  ** Duel in a fairfight between you and your mates! \
			\n  ** Several different fighting locations by using /fc [id] \
			\n  ** Summary: Train your DM skills, FAIRLY.\n \
			\n* Are you sure you want to play this mode?", "Yes", "No");
		

		return 1;
    }
    
    if(pickupid == F_Enter) // Freeroam pickup at the door
    {
        if(!ELEMENT_FREEROAM)
        	return SendClientMessage(playerid, COLOR_FALSE, "* Freeroam mode is currently closed.");

		PlayerInfo[playerid][pMode] = MODE_FREEROAM;
		
		Player::ShowDialog(playerid, DIALOG_MODE, DIALOG_STYLE_MSGBOX, "Freeroam Mode", "* Mode features:\n \
			\n  ** Buy properties to earn your income! \
			\n  ** Bank your money in order to keep it! \
			\n  ** Fight on the streets of San Fierro or cruise/stunt with your mates! \
			\n  ** Summary: Freeroam!\n \
			\n* Are you sure you want to play this mode?", "Yes", "No");

		return 1;
    }
    

	if( ( IsFreeroam(playerid) )
	&& ( Freeroam::OnPickup(playerid, pickupid) ) )
	    return 1;
    
   	if( ( IsTraining(playerid) )
	&& ( Training::OnPickup(playerid, pickupid) ) )
	    return 1;


	return 1;
}
