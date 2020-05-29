MySQL__Connect()
{
	if(mysql_connect(MySQL_HOST, MySQL_USER, MySQL_DB, MySQL_PASS))
	{
	    mysql_debug(MySQL_DEBUG);

	    printf("[MySQL]: Connection to '%s' established.", MySQL_DB);

		/*
 		new success[128];
		format(success, sizeof(success), "3[MySQL]: Connection to '%s' established.", MySQL_DB);
		IRC::SendOPMsg(success, AdminChan);*/
 	}
 	else
 	{
		printf("[MySQL]: Connection to '%s' failed.", MySQL_DB);

		/*
		new failure[128];
  		format(failure, sizeof(failure), "4[MySQL]: Connection to '%s' failed.", MySQL_DB);
		IRC::SendOPMsg(failure, AdminChan);*/
 	}
 	return 1;
}

MySQL__Disconnect()
{
	mysql_close();
	printf("[MySQL]: Connection to '%s' closed.", MySQL_DB);
	return 1;
}


// !IMPORTANT FUNCTION!
// Function: MySQL_Escape
// Author: iou
// Information: Escaped all bad characters before use in query, this prevents SQL INJECTIONS
// Notes: Returns with the escaped string
MySQL__Escape(const string[])
{
	new notconst[400];
	mysql_real_escape_string(string, notconst);
	return notconst;
}


MySQL__AlterTable(const table[], const alterstring[])
{
	MySQL_Vars_L
    MySQL_Format("ALTER TABLE %s %s", table, MySQL::Escape(alterstring));
    
    MySQL_Query
    
	FormatReport("[MySQL]: Executed AlterTable according to: %s", alterstring);
    SendReport(reportstring);
    return 1;
}

MySQL__CountRows(const table[])
{
	new Rows;
	
	MySQL_Vars
	MySQL_Format("SELECT * FROM %s", MySQL::Escape(table));
	
	MySQL_Query
 	MySQL_Result

	Rows = MySQL_NumRows;
	MySQL_Free
	
	if(Rows < 1)
	{
	    return 0;
 	}
 	return Rows;
}

MySQL__ResetAutoIncrement(const table[])
{
	new Rows = MySQL::CountRows(table);
	
	MySQL_Vars
	MySQL_Format("ALTER TABLE %s AUTO_INCREMENT = %d", MySQL::Escape(table), Rows + 1);
	
	MySQL_Query
    
    return Rows + 1;
}

MySQL__ReOrderTable(const table[], const field[])
{
	new Rows, Row = 1, id, hadtofix;
	new result[50], fixquery[128];

    MySQL::ResetAutoIncrement(table);
	Rows = MySQL::CountRows(table);
	
    if(Rows < 1)
		return 0;
    
    MySQL_Vars
   	MySQL_Format("SELECT %s FROM %s", MySQL::Escape(field), MySQL::Escape(table));
	MySQL_Query
	MySQL_Result

	MySQL_FetchMultiRows
	{
	    MySQL_FetchRow(result, field);
	    
	    id = strval(result);
	    
	    if(Row != id)
	    {
            hadtofix++;
            
            Format(fixquery, "UPDATE %s SET %s = %d WHERE %s = %d", MySQL::Escape(table), MySQL::Escape(field), Row, MySQL::Escape(field), id);
            mysql_query(fixquery);
            
            /*
			FormatReport("[MySQL]: Wrong %s in TABLE %s Current: (%d) Correct: (%d). %s was SET to %d.", field, table, id, Row, field, correctid);
            SendReport(reportstring);
            
        	//Set correct id
        	
        	print(query);*/
		 }
		 
		 Row++;
    }
    
    MySQL_Free
    
   	MySQL::ResetAutoIncrement(table);
    
	if(hadtofix < 1)
	{
	 	FormatReport("[MySQL]: ORDER of %s in TABLE %s has been checked and everything is fine.", field, table);
	 	SendReport(reportstring);
	}
	else
	{
	 	FormatReport("[MySQL]: ORDER of %s in TABLE %s has been checked, %d items was corrected.", field, table, hadtofix);
		SendReport(reportstring);
    }
    return 1;
}

/* INTENDED FOR LATER USE
// Function: GetUnloadedField
// Author: iou
// Parameters: table (eg. properties), field (eg. id), keyword (eg. name = iourules)
// Information: Retrieve any peice of data from any field
// Notes: Returns a string, use floatstr or strval to convert.
MySQL__GetUnloadedField(const table[], const field[], const keyword[])
{
	new result[256];
	
	MySQL_Vars
	MySQL_Format("SELECT %s FROM %s WHERE %s", field, table, keyword);
	
	MySQL_Query
	MySQL_Result
	
	MySQL_FetchPrepare
	    MySQL_FetchRow(result, field);

	return result;
}*/

// Function: ExistsRow
// Author: iou
// Parameters: table (eg. properties), searchfield (eg. name), keyword (eg. iou's Property)
// Information: Checks if a row with the specified keyword exists in the specified table
// Notes: Returns 1/0
MySQL__ExistsRow(const table[], const searchfield[], const keyword[])
{
	new Rows;

	MySQL_Vars
	
	if(isNumeric(keyword))
	    MySQL_Format("SELECT * FROM %s WHERE %s = %d", MySQL::Escape(table), MySQL::Escape(searchfield), strval(keyword));
	else
		MySQL_Format("SELECT * FROM %s WHERE %s = '%s'", MySQL::Escape(table), MySQL::Escape(searchfield), MySQL::Escape(keyword));
		
	
	MySQL_Query
	MySQL_Result

	Rows = MySQL_NumRows;
	MySQL_Free

	if(Rows < 1)
	    return 0;
 	
 	return 1;
}

