/* 
 *	Goko Mag Drop add-on v1.24 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	super simple object script
 *	spawns a persistent super-simple object in the world, replacing 3d particle on ground
*/

params ["_unit", "_foundMagazineP3D", "_bModelNeedsTilting"];
private _manualAdjustPos = _unit getVariable "GokoMD_VAR_particlePos";
/// adding bool to check if unit is over sea or not
private _bIsOverSea = (getPosASL _unit # 2 < getPosATL _unit # 2);
_adjustPos = if (_bIsOverSea) then 
{
	_manualAdjustPos set [2, 0.01 + getPosASL _unit # 2];
	_manualAdjustPos;
} else {
/// this is required to get proper Z inside buildings, towers, etc.
	_manualAdjustPos set [2, 0.0086 + getPosATL _unit # 2];
	AGLToASL _manualAdjustPos;
};

/// "needs to start without backslash"-> community.bistudio.com/wiki/BIS_fnc_createSimpleObject
private _modelPath = (_foundMagazineP3D splitString "\") joinString "\"; 
if (_bModelNeedsTilting) then
{
	/// create super-simple object at position with custom rotation
	private _prepareToPlaceSuperSimpleObject = 
	[  
		[  
			"",			//class
			_modelPath,	//model
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
		[0,0,0] vectordiff surfacenormal getpos _unit,
		[-1 +random 2,-1 +random 2,-1] vectorCrossProduct surfacenormal getpos _unit 
		/// no idea how it works, but it does. 
	];
} else {
	/// create super-simple object at position
	[ 
		[ 
			"", 						//class
			_modelPath,				//model
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
};

/// emit sound effect at position
[_unit, _adjustPos] call GokoMD_fnc_AudioSimulation;
