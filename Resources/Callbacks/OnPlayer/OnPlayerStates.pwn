/*  Defined in defines.pwn
#define HOLDING(%0) ((newkeys & (%0)) == (%0))
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
*/

#define JumpKey 			KEY_CROUCH
#define SBKey               KEY_ACTION
#define NosKey 				KEY_FIRE
#define FlipKey 			KEY_ANALOG_RIGHT
#define ColorChangeKey 		KEY_ANALOG_LEFT
#define FixKey				KEY_SUBMISSION
#define SpeedBoost 			2
#define Jump 				0.3

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if( (PRESSED(KEY_FIRE)) || (PRESSED(KEY_FIRE) && PRESSED(KEY_SECONDARY_ATTACK)) )
			Player::OnFire(playerid);

	if(Mini::IsPlaying(playerid) && Mini::IsRunning())
 		return Mini::OnKey(playerid, newkeys, oldkeys);

	if(IsPlayerInAnyVehicle(playerid))
	{
  		if(PlayerInfo[playerid][Ramping] && PRESSED(KEY_ACTION))
			Ramping::OnKey(playerid);
  
		//--------VEHICLE FUNCTIONS------------
  		if(PlayerInfo[playerid][VehFunct])
  		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(newkeys & ColorChangeKey) // Color Change
			{
				new colors = random(126);
				new colors2 = random(126);
				ChangeVehicleColor(vehicleid, colors, colors2);
			}
			if(newkeys & JumpKey) // Jump
			{
				new Float:vehx; new Float:vehy; new Float:vehz;
				GetVehicleVelocity(vehicleid,vehx,vehy,vehz);
				SetVehicleVelocity(vehicleid,vehx,vehy,vehz+Jump);
			}
			if(newkeys & NosKey) // Nos
			{
			    new ShowMess;
				AddVehicleComponent(vehicleid,1010);
				ShowMess = random(4);
				if(ShowMess == 2) GameTextForPlayer(playerid,"NOS",1000,4);
			}
			if(newkeys & FlipKey) // Flip
			{
				new Float:X, Float:Y, Float:Z, Float:Angle; GetPlayerPos(playerid, X, Y, Z);
				GetVehicleZAngle(vehicleid, Angle);
				SetVehiclePos(vehicleid, X, Y, Z+1);
				SetVehicleZAngle(vehicleid, Angle);
				RepairVehicle(GetPlayerVehicleID(playerid));
				GameTextForPlayer(playerid,"FLIPPED",1000,3);
			}
			if(newkeys & SBKey) // SpeedBoost
			{
				new Float:vehx; new Float:vehy; new Float:vehz;
				GetVehicleVelocity(vehicleid,vehx,vehy,vehz);
				SetVehicleVelocity(vehicleid,vehx*SpeedBoost,vehy*SpeedBoost,vehz*SpeedBoost);
			}
			if(newkeys & FixKey) // Fix
			{
				RepairVehicle(GetPlayerVehicleID(playerid));
				GameTextForPlayer(playerid,"FIXED",1000,3);
			}
		}
	}
	else
	{
		if(newkeys & KEY_SPRINT) // Player pressed SPACE
		{
		    if(PlayerInfo[playerid][Spectating] == true) // Spectating
		    {
		        if(CW::IsInvolved(playerid))
					return CW::SpecNextPlayer(playerid);
				else if(IsMod(playerid))
				    return Spectate::NextPlayer(playerid);
			}
			if(PlayerInfo[playerid][Hax] == true)
				return Hax::SuperJump(playerid);

			return 1;
		}
	}
	
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

