local commands = {  }

function numArgs(args)
    local count = 0
    for _ in pairs(args) do count = count + 1 end
    return count
end

function concatArgs(args, index)
    local str

    for i = index, numArgs(args) - 1 do
        str = str .. " " .. args[i]
    end

    return str
end

function commands.onMapRestartCommand(sender, args)
    
    gsc.map_restart(true)
    return true

end

function commands.onFastRestartCommand(sender, args)
    
    gsc.map_restart(false)
    return true

end

function commands.onMapCommand(sender, args)

    if numArgs(args) == 2 then
        util.executeCommand(string.format("map %s", args[2]))
    else
        sender:tell("^0[^2Plutonium Admin^0]^7: usage: map <mapname>")     
    end

    return true

end

function commands.onHelpCommand(sender, args)

end

function commands.onKickCommand(sender, args)

    if numArgs(args) >= 3 then
        
        player = args[2]
        reason = ""

        playerObj = nil

        if numArgs(args) > 3 then
            reason = concatArgs(args, 3)
        end

        if type(player) == "number" then
           playerObj = util.iterPlayers()[player]
        else
            for p in util.iterPlayers() do
                if p.name:lower() == player:lower() then
                    playerObj = p
                end
            end
        end

        if playerObj ~= nil then
            gsc.kick(playerObj, reason)
        end

    else
        sender:tell("^0[^2Plutonium Admin^0]^7: usage: kick <player> <reason>")     
    end

    return true

end

function commands.onRageQuitCommand(sender, args)
    
    gsc.kick(sender, "")
    return true
    
end

function commands.onBanCommand(sender, args)


    return true

end

function commands.onPermaBanCommand(sender, args)
    

    return true

end

return commands
