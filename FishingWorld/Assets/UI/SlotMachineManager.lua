--!Type(Module)

playerSlotRequest = Event.new("PlayerSlotRequest")
playerSlotResponse = Event.new("PlayerSlotResponse")

rewardAnimationEvent = Event.new("RewardAnimationEvent")

local playerTracker = require("PlayerTracker")
local inventoryManager = require("PlayerInventoryManager")
local uiManager = require("UIManager")

-------- CLIENT --------

function RequestSlot()
    playerSlotRequest:FireServer()
end

-------- SERVER --------

function CalculateSlotResult()
    -- 1: Small Chips (Under Play Cost) - 60%, 2: Power-up - 20%, 3: Large Chips - 10%, 0: Nothing - 8%, 4: Gold - 2%
    -- Define the probabilities and rewards
    local rewards = {
        {rewardID = nil, probability = 0.60}, -- Nothing
        {rewardID = 1, probability = 0.23}, -- Small Chips (Under Play Cost) +75
        {rewardID = 2, probability = 0.10}, -- Power-up +1 free daub
        {rewardID = 3, probability = 0.05}, -- Large Chips +500
        {rewardID = 4, probability = 0.02}  -- +1 Gold
    }

    -- Seed the random number generator (only needs to be done once per execution)
    math.randomseed(os.time())

    -- Generate a random number between 0 and 1
    local roll = math.random()

    -- Iterate through rewards and determine the result
    local cumulativeProbability = 0
    for _, reward in ipairs(rewards) do
        cumulativeProbability = cumulativeProbability + reward.probability
        if roll <= cumulativeProbability then
            return reward.rewardID
        end
    end

    -- Fallback (should never happen due to probabilities summing to 1)
    return 0
end

function self:ServerStart()
    playerSlotRequest:Connect(function(player)

        if playerTracker.players[player].Tokens.value < 100 then
            return
        end

        inventoryManager.TakePlayerItem(player, "Tokens", 100)

        local playerReward = CalculateSlotResult()
        playerSlotResponse:FireClient(player, playerReward)
        Timer.After(2.25, function()
            -- Play Reward Animations
            if playerReward then
                rewardAnimationEvent:FireClient(player, playerReward)
                Timer.After(1, function()
                    if playerReward == 1 then
                        inventoryManager.GivePlayerItem(player, "Tokens", 75)
                    elseif playerReward == 2 then
                        inventoryManager.GivePlayerItem(player, "free_daub", 1)
                    elseif playerReward == 3 then
                        inventoryManager.GivePlayerItem(player, "Tokens", 500)
                    elseif playerReward == 4 then
                        -- landed on gold
                    end
                end)
            end
        end)
    end)
end