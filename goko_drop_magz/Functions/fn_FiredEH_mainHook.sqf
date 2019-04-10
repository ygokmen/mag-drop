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
/// Make sure he has compatible magazines to start reloading (thanks @dedmen)
private _bOutofAmmo = (_weapon call CBA_fnc_compatibleMagazines) arrayIntersect (magazines _unit) isEqualTo [];
/// Make sure it is not rocket launcher
if (_bOutofAmmo || _weapon isEqualTo secondaryWeapon _unit) exitWith {};

/// Start a custom 'reload' EH on scheduled environment.
/// TODO: remove this lame loop and use unscheduled muzzle 'reload' EH when available @A3 stable branch
_null = _this spawn 
{
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

	private _saveCycles = if (isPlayer _unit) then {0.1} else {0.5};
	/// Reloading EH Stage1
	while {alive _unit && currentMuzzle _unit isEqualTo _muzzle} do 
	{
		sleep _saveCycles;
		if (!isPlayer _unit || inputAction "reloadMagazine" > 0) exitwith {};
	};
	if (!alive _unit || !(currentMuzzle _unit isEqualTo _muzzle)) exitwith {};
	/// Reloading EH Stage2
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
		private _incompatibleAuthorList = ["", "BW-Mod"];
		private _getMagazineAuthor = getText(configfile >> "CfgMagazines" >> _magazine >> "author");
		private _getMagazineCfgModelName = getText(configfile >> "CfgMagazines" >> _magazine >> "model");
		private _getMagazineCfgModelNameSpecial = getText(configfile >> "CfgMagazines" >> _magazine >> "modelSpecial");

		private _bModelNeedsTilting = false;
		private _foundMagazineP3D = "";
		private _getModel = "";
		
		/// models in nameSpecial string have different rotation, they need custom formula
		switch _getMagazineCfgModelNameSpecial do 
		{
			case "" : {_getModel = _getMagazineCfgModelName; _bModelNeedsTilting = false};
			default {_getModel = _getMagazineCfgModelNameSpecial; _bModelNeedsTilting = true};
		};

		private _modelNameExtension = _getModel splitString ".";
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
/// end of p3d model check stuff. TODO: this part above can be improved, I guess.
		/// Store or update magazine model name in object's namespace, will be needed in SimpleObject script
		_unit setVariable ["GokoMD_VAR_magazineModelName",_foundMagazineP3D];
		
		/// pass count of array, it will become index selector after incrementing attached objects array
		private _existingAttachedObjects = (count attachedObjects _unit);
		
		/// pass these and exec ONLY on server to avoid playsound3d spam (thanks @commy2)
		[
			_unit,
			_finalVelocity,
			_foundMagazineP3D,
			_existingAttachedObjects,
			_bModelNeedsTilting
		] remoteExecCall ["GokoMD_fnc_Magazine_Particle3DFx", 2, false];

		/// Leave custom reloading EH loop
		true;
	};
};
