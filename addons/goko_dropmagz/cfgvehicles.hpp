class CfgVehicles
{
	class Land;
	class Man: Land
	{
		class EventHandlers;
	};	
	class CAManBase: Man
	{
		class EventHandlers: EventHandlers
		{
			class goko_dropmagz
			{
				init = "_this execVM '\goko_dropmagz\initialize\goko_loadup.sqf'";
			};
		};
	};
};