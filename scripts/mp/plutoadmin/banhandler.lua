local banhandler = {  }

local bansFile = utils.read_file("bans.json")

if bansFile == nil or string.len( bansFile ) == 0 then
    util.print("Error: bans.json is empty!")
else
    -- expose bans
    banhandler.bans = json.decode(bansFile)
end

function banhandler.flushFile()
    -- create json file
    banJson = json.encode(banhandler.bans)
    
    -- save contents to disk
    utils.write_file("bans.json", banJson)
end

function banhandler.getPlayerReason(player)

    for ban in ipairs(banhandler.bans.bans) do
        if player:getguid() == banhandler.bans.bans[ban].xuid then 
            return banhandler.bans.bans[ban].banMessage
        end 
    end 

    return nil 

end 

function banhandler.banPlayer(admin, player, reason, time, message)

    banEntry = {}
    banEntry["name"] = player.name
    banEntry["reason"] = message
    banEntry["xuid"] = player:getguid()
    banEntry["admin"] = admin:getguid()
    banEntry["banMessage"] = reason

    if time ~= nil then
        banEntry["expires"] = os.time(os.date("!*t")) + time
    end

    -- init bans table if it does not exist yet
    if banhandler.bans.bans == nil then
        banhandler.bans.bans = {}
    end

    table.insert(banhandler.bans.bans, banEntry)

    -- flush file
    banhandler.flushFile()

    -- kick player
    utils.kickPlayer(player, reason)

    if time == nil then
        local withPlayer = languagehandler.language.permanent_ban_chat_print:gsub("{player}", player.name)
        local withAdmin = withPlayer:gsub("{admin}", admin.name)
        utils.chatPrint(withAdmin:gsub("{message}", message))
    else
        local withPlayer = languagehandler.language.temporary_ban_chat_print:gsub("{player}", player.name)
        local withAdmin = withPlayer:gsub("{admin}", admin.name)
        local withTime = withAdmin:gsub("{time}", parseTimeToRealTime(time))

        utils.chatPrint(withTime:gsub("{message}", message))
    end 

end

function banhandler.removeBan(sender, name)
    
    for ban in ipairs(banhandler.bans.bans) do
        if name:lower() == banhandler.bans.bans[ban].name:lower() then

            local unbanned = banhandler.bans.bans[ban].name
            table.remove(banhandler.bans.bans, ban)
            banhandler.flushFile()
            utils.chatPrint(languagehandler.language.player_unbanned:gsub("{player}", unbanned))

            return true 

        elseif string.match(banhandler.bans.bans[ban].name:lower(), name:lower()) then

            local unbanned = banhandler.bans.bans[ban].name
            table.remove(banhandler.bans.bans, ban)
            banhandler.flushFile()
            utils.chatPrint(languagehandler.language.player_unbanned:gsub("{player}", unbanned))

            return true 

        end 
            
    end

    return nil

end 

function banhandler.isBanExpired(ban, index)

    local curTime = os.time(os.date("!*t"))

    if ban.expires == nil then
        return false
    end

    if ban.expires - curTime > 0 then
        return false
    end

    -- remove ban entry
    table.remove(banhandler.bans.bans, index)

    -- flush bans file
    banhandler.flushFile()

    return true

end

function banhandler.isPlayerBanned(player)

    for ban in ipairs(banhandler.bans.bans) do
        if player:getguid() == banhandler.bans.bans[ban].xuid then
            if banhandler.isBanExpired(banhandler.bans.bans[ban], ban) then
                return false
            end

            return true
        end

        if player.name == banhandler.bans.bans[ban].name then
            if banhandler.isBanExpired(banhandler.bans.bans[ban], ban) then
                return false
            end

            return true
        end
    end

    return false

end

return banhandler
