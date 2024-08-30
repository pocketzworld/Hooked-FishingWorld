--!Type(Module)

-- Serialized fields for UI components
--!SerializeField
local InventoryObject : GameObject = nil
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
--!SerializeField
local DailiesUIObject : GameObject = nil

-- Required modules
local Utils = require("Utils")
local GameManager = require("GameManager")
local PlayerTracker = require("PlayerTracker")
local AudioManager = require("AudioManager")

-- UI scripts
FishingUIScript = nil
InventoryUIScript = nil
ShopUIScript = nil
WorldHUDScript = nil
ItemPopupScript = nil
DailiesScript = nil

-- UI map for quick access
local uiMap = {
    Inventory = InventoryObject,
    Shop = ShopObject,
    WorldHUD = WorldHudObject,
    ItemPopup = ItemPopupObject,
    RewardPopup = RewardPopupObject,
    Dailies = DailiesUIObject
}

--- Toggles the visibility of the Inventory UI
function ToggleInventory()
    if InventoryUIScript then
        InventoryUIScript.ToggleVisible()
    else
        print("[ToggleInventory] InventoryUIScript is not set")
    end
end

--- Toggles the visibility of a specific UI component
-- @param ui The UI component name
-- @param visible Boolean indicating whether to show or hide the UI
local function ToggleUI(ui: string, visible: boolean)
    local uiComponent = uiMap[ui]
    if not uiComponent then
        print("[ToggleUI] UI component not found: " .. ui)
        return
    end

    if visible then
        Utils.ActivateObject(uiComponent)
    else
        Utils.DeactivateObject(uiComponent)
    end
end

--- Toggles visibility for multiple UI components
-- @param uiList Table of UI component names to toggle
-- @param visible Boolean indicating whether to show or hide the UIs
local function ToggleUIs(uiList, visible: boolean)
    for _, ui in ipairs(uiList) do
        ToggleUI(ui, visible)
    end
end

--- Toggles visibility for all UI components, with an optional exclusion list
-- @param visible Boolean indicating whether to show or hide the UIs
-- @param except Table of UI component names to exclude from toggling
local function ToggleAll(visible: boolean, except)
    for ui, component in pairs(uiMap) do
        if not (except and except[ui]) then
            if visible then
                Utils.ActivateObject(component)
            else
                Utils.DeactivateObject(component)
            end
        end
    end
end

--- Handles button press actions
-- @param btn The button name
function ButtonPressed(btn: string)
    if btn == "Inventory" then
        ToggleAll(false)
        ToggleUI("Inventory", true)
        if not InventoryUIScript then
            InventoryUIScript = InventoryObject:GetComponent(inventory)
        end
        local playerInventory = PlayerTracker.GetPlayerInventory()
        InventoryUIScript.UpdateInventory(playerInventory)
        AudioManager.PlaySound("paperSound1", 1.1)
        
    elseif btn == "Poles" then
        ToggleAll(false)
        ToggleUI("Inventory", true)
        if not InventoryUIScript then
            InventoryUIScript = InventoryObject:GetComponent(inventory)
        end
        local playerInventory = PlayerTracker.GetPlayerInventory()
        InventoryUIScript.UpdateInventory(playerInventory)
        InventoryUIScript.ButtonPressed("poles")
        AudioManager.PlaySound("paperSound1", 1.1)

    elseif btn == "Bait" then
        ToggleAll(false)
        ToggleUI("Inventory", true)
        if not InventoryUIScript then
            InventoryUIScript = InventoryObject:GetComponent(inventory)
        end
        local playerInventory = PlayerTracker.GetPlayerInventory()
        InventoryUIScript.UpdateInventory(playerInventory)
        InventoryUIScript.ButtonPressed("bait")
        AudioManager.PlaySound("paperSound1", 1.1)

    elseif btn == "Shop" then
        ToggleAll(false)
        ToggleUI("Shop", true)
        if not ShopUIScript then
            ShopUIScript = ShopObject:GetComponent(Shop)
        end
        ShopUIScript.OpenShop()
        AudioManager.PlaySound("coinsSound1", 1)

    elseif btn == "Deals" then
        ToggleAll(false)
        ToggleUI("Shop", true)
        if not ShopUIScript then
            ShopUIScript = ShopObject:GetComponent(Shop)
        end
        ShopUIScript.OpenShop()
        ShopUIScript.ButtonPressed("deals")
        AudioManager.PlaySound("coinsSound1", 1)

    elseif btn == "Dailies" then
        ToggleAll(false)
        ToggleUI("Dailies", true)
        if not DailiesScript then
            DailiesScript = DailiesUIObject:GetComponent(dailyrewards)
        end
        DailiesScript.PopulateRewards()
        AudioManager.PlaySound("paperSound1", 1.1)

    elseif btn == "Close" then
        ToggleAll(false)
        ToggleUIs({"WorldHUD"}, true)
        AudioManager.PlaySound("paperSound1", 0.98)
    else
        print("[ButtonPressed] Unhandled button: " .. btn)
    end
end

--- Updates the cash display in the UI
function UpdateCash()
    if ShopUIScript == nil then
        ShopUIScript = ShopObject:GetComponent(Shop)
    end
    if ShopUIScript and ShopUIScript.UpdateCashUI then
        ShopUIScript.UpdateCashUI()
    else
        print("[UpdateCash] ShopUIScript or UpdateCashUI not found")
    end
    if WorldHUDScript and WorldHUDScript.UpdateCash then
        WorldHUDScript.UpdateCash()
    else
        print("[UpdateCash] WorldHUDScript or UpdateCash not found")
    end
end

--- Opens the shop and displays a specific page and item
-- @param page The shop page to open
-- @param itemID The item ID to display
function OpenShopPage(page: string, itemID: string)
    ToggleAll(false)
    ToggleUI("Shop", true)
    if not ShopUIScript then
        ShopUIScript = ShopObject:GetComponent(Shop)
    end
    ShopUIScript.OpenShop()
    ShopUIScript.ButtonPressed(page)
    ShopUIScript.ShowItemInfo(itemID)
end

--- Updates the selected bait in the HUD
-- @param baitID The bait ID
-- @param amount The amount of bait
function UpdateSelectedBait(baitID: string, amount)
    WorldHUDScript.UpdateBaitSlot(baitID, amount)
end

--- Updates the selected pole in the HUD
-- @param poleID The pole ID
function UpdateSelectedPole(poleID: string)
    WorldHUDScript.UpdatePoleSlot(poleID)
end

--- Shows the fishing mini-game
-- @param fishName The name of the fish
function ShowMiniGame(fishName: string)
    FishingUIScript.ShowMiniGame(fishName)
end

--- Hides the fishing mini-game
function HideMiniGame()
    FishingUIScript.HideMiniGame()
end

--- Shows a popup for the caught fish
-- @param fishID The fish ID
-- @param size The size of the fish
-- @param rarity The rarity of the fish
-- @param description The description of the fish
-- @param image The image of the fish
-- @param worth The worth of the fish
-- @param headerOverride Optional header override
function ShowFishPopup(fishID: string, size, rarity, description: string, image: Texture, worth, headerOverride)
    if not ItemPopupScript then
        ItemPopupScript = ItemPopupObject:GetComponent(ItemPopup)
    end
    ItemPopupScript.SetFish(fishID, size, rarity, description, image, worth, headerOverride)
    Utils.ActivateObject(ItemPopupObject)
    Utils.ActivateObject(RewardPopupObject)
end

--- Initializes the UI scripts on client awake
function self:ClientAwake()
    WorldHUDScript = WorldHudObject:GetComponent(worldhud)
    FishingUIScript = FishingHudObject:GetComponent(FishingHud)
end