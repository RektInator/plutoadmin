json = require "json"
--[[discordia = require("discordia")
client = discordia.Client()]]

utils = require "scripts.mp.plutoadmin.utils"
commands = require "scripts.mp.plutoadmin.commands"
banhandler = require "scripts.mp.plutoadmin.banhandler"
settingshandler = require "scripts.mp.plutoadmin.settingshandler"
adminhandler = require "scripts.mp.plutoadmin.adminhandler"
messagequeue = require "scripts.mp.plutoadmin.messagequeue"
anticamp = require "scripts.mp.plutoadmin.anticamp"
rules = require "scripts.mp.plutoadmin.rules"
languagehandler = require "scripts.mp.plutoadmin.languagehandler"

util.print("Starting up plutoadmin by RektInator...")

-- onPlayerSay function
function onPlayerSay(args)
    local message = args.message
    
    local player = args.sender
    local realArgs = message:split(" ")
    local arguments = {}

    for arg in ipairs(realArgs) do
        if string.len(realArgs[arg]) > 0 then
            table.insert(arguments, realArgs[arg])
        end 
    end 

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
                            utils.tell(player, languagehandler.language.command_disabled:gsub("{command}", command))
                        end
                    else
                        util.print(string.format("Error: no callback defined for command %s!", command))                         
                    end
                else
                    -- print error
                    util.print(string.format("player %s with guid %s tried to execute command %s.",args.sender.name, args.sender:getguid(), command))
                    utils.tell(args.sender, "Insufficient permissions.")
                    --logs it in commands.txt
                    local commandFile = io.open("scripts\\mp\\plutoadmin\\logs\\commands.txt", "a")
                    commandFile:write(string.format("Player %s with guid %s tried to execute command %s\n\n", args.sender.name, args.sender:getguid(), command))
                    commandFile:close()
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

        if rank == 0 then

            if args.sender.data.mute == true then

                utils.iPrintLnBold(args.sender, languagehandler.language.player_muted)

                return true 

            end 

            local chatLog = io.open("scripts\\mp\\plutoadmin\\logs\\chat.txt", "a")
            chatLog:write(string.format("%s: %s\n\n", args.sender.name, args.message))
            chatLog:close()

        end 

        if rank > 0 then
            -- check if the group has a title
            local title = adminhandler.getTitleForRank(rank)
            local alias = adminhandler.getPlayerAlias(args.sender)

            -- checks if the admin is muted
            if args.sender.data.mute == true then
                utils.iPrintLnBold(args.sender, languagehandler.language.player_muted)
                return true
            else
                -- set title if not nil
                if title ~= nil then
                    local newMessage = string.format("%s%s^7: %s", settingshandler.settings.title:gsub("{title}", title), alias, args.message)
            
                    local chatLog = io.open("scripts\\mp\\plutoadmin\\logs\\chat.txt", "a")
                    chatLog:write(string.format("%s%s: %s\n\n", utils.removeNumbers(settingshandler.settings.title:gsub("{title}", title)), args.sender.name, args.message))
                    chatLog:close()
                
            
                    -- print new message in the chat
                    util.chatPrint(newMessage)
                    --also prints it to the console
                    util.print(string.format("%s: %s", player.name, message))
                    -- return true (don't send original)
                    return true
                 
                elseif alias ~= nil then
                    local newMessage = string.format("%s^7:%s", alias, args.message)
                
                    -- print new message in the chat
                    util.chatPrint(newMessage)
                

                    -- return true (don't send original)
                    return true

                end 
            end 

        end
    end


    return false


end 


-- onPlayerConnecting function
function onPlayerConnected(player)
    -- kick player if player is banned
    if banhandler.isPlayerBanned(player) then
        local reason = banhandler.getPlayerReason(player)
        utils.kickPlayer(player, reason)
    else
        if settingshandler.settings.connectedMessage then
            utils.chatPrint(languagehandler.language.player_joined:gsub("{player}", player.name))
        end
    end
end

function onFrame()

    for player in util.iterPlayers() do
        if player.data.suicide ~= nil and player.data.suicide == true then
            
            -- reset suicide flag
            player.data.suicide = false

            -- kill player
            player:suicide()

        end
    end

end

if settingshandler.settings.reset_warns_after_every_round == true then
    function onPreGame()
        playerWarns = {}
    end 
end

function isEmpty(s)
    return s == nil or s == ''
end


-- install callbacks
callbacks.frame.add(onFrame)
callbacks.playerSay.add(onPlayerSay)
callbacks.playerConnected.add(onPlayerConnected)
callbacks.preGameInit.add(onPreGame)

-- init subscripts
messagequeue.init()
anticamp.init()

util.print("Successfully loaded plutoadmin.")    
utils.chatPrint("Plutonium Admin started up successfully.")
