local commands = {  }

playerWarns = {}


votemapConfig = {}
votemapFile = utils.read_file("votemapConfig.json")
votemapConfig.votemap = json.decode(votemapFile)
local votedPlayer
local onGoingVote = false
local voteTime = votemapConfig.votemap.voteTime
local playerVote = {}
local noVotes = 0
local yesVotes = 0

reportConfig = {}
reportFile = utils.read_file("scripts\\mp\\plutoadmin\\report\\report.json")
reportConfig.report = json.decode(reportFile)

local colors = {}
table.insert(colors, "^1")
table.insert(colors, "^2")
table.insert(colors, "^3")
table.insert(colors, "^4")
table.insert(colors, "^5")
table.insert(colors, "^6")
table.insert(colors, "^7")
table.insert(colors, "^8")
table.insert(colors, "^9")
table.insert(colors, "^;")
table.insert(colors, "^:")

local weapons = {}
table.insert(weapons, {longName = "iw5_acr_mp", shortName = "acr"})
table.insert(weapons, {longName = "iw5_type95_mp", shortName = "type95"})
table.insert(weapons, {longName = "iw5_m4_mp", shortName = "m4"})
table.insert(weapons, {longName = "iw5_ak47_mp", shortName = "ak47"})
table.insert(weapons, {longName = "iw5_m16_mp", shortName = "m16"})
table.insert(weapons, {longName = "iw5_mk14_mp", shortName = "mk14"})
table.insert(weapons, {longName = "iw5_g36c_mp", shortName = "g36c"})
table.insert(weapons, {longName = "iw5_scar_mp", shortName = "scar"})
table.insert(weapons, {longName = "iw5_fad_mp", shortName = "fad"})
table.insert(weapons, {longName = "iw5_cm901_mp", shortName = "cm901"})
table.insert(weapons, {longName = "iw5_mp5_mp", shortName = "mp5"})
table.insert(weapons, {longName = "iw5_p90_mp", shortName = "p90"})
table.insert(weapons, {longName = "iw5_m9_mp", shortName = "m9"})
table.insert(weapons, {longName = "iw5_pp90m1_mp", shortName = "pp90m1"})
table.insert(weapons, {longName = "iw5_ump45_mp ", shortName = "ump45"})
table.insert(weapons, {longName = "iw5_mp7_mp", shortName = "mp7"})
table.insert(weapons, {longName = "iw5_spas12_mp", shortName = "spas12"})
table.insert(weapons, {longName = "iw5_aa12_mp", shortName = "aa12"})
table.insert(weapons, {longName = "iw5_striker_mp", shortName = "striker"})
table.insert(weapons, {longName = "iw5_1887_mp", shortName = "1887"})
table.insert(weapons, {longName = "iw5_usas12_mp",  shortName = "usas12"})
table.insert(weapons, {longName = "iw5_ksg_mp", shortName = "ksg"})
table.insert(weapons, {longName = "iw5_m60_mp", shortName = "m60"})
table.insert(weapons, {longName = "iw5_mk46_mp", shortName = "mk46"})
table.insert(weapons, {longName = "iw5_pecheneg_mp", shortName = "pecheneg"})
table.insert(weapons, {longName = "iw5_sa80_mp", shortName = "sa80"})
table.insert(weapons, {longName = "iw5_mg36_mp", shortName = "mg36"})
table.insert(weapons, {longName = "iw5_barrett_mp", shortName = "barrett"})
table.insert(weapons, {longName = "iw5_msr_mp",  shortName = "msr"})
table.insert(weapons, {longName = "iw5_rsass_mp", shortName = "rsass"})
table.insert(weapons, {longName = "iw5_dragunov_mp", shortName = "dragunov"})
table.insert(weapons, {longName = "iw5_as50_mp", shortName = "as50"})
table.insert(weapons, {longName = "iw5_l96a1_mp", shortName = "l96a1"})
table.insert(weapons, {longName = "iw5_usp45_mp", shortName = "usp45"})
table.insert(weapons, {longName = "iw5_mp412_mp", shortName = "mp412"})
table.insert(weapons, {longName = "iiw5_44magnum_mp", shortName = "44magnum"})
table.insert(weapons, {longName = "iw5_deserteagle_mp", shortName = "deserteagle"})
table.insert(weapons, {longName = "iw5_p99_mp", shortName = "p99"})
table.insert(weapons, {longName = "iw5_fnfiveseven_mp", shortName = "fiveseven"})
table.insert(weapons, {longName = "iw5_fmg9_mp", shortName = "fmg9"})
table.insert(weapons, {longName = "iw5_g18_mp", shortName = "g18"})
table.insert(weapons, {longName = "iw5_mp9_mp", shortName = "mp9"})
table.insert(weapons, {longName = "iw5_skorpion_mp", shortName = "skorpion"})
table.insert(weapons, {longName = "rpg_mp", shortName = "rpg"})
table.insert(weapons, {longName = "javelin_mp", shortName = "javelin"})
table.insert(weapons, {longName = "iw5_smaw_mp", shortName = "smaw"})
table.insert(weapons, {longName = "m320_mp", shortName = "m320"})

function commands.onVoteMapCommand(sender, args)

    if numArgs(args) == 2 then
        logCommand(sender, args)
        if onGoingVote == false then
            local map = getMapName(args)

            if map ~= nil and map ~= languagehandler.language.map_disabled then

                if map == gsc.getdvar("mapname") then
                    utils.iPrintLnBold(sender, languagehandler.language.map_already_on:gsub("{map}", args[2]))
                    return true
                end 

                playerVote[sender:getguid()] = true
                yesVotes = yesVotes + 1
                onGoingVote = true 
                local votedMap = map
                local message = languagehandler.language.on_votemap:gsub("{player}", sender.name)
                utils.chatPrint(message:gsub("{map}", args[2]))
                utils.chatPrint(languagehandler.language.vote_alert)
                votedPlayer = adminhandler.getAdminRank(sender)

                callbacks.afterDelay.add(voteTime * 1000, function()
                    if onGoingVote == true then
                        if yesVotes > noVotes then
                            yesVotes = 0
                            noVotes = 0
                            onGoingVote = false
                            playerVote = {}
                            utils.chatPrint(languagehandler.language.changing_map:gsub("{map}", args[2]:lower()))
                            callbacks.afterDelay.add(1000, function()
                                util.executeCommand(string.format("map %s", votedMap))
                            end)
                        else 
                            utils.chatPrint(languagehandler.language.vote_failed)
                            yesVotes = 0
                            noVotes = 0
                            onGoingVote = false 
                            playerVote = {}
                        end 
                    else 
                        return true 
                    end 
                end)
            elseif map == nil then
                utils.iPrintLnBold(sender, languagehandler.language.map_not_valid)
            elseif map == languagehandler.language.map_disabled then
                utils.tell(sender, map:gsub("{map}", args[2]))
            end 
        else 
            utils.tell(sender, languagehandler.language.voting_already_on)
        end 
    else 
        utils.tell(sender, languagehandler.language.votemap_usage)
    end 
    return true 

end 

function getWeaponName(name)

    for weapon in pairs(weapons) do

        if name:lower() == weapons[weapon].shortName:lower() or name:lower() == weapons[weapon].longName:lower() then
            return weapons[weapon].longName
        end 

    end 

    return nil 

end 

function commands.onYesCommand(sender, args)

    if onGoingVote == true then 
        if playerVote[sender:getguid()] == true then

            utils.tell(sender, languagehandler.language.already_voted:gsub("{choice}", "Yes"))
                
        elseif playerVote[sender:getguid()] == false then

            utils.tell(sender, languagehandler.language.changing_vote)
            playerVote[sender:getguid()] = true 
            utils.chatPrint(languagehandler.language.changed_vote_yes:gsub("{player}", sender.name))
            yesVotes = yesVotes + 1
        else 
            playerVote[sender:getguid()] = true
            utils.chatPrint(languagehandler.language.vote_yes_alert:gsub("{player}", sender.name))
            yesVotes = yesVotes + 1
        end 
    else 
        utils.iPrintLnBold(sender, languagehandler.language.no_vote_playing)
    end 
    return true 

end 

function flushReportFile()

    reportJson = json.encode(reportConfig.report)

    utils.write_file("scripts\\mp\\plutoadmin\\report\\report.json", reportJson)

end 

function commands.onReportCommand(sender, args)

    if numArgs(args) >= 2 then

        local message = concatArgs(args, 2)

        reportConfig.report.server_name = gsc.getdvar("sv_hostname")
        reportConfig.report.reporter = sender.name
        reportConfig.report.message = message
        reportConfig.report.webhook = settingshandler.settings.discord_webhook_link

        flushReportFile()

        utils.tell(sender, languagehandler.language.report_successful)

    else 
        utils.tell(sender, languagehandler.language.report_usage)
    end 
    return true 

end 

function commands.onNoCommand(sender, args)

    if onGoingVote == true then
        if playerVote[sender:getguid()] == false then

            utils.tell(sender, languagehandler.language.already_voted:gsub("{choice}", "No"))

        elseif playerVote[sender:getguid()] == true then

            utils.tell(sender, languagehandler.language.changing_vote)
            playerVote[sender:getguid()] = false
            utils.chatPrint(languagehandler.language.changed_vote_no:gsub("{player}", sender.name))
            noVotes = noVotes + 1
        else 
            playerVote[sender:getguid()] = false 
            utils.chatPrint(languagehandler.language.vote_no_alert:gsub("{player}", sender.name))
            noVotes = noVotes + 1
        end 
    else 
        utils.iPrintLnBold(sender, languagehandler.language.no_vote_playing)
    end 
    return true 

end 

function commands.onCancelVoteCommand(sender, args)
    
    if onGoingVote == true then
    
        if adminhandler.getAdminRank(sender) >= votedPlayer then
            
            logCommand(sender, args)
            onGoingVote = false
            yesVotes = 0
            noVotes = 0
            playerVote = {}
            utils.chatPrint(languagehandler.language.vote_canceled:gsub("{player}", sender.name))
    
        else 
    
            utils.iPrintLnBold(sender, languagehandler.language.low_level_cancel)
    
        end 

    else 
    
        utils.iPrintLnBold(sender, languagehandler.language.no_vote_playing)
    
    end 
    return true 
    
end

function addWarn(player, message, sender)

    if playerWarns[player:getguid()] == nil then
            
        playerWarns[player:getguid()] = 1

    elseif playerWarns[player:getguid()] ~= settingshandler.settings.max_warns then

        playerWarns[player:getguid()] = playerWarns[player:getguid()] + 1

    end
    if playerWarns[player:getguid()] ~= settingshandler.settings.max_warns then
        local withOutWarn = languagehandler.language.warn_chat_print:gsub("{player}", player.name)
        local withOutMaxWarn = withOutWarn:gsub("{warn}", tostring(playerWarns[player:getguid()]))
        local withOutMessage = withOutMaxWarn:gsub("{max_warns}", tostring(settingshandler.settings.max_warns))
        local final = withOutMessage:gsub("{message}", message)
        utils.chatPrint(final)
        local rank = adminhandler.getAdminRank(sender)
        local withRank = languagehandler.language.warned_player_alert:gsub("{rank}", utils.removeNumbers(adminhandler.getTitleForRank(rank)))
        local withSender = withRank:gsub("{player}", sender.name)
        local withWarn = withSender:gsub("{warn}", tostring(playerWarns[player:getguid()]))
        local withMaxWarn = withWarn:gsub("{max_warns}", tostring(settingshandler.settings.max_warns))
        local finalAlert = withMaxWarn:gsub("{message}", message)
        utils.iPrintLnBold(player, finalAlert)
    end 

    if playerWarns[player:getguid()] == settingshandler.settings.max_warns then
        if settingshandler.settings.ban_after_max_warns == true then
            local time = parseTime(settingshandler.settings.default_ban_time)
            local messageTime = parseTimeToRealTime(time)
                
            local withMessage = languagehandler.language.ban_message:gsub("{message}", message)
            local withWebsite = withMessage:gsub("{website}", settingshandler.settings.website)
            local withTime = withWebsite:gsub("{time}", messageTime)
            local banMessage = withTime:gsub("{admin}", sender.name)

            banhandler.banPlayer(sender, player, banMessage, time, message)
        elseif settingshandler.settings.ban_after_max_warns == false then

            local withAdmin = languagehandler.language.kick_message:gsub("{admin}", sender.name)
            local reason = withAdmin:gsub("{message}", message)
            
            utils.kickPlayer(player, reason)

            local withPlayer = languagehandler.language.kick_chat_print:gsub("{player}", player.name)
            local withAdmin = withPlayer:gsub("{admin}", sender.name)
            utils.chatPrint(withAdmin:gsub("{message}", message))

        end 

        playerWarns[player:getguid()] = nil
    end 

end 

function unWarn(player, sender)

    if playerWarns[player:getguid()] == nil then

        utils.iPrintLnBold(sender, languagehandler.language.player_has_no_warns:gsub("{player}", player.name))

    else 
        utils.chatPrint(languagehandler.language.unwarn_successful:gsub("{player}", player.name))

        playerWarns[player:getguid()] = nil
    end 

end 

function parseTimeToRealTime(number)

    if number ~= nil then
        if number == 1 then
            return "1 Second"
        elseif number > 1 and number < 60 then
            return string.format("%s Seconds", tostring(math.floor(number)))
        elseif number == 60 then
            return "1 Minute"
        elseif number > 60 and number < 3600 then
            return string.format("%s Minutes", tostring(math.floor(number/60)))
        elseif number == 3600 then
            return "1 Hour"
        elseif number > 3600 and number < 86400 then
            return string.format("%s Hours", tostring(math.floor(number/3600)))
        elseif number == 86400 then 
            return "1 Day"
        elseif number > 86400 and number < 31557600 then
            return string.format("%s Days", tostring(math.floor(number/86400)))
        elseif number == 31557600 and number < 63115200 then
            return "1 Year"
        else
            return string.format("%s Years", tostring(math.floor(number/31557600)))
        end 
    end 

    return nil

end 

function commands.onUnWarnCommand(sender, args)

    if numArgs(args) == 2 then
        logCommand(sender, args)
        if string.sub(args[2], 1, 1) == "#" then
            local entity = player:getentitynumber()
            local player = findPlayerByEntityNumber(entity)
            if player == nil then 
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if checkPermissionToDo(sender, player) then 
                    unWarn(player, sender)
                else 
                    utils.tell(sender, languagehandler.language.low_level_unwarn)
                end 
            end 
        else 
            local player = findPlayerByName(args[2])
            if player == nil then 
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if checkPermissionToDo(sender, player) then 
                    unWarn(player, sender)
                else 
                    utils.tell(sender, languagehandler.language.low_level_unwarn)
                end 
            end
        end 
    else 
        utils.tell(sender, languagehandler.language.unwarn_usage)
    end 
    return true 

end 

function commands.onAdminChatCommand(sender, args)

    if numArgs(args) >= 2 then
        local message = concatArgs(args, 2)
        local chatLog = io.open("scripts\\mp\\plutoadmin\\logs\\chat.txt", "a")
        chatLog:write(string.format("[Admin Chat]%s:%s\n\n", sender.name, message))
        chatLog:close()
        local cmdrank = adminhandler.getRankForCommand("adminchat")

        for p in util.iterPlayers() do 
            if cmdrank ~= nil then
                if adminhandler.getAdminRank(p) >= cmdrank then
                    p:tell(string.format("%s%s:%s", languagehandler.language.admin_chat, sender.name, message))
                end 
            end  
        end 
    else 
        utils.tell(sender, languagehandler.language.admin_chat_usage)
    end 
    return true 

end 

function mutePlayer(player, sender)

    player.data.mute = true 

    utils.chatPrint(languagehandler.language.player_got_muted:gsub("{player}", player.name))
    local withRank = languagehandler.language.alert_muted_player:gsub("{rank}", utils.removeNumbers(adminhandler.getTitleForRank(adminhandler.getAdminRank(sender))))
    utils.iPrintLnBold(player, withRank:gsub("{name}", sender.name))

end 

function commands.onMuteCommand(sender, args)

    if numArgs(args) == 2 then
        logCommand(sender, args)
        
        if string.sub(args[2], 1, 1) == "#" then
            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(tonumber(entity))

            if player == nil then 
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if checkPermissionToDo(sender, player) then 
                    mutePlayer(player, sender)
                else 
                    utils.tell(sender, languagehandler.language.low_level_mute)
                    utils.tell(player, languagehandler.language.low_level_mute_alert:gsub("{player}", sender.name))
                end 
            end 
        else 
            local player = findPlayerByName(args[2])

            if player == nil then 
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if checkPermissionToDo(sender, player) then 
                    mutePlayer(player, sender)
                else 
                    utils.tell(sender, languagehandler.language.low_level_mute)
                    utils.tell(player, languagehandler.language.low_level_mute_alert:gsub("{player}", sender.name))
                end 
            end 
        end 

    else 
        utils.tell(sender, languagehandler.language.mute_usage)
    end 
    return true 

end 

function unMutePlayer(player, sender)

    if player.data.mute == true then
        player.data.mute = false

        utils.chatPrint(languagehandler.language.unmute_successful:gsub("{player}", player.name))
        utils.iPrintLnBold(player, languagehandler.language.alert_unmuted_player)
    else 
        utils.tell(sender, languagehandler.language.player_isnt_muted:gsub("{player}", player.name))
    end 

end 

function commands.onUnMuteCommand(sender, args)

    if numArgs(args) == 2 then
        logCommand(sender, args)

        if string.sub(args[2], 1 ,1) == "#" then 
            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(tonumber(entity))

            if player == nil then 
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if checkPermissionToDo(sender, player) then 
                    unMutePlayer(player, sender)
                else 
                    utils.tell(sender, languagehandler.language.low_level_unmute)
                end 
            end 
        else 
            local player = findPlayerByName(args[2])

            if player == nil then 
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if checkPermissionToDo(sender, player) then 
                    unMutePlayer(player, sender)
                else 
                    utils.tell(sender, languagehandler.language.low_level_unmute)
                end 
            end 
        end 

    else 
        utils.tell(sender, languagehandler.language.unmute_usage)
    end 
    return true

end 

function getMapName(args)
    
    for map in ipairs(votemapConfig.votemap.mapList) do
        if votemapConfig.votemap.mapList[map].enabled == true then
            if args[2]:lower() == votemapConfig.votemap.mapList[map].shortName:lower() or args[2]:lower() == votemapConfig.votemap.mapList[map].longName:lower() then
                return votemapConfig.votemap.mapList[map].longName
            end 
        else
            return languagehandler.language.map_disabled
        end 
    end 
    return nil

end 

function isEmpty(object)

    if object == nil or object == '' then
        return true
    else 
        return false 
    end

end 

function logCommand(sender, args)

    if numArgs(args) >= 4 then

        local message = concatArgs(args, 4)
        local commandLog = io.open("scripts\\mp\\plutoadmin\\logs\\commands.txt", "a")
        commandLog:write(string.format("%s %s has executed command %s %s %s%s\n\n", utils.removeNumbers(adminhandler.getTitleForRank(adminhandler.getAdminRank(sender))), sender.name, args[1], args[2], args[3], message))

    elseif numArgs(args) >= 3 then

        local message = concatArgs(args, 3)
        local commandLog = io.open("scripts\\mp\\plutoadmin\\logs\\commands.txt", "a")
        commandLog:write(string.format("%s %s has executed command %s %s%s\n\n", utils.removeNumbers(adminhandler.getTitleForRank(adminhandler.getAdminRank(sender))), sender.name, args[1], args[2], message))
        commandLog:close()
    
    elseif numArgs(args) == 2 then

        local commandLog = io.open("scripts\\mp\\plutoadmin\\logs\\commands.txt", "a")
        commandLog:write(string.format("%s %s has executed command %s %s\n\n", utils.removeNumbers(adminhandler.getTitleForRank(adminhandler.getAdminRank(sender))), sender.name, args[1], args[2]))
        commandLog:close()

    elseif numArgs(args) == 1 then

        local commandLog = io.open("scripts\\mp\\plutoadmin\\logs\\commands.txt", "a")
        commandLog:write(string.format("%s %s has executed command %s\n\n", utils.removeNumbers(adminhandler.getTitleForRank(adminhandler.getAdminRank(sender))), sender.name, args[1]))
        commandLog:close()
    end 

end 

function numArgs(args)
    return utils.getTableSize(args)
end

function concatArgs(args, index)
    local str = ""

    for i = index, numArgs(args) do
        str = string.format("%s %s", str, args[i])
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

function findPlayerByEntityNumber(number)
    for p in util.iterPlayers() do 
        if p:getentitynumber() == number then
            return p 
        end 
    end 

    return nil 
end 

function commands.onIAmGodCommand(sender, args)

    if adminhandler.hasAdmins() == false then
        adminhandler.setRank(sender, sender, 5)
    end

    return true

end

function commands.onWarnCommand(sender, args)

    if numArgs(args) >= 3 then
        logCommand(sender, args)
        if string.sub(args[2], 1, 1) == "#" then
            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(tonumber(entity))
            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if checkPermissionToDo(sender, player) then
                    local message = concatArgs(args, 3)
                    addWarn(player, message, sender) 
                else 
                    utils.tell(sender, languagehandler.language.warn_low_level)
                    utils.tell(player, languagehandler.language.low_level_warn_alert:gsub("{player}", sender.name))
                end 
            end 
        else 
            local player = findPlayerByName(args[2])
            if player ~= nil then
                if checkPermissionToDo(sender, player) then
                    local message = concatArgs(args, 3)
                    addWarn(player, message, sender) 
                else 
                    utils.tell(sender, languagehandler.language.warn_low_level)
                    utils.tell(player, languagehandler.language.low_level_warn_alert:gsub("{player}", sender.name))
                end
            else 
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            end 
        end
    elseif numArgs(args) == 2 then
        logCommand(sender, args)
        if string.sub(args[2], 1, 1) == "#" then
            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(tonumber(entity))
            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if checkPermissionToDo(sender, player) then
                    addWarn(player, languagehandler.language.default_warn_message, sender)
                else 
                    utils.tell(sender, languagehandler.language.warn_low_level)
                    utils.tell(player, languagehandler.language.low_level_warn_alert:gsub("{player}", sender.name))
                end 
            end 
        else 
            local player = findPlayerByName(args[2])
            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if checkPermissionToDo(sender, player) then
                    addWarn(player, languagehandler.language.default_warn_message, sender)
                else 
                    utils.tell(sender, languagehandler.language.warn_low_level)
                    utils.tell(player, languagehandler.language.low_level_warn_alert:gsub("{player}", sender.name))
                end
            end 
        end 
    else 
        utils.tell(sender, languagehandler.language.warn_usage)
    end 
    return true 

end 

function commands.onPutGroupCommand(sender, args)

    if numArgs(args) == 3 then
        
        logCommand(sender, args)
        local rank = args[3]

        if string.sub(args[2], 1, 1) == "#" then

            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(tonumber(entity))

            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if player == sender then 
                    utils.iPrintLnBold(sender, languagehandler.language.change_self_rank)
                else 
                    if checkPermissionToDo(sender, player) then
                        if string.find(rank, "%d") then
                            if tonumber(rank) == adminhandler.getAdminRank(player) then 
                            utils.iPrintLnBold(sender, languagehandler.language.already_has_rank:gsub("{player}", player.name))
                            else 
                            adminhandler.setRank(sender, player, tonumber(rank))
                            end 
                        else 
                            if adminhandler.getRankByName(rank) == adminhandler.getAdminRank(player) then 
                                utils.iPrintLnBold(sender, languagehandler.language.already_has_rank:gsub("{player}", player.name))
                            else 
                                adminhandler.setRank(sender, player, rank)
                            end 
                        end 
                    else 
                        utils.tell(sender, languagehandler.language.low_level_pg)
                    end 
                end 
            end 

        else 

            local player = findPlayerByName(args[2])

            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if player == sender then 
                    utils.iPrintLnBold(sender, languagehandler.language.change_self_rank)
                else 
                    if checkPermissionToDo(sender, player) then
                        if string.find(rank, "%d") then
                            if tonumber(rank) == adminhandler.getAdminRank(player) then 
                            utils.iPrintLnBold(sender, languagehandler.language.already_has_rank:gsub("{player}", player.name))
                            else 
                            adminhandler.setRank(sender, player, tonumber(rank))
                            end 
                        else 
                            if adminhandler.getRankByName(rank) == adminhandler.getAdminRank(player) then 
                                utils.iPrintLnBold(sender, languagehandler.language.already_has_rank:gsub("{player}", player.name))
                            else 
                                adminhandler.setRank(sender, player, rank)
                            end 
                        end 
                    else 
                        utils.tell(sender, languagehandler.language.low_level_pg)
                    end 
                end  
            end 

        end 
        
    else
        utils.tell(sender, languagehandler.language.putgroup_usage)
    end
    return true

end 

function commands.onRageQuitCommand(sender, args)
    
    utils.kickPlayer(sender, languagehandler.language.rage_kick_message)
    return true
        
end

function commands.onResetJumpCommand(sender, args)
    
    logCommand(sender, args)
    gsc.setdvar("jump_height", "39")
    utils.tell(sender, languagehandler.language.jump_reset)
    return true
    
end 

    
function commands.onResetGravityCommand(sender, args)
    
    logCommand(args, sender)
    gsc.setdvar("g_gravity", "800")
    utils.tell(sender, languagehandler.language.gravity_reset)
    return true
        
end 
    
function commands.onResetSpeedCommand(sender, args)

    logCommand(sender, args)
    gsc.setdvar("g_speed", "190")
    utils.tell(sender, languagehandler.language.speed_reset)
    return true
    
end

function commands.onNextMapCommand(sender, args)
    
    local nextmap = gsc.getdvar("nextmap")
    utils.tell(sender, languagehandler.language.nextmap:gsub("{map}", nextmap))
    return true

end

function commands.onAdminsCommand(sender, args)

    local out = "Admins online: "
    for display in ipairs(settingshandler.settings.ranks) do
        for p in util.iterPlayers() do
            if settingshandler.settings.ranks[display].level == adminhandler.getAdminRank(p) and settingshandler.settings.ranks[display].display_on_admins == true then
                local withName = languagehandler.language.admins_online:gsub("{player}", p.name)
                local withRank = withName:gsub("{rank}", tostring(adminhandler.getAdminRank(p)))
                out = out .. withRank
            end 
        end 
    end 

    

    if out == "Admins online: " then
        utils.tell(sender, languagehandler.language.no_admins_online)
    else
        utils.tell(sender, out)        
    end
    return true

end


function commands.onGiveCommand(sender, args)

    if numArgs(args) == 2 then

        logCommand(sender, args)
        local weapon = getWeaponName(args[2])
        if weapon == nil then
            utils.iPrintLnBold(sender, languagehandler.language.weapon_invalid)
        else
            sender:giveWeapon(weapon)
            sender:switchToWeaponImmediate(weapon)
        end 

    elseif numArgs(args) == 3 then

        logCommand(sender, args)
        if string.sub(args[2], 1, 1) == "#" then

            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(tonumber(entity))
            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                local weapon = getWeaponName(args[3])
                if weapon == nil then
                    utils.iPrintLnBold(sender, languagehandler.language.weapon_invalid)
                else
                    player:giveWeapon(weapon)
                    player:switchToWeaponImmediate(weapon)
                end 
            end 

        else 

            local player = findPlayerByName(args[2])
            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                local weapon = getWeaponName(args[3])
                if weapon == nil then
                    utils.iPrintLnBold(sender, languagehandler.language.weapon_invalid)
                else
                    player:giveWeapon(weapon)
                    player:switchToWeaponImmediate(weapon)
                end 
            end 

        end 

    else 
        utils.tell(sender, languagehandler.language.give_usage)
    end 
    return true

end

function commands.onMapRestartCommand(sender, args)
    
    logCommand(sender, args)
    utils.chatPrint(languagehandler.language.map_restart:gsub("{player}", sender.name))
    callbacks.afterDelay.add(1000, function()
        gsc.map_restart(true)
    end)
    return true

end

function commands.onFastRestartCommand(sender, args)
    
    logCommand(sender, args)
    utils.chatPrint(languagehandler.language.map_restart:gsub("{player}", sender.name))
    callbacks.afterDelay.add(1000, function()
        gsc.map_restart(false)
    end)
    return true

end

function commands.onMapCommand(sender, args)

    if numArgs(args) == 2 then
        logCommand(sender, args)
        local map = getMapName(args)
        if map ~= nil or map ~= languagehandler.language.map_disabled then
            utils.chatPrint(languagehandler.language.map_changed:gsub("{map}", args[2]:lower()))
            callbacks.afterDelay.add(1000, function()
                util.executeCommand(string.format("map %s", map))
            end)
        else 
            utils.iPrintLnBold(sender, languagehandler.language.map_not_valid)
        end 
    else
        utils.tell(sender, "usage: map <mapname>")     
    end

    return true

end

function commands.onSuicideCommand(sender, args)

    sender.data.suicide = true
    return true

end

function commands.onKillCommand(sender, args)

    if numArgs(args) == 2 then
        
        if string.sub(args[2], 1 ,1) == "#" then

            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(tonumber(entity))
            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if checkPermissionToDo(sender, player) then
                    player.data.suicide = true 

                    local withRank = languagehandler.language.killed_by_admin:gsub("{rank}", utils.removeNumbers(adminhandler.getTitleForRank(getAdminRank(sender))))
                    utils.iPrintLnBold(sender, withRank:gsub("{name}", sender.name))
                else 
                    utils.tell(sender, languagehandler.language.low_level_kill)
                end 
            end 

        else 
            
            local player = findPlayerByName(args[2])
            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if checkPermissionToDo(sender, player) then
                    player.data.suicide = true 

                    local withRank = languagehandler.language.killed_by_admin:gsub("{rank}", utils.removeNumbers(adminhandler.getTitleForRank(adminhandler.getAdminRank(sender))))
                    utils.iPrintLnBold(sender, withRank:gsub("{name}", sender.name))
                else 
                    utils.tell(sender, languagehandler.language.low_level_kill)
                end 
            end

        end 

    else 
        utils.tell(sender, languagehandler.language.kill_usage)
    end 
    return true 

end 

function commands.onUfoCommand(sender, args)

    if numArgs(args) == 2 then

        logCommand(sender, args)
        if args[2]:lower() == "on" then
            sender:ufo(true)
            utils.tell(player, languagehandler.language.ufo_on)
        elseif args[2]:lower() == "off" then
            sender:ufo(false)
            utils.tell(player, languagehandler.language.ufo_off)
        end 

    elseif numArgs(args) == 3 then

        logCommand(sender, args)
        if string.sub(args[2], 1, 1) == "#" then

            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(tonumber(entity))
            if player == nil then
                utils.iPrintLnBold(languagehandler.language.user_not_found)
            else 
                if args[3]:lower() == "on" then
                    player:ufo(true)
                    utils.tell(player, languagehandler.language.ufo_on)
                elseif args[3]:lower() == "off" then
                    player:ufo(false)
                    utils.tell(player, languagehandler.language.ufo_off)
                end 
            end 

        else 

            local player = findPlayerByName(args[2])
            if player == nil then
                utils.iPrintLnBold(languagehandler.language.user_not_found)
            else 
                if args[3]:lower() == "on" then
                    player:ufo(true)
                    utils.tell(player, languagehandler.language.ufo_on)
                elseif args[3]:lower() == "off" then
                    player:ufo(false)
                    utils.tell(player, languagehandler.language.ufo_off)
                end 
            end
        end

    else 
        utils.tell(sender, languagehandler.language.ufo_usage)
    end 
    return true 

end 

function commands.onNoClipCommand(sender, args)

    if numArgs(args) == 2 then 

        logCommand(sender, args)
        if args[2]:lower() == "on" then
            sender:noclip(true)
            utils.tell(sender, languagehandler.language.noclip_on)
        elseif args[2]:lower() == "off" then
            sender:noclip(false)
            utils.tell(sender, languagehandler.language.noclip_off)
        end 

    elseif numArgs(args) == 3 then

        logCommand(sender, args)
        if string.sub(args[2], 1, 1) == "#" then

            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(tonumber(entity))

            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if args[3]:lower() == "on" then
                    sender:noclip(true)
                    utils.tell(sender, languagehandler.language.noclip_on)
                elseif args[3]:lower() == "off" then
                    sender:noclip(false)
                    utils.tell(sender, languagehandler.language.noclip_off)
                end 
            end 

        else 

            local player = findPlayerByName(args[2])
            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if args[3]:lower() == "on" then
                    sender:noclip(true)
                    utils.tell(sender, languagehandler.language.noclip_on)
                elseif args[3]:lower() == "off" then
                    sender:noclip(false)
                    utils.tell(sender, languagehandler.language.noclip_off)
                end
            end 

        end 

    else
        utils.tell(sender, languagehandler.language.noclip_usage)
    end 
    return true 
    
end 

function commands.onTeleportCommand(sender, args)

    if numArgs(args) == 4 then

        logCommand(sender, args)
        local target = sender:getorigin()
        sender:setorigin(Vector3.new(utils.toNumber(args[2]), utils.toNumber(args[3]), utils.toNumber(args[4])))
        local withX = languagehandler.language.teleported_x_y_z:gsub("{x}", args[2])
        local withY = withX:gsub("{y}", args[3])
        utils.tell(sender, withY:gsub("{z}", args[4]))

    elseif numArgs(args) == 2 then

        logCommand(sender, args)
        if string.sub(args[2], 1, 1) == "#" then

            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(tonumber(entity))

            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                local playerOrigin = player:getorigin()
                sender:setorigin(Vector3.new(playerOrigin.x, playerOrigin.y, playerOrigin.z))
                local withPlayer = languagehandler.language.teleported_to_player:gsub("{player}", sender.name)
                utils.chatPrint(withPlayer:gsub("{target}", player.name))
            end 

        else 

            local player = findPlayerByName(args[2])

            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                local playerOrigin = player:getorigin()
                sender:setorigin(Vector3.new(playerOrigin.x, playerOrigin.y, playerOrigin.z))
                local withPlayer = languagehandler.language.teleported_to_player:gsub("{player}", sender.name)
                utils.chatPrint(withPlayer:gsub("{target}", player.name))
            end 

        end 

    elseif numArgs(args) == 3 then

        logCommand(sender, args)
        if string.sub(args[2], 1, 1) == "#" and string.sub(args[3], 1, 1) == "#" then

            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(tonumber(entity))

            local entity1 = args[3]:gsub("#", "")
            local target = findPlayerByEntityNumber(tonumber(entity1))

            if player == nil or target == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                local targetOrigin = target:getorigin()
                player:setorigin(Vector3.new(targetOrigin.x, targetOrigin.y, targetOrigin.z))
                local withPlayer = languagehandler.language.teleported_to_player:gsub("{player}", player.name)
                utils.chatPrint(withPlayer:gsub("{target}", target.name))
            end 

        elseif string.sub(args[2], 1, 1) == "#" then

            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(tonumber(entity))

            local target = findPlayerByName(args[3])

            if player == nil or target == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                local targetOrigin = target:getorigin()
                player:setorigin(Vector3.new(targetOrigin.x, targetOrigin.y, targetOrigin.z))
                local withPlayer = languagehandler.language.teleported_to_player:gsub("{player}", player.name)
                utils.chatPrint(withPlayer:gsub("{target}", target.name))
            end 

        elseif string.sub(args[3], 1 , 1) == "#" then

            local player = findPlayerByName(args[2])

            local entity = args[3]:gsub("#", "")
            local target = findPlayerByEntityNumber(tonumber(entity))

            if player == nil or target == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                local targetOrigin = target:getorigin()
                player:setorigin(Vector3.new(targetOrigin.x, targetOrigin.y, targetOrigin.z))
                local withPlayer = languagehandler.language.teleported_to_player:gsub("{player}", player.name)
                utils.chatPrint(withPlayer:gsub("{target}", target.name))
            end 

        else 

            local player = findPlayerByName(args[2])

            local target = findPlayerByName(args[3])

            if player == nil or target == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                local targetOrigin = target:getorigin()
                player:setorigin(Vector3.new(targetOrigin.x, targetOrigin.y, targetOrigin.z))
                local withPlayer = languagehandler.language.teleported_to_player:gsub("{player}", player.name)
                utils.chatPrint(withPlayer:gsub("{target}", target.name))
            end

        end 

    else 
        utils.tell(sender, languagehandler.language.teleport_usage)
    end 
    return true 

end

function commands.onScreamCommand(sender, args)

    if numArgs(args) >= 2 then

        logCommand(sender, args)
        local message = concatArgs(args, 2)
        
        for i in pairs(colors) do
            utils.chatPrint("^0" .. message)
            callbacks.afterDelay.add(i * 1000, function()
                utils.chatPrint(string.format("%s%s", colors[i], message))
            end) 
        end 

    else 
        utils.tell(sender, languagehandler.language.scream_usage)
    end 
    return true 

end 

function commands.onWebsiteCommand(sender, args)
    
    if isEmpty(settingshandler.settings.website) then
        utils.tell(sender, languagehandler.language.website_empty)
    else 
        utils.tell(sender, languagehandler.language.website_message:gsub("{website}", settingshandler.settings.website))
    end 
    return true

end

function commands.onDiscordCommand(sender, args)

    if isEmpty(settingshandler.settings.discord) then
        utils.tell(sender, languagehandler.language.discord_empty)
    else 
        utils.tell(sender, languagehandler.language.discord_message:gsub("{discord}", settingshandler.settings.discord))
    end 
    return true

end 

function commands.onGiveMaxAmmoCommand(sender, args)

    sender:givemaxammo(sender:getcurrentweapon())
    return true

end

function commands.onKickCommand(sender, args)

    if numArgs(args) >= 3 then
        
        logCommand(sender, args)
        if string.sub(args[2], 1, 1) == "#" then

            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(tonumber(entity))

            local message = concatArgs(args, 3)

            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if checkPermissionToDo(sender, player) then
                    local withAdmin = languagehandler.language.kick_message:gsub("{admin}", sender.name)
                    local reason = withAdmin:gsub("{message}", message)

                    utils.kickPlayer(player, reason)

                    local withPlayer = languagehandler.language.kick_chat_print:gsub("{player}", player.name)
                    local withAdmin = withPlayer:gsub("{admin}", sender.name)
                    utils.chatPrint(withAdmin:gsub("{message}", message))
                else 
                    utils.tell(sender, languagehandler.language.low_level_kick)
                    utils.tell(player, languagehandler.language.low_level_kick_alert:gsub("{player}", sender.name))
                end 
            end 

        else 

            local player = findPlayerByName(args[2])

            local message = concatArgs(args, 3)
            
            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if checkPermissionToDo(sender, player) then
                    local withAdmin = languagehandler.language.kick_message:gsub("{admin}", sender.name)
                    local reason = withAdmin:gsub("{message}", message)
            
                    utils.kickPlayer(player, reason)

                    local withPlayer = languagehandler.language.kick_chat_print:gsub("{player}", player.name)
                    local withAdmin = withPlayer:gsub("{admin}", sender.name)
                    utils.chatPrint(withAdmin:gsub("{message}", message))
                else 
                    utils.tell(sender, languagehandler.language.low_level_kick)
                    utils.tell(player, languagehandler.language.low_level_kick_alert:gsub("{player}", sender.name))
                end 
            end

        end 

    else 
        utils.tell(sender, languagehandler.language.kick_usage)
    end 
    return true 

end

function commands.onClientsCommand(sender, args)

    local out = "Online Players: "
    for p in util.iterPlayers() do
        local withEntity = languagehandler.language.clients:gsub("{entity}", p:getentitynumber())
        local withName = withEntity:gsub("{player}", p.name)
        out = out .. withName
    end

    utils.tell(sender, out)
    return true
    
end

function commands.onBotCommand(sender, args)

    if numArgs(args) == 2 then
        logCommand(sender, args)
        util.executeCommand(string.format("bot %i", tonumber(args[2])))
    else
        util.executeCommand("bot")
    end
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

    if numArgs(args) >= 4 then
        logCommand(sender, args)

        if string.sub(args[2], 1, 1) == "#" then
            local entity = args[2]:gsub("#", "")
            local player = findPlayerByName(tonumber(entity))
            
            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if checkPermissionToDo(sender, player) then
                    local time = parseTime(args[3])
                    local message = concatArgs(args, 4)
                    local realTime = parseTimeToRealTime(time)

                    if time == nil then
                        utils.tell(sender, languagehandler.language.time_formats)
                    else 
                        local withAdmin = languagehandler.language.ban_message:gsub("{admin}", sender.name)
                        local withTime = withAdmin:gsub("{time}", realTime)
                        local withMessage = withTime:gsub("{message}", message)
                        local reason = withMessage:gsub("{website}", settingshandler.settings.website)

                        banhandler.banPlayer(sender, player, reason, time, message)
                    end 
                else 
                    utils.tell(sender, languagehandler.language.low_level_ban)
                    utils.tell(player, languagehandler.language.low_level_ban_alert:gsub("{player}", sender.name))
                end 
            end 
        else 
            local player = findPlayerByName(args[2])

            if player == nil then
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else 
                if checkPermissionToDo(sender, player) then
                    local time = parseTime(args[3])
                    local message = concatArgs(args, 4)
                    local realTime = parseTimeToRealTime(time)

                    if time == nil then
                        utils.tell(sender, languagehandler.language.time_formats)
                    else 
                        local withAdmin = languagehandler.language.ban_message:gsub("{admin}", sender.name)
                        local withTime = withAdmin:gsub("{time}", realTime)
                        local withMessage = withTime:gsub("{message}", message)
                        local reason = withMessage:gsub("{website}", settingshandler.settings.website)

                        banhandler.banPlayer(sender, player, reason, time, message)
                    end 
                else 
                    utils.tell(sender, languagehandler.language.low_level_ban)
                    utils.tell(player, languagehandler.language.low_level_ban_alert:gsub("{player}", sender.name))
                end 
            end 
        end 

    else 
        utils.tell(sender, languagehandler.language.ban_usage)
    end 
    return true 


end

function checkPermissionToDo(sender, player)

    if adminhandler.getAdminRank(sender) <= adminhandler.getAdminRank(player) then 
        return false 
    elseif adminhandler.getAdminRank(sender) >= adminhandler.getAdminRank(player) then 
        return true 
    end 

end 

function commands.onUnBanComamnd(sender, args)

    if numArgs(args) == 2 then

        logCommand(sender, args)
        local name = args[2]
        if banhandler.removeBan(sender, name) == nil then
            utils.iPrintLnBold(sender, languagehandler.language.name_ban_invalid)
        else 
            banhandler.removeBan(sender, name)
        end 

    else 
        utils.tell(sender, languagehandler.language.unban_usage)
    end 
    return true 

end 

function commands.onPermaBanCommand(sender, args)
    
    if numArgs(args) >= 3 then

        logCommand(sender, args)

        if string.sub(args[2], 1 ,1) == "#" then

            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(tonumber(entity))
            
            if player ~= nil then
                if checkPermissionToDo(sender, player) then

                    local message = concatArgs(args, 3)

                    local withAdmin = languagehandler.language.permanent_ban_message:gsub("{admin}", sender.name)
                    local withMessage = withAdmin:gsub("{message}", message)
                    local reason = withMessage:gsub("{website}", settingshandler.settings.website)

                    banhandler.banPlayer(sender, player, reason, nil, message)
                    
                else 
                    utils.tell(sender, languagehandler.language.low_level_ban)
                    utils.tell(player, languagehandler.language.low_level_ban_alert:gsub("{player}", sender.name))
                end 
            elseif player == nil then

                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)

            end 

        else 

            local player = findPlayerByName(args[2])

            if player ~= nil then
                if checkPermissionToDo(sender, player) then
                    
                    local message = concatArgs(args, 3)
                    
                    local withAdmin = languagehandler.language.permanent_ban_message:gsub("{admin}", sender.name)
                    local withMessage = withAdmin:gsub("{message}", message)
                    local reason = withMessage:gsub("{website}", settingshandler.settings.website)
                    
                    banhandler.banPlayer(sender, player, reason, nil, message)
                                        
                else 
                    utils.tell(sender, languagehandler.language.low_level_ban)
                    utils.tell(player, languagehandler.language.low_level_ban_alert:gsub("{player}", sender.name))
                end 

            elseif player == nil then

                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)

            end 

        end 

    else 

        utils.tell(sender, languagehandler.language.permaban_usage)

    end 
    return true 


end

function commands.onJumpHeightCommand(sender, args)
    
    if numArgs(args) == 2 then
        logCommand(sender, args)
        gsc.setdvar("jump_height", utils.toNumber(args[2]))
        if utils.toNumber(args[2]) >= 100 then
            gsc.setdvar("bg_fallDamageMaxHeight", "9999")
            gsc.setdvar("bg_fallDamageMinHeight", "9998")
        end 
    
        if utils.toNumber(args[2]) < 100 then
            gsc.setdvar("bg_fallDamageMaxHeight", "300")
            gsc.setdvar("bg_fallDamageMinHeight", "128")
        end 
            
    else
        utils.tell(sender, languagehandler.language.jumpheight_usage)
    end
    return true
    
end

function commands.onSpeedCommand(sender, args)
    
    if numArgs(args) == 2 then
        logCommand(sender, args)
        gsc.setdvar("g_speed", utils.toNumber(args[2]))
    else
        utils.tell(sender, languagehandler.language.speed_usage)
    end
    return true

end

function commands.onGravityCommand(sender, args)
    
    if numArgs(args) == 2 then
        logCommand(sender, args)
        gsc.setdvar("g_gravity", utils.toNumber(args[2]))
    else
        utils.tell(sender, languagehandler.language.gravity_usage)
    end
    return true

end

function commands.onSayCommand(sender, args)

    logCommand(sender, args)
    local out = settingshandler.settings.sayName .. "[^7" .. sender.name .. "^0]^7:"
    text = concatArgs(args, 2)
    util.chatPrint(out .. text)
    return true

end 

function commands.onMyAliasCommand(sender, args)
    
    if numArgs(args) >= 2 then
        logCommand(sender, args)
        local alias = concatArgs(args, 2)
        adminhandler.setAlias(sender, alias)
        local withPlayer = languagehandler.language.changed_alias:gsub("{player}", sender.name)
        utils.chatPrint(withPlayer:gsub("{alias}", alias))
    else
        utils.tell(sender, languagehandler.language.myalias_usage)
    end
    return true
    
end

function commands.onAliasCommand(sender, args)

    if numArgs(args) >= 3 then
        logCommand(sender, args)
        local alias = concatArgs(args, 3)
        if string.sub(args[2], 1, 1) == "#" then
            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(tonumber(entity))
            if player == nil then 
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else
                if checkPermissionToDo(sender, player) then
                    adminhandler.setAlias(player, alias)
                    local withPlayer = languagehandler.language.changed_alias:gsub("{player}", sender.name)
                    utils.chatPrint(withPlayer:gsub("{alias}", alias))
                else
                    utils.tell(sender, languagehandler.language.low_level_alias)
                end 
            end 
        else 
            local player = findPlayerByName(args[2])
            if player == nil then 
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else
                if checkPermissionToDo(sender, player) then
                    adminhandler.setAlias(player, alias)
                    local withPlayer = languagehandler.language.changed_alias:gsub("{player}", sender.name)
                    utils.chatPrint(withPlayer:gsub("{alias}", alias))
                else
                    utils.tell(sender, languagehandler.language.low_level_alias)
                end 
            end 
        end 
    else 
        utils.tell(sender, languagehandler.language.alias_usage)
    end 
    return true 

end

function commands.onPMCommand(sender, args)
    
    if numArgs(args) >= 3 then
        logCommand(sender, args)
        if string.sub(args[2], 1, 1) ~= "#" then
            local player = findPlayerByName(args[2])
            local message = concatArgs(args, 3)
            if player ~= nil then
                player:tell(string.format("%s%s: %s", languagehandler.language.pm, languagehandler.language.pm_name:gsub("{name}", sender.name), message))
                utils.tell(sender, languagehandler.language.pm_successful)
            else 
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            end 
        else 
            local entity = args[2]:gsub("#", '')
            local player = findPlayerByEntityNumber(tonumber(player))
            local message = concatArgs(args, 3)
            if player ~= nil then
                player:tell(string.format("%s%s: %s", languagehandler.language.pm, languagehandler.language.pm_name:gsub("{name}", sender.name), message))
                utils.tell(sender, languagehandler.language.pm_successful)
            else 
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            end 
        end  
    else 
        utils.tell(sender, languagehandler.language.pm_usage)
    end 
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

function commands.onRulesCommand(sender, args)

    if rules.getNumRules() > 0 then
        for r in ipairs(rules.getRules()) do
            callbacks.afterDelay.add(1000 * r, function()
                utils.tell(sender, rules.getRule(r))
            end)
        end
    else
        utils.tell(sender, languagehandler.language.no_rules)
    end

    return true

end

function commands.onFallDamageCommand(sender, args)
    
    if numArgs(args) == 2 then
        logCommand(sender, args)
        local maxDamage = gsc.getdvar("bg_fallDamageMaxHeight")
        local minDamage = gsc.getdvar("bg_fallDamageMinHeight")
    
        if maxDamage == "300" and minDamage == "128" then
            fallDamage = true
        else
            fallDamage = false
        end 
    
        if args[2] == "off" and fallDamage == true then
            gsc.setdvar("bg_fallDamageMaxHeight", "9999")
            gsc.setdvar("bg_fallDamageMinHeight", "9998")
            fallDamage = 0
            utils.tell(sender, languagehandler.language.falldamage_deactivated)
        elseif args[2] == "off" and fallDamage == false then
            utils.tell(sender, languagehandler.language.falldamage_already_deactivated)
        end
    
        if args[2] == "on" and fallDamage == false then
            gsc.setdvar("bg_fallDamageMaxHeight", "300")
            gsc.setdvar("bg_fallDamageMinHeight", "128")
            fallDamage = 1
            utils.tell(sender, languagehandler.language.falldamage_activated)
        elseif args[2] == "on" and fallDamage == true then
            utils.tell(sender, languagehandler.language.falldamage_already_activated)
        end 
    else
        utils.tell(sender, languagehandler.language.falldamage_usage) 
    end 
    return true
end

function commands.onDeleteAliasCommand(sender, args)

    if numArgs(args) == 2 then
        logCommand(sender, args)
        if string.sub(args[2], 1, 1) == "#" then
            local entity = args[2]:gsub("#", "")
            local player = findPlayerByEntityNumber(entity)

            if player == nil then 
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else
                if checkPermissionToDo(sender, player) then
                    local alias = adminhandler.getPlayerAlias(player)
                    if alias ~= player.name then
                        adminhandler.removeAlias(player)
                        utils.chatPrint(languagehandler.language.deleted_alias_successfully:gsub("{player}", player.name))
                    elseif alias == player.name then
                        utils.tell(sender, languagehandler.language.user_has_no_alias:gsub("{player}", player.name))
                    end 
                else 
                    utils.tell(sender, languagehandler.language.low_level_delalias)
                    utils.tell(player, languagehandler.language.low_level_delalias_alert:gsub("{player}", sender.name))
                end 
            end 
        else 
            local player = findPlayerByName(args[2])

            if player == nil then 
                utils.iPrintLnBold(sender, languagehandler.language.user_not_found)
            else
                if checkPermissionToDo(sender, player) then
                    local alias = adminhandler.getPlayerAlias(player)
                    if alias ~= player.name then
                        adminhandler.removeAlias(player)
                        utils.chatPrint(languagehandler.language.deleted_alias_successfully:gsub("{player}", player.name))
                    elseif alias == player.name then
                        utils.tell(sender, languagehandler.language.user_has_no_alias:gsub("{player}", player.name))
                    end 
                else 
                    utils.tell(sender, languagehandler.language.low_level_delalias)
                    utils.tell(player, languagehandler.language.low_level_delalias_alert:gsub("{player}", sender.name))
                end 
            end 
        end 
    else 
        utils.tell(sender, languagehandler.language.delalias_usage)
    end 
    return true 

end 


function commands.onSetCommand(sender, args)

    if numArgs(args) >= 3 then
        logCommand(sender, args)
        local dvar = args[2]
        local value = concatArgs(args, 3)

        gsc.setdvar(dvar, value)
    else
        utils.tell(sender, languagehandler.language.set_usage)
    end
    return true 
    
end


function commands.onDSRCommand(sender, args)

    if numArgs(args) == 2 then
        logCommand(sender, args)
        utils.createDSPLFile(args[2], gsc.getdvar("mapname"))
    elseif numArgs(args) == 3 then
        local map = getMapName(args[2])
        utils.createDSPLFile(map, args[3])
    else
        utils.tell(sender, languagehandler.language.dsr_usage)
    end

end

function commands.onDSPLCommand(sender, args)

    if numArgs(args) == 2 then
        logCommand(sender, args)
        utils.loadDSPLFile(args[2])
    else
        utils.tell(sender, languagehandler.language.dspl_usage)
    end

end

return commands