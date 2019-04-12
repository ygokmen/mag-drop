/* 
 *	Goko Mag Drop add-on v1.24 for ARMA3 STEAM STABLE BRANCH
 *	Author: Sceptre
 *	Modified for goko magazine simulation add-on.
 *	Repo: github.com/the0utsider/mag-drop
 *	Removes local event handlers and calls for reinitialization on remote machine when unit's locality changed.
*/

params ["_unit","_isLocal"];

(_unit getVariable "GokoMD_unitCustomReloadEHIDs") params ["_firedEHID","_localEHID"];

// Remove local EH
_unit removeEventHandler ["Fired",_firedEHID];
_unit removeEventHandler ["Local",_localEHID];
_unit setVariable ["GokoMD_unitCustomReloadEHIDs",nil];

// Reinitialize unit on remote machine
[_unit] remoteExec ["GokoMD_fnc_reinitialize",_unit];
