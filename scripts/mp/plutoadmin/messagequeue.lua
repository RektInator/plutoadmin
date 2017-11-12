local messagequeue = {}

local messagesFile = utils.read_file("messages.json")

if messagesFile == nil or string.len( messagesFile ) == 0 then
    util.print("Error: messages.json is empty!")
    return
end

messagequeue.settings = json.decode(messagesFile)
messagequeue.currentIndex = 0

function messageQueueOnInterval()
    for p in util.iterPlayers() do
        utils.tell(p, messagequeue.settings.messages[messagequeue.currentIndex].message)
    end

    messagequeue.currentIndex = messagequeue.currentIndex + 1
    return false
end

function messagequeue.init()
    if messagequeue.settings.enableMessageQueue then
        -- callbacks.onInterval.add(messagequeue.settings.timeout, messageQueueOnInterval)        
    end
end

return messagequeue
