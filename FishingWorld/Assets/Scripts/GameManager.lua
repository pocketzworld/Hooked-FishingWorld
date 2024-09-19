--!Type(Module)

--!SerializeField
local lockedImage : Texture = nil

local Speed = 1.75
local currentSpeed = 1.75
local jumpFactor = 7
local HookSensitivity = 1
local ReelResistance = 1
local StrengthResistance = 1

-- Initialize game state
local currentValue = 500
local active = false
local currentFish = ""
local baitTimer = nil

local linedUp = false
local playerStrength = 1
local HookWidth = 72
local playerHookSpeed = 1

-- Fish movement
local fishMoveTimer = nil
local targeValue = 500
local fishvalue = 500

-- Timer Visuals
local progress = 0
local progressSpeed = 0.2
local ReelSpeed = 1

local startFishingReq = Event.new("StartFishingRequest")
local catchFishReq = Event.new("CatchFishRequest")
local looseFishReq = Event.new("LooseFishRequest")


local uiManager = require("UIManager")
local playerController = require("FishingCharacterController")
local audioManager = require("AudioManager")
local playerTracker = require("PlayerTracker")
local playerInventory = require("PlayerInventoryManager")
local itemMetaData = require("ItemMetaData")
local fishMetaData = require("FishMetaData")
local utility = require("Utils")

-- Function to calculate Tap Meter Width Modifier based on the player's strength
function GetHookBarWidth(strength)
    print("Strength: " .. tostring(strength) .. " Strength Resistance: " .. tostring(StrengthResistance))
    print("Hook Width: " .. tostring((72 * ((100 + 6.25 * (strength - 1))/100)) / StrengthResistance))
    return (72 * ((100 + 6.25 * (strength - 1))/100)) / StrengthResistance
end

-- Function to handle catching the fish
function CatchFish()
    uiManager.HideMiniGame()
    playerController.HideFishingIndicator()
    active = false
    playerTracker.FishingStateRequest(false, Vector3.zero)

    if fishMoveTimer ~= nil then 
        fishMoveTimer:Stop()
        fishMoveTimer = nil
    end

    if baitTimer ~= nil then 
        baitTimer:Stop()
        baitTimer = nil
    end

    -- Fire the event to the server to give the player the fish
    --print("CATCH!" .. currentFish)
    catchFishReq:FireServer(currentFish, fishMetaData.GetFishData(currentFish).Worth)

    Timer.After(1, function() playerController.options.enabled = true end)
end

-- Function to handle game over
function Loose()
    uiManager.HideMiniGame()
    playerController.HideFishingIndicator()
    active = false
    currentValue = 500
    playerTracker.FishingStateRequest(false, Vector3.zero)

    Timer.After(1, function() playerController.options.enabled = true end)

    if fishMoveTimer ~= nil then 
        fishMoveTimer:Stop()
        fishMoveTimer = nil
    end

    if baitTimer ~= nil then 
        baitTimer:Stop()
        baitTimer = nil
    end

    looseFishReq:FireServer()

end

function CancelBait()
    if baitTimer ~= nil then 
        Loose()
    end
end
-- Function to move the fish
function MoveFish()
    local roll = math.random(1,10)
    if roll > 4 then
        targeValue = targeValue + math.random(-(targeValue - 10), (300 - targeValue))
        targetValue = math.clamp(targeValue, 10, 350)
    end
end

function StartBaiting(biome : string)
    local BaitTime = 1.5 * playerHookSpeed

    --print("Baiting for " .. tostring(BaitTime) .. " seconds")
    baitTimer = Timer.After(BaitTime, function() 
        local roll = math.random(1,100)
        if roll > 80 then
            StartGame(biome) 
        else 
            StartBaiting(biome)
        end 
    end)
end

function InitiateFishing(point : Vector3, biome : string, bait : string, rarity : string)
    -- Get Fish Data
    currentFish = fishMetaData.GetRandomFish(biome, bait, rarity)
    local fishData = fishMetaData.GetFishData(currentFish)
    HookSensitivity = fishData.HookSensitivity
    ReelResistance = fishMetaData.GetFishReelResistance(currentFish)
    StrengthResistance = fishMetaData.GetFishStrengthResistance(currentFish)

    -- Get Player Stats --
    -- Fetch the players strength
    playerStrength = playerTracker.GetPlayerStrength()
    HookWidth = GetHookBarWidth(playerStrength)
    -- Fetch the players reel speed
    ReelSpeed = playerTracker.GetPlayerReelSpeed()
    -- Fetch the players hook speed
    playerHookSpeed = playerTracker.GetPlayerHookSpeed()

    playerController.ShowFishingIndicator(point)
    audioManager.PlaySound("splashSound1", 1)
    playerTracker.FishingStateRequest(true, point)

    -- Fire the event to the server to start the fishing state on the other clients
    startFishingReq:FireServer(currentFish, bait)
    StartBaiting(biome)

end

function StartGame(biome : string)
    -- Stop the bait timer
    if baitTimer ~= nil then 
        baitTimer:Stop()
        baitTimer = nil
    end

    -- play the alert sound
    audioManager.PlaySound("splashSound1", 1)

    -- Set the player to a fishing state
    playerController.options.enabled = false

    -- Show the MiniGame UI
    uiManager.ShowMiniGame(currentFish, HookWidth)
    active = true

    -- Set the initial values
    progress = .4
    targeValue = math.random(50, 300)
    currentValue = targeValue
    fishMoveTimer = Timer.Every(1, MoveFish)

    elapsedTimeProgressBar = 0
    increaseValueOnPress()
    --utility.PrintTable(fishMetaData.GetFishData(fish))
end

-- Function to decrease the value towards 0
function decreaseValue()
    currentValue = currentValue - Time.deltaTime * currentSpeed * 100
    if currentValue < 0 then currentValue = 0; end --Loose() end
end

-- Function to increase the value based on its distance from 0.5
function increaseValueOnPress()
    currentSpeed = -jumpFactor * HookSensitivity
    if currentValue > 350 then currentValue = 350; end --Loose() end
end

function MovedToWater(point : Vector3, water : GameObject)
    if Vector3.Distance(point, client.localPlayer.character.transform.position) > 12 then return end
    -- Get the water Biome and Player Bait
    local _waterType = water:GetComponent(WaterType)
    local _rarity = _waterType.GetRarity()
    local _biome = _waterType.GetBiome()
    local _lockedAlert = _waterType.GetLockedAlert()
    local _bait = playerTracker.GetBait()

    -- Check if the player has the correct pole for the biome
    -- Attempt to Start Fishing
    InitiateFishing(point, _biome, _bait, _rarity)
end

function proximity_to_middle(percentage)
    -- Clamp percentage between 0 and 100
    if percentage < 0 then percentage = 0 end
    if percentage > 100 then percentage = 100 end
    
    -- Scale percentage to be between 1 at 0, 0 at 50, and -1 at 100
    return 1 - (percentage / 50)
end

function self:ClientUpdate()
    if active then

        -- Hook Slider
        decreaseValue()
        uiManager.FishingUIScript.UpdateHook(currentValue, linedUp)
        if currentSpeed < Speed * HookSensitivity then
            currentSpeed = currentSpeed + Time.deltaTime * 50 * HookSensitivity
            if currentSpeed > Speed * HookSensitivity then currentSpeed = Speed * HookSensitivity end
        end

        -- Fish Slider
        if math.abs(fishvalue - targeValue) > 1 then
            if fishvalue < targeValue then
                fishvalue = fishvalue + Time.deltaTime * 100 * (math.abs(targeValue - fishvalue) / 100)
            elseif fishvalue > targeValue then
                fishvalue = fishvalue - Time.deltaTime * 100 * (math.abs(targeValue - fishvalue) / 100)
            end
        end

        uiManager.FishingUIScript.UpdateFish(fishvalue)
        
        -- Increase progress if the sliders are lined up
        local offsetHookValue = currentValue + (HookWidth * proximity_to_middle((currentValue/350)*100))/2
        linedUp = math.abs(offsetHookValue - fishvalue) < ((HookWidth/2)+18) -- half the wook slider width + half the fish slider width regestering any overlap
    
        if linedUp then
            progress = progress + Time.deltaTime * progressSpeed * ReelSpeed / ReelResistance
        else
            progress = progress - Time.deltaTime * progressSpeed * .8
        end

        
        -- Win when the prgress is full
        if progress >= 1 then
            CatchFish()
        elseif progress <= 0 then
            progress = 0
            Loose()
        end
        
        
        -- Update the progress bar visual (this is pseudocode)
        uiManager.FishingUIScript.UpdateProgressBar(progress)
    end
end

----------------- Server -----------------
local activeFishIDs = {}
function self:ServerAwake()
    -- when they lose the fish, remove the active fish ID for that player on Server
    looseFishReq:Connect(function(player)
        activeFishIDs[player] = ""
    end)

    -- When the player starts fishing, set the active fish ID for that player on Server
    startFishingReq:Connect(function(player, fishID, baitID)
        activeFishIDs[player] = fishID

        -- Check if baitID is bait
        if itemMetaData.bait_metadata[baitID] then 
            playerInventory.TakePlayerItem(player, baitID, 1)
            -- Check if the players bait is 0
            if playerTracker.GetPlayerItemCount(player, baitID) <= 0 then playerTracker.SetBaitServer(player, "none") end
        end

        --print("Start fishing! " .. fishID)
    end)

    -- When the player catches a fish, check if the fish their client claims to have caught is the one they were supposed to catch
    -- Then give them the fish via server in the InventoryManager
    catchFishReq:Connect(function(player, requestedFishID, worth)
        local expectedFish = activeFishIDs[player] == requestedFishID
        -- Give the player the fish if the client isnt lying
        if expectedFish and worth == fishMetaData.GetFishData(requestedFishID).Worth then 
            playerInventory.GivePlayerItem(player, requestedFishID, 1) 
            playerTracker.IncrementTokensServer(player, fishMetaData.GetFishData(requestedFishID).Worth)
            playerTracker.AwardXP(player, fishMetaData.GetFishExperianceValue(requestedFishID) * playerTracker.GetPlayerXPModifier(player))
        end


        activeFishIDs[player] = "" -- Remove the active fish ID for that player on Server
    end)

    -- When the player disconnects, remove the active fish ID for that player on Server
    server.PlayerDisconnected:Connect(function(player)
        activeFishIDs[player] = nil
    end)
end