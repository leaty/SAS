cw_NL(playerid, params[])
{
	if(CWNLInfo[IsCreating] != -1 && CWNLInfo[IsCreating] != playerid)
	    return SendClientMessage(playerid, COLOR_FALSE, "* Someone is already creating a new cw location. Try again later.");

	new sParam[50];
	
	if(CWNLInfo[Step] == CW_NL_STEP_MODE)
	{
	    new iMode;
		if(sscanf(params, "d", iMode))
	    	return SendClientMessage(playerid, COLOR_USAGE, "Usage: /cw nl [mode: 0 = CW/TCW | 1 = SDM]");

		if(iMode == 0)
			CWNLInfo[cwMode] = CW_MODE_CW;
		else if(iMode == 1)
      		CWNLInfo[cwMode] = CW_MODE_SDM;
		else
			return SendClientMessage(playerid, COLOR_FALSE, "* Invalid mode.");

		SendClientMessage(playerid, COLOR_TRUE, "* Alright, begin with the location name.");
        SendClientMessage(playerid, COLOR_INFO, "* Usage: /cw nl [name]");

        CWNLInfo[IsCreating] = playerid;
		CWNLInfo[Step] = CW_NL_STEP_NAME;
	}
	else if(CWNLInfo[Step] == CW_NL_STEP_NAME)
	{
		if(sscanf(params, "s", sParam))
	    	return SendClientMessage(playerid, COLOR_USAGE, "Usage: /cw nl [name]");
	    	
		Format(CWNLInfo[LocName], "%s", sParam);
		
		SendClientMessage(playerid, COLOR_TRUE, "* Done! Now continue with the position for team 1.");
        SendClientMessage(playerid, COLOR_INFO, "* Usage: /cw nl setpos");
        
		CWNLInfo[Step] = CW_NL_STEP_POS1;
	}
	else if(CWNLInfo[Step] == CW_NL_STEP_POS1)
	{
		if(sscanf(params, "s", sParam))
	    	return SendClientMessage(playerid, COLOR_USAGE, "Usage: /cw nl setpos");
	    	
	    new Float:X, Float:Y, Float:Z, Float:Angle;

		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, Angle);

		CWNLInfo[Pos1][0] = X;
		CWNLInfo[Pos1][1] = Y;
		CWNLInfo[Pos1][2] = Z;
		CWNLInfo[Pos1][3] = Angle;
	    	
		SendClientMessage(playerid, COLOR_TRUE, "* Alright, use the same command to set the position for team 2.");
		
		CWNLInfo[Step] = CW_NL_STEP_POS2;
	}
 	else if(CWNLInfo[Step] == CW_NL_STEP_POS2)
	{
		if(sscanf(params, "s", sParam))
	    	return SendClientMessage(playerid, COLOR_USAGE, "Usage: /cw nl setpos");

	    new Float:X, Float:Y, Float:Z, Float:Angle;

		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, Angle);

		CWNLInfo[Pos2][0] = X;
		CWNLInfo[Pos2][1] = Y;
		CWNLInfo[Pos2][2] = Z;
		CWNLInfo[Pos2][3] = Angle;

		SendClientMessage(playerid, COLOR_TRUE, "* Done! Now for the boundaries, use the same command. Start with Max X.");

		CWNLInfo[Step] = CW_NL_STEP_B_XMAX;
	}
	else if(CWNLInfo[Step] == CW_NL_STEP_B_XMAX)
	{
		new Float:XBoundry, Float:YBoundry, Float:ZBoundry;
		
		GetPlayerPos(playerid, XBoundry, YBoundry, ZBoundry);
		
		CWNLInfo[Boundries][0] = XBoundry;
		
		SendClientMessage(playerid, COLOR_TRUE, "* Alright, now set Min X.");
		
		CWNLInfo[Step] = CW_NL_STEP_B_XMIN;
	}
	else if(CWNLInfo[Step] == CW_NL_STEP_B_XMIN)
	{
		new Float:XBoundry, Float:YBoundry, Float:ZBoundry;

		GetPlayerPos(playerid, XBoundry, YBoundry, ZBoundry);

		CWNLInfo[Boundries][1] = XBoundry;

		SendClientMessage(playerid, COLOR_TRUE, "* Alright, now set Max Y.");
		
		CWNLInfo[Step] = CW_NL_STEP_B_YMAX;
	}
	else if(CWNLInfo[Step] == CW_NL_STEP_B_YMAX)
	{
		new Float:XBoundry, Float:YBoundry, Float:ZBoundry;

		GetPlayerPos(playerid, XBoundry, YBoundry, ZBoundry);

		CWNLInfo[Boundries][2] = YBoundry;

		SendClientMessage(playerid, COLOR_TRUE, "* Alright, now set Min Y.");

		CWNLInfo[Step] = CW_NL_STEP_B_YMIN;
	}
	else if(CWNLInfo[Step] == CW_NL_STEP_B_YMIN)
	{
		new Float:XBoundry, Float:YBoundry, Float:ZBoundry;

		GetPlayerPos(playerid, XBoundry, YBoundry, ZBoundry);

		CWNLInfo[Boundries][3] = YBoundry;

		CW::SaveLocation();

        CWNLInfo[IsCreating] = -1;
		SendClientMessage(playerid, COLOR_TRUE, "* All done! Server needs a restart before this new location becomes available.");
	}
	return 1;
}

