local settingshandler = {  }

local settingsFile = utils.read_file("settings.json")

if string.len( settingsFile ) == 0 then
    util.print("Error: settings.json is empty!")
    return
end

-- obtains the admin rank for the current player
function settingshandler.getAdminRank(player)

    -- find the admin level for the player that issued the command
    for admin in ipairs(settingshandler.settings.admins) do
        if settingshandler.settings.admins[admin].xuid == player:getguid() then
            return settingshandler.settings.admins[admin].level
        end
    end

    -- default rank
    return 0

end

-- expose settings
settingshandler.settings = json.decode(settingsFile)

return settingshandler
