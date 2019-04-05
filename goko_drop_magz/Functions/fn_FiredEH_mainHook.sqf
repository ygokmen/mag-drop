/* 
 *	Goko Mag Drop add-on v1.22 for ARMA3 STEAM STABLE BRANCH
 *	Author: gökmen 'the0utsider' çakal
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	Main hook using fired EH since muzzle reload EH do not exist (yet) on stable branch
 *	Detect reload, pass required params
*/

params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

private _ammoInMagazine = _unit ammo _muzzle;
if !(_ammoInMagazine isEqualTo 0 && {_weapon isEqualTo _muzzle}) exitWith{};

private _bOutofAmmo = getArray(configfile >> "CfgWeapons" >> _muzzle >> "magazines") arrayIntersect magazines _unit isEqualTo [];
if (_bOutofAmmo || _weapon isEqualTo secondaryWeapon _unit) exitWith{};

/// a custom 'reload' EH
_null = _this spawn 
{
	private _actor = _this#0;
	private _muzzle = _this#2;
	private _magazine = _this#5;
	private _saveCycles = if (isPlayer _actor) then {0.1} else {0.4};
	
	while {alive _actor && currentMuzzle _actor isEqualTo _muzzle} do 
	{
		sleep _saveCycles;
		if (!isPlayer _actor || inputAction "reloadMagazine" > 0) exitwith{};
	};
	if (!alive _actor || !(currentMuzzle _actor isEqualTo _muzzle)) exitwith{};

	waitUntil 
	{
		sleep (0.3 + random 0.3);

		if (!alive _actor) exitwith {true};

		private _addVelocity = (velocity _actor vectorMultiply 1.1) vectorAdd [-0.4 + random 0.8, -0.4 + random 0.8, 0];
		
		/// pass this count of array, it will become index selector after incrementing attached objects array
		private _existingAttachedObjects = (count attachedObjects _actor);
		
		/// config check for proper mag models 
		private _bMagtypeIsRHS = (getText(configfile >> "CfgMagazines" >> _magazine >> "author") == "Red Hammer Studios");
		private _getMagazineP3D = if (_bMagtypeIsRHS) then
		{
			private _rhsMagString = getText(configfile >> "CfgMagazines" >> _magazine >> "model");
			private _addExtension = ".p3d";

			if (_rhsMagString isEqualTo "\A3\weapons_F\ammo\mag_univ.p3d") then {_rhsMagString = "\A3\weapons_F\ammo\mag_univ"};
			[_rhsMagString, _addExtension] joinString "";
		} else {
			"\A3\Structures_F_EPB\Items\Military\Magazine_rifle_F.p3d";
		};
		/// Store or update magazine model name in object's namespace variable
		_actor setVariable ["GokoMD_VAR_magazineModelNamePistol",_getMagazineP3D];
		[_actor, _addVelocity, _getMagazineP3D, _existingAttachedObjects] remoteExecCall ["GokoMD_fnc_Pistol_Particle3DFx"];
		true;
	};
};
