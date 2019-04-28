/* 
 *	Goko Mag Drop add-on v1.26 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	getter for generic mag models @ compatibility list
 *	
*/

params ["_weaponKind"];

private _cupMagHandgun = "\CUP\Weapons\CUP_Weapons_Ammunition\magazines\CUP_mag_17Rnd_G17.p3d";
private _rhsUsMagHandgun = "\rhsusf\addons\rhsusf_weapons\magazines\rhs_15rnd_m9_mag";
private _rhsRusMagHandgun = "\rhsafrf\addons\rhs_weapons2\magazines\rhs_9x19_20mag";

private _cupMagRifle = "\CUP\Weapons\CUP_Weapons_Ammunition\magazines\CUP_mag_30rnd_pmag_qp.p3d";
private _rhsUsMagRifle = "rhsusf\addons\rhsusf_weapons\magazines\rhs_stanag_mag";
private _rhsRusMagRifle = "\rhsafrf\addons\rhs_weapons2\magazines\rhs_9x39_20mag";

private _hasCUPWeapons = (isClass(configfile >> "CfgPatches" >> "CUP_Weapons_Glock17"));
private _hasRHSUSAF = (isClass(configfile >> "CfgPatches" >> "rhsusf_main"));
private _hasRHSAFRF = (isClass(configfile >> "CfgPatches" >> "rhs_main"));
private _getGeneric = "";
switch true do {
	case (_hasCUPWeapons) : {_getGeneric = ["_cupMag", _weaponKind] joinString "";};
	case (_hasRHSUSAF) : {_getGeneric = ["_rhsUsMag", _weaponKind] joinString "";};
	case (_hasRHSAFRF) : {_getGeneric = ["_rhsRusMag", _weaponKind] joinString "";};
	case default {_getGeneric = "\A3\Structures_F_EPB\Items\Military\Magazine_rifle_F.p3d";};
};

call compile _getGeneric;

/*

private _rhsUsSrifleMag = "\rhsusf\addons\rhsusf_weapons\magazines\rhs_50cal_box_mag";
private _cupSrifleMag = "\CUP\Weapons\CUP_Weapons_Ammunition\magazines\CUP_mag_5Rnd_KSVK.p3d";

*/