local commands = {  }

function commands.onMapCommand(sender, args)
    util.executeCommand(string.format("map %s", args[2]))
end

function commands.onHelpCommand(sender, args)

end

function commands.onKickCommand(sender, args)

end

function commands.onBanCommand(sender, args)

end

function commands.onPermaBanCommand(sender, args)
    
end

return commands
