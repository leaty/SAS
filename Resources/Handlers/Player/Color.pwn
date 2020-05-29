UpdatePlayerColors()
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(CW::IsPlaying(i))
	        continue;
	        
 		if(IsGang(i))
	    {
			SetPlayerColor(i, playerColors[GangInfo[PlayerInfo[i][GangID]][ColorID]]);
	    }
	    else if(IsMod(i))
	    {
	        if(PlayerInfo[i][AdminLevel] == LEVEL_MOD)
				SetPlayerColor(i, playerColors[98]);
			else if(PlayerInfo[i][AdminLevel] > LEVEL_MOD)
				SetPlayerColor(i, playerColors[99]);
	    }
	    else
		{
		    SetPlayerColor(i, playerColors[i]);
  		}
	}
}

