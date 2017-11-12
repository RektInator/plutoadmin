local utils = {}

local open = io.open

-- read the contents of a file
function utils.read_file(path)
    local file = open(path, "rb")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

-- writes a buffer to disk
function utils.write_file(path, data)
    local file = open(path, "wb")
    if not file then return end
    file:write(data)
    file:close()
end

function utils.kickPlayer(player, reason)
    util.executeCommand(string.format("kickclient %i %s", player:getentitynumber(), reason))    
end

function utils.getTableSize(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end

function utils.tellInternal(player, message)
    player:tell(
        string.format(
            "^0[^7%s^0]^7: %s", settingshandler.settings.sayName, message
        )
    )
end

function utils.tell(player, message)
    if string.len(message) <= 100 then
        utils.tellInternal(player, message)
    else

        -- get string from pos 100
        local splitMsg = string.sub( message, 85 )

        -- find the nearest space character
        local pos = string.find( message, " " )

        -- use apropiate split method
        if pos > 15 then
            utils.tell(player, string.sub( message, 1, 85 ) + "-")
            utils.tell(player, string.sub( message, 86 ))                            
        else
            utils.tell(player, string.sub( message, 1, 85 + pos ))
            utils.tell(player, string.sub( message, 86 + pos ))            
        end
    end
    
end

return utils
