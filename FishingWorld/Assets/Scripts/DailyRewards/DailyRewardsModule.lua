--!Type(Module)

local dailyRewardEvent = Event.new("dailyRewardEvent")
local claimDailyRewardRequest = Event.new("claimDailyRewardRequest")
local resetRewardsRequest = Event.new("resetRewardsRequest")
local playerinventoryManager = require("PlayerInventoryManager")
local playerTracker = require("PlayerTracker")

local RewardSchedule = {
    day_1 = {itemID = "Tokens", itemAmount = 1},
    day_2 = {itemID = "Tokens", itemAmount = 2},
    day_3 = {itemID = "Tokens", itemAmount = 3},
    day_4 = {itemID = "Tokens", itemAmount = 4},
    day_5 = {itemID = "Tokens", itemAmount = 5},
    day_6 = {itemID = "Tokens", itemAmount = 6},
    day_7 = {itemID = "Tokens", itemAmount = 7}
}

local CLAIM_INTERVAL_MINUTES = 1440  -- Set the interval for claiming rewards (in minutes)

------------- CLIENT -------------

function self:ClientAwake()
    -- Listen for daily reward event
    dailyRewardEvent:Connect(function(reward)
        --print("You have claimed a reward: " .. reward.itemID .. " x" .. tostring(reward.itemAmount))
    end)
end

function RequestDailyReward()
    claimDailyRewardRequest:FireServer(os.time())
end

function ResetRewardsScheduleRequest()
    resetRewardsRequest:FireServer()
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
    if reward and reward.itemID then

        -- Check if it is a Token or an Item
        if reward.itemID == "Tokens" then
            playerTracker.IncrementTokensServer(player, reward.itemAmount)
        else
            playerinventoryManager.GivePlayerItem(player, reward.itemID, reward.itemAmount)
        end

        -- Notify the player
        print("Reward given: " .. reward.itemID .. " x" .. tostring(reward.itemAmount))
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
                callback(lastClaimTimestamp, streak)
            else
                callback(0, 1)  -- Default values if no data is found
            end
        end)
    end)
end

local function LoadRewardSchedule(callback)
    Storage.GetValue("RewardSchedule", function(schedule)
        if schedule then
            RewardSchedule = schedule
            print("Reward schedule loaded successfully.")
        else
            print("Failed to load reward schedule. Ensure it is set in storage.")
        end
        callback()
    end)
end

local function SaveRewardSchedule()
    Storage.SetValue("RewardSchedule", RewardSchedule)
    print("Reward schedule saved successfully.")
end

local function ClaimDailyReward(player, currentTime)

    LoadPlayerClaimData(player, function(lastClaimTimestamp, streak)
        local elapsedTime = currentTime - lastClaimTimestamp
        local claimIntervalInSeconds = CLAIM_INTERVAL_MINUTES * 60

        if elapsedTime < claimIntervalInSeconds then
            local timeRemaining = claimIntervalInSeconds - elapsedTime
            --Print how much time is remaining
            print("You must wait " .. convertMinutesToHoursAndMinutesAndSeconds(timeRemaining) .. " to claim the next reward.")
            return
        end

        -- Determine the next streak day (1 to 7)
        if elapsedTime >= claimIntervalInSeconds * 2 then
            streak = 1 -- Reset streak if more than 2 intervals have passed
        else
            streak = streak % 7 + 1
        end

        local rewardKey = "day_" .. tostring(streak)
        local reward = RewardSchedule[rewardKey]

        -- Give the reward
        print("Claimed daily reward: " .. reward.itemID .. " x" .. tostring(reward.itemAmount) .. "with streak " .. tostring(streak))
        GiveReward(player, reward)

        -- Update and save player claim timestamp and streak
        SavePlayerClaimData(player, currentTime, streak)

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
end