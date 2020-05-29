#define MAX_ATMS        				25

#define BANK_PICKUP_X       			246.7056
#define BANK_PICKUP_Y       			125.0884
#define BANK_PICKUP_Z       			1003.2188

#define BANK_PLAN_NONE					0
#define BANK_PLAN_BASIC      			1
#define BANK_PLAN_BUSINESS      		2
#define BANK_PLAN_PROFESSIONAL      	3

#define BANK_BASIC_MONEY                1000
#define BANK_BUSINESS_MONEY             100000
#define BANK_PROFESSIONAL_MONEY         1000000

#define BANK_BUSINESS_REQUIREMENT      	180000
#define BANK_PROFESSIONAL_REQUIREMENT   720000

new Float:ATM_Pos[MAX_ATMS][4] =
{
	{ 290.668395, -30.217794, 1001.115600, 0.758987 },
	{ -2586.947021, 488.075042, 14.216856, 316.753753 },
	{ -2493.914550, 388.649078, 27.365625, 324.752014 },
	{ -2676.366210, -285.612335, 6.785912, 138.183456 },
	{ -2675.119140, 634.668212, 14.053125, 359.503082 },
	{ -2562.482910, 985.823730, 77.873435, 3.847510 },
	{ 379.604827, -75.026031, 1001.107788, 267.386505 },
	{ -2025.114379, -102.038719, 34.764060, 178.063156 },
	{ -2437.544189, 754.625976, 34.771873, 88.278450 },
	{ -2203.237304, 1051.115112, 79.607810, 271.285430 },
	{ -1380.438720, -365.225860, 13.748437, 278.706359 },
	{ -1884.156005, 889.584594, 34.771873, 270.704742 },
	{ -1736.258789, 963.382385, 24.482812, 0.115349 },
	{ -2119.801757, -428.319854, 35.131248, 257.718963 },
	{ -1980.607666, 133.401412, 27.287500, 265.918243 },
	{ -1821.287719, 1051.402343, 45.678123, 272.259063 },
	{ -1892.095336, 277.229309, 40.646873, 0.997403 },
	{ -2415.458007, 352.310455, 34.771873, 55.953170 },
	{ -2545.614501, 1213.313720, 37.021873, 181.022201 },
	{ -2433.170898, 1028.685668, 49.990623, 184.012054 },
	{ -2634.271972, 1408.477539, 906.060913, 270.988983 },
	{ -1692.734497, 415.583557, 6.779687, 44.150089 },
	{ -1694.753173, 1336.433715, 6.779687, 226.966964 },
	{ -2221.223144, 721.004455, 49.006248, 182.014602 },
	{ 295.165222, -76.662658, 1001.115600, 10.530183 }
};

new BankPickup;
new ATM_Objects[MAX_ATMS];
new ATM_Pickups[MAX_ATMS];

new Menu:ATMMenu_1;
new Menu:ATMMenu_2;
new Menu:ATMMenu_3;

Bank__Init()
{
	new iCount, sMessage[128];
	
	BankPickup = CreatePickup(1274, 1, BANK_PICKUP_X, BANK_PICKUP_Y, BANK_PICKUP_Z, WORLD_FREEROAM);
	
	for(new i = 0; i < MAX_ATMS; i++)
	{
     	ATM_Objects[i] = CreateDynamicObject(2942, ATM_Pos[i][0], ATM_Pos[i][1], ATM_Pos[i][2], 0, 0, ATM_Pos[i][3], WORLD_FREEROAM);
 		ATM_Pickups[i] = CreatePickup(1489, 1, ATM_Pos[i][0], ATM_Pos[i][1], ATM_Pos[i][2]+0.4, WORLD_FREEROAM);
		iCount++;
	}
	
	Format(sMessage, "[BankHandler] %d ATM's where created.", iCount);
	SendReport(sMessage);
	
	ATMMenu_1 = CreateMenu("~g~ATM", 1, 300, 290, 300, 400);
	ATMMenu_2 = CreateMenu("~g~ATM", 1, 300, 290, 300, 400);
	ATMMenu_3 = CreateMenu("~g~ATM", 1, 300, 290, 300, 400);
	
	SetMenuColumnHeader(ATMMenu_1, 0, "What do you want to do?");
	AddMenuItem(ATMMenu_1, 0, "Withdraw");
    AddMenuItem(ATMMenu_1, 0, "Deposit");
    AddMenuItem(ATMMenu_1, 0, "View balance");
    
    SetMenuColumnHeader(ATMMenu_2, 0, "Withdraw");
   	AddMenuItem(ATMMenu_2, 0, "$ 100");
	AddMenuItem(ATMMenu_2, 0, "$ 1.000");
	AddMenuItem(ATMMenu_2, 0, "$ 10.000");
	AddMenuItem(ATMMenu_2, 0, "$ 100.000");
	AddMenuItem(ATMMenu_2, 0, "$ 1000.000");
	
 	SetMenuColumnHeader(ATMMenu_3, 0, "Deposit");
	AddMenuItem(ATMMenu_3, 0, "$ 100");
	AddMenuItem(ATMMenu_3, 0, "$ 1.000");
	AddMenuItem(ATMMenu_3, 0, "$ 10.000");
	AddMenuItem(ATMMenu_3, 0, "$ 100.000");
	AddMenuItem(ATMMenu_3, 0, "$ 1000.000");
		
	return 1;
}


Bank__OnBank(playerid)
{
	GameTextForPlayer(playerid, "~g~Welcome to SAS - Bank~n~~w~Type '/my bank' to begin", 2500, 4);
}

Bank__OnCommand(playerid, params[])
{
	if(!Bank::IsPlayerAtBank(playerid))
	{
	    SendClientMessage(playerid, COLOR_FALSE, "* You're not at the bank, financial services and options are handled at the SFPD HQ.");
	    SendClientMessage(playerid, COLOR_FALSE, "* It's located on the map with a big green $ icon.");
	    return 1;
	}

	new sMessage[128];
	
	str_switch(params)
	{
	    str_case(buy):
	    {
	    	if(PlayerInfo[playerid][BankLevel] > BANK_PLAN_NONE)
		        return SendClientMessage(playerid, COLOR_FALSE, "* You already have a bank account! Try '/my bank upgrade'.");
		        
			if(!Freeroam::Afford(playerid, BANK_BASIC_MONEY, AFFORD_NONSKIP))
			    return 1;
			    
			GivePlayerMoney(playerid, -BANK_BASIC_MONEY);

			PlayerInfo[playerid][BankLevel] = BANK_PLAN_BASIC;

			Format(sMessage, "%s has bought himself a bank account.", PlayerName(playerid), Bank::GetBankPlan(playerid));
			SendAdminMsg(sMessage);
			SendClientMessage(playerid, COLOR_TRUE, "* Congratulations! You've successfully purchased a bank account.");
			SendClientMessage(playerid, COLOR_TRUE, "* You can now use ATM's all around San Fierro to deposit/withdraw money!");
			return 1;
	    }
		str_case(upgrade):
		{
			switch(PlayerInfo[playerid][BankLevel])
			{
			    case BANK_PLAN_NONE: return SendClientMessage(playerid, COLOR_FALSE, "* You don't have a bank account, buy one using '/my bank buy'!");
			    case BANK_PLAN_BASIC:
			    {
			        if(!Freeroam::Permitted(playerid, BANK_BUSINESS_REQUIREMENT))
			            return 1;
			            
					if(!Freeroam::Afford(playerid, BANK_BUSINESS_MONEY, AFFORD_NONSKIP))
					    return 1;
					    
					GivePlayerMoney(playerid, -BANK_BUSINESS_MONEY);
					
					PlayerInfo[playerid][BankLevel] = BANK_PLAN_BUSINESS;

     				Format(sMessage, "%s has upgraded his bank to %s.", PlayerName(playerid), Bank::GetBankPlan(playerid));
     				SendAdminMsg(sMessage);
					Format(sMessage, "* Congratulations! You've upgraded your bank plan to %s.", Bank::GetBankPlan(playerid));
					SendClientMessage(playerid, COLOR_TRUE, sMessage);
			    }
			    case BANK_PLAN_BUSINESS:
			    {
       				if(!Freeroam::Permitted(playerid, BANK_PROFESSIONAL_REQUIREMENT))
			            return 1;

					if(!Freeroam::Afford(playerid, BANK_PROFESSIONAL_MONEY, AFFORD_NONSKIP))
					    return 1;

					GivePlayerMoney(playerid, -BANK_PROFESSIONAL_MONEY);

					PlayerInfo[playerid][BankLevel] = BANK_PLAN_PROFESSIONAL;

     				Format(sMessage, "%s has upgraded his bank to %s.", PlayerName(playerid), Bank::GetBankPlan(playerid));
     				SendAdminMsg(sMessage);
					Format(sMessage, "* Congratulations! You've upgraded your bank plan to %s.", Bank::GetBankPlan(playerid));
					SendClientMessage(playerid, COLOR_TRUE, sMessage);
			    }
				case BANK_PLAN_PROFESSIONAL: return SendClientMessage(playerid, COLOR_FALSE, "* You have the highest bank plan already!");
			}
			
			return 1;
		}
		str_case(balance):
		{
			if(PlayerInfo[playerid][BankLevel] == BANK_PLAN_NONE)
			     return SendClientMessage(playerid, COLOR_FALSE, "* You don't have a bank account, buy one using '/my bank buy'!");
			     
			Format(sMessage, "* Your current balance is $ %s", ConvertMoney(PlayerInfo[playerid][BankValue]));
			SendClientMessage(playerid, COLOR_TITLE, sMessage);

			Format(sMessage, "* Bank plan: %s.", Bank::GetBankPlan(playerid));
			SendClientMessage(playerid, COLOR_INFO, sMessage);

			Format(sMessage, "* Maximum space: $ %s", ConvertMoney(Bank::GetBankSpace(playerid)));
			SendClientMessage(playerid, COLOR_INFO, sMessage);
			return 1;
		}
	}
	
	SendClientMessage(playerid, COLOR_USAGE, "Usage: /my bank [buy/upgrade/balance]");

	return 1;
}

Bank__IsPlayerAtBank(playerid)
{
	if(!IsPlayerAt(playerid, BANK_PICKUP_X, BANK_PICKUP_Y, BANK_PICKUP_Z))
	    return 0;

	return 1;
}

Bank__PickupIsBank(pickupid)
{
	if(pickupid == BankPickup)
	    return 1;
	    
	return 0;
}

Bank__OnATM(playerid)
{
	if(PlayerInfo[playerid][OnATM] == true)
	    return 1;
	    
	if(PlayerInfo[playerid][BankLevel] == BANK_PLAN_NONE)
	    return SendClientMessage(playerid, COLOR_FALSE, "* You don't have a bank, please see '/help bank' to see where you can buy one.");
	    
 	PlayerInfo[playerid][OnATM] = true;
	
	SendClientMessage(playerid, COLOR_TITLE, "* Welcome to SAS - ATM!");
	SendClientMessage(playerid, COLOR_INFO, "* Use the 'SPRINT' key to choose an option.");
	SendClientMessage(playerid, COLOR_INFO ,"* You can cancel at any time using the 'ACTION' key.");
	
	Player::ShowMenu(playerid, ATMMenu_1);
	TogglePlayerControllable(playerid, false);

	return 1;
}

Bank__PickupIsATM(pickupid)
{
	for(new i = 0; i < MAX_ATMS; i++)
	    if(ATM_Pickups[i] == pickupid)
	        return 1;
	        
	return 0;
}

Bank__OnMenu(playerid, Menu:pmenu, row)
{
	
	// Choose an option
	if(pmenu == ATMMenu_1)
	{
		Player::HideMenu(playerid, pmenu);
		
		switch(row)
		{
		    case 0: Player::ShowMenu(playerid, ATMMenu_2);
		    case 1: Player::ShowMenu(playerid, ATMMenu_3);
		    case 2:
		    {
				new sMessage[128];
				Format(sMessage, "* Your current balance is $ %s", ConvertMoney(PlayerInfo[playerid][BankValue]));
				SendClientMessage(playerid, COLOR_TITLE, sMessage);
				
				Format(sMessage, "* Bank plan: %s.", Bank::GetBankPlan(playerid));
				SendClientMessage(playerid, COLOR_INFO, sMessage);
				
				Format(sMessage, "* Maximum space: $ %s", ConvertMoney(Bank::GetBankSpace(playerid)));
				SendClientMessage(playerid, COLOR_INFO, sMessage);

				Player::ShowMenu(playerid, ATMMenu_1);
			}
		}
		
		return 1;
	}
	
	// Withdraw
	if(pmenu == ATMMenu_2)
	{
	    Player::HideMenu(playerid, pmenu);
	
		switch(row)
		{
		    case 0: Bank::Withdraw(playerid, 100);
		    case 1: Bank::Withdraw(playerid, 1000);
		    case 2: Bank::Withdraw(playerid, 10000);
		    case 3: Bank::Withdraw(playerid, 100000);
		    case 4: Bank::Withdraw(playerid, 1000000);
		}
		
		Player::ShowMenu(playerid, ATMMenu_2);
		return 1;
	}
	
	// Deposit
	if(pmenu == ATMMenu_3)
	{
	    Player::HideMenu(playerid, pmenu);
	
		switch(row)
		{
		    case 0: Bank::Deposit(playerid, 100);
		    case 1: Bank::Deposit(playerid, 1000);
		    case 2: Bank::Deposit(playerid, 10000);
		    case 3: Bank::Deposit(playerid, 100000);
		    case 4: Bank::Deposit(playerid, 1000000);
		}
		
		Player::ShowMenu(playerid, ATMMenu_3);
		return 1;
	}

	return 0;
}

Bank__OnMenuExit(playerid)
{
	new Menu:pBankExit = PlayerInfo[playerid][Menu];
	
	if(pBankExit == ATMMenu_1)
	{
		Player::HideMenu(playerid, ATMMenu_1);
		PlayerInfo[playerid][OnATM] = false;
		
		if(PlayerInfo[playerid][Frozen] == false)
			TogglePlayerControllable(playerid, true);
	}
	else
	{
		Player::HideMenu(playerid, ATMMenu_2);
		Player::HideMenu(playerid, ATMMenu_3);
		
		Player::ShowMenu(playerid, ATMMenu_1);
		
		TogglePlayerControllable(playerid, false);
		
		return 1;
	}
	
	return 1;
}

Bank__GetBankPlan(playerid)
{
	new plan = PlayerInfo[playerid][BankLevel];
	new splan[128];
	
	switch(plan)
	{
	    case BANK_PLAN_NONE: splan = "none";
	    case BANK_PLAN_BASIC: splan = "basic";
	    case BANK_PLAN_BUSINESS: splan = "small business";
	    case BANK_PLAN_PROFESSIONAL: splan = "professional business";
	}
	
	return splan;
}

Bank__GetBankSpace(playerid)
{
	new plan, space;
	
	plan = PlayerInfo[playerid][BankLevel];
	
	switch(plan)
	{
	    case BANK_PLAN_NONE: space = 0;
	    case BANK_PLAN_BASIC: space = 1000000;
	    case BANK_PLAN_BUSINESS: space = 5000000;
	    case BANK_PLAN_PROFESSIONAL: space = 20000000;
	}
	
	return space;
}

Bank__Withdraw(playerid, amount)
{
	new pBank = PlayerInfo[playerid][BankValue];
	
	if(pBank < amount)
	    SendClientMessage(playerid, COLOR_FALSE, "* Your bank account does not appear to be holding that amount of money.");
	else
	{
	    new sMessage[128];
	    
	    GivePlayerMoney(playerid, amount);
	    PlayerInfo[playerid][BankValue] = pBank - amount;
	    
	    Format(sMessage, "* You've successfully withdrawn $ %s from your bank account.", ConvertMoney(amount));
	    SendClientMessage(playerid, COLOR_TRUE, sMessage);
	    Format(sMessage, "%s withdrew $ %s from his/her bank account.", PlayerName(playerid), ConvertMoney(amount));
	    SendAdminMsg(sMessage);
	}
	return 1;
}

Bank__Deposit(playerid, amount)
{
	new sMessage[128];
	new newbalance = PlayerInfo[playerid][BankValue]+amount;
	new space = Bank::GetBankSpace(playerid);

	if(GetPlayerMoney(playerid) < amount)
	{
	    SendClientMessage(playerid, COLOR_FALSE, "* You don't have enough money!");
	}
	else if(space < newbalance)
	{
	    Format(sMessage, "* Unfortunately, your bank plan (%s) only allows a maximum of $ %s,", Bank::GetBankPlan(playerid), ConvertMoney(space));
	    SendClientMessage(playerid, COLOR_TRUE, sMessage);
		Format(sMessage, "* whereas your new balance would become $ %s with a successful deposit.", ConvertMoney(newbalance));
		SendClientMessage(playerid, COLOR_TRUE, sMessage);

		if(space > PlayerInfo[playerid][BankValue])
		{
		    new countvar = space - PlayerInfo[playerid][BankValue];
			amount = countvar;
			
			GivePlayerMoney(playerid, -amount);
			PlayerInfo[playerid][BankValue] += amount;
			
			SendClientMessage(playerid, COLOR_TRUE, "* We've however filled your bank with as much money as it allowed.");
			
			/*Format(sMessage, "%s deposited $ %s to his/her bank account.", PlayerName(playerid), ConvertMoney(amount));
			SendAdminMsg(sMessage);*/
		}
		else
		{
			SendClientMessage(playerid, COLOR_FALSE, "* Your deposit was unsuccessful and rejected.");
		}
	}
	else
	{
	    GivePlayerMoney(playerid, -amount);
        PlayerInfo[playerid][BankValue] += amount;

	    Format(sMessage, "* You've successfully deposited $ %s to your bank account.", ConvertMoney(amount));
	    SendClientMessage(playerid, COLOR_TRUE, sMessage);
	    /*Format(sMessage, "%s deposited $ %s to his/her bank account.", PlayerName(playerid), ConvertMoney(amount));
	    SendAdminMsg(sMessage);*/
	}
	
	return 1;
}
