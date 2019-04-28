/* 
 *	Goko Mag Drop add-on v1.26 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	Detect null reload, pass required params
 *
*/

///	inner array params: magazineClass, ammoCount, magazineID, magazineCreator
params ["_unit", "_weapon", "_muzzle", "_newmag", ["_oldmag", ["","","",""]], "_weaponKind"];

if (isNil "_weaponKind") exitWith {};
if !(_oldmag#1 isEqualTo 0 && {_unit in _unit}) exitWith {};

if (GSM_option_bShowMagAuthor) exitWith {
	systemChat "GSM debugging enabled, leaving scripted simulation...";
	["WARNING! debugging enabled", 3, 1.5, [0.75,0.55,0,0.7],true] spawn bis_fnc_wlsmoothtext;
};

switch (_weaponKind) do {
	case "Handgun" : {GSM_localVar_delay = 0.45;};
	case "Rifle" : {GSM_localVar_delay = 0.6;};
};

///	add delay 
[
	{
		_this call GSM_fnc_prepSimulation;
	},
	[
		_unit,
		_weapon,
		_muzzle,
		_oldmag#0,
		_weaponKind
	],
	(random 0.1 + GSM_localVar_delay)
] call CBA_fnc_waitAndExecute;
