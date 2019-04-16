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
				fired	= "_this call GSM_fnc_detectReload";
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
			class GSM_popMagPistol
			{
				fired	= "_this call GSM_fnc_detectReload";
			}
			
		};
	};
};