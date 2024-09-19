--!Type(UI)

--!SerializeField
local testImage : Texture = nil -- Test image for the shop UI

--!Bind
local _Shop : UILuaView = nil -- Shop UI

--!Bind
local cash_text : Label = nil -- Cash text for the shop UI
--!Bind
local add_cash_button : VisualElement = nil -- Add cash button for the shop UI
--!Bind
local _ShopContent : VisualElement = nil -- Important do not remove
--!Bind
local _ShopContentContainer : UIScrollView = nil -- Important do not remove

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

--!Bind
local _contentHeaderIcon : VisualElement = nil
--!Bind
local _contentHeaderLabel : UILabel = nil -- Content header label for the shop UI

local missingCoinsModalOpen = false

local purchaseTimer = nil

local upgradeCost = 100
local maxedOut = false

local audioManager = require("AudioManager")
local UIManager = require("UIManager")
local playerTracker = require("PlayerTracker")
local inventoryManager = require("PlayerInventoryManager")
local Utils = require("Utils")
local itemMetaData = require("ItemMetaData")
local poleMetas = itemMetaData.pole_metadata
local baitMetas = itemMetaData.bait_metadata
local dealMetas = itemMetaData.deals_metadata

local state = 0 -- 0 = Poles, 1 = Bait, 2 = Deals

-- Poles Sorted by Price
local Poles = {
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

-- Register a callback to close the shop UI
_closeButton:RegisterPressCallback(function()
  --self.gameObject:SetActive(false)
  UIManager.ButtonPressed("Close")
end, true, true, true)

-- Register a callback to close the item info UI
_closeInfoButton:RegisterPressCallback(function()
  _itemInfo:RemoveFromClassList("open")
  _itemInfo:AddToClassList("hidden")
end, true, true, true)

function UpgradeRodCallback()
  if missingCoinsModalOpen then return end
  -- Check if the player has enough coins to upgrade the rod
  if playerTracker.GetTokens(client.localPlayer) >= upgradeCost then
    print("UPGRADING ROD FOR " .. upgradeCost .. " coins")
    playerTracker.UpgradePoleRequest()
  else
    -- Display missing coins modal
    missingCoinsModalOpen = true
    local missingCoinsModal = CreateMissingCoinsModal()
    _Shop:Add(missingCoinsModal)

    Timer.After(0.1, function()
      missingCoinsModal:EnableInClassList("open", true)
    end)
  
  end
end

function UpdateCashUI()
  --print("SHOPUI: UpdateCashUI")
  local cash = playerTracker.GetTokens(client.localPlayer)
  cash_text.text = Utils.FormatNumberWithCommas(cash)
end

-- Function to create an item in the shop
function CreateItem(price: number, image: Texture, useGold, item_type: string, item_name: string)
  useGold = useGold or false

  local _ShopItem = VisualElement.new()
  _ShopItem:AddToClassList("shop__item")

  --if item_type and item_type == "item_bait" then
  local _itemName = VisualElement.new()
  _itemName:AddToClassList("shop__item-name")

  local _itemNameText = Label.new()
  _itemNameText:AddToClassList("shop__item__name-label")
  _itemNameText.text = item_name

  _itemName:Add(_itemNameText)
  _ShopItem:Add(_itemName)
  --end

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

function CreateRodItem(rode_level: number, prestive_level: number, rode_progress: number, rode_max_progress: number, rode_upgrade_price: number, rode_image: Texture)
  local _rod_item = VisualElement.new()
  _rod_item:AddToClassList("rod__item")

  local _rod_item_header = VisualElement.new()
  _rod_item_header:AddToClassList("rod__item-header")

  local _rod_item_header_left = VisualElement.new()
  _rod_item_header_left:AddToClassList("rod__item-header__left")

  local _rod_item_header_left_icon = Image.new()
  _rod_item_header_left_icon:AddToClassList("rod__item-header__left__icon")
  _rod_item_header_left:Add(_rod_item_header_left_icon)
  _rod_item_header_left_icon.image = rode_image

  _rod_item_header:Add(_rod_item_header_left)

  local _rod_item_header_right = VisualElement.new()
  _rod_item_header_right:AddToClassList("rod__item-header__right")

  local _rod_item_header_stats = Label.new()
  _rod_item_header_stats:AddToClassList("rod__item-header__stats")
  _rod_item_header_stats.text = "Rod Stats:"
  _rod_item_header_right:Add(_rod_item_header_stats)

  local _rod_item_header_stats_content = VisualElement.new()
  _rod_item_header_stats_content:AddToClassList("rod__item-header__stats__content")

  local _rod_item_header_stats_content_label = Label.new()
  _rod_item_header_stats_content_label:AddToClassList("rod__item-header__stats__content__label")
  _rod_item_header_stats_content_label.text = "Level: " .. tostring(rode_level)
  _rod_item_header_stats_content:Add(_rod_item_header_stats_content_label)

  local _rod_item_header_stats_content_label = Label.new()
  _rod_item_header_stats_content_label:AddToClassList("rod__item-header__stats__content__label")
  _rod_item_header_stats_content_label.text = "Prestige: " .. tostring(prestive_level)
  _rod_item_header_stats_content:Add(_rod_item_header_stats_content_label)
  _rod_item_header_right:Add(_rod_item_header_stats_content)
  _rod_item_header:Add(_rod_item_header_right)
  _rod_item:Add(_rod_item_header)

  local _rod_item_content = VisualElement.new()
  _rod_item_content:AddToClassList("rod__item-content")

  local _rod_item_header_stats_bar = VisualElement.new()
  _rod_item_header_stats_bar:AddToClassList("rod__item-header__stats__bar")

  local _rod_item_header_stats_bar_fill = VisualElement.new()
  _rod_item_header_stats_bar_fill:AddToClassList("rod__item-header__stats__bar__fill")
  local ProgressWidth = (rode_progress / rode_max_progress) * 100
  _rod_item_header_stats_bar_fill.style.width = StyleLength.new(Length.Percent(ProgressWidth))

  _rod_item_header_stats_bar:Add(_rod_item_header_stats_bar_fill)

  local _rod_item_content_progress = Label.new()
  _rod_item_content_progress:AddToClassList("rod__item-content__progress")
  _rod_item_content_progress.text = tostring(rode_progress) .. "/" .. tostring(rode_max_progress)
  _rod_item_header_stats_bar:Add(_rod_item_content_progress)
  _rod_item_content:Add(_rod_item_header_stats_bar)

  local _rod_item_upgrade_button = VisualElement.new()
  _rod_item_upgrade_button:AddToClassList("rod__item-upgrade-button")
  if not maxedOut then _rod_item_upgrade_button:RegisterPressCallback(UpgradeRodCallback, true, true, true) end

  local _button_upper = VisualElement.new()
  _button_upper:AddToClassList("button-upper")

  local _rod_item_upgrade_button_icon = Image.new()
  _rod_item_upgrade_button_icon:AddToClassList("rod__item-upgrade-button__icon")
  _button_upper:Add(_rod_item_upgrade_button_icon)

  local _rod_item_upgrade_button_label = Label.new()
  _rod_item_upgrade_button_label:AddToClassList("rod__item-upgrade-button__label")
  _rod_item_upgrade_button_label.text = tostring(rode_upgrade_price)
  if maxedOut then _rod_item_upgrade_button_label.text = "" end

  _button_upper:Add(_rod_item_upgrade_button_label)
  _rod_item_upgrade_button:Add(_button_upper)

  local _button_lower = VisualElement.new()
  _button_lower:AddToClassList("button-lower")

  local _rod_item_upgrade_button_label = Label.new()
  _rod_item_upgrade_button_label:AddToClassList("rod__item-upgrade-button__label")
  if not maxedOut then
    if rode_progress == rode_max_progress then
      _rod_item_upgrade_button_label.text = "PRESTIGE"
      -- Logic for prestige
    else
      _rod_item_upgrade_button_label.text = "UPGRADE"
      -- Logic for upgrade
    end
  else
    _rod_item_upgrade_button_label.text = "Max Level"
  end

  _button_lower:Add(_rod_item_upgrade_button_label)

  _rod_item_upgrade_button:Add(_button_lower)

  _rod_item_content:Add(_rod_item_upgrade_button)
  _rod_item:Add(_rod_item_content)

  _ShopContent:Add(_rod_item)
  return _rod_item
end

function CreateDealItem(deal_name: string, deal_price: number, deal_description: string, deal_image: Texture, useGold: boolean, prompt_id: string)
  local _DealItem = VisualElement.new()
  _DealItem:AddToClassList("deal__item")

  local _DealHeader = VisualElement.new()
  _DealHeader:AddToClassList("deal__item-header")

  local _DealHeaderLeft = VisualElement.new()
  _DealHeaderLeft:AddToClassList("deal__item-header-left")

  local _DealHeaderIcon = Image.new()
  _DealHeaderIcon:AddToClassList("deal__item-header__icon")
  _DealHeaderIcon.image = deal_image

  _DealHeaderLeft:Add(_DealHeaderIcon)

  local _DealHeaderRight = VisualElement.new()
  _DealHeaderRight:AddToClassList("deal__item-header-right")

  local _DealHeaderLabel = UILabel.new()
  _DealHeaderLabel:AddToClassList("deal__item-header__label")
  _DealHeaderLabel.text = deal_description

  _DealHeaderRight:Add(_DealHeaderLabel)

  _DealHeader:Add(_DealHeaderLeft)
  _DealHeader:Add(_DealHeaderRight)

  local _DealContent = VisualElement.new()
  _DealContent:AddToClassList("deal__item-content")
  
  local _DealName = Label.new()
  _DealName:AddToClassList("deal__item__name-label")
  _DealName.text = deal_name

  local _DealBuyButton = VisualElement.new()
  _DealBuyButton:AddToClassList("deal__item-buy")

  local _DealPrice = VisualElement.new()
  _DealPrice:AddToClassList("deal__item-price")

  local _DealPriceText = Label.new()
  _DealPriceText:AddToClassList("deal__item-price__label")
  _DealPriceText.text = tostring(deal_price)

  local _DealPriceIcon = Image.new()
  if not useGold then _DealPriceIcon:AddToClassList("deal__item-price__icon") else _DealPriceIcon:AddToClassList("package__item-price__icon") end
  _DealPrice:Add(_DealPriceIcon)

  _DealPrice:Add(_DealPriceText)

  _DealBuyButton:Add(_DealPrice)

  _DealContent:Add(_DealName)
  _DealContent:Add(_DealBuyButton)

  _DealBuyButton:RegisterPressCallback(function()
    -- Open World Product Prmopt
    playerTracker.PromtTokenPurchase(prompt_id)
  end, true, true, true)

  _DealItem:Add(_DealHeader)
  _DealItem:Add(_DealContent)

  _ShopContent:Add(_DealItem)
  return _DealItem
end

-- Function to create item count modal
local item_quantity = 1 -- Default item quantity
function CreateItemCountModal(item_price: number, item_price_text: UILabel, item_quantity_text: UILabel)
  item_quantity = 1 -- Always reset quantity when a new item is selected

  local _ItemCountModal = VisualElement.new()
  _ItemCountModal:AddToClassList("item-quantity-modal")

  -- Decrement Button
  local _DecrementButton = Label.new()
  _DecrementButton:AddToClassList("item-quantity-modal__decrement")
  _DecrementButton.text = "-"
  if item_quantity == 1 then _DecrementButton:AddToClassList("item-quantity-modal__decrement--disabled") end

  -- Item Count
  local _ItemCount = VisualElement.new()
  _ItemCount:AddToClassList("item-quantity-modal__count")

  local _ItemCountText = Label.new()
  _ItemCountText:AddToClassList("item-quantity-modal__count__label")
  _ItemCountText.text = tostring(item_quantity)

  _ItemCount:Add(_ItemCountText)

  -- Increment Button
  local _IncrementButton = Label.new()
  _IncrementButton:AddToClassList("item-quantity-modal__increment")
  _IncrementButton.text = "+"
  
  local function UpdateButtons()
    if item_quantity == 1 then
      _DecrementButton:AddToClassList("item-quantity-modal__decrement--disabled")
    else
      _DecrementButton:RemoveFromClassList("item-quantity-modal__decrement--disabled")
    end

    if item_quantity == 100 then
      _IncrementButton:AddToClassList("item-quantity-modal__increment--disabled")
    else
      _IncrementButton:RemoveFromClassList("item-quantity-modal__increment--disabled")
    end
  end

  local IncrementItemQuantity = _IncrementButton:RegisterPressCallback(function()
    if item_quantity < 100 then
      item_quantity = item_quantity + 1
      _ItemCountText.text = tostring(item_quantity)
      UpdateButtons()

      -- Update the price
      item_price_text.text = tostring(item_price * item_quantity)
      item_quantity_text.text = "Buy x" .. tostring(item_quantity) .. " for: "
    end
  end, true, true, true)

  local DecrementItemQuantity = _DecrementButton:RegisterPressCallback(function()
    if item_quantity > 1 then
      item_quantity = item_quantity - 1
      _ItemCountText.text = tostring(item_quantity)
      UpdateButtons()

      -- Update the price
      item_price_text.text = tostring(item_price * item_quantity)
      item_quantity_text.text = "Buy x" .. tostring(item_quantity) .. " for: "
    end
  end, true, true, true)

  _ItemCountModal:Add(_DecrementButton)
  _ItemCountModal:Add(_ItemCount)
  _ItemCountModal:Add(_IncrementButton)

  return _ItemCountModal
end

function CreateItemInfoPage(name: string, price: number, description: string, image: Texture, is_purchased: boolean, id: string, useGold: boolean, autoHide: boolean, item_type: string, allow_quantity: boolean)
  _itemInfo:EnableInClassList("open", true)
  
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
  ]]

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

    local _ItemPrice = VisualElement.new()
    _ItemPrice:AddToClassList("shop__item__info-price")
    
    local _ItemPriceText = UILabel.new()
    _ItemPriceText:AddToClassList("shop__item__info__price-label")
    _ItemPriceText.text = tostring(price)
    _ItemPrice:Add(_ItemPriceText)

    if allow_quantity then
      _BuyButtonText:SetEmojiPrelocalizedText("Buy x1 for: ")

      local _ItemQuantityModal = CreateItemCountModal(price, _ItemPriceText, _BuyButtonText)
      _ItemInfoContent:Add(_ItemQuantityModal)
      
    else
      _BuyButtonText:SetPrelocalizedText("Buy for: ")
    end

    local _ItemPriceIcon = Image.new()
    _ItemPriceIcon:AddToClassList("shop__item__info-price__icon")
    if not useGold then _ItemPriceIcon:AddToClassList("shop__item__info-price__icon") else _ItemPriceIcon:AddToClassList("package__item__info-price__icon") end
    _ItemPrice:Add(_ItemPriceIcon)

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

        print("BUYING " .. tostring(item_quantity) .. " " .. name .. " for " .. tostring(price * item_quantity) .. " coins")
        
        local totalPrice = price * item_quantity
        if playerTracker.GetTokens(client.localPlayer) >= totalPrice then

          -- Purchase Item only if the player has enough cash
          inventoryManager.PurchaseItem(id, totalPrice, item_quantity)

          -- Equip the item if it is bait
          if baitMetas[id] then
            playerTracker.ChangeBaitRequest(id, false)
          end

          -- remove buy button and replace with purchased
          -- Note: Do not remove this button unless the purchase is successful (Another way is if we check for the user balance and disable the button if they don't have enough cash to purchase the item)
          audioManager.PlaySound("coinsSound2", 1)
          _ItemInfoContent:Remove(_BuyButton)
          CreatePurhcasedButton(autoHide, _BuyButton)
        else
          -- Display missing coins modal
          local missingCoinsModal = CreateMissingCoinsModal()
          _Shop:Add(missingCoinsModal)

          Timer.After(0.1, function()
            missingCoinsModal:EnableInClassList("open", true)
          end)
        
        end
      end, true, true, true)
    end
  else
    -- Display purchased
    CreatePurhcasedButton()
  end
    
end

-- Function to create missing coins modal, can be used to prompt the user to buy coins (good for marketing)
function CreateMissingCoinsModal()

  local function sortDealsByPrice(deals)
    local dealList = {}
    for key, v in pairs(deals) do
      table.insert(dealList, { key = key, value = v })
    end

    table.sort(dealList, function(a, b)
      return a.value.ItemWorth < b.value.ItemWorth
    end)

    return dealList
  end

  local sortedDeals = sortDealsByPrice(dealMetas)

  local _MissingCoinsModal = VisualElement.new()
  _MissingCoinsModal:AddToClassList("missing-coins-modal")

  local _ModalUpperPart = VisualElement.new()
  _ModalUpperPart:AddToClassList("missing-coins-modal__upper")

  local _ModalUpperImage = Image.new()
  _ModalUpperImage:AddToClassList("missing-coins-modal__upper__image")

  _ModalUpperPart:Add(_ModalUpperImage)

  local _ModalLowerPart = VisualElement.new()
  _ModalLowerPart:AddToClassList("missing-coins-modal__lower")

  local _ModalLowerContent = VisualElement.new()
  _ModalLowerContent:AddToClassList("missing-coins-modal__lower-content")

  local _ModalLowerText = UILabel.new()
  _ModalLowerText:AddToClassList("missing-coins-modal__lower__text")
  _ModalLowerText:SetPrelocalizedText("Coins Missing?")

  _ModalLowerContent:Add(_ModalLowerText)

  local _ModalDeals = VisualElement.new()
  _ModalDeals:AddToClassList("missing-coins-modal__lower__deals")

  for _, deal in ipairs(sortedDeals) do
    local v = deal.value
    local amount = v.Amount
    local price = v.ItemWorth
    local id = deal.key
    local itemImage = v.ItemImage

    local _ModalDeal = VisualElement.new()
    _ModalDeal:AddToClassList("missing-coins-modal__lower__deal")

    local _ModalDealIcon = Image.new()
    _ModalDealIcon:AddToClassList("missing-coins-modal__lower__deal__icon")
    _ModalDealIcon.image = itemImage

    local _ModalDealText = UILabel.new()
    _ModalDealText:AddToClassList("missing-coins-modal__lower__deal__text")
    _ModalDealText:SetPrelocalizedText(tostring(amount))

    local _ModalPurchaseButton = VisualElement.new()
    _ModalPurchaseButton:AddToClassList("missing-coins-modal__lower__purchase")

    local _ModalPurchaseButtonIcon = Image.new()
    _ModalPurchaseButtonIcon:AddToClassList("missing-coins-modal__lower__purchase__icon")

    local _ModalPurchaseButtonText = UILabel.new()
    _ModalPurchaseButtonText:AddToClassList("missing-coins-modal__lower__purchase__text")
    _ModalPurchaseButtonText:SetPrelocalizedText(tostring(price))

    _ModalDeal:Add(_ModalDealIcon)
    _ModalDeal:Add(_ModalDealText)

    _ModalPurchaseButton:Add(_ModalPurchaseButtonIcon)
    _ModalPurchaseButton:Add(_ModalPurchaseButtonText)
    
    _ModalDeal:Add(_ModalPurchaseButton)

    _ModalPurchaseButton:RegisterPressCallback(function()
      -- Open World Product Prompt
      playerTracker.PromtTokenPurchase(id)
    end, true, true, true)

    _ModalDeals:Add(_ModalDeal)
  end

  _ModalLowerContent:Add(_ModalDeals)

  _ModalLowerPart:Add(_ModalLowerContent)

  _MissingCoinsModal:Add(_ModalUpperPart)
  _MissingCoinsModal:Add(_ModalLowerPart)

  local _CloseButton = VisualElement.new()
  _CloseButton:AddToClassList("missing-coins-modal__close")

  local _CloseButtonContent = VisualElement.new()
  _CloseButtonContent:AddToClassList("missing-coins-modal__close-content")

  local _CloseButtonIcon = Image.new()
  _CloseButtonIcon:AddToClassList("missing-coins-modal__close__icon")

  _CloseButtonContent:Add(_CloseButtonIcon)
  _CloseButton:Add(_CloseButtonContent)

  _MissingCoinsModal:Add(_CloseButton)

  _CloseButton:RegisterPressCallback(function()
    missingCoinsModalOpen = false
    _Shop:Remove(_MissingCoinsModal)
  end, true, true, true)

  return _MissingCoinsModal
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
    purchaseTimer = Timer.After(2, function()
      _ItemInfoContent:Remove(_Purchased)
      _ItemInfoContent:Add(buyButton)
    end)
  end
end

function PopulateShop(items)
  _ShopContent:Clear()
  _ShopContentContainer:ScrollToBeginning()
  
  if items == nil then return end

  -- Clearn _contentHeaderIcon class list
  _contentHeaderIcon:ClearClassList()
  _contentHeaderIcon:AddToClassList("content-header__left")

  if state == 0 then -- check if items are poles
    _contentHeaderLabel:SetPrelocalizedText("Upgrade your fishing pole to increase your fishing capabilities.")
    _contentHeaderIcon:AddToClassList("pole-icon")

    CreateRodItem(playerTracker.GetPlayerPoleLevel(), playerTracker.GetPlayerPolePrestige(), playerTracker.GetPlayerPoleLevel(), 9, upgradeCost, poleMetas[playerTracker.players[client.localPlayer].playerFishingPole.value].ItemImage)

  elseif state == 1 then -- check if items are bait
    _contentHeaderLabel:SetPrelocalizedText("Bait is used to attract fish to your hook. Different fish are attracted to different bait.")
    _contentHeaderIcon:AddToClassList("bait-icon")

    for i = 1, #items do
      if baitMetas[items[i].id] then
        -- Create Item Meta Data based on ID
        local itemMeta = baitMetas[items[i].id]
    
        local itemPrice = itemMeta.ItemWorth
        local itemImage = itemMeta.ItemImage
        local itemDescription = itemMeta.Description
        local itemName = itemMeta.Name

        local useGold = false
    
        local item = CreateItem(itemPrice, itemImage, useGold, "item_bait", Utils.TrimText(itemName, 9))
      
        item:RegisterPressCallback(function()
          --Show Item Info
          CreateItemInfoPage(itemName, itemPrice, itemDescription, itemImage, false, items[i].id, useGold, true, "item_bait", true)
          if purchaseTimer then purchaseTimer:Stop(); purchaseTimer = nil end
        end, true, true, true)
    
      end
    end
  elseif state == 2 then -- check if items are deals
    _contentHeaderLabel:SetPrelocalizedText("Special deals to help you get started on your fishing journey.")
    _contentHeaderIcon:AddToClassList("deals-icon")

    for i = 1, #items do
      if dealMetas[items[i].id] then
        -- Create Item Meta Data based on ID
        local itemMeta = dealMetas[items[i].id]
    
        local itemPrice = itemMeta.ItemWorth
        local itemImage = itemMeta.ItemImage
        local itemDescription = itemMeta.Description
        local itemName = itemMeta.Name

        local useGold = true
    
        --local item = CreateItem(itemPrice, itemImage, useGold, "item_coins", Utils.TrimText(itemName, 9))
        local item = CreateDealItem(itemName, itemPrice, itemDescription, itemImage, useGold, items[i].id)

        --[[
        item:RegisterPressCallback(function()
          --Show Item Info
          CreateItemInfoPage(itemName, itemPrice, itemDescription, itemImage, false, items[i].id, useGold, true, "item_coins", false)
          if purchaseTimer then purchaseTimer:Stop(); purchaseTimer = nil end
        end, true, true, true)
        ]]--
    
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
  elseif btn == "poles" then
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
  local success = ButtonPressed("poles")
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

function self:Start()
  playerTracker.players[client.localPlayer].playerPolePrestige.Changed:Connect(function(polPrstg)
    if polPrstg == 12 and playerTracker.players[client.localPlayer].playerPoleLevel.value == 9 then
      maxedOut = true
    else
      maxedOut = false
    end
    upgradeCost = polPrstg * 100
    PopulateShop(Poles)
  end)

  playerTracker.players[client.localPlayer].playerPoleLevel.Changed:Connect(function(polLvl)
    if polLvl == 9 and playerTracker.players[client.localPlayer].playerPolePrestige.value == 12 then
      maxedOut = true
    else
      maxedOut = false
    end
    PopulateShop(Poles)
  end)

  playerTracker.players[client.localPlayer].playerFishingPole.Changed:Connect(function(newPole)
    PopulateShop(Poles)
  end)
end