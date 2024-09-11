--!Type(Module)

local dailyRewardEvent = Event.new("dailyRewardEvent")
local claimDailyRewardRequest = Event.new("claimDailyRewardRequest")
local resetRewardsRequest = Event.new("resetRewardsRequest")

local playerinventoryManager = require("PlayerInventoryManager")
local playerTracker = require("PlayerTracker")
local itemMetaData = require("ItemMetaData")

RewardSchedule = TableValue.new("RewardSchedule", {
    day_1 = {item_name = "sadworm_bait", item_amount = 1},
    day_2 = {item_name = "sadworm_bait", item_amount = 2},
    day_3 = {item_name = "sadworm_bait", item_amount = 3},
    day_4 = {item_name = "sadworm_bait", item_amount = 4},
    day_5 = {item_name = "sadworm_bait", item_amount = 5},
    day_6 = {item_name = "sadworm_bait", item_amount = 6},
    day_7 = {item_name = "sadworm_bait", item_amount = 7}
}
)

local CLAIM_INTERVAL_MINUTES = .1  -- Set the interval for claiming rewards (in minutes)

players = {}
------------ Player Tracking ------------
function TrackPlayers(game, characterCallback)
    scene.PlayerJoined:Connect(function(scene, player)
        players[player] = {
            player = player,
            playerLastClaimTime = IntValue.new("PlayerLastClaimTime" .. tostring(player.id), 0),
            playerClaimStreak = IntValue.new("PlayerClaimStreak" .. tostring(player.id), 1)
        }

        player.CharacterChanged:Connect(function(player, character) 
            local playerinfo = players[player]
            if (character == nil) then
                return
            end 

            if characterCallback then
                characterCallback(playerinfo)
            end
        end)
    end)

    game.PlayerDisconnected:Connect(function(player)
        players[player] = nil
    end)
end

------------- CLIENT -------------

function self:ClientAwake()
    -- Listen for daily reward event
    dailyRewardEvent:Connect(function(reward)
        --print("You have claimed a reward: " .. reward.item_name .. " x" .. tostring(reward.item_amount))
    end)

    function OnCharacterInstantiate(playerinfo)
        local player = playerinfo.player
        local character = player.character
    end

    TrackPlayers(client, OnCharacterInstantiate)
end

function RequestDailyReward()
    claimDailyRewardRequest:FireServer(os.time())
end

function ResetRewardsScheduleRequest()
    resetRewardsRequest:FireServer()
end

function GetDailyRewardSchedule()
    local Dailies = { }

    local rewardSched = RewardSchedule.value
    -- AutoPop dailies
    for i = 1, 7 do
        local item = {
            item_name = itemMetaData.GetItemData(rewardSched["day_" .. i].item_name).Name,
            item_amount = rewardSched["day_" .. i].item_amount,
            item_icon = itemMetaData.GetItemData(rewardSched["day_" .. i].item_name).ItemImage,
            item_type = "item"
        }
        Dailies["day_" .. i] = {item}
    end

    return Dailies
end

function GetClaimStreak()
    return players[client.localPlayer].playerClaimStreak.value
end

function GetLastClaimTime()
    return players[client.localPlayer].playerLastClaimTime.value
end

------------- SERVER -------------

local function convertMinutesToHoursAndMinutesAndSeconds(timeRemaining)
    local minutesRemaining = math.floor(timeRemaining / 60)

    local hours = math.floor(minutesRemaining / 60)
    local minutes = minutesRemaining % 60
    local seconds = timeRemaining % 60
    return (hours .. " hrs and " .. minutes .. " minutes" .. " and " .. seconds .. " seconds")
end

local function GiveReward(player, reward)
    if reward and reward.item_name then

        -- Check if it is a Token or an Item
        if reward.item_name == "Tokens" then
            playerTracker.IncrementTokensServer(player, reward.item_amount)
        else
            playerinventoryManager.GivePlayerItem(player, reward.item_name, reward.item_amount)
        end

        -- Notify the player
        print("Reward given: " .. reward.item_name .. " x" .. tostring(reward.item_amount))
    end
end

local function SavePlayerClaimData(player, lastClaimTimestamp, streak)
    Storage.SetPlayerValue(player, "LastClaimTimestamp", lastClaimTimestamp)
    Storage.SetPlayerValue(player, "ClaimStreak", streak)
end

local function LoadPlayerClaimData(player, callback)
    Storage.GetPlayerValue(player, "LastClaimTimestamp", function(lastClaimTimestamp)
        Storage.GetPlayerValue(player, "ClaimStreak", function(streak)
            if lastClaimTimestamp and streak then
                players[player].playerLastClaimTime.value = lastClaimTimestamp
                players[player].playerClaimStreak.value = streak
                callback()
            else
                callback()  -- Default values if no data is found
            end
        end)
    end)
end

local function LoadRewardSchedule(callback)
    Storage.GetValue("RewardSchedule", function(schedule)
        if schedule then
            RewardSchedule.value = schedule
            print("Reward schedule loaded successfully.")
        else
            print("Failed to load reward schedule. Ensure it is set in storage.")
        end
        callback()
    end)
end

local function SaveRewardSchedule()
    Storage.SetValue("RewardSchedule", RewardSchedule.value)
    print("Reward schedule saved successfully.")
end

local function ClaimDailyReward(player, currentTime)

    LoadPlayerClaimData(player, function()

        local lastClaimTimestamp = players[player].playerLastClaimTime.value

        local elapsedTime = currentTime - lastClaimTimestamp
        local claimIntervalInSeconds = CLAIM_INTERVAL_MINUTES * 60

        if elapsedTime < claimIntervalInSeconds then
            local timeRemaining = claimIntervalInSeconds - elapsedTime
            --Print how much time is remaining
            print("You must wait " .. convertMinutesToHoursAndMinutesAndSeconds(timeRemaining) .. " to claim the next reward.")
            return
        end

        local rewardKey = "day_" .. tostring(players[player].playerClaimStreak.value)
        local reward = RewardSchedule.value[rewardKey]

        -- Give the reward
        print("Claimed daily reward: " .. reward.item_name .. " x" .. tostring(reward.item_amount) .. "with streak " .. tostring(players[player].playerClaimStreak.value))
        GiveReward(player, reward)

        -- Determine the next streak day (1 to 7)
        if elapsedTime >= claimIntervalInSeconds * 2 then
            --players[player].playerClaimStreak.value = 1 -- Reset streak if more than 2 intervals have passed
            players[player].playerClaimStreak.value = players[player].playerClaimStreak.value % 7 + 1
        else
            players[player].playerClaimStreak.value = players[player].playerClaimStreak.value % 7 + 1
        end

        -- Update and save player claim timestamp and streak
        SavePlayerClaimData(player, currentTime, players[player].playerClaimStreak.value)

        -- Notify the player
        dailyRewardEvent:FireClient(player, reward)
    end)
end

function self:ServerAwake()
    -- Load the reward schedule from storage before starting any operations
    LoadRewardSchedule(function()
        -- Listen for reward claim request from player
        claimDailyRewardRequest:Connect(function(player, playerTime)
            ClaimDailyReward(player, playerTime)
        end)
    end)
    -- Listen for reset rewards request
    resetRewardsRequest:Connect(function(player)
        SaveRewardSchedule()
    end)

    TrackPlayers(server, function(playerInfo)
        local player = playerInfo.player
        LoadPlayerClaimData(player, function()
        end)
    end)
end