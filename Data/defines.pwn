#define HOLDING(%0) ((newkeys & (%0)) == (%0))
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))


//-- Spectating Modes
#define SPEC_MODE_NORMAL        0
#define SPEC_MODE_ADMIN         1


//-- MaxThings
#define MAX_MODES               2
#define MaxPickups 				100
#define MaxLoginTries    		3
#define MaxColors               200

#define MIN_PASSWORD            4
#define MAX_PASSWORD            30

#define MAX_ZONE_NAME 			30
#define MAX_ZONES 				366

//-- Player Modes
#define MODE_NORMAL             0 // These will be removed later
#define MODE_SCHOOL             1 // As above

#define MODE_NEUTRAL            0 // Used for commands for all modes
#define MODE_TRAINING           1
#define MODE_FREEROAM           2

//-- Player admin levels
#define LEVEL_PLAYER     		0
#define LEVEL_MOD        		1
#define LEVEL_ADMIN      		2
#define LEVEL_MANAGEMENT 		3

//-- IRC admin levels
#define IRC_LEVEL_NONE          0
#define IRC_LEVEL_VIP      		1
#define IRC_LEVEL_MOD           2
#define IRC_LEVEL_ADMIN         3
#define IRC_LEVEL_MANAGEMENT    4
#define IRC_LEVEL_OWNER		    4

//-- Player punishments
#define DEFAULT_MUTE_ADDITION   2 	// The time that adds when a player is muted
#define DEFAULT_JAIL_ADDITION   2   // The default time that's added when a player is jailed

//-- COLOR DEFINES
#define COLOR_TRUE 				0x00DA79D6
#define COLOR_FALSE 			0xFF546593
#define COLOR_TITLE 			0x5DC3FF5A
#define COLOR_INFO              0x06FFFF93
#define COLOR_PUBLIC 			0xFF8000FF
#define COLOR_HIDE              0xB4B5B7FF
#define COLOR_FADE				0xAFAFAFAA
#define COLOR_DEBUG             0x5DC3FF5A
#define COLOR_NEWS              0xAFAFAFAA
#define COLOR_REPORT            0xF90013FF
#define COLOR_NOTICE 			0x9F4E8CFF
#define COLOR_USAGE             0xFFFFFFAA
#define COLOR_IRCTOIG           0xFFFFFFAA

#define COLOR_PM_FROM           0xFFF900FF
#define COLOR_PM_TO             0xFFF900FF

#define COLOR_KICKBAN           0xFF8000FF

#define COLOR_ADMINCHAT         0xFFF900FF
#define COLOR_PROADMIN          0xFFFFFFAA
#define COLOR_ADMIN             0xFFFFFFAA
#define COLOR_MOD               0xFFFFFFAA

#define COLOR_DEATHMSG          0x719060FF

#define StripAlpha(%0)  		( ( %0 ) >>> 8 )
#define COLOR_EMBED             0xFFFFFFFF // This is generally just for showing that this text has embedded colors
#define COLOR_PLAYER_ID         0xAD3738FF
#define COLOR_PLAYER_TEXT       0xFFFFFFFF


//-- IRC COLOR DEFINES
#define IRC_COLOR_TRUE			"10"
#define IRC_COLOR_FALSE         "6"
#define IRC_COLOR_NOTICE        "5"
#define IRC_COLOR_INFO          "10"
#define IRC_COLOR_TITLE         "6"
#define IRC_COLOR_ADMINCHAT     "2"
#define IRC_COLOR_TEXT          "1,0"
#define IRC_COLOR_NAME          "5,0"
#define IRC_COLOR_PM            "7"
#define IRC_COLOR_BLACK         "1"
#define IRC_COLOR_DARKBLUE      "2"
#define IRC_COLOR_BROWN         "5"
#define IRC_COLOR_DARKPURPLE    "6"
#define IRC_COLOR_ORANGE		"7"
#define IRC_COLOR_YELLOW        "8"
#define IRC_COLOR_BRIGHTGREEN   "9"
#define IRC_COLOR_LIGHTBLUE     "10"
#define IRC_COLOR_BRIGHTBLUE    "11"
#define IRC_COLOR_BLUE          "12"
#define IRC_COLOR_LIGHTPURPLE   "13"
#define IRC_COLOR_GREY          "14"
#define IRC_COLOR_LIGHTGREY     "15"
#define IRC_COLOR_DEATH         "04"

#define IRC_BOLD                ""
#define IRC_ENDBOLD             ""
#define IRC_USAGE         		"6Usage:10"
#define IRC_ERROR               "6Error:1"
#define IRC_SUCCESS             "10Success:1"


//-- Functions
#define Ramping::%1(            Ramping__%1(
#define Timer::%1(              Timer__%1(
#define IRC::%1( 				IRC__%1(
#define MySQL::%1( 				MySQL__%1(
#define Objects::%1( 			Objects__%1(
#define Menus::%1( 				Menus__%1(
#define FCHandler::%1( 			FCHandler__%1(
#define Pickups::%1( 			Pickups__%1(
#define Vehicle::%1(            Vehicle__%1(
#define Hardcore::%1( 			Hardcore__%1(
#define Godmode::%1( 			Godmode__%1(
#define Admin::%1(              Admin__%1(
#define Player::%1( 			Player__%1(
#define Training::%1( 			Training__%1(
#define Freeroam::%1( 			Freeroam__%1(
#define Gang::%1(               Gang__%1(
#define CW::%1(               	CW__%1(
#define Bank::%1(               Bank__%1(
#define Loot::%1(         		Loot__%1(
#define Property::%1(           Property__%1(
#define Spectate::%1(           Spectate__%1(
#define Jail::%1(               Jail__%1(
#define Mute::%1(               Mute__%1(
#define Hax::%1(                Hax__%1(
#define Server::%1(             Server__%1(
#define News::%1(               News__%1(
#define Games::%1(              Games__%1(
#define Mini::%1(               Mini__%1(

//-- MySQL Quick
#define MySQL_Vars              new query[300];
#define MySQL_Vars2				new query2[300];
#define MySQL_Vars_L            new query[500];

#define MySQL_Format(           format(query, sizeof(query),
#define MySQL_Query             mysql_query(query);
#define MySQL_Result            mysql_store_result();
#define MySQL_NumRows         	mysql_num_rows()
#define MySQL_NumFields         mysql_num_fields()
#define MySQL_FetchPrepare      new resultline[1024]; if(mysql_fetch_row_format(resultline))
#define MySQL_FetchRow          mysql_fetch_field_row
#define MySQL_FetchMultiRows    while(mysql_retrieve_row())
#define MySQL_FetchFloat        mysql_fetch_float
#define MySQL_FetchInt          mysql_fetch_int();
#define MySQL_Free              mysql_free_result();

//-- MySQL Tables
#define Table_users             "users"
#define Table_bans              "bans"
#define Table_kicks             "kicks"
#define Table_pickups           "pickups"
#define Table_gangs             "gangs"
#define Table_fc                "fc_locations"
#define Table_cw                "cw_locations"
#define Table_sdm               "sdm_locations"
#define Table_properties        "properties"
#define Table_news              "news"

//-- Others
#define TRUE                    1
#define FALSE                   0
#define SERVERKICKBAN           "Server"
#define BAN_EXCEPTION           2

//-- String manipulations
#define FormatString(           new string[256]; format(string, sizeof(string),
#define FormatString2(          new string2[256]; format(string2, sizeof(string2),
#define FormatReport(           new reportstring[256]; format(reportstring, sizeof(reportstring),
#define FormatReport2(          new reportstring2[256]; format(reportstring2, sizeof(reportstring2),
#define FormatKick(             new kickstring[256]; format(kickstring, sizeof(kickstring),
#define FormatBan(              new banstring[256]; format(banstring, sizeof(banstring),
#define FormatIRC(              new ircstring[256]; format(ircstring, sizeof(ircstring),
#define FormatIRC2(             new ircstring2[256]; format(ircstring2, sizeof(ircstring2),


// USE THIS INSTEAD
// Define: Format
// Author: iou
// Note: All other Quick formats will be removed, so please start using this!
// Example:
/*
	new sError[128];
	Format(sError, "%s iourules!", IRC_SUCCESS);
*/
#define Format(%1,              format(%1, sizeof(%1),

#define StrReset(%1);           strdel(%1, 0, strlen(%1)+1); // Resets the string (i.e "")


#define str_null(%1)            (strlen(%1) < 1)
#define str_switch(%1)          new str_switch[128]; Format(str_switch, "%s", %1); if(!str_null(%1))
#define str_case(%1):           if(strcmp(str_switch, #%1, false, strlen(#%1)) == 0)

//-- Logs
#define LOG_IRC                 "/logs/ircLog.txt"
#define LOG_HANDLER             "/logs/HandlerLogs.txt"
#define LOG_KICK                "/logs/KickLog.txt"
#define LOG_BAN                 "/logs/BanLog.txt"
#define LOG_DEV                 "/logs/DevLog.txt"



/*//OLD
#define COLOR_ORANGE 0xFF8000FF
#define COLOR_BLUE 0x0006FFFF
#define COLOR_PURPLE 0x9118D1FF
#define COLOR_PINK 0xFD00FDFF
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x20FF00FF
#define COLOR_DARKGREEN 0x118001FF
#define COLOR_LIGHTGREEN 0xAAED82FF
#define COLOR_RED 0xF90013FF
#define COLOR_YELLOW 0xFFF900FF
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_BLACK 0x000000AA
#define COLOR_BRIGHTRED 0xFF0000AA
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_ORANGE 0xFF8000FF
#define COLOR_GREYLIGHTBLUE 0x7C9B9CFF
#define COLOR_GANGCHAT playerColors[GangInfo[GangID][ColorID]]
#define COLOR_CWGANGCHAT1 playerColors[GangInfo[ServerInfo[gID1]][ColorID]]
#define COLOR_CWGANGCHAT2 playerColors[GangInfo[ServerInfo[gID2]][ColorID]]
#define COLOR_MERCHANT 0xAFAFAFAA
#define COLOR_COOLBLUE 0x007bc4
*/
