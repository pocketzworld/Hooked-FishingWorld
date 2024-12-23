--!Type(Module)

local clientJoinRequets = Event.new("ClientJoinRequest")

local ServerLeaderboard = TableValue.new("ServerLeaderboard")
local playMoneySoundEvent = Event.new("playMoneySoundEvent")

local isFishingRequest = Event.new("isFishingRequest")
local changePoleRequest = Event.new("changePoleRequest")
local changeBaitRequest = Event.new("changeBaitRequest")

local upgradePoleRequest = Event.new("upgradePoleRequest")

local audioManager = require("AudioManager")
local utils = require("Utils")
local uiManager = require("UIManager")
local ItemMetaData = require("ItemMetaData")
local pole_metas = ItemMetaData.pole_metadata

--local uiManager = require("UIManager")
players = {}

------------ Player Tracking ------------
function TrackPlayers(game, characterCallback)
    scene.PlayerJoined:Connect(function(scene, player)
        players[player] = {
            player = player,
            Score = IntValue.new("PlayerScore" .. tostring(player.id), 0),
            isFishing = BoolValue.new("isFishing" .. tostring(player.id), false),
            fishingPoint = Vector3Value.new("fishingPoint" .. tostring(player.id), Vector3.new(0,0,0)),
            playerInventory = TableValue.new("PlayerInventory" .. tostring(player.id), {}),
            Tokens = IntValue.new("Tokens" .. tostring(player.id), 0),
            playerFishRecords = TableValue.new("PlayerFishRecords" .. tostring(player.id), {}),
            playerFishingPole = StringValue.new("PlayerFishingPole" .. tostring(player.id), "fishing_pole_1"),
            playerBait = StringValue.new("PlayerBait" .. tostring(player.id), "none"),
            playerXP = IntValue.new("PlayerXP" .. tostring(player.id), 0),
            playerLevel = IntValue.new("PlayerLevel" .. tostring(player.id), 1),
            playerPoleLevel = IntValue.new("PlayerPoleLevel" .. tostring(player.id), 1),
            playerPolePrestige = IntValue.new("PlayerPolePrestige" .. tostring(player.id), 1),
            playerStrength = IntValue.new("PlayerStrength" .. tostring(player.id), -1),
            playerHookSpeed = NumberValue.new("PlayerHookSpeed" .. tostring(player.id), -1),
            playerReelSpeed = NumberValue.new("PlayerReelSpeed" .. tostring(player.id), -1),
            playerXPModifier = NumberValue.new("PlayerXPModifier" .. tostring(player.id), -1)
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

------------------- Client -------------------
function self:ClientAwake()

    -------- Scoring --------
    clientJoinRequets:FireServer()

    ServerLeaderboard.Changed:Connect(function(iTopScores)
        --print("Updating Leaderboard " .. tostring(#iTopScores))
        --uiManager.UpdateLeaderboard(iTopScores)
    end)

    playMoneySoundEvent:Connect(function()
        audioManager.PlaySound("coinsSound1", 1)
    end)

    function OnCharacterInstantiate(playerinfo)
        local player = playerinfo.player
        local character = player.character

        -- Local player score update
        playerinfo.Score.Changed:Connect(function(score, oldVal)
            if player == client.localPlayer then
                --print("Score: " .. tostring(score))
                --uiManager.UpdateLocalPlayer(score)
            end
        end)

        -- local playerTokensChange
        playerinfo.Tokens.Changed:Connect(function(tokens, oldVal)
            if player == client.localPlayer then
                --print("Tokens: " .. tostring(tokens))
                uiManager.UpdateCash()
            end
        end)

        if pole_metas[playerinfo.playerFishingPole.value] then character:AddOutfit(pole_metas[playerinfo.playerFishingPole.value].Outfit) end
        playerinfo.playerFishingPole.Changed:Connect(function(poleID, oldVal)
            --Give player their selected fishing pole
            --print("Pole Changed: " .. poleID)
            if pole_metas[oldVal] then character:RemoveOutfit(pole_metas[oldVal].Outfit) end
            if pole_metas[poleID] then character:AddOutfit(pole_metas[poleID].Outfit) end

            if player == client.localPlayer then
                uiManager.UpdateSelectedPole(poleID)
            end

        end)

        playerinfo.playerBait.Changed:Connect(function(baitID, oldVal)
            --Give player their selected bait
            if player == client.localPlayer then
                
                -- Get the amount of the current bait
                local inv = playerinfo.playerInventory.value
                if utils.is_in_inventory_table(inv, baitID) then
                    local itemIndex = utils.find_inventory_index(inv, baitID)
                    local amount = inv[itemIndex].amount
                    uiManager.UpdateSelectedBait(baitID, amount)
                else
                    uiManager.UpdateSelectedBait("none", nil)
                end
                print(baitID)
            end
        end)

        ClearLine(player)
        playerinfo.isFishing.Changed:Connect(function(isFishing, oldVal)
            if not isFishing then
                ClearLine(player)
            end
        end)
        playerinfo.fishingPoint.Changed:Connect(function(fishingPoint, oldVal)
            if playerinfo.isFishing.value then
                SetLine(player, fishingPoint)
            end
        end)
        
        -- Update the player inventory
        playerinfo.playerInventory.Changed:Connect(function(inventory, oldVal)
            if player == client.localPlayer then

                print("Inventory Changed: " .. tostring(#inventory))

                -- Get the curretn Pole and update the UI
                uiManager.UpdateSelectedPole(playerinfo.playerFishingPole.value)

                -- Get the amount of the bait and update the UI
                local inv = playerinfo.playerInventory.value
                local curretnBait = playerinfo.playerBait.value
                if utils.is_in_inventory_table(inv, curretnBait) then
                    local itemIndex = utils.find_inventory_index(inv, curretnBait)
                    local amount = inv[itemIndex].amount
                    uiManager.UpdateSelectedBait(curretnBait, amount)
                else
                    uiManager.UpdateSelectedBait("", nil)
                end
            end
        end)
    end

    TrackPlayers(client, OnCharacterInstantiate)
end

-- Function to get the player's Level
function GetPlayerLevel()
    return players[client.localPlayer].playerLevel.value
end

-- Function to get the player's strength
function GetPlayerStrength()
    return players[client.localPlayer].playerStrength.value
end

-- Function to get the player's hook speed
function GetPlayerHookSpeed()
    return players[client.localPlayer].playerHookSpeed.value
end

-- Function to get the player's reel speed
function GetPlayerReelSpeed()
    return players[client.localPlayer].playerReelSpeed.value
end

-- Function to get the player's Rod Level
function GetPlayerPoleLevel()
    return players[client.localPlayer].playerPoleLevel.value
end

-- Function to get the player's Rod Prestige
function GetPlayerPolePrestige()
    return players[client.localPlayer].playerPolePrestige.value
end

-- Function to get the player's XP Modifier
function GetPlayerXPModifier(player)
    return players[player].playerXPModifier.value
end

function UpgradePoleRequest()
    upgradePoleRequest:FireServer()
end

function GetPlayerInventory()
    return players[client.localPlayer].playerInventory.value
end

function SetLine(player, point : Vector3)
    local character = player.character
    local playerinfo = players[player]

    local line = character.gameObject.transform:Find("Line")
    local lineB = line.transform:Find("B")

    lineB.transform.position = point
    line.gameObject:SetActive(true)
end
function ClearLine(player)
    local character = player.character
    local line = character.gameObject.transform:Find("Line")
    local lineB = line.transform:Find("B")

    lineB.transform.localPosition = Vector3.new(0,0,0)
    line.gameObject:SetActive(false)
end

function GetPlayerFishRecord(fishID : string)
    return players[client.localPlayer].playerFishRecords.value[fishID] or 0
end

function FishingStateRequest(state : boolean, point : Vector3)
    isFishingRequest:FireServer(state, point)
end

function ChangePoleRequest(poleID : string)
    changePoleRequest:FireServer(poleID)
end

function GetPole()
    return players[client.localPlayer].playerFishingPole.value
end

function ChangeBaitRequest(baitID : string, unEquip)
    if unEquip == nil then unEquip = true end
    --print(tostring(unEquip))
    changeBaitRequest:FireServer(baitID, unEquip)
end

function GetBait()
    return players[client.localPlayer].playerBait.value
end

function PromtTokenPurchase(id : string)

    --print(tostring(Payments))
    Payments:PromptPurchase(id, function(paid)
        if paid then
            -- Player has purchased the product, server PurchaseHandler will be called soon
            -- Do not give the product here, as the server may not have processed the purchase yet
            --print("(Client) Purchase successful!")
        else
            -- Purchase failed, player closed the purchase dialog or something went wrong
            --print("(Client) Purchase failed!" .. tostring(paid))
        end
    end)
end
------------------- Server -------------------

local topScoreTable = {}

-------- Utility Functions --------

function GetPlayerItemCount(player, itemID)
    local playerInfo = players[player]
    local playerInventory = playerInfo.playerInventory.value
    local itemIndex = utils.find_inventory_index(playerInventory, itemID)

    if playerInventory[itemIndex] == nil or itemIndex == nil then
        return 0
    end
    return playerInventory[itemIndex].amount
end

function GetTokens(player)
    return players[player].Tokens.value
end

function AddScoreServer(player, amount)
    local playerInfo = players[player]

    Storage.IncrementPlayerValue(player ,"HighScore", amount)
    
    Storage.GetPlayerValue(player, "HighScore", function(value)
        if value == nil then value = 0 end

        playerInfo.Score.value = value

        topScoreTable[player.name] = {
            playerName = player.name,
            playerScore = value
        }
        
        local topScores, iTopScores = utils.SortScores(topScoreTable)

        local leaderboardChanged = false
        Storage.UpdateValue("TopScores", function(newScores)
            leaderboardChanged = newScores == nil or not utils.is_table_equal(newScores, topScores, false)
            return if leaderboardChanged then topScores else nil
        end,
        function()
            if(leaderboardChanged) then
                updateLeaderboardEvent:FireAllClients(iTopScores)
            end
        end)

    end)
    UpdatePlayerScore(player)
    UpdateLeaderboard()
end

function UpdatePlayerScore(player)
    Storage.GetPlayerValue(player, "HighScore", function(value)
        if value == nil then value = 0 end
        players[player].Score.value = value
    end)
end

function UpdateLeaderboard()
    local topScores, iTopScores = utils.SortScores(topScoreTable)
    ServerLeaderboard.value = iTopScores
end

function SetPoleServer(player, poleID)
    if players[player].playerFishingPole.value ~= poleID then 
        players[player].playerFishingPole.value = poleID 
    else 
        players[player].playerFishingPole.value = "" 
    end
end

function SetBaitServer(player, baitID, unEquip)
    if players[player].playerBait.value ~= baitID then 
        players[player].playerBait.value = baitID 
    else 
        if unEquip then
            players[player].playerBait.value = "none"
        end
    end
end

function UpdatePlayerFishRecords(player, fishRecord)
    local playerInfo = players[player]
    playerInfo.playerFishRecords.value = fishRecord
end
---------------------------------------------


function self:ServerAwake()
    TrackPlayers(server)

    -- Fetch the top scores from storage
    Storage.GetValue("TopScores", function(value)
        if value == nil then return end
        local HighScores = value
        for key, value in pairs(HighScores) do 

            topScoreTable[value.playerName] = {
                playerName = value.playerName,
                playerScore = value.playerScore
            }

        end
    end)

    isFishingRequest:Connect(function(player, state, point)
        players[player].isFishing.value = state
        players[player].fishingPoint.value = point
    end)

    changePoleRequest:Connect(function(player, poleID)
        SetPoleServer(player, poleID)
    end)

    changeBaitRequest:Connect(function(player, baitID, unEquip)
        SetBaitServer(player, baitID, unEquip)
    end)

    upgradePoleRequest:Connect(function(player)
        local upgradeCost = CalculatePoleUpgradeCost(player)
        if GetTokens(player) < upgradeCost  then
            print("Error: Not enough tokens to upgrade pole")
            return
        end
        UpgradePole(player, upgradeCost)
    end)
    
    ---------------Token amd Scoring System----------------

    -- Register the PurchaseHandler function to be called when a purchase is made
    Payments.PurchaseHandler = ServerHandlePurchase

    clientJoinRequets:Connect(function(player)
        GetPlayerStatsFromStorage(player)
        GetPlayerTokensServer(player)
        UpdatePlayerScore(player)
    end)
end

----------------- Player Stats -----------------
-- Store player Stats with Storage API
function StorePlayerStats(player)
    if players[player] == nil then
        print("Error: Player not found.")
        return
    end

    local playerInfo = players[player]
    local playerStats = {
        playerXP = playerInfo.playerXP.value,
        playerLevel = playerInfo.playerLevel.value,
        playerPoleLevel = playerInfo.playerPoleLevel.value,
        playerPolePrestige = playerInfo.playerPolePrestige.value
    }

    Storage.SetPlayerValue(player, "PlayerStats", playerStats, function(err)
        if err ~= StorageError.None then print("Error: " .. err) end
    end)
end

-- Get player Stats from Storage API
function GetPlayerStatsFromStorage(player)
    if players[player] == nil then
        print("Error: Player not found.")
        return
    end

    Storage.GetPlayerValue(player, "PlayerStats", function(playerStats)
        if playerStats == nil then
            -- Default values if no data found
            print("No player stats found for " .. player.name .. ". Defaulting to level 1.")
            playerStats = {
                playerXP = 0,
                playerLevel = 1,
                playerPoleLevel = 1,
                playerPolePrestige = 1
            }
        end

        -- Ensure all stats exist and default to valid values
        players[player].playerXP.value = playerStats.playerXP or 0
        players[player].playerLevel.value = playerStats.playerLevel or 1
        players[player].playerPoleLevel.value = math.max(playerStats.playerPoleLevel, players[player].playerPoleLevel.value) or 1
        players[player].playerPolePrestige.value = math.max(playerStats.playerPolePrestige, players[player].playerPolePrestige.value) or 1
        SetStatsPerLevel(player)

        -- Print the player's stats
        --[[]
        print(player.name .. "'s stats: ")
        print("XP: " .. tostring(players[player].playerXP.value))
        print("Level: " .. tostring(players[player].playerLevel.value))
        print("Pole Level: " .. tostring(players[player].playerPoleLevel.value))
        print("Pole Prestige: " .. tostring(players[player].playerPolePrestige.value))
        print("Strength: " .. tostring(players[player].playerStrength.value))
        print("Hook Speed: " .. tostring(players[player].playerHookSpeed.value))
        print("Reel Speed: " .. tostring(players[player].playerReelSpeed.value))
        print("XP Modifier: " .. tostring(players[player].playerXPModifier.value))
        ]]

    end)
    
end

----------------- Leveling System -----------------
-- Function to award XP to the player
function AwardXP(player, xpAmount)
    local playerInfo = players[player]
    
    -- Add the XP to the player's current XP
    playerInfo.playerXP.value = playerInfo.playerXP.value + xpAmount
    print(player.name .. " has been awarded " .. tostring(xpAmount) .. " XP!")

    -- Check if the player can level up
    CheckLevelUp(player)
end

-- Define XP required for each level
function GetXPForLevel(level)
    if level == 1 then
        return 100
    elseif level >= 2 and level <= 9 then
        -- Levels 2 to 9: Each level requires 50 more XP than the previous
        return 100 + (level - 1) * 50
    elseif level >= 10 and level <= 14 then
        -- Levels 10 to 14: Each level requires 100 more XP than the previous
        -- Level 10 requires 600 XP (from the table)
        return 600 + (level - 10) * 100
    elseif level >= 15 and level <= 24 then
        -- Levels 15 to 24: Each level requires 200 more XP than the previous
        -- Level 15 requires 1200 XP (from the table)
        return 1200 + (level - 15) * 200
    elseif level >= 25 and level <= 29 then
        -- Levels 25 to 29: Each level requires 500 more XP than the previous
        -- Level 25 requires 3500 XP (from the table)
        return 3500 + (level - 25) * 500
    elseif level >= 30 then
        -- Level 30 is the max level; no further XP required
        return 3500 + (level - 25) * 1000
    else
        -- Handle invalid levels
        return nil -- or an error message
    end
end

-- Example Usage:
--[[
for lvl = 1, 30 do
    local xp = GetXPForLevel(lvl)
    if xp then
        print("Level " .. lvl .. " requires " .. xp .. " XP to reach the next level.")
    else
        print("Level " .. lvl .. " is the maximum level.")
    end
end
-]]

--[[
If a player has enough XP to jump from level 3 to level 5 in a single action, 
this function will automatically handle both level-ups instead of stopping at the first one.
]]
-- Function to handle leveling up
function CheckLevelUp(player)
    local playerInfo = players[player]
    local currentXP = playerInfo.playerXP.value
    local currentLevel = playerInfo.playerLevel.value

    --Print current XP and level
    print(player.name .. " has " .. tostring(currentXP) .. " XP and is level " .. tostring(currentLevel))

    -- Loop to level up if enough XP is accumulated for multiple levels
    while currentXP >= GetXPForLevel(currentLevel) do
        currentXP = currentXP - GetXPForLevel(currentLevel)
        currentLevel = currentLevel + 1
        print(player.name .. " leveled up to " .. tostring(currentLevel) .. "!")
    end

    -- Update player stats with new level and remaining XP
    playerInfo.playerXP.value = currentXP
    playerInfo.playerLevel.value = currentLevel
    SetStatsPerLevel(player)

    -- Store the updated stats after leveling up
    StorePlayerStats(player)
end

--[[
Set the Strength, Hook Speed, Reel Speed, and XP Modifier based on the player's level
]]
function SetStatsPerLevel(player)
    local playerInfo = players[player]
    local currentXP = playerInfo.playerXP.value
    local currentLevel = playerInfo.playerLevel.value
    local currentPoleLevel = playerInfo.playerPoleLevel.value
    local currentPolePrestige = playerInfo.playerPolePrestige.value

    playerInfo.playerFishingPole.value = "fishing_pole_" .. tostring(currentPolePrestige)

    --LEVEL UP STATS
    playerInfo.playerStrength.value = currentLevel
    playerInfo.playerHookSpeed.value = calculateHookSpeed(currentPoleLevel, currentPolePrestige)
    playerInfo.playerReelSpeed.value = calculateReelSpeed(currentPoleLevel, currentPolePrestige)
    playerInfo.playerXPModifier.value = calculateXPMultiplier(currentPolePrestige)
end

--[[
Function to calculate Hook Speed based on Rod Level and Prestige
]]
function calculateHookSpeed(level, prestige)
    -- Base hook speed factor for level 1 at prestige 1
    local baseHookSpeed = 1.0
    -- Hook speed reduction per level within each prestige
    local hookSpeedFactorPerLevel = 0.05
    -- Hook speed improvement per prestige (slight improvement from previous prestige)
    local hookSpeedImprovementPerPrestige = 0.02
    -- Adjust base hook speed with prestige improvement
    local prestigeAdjustedBaseHookSpeed = baseHookSpeed - ((prestige - 1) * hookSpeedImprovementPerPrestige)

    -- Calculate hook speed factor based on the current level within prestige
    local hookSpeedFactor = prestigeAdjustedBaseHookSpeed - ((level - 1) * hookSpeedFactorPerLevel)

    -- Ensure that hook speed doesn't drop below a certain threshold (e.g., 0.2x)
    if hookSpeedFactor < 0.2 then
        hookSpeedFactor = 0.2
    end

    return hookSpeedFactor
end

--[[
Function to calculate Reel Speed based on Rod Level and Prestige
]]
function calculateReelSpeed(level, prestige)
    -- Base reeling speed modifier for level 1 at prestige 1
    local baseReelSpeed = 1.0
    -- Reel speed increase per level within each prestige
    local reelSpeedFactorPerLevel = 0.05
    -- Reel speed improvement per prestige (slight improvement from previous prestige)
    local reelSpeedImprovementPerPrestige = 0.02
    -- Adjust base reel speed with prestige improvement
    local prestigeAdjustedBaseReelSpeed = baseReelSpeed + ((prestige - 1) * reelSpeedImprovementPerPrestige)

    -- Calculate reel speed factor based on the current level within prestige
    local reelSpeedFactor = prestigeAdjustedBaseReelSpeed + ((level - 1) * reelSpeedFactorPerLevel)

    return reelSpeedFactor
end

--[[
Function to calculate XP Multiplier based on Prestige
]]
function calculateXPMultiplier(prestige)
    -- Base XP multiplier for Prestige 1
    local baseXPMultiplier = 1.0
    -- XP multiplier increase per prestige level
    local xpMultiplierIncreasePerPrestige = 0.25

    -- Calculate the XP multiplier based on the prestige level
    local xpMultiplier = baseXPMultiplier + ((prestige - 1) * xpMultiplierIncreasePerPrestige)

    return xpMultiplier
end

--[[
Calculate the cost to upgrade the fishing pole based on the current level and prestige
]]
--Increase by 10 per level at prestige one, 50 per level at prestige 2, 100 per level at prestige 3, 200 per level at prestige 4, 300 per level at prestige 5, 400 per level at prestige 6, 500 per level at prestige 7, 600 per level at prestige 8, 700 per level at prestige 9, 800 per level at prestige 10, 900 per level at prestige 11, 1000 per level at prestige 12 
-- not reseting each prestige
-- Calculate the cost to upgrade the fishing pole based on the current level and prestige
function CalculatePoleUpgradeCost(player: Player)
    local upgradeCost = players[player].playerPolePrestige.value * 100
    return upgradeCost
end

--[[
Function to upgradeto the next level of the fishing pole and prestige at level 10
]]
function UpgradePole(player : Player, upgradeCost : number, levelstoIncease)
    levelstoIncease = levelstoIncease or 1
    local playerInfo = players[player]
    local currentPoleLevel = playerInfo.playerPoleLevel.value
    local currentPolePrestige = playerInfo.playerPolePrestige.value

    if upgradeCost > 0 then
        local transaction = InventoryTransaction.new()
        :TakePlayer(player, "Tokens", upgradeCost)
        Inventory.CommitTransaction(transaction, function(transactionId, err) if err ~= InventoryError.None then print(err) end end)
        playerInfo.Tokens.value = playerInfo.Tokens.value - upgradeCost
    end

    currentPoleLevel = currentPoleLevel + levelstoIncease

    -- Loop to level up if enough XP is accumulated for multiple levels
    while currentPoleLevel > 9 do
        currentPoleLevel = currentPoleLevel - 9
        if currentPolePrestige < 12 then
            currentPolePrestige = currentPolePrestige + 1
        end
    end

    playerInfo.playerPoleLevel.value = currentPoleLevel
    playerInfo.playerPolePrestige.value = currentPolePrestige
    playerInfo.playerFishingPole.value = "fishing_pole_" .. tostring(currentPolePrestige)
    print(currentPolePrestige)

    -- Update the player's stats based on the new pole level and prestige
    SetStatsPerLevel(player)
    StorePlayerStats(player)
end

function SetPoleLevel(player, Prestige, Level)
    local playerInfo = players[player]
    playerInfo.playerPoleLevel.value = Level
    playerInfo.playerPolePrestige.value = Prestige
    SetStatsPerLevel(player)
    StorePlayerStats(player)
end

function SetPlayerLevel(player, Level, XP)
    local playerInfo = players[player]
    playerInfo.playerLevel.value = Level
    playerInfo.playerXP.value = XP
    SetStatsPerLevel(player)
    StorePlayerStats(player)
end

----------------- Server Purchase Handler and Inventory -----------------
function GetPlayerTokensServer(player)
    Inventory.GetPlayerItem(player, "Tokens", function(item)
        if item == nil then
            players[player].Tokens.value = 0
        else
            players[player].Tokens.value = item.amount
        end
    end)
    --print("Player " .. player.name .. " has " .. tostring(players[player].Tokens.value) .. " tokens")
end
function IncrementTokensServer(player, amount)
    print("Incrementing tokens for player " .. player.name .. " by " .. tostring(amount))
    if amount < 0 then
        -- TAKE TOKENS
        local transaction = InventoryTransaction.new()
        :TakePlayer(player, "Tokens", math.abs(amount))
        Inventory.CommitTransaction(transaction)

    elseif amount > 0 then
        -- GIVE TOKENS
        local transaction = InventoryTransaction.new()
        :GivePlayer(player, "Tokens", math.abs(amount))
        Inventory.CommitTransaction(transaction, function(transactionId: string, error: InventoryError) print(tostring(error)) end)
        playMoneySoundEvent:FireClient(player)

    else
        return
    end
    players[player].Tokens.value = players[player].Tokens.value + amount
    --GetPlayerTokensServer(player)
end

function UpdatePlayerInventoryNetworkValue(player, clientItems)
    players[player].playerInventory.value = clientItems
end

function GetPlayerInventoryNetworkValue(player)
    return players[player].playerInventory.value
end

function PrintPurchasesForPlayer(player: Player)
    local limit = 100
    local productId = nil
    local cursorId = nil
    
    --print("(Server) Getting purchases for player " .. tostring(player))
    Payments.GetPurchases(player, productId, limit, cursorId, function(purchases, nextCursorId, getPurchasesErr)
        if getPurchasesErr ~= PaymentsError.None then
            error("(Server) Failed to get player purchases: " .. getPurchasesErr)
            return
        end
        --print("(Server) Player purchases:")
        for _, purchase in ipairs(purchases) do
            --print("Purchase ID: " .. tostring(purchase.id))
            --print("Product ID: " .. tostring(purchase.product_id))
            --print("User ID: " .. tostring(purchase.user_id))
            --print("Purchase Date: " .. tostring(purchase.purchase_date))
        end
    end)
end

function ServerHandlePurchase(purchase, player: Player)
    local productId = purchase.product_id
    --print("(Server) Purchase made by player " .. tostring(player) .. " for product " .. tostring(productId))
    
    local amountToGive = 0
    if productId == "fishing_token_1" then
        amountToGive = 100
    elseif productId == "fishing_token_2" then
        amountToGive = 200
    elseif productId == "fishing_token_3" then
        amountToGive = 500
    else
        Payments.AcknowledgePurchase(purchase, false) -- Reject the purchase, it will be retried at a later time and eventually refunded
        --print("(Server) Purchase for unknown product ID: " .. productId)
        return
    end

    Payments.AcknowledgePurchase(purchase, true, function(ackErr: PaymentsError)
        if ackErr ~= PaymentsError.None then
            error("(Server) Something went wrong while acknowledging purchase: " .. ackErr)
            return
        end
        --print("(Server) Purchase acknowledged")
        PrintPurchasesForPlayer(player)
        IncrementTokensServer(player, amountToGive)
    end)
end