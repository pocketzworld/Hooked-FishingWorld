--!Type(Module)

--!SerializeField
local InventoryObject : GameObject = nil
--!SerializeField
local LeaderboardObject : GameObject = nil
--!SerializeField
local ShopObject : GameObject = nil
--!SerializeField
local WorldHudObject : GameObject = nil
--!SerializeField
local FishingHudObject : GameObject = nil
--!SerializeField
local ItemPopupObject : GameObject = nil
--!SerializeField
local RewardPopupObject : GameObject = nil

local Utils = require("Utils")
local gameManager = require("GameManager")
local playerTracker = require("PlayerTracker")
local audioManager = require("AudioManager")

FishingUI = nil
InventoryUI = nil
LeaderboardUI = nil
ShopUI = nil
WorldHUD = nil
itemPopup = nil
RewardPopup = nil

local uiMap = {
    Inventory = InventoryObject,
    Leaderboard = LeaderboardObject,
    Shop = ShopObject,
    WorldHUD = WorldHudObject,
    itemPopup = ItemPopupObject,
    RewardPopup = RewardPopupObject
}

ToggleInventory = function()
    if InventoryUI then
        InventoryUI.ToggleVisible()
    else
        --print("[ShowInventory] InventoryUI is not set")
    end
end

ToggleUI = function(ui: string, visible: boolean)
    local uiComponent = uiMap[ui]
    if uiComponent == nil then
        --print("[ToggleUI] UI component not found: " .. ui)
        return
    end

    if visible then
        Utils.ActivateObject(uiComponent)
    else
        Utils.DeactivateObject(uiComponent)
    end
end

ToggleUIs = function(uiList, visible: boolean)
    for _, ui in ipairs(uiList) do
        ToggleUI(ui, visible)
    end
end

ToggleAll = function(visible: boolean, except)
    for ui, component in pairs(uiMap) do
        if except and except[ui] then
            continue
        end

        if visible then
            Utils.ActivateObject(component)
        else
            Utils.DeactivateObject(component)
        end
    end
end

ButtonPressed = function(btn)
    if btn == "Leaderboard" then
        ToggleAll(false)
        ToggleUI("Leaderboard", true)

        -- Do whatever you want to do when the Leaderboard button is pressed
        local LeaderboardUI = LeaderboardObject.gameObject:GetComponent(ranking)
        LeaderboardUI.OpenLeaderboard()

    elseif btn == "Inventory" then
        ToggleAll(false)
        ToggleUI("Inventory", true)

        -- Do whatever you want to do when the Inventory button is pressed
        local InventoryUI = InventoryObject.gameObject:GetComponent(inventory)
        local playerInventory = playerTracker.GetPlayerInventory()
        InventoryUI.UpdateInventory(playerInventory)
        audioManager.PlaySound("paperSound1", 1.1)
    elseif btn == "Poles" then
        ToggleAll(false)
        ToggleUI("Inventory", true)

        -- Do whatever you want to do when the Inventory button is pressed
        local InventoryUI = InventoryObject.gameObject:GetComponent(inventory)
        local playerInventory = playerTracker.GetPlayerInventory()
        InventoryUI.UpdateInventory(playerInventory)
        InventoryUI.ButtonPressed("poles")
        audioManager.PlaySound("paperSound1", 1.1)

    elseif btn == "Bait" then
        ToggleAll(false)
        ToggleUI("Inventory", true)

        -- Do whatever you want to do when the Inventory button is pressed
        local InventoryUI = InventoryObject.gameObject:GetComponent(inventory)
        local playerInventory = playerTracker.GetPlayerInventory()
        InventoryUI.UpdateInventory(playerInventory)
        InventoryUI.ButtonPressed("bait")
        audioManager.PlaySound("paperSound1", 1.1)

    elseif btn == "Shop" then
        ToggleAll(false)
        ToggleUI("Shop", true)

        local ShopUI = ShopObject.gameObject:GetComponent(Shop)
        ShopUI.OpenShop()
        audioManager.PlaySound("coinsSound1", 1)
    elseif btn == "Deals" then
        ToggleAll(false)
        ToggleUI("Shop", true)

        local ShopUI = ShopObject.gameObject:GetComponent(Shop)
        ShopUI.OpenShop()
        ShopUI.ButtonPressed("deals")
        audioManager.PlaySound("coinsSound1", 1)
    
    elseif btn == "Close" then
        -- This works for all UIs (leaderboard, inventory, etc.)
        ToggleAll(false)
        ToggleUIs({"WorldHUD"}, true)
        audioManager.PlaySound("paperSound1", 0.98)
    end

    ----print("Button Pressed: " .. btn)
end

UpdateCash = function()
    local ShopUI = ShopObject.gameObject:GetComponent(Shop)
    if ShopUI ~= nil then if ShopUI.UpdateCashUI ~= nil then ShopUI.UpdateCashUI() else end end
    WorldHUD.UpdateCash()
end

OpenShopPage = function(page : string, itemID : string)
    ToggleAll(false)
    ToggleUI("Shop", true)

    local ShopUI = ShopObject.gameObject:GetComponent(Shop)
    ShopUI.OpenShop()
    ShopUI.ButtonPressed(page)
    ShopUI.ShowItemInfo(itemID)
end

function UpdateSelectedBait(baitID : string, amount)
    -- Update the Bait icon in the bait slot of WorldHUD
    WorldHUD.UpdateBaitSlot(baitID, amount)
end
function UpdateSelectedPole(poleID : string)
    -- Update the Pole icon in the pole slot of WorldHUD
    WorldHUD.UpdatePoleSlot(poleID)
end

function ShowMiniGame(fishName : string)
    FishingUI.ShowMiniGame(fishName)
end

function HideMiniGame()
    FishingUI.HideMiniGame()
end

function ShowFishPopup(fishID : string, size, rarity, description : string, image : Texture, worth, headerOverride)
    local itemPopupUI = ItemPopupObject.gameObject:GetComponent(ItemPopup)
    itemPopupUI.SetFish(fishID, size, rarity, description, image, worth, headerOverride)
    Utils.ActivateObject(ItemPopupObject)
    Utils.ActivateObject(RewardPopupObject)
end

function self:ClientAwake()
    WorldHUD = WorldHudObject.gameObject:GetComponent(worldhud)
    FishingUI = FishingHudObject.gameObject:GetComponent(FishingHud)
end