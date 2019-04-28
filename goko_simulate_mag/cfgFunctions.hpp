class CfgFunctions
{
	class Goko_Simulate_Mag
	{
		tag = "GSM";
		class init
		{
			file = "goko_simulate_mag\functions";
			class CBASettings {};
		};
		class eventhandler
		{
			file = "goko_simulate_mag\functions";
			class detectEmptyMag {};
			class prepSimulation {};
			class getGenericMag {};
		};
		class audio
		{
			file = "goko_simulate_mag\functions";
			class AudioSimulation {};
		};
		class particle
		{
			file = "goko_simulate_mag\functions";
			class particle3D {};
			class transformSimpleObject {};
		};
	};
};