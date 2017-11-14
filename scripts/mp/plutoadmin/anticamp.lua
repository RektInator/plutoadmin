local anticamp = {}

local anticampFile = utils.read_file("anticamp.json")

if anticampFile == nil or string.len( anticampFile ) == 0 then
    util.print("Error: anticamp.json is empty!")
else
    -- expose anticamp settings
    anticamp.settings = json.decode(anticampFile)
end

function anticamp.init()

end

return anticamp
