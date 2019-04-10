/* 
 *	Goko Mag Drop add-on v1.23 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *	
 *	3D Particle fx function - spawns 3d particle with physics simulation
 *	later spawns script to create super simple object on ground on timer
*/

params ["_unit", "_relativeVelocity", "_ammoModelP3D", "_cachedAttachToCount", "_bModelNeedsTilting"];

private _placeSuperSimpleObject = if (_bModelNeedsTilting) then
{
	"\goko_drop_magz\Functions\TransformIntoSimpleObjectSpecial.sqf"
} else {
	"\goko_drop_magz\Functions\TransformIntoSimpleObject.sqf"
};

/// attach a particle source at hands of unit and spawn a magazine model with physics simulation
private _popOutMagazine = "#particleSource" createVehicleLocal (getPosATL _unit);
_popOutMagazine setParticleParams
[
	/*Sprite*/				[_ammoModelP3D,1,18,1,0],"",// File,Ntieth,Index,Count,Loop
	/*Type*/				"spaceObject",
	/*TimerSeconds*/		0.6,
	/*LifetimeSeconds*/		1.1,
	/*Position*/			[0,0,0],
	/*MoveVelocity*/		_relativeVelocity,
	/*Simulation*/			random 1.5, 1, 0.000139253, 0.07,//rotationVel,weight,volume,rubbing
	/*Scale*/				[0.9],
	/*Color*/				[[1,1,1,1],[1,1,1,1]],
	/*AnimSpeed*/			[1,1],
	/*randDirPeriod*/		0.1,
	/*randDirIntesity*/		0.01,
	/*onTimerScript*/		_placeSuperSimpleObject,
	/*DestroyScript*/		"",
	/*Follow*/				"",
	/*Angle*/				0,
	/*onSurface*/			false,
	/*bounceOnSurface*/		0.15,
	/*emissiveColor*/		[[0,0,0,0]]
	/**3D Array Vector dir	[random 0.5, random -0.5, -1 + random 2]  DEV BRANCH ONLY!!!!!!! wont be available until 1.92@stable */
];

private _modelMemoryPoints = selectRandom ["lwrist", "rwrist", "rightHandmiddle1", "granat"];
_popOutMagazine setDropInterval 7777; // man is five, devil is six, god is seven!!11!1!
_popOutMagazine attachTo [_unit, [0,0,0], _modelMemoryPoints];

/// detach and get rid of particle source. NOTE: particle source will stay there, don't matter lifetime or interval of spawned particles.
/// Array count from previous function represents last added attached array object above which is particle source.
/// small delay before detach&destroying this particle source is necessary. It wont spawn particles unless a delay is present.
private _attachedListLast = attachedObjects _unit;
[{	
	detach (_this#0 select _this#1); 
	deleteVehicle (_this#0 select _this#1);
}, [_attachedListLast, _cachedAttachToCount], 0.1] call CBA_fnc_waitAndExecute;
