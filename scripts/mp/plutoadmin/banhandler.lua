local banhandler = {  }

local bansFile = utils.read_file("bans.json")

if bansFile == nil or string.len( bansFile ) == 0 then
    util.print("Error: bans.json is empty!")
    return
end

-- expose bans
banhandler.bans = json.decode(bansFile)

function banhandler.banPlayer(admin, player, reason, time)

    banEntry = {}
    banEntry["name"] = player.name
    banEntry["reason"] = reason
    banEntry["xuid"] = player:getguid()
    banEntry["admin"] = admin:getguid()

    if time ~= nil then
        banEntry["expires"] = os.time(os.date("!*t")) + time
    end

    table.insert(banhandler.bans.bans, banEntry)

    -- create json file
    banJson = json.encode(banhandler.bans)

    -- save contents to disk
    utils.write_file("bans.json", banJson)

    -- kick player
    utils.kickPlayer(player, reason)

end

function banhandler.isBanExpired(ban)

    local curTime = os.time(os.date("!*t"))

    if ban.expires == nil then
        return false
    end

    if ban.expires - curTime > 0 then
        return false
    end

    return true

end

function banhandler.isPlayerBanned(player)

    for ban in ipairs(banhandler.bans.bans) do
        if player:getguid() == banhandler.bans.bans[ban].xuid and banhandler.isBanExpired(banhandler.bans.bans[ban]) == false then
            return true
        end

        if player.name == banhandler.bans.bans[ban].name and banhandler.isBanExpired(banhandler.bans.bans[ban]) == false then
            return true
        end
    end

    return false

end

return banhandler
