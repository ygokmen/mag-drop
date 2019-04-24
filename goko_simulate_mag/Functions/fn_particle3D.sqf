/* 
 *	Goko Mag Drop add-on v1.26 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *	
 *	3D Particle fx function - spawns 3d particle with physics simulation
 *	
*/

params ["_unit", "_ammoModelP3D", "_cachedAttachToCount"];

/// velocity to pass on magazine: calculate forward vector of actor 
//  and bump it a little if unit moving so particle can drop in front of unit
private _randomizeVector = [-2 + random 4, -2 + random 4, 0];
private _forwardVelocity = (_unit weaponDirection currentWeapon _unit) vectorMultiply 3;
private _finalVelocity = if !(velocityModelSpace _unit # 1 isEqualTo 0) then
{
	velocity _unit;
} else {
	vectorNormalized (_forwardVelocity vectorAdd _randomizeVector);
};

/// attach a particle source at hands of unit and spawn a magazine model with physics simulation
private _popOutMagazine = "#particleSource" createVehicleLocal (getPosATL _unit);
_popOutMagazine setParticleParams
[
	/*Sprite*/			[_ammoModelP3D,1,0,1,0],"", // File,Ntieth,Index,Count,Loop
	/*Type*/			"spaceObject",
	/*TimerSeconds*/	0.4,
	/*LifetimeSeconds*/	1.1,
	/*Position*/		[0,0,0],
	/*MoveVelocity*/	_finalVelocity,
	/*Simulation*/		random 1, 10, 0.0139253, 0.125,//rotationVel,weight,volume,rubbing
	/*Scale*/			[0.9],
	/*Color*/			[[1,1,1,1]],
	/*AnimSpeed*/		[1,1],
	/*randDirPeriod*/	0.4,
	/*randDirIntesity*/	0.01,
	/*onTimerScript*/	"\goko_simulate_mag\Functions\storeParticlePosition.sqf",
	/*DestroyScript*/	"",
	/*Follow*/			"",
	/*Angle*/			0,
	/*onSurface*/		false,
	/*bounceOnSurface*/	0.2,
	/*emissiveColor*/	[[0,0,0,0]]
	/**3D Array Vector dir DEV BRANCH ONLY!!!!!!! wont be available until 1.93@stable */
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
