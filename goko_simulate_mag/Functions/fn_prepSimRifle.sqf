/* 
 *	Goko Mag Drop add-on v1.26 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	Rifle magazine simulation
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
	switch true do 
	{
		case (_getMagazineCfgModelNameSpecial isEqualTo "") : {_getModel = _getMagazineCfgModelName;};
		case (_getMagazineAuthor isEqualTo "Red Hammer Studios") : {_getModel = _getMagazineCfgModelName;};
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

/// pass count of array, it will become index selector after incrementing attached objects array
private _existingAttachedObjects = (count attachedObjects _unit);

/// local stuff that has to be remoteExec'd for clients with interface (human)
if (isPlayer _unit) then {
	[
		_unit,
		_foundMagazineP3D,
		_existingAttachedObjects
	] remoteExecCall ["GSM_fnc_particle3D", 0, false];
} else {
	[
		_unit,
		_foundMagazineP3D,
		_existingAttachedObjects
	] call GSM_fnc_particle3D;
};

/// function with global commands in it, pass it via cba WaE
//	emit sound effect at position (triggers Transform function within)
[
	{	
		_this call GSM_fnc_audioSimulation;
	}, 
	[
		_unit,
		_foundMagazineP3D,
		_bModelNeedsTilting
	], 
	0.6 /* free fall timing of an object 170cm (arm-shoulder) above ground.
		http://ambrsoft.com/CalcPhysics/acceleration/acceleration.htm */
] call CBA_fnc_waitAndExecute;

