--!Type(Module)

--!SerializeField
local lockedImage : Texture = nil

local Speed = 1.75
local currentSpeed = 1.75
local jumpFactor = 7
local FishMod = 1
local FishDifficulty = 1

-- Initialize game state
local currentValue = 500
local active = false
local currentFish = ""
local baitTimer = nil

local linedUp = false

-- Fish movement
local fishMoveTimer = nil
local targeValue = 500
local fishvalue = 500

-- Timer Visuals
local progress = 0
local progressSpeed = 0.2

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
    print("CATCH!" .. currentFish)
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
        targeValue = targeValue + math.random(-(targeValue - 100), (900 - targeValue))
        targetValue = math.clamp(targeValue, 100, 900)
    end
end

function StartBaiting(biome : string)
    baitTimer = Timer.After(1, function() 
        local roll = math.random(1,10) + (math.random() * math.random(-1,1))
        if roll > 8 then 
            StartGame(biome) 
        else 
            StartBaiting(biome)
        end 
    end)
end

function InitiateFishing(point : Vector3, biome : string, bait : string)
    -- Get Fish Data
    currentFish = fishMetaData.GetRandomFish(biome, bait)
    local fishData = fishMetaData.GetFishData(currentFish)
    FishMod = fishData.FishMod
    FishDifficulty = fishMetaData.FishDifficulties[fishData.Rarity]

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
    uiManager.ShowMiniGame(currentFish)
    active = true

    -- Set the initial values
    progress = .4
    targeValue = math.random(100, 900)
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
    currentSpeed = -jumpFactor * FishMod
    if currentValue > 1000 then currentValue = 1000; end --Loose() end
end

function MovedToWater(point : Vector3, water : GameObject)
    -- Get the water Biome and Player Bait
    local _waterType = water:GetComponent(WaterType)
    local _biome = _waterType.GetBiome()
    local _lockedAlert = _waterType.GetLockedAlert()
    local _bait = playerTracker.GetBait()

    -- Check if the player has the correct pole for the biome
    local playerPoleID = playerTracker.GetPole()
    local poleData = itemMetaData.GetItemData(playerPoleID)
    if poleData ~= nil then
        local poleBiomes = poleData.ItemBiomes
        local hasCorrectPole = false

        for i, v in ipairs(poleBiomes) do
            if v == _biome or v == "Any" then hasCorrectPole = true end
        end

        if hasCorrectPole then
            -- Attempt to Start Fishing
            InitiateFishing(point, _biome, _bait)
        else
            -- Display a message to the player that they need a different pole
            uiManager.ShowFishPopup(_biome, 
            nil, 
            nil, 
            _lockedAlert, 
            lockedImage,
            nil,
            "Region Locked")

            audioManager.PlaySound("splashSound1", 1)
            audioManager.PlaySound("errorSound", 1)
        end
    else
        -- Display a message to the player that they need a different pole
        uiManager.ShowFishPopup(_biome, 
        nil, 
        nil, 
        _lockedAlert, 
        lockedImage,
        nil,
        "Region Locked")
        
        audioManager.PlaySound("splashSound1", 1)
        audioManager.PlaySound("errorSound", 1)
    end
end


function self:ClientUpdate()
    if active then

        -- Hook Slider
        decreaseValue()
        uiManager.FishingUI.UpdateHook(currentValue, linedUp)
        if currentSpeed < Speed * FishMod then
            currentSpeed = currentSpeed + Time.deltaTime * 50 * FishMod
            if currentSpeed > Speed * FishMod then currentSpeed = Speed * FishMod end
        end

        -- Fish Slider
        if math.abs(fishvalue - targeValue) > 10 then
            if fishvalue < targeValue then
                fishvalue = fishvalue + Time.deltaTime * 100 * (math.abs(targeValue - fishvalue) / 100)
            elseif fishvalue > targeValue then
                fishvalue = fishvalue - Time.deltaTime * 100 * (math.abs(targeValue - fishvalue) / 100)
            end
        end

        uiManager.FishingUI.UpdateFish(fishvalue)
        
        -- Calculate progress as a ratio of elapsedTime to duration
        linedUp = math.abs((currentValue-36) - fishvalue) < 200
        if linedUp then
            progress = progress + Time.deltaTime * progressSpeed / FishDifficulty
        else
            progress = progress - Time.deltaTime * progressSpeed * 1.5 / FishDifficulty
        end

        -- Win when the prgress is full
        if progress >= 1 then
            CatchFish()
        elseif progress <= 0 then
            Loose()
        end
        
        -- Update the progress bar visual (this is pseudocode)
        uiManager.FishingUI.UpdateProgressBar(progress)
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
            if playerTracker.GetPlayerItemCount(player, baitID) <= 1 then print("OUT OF BAIT"); playerTracker.SetBaitServer(player, "none") end
        end

        print("Start fishing! " .. fishID)
    end)

    -- When the player catches a fish, check if the fish their client claims to have caught is the one they were supposed to catch
    -- Then give them the fish via server in the InventoryManager
    catchFishReq:Connect(function(player, requestedFishID, worth)
        local expectedFish = activeFishIDs[player] == requestedFishID
        -- Give the player the fish if the client isnt lying
        if expectedFish then playerInventory.GivePlayerItem(player, requestedFishID, 1) end
        -- Give the player coins for the fish if the client isnt lying
        if expectedFish then playerTracker.IncrementTokensServer(player, worth) end

        activeFishIDs[player] = "" -- Remove the active fish ID for that player on Server
    end)

    -- When the player disconnects, remove the active fish ID for that player on Server
    server.PlayerDisconnected:Connect(function(player)
        activeFishIDs[player] = nil
    end)
end