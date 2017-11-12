json = require "json"

-- reading files
local open = io.open
local function read_file(path)
    local file = open(path, "rb")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

local bansFile =        read_file("bans.json")
local settingsFile =    read_file("settings.json")

if bansFile ~= nil and settingsFile ~= nil then

    local bans = json.decode(bansFile)
    local settings = json.decode(settingsFile)

else

    util.print("Could not load plutoadmin, bans.json or settings.json is missing!")

end
