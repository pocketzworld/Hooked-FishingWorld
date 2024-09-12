--!Type(UI)

--!Bind
local _InventoryContent : UIScrollView = nil -- Important do not remove

--!Bind
local _itemInfo : VisualElement = nil -- Important do not remove
--!Bind
local _ItemInfoContent : VisualElement = nil -- Important do not remove

--!Bind
local _pageButtonFish : VisualElement = nil -- Important do not remove
--!Bind
local _pageButtonBait : VisualElement = nil -- Important do not remove
--!Bind
local _pageButtonProgress : VisualElement = nil -- Important do not remove
--!Bind
local _pageButtonStats : VisualElement = nil -- Important do not remove
--!Bind
local _pageButtonQuests : VisualElement = nil -- Important do not remove

--!SerializeField
local defaultImage : Texture = nil

local audioManager = require("AudioManager")

local inventoryManager = require("PlayerInventoryManager")

local Utils = require("Utils")
local UIManager = require("UIManager")
local audioManager = require("AudioManager")
local playerTracker = require("PlayerTracker")

local FishMetaData = require("FishMetaData")
local fishMetas = FishMetaData.fish_metadata
local fishKeys = FishMetaData.fish_keys

local ItemMetaData = require("ItemMetaData")
local baitMetas = ItemMetaData.bait_metadata
local poleMetas = ItemMetaData.pole_metadata
local poleKeys = ItemMetaData.pole_keys
local baitMetas = ItemMetaData.bait_metadata
local baitKeys = ItemMetaData.bait_keys

local inventoryItems = {}
local state = 0

--[[
Changable variables
modify/change/add/remove variables as needed
]]

--!Bind
local _closeButton : VisualElement = nil -- Close button for the inventory UI
--!Bind
local _closeInfoButton : VisualElement = nil -- Close button for the item info UI

local currentItems = {}

function SetRarityColor(element, rarity)
  element:AddToClassList("rarity__" .. rarity)
end

-- Function to create an item in the inventory
function CreateItem(amount, image)
  amount = amount or 0
  image = image or defaultImage

  local item = VisualElement.new()
  item:AddToClassList("inventory__item")

  local _itemIcon = VisualElement.new()
  _itemIcon:AddToClassList("inventory__item-icon")

  local _fishImage = UIImage.new()
  _fishImage:AddToClassList("inventory__item__icon__image")
  _fishImage.image = image
  _itemIcon:Add(_fishImage)

  local _itemAmount = VisualElement.new()
  _itemAmount:AddToClassList("inventory__item-amount")

  local _itemAmountText = UILabel.new()
  _itemAmountText:SetPrelocalizedText(tostring(amount))
  if amount > 0 then _itemAmount:Add(_itemAmountText) end

  item:Add(_itemIcon)
  item:Add(_itemAmount)

  _InventoryContent:Add(item)
  table.insert(inventoryItems, item)
  return item
end

function CreateItemInfoPage(name: string, amount: number, description: string, image, rarity, size, worth, biomes, baits, owned)  
  image = image or defaultImage

  -- Show Item Info
  _itemInfo:RemoveFromClassList("hidden")
  -- Clear the item info content
  _ItemInfoContent:Clear()

  -- Create the item Icon Container
  local _ItemInfoIcon = VisualElement.new()
  _ItemInfoIcon:AddToClassList("inventory__item__info-icon")
  -- Create the item info Icon Image
  local _ItemInfoImage = UIImage.new()
  _ItemInfoImage:AddToClassList("inventory__item__info__icon__image")
  _ItemInfoImage:EnableInClassList("locked", not owned)
  _ItemInfoImage.image = image

  -- Create the item info amount container
  local _ItemInfoAmount = VisualElement.new()
  _ItemInfoAmount:AddToClassList("inventory__item__info-amount")
  -- Create the item info amount text
  local _ItemInfoAmountText = UILabel.new()
  _ItemInfoAmountText:AddToClassList("inventory__item__info__amount-label")
  _ItemInfoAmountText:SetPrelocalizedText(tostring(amount))
  _ItemInfoAmount:Add(_ItemInfoAmountText)

  -- Add the item info icon and amount to the item info icon container
  _ItemInfoIcon:Add(_ItemInfoImage)
  _ItemInfoIcon:Add(_ItemInfoAmount)

  -- Create the item info name container
  local _ItemInfoName = VisualElement.new()
  _ItemInfoName:AddToClassList("inventory__item__info-name")

  -- Create the item info name text
  local _ItemInfoNameText = UILabel.new()
  _ItemInfoNameText:AddToClassList("inventory__item__info__name-label")
  _ItemInfoNameText:SetPrelocalizedText(name)
  -- Add the item info name label to the item info name container
  _ItemInfoName:Add(_ItemInfoNameText)

  -- Create the item info description container
  local _ItemInfoDescription = VisualElement.new()
  _ItemInfoDescription:AddToClassList("inventory__item__info-description")
  -- Create the item info description text
  local _ItemInfoDescriptionText = UILabel.new()
  _ItemInfoDescriptionText:AddToClassList("inventory__item__info__description-label")
  _ItemInfoDescriptionText:SetPrelocalizedText(description)
  -- Add the item info description label to the item info description container
  _ItemInfoDescription:Add(_ItemInfoDescriptionText)

  -- Create the item info stats container
  local _ItemInfoStats = VisualElement.new()
  _ItemInfoStats:AddToClassList("inventory__item__info-stats")

  -- Create the Rarity container
  local _ItemInfoRarity = VisualElement.new()
  if rarity then
    _ItemInfoRarity:AddToClassList("inventory__item__info-rarity")
    -- Create the Rarity text 1
    local _ItemInfoRarity_1 = UILabel.new()
    _ItemInfoRarity_1:AddToClassList("inventory__item__info__stat-label")
    _ItemInfoRarity_1:SetPrelocalizedText("Rarity:")
    -- Create the Rarity text 2
    local _ItemInfoRarity_2 = UILabel.new()
    _ItemInfoRarity_2:AddToClassList("inventory__item__info__stat-label")
    _ItemInfoRarity_2:SetPrelocalizedText(rarity)
    SetRarityColor(_ItemInfoRarity_2, rarity)
    -- Add the rarity 1 and 2 elements to the rarity container
    _ItemInfoRarity:Add(_ItemInfoRarity_1)
    _ItemInfoRarity:Add(_ItemInfoRarity_2)
  end

  -- Create the Size text
  local _ItemInfoSize = UILabel.new()
  if size then
    _ItemInfoSize:AddToClassList("inventory__item__info__stat-label")
    _ItemInfoSize:SetPrelocalizedText("Record Size: " .. size .. " in")
  end

  -- Create the Worth text
  local _ItemInfoWorth = UILabel.new()
  _ItemInfoWorth:AddToClassList("inventory__item__info__stat-label")
  _ItemInfoWorth:SetPrelocalizedText("Worth: " .. worth .. " coins")

  -- Create the Biome text
  local _ItemInfoBiome = UILabel.new()
  if biomes then
    _ItemInfoBiome:AddToClassList("inventory__item__info__stat-label")
    local biomeString = ""
    for k, v in pairs(biomes) do
      if k == 1 then biomeString = v else biomeString = biomeString .. ", " .. v end
    end
    _ItemInfoBiome:SetPrelocalizedText("Biome(s): " .. biomeString)
  end

  -- Create the Baits text
  local _ItemInfoBaits = UILabel.new()
  if baits then
    _ItemInfoBaits:AddToClassList("inventory__item__info-label")
    local baitString = ""
    for k, v in pairs(baits) do
      local baitName = "Any"
      if baitMetas[v] then baitName = baitMetas[v].Name end
      if k == 1 then baitString = baitName else baitString = baitString .. ", " .. baitName end
    end
    _ItemInfoBaits:SetPrelocalizedText("Bait(s): " .. baitString)
  end

  -- Add the rarity, size, worth, biomes, and baits text to the item info stats container
  if rarity then _ItemInfoStats:Add(_ItemInfoRarity) end
  if size then _ItemInfoStats:Add(_ItemInfoSize) end
  _ItemInfoStats:Add(_ItemInfoWorth)
  _ItemInfoStats:Add(_ItemInfoBiome)
  if baits then _ItemInfoStats:Add(_ItemInfoBaits) end

  -- Add the item info icon, name, description, and stats to the item info content container
  _ItemInfoContent:Add(_ItemInfoIcon)
  _ItemInfoContent:Add(_ItemInfoName)
  _ItemInfoContent:Add(_ItemInfoDescription)
  _ItemInfoContent:Add(_ItemInfoStats)
end

-- Register a callback to close the item info UI
_closeInfoButton:RegisterPressCallback(function()
  _itemInfo:AddToClassList("hidden")
  audioManager.PlaySound("paperSound1", 1)
end, true, true, true)

function ToggleVisible()
  self.gameObject:SetActive(not self.gameObject.activeSelf)
end

-- Hardcode 2 items - Example of how to create items in the inventory
function UpdateInventory(items)
  _InventoryContent:Clear()

  -- Populate the inventory with with Items depending on the Sate
  if state == 0 then
    -- Fish
    --[[ -- Add all existing fish to the journal defaulted to unowned ]]
    for i in ipairs(fishKeys) do
      local fishID = fishKeys[i]

      local itemName = fishMetas[fishID].Name
      local itemDescription = fishMetas[fishID].Description
      local fishImage = fishMetas[fishID].FishImage or defaultImage
      local itemRarity = fishMetas[fishID].Rarity
      local itemSize = playerTracker.GetPlayerFishRecord(fishID)
      local itemWorth = fishMetas[fishID].Worth
      local itemBiomes = fishMetas[fishID].Biomes
      local fishBaits = fishMetas[fishID].Baits

      -- Check if the fish is in the player's inventory
      if Utils.is_in_inventory_table(items, fishID) then
        -- The player has this Fish
        -- Get the fish's index in the player inventoy table
        local i = Utils.find_inventory_index(items, fishID)

        local item = CreateItem(items[i].amount, fishImage)
        item:AddToClassList("rarity__" .. itemRarity)

        item:RegisterPressCallback(function()
          --Show Item Info
          audioManager.PlaySound("paperSound1", 1)
          CreateItemInfoPage(itemName, items[i].amount, itemDescription, fishImage, itemRarity, itemSize, itemWorth, itemBiomes, fishBaits, true)
        end, true, true, true)

      else
        -- The player does not have this Fish
        local item = CreateItem(0, fishImage)
        item:Children()[1]:Children()[1]:AddToClassList("locked")

        item:RegisterPressCallback(function()
          --Show Item Info
          audioManager.PlaySound("paperSound1", 1)
          CreateItemInfoPage(itemName, 0, itemDescription, fishImage, itemRarity, itemSize, itemWorth, itemBiomes, fishBaits, false)
        end, true, true, true)
        
      end
    end
  elseif state == 1 then
    -- Bait
    --[[ -- Add all existing poles to the journal defaulted to unowned ]]
    for i in ipairs(baitKeys) do
      local itemID = baitKeys[i]

      local itemName = baitMetas[itemID].Name
      local itemDescription = baitMetas[itemID].Description
      local itemImage = baitMetas[itemID].ItemImage or defaultImage
      local itemLevel = baitMetas[itemID].ItemLuck
      local itemWorth = baitMetas[itemID].ItemWorth
      local itemRarity = baitMetas[itemID].ItemRarity
      local itemBiomes = baitMetas[itemID].ItemBiomes

      -- Check if the fish is in the player's inventory
      if Utils.is_in_inventory_table(items, itemID) then
        -- The player has this Fish
        -- Get the fish's index in the player inventoy table
        local i = Utils.find_inventory_index(items, itemID)

        local item = CreateItem(items[i].amount, itemImage)

        if itemID == playerTracker.GetBait() then item:EnableInClassList("equiped", true) else item:EnableInClassList("equiped", false) end
        item:RegisterPressCallback(function()
          -- EQUIP THE ITEM
          for i, element in ipairs(inventoryItems) do if element ~= item then element:EnableInClassList("equiped", false) end end
          item:ToggleInClassList("equiped")
          playerTracker.ChangeBaitRequest(itemID)
          audioManager.PlaySound("baitSound", 1)
        end, true, true, true)

        item:RegisterLongPressCallback(function()
          --Show Item Info
          audioManager.PlaySound("paperSound1", 1)
          CreateItemInfoPage(itemName, items[i].amount, itemDescription, itemImage, nil, nil, itemWorth, nil, nil, true)
        end, true, true, true)

      else
        -- The player does not have this Fish
        local item = CreateItem(0, itemImage)
        item:Children()[1]:Children()[1]:AddToClassList("locked")

        item:RegisterPressCallback(function()
          --Show Item Info
          audioManager.PlaySound("paperSound1", 1)
          CreateItemInfoPage(itemName, 0, itemDescription, itemImage, nil, nil, itemWorth, nil, nil, false)
        end, true, true, true)
        
      end
    end
    return
  elseif state == 2 then
    -- Progress
    
  elseif state == 3 then
    -- Stats
  elseif state == 4 then
    -- Quests
  end
  
end

-- Function to make life easier :P
function ButtonPressed(btn: string)

  -- Fetch the player's inventory
  local playerInventory = playerTracker.GetPlayerInventory()

  if btn == "close" then
    --ToggleVisible()
    UIManager.ButtonPressed("Close")
    return true
  elseif btn == "fish" then
    if state == 0 then return end -- Already in Fish
    state = 0
    Utils.AddRemoveClass(_pageButtonFish, "inventory__header__page--deselected", false)
    Utils.AddRemoveClass(_pageButtonFish, "inventory__header__page", true)
    Utils.AddRemoveClass(_pageButtonBait, "inventory__header__page--deselected", true)
    audioManager.PlaySound("paperSound1", 1)
    UpdateInventory(playerInventory)
    return true
  elseif btn == "bait" then
    if state == 1 then return end -- Already in Bait
    state = 1
    Utils.AddRemoveClass(_pageButtonFish, "inventory__header__page--deselected", true)
    Utils.AddRemoveClass(_pageButtonBait, "inventory__header__page--deselected", false)
    Utils.AddRemoveClass(_pageButtonBait, "inventory__header__page", true)
    audioManager.PlaySound("paperSound1", 1)
    UpdateInventory(playerInventory)
    return true
  elseif btn == "progress" then
    if state == 2 then return end -- Already in Progress
    state = 2
    Utils.AddRemoveClass(_pageButtonBait, "inventory__header__page--deselected", true)
    Utils.AddRemoveClass(_pageButtonProgress, "inventory__header__page", true)
    audioManager.PlaySound("paperSound1", 1)
    UpdateInventory(playerInventory)
    return true
  elseif btn == "stats" then
    if state == 3 then return end -- Already in Stats
    state = 3
    Utils.AddRemoveClass(_pageButtonProgress, "inventory__header__page--deselected", true)
    Utils.AddRemoveClass(_pageButtonStats, "inventory__header__page", true)
    audioManager.PlaySound("paperSound1", 1)
    UpdateInventory(playerInventory)
    return true
  elseif btn == "quests" then
    if state == 4 then return end -- Already in Quests
    state = 4
    Utils.AddRemoveClass(_pageButtonStats, "inventory__header__page--deselected", true)
    Utils.AddRemoveClass(_pageButtonQuests, "inventory__header__page", true)
    audioManager.PlaySound("paperSound1", 1)
    UpdateInventory(playerInventory)
    return true
  end
end

-- Register a callback to populate the inventory UI with Fish
_pageButtonFish:RegisterPressCallback(function()
  ButtonPressed("fish")
end, true, true, true)

-- Register a callback to populate the inventory UI with Bait
_pageButtonBait:RegisterPressCallback(function()
  ButtonPressed("bait")
end, true, true, true)

-- Register a callback to close the inventory UI
_closeButton:RegisterPressCallback(function()
  --self.gameObject:SetActive(false)
  ButtonPressed("close")
end, true, true, true)