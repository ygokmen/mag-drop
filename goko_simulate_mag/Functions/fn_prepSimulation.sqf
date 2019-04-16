/* 
 *	Goko Mag Drop add-on v1.25 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	Stage2 of custom 'reload' getting everything done here
 *	
*/

params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
/// coming from waitAndExec, check if unit still exist
if (!alive _unit) exitwith {};
/// magazine model getter method. TODO: Improve this getter for better compatibility

/// setup getters
private _getMagazineAuthor = getText(configfile >> "CfgMagazines" >> _magazine >> "author");
private _getMagazineCfgModelName = getText(configfile >> "CfgMagazines" >> _magazine >> "model");
private _getMagazineCfgModelNameSpecial = getText(configfile >> "CfgMagazines" >> _magazine >> "modelSpecial");
/// initialize local variables with defaults
private _bModelNeedsTilting = false;
private _foundMagazineP3D = "\A3\Structures_F_EPB\Items\Military\Magazine_rifle_F.p3d";
private _getModel = "";
///
if !(_getMagazineAuthor in (GSM_option_nonCompatList splitString "**")) then 
{
	/// models in nameSpecial string have different rotation, they will need custom formula
	switch _getMagazineCfgModelNameSpecial do 
	{
		case "" : {_getModel = _getMagazineCfgModelName;};
		default {_getModel = _getMagazineCfgModelNameSpecial; _bModelNeedsTilting = true;};
	};

	private _modelNameExtension = _getModel splitString ".";
	/// check if config name has p3d extension or not
	private _bIsP3D = ( "p3d" == _modelNameExtension # (count _modelNameExtension - 1));
	if (_bIsP3D) then
	{
		_foundMagazineP3D = _getModel;
	} else {
		_foundMagazineP3D = [_getModel, "p3d"] joinString ".";
	};
};

/// velocity to pass on magazine: calculate forward vector of actor 
//  and bump it a little if unit moving so particle can drop in front of unit
private _unitVelocity =  velocity _unit;
private _unitDirection = direction _unit;
private _addVelocity = if (speed _unit isEqualTo 0) then {0.35 + random 0.3} else {0.65};
private _addVelocityForwardVector = 
[
	(velocity _unit # 0) + (sin _unitDirection * _addVelocity),
	(velocity _unit # 1) + (cos _unitDirection * _addVelocity),
	(velocity _unit # 2)
];
private _finalVelocity = ([-0.7 + random 1.4, -0.7 + random 1.4, 0] vectorAdd _addVelocityForwardVector);

/// pass count of array, it will become index selector after incrementing attached objects array
private _existingAttachedObjects = (count attachedObjects _unit);

/// local stuff that has to be remoteExec'd for clients with interface (human)
if (isPlayer _unit) then {
	[
		_unit,
		_finalVelocity,
		_foundMagazineP3D,
		_existingAttachedObjects
	] remoteExecCall ["GSM_fnc_particle3D", 0, false];
} else {
	[
		_unit,
		_finalVelocity,
		_foundMagazineP3D,
		_existingAttachedObjects
	] call GSM_fnc_particle3D;
};

/// globals, pass it via cba WaE
[
	{	
		_this call GSM_fnc_transformSimpleObject;
	}, 
	[
		_unit,
		_foundMagazineP3D,
		_bModelNeedsTilting
	], 
	0.64
] call CBA_fnc_waitAndExecute;
