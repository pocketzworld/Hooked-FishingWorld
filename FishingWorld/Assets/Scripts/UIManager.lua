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
--!SerializeField
local PlayerCardObject : GameObject = nil
--!SerializeField
local islandCamera : GameObject = nil

playerDisplayFishRequest = Event.new("PlayerDisplayFishRequest")
playerDisplayFishResponse = Event.new("PlayerDisplayFishResponse")

-- Required modules
local Utils = require("Utils")
local GameManager = require("GameManager")
local PlayerTracker = require("PlayerTracker")
local AudioManager = require("AudioManager")
local fishMetaData = require("FishMetaData")
local fishMetaTable = fishMetaData.fish_metadata

-- UI scripts
FishingUIScript = nil
InventoryUIScript = nil
ShopUIScript = nil
WorldHUDScript = nil
ItemPopupScript = nil
DailiesScript = nil
PlayerCardScript = nil

-- UI map for quick access
local uiMap = {
    Inventory = InventoryObject,
    Shop = ShopObject,
    WorldHUD = WorldHudObject,
    ItemPopup = ItemPopupObject,
    RewardPopup = RewardPopupObject,
    Dailies = DailiesUIObject,
    PlayerCard = PlayerCardObject
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
local function ToggleUIs(uiList, visible: boolean)
    for _, ui in ipairs(uiList) do
        ToggleUI(ui, visible)
    end
end

--- Toggles visibility for all UI components, with an optional exclusion list
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
        ToggleUI("Shop", true)
        if not ShopUIScript then
            ShopUIScript = ShopObject:GetComponent(Shop)
        end
        ShopUIScript.OpenShop()
        ShopUIScript.ButtonPressed("poles")
        AudioManager.PlaySound("coinsSound1", 1)

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

    elseif btn == "Stats" then
        ToggleAll(false)
        ToggleUI("Inventory", true)
        if not InventoryUIScript then
            InventoryUIScript = InventoryObject:GetComponent(inventory)
        end
        local playerInventory = PlayerTracker.GetPlayerInventory()
        InventoryUIScript.UpdateInventory(playerInventory)
        InventoryUIScript.ButtonPressed("stats")
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
    
    elseif btn == "PlayerCard" then
        ToggleAll(false)
        ToggleUI("PlayerCard", true)
        if not PlayerCardScript then
            PlayerCardScript = PlayerCardObject:GetComponent(playercard)
        end

        PlayerCardScript.Initialize() -- #TODO: add paramater to pass in player data
        AudioManager.PlaySound("paperSound1", 1.1)
    elseif btn == "Close" then
        ToggleAll(false)
        ToggleUIs({"WorldHUD"}, true)
        AudioManager.PlaySound("paperSound1", 0.98)
     
    elseif btn == "Map" then
        islandCamera:GetComponent(LevelSelectCamera).SwitchToMap()
        AudioManager.PlaySound("paperSound1", 1.1)
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
function UpdateSelectedBait(baitID: string, amount)
    WorldHUDScript.UpdateBaitSlot(baitID, amount)
end

--- Updates the selected pole in the HUD
function UpdateSelectedPole(poleID: string)
    WorldHUDScript.UpdatePoleSlot(poleID)
end

--- Shows the fishing mini-game
function ShowMiniGame(fishName: string, hookwidth: number)
    FishingUIScript.ShowMiniGame(fishName, hookwidth)
end

--- Hides the fishing mini-game
function HideMiniGame()
    FishingUIScript.HideMiniGame()
end

--- Shows a popup for the caught fish
function ShowFishPopup(fishID: string, size, rarity, description: string, image: Texture, worth, headerOverride)
    if not ItemPopupScript then
        ItemPopupScript = ItemPopupObject:GetComponent(ItemPopup)
    end
    ItemPopupScript.SetFish(fishID, size, rarity, description, image, worth, headerOverride)
    Utils.ActivateObject(ItemPopupObject)
    Utils.ActivateObject(RewardPopupObject)
end

function ShowPlayerFishWorld(player, fish, size)
    print(player.character.gameObject.transform:GetChild(3).gameObject.name)
    local playerFishQuad = player.character.gameObject.transform:GetChild(3).gameObject.transform:GetChild(0).gameObject
    local playerFishAnimator = playerFishQuad:GetComponent(Animator)
    local playerFishRenderer = player.character.gameObject.transform:GetChild(3).gameObject.transform:GetChild(0):GetComponent(Renderer)
    playerFishRenderer.material:SetTexture("_BaseMap", fishMetaTable[fish].FishImage)
    playerFishAnimator:SetTrigger("ShowFish")

end

--- Initializes the UI scripts on client awake
function self:ClientAwake()
    WorldHUDScript = WorldHudObject:GetComponent(worldhud)
    FishingUIScript = FishingHudObject:GetComponent(FishingHud)

    playerDisplayFishResponse:Connect(ShowPlayerFishWorld)
end



function self:ServerAwake()
    playerDisplayFishRequest:Connect(function(player, fish, size)
        playerDisplayFishResponse:FireAllClients(player, fish, size)
    end)
end