/* 
 *	Goko Mag Drop add-on v1.25 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	store particle last position with a if check for more than 1 soldier in vicinity
 *	this is remote exec'd and script itself has global effect, not safe to do anything else here
 *	
*/

private _particlePosASL = _this;
private _searchForEntity = (_particlePosASL nearEntities ["CAManBase", 3]);
if (_searchForEntity isEqualTo []) exitWith {};

if (count _searchForEntity isEqualTo 1) then 
{
	_searchForEntity # 0 setVariable ["GMS_var_particlePos", _particlePosASL];

} else {
	{
	_x setVariable ["GMS_var_particlePos", _particlePosASL];
	} forEach _searchForEntity;
};
