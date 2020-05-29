UpdatePlayerMarkers()
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(CW::IsPlaying(i))
	        CW::UpdateMarker(i);
		else if(Mini::IsPlaying(i))
		    Mini::UpdateMarker(i);
		else if(PlayerInfo[i][Hidden] == true)
		    Player::HideMarker(i);
		else if(PlayerInfo[i][Hidden] == false)
		    Player::ShowMarker(i);
	}
}

