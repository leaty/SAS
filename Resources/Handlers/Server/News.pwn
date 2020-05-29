#define NEWS_MAX            50
#define NEWS_PREFIX         "SASBot:"

enum NewsData
{
	sNewsItem[256],
	bool:Exists,
	ItemID
};

new NewsInfo[NEWS_MAX][NewsData];

// This function fetches all the news-messages from the Database
News__Init()
{
	MySQL::ResetAutoIncrement(Table_news);
	
	new Rows = MySQL::CountRows(Table_news);
	
	if(Rows < 1 )
	    return false;
	    
	MySQL::ReOrderTable(Table_news, "id");
	    
	new iCount = 0;

    MySQL_Vars
    MySQL_Format("SELECT item FROM %s", Table_news);
	MySQL_Query
	MySQL_Result
	
	MySQL_FetchMultiRows
	{
    	// Fetch the item
    	MySQL_FetchRow(NewsInfo[iCount][sNewsItem], "item");
    	NewsInfo[iCount][Exists] = true;
    	iCount++;
	}
	
	News::UpdateItems();
	
	return true;
}

// This function will send out a randomized news message
News__Process()
{
	if(News::CountNews() < 1)
	    return 0;
	    
	new iRandom = News::GetRandomItem();
	
	if(iRandom == -1)
	    return 0;
	    
	News::SendMessage(NewsInfo[iRandom][sNewsItem]);
	
	return 1;
}

News__SendMessage(sItem[])
{
	new sNews[256];
	Format(sNews, "%s %s", NEWS_PREFIX, sItem);
	
	SendClientMessageToAll( COLOR_TITLE, sNews);
	return true;
}

News__AddItem(sItem[256])
{
	new arraypos;
	
	for(new i = 0; i < NEWS_MAX; i++)
	{
	    if(News::Exists(i))
	        continue;
	        
		arraypos = i;
		break;
	}
	
	NewsInfo[arraypos][Exists] = true;
	NewsInfo[arraypos][sNewsItem] = sItem;
	
	News::UpdateItems();
	
	MySQL_Vars
	MySQL_Format("INSERT INTO %s (id, item) VALUES(%d, '%s')", Table_news, NewsInfo[arraypos][ItemID], MySQL::Escape(sItem));
	MySQL_Query
	
	MySQL::ReOrderTable(Table_news, "id");
	
	return 1;
}

News__DeleteItem(itemid)
{
	NewsInfo[News::GetArrayPos(itemid)][Exists] = false;
	
	MySQL_Vars
	MySQL_Format("DELETE FROM %s WHERE id = %d", Table_news, itemid);
	MySQL_Query
	
	News::UpdateItems();
	MySQL::ReOrderTable(Table_news, "id");
	
	return 1;
}

News__Exists(id)
{
	if(NewsInfo[id][Exists] == false || NewsInfo[id][ItemID] == 0)
	    return 0;
	    
	return 1;
}

News__UpdateItems()
{
	new iCount = 1;
	
	for(new i = 0; i < NEWS_MAX; i++)
	{
	    if(NewsInfo[i][Exists] == false)
     		NewsInfo[i][ItemID] = 0;
		else
		{
		    NewsInfo[i][ItemID] = iCount;
		    iCount++;
		}
	}
}

News__CountNews()
{
	new iCount;
	
	for(new i = 0; i < NEWS_MAX; i++)
		if(News::Exists(i))
		    iCount++;
		    
	return iCount;
}

News__GetRandomItem()
{
	new iCount;
	new iRandom;
	
	// Infinite loop
	for(new i = 1; i > 0; i++)
	{
 		// -5 is just to be sure
	    if(iCount > NEWS_MAX-5)
	        return -1;
	        
		iRandom = random(NEWS_MAX);
		
	    if(News::Exists(iRandom))
	        return iRandom;

	    iCount++;
	}
	
	return -1;
}

News__GetArrayPos(itemid)
{
	    
	for(new i = 0; i < NEWS_MAX; i++)
	{
	    if(!News::Exists(i))
	        continue;
	        
		if(NewsInfo[i][ItemID] != itemid)
		    continue;
		    
		return i;
	}
	
	return -1;
}

News__OnCommand( playerid, params[] )
{
	if(!IsManagement(playerid))
	    return false;
	    
	new sParam[ 50 ], sParam2[ 256 ], sMessage[256];
	
	if( sscanf( params, "sz", sParam, sParam2 ) )
	    return SendClientMessage( playerid, COLOR_USAGE, "Usage: /news [add/delete/list]" );
	    
	if( strcmp( sParam, "add", true, 3 ) == 0 )
	{
	    if(strlen(sParam2) < 1)
	        return SendClientMessage(playerid, COLOR_USAGE, "Usage: /news add [message]");
	
	    if(strlen(sParam2) < 5)
	        return SendClientMessage(playerid, COLOR_FALSE, "* Too short message.");
	        
		if(News::AddItem(sParam2))
			SendClientMessage(playerid, COLOR_TRUE, "* News item was successfully added.");
		else
		    SendClientMessage(playerid, COLOR_FALSE, "* Something went wrong, the news item was not added.");
	}
 	else if( strcmp( sParam, "delete", true, 6 ) == 0 )
	{
	    if(!isNumeric(sParam2))
	        return SendClientMessage(playerid, COLOR_USAGE, "Usage: /news delete [itemid]");
	        
		new item = strval(sParam2), arraypos;
		
		if(item == 0 || item > NEWS_MAX)
		    return SendClientMessage(playerid, COLOR_FALSE, "* Invalid itemid.");
		    
		arraypos = News::GetArrayPos(item);
	        
		if(arraypos == -1 || !News::Exists(arraypos))
		    return SendClientMessage(playerid, COLOR_FALSE, "* This item does not appear to exist.");
		    
		if(News::DeleteItem(item))
            SendClientMessage(playerid, COLOR_TRUE, "* News item was successfully deleted.");
		else
		    SendClientMessage(playerid, COLOR_FALSE, "* Something went wrong, the news item was not deleted.");
	}
	else if( strcmp( sParam, "list", true, 4 ) == 0 )
	{
	    SendClientMessage(playerid, COLOR_TITLE, "*** News Items: ***");
	    
	    for(new i = 0; i < NEWS_MAX; i++)
	    {
	        if(!News::Exists(i))
	            continue;
	            
	        Format(sMessage, "%d. %s", NewsInfo[i][ItemID], NewsInfo[i][sNewsItem]);
			SendClientMessage(playerid, COLOR_INFO, sMessage);
	    }
	}
	else SendClientMessage( playerid, COLOR_FALSE, "Usage: /news [add/delete/list]" );
	
	return 1;
}

sas_News( playerid, params[] )
{
	News::OnCommand( playerid, params );
	return true;
}
