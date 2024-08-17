--!Type(UI)

--!SerializeField
local testImage : Texture = nil -- Test image for the shop UI

--!Bind
local cash_text : Label = nil -- Cash text for the shop UI
--!Bind
local add_cash_button : VisualElement = nil -- Add cash button for the shop UI
--!Bind
local _ShopContent : UIScrollView = nil -- Important do not remove

--!Bind
local _itemInfo : VisualElement = nil -- Important do not remove
--!Bind
local _ItemInfoContent : VisualElement = nil -- Important do not remove

--!Bind
local _closeButton : VisualElement = nil -- Close button for the shop UI
--!Bind
local _closeInfoButton : VisualElement = nil -- Close button for the item info UI

--!Bind
local _PolesButton : VisualElement = nil -- Poles button for the shop UI
--!Bind
local _BaitButton : VisualElement = nil -- Bait button for the shop UI
--!Bind
local _DealsButton : VisualElement = nil -- Backgrounds button for the shop UI

local purchaseTimer = nil

local audioManager = require("AudioManager")
local UIManager = require("UIManager")
local playerTracker = require("PlayerTracker")
local inventoryManager = require("PlayerInventoryManager")
local Utils = require("Utils")
local itemMetaData = require("ItemMetaData")
local poleMetas = itemMetaData.pole_metadata
local baitMetas = itemMetaData.bait_metadata
local dealMetas = itemMetaData.deals_metadata

-- Register a callback to close the shop UI
_closeButton:RegisterPressCallback(function()
  --self.gameObject:SetActive(false)
  UIManager.ButtonPressed("Close")
end, true, true, true)

-- Register a callback to close the item info UI
_closeInfoButton:RegisterPressCallback(function()
  _itemInfo:AddToClassList("hidden")
end, true, true, true)

function UpdateCashUI()
  print("SHOPUI: UpdateCashUI")
  local cash = playerTracker.GetTokens(client.localPlayer)
  cash_text.text = Utils.FormatNumberWithCommas(cash)
end

-- Function to create an item in the shop
function CreateItem(price: number, image: Texture, useGold)
  useGold = useGold or false

  local _ShopItem = VisualElement.new()
  _ShopItem:AddToClassList("shop__item")

  local _shopIcon = VisualElement.new()
  _shopIcon:AddToClassList("shop__item-icon")

  local _shopImage = Image.new()
  _shopImage:AddToClassList("shop__item-icon__image")
  _shopImage.image = image
  _shopIcon:Add(_shopImage)

  _ShopItem:Add(_shopIcon)

  local _shopPrice = VisualElement.new()
  _shopPrice:AddToClassList("shop__item-price")

  local _shopPriceIcon = Image.new()
  if not useGold then _shopPriceIcon:AddToClassList("shop__item-price__icon") else _shopPriceIcon:AddToClassList("package__item-price__icon") end
  _shopPrice:Add(_shopPriceIcon)

  local _shopPriceText = Label.new()
  _shopPriceText:AddToClassList("shop__item-price__label")
  _shopPriceText.text = tostring(price)
  _shopPrice:Add(_shopPriceText)

  _ShopItem:Add(_shopPrice)

  _ShopContent:Add(_ShopItem)
  return _ShopItem
end

function CreateItemInfoPage(name: string, price: number, description: string, image: Texture, is_purchased: boolean, id: string, useGold, autoHide)  
  _itemInfo:RemoveFromClassList("hidden")
  _ItemInfoContent:Clear()

  local _ItemInfoIcon = VisualElement.new()
  _ItemInfoIcon:AddToClassList("shop__item__info-icon")

  local _ItemInfoImage = UIImage.new()
  _ItemInfoImage:AddToClassList("shop__item__info__icon__image")
  _ItemInfoImage.image = image


  --[[
  local _ItemInfoAmount = VisualElement.new()
  _ItemInfoAmount:AddToClassList("shop__item__info-amount")

  local _ItemInfoAmountText = UILabel.new()
  _ItemInfoAmountText:AddToClassList("shop__item__info__amount-label")
  _ItemInfoAmountText:SetPrelocalizedText(tostring(amount))
  _ItemInfoAmount:Add(_ItemInfoAmountText)
  --]]

  _ItemInfoIcon:Add(_ItemInfoImage)
  --_ItemInfoIcon:Add(_ItemInfoAmount)

  local _ItemInfoName = VisualElement.new()
  _ItemInfoName:AddToClassList("shop__item__info-name")

  local _ItemInfoNameText = UILabel.new()
  _ItemInfoNameText:AddToClassList("shop__item__info__name-label")
  _ItemInfoNameText:SetPrelocalizedText(name)
  _ItemInfoName:Add(_ItemInfoNameText)

  local _ItemInfoDescription = VisualElement.new()
  _ItemInfoDescription:AddToClassList("shop__item__info-description")

  local _ItemInfoDescriptionText = UILabel.new()
  _ItemInfoDescriptionText:AddToClassList("shop__item__info__description-label")
  _ItemInfoDescriptionText:SetPrelocalizedText(description)
  _ItemInfoDescription:Add(_ItemInfoDescriptionText)

  _ItemInfoContent:Add(_ItemInfoIcon)
  _ItemInfoContent:Add(_ItemInfoName)
  _ItemInfoContent:Add(_ItemInfoDescription)

  if not is_purchased then
    local _BuyButton = VisualElement.new()
    _BuyButton:AddToClassList("shop__item__info-buy")

    _BuyButtonText = UILabel.new()
    _BuyButtonText:AddToClassList("shop__item__info__buy-label")
    _BuyButtonText:SetPrelocalizedText("Buy")

    local _ItemPrice = VisualElement.new()
    _ItemPrice:AddToClassList("shop__item__info-price")
  
    local _ItemPriceIcon = Image.new()
    _ItemPriceIcon:AddToClassList("shop__item__info-price__icon")
    if not useGold then _ItemPriceIcon:AddToClassList("shop__item__info-price__icon") else _ItemPriceIcon:AddToClassList("package__item__info-price__icon") end
    _ItemPrice:Add(_ItemPriceIcon)
  
    local _ItemPriceText = UILabel.new()
    _ItemPriceText:AddToClassList("shop__item__info__price-label")
    _ItemPriceText.text = tostring(price)
    _ItemPrice:Add(_ItemPriceText)

    _BuyButton:Add(_BuyButtonText)
    _BuyButton:Add(_ItemPrice)

    _ItemInfoContent:Add(_BuyButton)

    if useGold then -- Get the Product Popup instead of use Cash
      _BuyButton:RegisterPressCallback(function()
        -- Open World Product Prmopt
        playerTracker.PromtTokenPurchase(id)
      end, true, true, true)
    else -- Use Cash to buy the item
      _BuyButton:RegisterPressCallback(function()

        if playerTracker.GetTokens(client.localPlayer) >= price then

          -- Purchase Item only if the player has enough cash
          inventoryManager.PurchaseItem(id, price)

          -- Equip the item if it is bait
          if baitMetas[id] then
            playerTracker.ChangeBaitRequest(id, false)
          end

          -- remove buy button and replace with purchased
          -- Note: Do not remove this button unless the purchase is successful (Another way is if we check for the user balance and disable the button if they don't have enough cash to purchase the item)
          audioManager.PlaySound("coinsSound2", 1)
          _ItemInfoContent:Remove(_BuyButton)
          CreatePurhcasedButton(autoHide, _BuyButton)
        end
      end, true, true, true)
    end
  else
    -- Display purchased
    CreatePurhcasedButton()
  end
    
end

function CreatePurhcasedButton(autoHide, buyButton)
  local _Purchased = VisualElement.new()
  _Purchased:AddToClassList("shop__item__info-purchased")

  _PurchasedText = UILabel.new()
  _PurchasedText:AddToClassList("shop__item__info__purchased-label")
  _PurchasedText:SetPrelocalizedText("Purchased")

  _Purchased:Add(_PurchasedText)

  _ItemInfoContent:Add(_Purchased)

  if autoHide then
    -- Hide the purchased button after 1 seconds
    purchaseTimer = Timer.After(1, function()
      _ItemInfoContent:Remove(_Purchased)
      _ItemInfoContent:Add(buyButton)
    end)
  end
end

local state = 0 -- 0 = Poles, 1 = Bait, 2 = Deals

-- Poles Sorted by Price
local Poles = {
  -- Affordable - 99g
  --{id = "fishing_pole_1"},
  {id = "fishing_pole_2"},
  {id = "fishing_pole_3"},
  {id = "fishing_pole_5"}
}

local Bait = {
  {id = "sadworm_bait"},
  {id = "corn_bait"},
  {id = "plastic_bait"},
  {id = "maggot_bait"},
  {id = "grub_bait"},
  {id = "toast_bait"},
  {id = "bacon_bait"},
  {id = "broccoli_bait"},
  {id = "chicken_bait"},
  {id = "egg_bait"},
  {id = "hotdog_bait"},
  {id = "pizza_bait"},
  {id = "shrimp_bait"},
  {id = "squid_bait"},
  {id = "steak_bait"},
  {id = "donut_bait"}
}

local Deals = {
  {id = "fishing_token_1"},
  {id = "fishing_token_2"},
  {id = "fishing_token_3"}
}

function PopulateShop(items)
  _ShopContent:Clear()
  if items == nil then return end

  if state == 0 then -- check if items are poles
    for i = 1, #items do
      if poleMetas[items[i].id] then
        -- Create Item Meta Data based on ID
        local itemMeta = poleMetas[items[i].id]
    
        local itemPrice = itemMeta.ItemWorth
        local itemImage = itemMeta.ItemImage
        local itemDescription = itemMeta.Description
        local itemName = itemMeta.Name

        local useGold = false
    
        local item = CreateItem(itemPrice, itemImage, useGold)
      
        item:RegisterPressCallback(function()
          --Show Item Info
          local is_purchased = false

          --print the inventory keys
          for key, value in playerTracker.players[client.localPlayer].playerInventory.value do
            if value.id == items[i].id then
              is_purchased = true
              break
            end
          end

          CreateItemInfoPage(itemName, itemPrice, itemDescription, itemImage, is_purchased, items[i].id, useGold)
          if purchaseTimer then purchaseTimer:Stop(); purchaseTimer = nil end
        end, true, true, true)
    
      end
    end
  elseif state == 1 then -- check if items are bait
    for i = 1, #items do
      if baitMetas[items[i].id] then
        -- Create Item Meta Data based on ID
        local itemMeta = baitMetas[items[i].id]
    
        local itemPrice = itemMeta.ItemWorth
        local itemImage = itemMeta.ItemImage
        local itemDescription = itemMeta.Description
        local itemName = itemMeta.Name

        local useGold = false
    
        local item = CreateItem(itemPrice, itemImage, useGold)
      
        item:RegisterPressCallback(function()
          --Show Item Info
          CreateItemInfoPage(itemName, itemPrice, itemDescription, itemImage, false, items[i].id, useGold, true)
          if purchaseTimer then purchaseTimer:Stop(); purchaseTimer = nil end
        end, true, true, true)
    
      end
    end
  elseif state == 2 then -- check if items are deals
    for i = 1, #items do
      if dealMetas[items[i].id] then
        -- Create Item Meta Data based on ID
        local itemMeta = dealMetas[items[i].id]
    
        local itemPrice = itemMeta.ItemWorth
        local itemImage = itemMeta.ItemImage
        local itemDescription = itemMeta.Description
        local itemName = itemMeta.Name

        local useGold = true
    
        local item = CreateItem(itemPrice, itemImage, useGold)
      
        item:RegisterPressCallback(function()
          --Show Item Info
          CreateItemInfoPage(itemName, itemPrice, itemDescription, itemImage, false, items[i].id, useGold)
          if purchaseTimer then purchaseTimer:Stop(); purchaseTimer = nil end
        end, true, true, true)
    
      end
    end
  end

end

function OpenShop()
  _ShopContent:Clear()

  local cash = playerTracker.GetTokens(client.localPlayer)
  cash_text.text = Utils.FormatNumberWithCommas(cash)

  _itemInfo:AddToClassList("hidden")
  -- Populate the shop per the state
  if state == 0 then -- Poles
    PopulateShop(Poles)
  elseif state == 1 then -- Bait
    PopulateShop(Bait)
  elseif state == 2 then -- Deals
    PopulateShop(Deals)
  else
    return
  end
end

-- Function to make life easier :P
function ButtonPressed(btn: string)
  if btn == "close" then
    --ToggleVisible()
    UIManager.ButtonPressed("Close")
    return true
  elseif btn == "Poles" then
    if state == 0 then return end -- Already in Poles
    state = 0
    Utils.AddRemoveClass(_PolesButton, "nav-button--deselected", false)
    Utils.AddRemoveClass(_PolesButton, "nav-button--selected", true)
    Utils.AddRemoveClass(_BaitButton, "nav-button--deselected", true)
    Utils.AddRemoveClass(_DealsButton, "nav-button--deselected", true)
    PopulateShop(Poles)
    audioManager.PlaySound("paperSound1", 1)
    return true
  elseif btn == "Bait" then
    if state == 1 then return end -- Already in Bait
    state = 1
    Utils.AddRemoveClass(_PolesButton, "nav-button--deselected", true)
    Utils.AddRemoveClass(_BaitButton, "nav-button--deselected", false)
    Utils.AddRemoveClass(_BaitButton, "nav-button--selected", true)
    Utils.AddRemoveClass(_DealsButton, "nav-button--deselected", true)
    PopulateShop(Bait)
    audioManager.PlaySound("paperSound1", 1)
    return true
  elseif btn == "deals" then
    state = 2
    Utils.AddRemoveClass(_PolesButton, "nav-button--deselected", true)
    Utils.AddRemoveClass(_BaitButton, "nav-button--deselected", true)
    Utils.AddRemoveClass(_DealsButton, "nav-button--deselected", false)
    Utils.AddRemoveClass(_DealsButton, "nav-button--selected", true)
    PopulateShop(Deals)
    audioManager.PlaySound("paperSound1", 1)
    return true
  end
end

_PolesButton:RegisterPressCallback(function()
  local success = ButtonPressed("Poles")
end, true, true, true)

_BaitButton:RegisterPressCallback(function()
  local success = ButtonPressed("Bait")
end, true, true, true)

_DealsButton:RegisterPressCallback(function()
  local success = ButtonPressed("deals")
end, true, true, true)

-- Register a callback to add cash to the player
add_cash_button:RegisterPressCallback(function()
  ButtonPressed("deals")
end, true, true, true)