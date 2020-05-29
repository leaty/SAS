#define MAX_PERM_VEHICLES       102
#define MAX_TEMP_VEHICLES       100

new Vehicles[MAX_PERM_VEHICLES];
new TempVehicle[100];
new TempVehicles = 0;


new Float:Vehicles_Pos[MAX_PERM_VEHICLES][4] =
{
	{ -1979.330444, 432.393737, 25.294820, 358.945739 },
	{ -1921.358154, 236.014221, 34.541213, 89.974609  },
	{ -1988.431274, 275.903228, 34.902683, 88.889923  },
	{ -1989.506713, 262.087371, 35.232910, 86.392494  },
	{ -1955.895751, 303.203552, 40.753299, 179.255447 },
	{ -1948.365966, 255.951187, 35.015506, 178.507965 },
	{ -1949.463134, 255.904571, 35.024074, 180.491683 },
	{ -1944.203979, 272.585937, 35.370113, 180.014007 },
	{ -2613.494140, 183.609451, 4.390219, 0.459724 	  },
	{ -2688.278320, 268.278717, 4.092134, 177.724441  },
	{ -2681.655273, 268.486236, 4.052121, 180.077896  },
	{ -2661.746582, 268.065399, 4.477473, 178.424468  },
	{ -2674.395019, 863.328002, 75.821372, 0.391713   },
	{ -2664.924804, 913.380065, 79.438682, 0.708365   },
	{ -2680.966308, 870.145690, 76.512405, 19.203969  },
	{ -2722.305419, 915.837097, 67.301994, 90.000000  },
	{ -1821.874389, 1060.795166, 45.645896, 1.788870  },
	{ -1821.374389, 1096.049316, 45.081470, 90.552490 },
	{ -1876.348754, 1124.703857, 45.059059, 0.568007  },
	{ -1794.597412, 1225.608154, 32.379394, 179.811279 },
	{ -1783.597900, 1210.991699, 32.138912, 90.517364 },
	{ -1660.794677, 1215.286865, 33.083072, 22.450216 },
	{ -1700.316406, 1216.161987, 32.472064, 2.922283 },
	{ -2655.883789, -278.669586, 7.376331, 316.637329 },
	{ -2644.696777, -289.374816, 7.257549, 135.383026 },
	{ -2659.551513, -289.583435, 7.271258, 314.947998 },
	{ -2792.498291, -376.339691, 7.059659, 179.946731 },
	{ -2771.102294, -312.103027, 6.779085, 181.824722 },
	{ -2744.922607, -278.690399, 7.213453, 270.419403 },
	{ -2771.499023, -282.606567, 6.750005, 359.494720 },
	{ -2738.107421, -296.481842, 6.569893, 228.275253 },
	{ -2725.821777, -196.850479, 4.063019, 89.564224 },
	{ -2653.192138, -341.009307, 6.717943, 2.694316 },
	{ -2436.537841, -288.463409, 39.322162, 123.045349 },
	{ -2434.659912, -164.158279, 35.127288, 90.319717 },
	{ -2449.250244, -87.704437, 34.097602, 1.123354 },
	{ -2520.635009, -602.495178, 132.123840, 359.450958 },
	{ -2499.424072, -677.706604, 139.691589, 359.593139 },
	{ -2494.487548, -602.275939, 132.386398, 0.233232 },
	{ -2408.835693, -584.056762, 132.333190, 36.268398 },
	{ -2398.066650, -592.254882, 132.309555, 125.436614 },
	{ -2394.742675, -609.731933, 132.377029, 214.918518 },
	{ -2120.021728, 276.754364, 35.100528, 90.302322 },
	{ -2134.114501, 262.630676, 35.300338, 359.703155 },
	{ -2085.073730, 307.851318, 35.135982, 90.328788 },
	{ -2139.044677, 353.045379, 35.438037, 359.521087 },
	{ -2164.743408, 367.573394, 35.449375, 90.210891 },
	{ -1964.067016, 437.838592, 34.971878, 0.268705 },
	{ -1584.125000, 1078.284790, 7.497308, 180.000000 },
	{ -1513.549804, 1023.111083, 6.914582, 180.092788 },
	{ -1461.348266, 1023.835144, -0.786588, 90.971588 },
	{ -1495.170654, 931.536926, 6.987481, 179.647216 },
	{ -1649.341430, 1203.946411, 12.955669, 269.906616 },
	{ -1649.260864, 1206.051025, 12.955760, 273.218963 },
	{ -1663.724853, 1224.752441, 13.507387, 44.943153 },
	{ -1656.173217, 1217.287963, 20.994855, 224.848800 },
	{ -1588.240112, 673.880065, 6.954274, 0.371154 },
	{ -1600.169677, 672.956909, 6.958106, 178.292098 },
	{ -1605.768188, 673.549621, 7.379367, 182.122070 },
	{ -1679.807739, 706.422546, 30.778228, 270.461486 },
	{ -1942.722534, 688.415405, 146.953796, 92.174285 },
	{ -2197.489257, 990.126831, 79.626007, 92.522827 },
	{ -2196.220214, 971.672607, 79.706474, 92.097999 },
	{ -2189.941894, 1032.510375, 79.723106, 0.068528 },
	{ -2217.357421, 1056.554321, 79.676795, 89.023300 },
	{ -2217.210937, 1055.020874, 79.570762, 87.154953 },
	{ -2520.243896, 1148.044921, 55.499748, 355.614196 },
	{ -2562.664306, -327.493957, 24.340065, 97.319015 },
	{ -2473.734130, 1070.603271, 55.531250, 180.892852 },
	{ -2465.998291, 1070.087158, 55.557338, 179.521209 },
	{ -2409.870361, 1139.988525, 55.552452, 349.564331 },
	{ -2480.861083, 1069.959472, 55.429840, 180.296783 },
	{ -2414.114257, 969.589904, 45.093040, 180.399108 },
	{ -2098.976562, 820.146728, 69.385902, 359.552368 },
	{ -2117.446533, 800.025390, 69.298919, 179.617645 },
	{ -2155.573974, 835.728210, 69.297973, 91.794143 },
	{ -2151.346923, 761.495239, 69.220283, 359.948577 },
	{ -2097.277832, 710.990844, 69.123893, 179.753662 },
	{ -2097.216308, 707.535766, 69.132865, 179.596206 },
	{ -2102.978271, 654.876892, 52.038024, 178.662185 },
	{ -1942.792724, 558.347229, 34.886993, 270.928039 },
	{ -2085.929443, 61.581905, 35.109363, 273.203491 },
	{ -2085.551757, 386.632812, 35.778850, 88.979354 },
	{ -2054.753906, 456.574829, 35.264217, 227.165557 },
	{ -2185.961669, 513.356628, 34.971145, 89.416915 },
	{ -2273.817626, 700.793640, 49.148345, 180.671325 },
	{ -2506.262939, 774.092834, 35.716758, 90.066490 },
	{ -2513.178955, 762.644653, 34.749107, 93.324378 },
	{ -2513.101562, 760.365051, 34.750194, 87.534698 },
	{ -2513.241943, 764.979370, 34.732513, 92.421112 },
	{ -2492.966552, 795.230041, 35.264995, 89.986183 },
	{ -2462.513183, 787.416442, 35.726497, 91.990905 },
	{ -2468.986572, 741.187194, 34.675350, 1.663108 },
	{ -2473.281738, 741.062622, 34.758487, 0.786338 },
	{ -2438.138427, 741.177856, 34.787471, 359.514617 },
	{ -2557.937255, 625.779785, 27.359529, 180.244338 },
	{ -2583.832031, 626.991821, 27.961256, 179.402374 },
	{ -2571.412597, 657.785217, 14.601951, 269.761383 },
	{ -2572.170654, 647.617431, 14.602913, 89.833007 },
	{ -2546.401611, 647.234497, 14.608296, 88.443763 },
	{ -2571.781005, 628.047424, 14.222863, 90.170913 },
	{ -2589.143554, 637.773925, 14.220445, 89.941764 }
};

new Vehicles_Data[MAX_PERM_VEHICLES][3] =
{
	{ 411, 0, 102 },
	{ 468, 0, 102 },
	{ 411, 0, 102 },
	{ 459, 0, 102 },
	{ 451, 0, 102 },
	{ 522, 0, 102 },
	{ 522, 0, 102 },
	{ 494, 0, 102 },
	{ 498, 0, 102 },
	{ 491, 0, 102 },
	{ 496, 0, 102 },
	{ 489, 0, 102 },
	{ 521, 0, 102 },
	{ 535, 0, 102 },
	{ 536, 0, 102 },
	{ 560, 0, 102 },
	{ 522, 0, 102 },
	{ 496, 0, 102 },
	{ 552, 0, 102 },
	{ 411, 0, 102 },
	{ 471, 0, 102 },
	{ 487, 0, 102 },
	{ 521, 0, 102 },
	{ 458, 0, 102 },
	{ 474, 0, 102 },
	{ 475, 0, 102 },
	{ 470, 0, 102 },
	{ 467, 0, 102 },
	{ 431, 0, 102 },
	{ 560, 0, 102 },
	{ 522, 0, 102 },
	{ 411, 0, 102 },
	{ 433, 0, 102 },
	{ 462, 0, 102 },
	{ 401, 0, 102 },
	{ 400, 0, 102 },
	{ 522, 0, 102 },
	{ 444, 0, 102 },
	{ 507, 0, 102 },
	{ 562, 0, 102 },
	{ 562, 0, 102 },
	{ 411, 0, 102 },
	{ 542, 0, 102 },
	{ 468, 0, 102 },
	{ 466, 0, 102 },
	{ 482, 0, 102 },
	{ 490, 0, 102 },
	{ 409, 0, 102 },
	{ 449, 0, 102 },
	{ 411, 0, 102 },
	{ 446, 0, 102 },
	{ 409, 0, 102 },
	{ 571, 0, 102 },
	{ 571, 0, 102 },
	{ 402, 0, 102 },
	{ 603, 0, 102 },
	{ 597, 0, 102 },
	{ 597, 0, 102 },
	{ 599, 0, 102 },
	{ 497, 0, 102 },
	{ 548, 0, 102 },
	{ 565, 0, 102 },
	{ 560, 0, 102 },
	{ 527, 0, 102 },
	{ 468, 0, 102 },
	{ 521, 0, 102 },
	{ 551, 0, 102 },
	{ 402, 0, 102 },
	{ 467, 0, 102 },
	{ 436, 0, 102 },
	{ 507, 0, 102 },
	{ 562, 0, 102 },
	{ 580, 0, 102 },
	{ 550, 0, 102 },
	{ 404, 0, 102 },
	{ 426, 0, 102 },
	{ 547, 0, 102 },
	{ 522, 0, 102 },
	{ 522, 0, 102 },
	{ 518, 0, 102 },
	{ 527, 0, 102 },
	{ 403, 0, 102 },
	{ 403, 0, 102 },
	{ 400, 0, 102 },
	{ 421, 0, 102 },
	{ 401, 0, 102 },
	{ 408, 0, 102 },
	{ 462, 0, 102 },
	{ 448, 0, 102 },
	{ 522, 0, 102 },
	{ 418, 0, 102 },
	{ 408, 0, 102 },
	{ 562, 0, 102 },
	{ 426, 0, 102 },
	{ 436, 0, 102 },
	{ 522, 0, 102 },
	{ 416, 0, 102 },
	{ 416, 0, 102 },
	{ 416, 0, 102 },
	{ 416, 0, 102 },
	{ 597, 0, 102 },
	{ 597, 0, 102 }
};

Vehicle__Init()
{
	new sReport[256];
	new color1, color2, shouldhavehc, shouldhavepj, paintjob, iCount;
	
	for(new i = 0; i < MAX_PERM_VEHICLES; i++)
	{
	    // Should the vehicle have default or random colors?
	    if(!Vehicle::IsColorModel(Vehicles_Data[i][0]))
	    {
	        color1 = -1;
	        color2 = -1;
	        paintjob = -1;
		}
		else
		{
	        // It's one chance out of 5 that this vehicle can get hidden + two different colors
			shouldhavehc = random(5);

			if(shouldhavehc > 0)
			{
			    color1 = random(127);
			    color2 = color1;
			}
			else
		    {
			    color1 = random(255);
				color2 = random(255);

				while(!Vehicle::IsValidColor(color1))
				    color1 = random(255);

				while(!Vehicle::IsValidColor(color2))
				    color2 = random(255);
			}
			    
			// It's one chance out of 10 that this vehicle gets a paintjob
			shouldhavepj = random(10);

			paintjob = random(3);

			if(shouldhavepj > 0)
			    paintjob = -1;
		}

		// All done, make the vehicle :D
		Vehicles[i] = CreateVehicle(Vehicles_Data[i][0], Vehicles_Pos[i][0], Vehicles_Pos[i][1], Vehicles_Pos[i][2], Vehicles_Pos[i][3], color1, color2, 100);
		LinkVehicleToInterior(Vehicles[i], Vehicles_Data[i][1]);
		SetVehicleVirtualWorld(Vehicles[i], Vehicles_Data[i][2]);
		ChangeVehiclePaintjob(Vehicles[i], paintjob);
		
		iCount++;
 	}
 	
 	Format(sReport, "[Vehicle] %d Vehicles successfully created, initialization end.", iCount);
 	SendReport(sReport);
 	
 	return 1;
}

Vehicle__OnRespawn(vehicleid)
{
	new color1;
	new color2;
	new shouldhavehc;
	new paintjob;
	new shouldhavepj;
	new varrayid = Vehicle::GetPermArrayID(vehicleid);
	
 	// Should the vehicle have default or random colors?
    if(!Vehicle::IsColorModel(Vehicles_Data[varrayid][0]))
    {
        color1 = -1;
        color2 = -1;
        paintjob = -1;
	}
	else
	{
        // It's one chance out of 5 that this vehicle can get hidden + two different colors
		shouldhavehc = random(5);

		if(shouldhavehc > 0)
		{
		    color1 = random(127);
		    color2 = color1;
		}
		else
	    {
		    color1 = random(255);
			color2 = random(255);

			while(!Vehicle::IsValidColor(color1))
			    color1 = random(255);

			while(!Vehicle::IsValidColor(color2))
			    color2 = random(255);
		}
		    
		// It's one chance out of 10 that this vehicle gets a paintjob
		shouldhavepj = random(10);
		
		paintjob = random(3);
		
		if(shouldhavepj > 0)
		    paintjob = -1;
	}

	SetVehiclePos(vehicleid, Vehicles_Pos[varrayid][0], Vehicles_Pos[varrayid][1], Vehicles_Pos[varrayid][2]);
	SetVehicleVirtualWorld(vehicleid, Vehicles_Data[varrayid][2]);
	LinkVehicleToInterior(vehicleid, Vehicles_Data[varrayid][1]);
	ChangeVehicleColor(vehicleid, color1, color2);
	ChangeVehiclePaintjob(vehicleid, paintjob);
	    
	return 1;
}

Vehicle__IsValidColor(colorid)
{
	if(colorid < 0)
	    return 0;
	    
	if(colorid > 126)
	{
	    if(colorid == 129)
	        return 0;
	        
		if(colorid > 132 && colorid < 142)
		    return 0;
		    
		if(colorid == 143)
		    return 0;
		    
		if(colorid == 177 || colorid == 178 || colorid == 179)
		    return 0;
		    
		if(colorid > 186 && colorid < 236)
		    return 0;
	}
	
	return 1;
}

Vehicle__IsPerm(vehicleid)
{
	for(new i = 0; i < MAX_PERM_VEHICLES; i++)
	    if(Vehicles[i] == vehicleid)
	        return 1;
	        
 	return 0;
}

Vehicle__IsTemp(vehicleid)
{
	for(new i = 0; i < MAX_TEMP_VEHICLES; i++)
	    if(TempVehicle[i] == vehicleid)
	        return 1;

 	return 0;
}

Vehicle__Destroy(vehicleid)
{
	for(new i = 0; i < MAX_TEMP_VEHICLES; i++)
	{
		if(TempVehicle[i] == vehicleid)
		{
		    TempVehicles--;
		    DestroyVehicle(TempVehicle[i]);
		    break;
		}
	}
	return 1;
}

Vehicle__GetPermArrayID(vehicleid)
{
	for(new i = 0; i < MAX_PERM_VEHICLES; i++)
	{
	    if(Vehicles[i] == vehicleid)
	        return i;
	}
	return -1;
}

/* Intended for later use
Vehicle__GetTempArrayID(vehicleid)
{
	for(new i = 0; i < MAX_TEMP_VEHICLES; i++)
	{
	    if(TempVehicle[i] == vehicleid)
	        return i;
	}
	return 0;
}
*/

Vehicle__GetPermVehicleID(const vehiclename[])
{
	new iModel = Vehicle::GetModelFromName(vehiclename);

	if(iModel == -1 || iModel < 400 || iModel > 611)
	    return -1;

	for(new i = 0; i < MAX_PERM_VEHICLES; i++)
	    if(Vehicles_Data[i][0] == iModel && !Vehicle::Busy(Vehicles[i]))
	        return Vehicles[i];
	        
	return -1;
}

Vehicle__GetModelFromName(const vehiclename[])
{
    for(new i = 0; i < 211; i++)
    {
        if(!strfind(VehicleNames[i], vehiclename, true))
        	return i + 400;
    }
    return -1;
}

// Is this vehicle being used by someone?
Vehicle__Busy(vehicleid)
{
	for(new i = 0; i < MaxSlots; i++)
	{
	    if(GetPlayerVehicleID(i) == vehicleid)
	        return 1;
	}
	
	return 0;
}

// Function: IsColorModel
// Information: This checks if a vehicle model can or should (in our opinion) use colors
// Author: iou
// Returns: 1/0
Vehicle__IsColorModel(modelid)
{
	if(modelid == 409) return 0; // Stretch (limousin)
	if(modelid == 416) return 0; // Ambulance
	if(modelid == 420) return 0; // Taxi
	if(modelid == 433) return 0; // Barracks (military truck)
	if(modelid == 438) return 0; // Cabbie
	if(modelid == 523) return 0; // Cop Bike
	if(modelid == 427) return 0; // Enforcer
	if(modelid == 490) return 0; // FBI Rancher
	if(modelid == 497) return 0; // Police Maverick (helicopter)
	if(modelid == 528) return 0; // FBI Truck
	if(modelid == 407) return 0; // Firetruck
	if(modelid == 544) return 0; // Firetruck LA
	if(modelid == 596) return 0; // Police Car (LSPD)
	if(modelid == 597) return 0; // Police Car (SFPD)
	if(modelid == 598) return 0; // Police Car (LVPD)
	if(modelid == 599) return 0; // Ranger (police)
	if(modelid == 432) return 0; // Rhino (military)
	if(modelid == 601) return 0; // S.W.A.T.
	if(modelid == 548) return 0; // Cargobob (military heli)
	if(modelid == 425) return 0; // Hunter   (military heli)
	if(modelid == 563) return 0; // Raindance (some heli)
	
	return 1;
}


