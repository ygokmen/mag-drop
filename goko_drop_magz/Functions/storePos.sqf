/* 
 *	Goko Mag Drop add-on v1.24 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	store particle last position
 *	needed a check if more than 1 soldier in vicinity
*/

private _particlePosASL = _this;
private _searchForEntity = (_particlePosASL nearEntities ["CAManBase", 3]);
if (_searchForEntity isEqualTo []) exitWith {};

if (count _searchForEntity isEqualTo 1) then 
{
	_searchForEntity # 0 setVariable ["GokoMD_VAR_particlePos", _particlePosASL];

} else {
	{
	_x setVariable ["GokoMD_VAR_particlePos", _particlePosASL];
	} forEach _searchForEntity;
};



/*

_searchForEntity = _searchForEntity apply {[_x clientOwner, _x]};
_nearEnemies sort true;
private _nearestEnemy = _nearEnemies # 0 # 1;

private _getMagModel = _unitFound getVariable "GokoMD_VAR_magazineModelName";
private _getUniqueID = _unitFound getVariable "GokoMD_VAR_clientOwnerID";

if !(_getUniqueID isEqualTo clientOwner) exitWith {};

/// "needs to start without backslash"-> community.bistudio.com/wiki/BIS_fnc_createSimpleObject
private _modelPathFull = if !(isNil "_getMagModel") then 
{
	(_getMagModel splitString "\") joinString "\"; 
} else { "A3\Structures_F_EPB\Items\Military\Magazine_rifle_F.p3d" };

private _manualAdjustPos = _particlePosASL;
/// adding bool to check if unit is over sea or not
private _bIsOverSea = (getPosASL _unitFound # 2 < getPosATL _unitFound # 2);
_adjustPos = if (_bIsOverSea) then 
{
	_manualAdjustPos set [2, 0.01 + getPosASL _unitFound # 2];
	_manualAdjustPos;
} else {
/// this is required to get proper Z inside buildings, towers, etc.
	_manualAdjustPos set [2, 0.01 + getPosATL _unitFound # 2];
	AGLToASL _manualAdjustPos;
};

/// emit sound effect at position
[_unitFound, _adjustPos] call GokoMD_fnc_AudioSimulation;

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
	_adjustPos, 					//positionWorld: Array - placement position in format PositionWorld
	round(random 359), 				//direction
	true, 							//follow terrain inclination
	true							//forceSuperSimpleObject
] call BIS_fnc_createSimpleObject;


*/