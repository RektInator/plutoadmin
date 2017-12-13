local adminhandler = {  }

local adminsFile = utils.read_file("admins.json")

if adminsFile == nil or string.len( adminsFile ) == 0 then
    util.print("Error: admins.json is empty!")
else
    -- expose bans
    adminhandler.admins = json.decode(adminsFile)
end

function adminhandler.flushFile()
    -- create json file
    adminJson = json.encode(adminhandler.admins)

    -- save contents to disk
    utils.write_file("admins.json", adminJson)
end

function adminhandler.getRankByName(rankName)
    
    for rank in ipairs(settingshandler.settings.ranks) do
        if settingshandler.settings.ranks[rank].name:lower() == rankName:lower() then
            return settingshandler.settings.ranks[rank].level
        end
    end
    
    return nil
    
end

function adminhandler.getRankByLevel(rankLevel)

    for rank in ipairs(settingshandler.settings.ranks) do
        if settingshandler.settings.ranks[rank].level == rankLevel then
            return settingshandler.settings.ranks[rank].level
        end 
    end 

    return nil 

end 

function adminhandler.hasAdmins()
    if adminhandler.admins.admins ~= nil then
        if utils.getTableSize(adminhandler.admins.admins) > 0 then
            return true
        end
    end

    return false
end

function adminhandler.getRankNameByLevel(level)
    
    for rank in ipairs(settingshandler.settings.ranks) do
        if settingshandler.settings.ranks[rank].level == level then
            return settingshandler.settings.ranks[rank].name
        end
    end

    return nil

end

function adminhandler.getTitleForRank(level)

    for rank in ipairs(settingshandler.settings.ranks) do
        if settingshandler.settings.ranks[rank].level == level then
            return settingshandler.settings.ranks[rank].title
        end
    end

    

end

function adminhandler.getPlayerAlias(player)

    -- search for the admin and find the alias name
    for admin in ipairs(adminhandler.admins.admins) do
        if adminhandler.admins.admins[admin].xuid == player:getguid() then
            if adminhandler.admins.admins[admin].alias ~= nil then
                return adminhandler.admins.admins[admin].alias
            end
        end
    end

    -- return player name if no alias is set
    return " " .. player.name

end

function adminhandler.setAlias(player, alias)

    -- search for the admin and set the alias
    for admin in ipairs(adminhandler.admins.admins) do
        if adminhandler.admins.admins[admin].xuid == player:getguid() then
            adminhandler.admins.admins[admin].alias = alias
        end 
    end

    -- flush json file
    adminhandler.flushFile()

end

function adminhandler.removeAdmin(player)

    local removeThisEntry = nil
    for admin in ipairs(adminhandler.admins.admins) do
        if adminhandler.admins.admins[admin].xuid == player:getguid() then
            removeThisEntry = admin
        end
    end

    if removeThisEntry ~= nil then
        table.remove(adminhandler.admins.admins, removeThisEntry)
    end

end

function adminhandler.setRank(sender, player, rank)

    if type(rank) == "string" then
        rank = adminhandler.getRankByName(rank)
    elseif type(rank) == "number" then 
        rank = adminhandler.getRankByLevel(rank)
    end 

    if rank == nil then
        utils.iPrintLnBold(sender, languagehandler.language.invalid_rank)
        return
    end

    -- init table if it doesn't exist yet
    if adminhandler.admins.admins == nil then
        adminhandler.admins.admins = {}
    end

    adminhandler.removeAdmin(player)

    -- only create an admin entry if the rank is higher than 0 (player)
    if rank > 0 then
        adminEntry = {}
        adminEntry["xuid"] = player:getguid()
        adminEntry["level"] = rank
        adminEntry["name"] = player.name
    
        -- insert admin entry
        table.insert(adminhandler.admins.admins, adminEntry)
    
        -- flush file
        adminhandler.flushFile()
    end
    if rank > 0 then
        -- tell player about their new rank
        local withName = languagehandler.language.chat_alert_rank:gsub("{player}", player.name)
        utils.chatPrint(withName:gsub("{rank}", utils.removeNumbers(adminhandler.getTitleForRank(rank))))
        utils.iPrintLnBold(player, languagehandler.language.alert_promoted_player:gsub("{rank}", utils.removeNumbers(adminhandler.getTitleForRank(rank))))
    elseif rank == 0 then
        adminhandler.removeAdmin(player)
        utils.chatPrint(languagehandler.language.chat_alert_demote:gsub("{player}", player.name))
        utils.iPrintLnBold(player, languagehandler.language.demoted_to_player)
        adminhandler.flushFile()
    end 

end

function adminhandler.removeAlias(player)
    
    local alias = nil
    local rank = nil
    for admin in ipairs(adminhandler.admins.admins) do 
        if adminhandler.admins.admins[admin].xuid == player:getguid() then
            alias = adminhandler.admins.admins[admin].alias
            rank = adminhandler.admins.admins[admin].level
        end 
        if alias ~= nil and rank ~= nil then
            table.remove(adminhandler.admins.admins, admin)
            adminEntry = {}
            adminEntry["xuid"] = player:getguid()
            adminEntry["level"] = rank
            adminEntry["name"] = player.name
                
            table.insert(adminhandler.admins.admins, adminEntry)

            adminhandler.flushFile()
        end 
    end 
        
end



-- obtains the admin rank for the current player
function adminhandler.getAdminRank(player)
    
    -- find the admin level for the player that issued the command
    for admin in ipairs(adminhandler.admins.admins) do
        if adminhandler.admins.admins[admin].xuid == player:getguid() then
            return adminhandler.admins.admins[admin].level
        end
    end

    -- default rank
    return 0

end

function adminhandler.getAdminTitle(player)

    for admin in ipairs(adminhandler.admins.admins) do
        if adminhandler.admins.admins[admin].xuid == player:getguid() then
            return adminhandler.admins.admins[admin].title
        end 
    end 

    return 0 

end 

function adminhandler.getRankForCommand(command)

    for cmd in ipairs(settingshandler.settings.commands) do 
        if settingshandler.settings.commands[cmd].command:lower() == command:lower() then
           return settingshandler.settings.commands[cmd].level
        end 
    end

    return nil

end

return adminhandler
