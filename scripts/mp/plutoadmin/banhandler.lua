local banhandler = {  }

local bansFile = utils.read_file("bans.json")

if bansFile == nil or string.len( bansFile ) == 0 then
    util.print("Error: bans.json is empty!")
    return
end

-- expose bans
banhandler.bans = json.decode(bansFile)

function banhandler.banPlayer(admin, player, reason)

    banEntry = {}
    banEntry["name"] = player.name
    banEntry["reason"] = reason
    banEntry["xuid"] = player:getguid()
    banEntry["admin"] = admin:getguid()

    table.insert(banhandler.bans.bans, banEntry)

    -- create json file
    banJson = json.encode(banhandler.bans)

    -- save contents to disk
    utils.write_file("bans.json", banJson)

    -- kick player
    utils.kickPlayer(player, reason)

end

function banhandler.isPlayerBanned(player)

    for ban in ipairs(banhandler.bans.bans) do
        if player:getguid() == banhandler.bans.bans[ban].xuid then
            return true
        end

        if player.name == banhandler.bans.bans[ban].name then
            return true
        end
    end

    return false

end

return banhandler
