--!Type(Module)

local dailyRewardEvent = Event.new("dailyRewardEvent")
local claimDailyRewardRequest = Event.new("claimDailyRewardRequest")
local resetRewardsRequest = Event.new("resetRewardsRequest")
local syncRewardTimeRequest = Event.new("syncRewardTimeRequest")

local playerinventoryManager = require("PlayerInventoryManager")
local playerTracker = require("PlayerTracker")
local itemMetaData = require("ItemMetaData")

RewardSchedule = TableValue.new("RewardSchedule", {
    day_1 = {item_name = "sadworm_bait", item_amount = 5},
    day_2 = {item_name = "corn_bait", item_amount = 10},
    day_3 = {item_name = "plastic_bait", item_amount = 5},
    day_4 = {item_name = "Tokens", item_amount = 1000},
    day_5 = {item_name = "grub_bait", item_amount = 10},
    day_6 = {item_name = "toast_bait", item_amount = 5},
    day_7 = {item_name = "Tokens", item_amount = 2200}
}
)

CLAIM_INTERVAL_MINUTES = 1440  -- Set the interval for claiming rewards (in minutes)

players = {}
------------ Player Tracking ------------
function TrackPlayers(game, characterCallback)
    scene.PlayerJoined:Connect(function(scene, player)
        players[player] = {
            player = player,
            playerLastClaimTime = IntValue.new("PlayerLastClaimTime" .. tostring(player.id), 0),
            playerTimeTillClaim = IntValue.new("PlayerTimeTillClaim" .. tostring(player.id), 0),
            playerClaimStreak = IntValue.new("PlayerClaimStreak" .. tostring(player.id), 1),
            playerCanClaim = BoolValue.new("PlayerCanClaim" .. tostring(player.id), true)
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

    -- Sync the reward time with the server
    syncRewardTimeRequest:FireServer(os.time())

    function OnCharacterInstantiate(playerinfo)
        local player = playerinfo.player
        local character = player.character

        --[[
        playerinfo.playerTimeTillClaim.Changed:Connect(function(newVal)
            print("Time till claim: " .. convertMinutesToHoursAndMinutesAndSeconds(newVal))
        end)
        -]]
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
            item_icon = itemMetaData.GetItemData(rewardSched["day_" .. i].item_name, rewardSched["day_" .. i].item_amount).ItemImage,
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
function GetCanClaim()
    return players[client.localPlayer].playerCanClaim.value
end

------------- SERVER -------------

function convertMinutesToHoursAndMinutesAndSeconds(timeRemaining)
    local minutesRemaining = math.floor(timeRemaining / 60)

    local hours = math.floor(minutesRemaining / 60)
    local minutes = minutesRemaining % 60
    local seconds = timeRemaining % 60
    return (hours .. " : " .. minutes .. " : " .. seconds)
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

local function SavePlayerClaimData(player : Player, lastClaimTimestamp : number | nil, streak : number | nil)
    if lastClaimTimestamp then Storage.SetPlayerValue(player, "LastClaimTimestamp", lastClaimTimestamp, function(err) if err == 0 then print(err) end end) end
    if streak then Storage.SetPlayerValue(player, "ClaimStreak", streak, function(err) if err ~= 0 then print(err) end end) end
end

local function LoadPlayerClaimData(player, callback)
    Storage.GetPlayerValue(player, "LastClaimTimestamp", function(lastClaimTimestamp)
        Storage.GetPlayerValue(player, "ClaimStreak", function(streak)
            if lastClaimTimestamp and streak then
                players[player].playerLastClaimTime.value = lastClaimTimestamp
                players[player].playerClaimStreak.value = streak
                if callback then callback() end
            else
                if callback then callback() end  -- Default values if no data is found
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
            return
        end

        local rewardKey = "day_" .. tostring(players[player].playerClaimStreak.value)
        local reward = RewardSchedule.value[rewardKey]

        -- Give the reward
        print("Claimed daily reward: " .. reward.item_name .. " x" .. tostring(reward.item_amount) .. "with streak " .. tostring(players[player].playerClaimStreak.value))
        GiveReward(player, reward)

        -- Determine the next streak day (1 to 7)
        players[player].playerClaimStreak.value = players[player].playerClaimStreak.value % 7 + 1

        -- Update and save player claim timestamp and streak
        SavePlayerClaimData(player, currentTime, players[player].playerClaimStreak.value)
        players[player].playerTimeTillClaim.value = CLAIM_INTERVAL_MINUTES * 60

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

    syncRewardTimeRequest:Connect(function(player, currentTime)
        LoadPlayerClaimData(player, function()
            local lastClaimTimestamp = players[player].playerLastClaimTime.value
            local elapsedTime = currentTime - lastClaimTimestamp
            local claimIntervalInSeconds = CLAIM_INTERVAL_MINUTES * 60

            local timeRemaining = claimIntervalInSeconds - elapsedTime
            players[player].playerTimeTillClaim.value = timeRemaining
            if elapsedTime < claimIntervalInSeconds then
                players[player].playerCanClaim.value = false
            end
        end)
    end)

    TrackPlayers(server, function(playerInfo)
        local player = playerInfo.player
        
        LoadPlayerClaimData(player)

        local claimTimer
        claimTimer = Timer.Every(1, function()
            if players[player] == nil then claimTimer:Stop(); claimTimer = nil; return end
            players[player].playerTimeTillClaim.value = players[player].playerTimeTillClaim.value - 1
            if players[player].playerTimeTillClaim.value > 0 then
                players[player].playerCanClaim.value = false
            else
                players[player].playerCanClaim.value = true
                if players[player].playerTimeTillClaim.value < -CLAIM_INTERVAL_MINUTES * 60 and players[player].playerClaimStreak.value > 1 then
                    players[player].playerClaimStreak.value = 1
                    SavePlayerClaimData(player, nil, 1)
                    print(player.name .. " Missed a day")
                end
            end
        end)
    end)
end