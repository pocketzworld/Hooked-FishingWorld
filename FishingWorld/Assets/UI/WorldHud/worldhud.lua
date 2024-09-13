--!Type(UI)

--!SerializeField
local emptyPoleIcon : Texture = nil
--!SerializeField
local emptyBaitIcon : Texture = nil

--!Bind
local _levelbar : VisualElement = nil
--!Bind
local _InventoryButton : VisualElement = nil
--!Bind 
local _ShopButton : VisualElement = nil
--!Bind
local _DailiesButton : VisualElement = nil
--!Bind
local add_cash_button : VisualElement = nil
--!Bind
local cash_text : Label = nil
--!Bind
local pole_slot : VisualElement = nil
--!Bind
local bait_slot : VisualElement = nil
--!Bind
local poleIcon : Image = nil
--!Bind
local baitIcon : Image = nil
--!Bind
local bait_text : Label = nil

--!Bind
local _playerLevelContainer : VisualElement = nil

local gameManager = require("GameManager")
local playerTracker = require("PlayerTracker")
local UIManager = require("UIManager")
local Utils = require("Utils")
local itemMetaData = require("ItemMetaData")

_playerLevelContainer:RegisterPressCallback(function()
    UIManager.ButtonPressed("PlayerCard")
end, true, true, true)

_InventoryButton:RegisterPressCallback(function()
    UIManager.ButtonPressed("Inventory")
end, true, true, true)

_ShopButton:RegisterPressCallback(function()
    UIManager.ButtonPressed("Shop")
end, true, true, true)

_DailiesButton:RegisterPressCallback(function()
    UIManager.ButtonPressed("Dailies")
end, true, true, true)

add_cash_button:RegisterPressCallback(function()
    UIManager.ButtonPressed("Deals")
end, true, true, true)

pole_slot:RegisterPressCallback(function()
    UIManager.ButtonPressed("Poles")
end, true, true, true)

bait_slot:RegisterPressCallback(function()
    UIManager.ButtonPressed("Bait")
end, true, true, true)

function UpdateBaitSlot(baitID : string, amount)
    amount = amount or 0
    if itemMetaData.bait_metadata[baitID] then
        baitIcon.image = itemMetaData.bait_metadata[baitID].ItemImage
        bait_text.text = tostring(amount)
        bait_text:RemoveFromClassList("hidden")
    else
        -- Use empty bait image
        baitIcon.image = emptyBaitIcon
        bait_text:AddToClassList("hidden")
    end
end
function UpdatePoleSlot(poleID : string)
    if itemMetaData.pole_metadata[poleID] then
        poleIcon.image = itemMetaData.pole_metadata[poleID].ItemImage
    else
        -- Use empty pole image
        poleIcon.image = emptyPoleIcon
    end
end

function UpdateCash()
    local cash = playerTracker.GetTokens(client.localPlayer)
    cash_text.text = (cash > 999 and string.format("%.1fk", cash / 1000) or tostring(cash))
end

function self:Start()
    playerTracker.players[client.localPlayer].playerXP.Changed:Connect(function(xp)
        playerTracker.players[client.localPlayer].playerLevel.Changed:Connect(function(playerLevel)
            local nextLevelXP = playerTracker.GetXPForLevel(playerLevel + 1)
            local percent = (xp / nextLevelXP)*100
            print("Lvl: ".. playerLevel .. "XP: " .. xp .. " Next Level: " .. nextLevelXP .. " Percent: " .. percent)
            _levelbar.style.width = StyleLength.new(Length.Percent(percent))
        end)
    end)
end