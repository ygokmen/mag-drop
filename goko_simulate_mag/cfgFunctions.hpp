class CfgFunctions
{
	class Goko_Simulate_Mag
	{
		tag = "GSM";
		class particle
		{
			file = "goko_simulate_mag\functions";
			class particle3D {};
			class transformSimpleObject {};
		};
		class eventhandler
		{
			file = "goko_simulate_mag\functions";
			class detectReload {};
			class prepSimulation {};
		};
		class audio
		{
			file = "goko_simulate_mag\functions";
			class AudioSimulation {};
		};
		class init
		{
			file = "goko_simulate_mag\functions";
			class CBASettings {};
		};
	};
};