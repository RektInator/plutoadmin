local languagehandler = {}

local languageFile = utils.read_file("language.json")

if languageFile == nil or string.len(languageFile) == 0 then
    util.print("langauge.json is missing or empty")
else
    languagehandler.language = json.decode(languageFile)
end 

return languagehandler