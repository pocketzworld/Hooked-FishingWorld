--!Type(UI)

--!Bind
local _header : UILabel = nil

--!Bind
local _progressBar : UIProgressBar = nil
--!Bind
local _closeButton : VisualElement = nil -- Close button for the daily rewards UI

--!Bind
local _content : VisualElement = nil

local UIManager = require("UIManager")

-- Register a callback to close the daily rewards UI
_closeButton:RegisterPressCallback(function()
  UIManager.ButtonPressed("Close")
end, true, true, true)

local hardCodedDailies = {
  ["day_one"] = {
    {
      item_name = "Coins",
      item_amount = 10,
      item_icon = "coin_icon",
      item_type = "currency"
    }
  },
  ["day_two"] = {
    {
      item_name = "Corn",
      item_amount = 5,
      item_icon = nil,
      item_type = "bait"
    }
  },
  ["day_three"] = {
    {
      item_name = "Coins",
      item_amount = 50,
      item_icon = "coin_icon",
      item_type = "currency"
    }
  },
  ["day_four"] = {
    {
      item_name = "broccoli_bait",
      item_amount = 1,
      item_icon = nil,
      item_type = "bait"
    }
  },
  ["day_five"] = {
    {
      item_name = "Coins",
      item_amount = 60,
      item_icon = "coin_icon",
      item_type = "currency"
    }
  },
  ["day_six"] = {
    {
      item_name = "chicken_bait",
      item_amount = 1,
      item_icon = nil,
      item_type = "bait"
    }
  },
  ["day_seven"] = {
    {
      item_name = "Coins",
      item_amount = 100,
      item_icon = "coin_icon",
      item_type = "currency"
    },
    {
      item_name = "hotdog_bait",
      item_amount = 2,
      item_icon = nil,
      item_type = "bait"
    },
    {
      item_name = "donut_bait",
      item_amount = 1,
      item_icon = nil,
      item_type = "bait"
    }
  }
}

local dailies = 7
_progressBar.value = 0

-- Fill the progress bar every 5 seconds until it's full
function FillProgressBar()
    local progress = 0
    local interval = Timer.Every(5, function()
        progress = progress + 0.125
        _progressBar.value = progress
        if progress >= 1 then
            interval = nil
        end
    end)
end

FillProgressBar()

function CreateDailyRewardItem(title: string, item, is_claimed: boolean, can_claim: boolean, is_special: boolean)
  local dailyrewards__item = VisualElement.new()
  dailyrewards__item:AddToClassList("dailyrewards__item")

  if is_claimed then
    dailyrewards__item:AddToClassList("claimed")
  end

  local dailyrewards__item__header = VisualElement.new()
  dailyrewards__item__header:AddToClassList("dailyrewards__item__header")

  local dailyrewards__item__header__title = UILabel.new()
  dailyrewards__item__header__title:AddToClassList("dailyrewards__item__header__title")
  dailyrewards__item__header__title.text = title
  
  dailyrewards__item__header:Add(dailyrewards__item__header__title)

  local dailyrewards__item__content = VisualElement.new()
  dailyrewards__item__content:AddToClassList("dailyrewards__item__content")

  local dailyrewards__item__content__icon = UIImage.new()
  dailyrewards__item__content__icon:AddToClassList("dailyrewards__item__content__icon")
  dailyrewards__item__content__icon.image = item.item_icon

  local dailyrewards__item__content__text = UILabel.new()
  dailyrewards__item__content__text:AddToClassList("dailyrewards__item__content__text")
  dailyrewards__item__content__text.text = item.item_amount

  dailyrewards__item__content:Add(dailyrewards__item__content__icon)
  dailyrewards__item__content:Add(dailyrewards__item__content__text)

  dailyrewards__item:Add(dailyrewards__item__header)
  dailyrewards__item:Add(dailyrewards__item__content)

  if can_claim then
    dailyrewards__item:RegisterPressCallback(function()
      --#TODO: Claim the daily reward
    end, true, true, true)
  end

  return dailyrewards__item
end