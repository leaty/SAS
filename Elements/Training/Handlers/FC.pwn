#define MaxFightAreas 			100
#define MAX_FC_NAME             256

enum FCData
{
	fcName[MAX_FC_NAME],
	Float:fcX,
	Float:fcY,
	Float:fcZ,
	Float:fcAngle,
	fcInterior
};
new FCInfo[MaxFightAreas][FCData];


FCHandler__Init()
{
    MySQL::ResetAutoIncrement(Table_fc);
	MySQL::ReOrderTable(Table_fc, "fcid");

	FCMax = MySQL::CountRows(Table_fc);
	
	if(FCMax < 1)
	{
	    SendReport("[FCHandler]: No existing FightClubs, initialization terminated.");
	 	return 0; // If there are no fcs, stop initializing.
	}
	
	new strX[50], strY[50], strZ[50], strAngle[50], strInterior[50];
	new FCName[MAX_FC_NAME];

	for(new i = 1; i < FCMax + 1; i++)
	{
		MySQL_Vars
		MySQL_Format("SELECT fcname, \
							 x, \
					 		 y, \
						     z, \
							 angle, \
							 interior \
						     FROM %s WHERE fcid = %d", Table_fc, i);
		
		
		MySQL_Query
 		MySQL_Result

		MySQL_FetchPrepare
		{
		    
		    MySQL_FetchRow(FCName, "fcname");
		    MySQL_FetchRow(strX, "x");
		    MySQL_FetchRow(strY, "y");
		    MySQL_FetchRow(strZ, "z");
		    MySQL_FetchRow(strAngle, "angle");
		    MySQL_FetchRow(strInterior, "interior");
		}

		MySQL_Free
		
		FCInfo[i][fcName] = FCName;
		FCInfo[i][fcX] = floatstr(strX);
		FCInfo[i][fcY] = floatstr(strY);
		FCInfo[i][fcZ] = floatstr(strZ);
		FCInfo[i][fcAngle] = floatstr(strAngle);
		FCInfo[i][fcInterior] = strval(strInterior);

		FormatString("[FCHandler]: %s - X: %f Y: %f Z: %f Angle: %f Interior: %d", FCInfo[i][fcName], FCInfo[i][fcX], FCInfo[i][fcY], FCInfo[i][fcZ], FCInfo[i][fcAngle], FCInfo[i][fcInterior]);
		SendReport(string);
	}
	
	FormatReport("[FCHandler]: %d FightClubs were loaded, initialization end.", FCMax);
	SendReport(reportstring);
	
	return 1;
}

FCHandler__Create(const FCName[MAX_FC_NAME], playerid)
{
	new Float:X, Float:Y, Float:Z, Float:Angle, Interior;
	new countFC;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, Angle);
	Interior = GetPlayerInterior(playerid);
	
	//Save to database
	MySQL_Vars_L
	MySQL_Format("INSERT INTO %s (fcname, x, y, z, angle, interior) VALUES ('%s', %f, %f, %f, %f, %d)", Table_fc, FCName, X, Y, Z, Angle, Interior);

	
	MySQL_Query

	MySQL_Free
	
	countFC = MySQL::CountRows(Table_fc);
	
	if(countFC == FCMax + 1)
	{
	    FormatReport("[FCHandler]: FC %s was successfully added to the database.", FCName);
	    SendReport(reportstring);
	    
	    FCInfo[countFC][fcName] = FCName;
   		FCInfo[countFC][fcX] = X;
		FCInfo[countFC][fcY] = Y;
		FCInfo[countFC][fcZ] = Z;
		FCInfo[countFC][fcAngle] = Angle;
		FCInfo[countFC][fcInterior] = Interior;
	    
	    FCMax = countFC;
	    return 1;
	}
	else
	{
 		FormatReport("[FCHandler]: Failed to add FC %s to the database.", FCName);
	    SendReport(reportstring);
	    return 0;
	}
}

FCHandler__Goto(playerid, FCNumber)
{
	if(FCNumber < 1 || FCNumber > FCMax) FCNumber = 1;

	if(strlen(FCInfo[FCNumber][fcName]) < 1)
	{
		FormatReport("[FCHandler]: fcid %d does not exist, but was counted into FCMax.", FCNumber);
		SendReport(reportstring);
		
		SendClientMessage(playerid, COLOR_FALSE, "* This FightClub has been deleted, or does not exist.");
		return 0;
	}
	
	new sMessage[128];
	
	PlayerInfo[playerid][LastFC] = FCNumber;
	
	SetPlayerPos(playerid, FCInfo[FCNumber][fcX], FCInfo[FCNumber][fcY], FCInfo[FCNumber][fcZ]);
	SetPlayerFacingAngle(playerid, FCInfo[FCNumber][fcAngle]);
	SetPlayerInterior(playerid, FCInfo[FCNumber][fcInterior]);
	SetCameraBehindPlayer(playerid);
	
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 100);
	
	Format(sMessage, "* You've been teleported to '%s' (ID: %d)!", FCInfo[FCNumber][fcName], FCNumber);
	SendClientMessage(playerid, COLOR_TRUE, sMessage);

	return 1;
}


