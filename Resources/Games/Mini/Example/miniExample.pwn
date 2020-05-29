/*

	This file includes all existing minigame callbacks that can be used.
	This makes it easier start on a new minigame.

	1.  Copy & paste Example folder and change every "Example" to your minigames name.
	2.  Add your minigame to the 'MiniNames' variable inside miniCore.pwn and increase it's size by one.
	3.  Begin with miniExampledialogs.pwn and add necessary dialog responses and dialog calls for your own minigame.
		Yes, dialogs are premade for the current options the minigame handler has, you can add more (if needed) very easily.

	
	
	NOTE: You MUST return 0; on the callbacks your minigame doesn't use.
		  Also, if you need any more callbacks it's easy to implement, but ask a lead developer first.
	
*/


public Mini__Example_Process()
{
	return 0;
}

public Mini__Example_Prepare()
{
	return 0;
}

public Mini__Example_Start()
{
	return 0;
}

public Mini__Example_OnSignup(playerid)
{
	return 0;
}

public Mini__Example_OnSpawn(playerid)
{
	return 0;
}

public Mini__Example_OnDeath(playerid, killerid, reason)
{
	return 0;
}

public Mini__Example_OnText(playerid, const text[])
{
	return 0;
}

public Mini__Example_OnFire(playerid)
{
	return 0;
}

public Mini__Example_OnKey(playerid, newkeys, oldkeys)
{
	return 0;
}

public Mini__Example_UpdateMarker(playerid)
{
	return 0;
}


public Mini__Example_UpdateTag(playerid)
{
	return 0;
}

#include miniExampledialogs.pwn

