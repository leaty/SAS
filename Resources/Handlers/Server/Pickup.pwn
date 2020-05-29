new PickupMax;
new Pickups[MaxPickups];

Pickups__Init()
{
    PickupMax = MySQL::CountRows(Table_pickups);
	MySQL::ResetAutoIncrement(Table_pickups);
    MySQL::ReOrderTable(Table_pickups, "pickupid");

	if(PickupMax < 1)
	{
	    SendReport("[PickupHandler]: No existing Pickups, initialization terminated.");
	 	return 0; // If there are no pickups in the database, stop initializing.
	}

	new modelid[10], Typeid[10], strX[50], strY[50], strZ[50], worldid[10], iCount;

	MySQL_Vars
	MySQL_Format("SELECT modelid, \
						 typeid, \
				 		 x, \
					     y, \
					     z, \
						 worldid \
					     FROM %s", Table_pickups);
	
	MySQL_Query
	MySQL_Result

	MySQL_FetchMultiRows
	{
	    MySQL_FetchRow(modelid, "modelid");
	    MySQL_FetchRow(Typeid, "typeid");
	    MySQL_FetchRow(strX, "x");
	    MySQL_FetchRow(strY, "y");
	    MySQL_FetchRow(strZ, "z");
	    MySQL_FetchRow(worldid, "worldid");
	    
     	Pickups[iCount] = CreatePickup(strval(modelid), strval(Typeid), floatstr(strX), floatstr(strY), floatstr(strZ), strval(worldid));
     	
     	iCount++;
	}
	
	MySQL_Free
	
	FormatReport("[PickupHandler]: %d pickups were loaded.", PickupMax);
    SendReport(reportstring);
    
	return 1;
}

Pickups__Create(playerid, modelid)
{
	new Float:X, Float:Y, Float:Z;
	
	GetPlayerPos(playerid, X, Y, Z);
	
	MySQL_Vars_L
	MySQL_Format("INSERT INTO %s (modelid, typeid, x, y, z, worldid) VALUES (%d, 2, %f, %f, %f, -1)", Table_pickups, modelid, X, Y, Z);
	
	MySQL_Query
	
	CreatePickup(modelid, 2, X, Y, Z, -1);
	
	PickupMax++;
	
	return 1;
}
