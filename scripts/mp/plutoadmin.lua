json = require "json"

utils = require "scripts.mp.plutoadmin.utils"
commands = require "scripts.mp.plutoadmin.commands"
banhandler = require "scripts.mp.plutoadmin.banhandler"
settingshandler = require "scripts.mp.plutoadmin.settingshandler"
adminhandler = require "scripts.mp.plutoadmin.adminhandler"
messagequeue = require "scripts.mp.plutoadmin.messagequeue"

util.print("Starting up plutoadmin by RektInator...")

-- onPlayerSay function
function onPlayerSay(args)

    local message = args.message
    
    local player = args.sender
    local arguments = message:split(" ")

    -- check if we're handling a command
    if string.sub(arguments[1]:lower(), 1, 1) == "!" then
        
        -- extract command from message
        local command = string.sub( arguments[1]:lower(), 2 )

        -- check if command exists
        local commandFound = false
        for cmd in ipairs(settingshandler.settings.commands) do
            if settingshandler.settings.commands[cmd].command == command or
                (settingshandler.settings.commands[cmd].alias ~= nil and settingshandler.settings.commands[cmd].alias == command) then

                -- set commandFound to true
                commandFound = true

                -- check if the rank for the current player is high enough to execute the command
                if settingshandler.settings.commands[cmd].level <= adminhandler.getAdminRank(args.sender) then
                    -- execute command callback
                    if settingshandler.settings.commands[cmd].func ~= nil and commands[settingshandler.settings.commands[cmd].func] ~= nil then
                        if settingshandler.settings.commands[cmd].enabled == nil or 
                            (settingshandler.settings.commands[cmd].enabled ~= nil and settingshandler.settings.commands[cmd].enabled == true) then
                            return commands[settingshandler.settings.commands[cmd].func](player, arguments)                         
                        else
                            util.print(string.format("Error: command ^2%s^7 is disabled!", command))
                        end
                    else
                        util.print(string.format("Error: no callback defined for command ^2%s^7!", command))                         
                    end
                else
                    -- print error
                    util.print(string.format("player with guid %s tried to execute command ^2%s^7.", args.sender:getguid(), command))
                    utils.tell(args.sender, "Insufficient permissions.")
                end

            end
        end

        if commandFound ~= true then
            -- print error
            utils.tell(args.sender, string.format("Invalid command ^2%s^7.", command))
        end

        return true

    else

        -- normal chat message, lets see if the player is an admin.
        local rank = adminhandler.getAdminRank(args.sender)

        if rank > 0 then
            -- check if the group has a title
            local title = adminhandler.getTitleForRank(rank)
            local alias = adminhandler.getPlayerAlias(args.sender)

            -- set title if not nil
            if title ~= nil then
                local newMessage = string.format("^0[^7%s^0]^7 %s^7: %s", title, alias, args.message)

                -- print new message in the chat
                util.chatPrint(newMessage)

                -- return true (don't send original)
                return true
            elseif alias ~= nil then
                local newMessage = string.format("^7%s^7: %s", alias, args.message)
                
                -- print new message in the chat
                util.chatPrint(newMessage)

                -- return true (don't send original)
                return true
            end
        end

    end


    return false

end

-- onPlayerConnecting function
function onPlayerConnected(player)
    -- kick player if player is banned
    if banhandler.isPlayerBanned(player) then
        utils.kickPlayer(player, "You are banned from the server.")
    end
end

-- install callbacks
callbacks.playerSay.add(onPlayerSay)
callbacks.playerConnected.add(onPlayerConnected)

-- init the message queue
messagequeue.init()

util.print("Successfully loaded plutoadmin.")    
utils.chatPrint("Plutonium Admin started up successfully.")
