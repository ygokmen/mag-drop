_unit = _this select 0;

if (local _unit) then {

	_unit addeventhandler ["Fired",{_this call GokoMD_fnc_FiredEH_mainHook}];
};
