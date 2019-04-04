class CfgFunctions
{
	class Goko_MagDrop
	{
		tag = "GokoMD";
		class particle
		{
			file = "goko_drop_magz\functions";
			class Pistol_Particle3DFx {};
		};
		class eventhandler
		{
			file = "goko_drop_magz\functions";
			class FiredEH_mainHook {};
		};
		class audio
		{
			file = "goko_drop_magz\functions";
			class AudioSimulation {};
		};
	};
};