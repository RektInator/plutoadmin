# Plutonium Admin
Easily extendable admin plugin for the Plutonium IW5 (Modern Warfare 3) client.

## How to install
Simply drag & drop all the files of the repo in the root folder of your MW3 dedicated server. Type ``loadscript plutoadmin.lua`` to load the script. To obtain admin permissions, type !iamgod in the chat. This command will only work once. Type !help for a list of commands.

## Changing ranks & permissions
You can add new ranks to the settings.json file. You can also change the required level per command in the settings.json file. If you want to manually change someone's admin rank, you can modify the Admins.json file. Otherwise, just execute  ``!putgroup <nickname> <group>`` ingame.

## Adding custom commands to the plugin
If you want to add a new command, simply create a command definition in the settings.json file. Set the command name and the level that is required, then set the function callback. When you've done that, define the function callback in commands.lua. The callback will be executed when an admin executes the command and has the required permissions to execute the command.

## Current Change Log
**New Commands**: 
``!votemap <map>``
``!yes``
``!no``
``!discord``
``!website``
``!alias <player> <nickname>``
``!myalias <nickname>``
``!warn <player> <message>``
``!unwarn <player>``
``!adminchat <message>``
``!mute <player>``
``!unmute <player>``
``deletealias <player>``
``votecancel``
New usage of !teleport: ``!teleport <player> <target>``
``!scream <message>``
``!unban <player>``
``!kill <player>``
``!resetjumpheight``
``!resetspeed``
``!resetgravity``
``!falldamage <off/on>``
  **Additional Stuff**: 
  Added the option to remove certain ranks from the admins list.
  Added the option to display online admins in a timed message.
  Short names for guns and maps instead of using the full name.
  Permission checks for all commands (players can't ban a player with the same or a higher rank than their rank).
  Added chat and command logging.
  Added full language customization.
  Also fixed a lot of bugs that I can't be arsed to say them all.
  
