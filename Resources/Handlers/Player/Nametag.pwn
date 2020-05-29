UpdatePlayerTags()
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerConnected(i))
	        continue;
	        
	    if(CW::IsPlaying(i))
	        CW::UpdateTag(i);
		else if(Mini::IsPlaying(i))
			Mini::UpdateTag(i);
	    else if(PlayerInfo[i][Hidden] == true)
	        Player::HideTag(i);
		else if(PlayerInfo[i][Hidden] == false)
		    Player::ShowTag(i);
	}
}

