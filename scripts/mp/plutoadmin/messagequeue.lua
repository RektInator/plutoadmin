local messagequeue = {}

local messagesFile = utils.read_file("messages.json")

if messagesFile == nil or string.len( messagesFile ) == 0 then
    util.print("Error: messages.json is empty!")
else
    messagequeue.settings = json.decode(messagesFile)
    messagequeue.currentIndex = 0
end

function messagequeue.messageQueueOnInterval()

    -- reset index to 0 if we displayed all the messages in the queue already.
    if messagequeue.currentIndex > utils.getTableSize(messagequeue.settings.messages) then
        messagequeue.currentIndex = 1
    end

    -- send message to everyone
    -- utils.chatPrint(messagequeue.settings.messages[messagequeue.currentIndex].message)

    local index = 1
    for msg in ipairs(messagequeue.settings.messages) do
        if index == messagequeue.currentIndex then
            utils.chatPrint(messagequeue.settings.messages[msg].message)            
        end

        index = index + 1        
    end

    -- increment queue
    messagequeue.currentIndex = messagequeue.currentIndex + 1

    -- return false (don't cancel)
    return false

end

function messagequeue.init()
    if messagequeue.settings ~= nil then
        if messagequeue.settings.enableMessageQueue then
            callbacks.onInterval.add(messagequeue.settings.timeout * 1000, messagequeue.messageQueueOnInterval)        
        end
        if messagequeue.settings.admins_online_message == true then
            callbacks.onInterval.add(messagequeue.settings.admins_online_timeout * 1000, function()
                local out = "Admins online: "
                for display in ipairs(settingshandler.settings.ranks) do
                    for p in util.iterPlayers() do
                        if settingshandler.settings.ranks[display].level == adminhandler.getAdminRank(p) and settingshandler.settings.ranks[display].display_on_admins == true then
                            local withName = languagehandler.language.admins_online:gsub("{player}", p.name)
                            local withRank = withName:gsub("{rank}", tostring(adminhandler.getAdminRank(p)))
                            out = out .. withRank
                        end 
                    end 
                end 

                if out == "Admins online: " then
                    utils.chatPrint(languagehandler.language.no_admins_online)
                else 
                    utils.chatPrint(out)
                end 
            end)
        end 
    end 
end 
        

return messagequeue
