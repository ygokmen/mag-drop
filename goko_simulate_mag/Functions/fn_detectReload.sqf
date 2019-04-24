/* 
 *	Goko Mag Drop add-on v1.26 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	Main hook using muzzle fired EH since muzzle reload EH do not exist (yet) on stable branch
 *	Detect reload, pass required params
*/

params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

/// Leave ASAP if magazine still has ammo in it
if !((_unit ammo _muzzle) isEqualTo 0) exitWith {};

/// Make sure soldier is on foot and not using GL or anything else
if !(_unit in _unit && {_weapon isEqualTo _muzzle}) exitWith {};
/// Make sure he has compatible magazines to start reloading (thanks @dedmen)
private _bOutofAmmo = (_weapon call CBA_fnc_compatibleMagazines) arrayIntersect (magazines _unit) isEqualTo [];
if (_bOutofAmmo) exitWith {};

if (GSM_option_bShowMagAuthor) exitWith {
	systemChat "GSM debugging enabled, leaving scripted simulation...";
	["WARNING: debugging enabled", 3, 1.5, [1,0,0,0.8],false] spawn bis_fnc_wlsmoothtext;
};

/// TODO: use unscheduled muzzle 'reload' EH when available @A3 stable branch
_null = _this spawn 
{
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
	_unit setVariable ["GMS_var_particlePos", nil];
	private _saveCycles = if (isPlayer _unit) then {0.08} else {0.2};
	/// Reloading Stage1
	while {alive _unit && {currentMuzzle _unit isEqualTo _muzzle}} do 
	{
		Sleep _saveCycles;
		if (!isPlayer _unit || !(inputAction "reloadMagazine" isEqualTo 0)) exitwith {};		
	};
	if (!alive _unit || !(currentMuzzle _unit isEqualTo _muzzle)) exitwith {};
	/// Reloading, pass it via cba WaE
	[
		{	
			_this call GSM_fnc_prepSimulation;
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
		0.4 + random 0.4
		// TODO: can we find a better calculation for reload animation length?
	] call CBA_fnc_waitAndExecute;
};
