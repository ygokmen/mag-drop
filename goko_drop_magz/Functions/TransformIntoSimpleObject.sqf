/* 
 *	Goko Mag Drop add-on v1.23 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	super simple object script
 *	spawns a persistent simple object on ground, replacing 3d particle on ground
*/

private _particlePosASL = _this;
private _searchForEntity = (_particlePosASL nearEntities ["CAManBase", 3]);
if (_searchForEntity isEqualTo []) exitWith {};
private _unitFound = _searchForEntity#0;
private _getMagModel = _unitFound getVariable "GokoMD_VAR_magazineModelName";

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

