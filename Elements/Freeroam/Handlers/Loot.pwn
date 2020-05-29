#define LOOT_LISTITEM_MONEY           		0
#define LOOT_LISTITEM_PROPERTY        1
#define LOOT_LISTITEM_WEAPON          2

enum pLootData
{
 	iallowed,
 	ilooting,
 	bool:dead,
 	bool:looting,
	Float:dposX,
	Float:dposY,
	Float:dposZ,
	
	lootMoney,
	lootProperty,
	lootWeapon,
	lootAmmo
	
};

new pLootInfo[MaxSlots][pLootData];


Loot__Init()
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    pLootInfo[i][iallowed] = -1;
	    pLootInfo[i][dead] = false;
	}
	
	return 1;
}

Loot__OnBody(playerid, bodyid)
{
	new sCaption[128], sItems[256], WepName[50];
	
	GetWeaponName(pLootInfo[playerid][lootWeapon], WepName, sizeof(WepName));

	Format(sCaption, "Looting %s's pockets..", PlayerName(bodyid));
	Format(sItems, "Money: $ %s\nProperty key: %s\nWeapon: %s (ammo: %d)", ConvertMoney(pLootInfo[bodyid][lootMoney]), Property::GetPropName(pLootInfo[bodyid][lootProperty]), WepName, pLootInfo[playerid][lootAmmo]);
	
	Player::ShowDialog(playerid, DIALOG_LOOT, DIALOG_STYLE_LIST, sCaption, sItems, "Take", "Close");
	pLootInfo[playerid][looting] = true;
	pLootInfo[playerid][ilooting] = bodyid;
	
	return 1;
}

Loot__OnExitBody(playerid)
{
	new bodyid = pLootInfo[playerid][ilooting];
	
  	Loot::OnReset(bodyid);
  	Loot::OnReset(playerid);
	
	Player::OnDialogResponse(playerid);
    
    return 1;
}

Loot__OnDialog(playerid, response, listitem, inputtext[])
{
	new lootid = pLootInfo[playerid][ilooting],
        sMessage[128];
 
	if(!response)
	    return Loot::OnExitBody(playerid);

	switch(listitem)
	{
	    case LOOT_LISTITEM_MONEY:
		{
			GivePlayerMoney(playerid, pLootInfo[lootid][lootMoney]);
		}
		
		case LOOT_LISTITEM_PROPERTY:
	    {
	        if(pLootInfo[lootid][lootProperty] != -1)
	        {
      			Properties[pLootInfo[lootid][lootProperty]][Owned] = true;
				Properties[pLootInfo[lootid][lootProperty]][Ownerid] = playerid;
				
	            Format(sMessage, "* Congratulations! You stole the key to property '%s'", Property::GetPropName(pLootInfo[lootid][lootProperty]));
	            SendClientMessage(playerid, COLOR_TRUE, sMessage);
				Format(sMessage, "* and will earn $ %s every 2 minutes for this property!", ConvertMoney(Properties[pLootInfo[lootid][lootProperty]][Earn]));
	            SendClientMessage(playerid, COLOR_TRUE, sMessage);
	            
	            Format(sMessage, "* Your key to property '%s' has been stolen!", Property::GetPropName(pLootInfo[lootid][lootProperty]));
	            SendClientMessage(lootid, COLOR_FALSE, sMessage);
	            SendClientMessage(lootid, COLOR_FALSE, "* You will no longer earn money for this property.");
	        }
		}
		
	    case LOOT_LISTITEM_WEAPON:
	    {
	       GivePlayerWeapon(playerid, pLootInfo[lootid][lootWeapon], pLootInfo[lootid][lootAmmo]);
	    }
	}
	
	Loot::OnExitBody(playerid);
	
	#pragma unused inputtext
	return 1;
}

Loot__OnDeath(playerid, killerid)
{
	new Float:X, Float:Y, Float:Z;
	
	GetPlayerPos(playerid, X, Y, Z);
	    
	pLootInfo[playerid][iallowed] = killerid;
	pLootInfo[playerid][dead] = true;
	pLootInfo[playerid][dposX] = X;
	pLootInfo[playerid][dposY] = Y;
	pLootInfo[playerid][dposZ] = Z;
	
	// Current player money
	pLootInfo[playerid][lootMoney] = GetPlayerMoney(playerid);
	
	// If the player had a prop, include it
	for(new i = 0; i < Properties_Loaded; i++)
	{
		pLootInfo[playerid][lootProperty] = -1;

		if(!Property::PlayerOwnProp(playerid, i))
		    continue;
		    
		pLootInfo[playerid][lootProperty] = i;
		break;
	}
	
	// Get the players weapon he had before death
	pLootInfo[playerid][lootWeapon] = GetPlayerWeapon(playerid);
	
	pLootInfo[playerid][lootAmmo] = random(10)*10;
	
	// If the weapon was 'unarmed', change it to brass knuckles to make it more fun
	if(pLootInfo[playerid][lootWeapon] == 0)
	    pLootInfo[playerid][lootWeapon] = 1;
	    
	// Send message to player
	SendClientMessage(playerid, COLOR_FALSE, "* Your killer is able loot your body! He/she might steal a key from");
	SendClientMessage(playerid, COLOR_FALSE, "* one of your properties if you had any. If so, you will loose that property!");
	
	// Send message to the killer
	SendClientMessage(killerid, COLOR_TRUE, "* You can loot the player you just killed!");
	SendClientMessage(killerid, COLOR_INFO, "** Loot the player for items by crouching on the body,");
	SendClientMessage(killerid, COLOR_INFO, "** remember though that you can only pick one item!");

	return 1;
}

Loot__OnSpawn(playerid)
{
	pLootInfo[playerid][iallowed] = -1;
	pLootInfo[playerid][dead] = false;
	
	return 1;
}

Loot__OnUpdate(playerid)
{
	if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
	    return 1;
	    
 	if(pLootInfo[playerid][looting] == true)
	    return 1;
	    
	new bodyid = Loot::GetBody(playerid);
	    
	if(!IsPlayerConnected(bodyid))
	    return 1;
	    
 	Loot::OnBody(playerid, bodyid);
	
	return 1;
}

Loot__GetBody(playerid)
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(!IsPlayerConnected(i))
	        continue;
	        
		if(pLootInfo[i][iallowed] != playerid)
   			continue;
   			
		if(!Loot::IsOnBody(playerid, i))
		    continue;
		    
		return i;
	}
	
	return -1;
}

Loot__IsOnBody(playerid, bodyid)
{
	if(!IsPlayerConnected(bodyid))
	    return 0;
	    
	if(!IsPlayerAt(playerid, pLootInfo[bodyid][dposX], pLootInfo[bodyid][dposY], pLootInfo[bodyid][dposZ]))
	    return 0;
	    
	return 1;
}

Loot__OnReset(playerid)
{
	pLootInfo[playerid][ilooting] = -1;
	pLootInfo[playerid][iallowed] = -1;
	pLootInfo[playerid][dead] = false;
	pLootInfo[playerid][looting] = false;

	pLootInfo[playerid][lootMoney] = 0;
	pLootInfo[playerid][lootProperty] = -1;
	pLootInfo[playerid][lootWeapon] = 0;

	return 1;
}

