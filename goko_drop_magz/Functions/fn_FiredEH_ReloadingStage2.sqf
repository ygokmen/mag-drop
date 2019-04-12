/* 
 *	Goko Mag Drop add-on v1.24 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	Stage2 of custom 'reload' using fired EH main hook params
 *	
*/

params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
/// coming from waitAndExec, check if unit still exist
if (!alive _unit) exitwith {};
/// magazine model getter method. TODO: Improve this getter for better compatibility
private _incompatibleAuthorList = ["", "BW-Mod"];
private _getMagazineAuthor = getText(configfile >> "CfgMagazines" >> _magazine >> "author");
private _getMagazineCfgModelName = getText(configfile >> "CfgMagazines" >> _magazine >> "model");
private _getMagazineCfgModelNameSpecial = getText(configfile >> "CfgMagazines" >> _magazine >> "modelSpecial");
private _bModelNeedsTilting = false;
private _foundMagazineP3D = "";
private _getModel = "";
/// models in nameSpecial string have different rotation, they will need custom formula
switch _getMagazineCfgModelNameSpecial do 
{
	case "" : {_getModel = _getMagazineCfgModelName; _bModelNeedsTilting = false};
	default {_getModel = _getMagazineCfgModelNameSpecial; _bModelNeedsTilting = true};
};
private _modelNameExtension = _getModel splitString ".";
/// check if config name has p3d extension or not
private _bIsP3D = ( "p3d" == _modelNameExtension # (count _modelNameExtension - 1));
if (_bIsP3D) then
{
	_foundMagazineP3D = if (_getModel isEqualTo "\A3\weapons_F\ammo\mag_univ.p3d") then
	{
		"\A3\Structures_F_EPB\Items\Military\Magazine_rifle_F.p3d";
	} else {
		_getModel;
	};
} else {
	_foundMagazineP3D = if (_getMagazineAuthor in _incompatibleAuthorList) then 
	{
		"\A3\Structures_F_EPB\Items\Military\Magazine_rifle_F.p3d";
	} else {
		[_getModel, "p3d"] joinString ".";
	};
};
/// Store or update magazine model name in object's namespace, will be needed in SimpleObject script
_unit setVariable ["GokoMD_VAR_magazineModelName",_foundMagazineP3D];

/// velocity to pass on magazine: calculate forward vector of actor and bump it a little if unit moving so particle can drop in front of unit
private _unitVelocity =  velocity _unit;
private _unitDirection = direction _unit;
private _addVelocity = if (speed _unit isEqualTo 0) then {0.2 + random 0.2} else {0.5};
private _addVelocityForwardVector = 
[
	(velocity _unit # 0) + (sin _unitDirection * _addVelocity),
	(velocity _unit # 1) + (cos _unitDirection * _addVelocity),
	(velocity _unit # 2)
];
private _finalVelocity = ([-0.8 + random 1.6, -0.8 + random 1.6, 0] vectorAdd _addVelocityForwardVector);

/// pass count of array, it will become index selector after incrementing attached objects array
private _existingAttachedObjects = (count attachedObjects _unit);

/// local stuff that has to be remoteExec'd
[
	_unit,
	_finalVelocity,
	_foundMagazineP3D,
	_existingAttachedObjects
] remoteExecCall ["GokoMD_fnc_Magazine_Particle3DFx"];

/// globals, pass it via cba WaE
[
	{	
		_this call GokoMD_fnc_SimpleObject;
	}, 
	[
		_unit,
		_foundMagazineP3D,
		_bModelNeedsTilting
	], 
	0.6
] call CBA_fnc_waitAndExecute;
