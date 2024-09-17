--!Type(Module)

local giveItemReq = Event.new("GiveItemRequest")
local takeItemReq = Event.new("TakeItemRequest")

local itemChangedEvent = Event.new("ItemChangedEvent")

local getRecordReq = Event.new("GetRecordRequest")
local updateRecordReq = Event.new("UpdateRecordRequest")

local purchaseItemReq = Event.new("PurchaseItemRequest")

local ClientJoinRequest = Event.new("ClientJoinRequest")

local Utils = require("Utils")
local audioManager = require("AudioManager")
local playerTracker = require("PlayerTracker")
local uiManager = require("UIManager")
local itemMetaData = require("ItemMetaData")
local fishMetaData = require("FishMetaData")
local fishMetaTable = fishMetaData.fish_metadata

----------------- Client -----------------
function GiveItemClient(id: string, amount: number)
    --giveItemReq:FireServer(id, amount)
end

function TakeItemClient(id: string, amount: number)
    --takeItemReq:FireServer(id, amount)
end

function PurchaseItem(id : string, price : number, quantity : number)
    purchaseItemReq:FireServer(id, price, quantity)
end

function self:ClientAwake()
    itemChangedEvent:Connect(function(item)
        --print("Item Changed: " .. item)
        -- Show popup for the item if it is a Fish
        if fishMetaData.IsFish(item) then 
            local fishSize = fishMetaData.GetFishSize(item)
            if fishMetaTable[item] then
                uiManager.ShowFishPopup(item,
                fishSize,
                fishMetaTable[item].Rarity,
                fishMetaTable[item].Description,
                fishMetaTable[item].FishImage,
                fishMetaTable[item].Worth)

                audioManager.PlaySound("rewardSound1", 1)

                updateRecordReq:FireServer(item, fishSize)
            end
        end

    end)

    getRecordReq:FireServer()
    ClientJoinRequest:FireServer()

    --[[ Give the player all the bait items]
    for key, value in pairs(itemMetaData.bait_keys) do
        GiveItemClient(value, 10)
    end
    for key, value in pairs(itemMetaData.pole_keys) do
        GiveItemClient(value, 1)
    end
    -]]

end
----------------- Server -----------------

local GiveTransactionsToCommit = {}
local TakeTransactionsToCommit = {}

local currentSeasonID = 1

function self:ServerAwake()
    --giveItemReq:Connect(GivePlayerItem)
    --takeItemReq:Connect(TakePlayerItem)

    ClientJoinRequest:Connect(function(player)
        --[[
        local hasBegginerPole = playerTracker.GetPlayerItemCount(player, "fishing_pole_1") > 0
        if not hasBegginerPole then
            GivePlayerItem(player, "fishing_pole_1", 1)
        end
        local hasBegginerPole = playerTracker.GetPlayerItemCount(player, "fishing_pole_2") > 0
        if not hasBegginerPole then
            GivePlayerItem(player, "fishing_pole_2", 1)
        end
        local hasBegginerPole = playerTracker.GetPlayerItemCount(player, "fishing_pole_3") > 0
        if not hasBegginerPole then
            GivePlayerItem(player, "fishing_pole_3", 1)
        end
        local hasBegginerPole = playerTracker.GetPlayerItemCount(player, "fishing_pole_5") > 0
        if not hasBegginerPole then
            GivePlayerItem(player, "fishing_pole_5", 1)
        end
        ]]

        GetSeasonData(function()
            Timer.After(1, function()

                -- Port Old poles to V2 as Rod Upgrades
                TradeOldPoles(player)
    
                -- Get the player's Season Id
                Storage.GetPlayerValue(player, "SeasonID", function(value)
                    local playerSeasonID = value or 1
                    -- If the player Season ID does not match the current Season ID, remove all fish from inv and reset the player Season ID
                    if playerSeasonID ~= currentSeasonID then
                        -- Fetch the players Inventory
                        local playerInv = playerTracker.players[player].playerInventory.value
                        -- Remove all fish from the player's inventory
                        for index, item in playerInv do
                            if fishMetaData.IsFish(item.id) then
                                TakePlayerItem(player, item.id, item.amount)
                            end
                        end
                        -- Reset the player's level
                        playerTracker.SetPlayerLevel(player, 1, 0)
                        -- Reset the player's Season ID
                        Storage.SetPlayerValue(player, "SeasonID", currentSeasonID)
                    end
                end)
            end)
        end)
    end)

    purchaseItemReq:Connect(function(player: Player, id: string, price: number, quantity: number)
        local transaction = InventoryTransaction.new()
        :TakePlayer(player, "Tokens", price)
        :GivePlayer(player, id, quantity)
        Inventory.CommitTransaction(transaction)

        GetAllPlayerItems_From_API(player, 100, nil, {}, UpdatePlayerInventory)
        playerTracker.GetPlayerTokensServer(player)
    end)
    scene.PlayerJoined:Connect(function(scene, player)
        GetAllPlayerItems_From_API(player, 100, nil, {}, UpdatePlayerInventory)
    end)

    getRecordReq:Connect(function(player: Player)
        GetPlayerFishRecords(player)
    end)
    updateRecordReq:Connect(function(player: Player, fishID: string, size: number)
        UpdatePlayersRecordFish(player, fishID, size)
    end)


    -- Commit All Queued Transactions every 5 seconds
    Timer.Every(5, function()
        CommitQueuedTransactions()
    end)
end

function UpdatePlayerInventory(player, items)
    print("Sending " .. tostring(#items) .. " items to " .. player.name)
    --Convert the items to a format that can be sent to the client
    local clientItems = {}
    for index, item in items do
        clientItems[index] = {
            id = item.id,
            amount = item.amount
        }
    end
    --Set the players Items on Server via Player Tracker
    playerTracker.UpdatePlayerInventoryNetworkValue(player, clientItems)
end

function UpdatePlayerInventory_Temporary(player, itemId, amount)

    local Player_Inventory_Table_Value = playerTracker.GetPlayerInventoryNetworkValue(player)
    local itemExists = false
    for index, item in Player_Inventory_Table_Value do
        if item.id == itemId then
            item.amount = item.amount + amount
            if item.amount <= 0 then
                table.remove(Player_Inventory_Table_Value, index)
            end
            itemExists = true
            break
        end
    end
    if not itemExists and amount > 0 then
        table.insert(Player_Inventory_Table_Value, {id = itemId, amount = amount})
    end

    --Set the players Items on Server via Player Tracker
    playerTracker.UpdatePlayerInventoryNetworkValue(player, Player_Inventory_Table_Value)
end

function GivePlayerItem(player : Player, itemId : string, amount : number)
    itemChangedEvent:FireClient(player, itemId)
    table.insert(GiveTransactionsToCommit, {playerID = player.user.id, itemId = itemId, amount = amount})

    UpdatePlayerInventory_Temporary(player, itemId, amount)
end
function TakePlayerItem(player : Player, itemId : string, amount : number)
    table.insert(TakeTransactionsToCommit, {playerID = player.user.id, itemId = itemId, amount = amount})
    UpdatePlayerInventory_Temporary(player, itemId, -amount)
end

function CommitQueuedTransactions()

    if #GiveTransactionsToCommit == 0 and #TakeTransactionsToCommit == 0 then
        return
    end

    print("Committing " .. tostring(#GiveTransactionsToCommit) .. " Give Transactions and " .. tostring(#TakeTransactionsToCommit) .. " Take Transactions")

    local compiledTransaction = InventoryTransaction.new()

    for index, transaction in GiveTransactionsToCommit do
        compiledTransaction:Give(transaction.playerID, transaction.itemId, transaction.amount)
    end
    for index, transaction in TakeTransactionsToCommit do
        compiledTransaction:Take(transaction.playerID, transaction.itemId, transaction.amount)
    end

    Inventory.CommitTransaction(compiledTransaction)

    GiveTransactionsToCommit = {}
    TakeTransactionsToCommit = {}
end

function GetAllPlayerItems_From_API(player, limit, cursorId, accumulatedItems, callback)
    accumulatedItems = accumulatedItems or {}
    
    Inventory.GetPlayerItems(player, limit, cursorId, function(items, newCursorId, errorCode)
        if items == nil then
            print("Got error " .. InventoryError[errorCode] .. " while getting items")
            return
        end

        -- Add fetched items to the accumulatedItems table
        
        for index, item in items do
            table.insert(accumulatedItems, item)
        end

        if newCursorId ~= nil then
            -- Continue fetching the next batch of items
            GetAllPlayerItems_From_API(player, limit, newCursorId, accumulatedItems, UpdatePlayerInventory)
        else
            -- No more items to fetch, call the callback with the accumulated items
            for each, item in accumulatedItems do
                ----print(item.id .. " " .. item.amount)
            end
            callback(player, accumulatedItems)
        end
    end)
end

function GetPlayerFishRecords(player : Player)
    Storage.GetPlayerValue(player, "Fish_Records", function(value)
        local records = {}
        if value == nil then print("NO RECORDS FOR " .. player.name) else records = value end
        playerTracker.UpdatePlayerFishRecords(player, records)
    end)
end

function SetPlayersRecordFish(player : Player, records)
    --print("Setting Records for " .. player.name)
    Storage.SetPlayerValue(player, "Fish_Records", records)
    playerTracker.UpdatePlayerFishRecords(player, records)
end

function UpdatePlayersRecordFish(player : Player, fishID : string, size : number)
    -- Fetch the Records Table
    local playerFishRecords = {}
    Storage.GetPlayerValue(player, "Fish_Records", function(value)
        if value == nil then print("NO RECORDS FOR " .. player.name) else playerFishRecords = value end

        -- If the Fish ID is not in the Records Table, add it
        if playerFishRecords[fishID] == nil or playerFishRecords[fishID] < size then 
            playerFishRecords[fishID] = size
        else
            return
        end
        SetPlayersRecordFish(player, playerFishRecords)

    end)
end

function GetSeasonData(cb)
    Storage.GetValue("SeasonID", function(value)
        if value == nil then
            currentSeasonID = 1
            Storage.SetValue("SeasonID", currentSeasonID)
        else
            currentSeasonID = value
        end
        if cb ~= nil then cb() end
    end)
end

function TradeOldPoles(player : Player)
    local highestPole = "fishing_pole_1"
    -- Take all the poles from the player
    local begginerPoleCount = playerTracker.GetPlayerItemCount(player, "fishing_pole_1")
    if begginerPoleCount > 0 then
        TakePlayerItem(player, "fishing_pole_1", begginerPoleCount)
    end
    local journeymanPoleCount = playerTracker.GetPlayerItemCount(player, "fishing_pole_2")
    if journeymanPoleCount > 0 then
        TakePlayerItem(player, "fishing_pole_2", begginerPoleCount)
        highestPole = "fishing_pole_2"
    end
    local deapSeaPoleCount = playerTracker.GetPlayerItemCount(player, "fishing_pole_3")
    if deapSeaPoleCount > 0 then
        TakePlayerItem(player, "fishing_pole_3", begginerPoleCount)
        highestPole = "fishing_pole_3"
    end
    local goldenPoleCount = playerTracker.GetPlayerItemCount(player, "fishing_pole_5")
    if goldenPoleCount > 0 then
        TakePlayerItem(player, "fishing_pole_5", begginerPoleCount)
        highestPole = "fishing_pole_5"
    end

    -- Give player Rod Upgrades depending on the best Pole they have
    if highestPole == "fishing_pole_1" then
        return
    elseif highestPole == "fishing_pole_2" then
        playerTracker.SetPoleLevel(player, 2, 1)
        print("Upgrading Pole 9 levels")
    elseif highestPole == "fishing_pole_3" then
        playerTracker.SetPoleLevel(player, 3, 1)
        print("Upgrading Pole 18 levels")
    elseif highestPole == "fishing_pole_5" then
        playerTracker.SetPoleLevel(player, 4, 1)
        print("Upgrading Pole 27 levels")
    end
end