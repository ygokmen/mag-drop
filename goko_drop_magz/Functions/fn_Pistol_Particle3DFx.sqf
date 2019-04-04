/* 
 *	Goko Mag Drop add-on v1.22c for ARMA3
 *	Author: gökmen 'the0utsider' çakal
 *	Repo: github.com/the0utsider/mag-drop
 *	
 *	3D Particle fx function - spawns 3d particle with physics simulation
 *	spawns script to create super simple object on ground
*/

params ["_unit","_relativeVelocity", "_ammoCfg", "_cachedFxCount"];

/// attach a particle source at hands of unit and spawn a magazine model with physics simulation
private _popOutMagazine = "#particleSource" createVehicleLocal (getPosATL _unit);
_popOutMagazine setParticleParams
[
	/*Sprite*/				[_ammoCfg,1,18,1,0],"",// File,Ntieth,Index,Count,Loop
	/*Type*/				"spaceObject",
	/*TimmerPer*/			0.9,
	/*Lifetime*/			1,
	/*Position*/			[0,0,0],
	/*MoveVelocity*/		_relativeVelocity,
	/*Simulation*/			random 1, 3.4, 1, 0.12,//rotationVel,weight,volume,rubbing
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
	/*bounceOnSurface*/		0.21,
	/*emissiveColor*/		[[0,0,0,0]],
	/*3D Array Vector dir*/	[random 0.5, random -0.5, -1 + random 2]
];
private _modelMemoryPoints = selectRandom ["lwrist", "rwrist"]; 
_popOutMagazine setDropInterval 10; 
_popOutMagazine attachTo [_unit, [0,0,0], _modelMemoryPoints];

/// detach and get rid of particle source safely
private _attachedArr = attachedObjects _unit;
private _particleSourceExists = _attachedArr findIf { (typeOf _x) isEqualto "#particleSource"};
private _findLastAddedParticle = _particleSourceExists + _cachedFxCount;

if !(_particleSourceExists == -1 && {_cachedFxCount == 0}) then {
	[{	
		detach (_this#0 select _this#1); 
		deleteVehicle (_this#0 select _this#1);
	}, [_attachedArr, _findLastAddedParticle], 1] call CBA_fnc_waitAndExecute;
};

[{	
	_this call GokoMD_fnc_AudioSimulation;
}, _unit, 0.7] call CBA_fnc_waitAndExecute;