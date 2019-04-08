/* 
 *	Goko Mag Drop add-on v1.23 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *	add fired EH main function 
*/

_unit = _this select 0;

if (local _unit) then 
{
	_unit addeventhandler ["Fired",{_this call GokoMD_fnc_FiredEH_mainHook}];
};
