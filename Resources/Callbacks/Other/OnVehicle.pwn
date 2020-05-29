public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	if(Vehicle::IsPerm(vehicleid))
		Vehicle::OnRespawn(vehicleid);
	else if(Vehicle::IsTemp(vehicleid))
		Vehicle::Destroy(vehicleid);
	
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}
