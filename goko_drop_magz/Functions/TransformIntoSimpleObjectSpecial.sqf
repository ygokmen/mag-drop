/* 
 *	Goko Mag Drop add-on v1.23 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	super simple object script
 *	spawns a persistent super-simple object in the world, replacing 3d particle on ground
*/

private _particlePosASL = _this;
private _searchForEntity = (_particlePosASL nearEntities ["CAManBase", 3]);
if (_searchForEntity isEqualTo []) exitWith {};
private _unitFound = _searchForEntity # 0;
private _getMagModel = _unitFound getVariable "GokoMD_VAR_magazineModelName";

/// "needs to start without backslash"-> community.bistudio.com/wiki/BIS_fnc_createSimpleObject
private _modelPathFull = if !(isNil "_getMagModel") then 
{
	(_getMagModel splitString "\") joinString "\"; 
} else { "A3\Structures_F_EPB\Items\Military\Magazine_rifle_F.p3d" };

private _manualAdjustPos = _particlePosASL;

/// commy2 warned: this won't work over sea, on carrier etc...
/// adding bool to check if unit is over sea or not
private _bIsOverSea = (getPosASL _unitFound # 2 < getPosATL _unitFound # 2);
_adjustPos = if (_bIsOverSea) then 
{
	_manualAdjustPos set [2, 0.01 + getPosASL _unitFound # 2];
	_manualAdjustPos;
} else {
/// this is required to get proper Z inside buildings, towers, etc.
	_manualAdjustPos set [2, 0.009 + getPosATL _unitFound # 2];
	AGLToASL _manualAdjustPos;
};

/// emit sound effect at position
[_unitFound, _adjustPos] call GokoMD_fnc_AudioSimulation;

/// create super-simple object at position

private _stringoro = 
[  
	[  
		"",			//class
		_modelPathFull,	//model
		0,			//model reversed
		0,			//vertical offset 
		[],			//animAdjustments
		[]			//selectionstoHide
	],   
	_adjustPos,			//positionWorld: Array - placement position in format PositionWorld
	round(random 359),	//direction
	false,				//follow terrain inclination
	true 				//forceSuperSimpleObject
] call BIS_fnc_createSimpleObject; 

_stringoro setvectordirandup  
[ 
	[0,0,0] vectordiff surfacenormal getpos _unitFound,
	[-1 +random 2,-1 +random 2,-1] vectorCrossProduct surfacenormal getpos _unitFound 
];

/* NOTES ON BIS SIMPLE OBJECT FUNCTION
Terrain inclination bool helps greatly, it aligns the spawned magazines beautifully without dealing with setVectorDirAndUp.
Downside, when you try to use magazines at nameSpecial string of magazineCfg, because of their rotation, they stand up on ground
with one half of them buried to the ground... With Terrain inclination bool set to false, you have to set Dir and Up vectors manually.
So far I couldn't manage to write a formula to do this. It is not an issue on even surfaces, flat areas etc. 

PROBLEM: on terrain, spawning a nameSpecial cfg require 2 operations: 90 degrees tilt on X axis, and with that a surface normal calculation...
player model is the only thing we can take as reference. 

NOTE: you can still use terrain inclination bool true, then use setVectorDirAndUp to do X 90 rotation. Which I couldn't manage.

TODO: find a formula to rotate object and set its position according to surface player walking on.
