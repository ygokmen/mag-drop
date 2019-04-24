/* 
 *	Goko Mag Drop add-on v1.25 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *	
 *	3D Particle fx function - spawns 3d particle with physics simulation
 *	
*/

params ["_unit", "_relativeVelocity", "_ammoModelP3D", "_cachedAttachToCount", "_hiddenTexture"];
/// attach a particle source at hands of unit and spawn a magazine model with physics simulation

private _popOutMagazine = "#particleSource" createVehicleLocal (getPosATL _unit);
_popOutMagazine setParticleParams
[
	/*Sprite*/			[_ammoModelP3D,1,0,1,0],"", // File,Ntieth,Index,Count,Loop
	/*Type*/			"spaceObject",
	/*TimerSeconds*/	0.51,
	/*LifetimeSeconds*/	1,
	/*Position*/		[0,0,0],
	/*MoveVelocity*/	_relativeVelocity,
	/*Simulation*/		random 1, 10, 0.0139253, 0.36,//rotationVel,weight,volume,rubbing
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
	/*bounceOnSurface*/	-1,   /// this means no collision with ground
	/*emissiveColor*/	[[0,0,0,0]]
	/**3D Array Vector dir DEV BRANCH ONLY!!!!!!! wont be available until 1.93@stable */
];
/* doesn't work...can't use hiddenSelectionTextures...
if !(_hiddenTexture isEqualTo []) then { 
	_popOutMagazine setObjectMaterial [0, "\A3\Structures_F_Mark\VR\Targets\Data\VR_Target_MBT_01_cannon_INDEP.rvmat"];
	_test = _hiddenTexture # 0;
	_popOutMagazine setObjectTextureGlobal [0, _test];
};
*/
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
