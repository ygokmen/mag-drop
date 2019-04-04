/* 
 *	Goko Mag Drop add-on v1.22c for ARMA3
 *	Author: gökmen 'the0utsider' çakal
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	super simple object script
 *	spawns a persistent simple object on ground, replacing 3d particle on ground
*/

private _particlePosASL = _this;
private _searchForEntity = (_particlePosASL nearEntities ["CAManBase", 3]);
if (_searchForEntity isEqualTo []) exitWith {};
private _unitFound = _searchForEntity#0;
private _getMagModel = _unitFound getVariable "GokoMD_VAR_magazineModelNamePistol";

private _formatModelName = if !(isNil "_getMagModel") then 
{
	(_getMagModel splitString "\") joinString "\"; 
} else { "A3\Structures_F_EPB\Items\Military\Magazine_rifle_F.p3d" };

private _manualAdjustPos = [];
_manualAdjustPos resize 3;
_manualAdjustPos set [0, _particlePosASL # 0];
_manualAdjustPos set [1, _particlePosASL # 1];
_manualAdjustPos set [2, 0.01 + getPosATL _unitFound # 2];
private _adjustedPos = AGLToASL _manualAdjustPos ;

[ 
	[ 
		"", 						//class
		_formatModelName, 			//model
		0, 							//model reversed
		0,							//vertical offset 
		[], 						//animAdjustments
		[] 							//selectionstoHide
	],  
	_adjustedPos, 					//positionWorld
	round(random 180), 				//direction
	true, 							//follow terrain inclination
	true							//forceSuperSimpleObject
] call BIS_fnc_createSimpleObject;


//AGLS

/*
KK_fnc_setPosAGLS = {
	params ["_obj", "_pos", "_offset"];
	_offset = _pos select 2;
	if (isNil "_offset") then {_offset = 0};
	_pos set [2, worldSize]; 
	_obj setPosASL _pos;
	_pos set [2, vectorMagnitude (_pos vectorDiff getPosVisual _obj) + _offset];
	_obj setPosASL _pos;
};


_worldPosition = getPosWorld _unitFound;
_PositionZ = getPosASL _unitFound;
_zDifference = _positionZ select 2;

_worldPositionZ set [0, _particleLastPOS # 0];
_worldPositionZ set [1, _particleLastPOS # 1];

_manualZcalc set [2, worldSize];
_worldPositionZ setPosASL _manualZcalc;
_manualZcalc set [[2, vectorMagnitude (_worldPositionZ vectorDiff getPosVisual _obj) + _zDifference];

_sVectorDirUp = [vectorDir _unitFound, (surfaceNormal position _unitFound)];
_groundItem = createSimpleObject [_formatMagModel, AGLToASL _worldPositionZ];
_groundItem setVectorDirAndUp _sVectorDirUp;
/*
//AGLS
_position = getPosWorld _unitFound;
_offset = _position # 2;

_position set [0, _particleLastPOS # 0];
_position set [1, _particleLastPOS # 1];
_position set [2, worldSize];

//_groundItem = createVehicle ["Land_Magazine_rifle_F", _position, [], 0, "CAN_COLLIDE"];

_groundItem setPosASL _position;
_position set [2, vectorMagnitude (_position vectorDiff getPosVisual _groundItem) + _offset];
_groundItem setPosASL _position;
_groundItem setVectorDirAndUp [[-1 +random 2, -1 +random 2, -1 +random 2], _getSurfaceNormal];

KK_fnc_setPosAGLS = {
	params ["_obj", "_pos", "_offset"];
	_offset = _pos select 2;
	if (isNil "_offset") then {_offset = 0};
	_pos set [2, worldSize]; 
	_obj setPosASL _pos;
	_pos set [2, vectorMagnitude (_pos vectorDiff getPosVisual _obj) + _offset];
	_obj setPosASL _pos;
};

*/




