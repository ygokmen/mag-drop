/* 
 *	Goko Mag Drop add-on v1.22c for ARMA3
 *	Author: gökmen 'the0utsider' çakal
 *	Repo: github.com/the0utsider/mag-drop
 *	
 *	plays 3D sound effect in the world for dropped item
 *	uses variable pitch and randomized samples for authentic simulation
*/

params ["_unit"];

private _SoundSamples = selectRandom
[	
	"goko_drop_magz\SoundFX\gear_impact01.wav",
	"goko_drop_magz\SoundFX\gear_impact02.wav",
	"goko_drop_magz\SoundFX\gear_impact03.wav",
	"goko_drop_magz\SoundFX\gear_impact04.wav",
	"goko_drop_magz\SoundFX\gear_impact05.wav",
	"goko_drop_magz\SoundFX\gear_impact06.wav"
];

private _soldierFeetPos = _unit modelToWorldVisualWorld [0,0,-3];

/// play a sound sample at position below soldiers feet
playsound3d 
[
	_SoundSamples, 
	_unit,
	false,
	_soldierFeetPos,		// position above sea level
	1.2,					// volume dB
	0.8 + random 0.6,		// sound pitch
	33						// sound range in meters
];