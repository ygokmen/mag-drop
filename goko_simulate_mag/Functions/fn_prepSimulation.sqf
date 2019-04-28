/* 
 *	Goko Mag Drop add-on v1.26 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	magazine simulation main function
 *	
*/

params ["_unit", "_weapon", "_muzzle", "_mag", "_weaponKind"];

/// coming from waitAndExec, check if unit still exist
if (!alive _unit) exitwith {};
/// setup getters
private _getMagAuthor = getText(configfile >> "CfgMagazines" >> _mag >> "author");
private _getMagModelName = getText(configfile >> "CfgMagazines" >> _mag >> "model");
private _getMagModelNameSpecial = getText(configfile >> "CfgMagazines" >> _mag >> "modelSpecial");
private _getMagCapacity = getText (configfile >> "CfgMagazines" >> _mag >> "count");
private _bModelNeedsTilting = false;
private _findMagazineP3D = "";
private _getModel = "";
private _existingAttachedObjects = count (attachedObjects _unit);	//this will become index selector after incrementing attached objects array

///	finding p3d model file. Authors in nonCompatList will be using pre-defined generic models according to loaded mods
if (_getMagAuthor in (GSM_option_nonCompatList splitString "**")) then 
{
	_findMagazineP3D = _weaponKind call GSM_fnc_getGenericMag;
} else {
/// models in nameSpecial string have different rotation, they will need custom formula
	switch true do 
	{
		case (_getMagModelNameSpecial isEqualTo "") : {_getModel = _getMagModelName;};
		case (_getMagAuthor isEqualTo "Red Hammer Studios") : {_getModel = _getMagModelName;};
		default {_getModel = _getMagModelNameSpecial; _bModelNeedsTilting = true;};
	};

	private _modelNameExtension = _getModel splitString ".";
	/// check if config name has p3d extension or not
	private _bIsP3D = ( "p3d" == _modelNameExtension # (count _modelNameExtension - 1));
	if (_bIsP3D) then
	{
		_findMagazineP3D = _getModel;
	} else {
		_findMagazineP3D = [_getModel, "p3d"] joinString ".";
	};
};

/// local stuff has to be remoteExec'd for human
if (isPlayer _unit) then {
	[
		_unit,
		_findMagazineP3D,
		_existingAttachedObjects,
		_weaponKind
	] remoteExecCall ["GSM_fnc_particle3D", 0, false];
} else {
	[
		_unit,
		_findMagazineP3D,
		_existingAttachedObjects,
		_weaponKind
	] call GSM_fnc_particle3D;
};

/// function with global commands in it, pass it via cba WaE
//	emit sound effect at position (this triggers "transformSimpleObject" script within itself next
[
	{	
		_this call GSM_fnc_audioSimulation;
	}, 
	[
		_unit,
		_findMagazineP3D,
		_bModelNeedsTilting
	], 
	0.6 /* free fall timing of an object 170cm (arm-shoulder) above ground.
		http://ambrsoft.com/CalcPhysics/acceleration/acceleration.htm */
] call CBA_fnc_waitAndExecute;
