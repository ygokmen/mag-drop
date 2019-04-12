/* 
 *	Goko Mag Drop add-on v1.24 for ARMA3 STEAM STABLE BRANCH
 *	Author: Sceptre
 *	Modified for goko magazine simulation add-on.
 *	Repo: github.com/the0utsider/mag-drop
 *	Reinitializes magsim function on a unit that had locality changed
*/

params ["_unit"];

// Add necessary Event Handlers, again.
private _firedEHID = _unit addeventhandler ["Fired",{_this call GokoMD_fnc_FiredEH_mainHook}];
private _localEHID = _unit addEventhandler ["Local",{_this call GokoMD_fnc_localEH}];

_unit setVariable ["GokoMD_unitCustomReloadEHIDs",[_firedEHID, _localEHID] ];
