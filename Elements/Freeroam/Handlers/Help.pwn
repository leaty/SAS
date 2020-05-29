Freeroam__ShowHelp(playerid, help[])
{
	str_switch(help)
	{
	    str_case(props):
	    {
	    	SendClientMessage(playerid, COLOR_TITLE, "*** Property Help: ***");
	    	SendClientMessage(playerid, COLOR_INFO,  "* You can purchase properties to earn money every 2 minutes.");
	    	SendClientMessage(playerid, COLOR_INFO,  "* Sell a property of yours for half the original prize.");
	    	SendClientMessage(playerid, COLOR_INFO,  "* If you see a property you want to buy but it's already owned and secured,");
			SendClientMessage(playerid, COLOR_INFO,  "* you can either wait until it's available for purchase or try to kill the owner");
	    	SendClientMessage(playerid, COLOR_INFO,  "* and you can loot his body for the property key (see /help loot)");
	    	return 1;
	    }
	    str_case(loot):
	    {
	        SendClientMessage(playerid, COLOR_TITLE, "*** Loot Help: ***");
	        SendClientMessage(playerid, COLOR_INFO,  "* Sometimes when you kill a player, you can loot his body for items.");
	        SendClientMessage(playerid, COLOR_INFO,  "* These items could be money, a property key (see /help props) or weapons.");
	        SendClientMessage(playerid, COLOR_INFO,  "* Loot a player by crouching on his body,");
	        SendClientMessage(playerid, COLOR_INFO,  "* you have to be quick though because his body disappears when he respawns.");
	        return 1;
	    }
	    str_case(bank):
	    {
     		SendClientMessage(playerid, COLOR_TITLE, "*** Bank Help: ***");
	        SendClientMessage(playerid, COLOR_INFO,  "* The money in your hand does not save when you quit, or die.");
	        SendClientMessage(playerid, COLOR_INFO,  "* Try to bank your money as often as you can.");
	        SendClientMessage(playerid, COLOR_INFO,  "* You can buy or upgrade your bank plan at San Fierro's Police Department.");
	        SendClientMessage(playerid, COLOR_INFO,  "* Banking is easy, all you have to do is to find an ATM and do whatever you wish there.");
			return 1;
		}
	}
	
	return SendClientMessage(playerid, COLOR_USAGE, "Usage: /help [props/loot/bank]");
}

freeroam_Help(playerid, params[])
{
	new constparam[128];

	Format(constparam, "%s", params);
	Freeroam::ShowHelp(playerid, constparam);
	return 1;
}

