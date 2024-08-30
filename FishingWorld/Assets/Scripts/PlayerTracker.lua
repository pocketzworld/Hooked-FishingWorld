--!Type(Module)

local getMyScoreRequest = Event.new("getMyScoreRequest")
local ServerLeaderboard = TableValue.new("ServerLeaderboard")
local playMoneySoundEvent = Event.new("playMoneySoundEvent")

local isFishingRequest = Event.new("isFishingRequest")
local changePoleRequest = Event.new("changePoleRequest")
local changeBaitRequest = Event.new("changeBaitRequest")

local getTokenRequest = Event.new("GetTokenRequest")

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
            playerInventory = TableValue.new("PlayerInventory" .. tostring(player.id)),
            Tokens = IntValue.new("Tokens" .. tostring(player.id), 0),
            playerFishRecords = TableValue.new("PlayerFishRecords" .. tostring(player.id), {}),
            playerFishingPole = StringValue.new("PlayerFishingPole" .. tostring(player.id), "fishing_pole_1"),
            playerBait = StringValue.new("PlayerBait" .. tostring(player.id), "none")
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
    getTokenRequest:FireServer()
    getMyScoreRequest:FireServer()

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
                uiManager.UpdateCash(tokens)
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
                --print("Bait Changed: " .. baitID)

                -- Get the amount of the current bait
                local inv = playerinfo.playerInventory.value
                if utils.is_in_inventory_table(inv, baitID) then
                    local itemIndex = utils.find_inventory_index(inv, baitID)
                    local amount = inv[itemIndex].amount
                    uiManager.UpdateSelectedBait(baitID, amount)
                else
                    uiManager.UpdateSelectedBait("", nil)
                end
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

local function findMaxKey(tbl)
    local maxKey = nil
    local maxValue = -math.huge -- Start with negative infinity as initial maximum value

    for key, value in pairs(tbl) do
        if value > maxValue then
            maxValue = value
            maxKey = key
        elseif value == maxValue then
            maxValue = value
            maxKey = nil
        end
    end

    return maxKey
end

function GetPlayerItemCount(player, itemID)
    local playerInfo = players[player]
    local playerInventory = playerInfo.playerInventory.value
    local itemIndex = utils.find_inventory_index(playerInventory, itemID)

    if playerInventory[itemIndex] == nil or itemIndex == nil then
        return 0
    end
    return playerInventory[itemIndex].amount
end

function is_table_equal(t1,t2,ignore_mt)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end
    -- non-table types can be directly compared
    if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
    -- as well as tables which have the metamethod __eq
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then return t1 == t2 end
    for k1,v1 in pairs(t1) do
       local v2 = t2[k1]
       if v2 == nil or not is_table_equal(v1,v2) then return false end
    end
    for k2,v2 in pairs(t2) do
       local v1 = t1[k2]
       if v1 == nil or not is_table_equal(v1,v2) then return false end
    end
    return true
end

function SortScores()
    -- Create a sortable list of players with score
    local sortableScores = {}
    for playerName, playerInfo in topScoreTable do
        table.insert(sortableScores, {playerName = playerInfo.playerName, playerScore = playerInfo.playerScore})
    end

    -- Sort the list by score in descending order
    table.sort(sortableScores, function(a, b)
        return a.playerScore > b.playerScore
    end)

    -- Extract the top scores (up to the number of players available)
    local numPlayers = #sortableScores
    local topScoresCount = math.min(numPlayers, 10)

    local topScores = {}
    local iTopScores = {}
    for i = 1, topScoresCount do
        topScores[sortableScores[i].playerName] = sortableScores[i]
        table.insert(iTopScores, sortableScores[i])
    end

    return topScores, iTopScores;
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
        
        local topScores, iTopScores = SortScores()

        local leaderboardChanged = false
        Storage.UpdateValue("TopScores", function(newScores)
            leaderboardChanged = newScores == nil or not is_table_equal(newScores, topScores, false)
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
    local topScores, iTopScores = SortScores()
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
            players[player].playerBait.value = "" 
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
    
    ---------------Token amd Scoring System----------------

    -- Register the PurchaseHandler function to be called when a purchase is made
    Payments.PurchaseHandler = ServerHandlePurchase

    getTokenRequest:Connect(GetPlayerTokensServer)
    getMyScoreRequest:Connect(UpdatePlayerScore)
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
    ----print("Incrementing tokens for player " .. player.name .. " by " .. tostring(amount))
    if amount < 0 then
        -- TAKE TOKENS
        local transaction = InventoryTransaction.new()
        :TakePlayer(player, "Tokens", math.abs(amount))
        Inventory.CommitTransaction(transaction)

    elseif amount > 0 then
        -- GIVE TOKENS
        local transaction = InventoryTransaction.new()
        :GivePlayer(player, "Tokens", math.abs(amount))
        Inventory.CommitTransaction(transaction)
        playMoneySoundEvent:FireClient(player)

    else
        return
    end
    GetPlayerTokensServer(player)
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