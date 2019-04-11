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

/// Start a custom 'reload' EH on scheduled environment, It basically detects reload for AI or player.
/// TODO: remove this and use unscheduled muzzle 'reload' EH when available @A3 stable branch
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

	/// Reloading EH Stage2, pass it via cba WaE
	[
		{	
			_this call GokoMD_fnc_FiredEH_ReloadingStage2;
		}, 
		[
			_unit, 
			_weapon, 
			_muzzle, 
			_mode, 
			_ammo, 
			_magazine, 
			_projectile, 
			_gunner
		], 
		0.4 + random 0.3
		// TODO: can we find a better calculation for reload animation length?
	] call CBA_fnc_waitAndExecute;

};

