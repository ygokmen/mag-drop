/* 
 *	Goko Mag Drop add-on v1.26 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	Setting file using Extended PreInit EventHandlers
 *	Allows user to manipulate ignored list. 
 *	
*/

GSM_option_bShowMagAuthor = profileNamespace getVariable ["GSM_option_bShowMagAuthor", false];
GSM_option_nonCompatList = profileNamespace getVariable ["GSM_option_nonCompatList", 
	"
		BW-Mod**
		Bohemia Interactive**
		Example Author Name**
	"
];

[
	"GSM_option_nonCompatList",
	"EDITBOX",
	["Compatibility List/Disabled authors","Fix incompatible magazines: GSM will use 'generic rifle model' for author(s) in this list.\nUse ** (double asterisk) between each name instead of comma to seperate.\nCAUTION: Case sensitive:'bOheMia inTeracTive' will not work, 'Bohemia Interactive' will.\nOnly use 'author name' extracted from magazine config."],
	["Goko Simulate Mag Options", "Compatibility setting"],
	"BW-Mod**Bohemia Interactive**Example Author Name**",
	false,
	{

		if (!GSM_option_bShowMagAuthor || isNull findDisplay 46) exitWith {};
		params ["_list"];
		private _createArray = _list splitString "**";
		systemChat ":: Goko Simulate Mag :: Compatibility list updated!";
		hint Format ["'Generic model' will be used for: %1 \n magazine authors.", _createArray];
	}
] call CBA_Settings_fnc_init;

[
	"GSM_option_bShowMagAuthor",
	"CHECKBOX",
	["Show mag/Copy to clipboard","Automated solution to get mag author from config.\nStep1: Enable setting, reload problematic magazine you want to reveal.\nStep2: Magazine's author will be shown and copied to clipboard.\nFound magazine model is also created after reload for testing."],
	["Goko Simulate Mag Options", "Debugging"],
	false,
	false,
	{
		if (!GSM_option_bShowMagAuthor) exitWith {};
		[player, "reloaded", {
			if (GSM_option_bShowMagAuthor) then 
			{
				params ["_unit", "_weapon", "_muzzle", "_newmag", ["_oldmag", ["","","",""]]];
				if ( "" in [_muzzle, _weapon, _newmag#0]) exitWith {};

				private _getMagAuthor = getText(configfile >> "CfgMagazines" >> _newmag#0 >> "author");
				private _magAuthor = ["'", _getMagAuthor, "'"] joinString "";
				private _prepString = ["**", _getMagAuthor, "**"] joinString "";

				if (!(_weapon isEqualTo _muzzle) || isNull findDisplay 46) exitWith {};
				[["author is", _magAuthor] joinString " ", 3, 2.3, [0.9,1,0.7,0.7],true] spawn bis_fnc_wlsmoothtext;
				[["Loaded: ", getText(configfile >> "CfgMagazines" >> _newmag#0 >> "displayName")] joinString " ", 3, 2, [1,1,1,0.8],false] spawn bis_fnc_wlsmoothtext;
				
				copyToClipboard _prepString;
				systemchat Format ["%1 copied to clipboard.", _prepString];
				
				[player, "", "", "", "", _newmag#0, "", ""] call GSM_fnc_prepSimulation;
			} else {
				player removeEventHandler [_thisType, _thisID];
				["GSM system messages shut down", 3, 5, [1,1,1,0.4],true] spawn bis_fnc_wlsmoothtext;
				systemchat Format ["Current compatibility list is = %1", (GSM_option_nonCompatList splitString "**")];
			};
		}, time] call CBA_fnc_addBISEventHandler;
	}
] call CBA_Settings_fnc_init;
