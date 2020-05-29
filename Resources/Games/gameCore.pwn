#define MAX_CW_LOCATIONS            20
#define MAX_SDM_LOCATIONS           20
#define MAX_SR_LOCATIONS            20

enum CWLocationData
{
	LocName[128],
	Float:Pos1[4],
	Float:Pos2[4],
	Float:Boundries[4]
};

enum SDMLocationData
{
	LocName[128],
	Float:Pos1[4],
	Float:Pos2[4],
	Float:Boundries[4]
};

enum SRLocationData
{
	DefSide, // Defender side, can be 1 or 2
	Float:MCOM[6]
};

new CWLocations[MAX_CW_LOCATIONS][CWLocationData];
new SDMLocations[MAX_SDM_LOCATIONS][SDMLocationData];
new SRLocations[MAX_SR_LOCATIONS][SRLocationData];
new CW_LocCount, SDM_LocCount;

Games__Init()
{

	Games::LoadLocations();

	if(GAMES_CLANWAR)
	    CW::Init();
	    
	if(GAMES_MINI)
	    Mini::Init();
}


Games__LoadLocations()
{
	new locCount, result[256];
	new iCount, sMessage[128];
	new i = 0;

	// CW
	locCount = MySQL::CountRows(Table_cw);

	CW_LocCount = locCount;

	if(locCount < 1)
 	{
	    SendReport("[GameHandler]: No existing CW locations.");
 	}
	else
	{
		MySQL_Vars

		MySQL_Format("SELECT * FROM %s", Table_cw);

		MySQL_Query
		MySQL_Result

		MySQL_FetchMultiRows
		{
		    MySQL_FetchRow(CWLocations[i][LocName], "name");

			MySQL_FetchRow(result, "x1");
			CWLocations[i][Pos1][0] = floatstr(result);

			MySQL_FetchRow(result, "y1");
			CWLocations[i][Pos1][1] = floatstr(result);

			MySQL_FetchRow(result, "z1");
			CWLocations[i][Pos1][2] = floatstr(result);

			MySQL_FetchRow(result, "ang1");
			CWLocations[i][Pos1][3] = floatstr(result);

			MySQL_FetchRow(result, "x2");
			CWLocations[i][Pos2][0] = floatstr(result);

			MySQL_FetchRow(result, "y2");
			CWLocations[i][Pos2][1] = floatstr(result);

			MySQL_FetchRow(result, "z2");
			CWLocations[i][Pos2][2] = floatstr(result);

			MySQL_FetchRow(result, "ang2");
			CWLocations[i][Pos2][3] = floatstr(result);

   			MySQL_FetchRow(result, "xmax");
			CWLocations[i][Boundries][0] = floatstr(result);

   			MySQL_FetchRow(result, "xmin");
			CWLocations[i][Boundries][1] = floatstr(result);

   			MySQL_FetchRow(result, "ymax");
			CWLocations[i][Boundries][2] = floatstr(result);

			MySQL_FetchRow(result, "ymin");
			CWLocations[i][Boundries][3] = floatstr(result);

			i++;
			iCount++;
		}
		MySQL_Free

		Format(sMessage, "[GameHandler]: %d/%d CW locations where loaded.", iCount, locCount);
		SendReport(sMessage);
	}
	// SDM

	i = 0;
	iCount = 0;
	locCount = MySQL::CountRows(Table_sdm);

    SDM_LocCount = locCount;

	if(locCount < 1)
	{
	    SendReport("[GameHandler]: No existing SDM locations.");
	}
	else
	{
	    MySQL_Vars


		MySQL_Format("SELECT * FROM %s", Table_sdm);

		MySQL_Query
		MySQL_Result

		MySQL_FetchMultiRows
		{
		    MySQL_FetchRow(SDMLocations[i][LocName], "name");

			MySQL_FetchRow(result, "x1");
			SDMLocations[i][Pos1][0] = floatstr(result);

			MySQL_FetchRow(result, "y1");
			SDMLocations[i][Pos1][1] = floatstr(result);

			MySQL_FetchRow(result, "z1");
			SDMLocations[i][Pos1][2] = floatstr(result);

			MySQL_FetchRow(result, "ang1");
			SDMLocations[i][Pos1][3] = floatstr(result);

			MySQL_FetchRow(result, "x2");
			SDMLocations[i][Pos2][0] = floatstr(result);

			MySQL_FetchRow(result, "y2");
			SDMLocations[i][Pos2][1] = floatstr(result);

			MySQL_FetchRow(result, "z2");
			SDMLocations[i][Pos2][2] = floatstr(result);

			MySQL_FetchRow(result, "ang2");
			SDMLocations[i][Pos2][3] = floatstr(result);

   			MySQL_FetchRow(result, "xmax");
			SDMLocations[i][Boundries][0] = floatstr(result);

   			MySQL_FetchRow(result, "xmin");
			SDMLocations[i][Boundries][1] = floatstr(result);

   			MySQL_FetchRow(result, "ymax");
			SDMLocations[i][Boundries][2] = floatstr(result);

   			MySQL_FetchRow(result, "ymin");
			SDMLocations[i][Boundries][3] = floatstr(result);
			i++;
			iCount++;
		}
		MySQL_Free

		Format(sMessage, "[GameHandler]: %d/%d SDM locations where loaded.", iCount, locCount);
		SendReport(sMessage);
	}
	
	SRLocations[7][DefSide] = 2;
	SRLocations[7][MCOM][0] = -90.815460205078;
	SRLocations[7][MCOM][1] = -37.612209320068;
	SRLocations[7][MCOM][2] = 2.1171875;
	SRLocations[7][MCOM][3] = 0.0;
	SRLocations[7][MCOM][4] = 0.0;
 	SRLocations[7][MCOM][5] = 339.59313964844;

	return 1;
}
	
Games::GetSDMLocationList()
{
	new iCount, LocList[256];

	for(new i = 0; i < SDM_LocCount; i++)
    {
		if(iCount == 0)
	        Format(LocList, "%s", SDMLocations[i][LocName]);
		else
			Format(LocList, "%s\r\n%s", LocList, SDMLocations[i][LocName]);

		iCount++;
    }
    
    return LocList;
}

Games::GetCWLocationList()
{
    new iCount, LocList[256];

	for(new i = 0; i < CW_LocCount; i++)
	{
	    if(iCount == 0)
	        Format(LocList, "%s", CWLocations[i][LocName]);
		else
			Format(LocList, "%s\r\n%s", LocList, CWLocations[i][LocName]);

		iCount++;
	}
	
	return LocList;
}



#include CW/cwCore.pwn
#include Mini/miniCore.pwn

