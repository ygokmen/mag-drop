/* 
 *	Goko Mag Drop add-on v1.24 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	store particle last position
 *	 a check needed if more than 1 soldier in vicinity
*/

private _particlePosASL = _this;
private _searchForEntity = (_particlePosASL nearEntities ["CAManBase", 3]);
if (_searchForEntity isEqualTo []) exitWith {};

if (count _searchForEntity isEqualTo 1) then 
{
	_searchForEntity # 0 setVariable ["GokoMD_VAR_particlePos", _particlePosASL];

} else {
	{
	_x setVariable ["GokoMD_VAR_particlePos", _particlePosASL];
	} forEach _searchForEntity;
};


