json = require "json"

utils = require "scripts.mp.plutoadmin.utils"
commands = require "scripts.mp.plutoadmin.commands"
banhandler = require "scripts.mp.plutoadmin.banhandler"
settingshandler = require "scripts.mp.plutoadmin.settingshandler"
messagequeue = require "scripts.mp.plutoadmin.messagequeue"

util.print("Starting up plutoadmin by RektInator...")

-- onPlayerSay function
function onPlayerSay(args)

    local message = args.message:lower()
    
    player = args.sender
    arguments = message:split(" ")

    -- check if we're handling a command
    if string.sub(arguments[1], 1, 1) == "!" then
        
        -- extract command from message
        local command = string.sub( arguments[1], 2 )

        -- check if command exists
        commandFound = false
        for cmd in ipairs(settingshandler.settings.commands) do
            if settingshandler.settings.commands[cmd].command == command or
                (settingshandler.settings.commands[cmd].alias ~= nil and settingshandler.settings.commands[cmd].alias == command) then

                commandFound = true

                -- check if the rank for the current player is high enough to execute the command
                if settingshandler.settings.commands[cmd].level <= settingshandler.getAdminRank(args.sender) then
                    -- execute command callback
                    if settingshandler.settings.commands[cmd].func ~= nil and commands[settingshandler.settings.commands[cmd].func] ~= nil then
                        return commands[settingshandler.settings.commands[cmd].func](player, arguments)
                    else
                        util.print(string.format("Error, no callback defined for command %s!", command))                         
                    end
                else
                    -- print error
                    util.print(string.format("player with guid %s tried to execute command %s.", args.sender:getguid(), command))
                    utils.tell(args.sender, "Insufficient permissions.")
                end

            end
        end

        if commandFound ~= true then
            -- print error
            utils.tell(args.sender, "Invalid command \"%s\".", command)
        end

        return true

    end

    return false

end

-- onPlayerConnecting function
function onPlayerConnecting(args)

    -- kick player if player is banned
    if banhandler.isPlayerBanned(args.player) then
        return true
    end

    -- allow player
    return false

end

-- install callbacks
callbacks.playerSay.add(onPlayerSay)
callbacks.playerConnecting.add(onPlayerConnecting)

-- init the message queue
messagequeue.init()

util.print("Successfully loaded plutoadmin.")    
