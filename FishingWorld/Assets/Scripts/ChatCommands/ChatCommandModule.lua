--!Type(Module)

local DailyRewards = require("DailyRewardsModule")

local commands = {}
local info = nil

helpCallback = function()
    Chat:DisplayTextMessage(info, client.localPlayer, "Available commands:")
    local printcommands = ""
    for command, _ in pairs(commands) do
        printcommands = printcommands .. "\n"
        printcommands = printcommands .. "-" .. command
    end
    Timer.After(0.5, function() Chat:DisplayTextMessage(info, client.localPlayer, printcommands) end)
end

commands = {
    help = helpCallback,
    claimdaily = DailyRewards.RequestDailyReward,
    resetschedule = DailyRewards.ResetRewardsScheduleRequest
}

function self:ClientAwake()
    Chat.TextMessageReceivedHandler:Connect(function(channelInfo, player, message)
        info = channelInfo
        local isCommand = string.sub(message, 1, 1) == "/"
        if isCommand then
            if player == client.localPlayer then -- Check if this is the client who sent the message
                Chat:DisplayTextMessage(channelInfo, player, message)
                local command = string.sub(message, 2)
                command = string.lower(command)
                local commandExists = commands[command] ~= nil
                if commandExists then
                    commands[command]()
                else
                    Chat:DisplayTextMessage(channelInfo, player, "Command not found. Type /help to see available commands.")
                end
            end
        else
            Chat:DisplayTextMessage(channelInfo, player, message)
        end
    end)
end