/* 
 *	Goko Mag Drop add-on v1.23 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	Main hook using fired EH since muzzle reload EH do not exist (yet) on stable branch
 *	Detect reload, pass required params
*/

/// Leave ASAP if magazine still has ammo in it
if !((_this#0 ammo _this#2) isEqualTo 0) exitWith {};

params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

/// Make sure soldier is on foot and not using GL or anything else than firearm
if !(_unit in _unit && {_weapon isEqualTo _muzzle}) exitWith {};
/// Make sure he has compatible magazines to start reloading
private _bOutofAmmo = (_weapon call CBA_fnc_compatibleMagazines) arrayIntersect (magazines _unit) isEqualTo [];
/// Make sure it is not rocket launcher
if (_bOutofAmmo || _weapon isEqualTo secondaryWeapon _unit) exitWith {};

/// Start a custom 'reload' EH on scheduled environment.
/// TODO: remove this lame loop and use unscheduled muzzle reload EH when available @A3 stable branch
_null = _this spawn 
{
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

	private _saveCycles = if (isPlayer _unit) then {0.1} else {0.5};
	
	while {alive _unit && currentMuzzle _unit isEqualTo _muzzle} do 
	{
		sleep _saveCycles;
		if (!isPlayer _unit || inputAction "reloadMagazine" > 0) exitwith {};
	};
	if (!alive _unit || !(currentMuzzle _unit isEqualTo _muzzle)) exitwith {};

	waitUntil 
	{
		sleep (0.4 + random 0.3);
		if (!alive _unit) exitwith {true};

		/// velocity to pass on magazine. calculate forward vector of actor and bump it a little if unit moving so particle can drop in front of unit
		private _unitVelocity =  velocity _unit;
		private _unitDirection = direction _unit;
		private _addVelocity = if (speed _unit isEqualTo 0) then {0.35 + random 0.3} else {0.6};
		private _addVelocityForwardVector = 
		[
			(velocity _unit # 0) + (sin _unitDirection * _addVelocity),
			(velocity _unit # 1) + (cos _unitDirection * _addVelocity),
			(velocity _unit # 2)
		];
		private _finalVelocity = ([-0.8 + random 1.6, -0.8 + random 1.6, 0] vectorAdd _addVelocityForwardVector);

		/// magazine config check for p3d model
		private _getMagazineAuthor = getText(configfile >> "CfgMagazines" >> _magazine >> "author");
		private _getMagazineCfgModelName = getText(configfile >> "CfgMagazines" >> _magazine >> "model");
		private _getMagazineCfgModelNameSpecial = getText(configfile >> "CfgMagazines" >> _magazine >> "modelSpecial");
		// nameSpecial have detailed models (BI magazines) but their rotation is 90degrees up, they stand straight on ground, don't look good.
		// TODO: Find a formula to properly set object rotation for nameSpecial models...can't use simpleObject method on them until then.
		// don't use namespecial, unless main modelname is null. They can be used primarily when issue described above is solved.
		private _getModel = if (_getMagazineCfgModelName isEqualTo "") then {_getMagazineCfgModelNameSpecial;} else {_getMagazineCfgModelName;};
		private _modelNameExtension = _getModel splitString ".";
		private _bIsP3D = ( "p3d" == _modelNameExtension # (count _modelNameExtension - 1));

		private _foundMagazineP3D = "";
		if (_bIsP3D) then
		{
			switch _getModel do {
				case "\A3\weapons_F\ammo\mag_univ.p3d" : {_foundMagazineP3D = "\A3\Structures_F_EPB\Items\Military\Magazine_rifle_F.p3d"};
				default {_foundMagazineP3D = _getModel};
			};
		} else {
			/// this is special case for RHS magazines. Some of them also have BI as author name. Once in *.p3d format, they are good to go
			switch _getMagazineAuthor do {
				case "Red Hammer Studios" : {_foundMagazineP3D = [_getModel, "p3d"] joinString "."};
				case "Bohemia Interactive" : {_foundMagazineP3D = [_getModel, "p3d"] joinString "."};
				default {_foundMagazineP3D = "\A3\Structures_F_EPB\Items\Military\Magazine_rifle_F.p3d"};
			};
		};
		/// Store or update magazine model name in object's namespace variable, will be needed in SimpleObject script
		_unit setVariable ["GokoMD_VAR_magazineModelName",_foundMagazineP3D];
		
		/// pass this count of array, it will become index selector after incrementing attached objects array
		private _existingAttachedObjects = (count attachedObjects _unit);
		[_unit, _finalVelocity, _foundMagazineP3D, _existingAttachedObjects] remoteExecCall ["GokoMD_fnc_Magazine_Particle3DFx"];
		true;
	};
};
