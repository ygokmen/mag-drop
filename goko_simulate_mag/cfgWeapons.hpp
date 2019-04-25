class CfgWeapons
{
	class RifleCore;
	class Rifle : RifleCore 
	{
		class Eventhandlers;
	};
	class Rifle_Base_F: Rifle 
	{
		// inheriting Eventhandlers class for better modcross compatibility
		class Eventhandlers: Eventhandlers 
		{
			class GSM_popMagRifle
			{
				//fired	= "_this call GSM_fnc_detectReload";
				reload	= "_this call GSM_fnc_prepSimRifle";
			}
		};
	};
	class PistolCore;
	class Pistol : PistolCore 
	{
		class Eventhandlers;
	};
	class Pistol_Base_F: Pistol 
	{
		// inheriting Eventhandlers class for better modcross compatibility
		class Eventhandlers: Eventhandlers 
		{
			class GSM_popMagHandgun
			{
				//fired	= "_this call GSM_fnc_detectReload";
				reload	= "_this call GSM_fnc_prepSimHandgun";
			}
			
		};
	};
};