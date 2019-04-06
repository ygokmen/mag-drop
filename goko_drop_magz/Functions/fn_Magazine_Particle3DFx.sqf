/* 
 *	Goko Mag Drop add-on v1.22c for ARMA3
 *	Author: gökmen 'the0utsider' çakal
 *	Repo: github.com/the0utsider/mag-drop
 *	
 *	3D Particle fx function - spawns 3d particle with physics simulation
 *	spawns script to create super simple object on ground
*/

params ["_unit","_relativeVelocity", "_ammoModelP3D", "_cachedAttachToCount"];

/// attach a particle source at hands of unit and spawn a magazine model with physics simulation
private _popOutMagazine = "#particleSource" createVehicleLocal (getPosATL _unit);
_popOutMagazine setParticleParams
[
	/*Sprite*/				[_ammoModelP3D,1,18,1,0],"",// File,Ntieth,Index,Count,Loop
	/*Type*/				"spaceObject",
	/*TimmerPer*/			0.9,
	/*Lifetime*/			1,
	/*Position*/			[0,0,0],
	/*MoveVelocity*/		_relativeVelocity,
	/*Simulation*/			random 1.5, 3.8, 1, 0.13,//rotationVel,weight,volume,rubbing
	/*Scale*/				[0.9],
	/*Color*/				[[1,1,1,1],[1,1,1,1]],
	/*AnimSpeed*/			[1,1],
	/*randDirPeriod*/		0.1,
	/*randDirIntesity*/		0.05,
	/*onTimerScript*/		"\goko_drop_magz\Functions\TransformIntoSimpleObject.sqf",
	/*DestroyScript*/		"",
	/*Follow*/				"",
	/*Angle*/				0,
	/*onSurface*/			false,
	/*bounceOnSurface*/		0.22,
	/*emissiveColor*/		[[0,0,0,0]]
	/**3D Array Vector dir	[random 0.5, random -0.5, -1 + random 2]  DEV BRANCH ONLY!!!!!!! wont be available until 1.92@stable */
];

private _modelMemoryPoints = selectRandom ["lwrist", "rwrist", "rwrist"];
_popOutMagazine setDropInterval 7777; // man is five, devil is six, god is seven!!11!1!
_popOutMagazine attachTo [_unit, [0,0,0], _modelMemoryPoints];

/// detach and get rid of particle source. (still needs testing if this needs delay or not) using small delay with cba WaE
/// Array count from previous function represents last added attached array object above without any modification.
private _attachedLast = attachedObjects _actor;

[{	
	detach (_this#0 select _this#1); 
	deleteVehicle (_this#0 select _this#1);
}, [_attachedLast, _cachedAttachToCount], 0.1] call CBA_fnc_waitAndExecute;

[{	
	_this call GokoMD_fnc_AudioSimulation;
}, _unit, 0.7] call CBA_fnc_waitAndExecute;
