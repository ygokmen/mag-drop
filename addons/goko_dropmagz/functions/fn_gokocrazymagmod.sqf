

gokoMag_var_magLifeTime = profileNamespace getVariable ["gokoMag_var_magLifeTime", 600];

if(isClass(configFile >> "CfgPatches" >> "cba_settings")) then 
{
	[] spawn 
	{
		[
			"gokoMag_var_magLifeTime", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
			"LIST", // setting type
			["Particle simulation lifetime","Decide how long object stays on ground."], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
			"Goko crazy mag-mod over9000", // Pretty name of the category where the setting can be found. Can be stringtable entry.
			[[10 + round(random 49),180,300,600,900,1200],["< than a minute","3 minutes","5 minutes","10 minutes","15 Minutes", "20 Minutes"],3], // default
			true, // "global" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
			{
			} // function that will be executed once on mission start and every time the setting is changed.
		] call CBA_Settings_fnc_init;	
	};	
};

goko_fnc_reloadingOver9000 =
{
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
	
	private _ammoInMagazine = _unit ammo _muzzle;
	if !(_weapon isEqualTo _muzzle && _ammoInMagazine isEqualTo 0) exitWith {};
	
	private _bOutofAmmo = getArray(configfile >> "CfgWeapons" >> _muzzle >> "magazines") arrayIntersect magazines _unit isEqualTo [];
	if (_bOutofAmmo) exitWith{};
	
	_null = _this spawn {
		private _actor = _this#0;
		private _muzzle = _this#2;
		private _saveCycles = if (isPlayer _actor) then {0.05} else {0.5};
		
		while {alive _actor && currentMuzzle _actor isEqualTo _muzzle} do {
			sleep _saveCycles;
			if (!isPlayer _actor || inputAction "reloadMagazine" > 0) exitwith{};
		};
		if (!alive _actor || !(currentMuzzle _actor isEqualTo _muzzle)) exitwith{};
		
		waitUntil {
			sleep (0.3 + random 0.7);
			if (!alive _actor) exitwith {true};
			private _dirAndVelocity = (velocity _actor vectorAdd [0, -0.1 + random 0.2, -1 + random 2]) vectorMultiply (1 + random 1);
			[_actor, _dirAndVelocity] remoteExecCall ["goko_fnc_dropmagout"];
			sleep 0.5;
			private _unitFeetPos = _actor modelToWorldVisualWorld [0,0,-3];
			private _impactOnGround = selectRandom ["goko_dropmagz\sfx\gear_impact01.wav", "goko_dropmagz\sfx\gear_impact02.wav",
			"goko_dropmagz\sfx\gear_impact03.wav", "goko_dropmagz\sfx\gear_impact04.wav", "goko_dropmagz\sfx\gear_impact05.wav",
			"goko_dropmagz\sfx\gear_impact06.wav"];
			playsound3d [_impactOnGround, _actor, false, _unitFeetPos, 1.2, 1 + random 0.5, 50];
			true;
		};
	};
};

goko_fnc_dropmagout = 
{ 
	_unit = _this select 0; 
	_velocity = _this select 1; 

	_magout = "#particlesource" createVehicleLocal (getposATL _unit); 
	_magout setParticleParams 
	[ 
		["\A3\Structures_F_EPB\Items\Military\Magazine_rifle_F.p3d", 1, 0, 1], //shape name 
		"", //animation name 
		"SpaceObject", //type 
		0, gokoMag_var_magLifeTime, //timer period & life time 
		[0, 0, 0], //position 
		_velocity, //moveVeocity 
		random 1, 1, 0.1, 0, //rotation velocity, weight, volume, rubbing 
		[1], //size 
		[[1,1,1,1]], //color 
		[10], //animationPhase (animation speed in config) 
		0.1, //randomdirection period 
		0.05, //random direction intensity 
		"", //onTimer 
		"", //before destroy 
		"", //object 
		0, //angle 
		false, //on surface 
		0.4, //bounce on surface 
		[[1,0,0,0]] //randomizations I dont need 
	]; 

	_mempoints = ["LeftForeArm", "LeftForeArmRoll", "RightForeArmRoll", "rwrist"]; 
	_mempoint = selectrandom _mempoints; 
	_magout setDropInterval 420; 
	_magout attachTo [_unit,[0,0,0],_mempoint]; 
};
