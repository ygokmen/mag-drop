/* 
 *	Goko Mag Drop add-on v1.24 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	super simple object script with custom alignment and rotator
 *	spawns a persistent super-simple object in the world, replacing 3d particle on ground
*/

private _particlePosASL = _this;
private _searchForEntity = (_particlePosASL nearEntities ["CAManBase", 3]);
if (_searchForEntity isEqualTo []) exitWith {};
private _unitFound = _searchForEntity # 0;
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
private _prepareToPlaceSuperSimpleObject = 
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

_prepareToPlaceSuperSimpleObject setvectordirandup  
[ 
	[0,0,0] vectordiff surfacenormal getpos _unitFound,
	[-1 +random 2,-1 +random 2,-1] vectorCrossProduct surfacenormal getpos _unitFound 
	/// no idea how it works, but it does. 
];
