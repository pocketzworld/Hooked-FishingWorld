--!Type(UI)

--!SerializeField
local popupIconOBJ : GameObject = nil

--!Bind
local root : UILuaView = nil
--!Bind
local item_popup : VisualElement = nil
--!Bind
local item_popup_header : VisualElement = nil
--!Bind
local item_popup_stats : VisualElement = nil
--!Bind
local fish_label : Label = nil
--!Bind
local fish_size : Label = nil
--!Bind
local fish_rarity : Label = nil
--!Bind
local fish_description : Label = nil
--!Bind
local confirmText : Label = nil
--!Bind
local popup_header : Label = nil
--!Bind
local fish_price : Label = nil

local canClose = false

local uiManager = require("UIManager")
local fishMetaData = require("FishMetaData")

function SetRarityColor(element, rarity)
    element:RemoveFromClassList("rarity__Common")
    element:RemoveFromClassList("rarity__Uncommon")
    element:RemoveFromClassList("rarity__Rare")
    element:RemoveFromClassList("rarity__Epic")
    element:RemoveFromClassList("rarity__Legendary")
    element:RemoveFromClassList("rarity__Mythical")

    element:AddToClassList("rarity__" .. rarity)
end

function SetFish(popupTitle : string, size, rarity, description : string, image, price, headerOverride)
    canClose = false
    local isFish = fishMetaData.IsFish(popupTitle)

    if isFish then 
        -- If the popup Title is a FISH ID
        fish_label.text = fishMetaData.fish_metadata[popupTitle].Name
        fish_size.text = "(" .. tostring(size) .. " in" .. ")"
        fish_rarity.text = "(" .. rarity .. ")"
        fish_price.text = "Worth " .. tostring(price) .. " coins!" 
        SetRarityColor(fish_rarity, rarity) 
        confirmText.text = "The fish has been added to your Journal..."
        popup_header.text = "You Caught A"

        item_popup_stats:RemoveFromClassList("hidden")
        fish_price:RemoveFromClassList("hidden")

    else
        fish_label.text = popupTitle
        popup_header.text = tostring(headerOverride) or ""
        fish_rarity.text = ""
        fish_size.text = ""
        confirmText.text = "Continue..."
        item_popup_stats:AddToClassList("hidden")
        fish_price:AddToClassList("hidden")
    end

    fish_description.text = description

    Timer.After(0.5, function() canClose = true end)

    if image then
        local worldIconUI = popupIconOBJ:GetComponent(FishIconWorld)
        worldIconUI.SetIcon(image)
    else
        --print("No image for the fish")
    end
end

root:RegisterPressCallback(function()
    if canClose then Timer.After(0.1, function() uiManager.ButtonPressed("Close") end) end
end, canClose, canClose, canClose)

function self:ClientStart()
    uiManager.ButtonPressed("Close")
end