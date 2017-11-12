local commands = {  }

function numArgs(args)
    local count = 0
    for _ in pairs(args) do count = count + 1 end
    return count
end

function concatArgs(args, index)
    local str

    for i = index, numArgs(args) do
        str = str .. " " .. args[i]
    end

    return str
end

function findPlayerByName(name)
    for p in util.iterPlayers() do
        if p.name:lower() == name:lower() then
            return p
        end

        if string.match(p.name:lower(), name:lower()) then
            return p
        end
    end
end

function commands.onGiveCommand(sender, args)

    if numArgs(args) == 2 then
        sender:give(args[2])
    else
        sender:tell("^0[^2Plutonium Admin^0]^7: usage: give <weapon>")             
    end

    return true

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

function commands.onSuicideCommand(sender, args)

    sender:suicide()
    return true

end

function commands.onUfoCommand(sender, args)

    if numArgs(args) == 2 then
        if args[2] == "on" then
            sender:ufo(true)            
        else
            sender:ufo(false)  
        end
    else
        sender:tell("^0[^2Plutonium Admin^0]^7: usage: ufo <on/off>")     
    end

    return true

end

function commands.onNoClipCommand(sender, args)

    if numArgs(args) == 2 then
        if args[2] == "on" then
            sender:noclip(true)            
        else
            sender:noclip(false)  
        end
    else
        sender:tell("^0[^2Plutonium Admin^0]^7: usage: noclip <on/off>")     
    end

    return true

end

function commands.onTeleportCommand(sender, args)

    if numArgs(args) == 4 then
        sender:setorigin(tonumber(args[2]), tonumber(args[3]), tonumber(args[4]))        
    else
        sender:tell("^0[^2Plutonium Admin^0]^7: usage: teleport <x> <y> <z>")             
    end

    return true

end

function commands.onGiveMaxAmmoCommand(sender, args)

    sender:givemaxammo(sender:getcurrentweapon())
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
            playerObj = findPlayerByName(player)
        end

        if playerObj ~= nil then
            utils.kickPlayer(playerObj, reason)
        else
            sender:tell("^0[^2Plutonium Admin^0]^7: player not found.")                 
        end

    else
        sender:tell("^0[^2Plutonium Admin^0]^7: usage: kick <player> <reason>")     
    end

    return true

end

function commands.onClientsCommand(sender, args)

    local out = "^0[^2Plutonium Admin^0]^7:"
    for p in util.iterPlayers() do
        out = out .. string.format( "[%i]: %s, ", p:getentitynumber(), p.name )
    end

    sender:tell(out)
    return true
    
end

function commands.onBotCommand(sender, args)

    if numArgs(args) == 2 then
        util.executeCommand(string.format("bot %i", tonumber(args[2])))
    else
        util.executeCommand("bot")
    end
    return true

end

function commands.onRageQuitCommand(sender, args)

    utils.kickPlayer(sender, "")
    return true
    
end

function commands.onBanCommand(sender, args)

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
            playerObj = findPlayerByName(player)
        end

        if playerObj ~= nil then
            banhandler.banPlayer(playerObj, reason)
        else
            sender:tell("^0[^2Plutonium Admin^0]^7: player not found.")                 
        end

    else
        sender:tell("^0[^2Plutonium Admin^0]^7: usage: ban <player> <reason>")     
    end

    return true

end

function commands.onPermaBanCommand(sender, args)
    
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
            playerObj = findPlayerByName(player)
        end

        if playerObj ~= nil then
            banhandler.banPlayer(playerObj, reason)
        else
            sender:tell("^0[^2Plutonium Admin^0]^7: player not found.")                 
        end

    else
        sender:tell("^0[^2Plutonium Admin^0]^7: usage: permaban <player> <reason>")     
    end

    return true

end

return commands
