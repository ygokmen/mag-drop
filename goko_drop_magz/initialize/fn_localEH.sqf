/*--------------------------------------------------------
Authors: Sceptre
Modified for goko magazine simulation add-on.
Removes local event handlers and calls for reinitialization on remote machine when unit's locality changed.

Parameters:
See (https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Local)

Return Value:
Nothing
----------------------------------------------------------*/
params ["_unit","_isLocal"];

(_unit getVariable "GokoMD_unitCustomReloadEHIDs") params ["_firedEHID","_localEHID"];

// Remove local EH
_unit removeEventHandler ["Fired",_firedEHID];
_unit removeEventHandler ["Local",_localEHID];
_unit setVariable ["GokoMD_unitCustomReloadEHIDs",nil];

// Reinitialize unit on remote machine
[_unit] remoteExec ["GokoMD_fnc_reinitialize",_unit];
