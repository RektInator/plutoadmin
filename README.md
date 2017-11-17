# Plutonium Admin
Easily extendable admin plugin for the Plutonium IW5 (Modern Warfare 3) client.

## How to install
Simply drag & drop all the files of the repo in the root folder of your MW3 dedicated server. Type ``loadscript plutoadmin.lua`` to load the script. To obtain admin permissions, type !iamgod in the chat. This command will only work once. Type !help for a list of commands.

## Changing ranks & permissions
You can add new ranks to the settings.json file. You can also change the required level per command in the settings.json file. If you want to manually change someone's admin rank, you can modify the Admins.json file. Otherwise, just execute  ``!putgroup <nickname> <group>`` ingame.

## Adding custom commands to the plugin
If you want to add a new command, simply create a command definition in the settings.json file. Set the command name and the level that is required, then set the function callback. When you've done that, define the function callback in commands.lua. The callback will be executed when an admin executes the command and has the required permissions to execute the command.
