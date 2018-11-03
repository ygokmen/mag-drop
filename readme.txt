Empty mag simulation: while reloading a depleted mag (ammo null), A.I or player, unit will drop an empty magazine on ground. 
It uses relative velocity, sound effect when hit on ground. Uses a generic magazine model in game since weapon mags' are part of weapon model itself, they can't be used.

Mod use arma3's own physx based particle system so It doesn't kill performance, have almost 0 impact on performance.

[B]ChangeLog:[/B] [SPOILER]
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