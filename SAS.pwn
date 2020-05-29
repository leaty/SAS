#pragma unused ret_memcpy

#include <a_samp>
#include <a_mysql>
#include <md5>
#include <irc>
#include <dutils>
#include <streamer>

main()
{

}

#define TEST 					0 // Is this for testing or a public release?

#define VERSION                 "1"
#define BUILD                   "10"


#define REPORT_HANDLERS         1 // Show reports to Management?
#define REPORT_CMDS             1 // Show written commands to Management?


#define ELEMENT_GANG            strval("1") // Load gang?
#define ELEMENT_TRAINING        strval("1") // Training mode enabled?
#define ELEMENT_FREEROAM        strval("1") // Freeroam mode enabled?

#define GAMES_CLANWAR           strval("1") // CW enabled?
#define GAMES_MINI              strval("1")

#define GAMEMODE_TEXT           "Splitmode"

#define RAMPING_ENABLED         true
#define RAMPING_ABUSE           1


// MySQL details.
#if TEST == 0

    #define MaxSlots            	20
    
    // MySQL details.
    #define MySQL_DEBUG         	0
	#define MySQL_HOST 				"127.0.0.1"
	#define MySQL_USER 				"iou_tho"
	#define MySQL_PASS 				"password"
	#define MySQL_DB 				"iou_tho"
	
	// IRC details
	#define IrcServer 				"irc.gtanet.com" // IRC server.
	#define IrcPort 				6667 // IRC port.

	#define Mode 					"-" // +v / +h / +o / +a / +q / - (off)
	#define IrcToServer 			"admin" // admin (rcon) / all / off

	#define EchoChan  				"#SAS.echo"  	 // The channel where will go out.
	#define ChanPass  				"password"				 // The password for chanserv. (Optional)

	#define DevChan   				"#SAS.dev" 	 	 		 // Dev Channel.
	#define DevPass     			"password"

	#define AdminChan 				"#SAS.crew" 	 // If there is a channel, everything private will be seen there. (Optional)
	#define AdminPass 				"password"

	#define BotRealName 			"SplitBots"
 	#define BotUserName 			"SASBots"

	#define BotPass 				"password" // The password for nickserv. (Optional)

	#define IRC_OWNER 				"~"
	#define IRC_SOP 				"&"
	#define IRC_OP 					"@"
	#define IRC_HOP 				"%"
	#define IRC_VOICE 				"+"
	
	#define IRC_GROUP_ECHO          0
	#define IRC_GROUP_ADMIN         1
	#define IRC_GROUP_COMMAND       2
	
	#define IRC_MAX_BOTS            5

#elseif TEST == 1

	#define MaxSlots 				20

    // MySQL details.
    #define MySQL_DEBUG         	1
	#define MySQL_HOST 				"127.0.0.1"
	#define MySQL_USER 				"iou_sastest"
	#define MySQL_PASS 				"password"
	#define MySQL_DB 				"iou_sastest"
	
	// IRC details.
	#define IrcServer 				"irc.gtanet.com" // IRC server.
	#define IrcPort 				6667 // IRC port.
	
	#define Mode 					"-" // +v / +h / +o / +a / +q / - (off)
	#define IrcToServer 			"admin" // admin (rcon) / all / off

	#define EchoChan 				"#SAS.Beta" 		 // The channel where will go out.
	#define ChanPass 				"password" 	 // The password for chanserv. (Optional)

	#define DevChan   				"#SAS.Dev"               // Dev Channel. (Optional)
	#define DevPass     			"password"

	#define AdminChan 				"#SAS.Beta" 		 // If there is an admin channel, everything private will be seen there. (Optional)
	#define AdminPass 				"password"

	#define BotRealName 			"TestBots"
 	#define BotUserName 			"SASBots"

	#define BotPass 				"password" // The password for nickserv. (Optional)

	#define IRC_OWNER 				"~"
	#define IRC_SOP 				"&"
	#define IRC_OP 					"@"
	#define IRC_HOP 				"%"
	#define IRC_VOICE 				"+"
	
	#define IRC_GROUP_ECHO          0
	#define IRC_GROUP_ADMIN         0
	#define IRC_GROUP_COMMAND       0
	
	#define IRC_MAX_BOTS            1

#endif

//===================================================================//
//-----------------------------INCLUDES------------------------------//
//===================================================================//

//------ Data ------
#include Data/defines.pwn
#include Data/worlds.pwn
#include Data/dialogs.pwn
#include Data/enums.pwn
#include Data/forwards.pwn
#include Data/variables.pwn
#include Data/menus.pwn
#include Data/mapicons.pwn
#include Data/functions.pwn

//---------Server Handlers-------
#include Resources/Handlers/Server/Server.pwn
#include Resources/Handlers/Server/Pickup.pwn
#include Resources/Handlers/Server/Object.pwn
#include Resources/Handlers/Server/Vehicle.pwn
#include Resources/Handlers/Server/News.pwn

//------- Elements ---------
#include Elements/Player/playerCore.pwn //Player
#include Elements/Admin/adminCore.pwn //Admin
#include Elements/Gang/gangCore.pwn //Gang
#include Elements/IRC/ircCore.pwn //IRC

//-------- Games/Minigames ---------
#include Resources/Games/gameCore.pwn


//---------Player Handlers-------
#include Resources/Handlers/Player/Nametag.pwn
#include Resources/Handlers/Player/Marker.pwn
#include Resources/Handlers/Player/Color.pwn
#include Resources/Handlers/Player/Hardcore.pwn
#include Resources/Handlers/Player/Godmode.pwn
#include Resources/Handlers/Player/Spectate.pwn
#include Resources/Handlers/Player/Jail.pwn
#include Resources/Handlers/Player/Mute.pwn
#include Resources/Handlers/Player/Hax.pwn
#include Resources/Handlers/Player/Ramping.pwn

//------- Modes --------
#include Elements/Training/trainingCore.pwn //Training
#include Elements/Freeroam/freeroamCore.pwn //Freeroam

// Other
#include Data/timers.pwn

//----- Callbacks -----
#include Resources/Callbacks/Other/OnGameModeInit.pwn
#include Resources/Callbacks/Other/OnGameModeExit.pwn
#include Resources/Callbacks/Other/OnRconCommand.pwn
#include Resources/Callbacks/Other/OnVehicle.pwn
#include Resources/Callbacks/Other/OnDialogResponse.pwn

#include Resources/Callbacks/OnPlayer/OnPlayerConnect.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerDisconnect.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerSpawn.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerDeath.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerStates.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerUpdate.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerCheckpoints.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerClickPlayer.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerInteriorChange.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerEnterVehicle.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerExitVehicle.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerExitedMenu.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerRequestClass.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerRequestSpawn.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerPickUpPickup.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerSelectedMenuRow.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerObjectMoved.pwn
#include Resources/Callbacks/OnPlayer/OnPlayerText.pwn

#include Resources/Callbacks/OnPlayer/OnPlayerCommandText.pwn

//-- Engines
#include Resources/Engines/MySQL.pwn

