Empty mag throw simulation: while reloading a depleted mag (ammo null), A.I and player both, unit will drop an empty magazine on ground. 
Simulation uses relative velocity with randomization and sound effect when hit on ground. 

If reloaded weapon supports proxy magazine tech, mod will get the magazine model accordingly. If not, it will spawn a generic rifle magazine model.

This mod uses arma3's own physx based particle system. Performance impact is zero to none.

[B]ChangeLog:[/B] [SPOILER]
 V1.23 - 04-08-2019 hotfix2;
  - Modname changed to "magazine simulation A3"
  - Minor animation & sound tweaks

 V1.23 - 04-06-2019;
  - Fixed: Mod not working on RHS class soldiers now fixed
  - Fixed: Magazines spawning random bug is gone for good!
  - Tweak: Model getter method: All CUP and RHS weapons now fully working.
  - Added: Now using CBA ClassEventhandler method: improved compatibility
  - Added: Boolean for shooting from vehicle (mag simulation won't happen while shooting from offroad etc)
 V1.23alpha - 04-04-2019;
  - *NEW*: Persistent decals throughout mission time
  - *NEW*: Using BIS' super simple object method to simulate dropped magazines
  - *NEW*: Rewritten code and functionality for better simulation and efficiency
  - *NEW*: particleSource detection and protection method (no more flying mags)
  - Added: CBA WaitUntilAndExecute to improve mod performance
  - Fixed: Red Hammer Studios' mods working again
  - Fixed: models now stand on correct alignment on surfaces 
  - Fixed: Multiple particle source's being stacked on model 
  - Fixed: Soldier randomly spawning magazines is fixed for good
  - Tweak: sound emission max hearing range decreased to 30m
  - Tweak: Particle3D simulation weight and air friction adjusted
  - Tweak: attachTo model memory points
 V1.22 - 03-21-2019;
  - Fixed: Launchers spawning rocket model on reload
 V1.21 - 11-22-2018;
  - Added: A3 proxy magazine technology support
 V1.2 - 11-03-2018;
  - *New*: Mod uses fired eventhandler instead of reloaded EH
  - Added: New method runs less on scheduled environment
  - Added: Shortened loop cycle for better detection on player/non A.I.
 V1.1 - 04-30-2018;
  - Fixed: Player spawning particle simulation before hitting reload keybind
  - Added: switch for detecting 'reloadmagazine' action for human controlled units
  - Added: sound simulation and 7 different sound samples
  - Tweak: positional sound effect below unit's position using modelToWorldVisualWorld and playsound3d commands
  V1.0 - 04-29-2018:
  - Addon Released on steam as 'goko mag drop'
[/SPOILER]