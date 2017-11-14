local commands = {  }

function numArgs(args)
    return utils.getTableSize(args)
end

function concatArgs(args, index)
    local str = ""

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

    return nil
end

function commands.onIAmGodCommand(sender, args)

    if adminhandler.hasAdmins() == false then
        utils.tell(sender, "You are now super admin.")
        adminhandler.setRank(sender, sender, 5)
    end

    return true

end

function commands.onPutGroupCommand(sender, args)

    if numArgs(args) == 3 then

        local player = findPlayerByName(args[2])
        local rank = args[3]

        if player ~= nil then
            adminhandler.setRank(sender, player, rank)
        else
            utils.tell(sender, string.format("player %s not found.", args[2]))     
        end

    else
        utils.tell(sender, "usage: putgroup <player> <rank>")
    end

    return true

end

function commands.onNextMapCommand(sender, args)

    local nextmap = gsc.getdvar("nextmap")
    utils.tell(sender, string.format("Next map: %s", nextmap))
    return true

end

function commands.onAdminsCommand(sender, args)

    local out = "Admins online: "
    for p in util.iterPlayers() do
        local rank = adminhandler.getAdminRank(p)
        if rank > 1 then
            out = out .. string.format("^2%s^7 [%i], ", p.name, rank) 
        end
    end
    utils.tell(sender, out)
    return true

end

function commands.onGiveCommand(sender, args)

    if numArgs(args) == 2 then
        sender:give(args[2])
    else
        utils.tell(sender, "usage: give <weapon>")             
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
        utils.tell(sender, "usage: map <mapname>")     
    end

    return true

end

function commands.onSuicideCommand(sender, args)

    callbacks.afterDelay.add(200,
        function()
            sender:suicide()
        end
    )

    return true

end

function commands.onUfoCommand(sender, args)

    if numArgs(args) == 2 then
        if args[2]:lower() == "on" then
            sender:ufo(true)            
        else
            sender:ufo(false)  
        end
    else
        utils.tell(sender, "usage: ufo <on/off>")     
    end

    return true

end

function commands.onNoClipCommand(sender, args)

    if numArgs(args) == 2 then
        if args[2]:lower() == "on" then
            sender:noclip(true)            
        else
            sender:noclip(false)  
        end
    else
        utils.tell(sender, "usage: noclip <on/off>")     
    end

    return true

end

function commands.onTeleportCommand(sender, args)

    if numArgs(args) == 4 then
        sender:setorigin(Vector3.new(utils.toNumber(args[2]), utils.toNumber(args[3]), utils.toNumber(args[4])))
    elseif numArgs(args) == 2 then
        local player = findPlayerByName(args[2])
        
        if player ~= nil then
            local playerOrigin = player:getorigin()
            sender:setorigin(Vector3.new(playerOrigin.x, playerOrigin.y - 100, playerOrigin.z + 100))
        else
            utils.tell(sender, "Player not found.")
        end
    else
        utils.tell(sender, "usage: teleport <x> <y> <z>")             
    end

    return true

end

function commands.onGiveMaxAmmoCommand(sender, args)

    sender:givemaxammo(sender:getcurrentweapon())
    return true

end

function commands.onHelpCommand(sender, args)

    local out = "Available commands: "
    local rank = adminhandler.getAdminRank(sender)

    for cmd in ipairs(settingshandler.settings.commands) do

        if rank >= settingshandler.settings.commands[cmd].level then
            if settingshandler.settings.commands[cmd].hide == nil or (
                settingshandler.settings.commands[cmd].hide ~= nil and settingshandler.settings.commands[cmd].hide == false) then
                out = out .. string.format("%s, ", settingshandler.settings.commands[cmd].command)
            end
            if adminhandler.hasAdmins() == false and settingshandler.settings.commands[cmd].command == "iamgod" then
                out = out .. string.format("%s, ", settingshandler.settings.commands[cmd].command)
            end
        end

    end

    utils.tell(sender, out)
    return true

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
            utils.tell(sender, "player not found.")                 
        end

    else
        utils.tell(sender, "usage: kick <player> <reason>")     
    end

    return true

end

function commands.onClientsCommand(sender, args)

    local out = "Online Players: "
    for p in util.iterPlayers() do
        out = out .. string.format( "^7[%i]: ^2%s^7, ", p:getentitynumber(), p.name )
    end

    utils.tell(sender, out)
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

function parseTime(time)

    local type = string.sub( time, string.len( time ) )
    local duration = utils.toNumber(string.sub( time, 1, string.len( time ) - 1 ))
    
    if type == "s" then
        return duration
    elseif type == "m" then
        return 60 * duration
    elseif type == "h" then
        return 60 * 60 * duration
    elseif type == "d" then
        return 24 * 60 * 60 * duration
    elseif type == "w" then
        return 7 * 24 * 60 * 60 * duration
    elseif type == "y" then
        return 52 * 7 * 24 * 60 * 60 * duration
    else
        return nil
    end

end

function commands.onBanCommand(sender, args)

    if numArgs(args) >= 2 then
        
        player = args[2]
        reason = ""

        playerObj = nil

        -- 2 weeks (default time)
        time = 2 * 7 * 24 * 60 * 60

        if numArgs(args) > 3 then
            time = parseTime(args[3])

            if time == nil then
                utils.telL(sender, "Invalid time format. Correct time formats are: 30s (seconds), 10m (minutes), 5h (hours), 20d (days), 3w (weeks), 2y (years).")
                return true
            end
        end

        if numArgs(args) > 4 then
            reason = concatArgs(args, 4)
        end

        if type(player) == "number" then
            playerObj = util.iterPlayers()[player]
        else
            playerObj = findPlayerByName(player)
        end

        if playerObj ~= nil then
            banhandler.banPlayer(sender, playerObj, reason, time)
        else
            utils.tell(sender, "player not found.")                 
        end

    else
       utils.tell(sender, "usage: ban <player> <time> <reason>")     
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
            banhandler.banPlayer(sender, playerObj, reason, nil)
        else
            utils.tell(sender, "player not found.")                 
        end

    else
        utils.tell(sender, "usage: permaban <player> <reason>")     
    end

    return true

end

function commands.onJumpHeightCommand(sender, args)

    if numArgs(args) == 2 then
        gsc.setdvar("jump_height", utils.toNumber(args[2]))
    else
        utils.tell(sender, "usage: jumpheight <value>")
    end
    return true

end

function commands.onSpeedCommand(sender, args)
    
    if numArgs(args) == 2 then
        gsc.setdvar("g_speed", utils.toNumber(args[2]))
    else
        utils.tell(sender, "usage: speed <value>")
    end
    return true

end

function commands.onGravityCommand(sender, args)
    
    if numArgs(args) == 2 then
        gsc.setdvar("g_gravity", utils.toNumber(args[2]))
    else
        utils.tell(sender, "usage: gravity <value>")
    end
    return true

end

function commands.onWarnCommand(sender, args)

    utils.tell(sender, "Not yet implemented, kick the player instead.")
    return true

end

function commands.onSayCommand(sender, args)

    local out = "^0[" .. settingshandler.settings.sayName .. "^0][^7" .. sender.name .. "^0]^7:"
    text = concatArgs(args, 2)
    util.chatPrint(out .. text)
    return true

end 

function commands.onAliasCommand(sender, args)

    if numArgs(args) >= 2 then
        local alias = concatArgs(args, 2)
        adminhandler.setAlias(sender, alias)
    else
        utils.tell(sender, "usage: alias <nickname>")
    end
    return true

end

function commands.onPMCommand(sender, args)

    if numArgs(args) >= 3 then
        local player = findPlayerByName(args[2])
        local message = concatArgs(args, 3)

        if player ~= nil then
            player:tell("^0[^2PM^0][^2%s^0]: %s", sender.name, message)
        else
            utils.tell(sender, "Player not found.")
        end
    else
        utils.tell(sender, "usage: pm <player> <message>")
    end

    return true

end

function commands.onRulesCommand(sender, args)

    if rules.getNumRules() > 0 then
        for r in ipairs(rules.getRules()) do
            callbacks.afterDelay.add(1000 * r, function()
                utils.tell(sender, rules.getRule(r))
            end)
        end
    else
        utils.tell(sender, "There are no rules.")
    end

    return true

end

function commands.onSetCommand(sender, args)

    if numArgs(args) >= 3 then
        local dvar = args[2]
        local value = concatArgs(args, 3)

        gsc.setdvar(dvar, value)
    else
        utils.tell(sender, "usage: set <dvar> <value>")
    end

end

return commands
