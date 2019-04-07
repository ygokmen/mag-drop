/* 
 *	Goko Mag Drop add-on v1.23 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *	add fired EH main function 
*/


if (local _this#0) then {

	_this#0 addeventhandler ["Fired",{_this call GokoMD_fnc_FiredEH_mainHook}];
};
