local rules = {}

local rulesFile = utils.read_file("rules.json")

if rulesFile == nil or string.len( rulesFile ) == 0 then
    util.print("Error: rules.json is empty!")
else
    -- expose rules
    rules.settings = json.decode(rulesFile)
end

function rules.getNumRules()
    if rules.settings.rules ~= nil then
        return utils.getTableSize(rules.settings.rules)        
    end

    return 0
end

function rules.getRules()
    return rules.settings.rules
end

function rules.getRule(index)
    if rules.settings.rules ~= nil then
        return rules.settings.rules[index].rule        
    end

    return nil
end

return rules
