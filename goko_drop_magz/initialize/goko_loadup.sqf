if(is3DEN) exitWith {};

_unit = _this # 0;

if (local _unit) then
{
	_unit addEventHandler ["Fired", {_this call GokoMD_fnc_FiredEH_mainHook}];

};