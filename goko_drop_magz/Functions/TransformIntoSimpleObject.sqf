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
private _unitFound = _searchForEntity#0;
private _getMagModel = _unitFound getVariable "GokoMD_VAR_magazineModelName";

/// "needs to start without backslash"-> community.bistudio.com/wiki/BIS_fnc_createSimpleObject
private _modelPathFull = if !(isNil "_getMagModel") then 
{
	(_getMagModel splitString "\") joinString "\"; 
} else { "A3\Structures_F_EPB\Items\Military\Magazine_rifle_F.p3d" };

private _adjustedPos = _particlePosASL;
_adjustedPos set [2, 0.009 + getPosASL _unitFound # 2];
/// create super-simple object at position
[ 
	[ 
		"", 						//class
		_modelPathFull,				//model
		0, 							//model reversed
		0,							//vertical offset 
		[], 						//animAdjustments
		[] 							//selectionstoHide
	],  
	_adjustedPos, 					//WorldPosition
	round(random 359), 				//direction
	true, 							//follow terrain inclination
	true							//forceSuperSimpleObject
] call BIS_fnc_createSimpleObject;

/// emit sound effect on position
[_unitFound, _adjustedPos] call GokoMD_fnc_AudioSimulation;
