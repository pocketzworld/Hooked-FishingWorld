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

function PurchaseItem(id : string, price : number)
    purchaseItemReq:FireServer(id, price)
end

function self:ClientAwake()
    itemChangedEvent:Connect(function(item)
        print("Item Changed: " .. item)
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
    ---]]

end
----------------- Server -----------------

function self:ServerAwake()
    --giveItemReq:Connect(GivePlayerItem)
    --takeItemReq:Connect(TakePlayerItem)

    ClientJoinRequest:Connect(function(player)
        TakePlayerItem(player,"fishing_pole_1", 1)
        GivePlayerItem(player, "fishing_pole_1", 1)
    end)

    purchaseItemReq:Connect(function(player: Player, id: string, price: number)
        local transaction = InventoryTransaction.new()
        :TakePlayer(player, "Tokens", price)
        :GivePlayer(player, id, 1)
        Inventory.CommitTransaction(transaction)

        GetAllPlayerItems(player, 100, nil, {}, UpdatePlayerInventory)
        playerTracker.GetPlayerTokensServer(player)
    end)

    scene.PlayerJoined:Connect(function(scene, player)
        GetAllPlayerItems(player, 100, nil, {}, UpdatePlayerInventory)
    end)

    getRecordReq:Connect(function(player: Player)
        GetPlayerFishRecords(player)
    end)
    updateRecordReq:Connect(function(player: Player, fishID: string, size: number)
        UpdatePlayersRecordFish(player, fishID, size)
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

function GivePlayerItem(player : Player, itemId : string, amount : number)
    itemChangedEvent:FireClient(player, itemId)
    print("Giving " .. player.name .. " " .. tostring(amount) .. " of " .. itemId)
    local transaction = InventoryTransaction.new()
    :GivePlayer(player, itemId, amount)
    Inventory.CommitTransaction(transaction)

    GetAllPlayerItems(player, 100, nil, {}, UpdatePlayerInventory)
end
function TakePlayerItem(player : Player, itemId : string, amount : number)
    local transaction = InventoryTransaction.new()
    :TakePlayer(player, itemId, amount)
    Inventory.CommitTransaction(transaction)

    GetAllPlayerItems(player, 100, nil, {}, UpdatePlayerInventory)
end

function GetAllPlayerItems(player, limit, cursorId, accumulatedItems, callback)
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
            GetAllPlayerItems(player, limit, newCursorId, accumulatedItems, UpdatePlayerInventory)
        else
            -- No more items to fetch, call the callback with the accumulated items
            for each, item in accumulatedItems do
                --print(item.id .. " " .. item.amount)
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
    print("Setting Records for " .. player.name)
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