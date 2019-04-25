/* 
 *	Goko Mag Drop add-on v1.26 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *	
 *	plays 3D sound effect in the world for dropped item
 *	uses randomized pitch & samples for authentic simulation
*/

params ["_unit", "_foundMagazineP3D", "_bModelNeedsTilting"];

private _manualAdjustPos = if (isnil{_unit getVariable "GMS_var_particlePos"}) then 
{
	_unit getRelPos [(0.6 + round random 0.5), (280 + round random 160)];
} else {
	AGLToASL (_unit getVariable "GMS_var_particlePos");
};

private _SoundSamples = selectRandom
[	
	"goko_simulate_mag\SoundFX\gear_impact01.wav",
	"goko_simulate_mag\SoundFX\gear_impact02.wav",
	"goko_simulate_mag\SoundFX\gear_impact03.wav",
	"goko_simulate_mag\SoundFX\gear_impact04.wav",
	"goko_simulate_mag\SoundFX\gear_impact05.wav",
	"goko_simulate_mag\SoundFX\gear_impact06.wav"
];

/// play a sound sample at position
playsound3d 
[
	_SoundSamples, 
	_unit,				// this is ignored since position ASL provided.
	false,					// buggy
	_manualAdjustPos,		// position asl
	1.2,					// volume dB
	0.9 + random 0.6,		// sound pitch
	25						// sound range in meters
];

/// place simple object (time delay synched with particle3D disappearance)
[
	{	
		_this call GSM_fnc_transformSimpleObject;
	}, 
	[
		_unit,
		_foundMagazineP3D,
		_bModelNeedsTilting
	], 
	0.5
] call CBA_fnc_waitAndExecute;
