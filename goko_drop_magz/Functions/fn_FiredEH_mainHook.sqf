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

if !(_unit in _unit && {_weapon isEqualTo _muzzle}) exitWith {};

private _bOutofAmmo = getArray(configfile >> "CfgWeapons" >> _weapon >> "magazines") arrayIntersect magazines _unit isEqualTo [];
if (_bOutofAmmo || _weapon isEqualTo secondaryWeapon _unit) exitWith {};

/// a custom 'reload' EH with spawn/scheduled environment.
/// TODO: remove this lame loop and use unscheduled muzzle reload EH when available @A3 stable branch
_null = _this spawn 
{
	private _actor = _this#0;
	private _muzzle = _this#2;
	private _magazine = _this#5;
	private _saveCycles = if (isPlayer _actor) then {0.1} else {0.5};
	
	while {alive _actor && currentMuzzle _actor isEqualTo _muzzle} do 
	{
		sleep _saveCycles;
		if (!isPlayer _actor || inputAction "reloadMagazine" > 0) exitwith {};
	};
	if (!alive _actor || !(currentMuzzle _actor isEqualTo _muzzle)) exitwith {};

	waitUntil 
	{
		sleep (0.3 + random 0.3);
		if (!alive _actor) exitwith {true};

		/// velocity to pass on magazine. calculate forward vector of actor and bump it a little if unit moving so particle can drop in front of unit
		private _actorVelocity =  velocity _actor;
		private _actorDirection = direction _actor;
		private _addVelocity = if (speed _actor isEqualTo 0) then {0.3 + random 0.4} else {0.5};
		private _addVelocityForwardVector = 
		[
			(velocity _actor # 0) + (sin _actorDirection * _addVelocity),
			(velocity _actor # 1) + (cos _actorDirection * _addVelocity),
			(velocity _actor # 2)
		];
		private _finalVelocity = ([0.8 - random 1.5, 0.8 - random 1.5, 0] vectorAdd _addVelocityForwardVector);

		/// magazine config check for p3d model
		private _getMagazineAuthor = getText(configfile >> "CfgMagazines" >> _magazine >> "author");
		private _getMagazineCfgModelName = getText(configfile >> "CfgMagazines" >> _magazine >> "model");
		private _getMagazineCfgModelNameSpecial = getText(configfile >> "CfgMagazines" >> _magazine >> "modelSpecial");
		// nameSpecial have detailed models but their Z orientation is 90degrees up, they stand straight on ground, don't look good.
		private _getModel = if (_getMagazineCfgModelName isEqualTo "") then {_getMagazineCfgModelNameSpecial;} else {_getMagazineCfgModelName;};
		private _foundMagazineP3D = "";
		private _findIfP3D = _getModel splitString ".";

		if ("p3d" in _findIfP3D) then
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
		_actor setVariable ["GokoMD_VAR_magazineModelName",_foundMagazineP3D];

		/// pass this count of array, it will become index selector after incrementing attached objects array
		private _existingAttachedObjects = (count attachedObjects _actor);
		[_actor, _finalVelocity, _foundMagazineP3D, _existingAttachedObjects] remoteExecCall ["GokoMD_fnc_Magazine_Particle3DFx"];
		true;
	};
};
