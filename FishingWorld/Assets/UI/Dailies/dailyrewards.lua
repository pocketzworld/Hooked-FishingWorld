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
local dailyRewardsModule = require("DailyRewardsModule")


function FormatTitle(title: string)
  local formatted_title = title:gsub("_", " ")
  return formatted_title:gsub("^%l", string.upper)
end

-- Register a callback to close the daily rewards UI
_closeButton:RegisterPressCallback(function()
  UIManager.ButtonPressed("Close")
end, true, true, true)

-- Initialize the daily rewards UI
local function Initialize()
  _header:SetPrelocalizedText("Claim your daily rewards!")
end


_progressBar.value = 0
local IncreaseBy = 0.125

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

--FillProgressBar()
Initialize()

function CreateDailyRewardItem(title: string, items, is_claimed: boolean, can_claim: boolean, is_special: boolean)
  local dailyrewards__item = VisualElement.new()
  dailyrewards__item:AddToClassList("dailyrewards__item")

  if is_claimed then
    dailyrewards__item:AddToClassList("claimed")
  else
    if not can_claim then
      dailyrewards__item:AddToClassList("locked")
    end
  end

  local dailyrewards__item__header = VisualElement.new()
  dailyrewards__item__header:AddToClassList("dailyrewards__item__header")

  local dailyrewards__item__header__title = Label.new()
  dailyrewards__item__header__title:AddToClassList("dailyrewards__item__header__title")
  dailyrewards__item__header__title.text = FormatTitle(title)
  dailyrewards__item__header:Add(dailyrewards__item__header__title)

  local dailyrewards__item__content = VisualElement.new()
  dailyrewards__item__content:AddToClassList("dailyrewards__item__content")

  if is_special then
    dailyrewards__item:AddToClassList("special")
    -- Loop through the item array for the special item
    local index = 1
    for _, value in ipairs(items) do
      local dailyrewards__item__content_info = VisualElement.new()
      dailyrewards__item__content_info:AddToClassList("dailyrewards__item__content_info")
      if index == 1 then
        dailyrewards__item__content_info:AddToClassList("one")
      elseif index == 2 then
        dailyrewards__item__content_info:AddToClassList("two")
      elseif index == 3 then
        dailyrewards__item__content_info:AddToClassList("three")
      end

      local dailyrewards__item__content__icon = Image.new()
      dailyrewards__item__content__icon:AddToClassList("dailyrewards__item__content__icon")
      dailyrewards__item__content__icon.image = value.item_icon

      local dailyrewards__item__content__text = Label.new()
      dailyrewards__item__content__text:AddToClassList("dailyrewards__item__content__text")
      dailyrewards__item__content__text.text = value.item_amount

      dailyrewards__item__content_info:Add(dailyrewards__item__content__icon)
      dailyrewards__item__content_info:Add(dailyrewards__item__content__text)

      dailyrewards__item__content:Add(dailyrewards__item__content_info)
      index = index + 1
    end
  else
    local dailyrewards__item__content__icon = Image.new()
    dailyrewards__item__content__icon:AddToClassList("dailyrewards__item__content__icon")
    dailyrewards__item__content__icon.image = items[1].item_icon

    local dailyrewards__item__content__text = Label.new()
    dailyrewards__item__content__text:AddToClassList("dailyrewards__item__content__text")
    dailyrewards__item__content__text.text = items[1].item_amount

    dailyrewards__item__content:Add(dailyrewards__item__content__icon)
    dailyrewards__item__content:Add(dailyrewards__item__content__text)
  end

  dailyrewards__item:Add(dailyrewards__item__header)
  dailyrewards__item:Add(dailyrewards__item__content)

  if can_claim then
    dailyrewards__item:RegisterPressCallback(function()
      --#TODO: Claim the daily reward
      dailyRewardsModule.RequestDailyReward()
      dailyrewards__item:AddToClassList("claimed")
      Timer.After(1, function()
        PopulateRewards()
      end)
    end, true, true, true)
  end

  return dailyrewards__item
end

function PopulateRewards()
  _content:Clear() -- Clear the content before populating it with new items

  local dailyrewards__item = nil
  local row_count = 0
  local dailyrewards__content__row = nil
  local row_index = 1
  local row_classes = { "one", "two", "three" }

  -- Define the correct order of days
  local ordered_keys = {"day_1", "day_2", "day_3", "day_4", "day_5", "day_6", "day_7"}

  local dailyRewards = dailyRewardsModule.GetDailyRewardSchedule()

  for i, key in ipairs(ordered_keys) do
      local value = dailyRewards[key]
      local is_claimed = dailyRewardsModule.GetClaimStreak() > i
      local can_claim = false
      local is_special = #value > 1

      if key == "day_" .. dailyRewardsModule.GetClaimStreak() then
          can_claim = true
      end

      if row_count == 0 then
          dailyrewards__content__row = VisualElement.new()
          dailyrewards__content__row:AddToClassList("dailyrewards__content__row")
          -- Add the appropriate row class based on the current row index
          dailyrewards__content__row:AddToClassList(row_classes[row_index])
      end

      dailyrewards__item = CreateDailyRewardItem(key, value, is_claimed, can_claim, is_special)
      dailyrewards__content__row:Add(dailyrewards__item)
      row_count = row_count + 1

      if row_count == 3 then
          _content:Add(dailyrewards__content__row)
          row_count = 0
          row_index = row_index + 1
          if row_index > #row_classes then
              row_index = 1 -- Reset to the first class if there are more than 3 rows
          end
      end
  end

  -- Add the last row if it has less than 3 items
  if row_count > 0 then
      _content:Add(dailyrewards__content__row)
  end
end
