--!Type(UI)

--!Bind
local _headerTitle : Label = nil -- Important do not remove

--!Bind
local _InventoryContent : UIScrollView = nil -- Important do not remove

--!Bind
local _itemInfo : VisualElement = nil -- Important do not remove
--!Bind
local _tooltip : VisualElement = nil -- Important do not remove
--!Bind
local _ItemInfoContent : VisualElement = nil -- Important do not remove
--!Bind
local _closeTooltipButton  : VisualElement = nil -- Important do not remove

--!Bind
local _pageButtonFish : VisualElement = nil -- Important do not remove
--!Bind
local _pageButtonBait : VisualElement = nil -- Important do not remove
--!Bind
local _pageButtonProgress : VisualElement = nil -- Important do not remove
--!Bind
local _pageButtonStats : VisualElement = nil -- Important do not remove

--local _pageButtonQuests : VisualElement = nil -- Important do not remove

--!Bind
local _tooltipTitle : Label = nil -- Important do not remove
--!Bind
local _tooltipDescription : Label = nil -- Important do not remove

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

--#TODO: Hard coded stuff needs to be changed.

local HardcodedStats = {
  {name = "Level", value = 1},
  {name = "XP", value = 0},
  {name = "XP Modifier", value = 1},
  {name = "Strength", value = 1},
  {name = "Hook Speed", value = 1},
  {name = "Reel Speed", value = 1}
}

function SetPlayerStats()
  UpdateInventory(playerTracker.GetPlayerInventory())
end

local HardcodedQuests = {
  {
    title = "Upgrade Fishing Pole to Level 2",
    reward = 200,
    description = "Visit the shop and upgrade your fishing pole to level 2 to improve your fishing skills.",
    progress = 100,
    completed = true
  },
  {
    title = "Catch Your First Fish",
    reward = 150,
    description = "Head to the river and catch your first fish.",
    progress = 100,
    completed = true
  },
  {
    title = "Catch 5 Fish",
    reward = 300,
    description = "Prove your skills by catching 5 fish from the river.",
    progress = 60,
    completed = false
  },
  {
    title = "Sell a Fish at the Market",
    reward = 100,
    description = "Sell one of your freshly caught fish at the local market.",
    progress = 0,
    completed = false
  },
  {
    title = "Catch a Rare Fish",
    reward = 500,
    description = "Find and catch a rare fish species in the river.",
    progress = 0,
    completed = false
  },
  {
    title = "Upgrade Pole to Level 3",
    reward = 300,
    description = "Upgrade your fishing pole to level 3 for better performance.",
    progress = 25,
    completed = false
  },
  {
    title = "Participate in a Fishing Contest",
    reward = 400,
    description = "Join the local fishing contest and compete with others.",
    progress = 0,
    completed = false
  },
  {
    title = "Catch 10 Fish",
    reward = 600,
    description = "Demonstrate your expertise by catching a total of 10 fish.",
    progress = 40,
    completed = false
  },
  {
    title = "Buy Bait from the Shop",
    reward = 50,
    description = "Purchase fishing bait from the shop to improve your chances of catching fish.",
    progress = 0,
    completed = false
  },
  {
    title = "Catch a Legendary Fish",
    reward = 1000,
    description = "Become a fishing legend by catching the rarest fish in the river.",
    progress = 0,
    completed = false
  }
}

function CreateToolTipItem(tooltip_title: string, tooltip_description: string)
  _tooltip:RemoveFromClassList("hidden")

  _tooltipTitle.text = tooltip_title
  _tooltipDescription.text = tooltip_description
end


function CreateProgressItem(progress_title: string, progress_xp: number, progress_description: string, progress_progress: number | nil, max_progress: number, tooltipData: {title: string, description: string})
  local _progress_item = VisualElement.new()
  _progress_item:AddToClassList("progress-item")

  local _progress_left_side = VisualElement.new()
  _progress_left_side:AddToClassList("progress-left-side")

  local _progress_title = VisualElement.new()
  _progress_title:AddToClassList("progress-title")
  
  local _progress_title_text = Label.new()
  _progress_title_text:AddToClassList("progress-title-text")
  if progress_title then
    _progress_title_text.text = progress_title
  else
    print("progress_title is nil")
    _progress_title_text.text = "Level Placeholder"
  end
  _progress_title:Add(_progress_title_text)

  local _progress_title_xp = Label.new()
  _progress_title_xp:AddToClassList("progress-title-xp")
  if progress_xp then
    _progress_title_xp.text = progress_xp .. " XP"
  else
    print("progress_xp is nil")
    _progress_title_xp.text = "Nil XP"
  end

  _progress_title:Add(_progress_title_xp)
  _progress_left_side:Add(_progress_title)

  local _progress_description = VisualElement.new()
  _progress_description:AddToClassList("progress-description")

  local _progress_description_text = Label.new()
  _progress_description_text:AddToClassList("progress-description-text")
  if progress_description then
    _progress_description_text.text = progress_description
  else
    print("progress_description is nil")
    _progress_description_text.text = "Description"
  end
  _progress_description:Add(_progress_description_text)
  _progress_left_side:Add(_progress_description)

  local _progress_bar = VisualElement.new()
  _progress_bar:AddToClassList("progress-bar")

  local _progress_bar_fill = VisualElement.new()
  _progress_bar_fill:AddToClassList("progress-bar-fill")
  if progress_progress then
    local width = Length.Percent(progress_progress / max_progress * 100)
    _progress_bar_fill.style.width = StyleLength.new(width)
  else
    print("progress_progress is nil")
    _progress_bar_fill.style.width = StyleLength.new(Length.Percent(1))
  end
  
  _progress_bar:Add(_progress_bar_fill)
  _progress_left_side:Add(_progress_bar)
  _progress_item:Add(_progress_left_side)

  local _progress_right_side = VisualElement.new()
  _progress_right_side:AddToClassList("progress-right-side")

  local _tooltip_icon = Image.new()
  _tooltip_icon:AddToClassList("tooltip-icon")

  _tooltip_icon:RegisterPressCallback(function()
    local tooltip_title = tooltipData.title
    local tooltip_description = tooltipData.description

    CreateToolTipItem(tooltip_title, tooltip_description)
  end, true, true, true)

  _progress_right_side:Add(_tooltip_icon)
  _progress_item:Add(_progress_right_side)

  _InventoryContent:Add(_progress_item)
  return _progress_item
end


-- Descriptions are optional and based on the player level, to have a better design, you can add a description for each level
local HardcodedPlayerData = {
  level = 1,
  experience = 45000,
  xp_to_next_level = 50000,
  description = "You are a beginner fisherman. Keep fishing to level up!"
}

local HardcodedRodData = {
  level = 1,
  experience = 20000,
  xp_to_next_level = 50000,
  description = "Your rod is getting rusty. Time to upgrade!"
}


function CreateQuestItem(quest_title: string, quest_reward: number, quest_description: string, quest_progress: number | nil, is_completed: boolean)
  local _quest_item = VisualElement.new()
  _quest_item:AddToClassList("quest-item")
  if is_completed then _quest_item:AddToClassList("completed") end

  local _left_side = VisualElement.new()
  _left_side:AddToClassList("left-side")

  local _quest_title = VisualElement.new()
  _quest_title:AddToClassList("quest-title")

  local _quest_title_text = Label.new()
  _quest_title_text:AddToClassList("quest-title-text")
  if quest_title then
    _quest_title_text.text = "Upgrade pole to Level 2"
  else
    print("quest_title is nil")
    _quest_title_text.text = "Quest Title"
  end
  _quest_title:Add(_quest_title_text)

  local _quest_reward_text = Label.new()
  _quest_reward_text:AddToClassList("quest-reward-text")
  if quest_reward then
    _quest_reward_text.text = "+" .. tostring(quest_reward) .. " XP"
  else
    print("quest_reward is nil")
    _quest_reward_text.text = "+nil XP"
  end

  _quest_title:Add(_quest_reward_text)
  _left_side:Add(_quest_title)

  local _quest_description = VisualElement.new()
  _quest_description:AddToClassList("quest-description")

  local _quest_description_text = Label.new()
  _quest_description_text:AddToClassList("quest-description-text")
  if quest_description then
    _quest_description_text.text = "Go to the shop and upgrade your fishing pole to level 2"
  else
    print("quest_description is nil")
    _quest_description_text.text = "Quest Description"
  end

  _quest_description:Add(_quest_description_text)
  _left_side:Add(_quest_description)

  local _quest_progress = VisualElement.new()
  _quest_progress:AddToClassList("quest-progress")

  local _quest_progress_fill = VisualElement.new()
  _quest_progress_fill:AddToClassList("quest-progress-fill")
  if quest_progress then
    local width = Length.Percent(quest_progress / 100 * 100)
    _quest_progress_fill.style.width = StyleLength.new(width)
  else
    print("quest_progress is nil")
    _quest_progress_fill.style.width = StyleLength.new(Length.Percent(1))
  end

  _quest_progress:Add(_quest_progress_fill)
  _left_side:Add(_quest_progress)
  _quest_item:Add(_left_side)

  local _right_side = VisualElement.new()
  _right_side:AddToClassList("right-side")

  local _arrow_icon = Image.new()
  _arrow_icon:AddToClassList("arrow-icon")
  _right_side:Add(_arrow_icon)
  _quest_item:Add(_right_side)

  _InventoryContent:Add(_quest_item)
  return _quest_item
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

function CreateStatsItem(name: string, value: number)
  local _StatsItem = VisualElement.new()
  _StatsItem:AddToClassList("stats-item")

  local _StatsItemTitle = Label.new()
  _StatsItemTitle:AddToClassList("stats-item__title")
  _StatsItemTitle.text = name

  local _StatsItemValue = Label.new()
  _StatsItemValue:AddToClassList("stats-item__value")
  _StatsItemValue.text = tostring(value)

  _StatsItem:Add(_StatsItemTitle)
  _StatsItem:Add(_StatsItemValue)

  _InventoryContent:Add(_StatsItem)

  return _StatsItem
end

-- Register a callback to close the item info UI
_closeInfoButton:RegisterPressCallback(function()
  _itemInfo:AddToClassList("hidden")
  audioManager.PlaySound("paperSound1", 1)
end, true, true, true)

-- Register a callback to close the item info UI
_closeTooltipButton:RegisterPressCallback(function()
  _tooltip:AddToClassList("hidden")
  audioManager.PlaySound("paperSound1", 1)
end, true, true, true)

function ToggleVisible()
  self.gameObject:SetActive(not self.gameObject.activeSelf)
end

-- Hardcode 2 items - Example of how to create items in the inventory
function UpdateInventory(items)
  if state == 10 then 
    -- Testing purposes, edit inventory.uxml without clearing the inventory
    return
  end

  _InventoryContent:Clear()
  _InventoryContent:ScrollToBeginning()

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
    local playerData = HardcodedPlayerData
    local rodData = HardcodedRodData

    local tooltipPlayerData = {title = "Player", description = "Player Progress"} -- Change this to teach the player more about the player progress
    local tooltipRodData = {title = "Fishing Rod", description = "Fishing Rod Progress"} -- Change this to teach the player more about the rod progress

    local playerProgress = CreateProgressItem("Player Level: " .. tostring(playerData.level), playerData.experience, playerData.description, playerData.experience, playerData.xp_to_next_level, {title = tooltipPlayerData.title, description = tooltipPlayerData.description})
    local rodProgress = CreateProgressItem("Rod Level: " .. tostring(rodData.level), rodData.experience, rodData.description, rodData.experience, rodData.xp_to_next_level, {title = tooltipRodData.title, description = tooltipRodData.description})
    
  elseif state == 3 then
    -- Stats
    print("Show Stats")
    for i, stat in ipairs(HardcodedStats) do
      local statsItem = CreateStatsItem(stat.name, stat.value)
    end
  elseif state == 4 then
    -- Quests
    --Sort quests by completed and display not completed first
    table.sort(HardcodedQuests, function(a, b) return not a.completed and b.completed end)

    -- Display all quests
    for i, quest in ipairs(HardcodedQuests) do
      local questItem = CreateQuestItem(quest.title, quest.reward, quest.description, quest.progress, quest.completed)
    end
  end
  
end


-- An easier way to manage the buttons ^_^
local buttons = {
  fish = { element = _pageButtonFish, state = 0, title = "Fish Collection" },
  bait = { element = _pageButtonBait, state = 1, title = "Owned Bait" },
  progress = { element = _pageButtonProgress, state = 2, title = client.localPlayer.name .. "'s Progress" },
  stats = { element = _pageButtonStats, state = 3, title = client.localPlayer.name .. "'s Stats" },
  --quests = { element = _pageButtonQuests, state = 4, title = "Quests" }
}

-- Function to make life easier :P
function ButtonPressed(btn: string)
  -- Fetch the player's inventory
  local playerInventory = playerTracker.GetPlayerInventory()

  if btn == "close" then
      --ToggleVisible()
      UIManager.ButtonPressed("Close")
      return true
  end

  -- Check if the button exists in the buttons table
  local buttonInfo = buttons[btn]
  if buttonInfo then
      if state == buttonInfo.state then return end -- Already in the selected state

      -- Update header title
      _headerTitle.text = buttonInfo.title

      -- Update state
      state = buttonInfo.state

      -- Update classes for all buttons
      for key, info in pairs(buttons) do
          Utils.AddRemoveClass(info.element, "inventory__header__page--deselected", key ~= btn)
          Utils.AddRemoveClass(info.element, "inventory__header__page", key == btn)
      end

      -- Play sound and update inventory
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

--[[
_pageButtonQuests:RegisterPressCallback(function()
  ButtonPressed("quests")
end, true, true, true)
]]

_pageButtonStats:RegisterPressCallback(function()
  ButtonPressed("stats")
end, true, true, true)

_pageButtonProgress:RegisterPressCallback(function()
  ButtonPressed("progress")
end, true, true, true)

-- Register a callback to close the inventory UI
_closeButton:RegisterPressCallback(function()
  --self.gameObject:SetActive(false)
  ButtonPressed("close")
end, true, true, true)


function self:Start()
  local playerInfo = playerTracker.players[client.localPlayer]
  playerInfo.playerLevel.Changed:Connect(function(lvl)
    HardcodedStats[1] = {name = "Level", value = lvl}
  end)
  playerInfo.playerXP.Changed:Connect(function(xp)
    print("XP Changed")
    HardcodedStats[2] = {name = "XP", value = xp}
  end)
  playerInfo.playerXPModifier.Changed:Connect(function(xpMod)
    HardcodedStats[3] = {name = "XP Modifier", value = xpMod}
  end)
  playerInfo.playerStrength.Changed:Connect(function(Str)
    HardcodedStats[4] = {name = "Strength", value = Str}
  end)
  playerInfo.playerHookSpeed.Changed:Connect(function(hookSpeed)
    HardcodedStats[5] = {name = "Hook Speed", value = hookSpeed}
  end)
  playerInfo.playerReelSpeed.Changed:Connect(function(reelSpeed)
    HardcodedStats[6] = {name = "Reel Speed", value = reelSpeed}
  end)
end