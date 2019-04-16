/* 
 *	Goko Mag Drop add-on v1.24 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *	add fired EH main function 
 *
*/

params ["_unit"]; 

if (local _unit) then 
{
	private _firedEHID = _unit addeventhandler ["Fired",{_this call GokoMD_fnc_FiredEH_mainHook}];
	private _localEHID = _unit addEventhandler ["Local",{_this call GokoMD_fnc_localEH}];
	_unit setVariable ["GokoMD_unitCustomReloadEHIDs",[_firedEHID, _localEHID] ];
};
