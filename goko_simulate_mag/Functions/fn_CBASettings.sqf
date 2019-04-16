/* 
 *	Goko Mag Drop add-on v1.25 for ARMA3 STEAM STABLE BRANCH
 *	Author: cgökmen 'the0utsider'
 *	Repo: github.com/the0utsider/mag-drop
 *
 *	Setting file using Extended PreInit EventHandlers
 *	Allows user to manipulate ignored list. 
 *	
*/
GSM_option_bHintListSystemchat = profileNamespace getVariable ["GSM_option_bHintListSystemchat", false];
GSM_option_nonCompatList = profileNamespace getVariable ["GSM_option_nonCompatList", 
	"
		BW-Mod**
		Bohemia Interactive
	"
];

[
	"GSM_option_nonCompatList",
	"EDITBOX",
	["Disabled magazine authors","Fix incompatible magazines: GSM will use 'generic rifle model' for author(s) in this list.\nUse ** (double asterisk) between each name instead of comma to seperate.\nCAUTION: Case sensitive:'bOheMia inTeracTive' will not work, 'Bohemia Interactive' will.\nOnly use 'author name' extracted from magazine config."],
	["Goko Simulate Mag Options", "Compatibility setting"],
	"BW-Mod**Bohemia Interactive**Your Example Author Name 3**",
	false,
	{
		if !(GSM_option_bHintListSystemchat) exitWith {};
		params ["_list"];
		private _createArray = _list splitString "**";
		systemChat ":: Goko Simulate Mag :: Compatibility list updated !";
		systemchat Format ["GSM will use generic model for %1 magazines.", _createArray];
	}
] call CBA_Settings_fnc_init;
[
	"GSM_option_bHintListSystemchat",
	"CHECKBOX",
	["Show in systemChat","Show disabled author array elements via system message."],
	["Goko Simulate Mag Options", "Compatibility setting"],
	false,
	false,
	{}
] call CBA_Settings_fnc_init;

