/*--------------------------------------------------------
Authors: Sceptre
Modified for goko magazine simulation add-on
Reinitializes magsim function on a unit that had locality changed

Parameters:
0: Unit to reinitilize UVO stuff on <OBJECT>

Return Value:
Nothing
----------------------------------------------------------*/
params ["_unit"];

// Add necessary Event Handlers, again.
private _firedEHID = _unit addeventhandler ["Fired",{_this call GokoMD_fnc_FiredEH_mainHook}];
private _localEHID = _unit addEventhandler ["Local",{_this call GokoMD_fnc_localEH}];

_unit setVariable ["GokoMD_unitCustomReloadEHIDs",[_firedEHID, _localEHID] ];
