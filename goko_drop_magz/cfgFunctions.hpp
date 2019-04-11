class CfgFunctions
{
	class Goko_MagDrop
	{
		tag = "GokoMD";
		class particle
		{
			file = "goko_drop_magz\functions";
			class Magazine_Particle3DFx {};
		};
		class eventhandler
		{
			file = "goko_drop_magz\functions";
			class FiredEH_mainHook {};
			class FiredEH_ReloadingStage2 {};
		};
		class audio
		{
			file = "goko_drop_magz\functions";
			class AudioSimulation {};
		};
		class initialize
		{
			file = "\goko_drop_magz\initialize";
			class preload {preInit = 1};
			class loadup {};
		}
	};
};