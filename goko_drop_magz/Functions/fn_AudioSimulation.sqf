/* 
 *	Goko Mag Drop add-on v1.23 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *	
 *	plays 3D sound effect in the world for dropped item
 *	uses variable pitch and randomized samples for authentic simulation
*/

params ["_unit", "_soldierFeetPos"];

private _SoundSamples = selectRandom
[	
	"goko_drop_magz\SoundFX\gear_impact01.wav",
	"goko_drop_magz\SoundFX\gear_impact02.wav",
	"goko_drop_magz\SoundFX\gear_impact03.wav",
	"goko_drop_magz\SoundFX\gear_impact04.wav",
	"goko_drop_magz\SoundFX\gear_impact05.wav",
	"goko_drop_magz\SoundFX\gear_impact06.wav"
];

/// play a sound sample at position
playsound3d 
[
	_SoundSamples, 
	_unit,
	false,					//buggy
	_soldierFeetPos,		// position above sea level
	1.0,					// volume dB
	0.8 + random 0.6,		// sound pitch
	30						// sound range in meters
];
