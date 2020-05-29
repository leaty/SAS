#define MAX_PROPERTIES              300
#define MAX_PROPERTY_NAME           128

#define PROPERTY_SECURE_TIME        600

new Properties_Loaded;

enum PropertyData
{
	PropName[MAX_PROPERTY_NAME],
	Prize,
	Earn,
	PropPickup,
	TimeAtPurchase,
	Float:propX,
	Float:propY,
	Float:propZ,
	Ownerid,
	bool:Owned,
	bool:Secured,
};

new Properties[MAX_PROPERTIES][PropertyData];

Property__Init()
{
	new sMessage[256];
	
	if(!Property::Load())
	    Format(sMessage, "[PropertyHandler]: No existing Properties, initialization terminated.");
	else
	    Format(sMessage, "[PropertyHandler]: %d Properties were successfully loaded, initialization end.", Properties_Loaded);

	SendReport(sMessage);
	
	return 1;
}

// Runs every 2 minutes
Property__Process()
{
	new sMessage[128], EarnCount;

	for(new i = 0; i < MaxSlots; i++)
	{
	    EarnCount = 0;

	    if(!IsPlayerConnected(i))
			continue;

		for(new propid = 0; propid < Properties_Loaded; propid++)
		    if(Property::PlayerOwnProp(i, propid))
				EarnCount += Properties[propid][Earn];

		if(EarnCount > 0)
		{
		    GivePlayerMoney(i, EarnCount);
			Format(sMessage, "* You've earned $ %s with your properties.", ConvertMoney(EarnCount));
			SendClientMessage(i, COLOR_TRUE, sMessage);
		}
	}
}

Property__Create(playerid, propertyname[MAX_PROPERTY_NAME], prize, earn)
{
	new Float:X, Float:Y, Float:Z, sMessage[128], randpickup = random(3);

	if(randpickup == 0)
	    randpickup = 1272;
	else
		randpickup = 1273;
	
	GetPlayerPos(playerid, X, Y, Z);
	
	MySQL_Vars
	MySQL_Format("INSERT INTO %s (name, prize, earn, x, y, z) VALUES ('%s', %d, %d, %f, %f, %f)", Table_properties, MySQL::Escape(propertyname), prize, earn, X, Y, Z);
	MySQL_Query
	
	Properties_Loaded++;
	
	Properties[Properties_Loaded][PropName] = propertyname;
	Properties[Properties_Loaded][Prize] = prize;
	Properties[Properties_Loaded][Earn] = earn;
	Properties[Properties_Loaded][PropPickup] = CreatePickup(randpickup, 1, X, Y, Z, WORLD_FREEROAM);
	Properties[Properties_Loaded][propX] = X;
	Properties[Properties_Loaded][propY] = Y;
	Properties[Properties_Loaded][propZ] = Z;
	
	if(MySQL::ExistsRow(Table_properties, "name", propertyname))
	{
        Format(sMessage, "[PropertyHandler]: Property '%s' was successfully added to the database.", propertyname);
       	SendReport(sMessage);
       	return 1;
	}
	else
	{
		Format(sMessage, "[PropertyHandler]: Property '%s' failed to add to database!", propertyname);
		SendReport(sMessage);
	}

	return 0;
}

Property__Load()
{
	new iCount, propName[MAX_PROPERTY_NAME], result[256], randpickup = random(3);
	new Float:X, Float:Y, Float:Z;

	if(MySQL::CountRows(Table_properties) < 1)
	 	return 0; // If there are no properties in the database, stop!
	
	
	MySQL::ReOrderTable(Table_properties, "id");
	
	if(randpickup == 0)
	    randpickup = 1272;
	else
		randpickup = 1273;
	
	MySQL_Vars
	MySQL_Format("SELECT name, prize, earn, x, y, z FROM %s", Table_properties);
	MySQL_Query
	MySQL_Result
	
	MySQL_FetchMultiRows
	{
	    MySQL_FetchRow(propName, "name");
	    Properties[iCount][PropName] = propName;
	    
        MySQL_FetchRow(result, "prize");
        Properties[iCount][Prize] = strval(result);
        
        MySQL_FetchRow(result, "earn");
        Properties[iCount][Earn] = strval(result);

		MySQL_FetchRow(result, "x");
        X = floatstr(result);
       	Properties[iCount][propX] = X;

        MySQL_FetchRow(result, "y");
        Y = floatstr(result);
       	Properties[iCount][propY] = Y;
       	
        MySQL_FetchRow(result, "z");
        Z = floatstr(result);
       	Properties[iCount][propZ] = Z;
        
        Properties[iCount][PropPickup] = CreatePickup(randpickup, 1, X, Y, Z, WORLD_FREEROAM);
        
        iCount++;
	}
	
	Properties_Loaded = iCount;
	
	return 1;
}

Property__OnProp(playerid, pickupid)
{
	new sPropInfo[300];
	new propid = Property::GetPropID(pickupid);
	
	if(Property::IsPlayerAtProp(playerid, propid))
	{
		PlayerInfo[playerid][LastProp] = propid;
		
		if(Properties[propid][Owned] == true)
		{
		    if(Property::PlayerOwnProp(playerid, propid))
                Format(sPropInfo, "~g~%s~n~~g~You own this property~n~Sell it for $ %s using~n~/property sell", Properties[propid][PropName], ConvertMoney(Properties[propid][Earn]/2));
                
			else if(!Property::IsSecure(propid))
			    Format(sPropInfo, "~g~%s~n~~r~Owner: %s (%d)~n~~y~Prize: $ %s~n~Earnings: $ %s~n~Every 2 minutes", Properties[propid][PropName], PlayerName(Properties[propid][Ownerid]), Properties[propid][Ownerid], ConvertMoney(Properties[propid][Prize]), ConvertMoney(Properties[propid][Earn]));
			    
		    else
		    {
		        new timeowned = Now() - Properties[propid][TimeAtPurchase];
		    	Format(sPropInfo, "~g~%s~n~~r~Owner: %s (%d)~n~~y~Purchasable in approximately~n~%s", Properties[propid][PropName], PlayerName(Properties[propid][Ownerid]), Properties[propid][Ownerid], ConvertTime(PROPERTY_SECURE_TIME - timeowned));
			}
		}
		else
			Format(sPropInfo, "~g~%s~n~~y~Prize: $ %s~n~Earnings: $ %s~n~Every 2 minutes", Properties[propid][PropName], ConvertMoney(Properties[propid][Prize]), ConvertMoney(Properties[propid][Earn]));
			
		GameTextForPlayer(playerid, sPropInfo, 2500, 4);
	}

	return 1;
}

Property__OnCommand(playerid, params[])
{
	if(!Property::IsPlayerAtProp(playerid, PlayerInfo[playerid][LastProp]))
	    return SendClientMessage(playerid, COLOR_FALSE, "* You're not at a property, see '/help props'.");

	new sOption[50], sMessage[128], propid = PlayerInfo[playerid][LastProp];
	
	if(sscanf(params, "s", sOption))
	    return SendClientMessage(playerid, COLOR_USAGE, "Usage: /property [buy/sell]");
	    
	if(strcmp(sOption, "buy", true, 3) == 0)
	{
	    if(Property::PlayerOwnProp(playerid, propid))
		{
			Format(sMessage, "* You already own this property! Sell this property for $ %s using '/property sell'", ConvertMoney(Properties[propid][Prize]/2));
			SendClientMessage(playerid, COLOR_FALSE, sMessage);
		}
		else if(Property::IsSecure(propid))
		{
  			Format(sMessage, "* This property is owned by someone else, read '/help props' to see what you can do.");
  			SendClientMessage(playerid, COLOR_FALSE, sMessage);
		}
		else
		{
			if(GetPlayerMoney(playerid) < Properties[propid][Prize])
			    return SendClientMessage(playerid, COLOR_FALSE, "* You cannot afford this property.");
			    
			GivePlayerMoney(playerid, -Properties[propid][Prize]);
			    
			    
			Format(sMessage, "%s just bought property %s!", PlayerName(playerid), Properties[propid][PropName]);
			SendNews(sMessage);
			
			if(Properties[propid][Owned] == true)
			{
			    Format(sMessage, "* Your property '%s' has been purchased by another player!", Properties[propid][PropName]);
			    SendClientMessage(Properties[propid][Ownerid], COLOR_FALSE, sMessage);
			    SendClientMessage(Properties[propid][Ownerid], COLOR_FALSE, "* You will no longer earn money from this property.");
			}

			Properties[propid][Owned] = true;
			Properties[propid][Ownerid] = playerid;
			Properties[propid][TimeAtPurchase] = Now();
			
			PlayerInfo[playerid][TotalPropCount]++;
			
			Format(sMessage, "* Congratulations! You've just bought property '%s',", Properties[propid][PropName]);
			SendClientMessage(playerid, COLOR_TRUE, sMessage);
			Format(sMessage, "* you will earn $ %s per minute for this property.", ConvertMoney(Properties[propid][Earn]));
			SendClientMessage(playerid, COLOR_TRUE, sMessage);
			Format(sMessage, "* You should also know that your property is secured from purchase for %s!", ConvertTime(PROPERTY_SECURE_TIME));
			SendClientMessage(playerid, COLOR_TRUE, sMessage);
		}
	}
	else if(strcmp(sOption, "sell", true, 3) == 0)
	{
	    if(!Property::PlayerOwnProp(playerid, propid))
	        return SendClientMessage(playerid, COLOR_FALSE, "* You do not own this property.");
	        
		Properties[propid][Owned] = false;
		
		GivePlayerMoney(playerid, Properties[propid][Prize]/2);
		
		Format(sMessage, "%s just sold property %s!", PlayerName(playerid), Properties[propid][PropName]);
		SendNews(sMessage);
		
		Format(sMessage, "* You've just sold property '%s', you won't earn anything for this property anymore.", Properties[propid][PropName]);
		SendClientMessage(playerid, COLOR_TRUE, sMessage);
	}
	else SendClientMessage(playerid, COLOR_USAGE, "Usage: /property [buy/sell]");

	return 1;
}

freeroam_Property(playerid, params[])
    return Property::OnCommand(playerid, params);

freeroam_Prop(playerid, params[])
	return freeroam_Property(playerid, params);
	

Property__PickupIsProp(pickupid)
{
	for(new i = 0; Properties_Loaded; i++)
	    if(Properties[i][PropPickup] == pickupid)
	        return 1;
	
	return 0;
}

Property__IsSecure(propid)
{
	if(Now() - Properties[propid][TimeAtPurchase] > PROPERTY_SECURE_TIME)
	    return 0;
	    
	return 1;
}

Property__GetPropID(pickupid)
{
	for(new i = 0; Properties_Loaded; i++)
	    if(Properties[i][PropPickup] == pickupid)
	        return i;
	        
	return 0;
}

Property__GetPropName(propid)
{
	new propName[MAX_PROPERTY_NAME];
	
	if(propid > Properties_Loaded || propid < 0)
	{
	    propName = "None";
	    return propName;
	}

	Format(propName, "%s", Properties[propid][PropName]);

	return propName;
}

/*
Property__TextDrawInit()
{

	for(new i = 0; i < Properties_Loaded; i++)
	{
		Properties[i][PropDraw] = TextDrawCreate(482, 311, "~g~fucking work plz");
		TextDrawBackgroundColor(Properties[i][PropDraw], 255);
		TextDrawFont(Properties[i][PropDraw], 2);
		TextDrawLetterSize(Properties[i][PropDraw], 0.33, 1.5);
		TextDrawColor(Properties[i][PropDraw], -1);
		TextDrawSetOutline(Properties[i][PropDraw], 1);
		TextDrawSetProportional(Properties[i][PropDraw], 1);
	}
	
	
	PropDraw = TextDrawCreate(482, 311, "~g~fucking work plz");
	TextDrawBackgroundColor(PropDraw, 255);
	TextDrawFont(PropDraw, 2);
	TextDrawLetterSize(PropDraw, 0.33, 1.5);
	TextDrawColor(PropDraw, -1);
	TextDrawSetOutline(PropDraw, 1);
	TextDrawSetProportional(PropDraw, 1);

	return 1;
}
*/

Property__IsPlayerAtProp(playerid, propid)
{
	new Float:PropX = Properties[propid][propX],
		Float:PropY = Properties[propid][propY],
		Float:PropZ = Properties[propid][propZ];

	if(!IsPlayerAt(playerid, PropX, PropY, PropZ))
	    return 0;
	
	return 1;
}

Property__PlayerOwnProp(playerid, propid)
{
	if(Properties[propid][Owned] == false)
	    return 0;
	    
	if(Properties[propid][Ownerid] == playerid)
	    return 1;
	    
	return 0;
}

Property__OnReset(playerid)
{
	for(new i = 0; i < Properties_Loaded; i++)
	{
	    if(Property::PlayerOwnProp(playerid, i))
	    {
	        Properties[i][Owned] = false;
	        Properties[i][Ownerid] = -1;
	        Properties[i][TimeAtPurchase] = 0;
		}
	}
	
	return 1;
}

