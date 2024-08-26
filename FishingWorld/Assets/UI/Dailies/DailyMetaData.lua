--!Type(Module)

--!SerializeField
local coinIcons : {Texture} = nil
--!SerializeField
local baitIcons : {Texture} = nil

local AssignCoinIcon = function(amount: number)
  if amount <= 49 then
    return coinIcons[1]
  elseif amount <= 99 then
    return coinIcons[2]
  else
    return coinIcons[3]
  end
end

local AssignBaitIcon = function(bait_name: string)
  if bait_name == "corn_bait" then
    return baitIcons[1]
  elseif bait_name == "broccoli_bait" then
    return baitIcons[2]
  elseif bait_name == "chicken_bait" then
    return baitIcons[3]
  elseif bait_name == "hotdog_bait" then
    return baitIcons[4]
  elseif bait_name == "donut_bait" then
    return baitIcons[5]
  end
end

Dailies = {
  ["day_1"] = {
    {
      item_name = "Coins",
      item_amount = 10,
      item_icon = AssignCoinIcon(10),
      item_type = "currency"
    }
  },
  ["day_2"] = {
    {
      item_name = "corn_bait",
      item_amount = 5,
      item_icon = AssignBaitIcon("corn_bait"),
      item_type = "bait"
    }
  },
  ["day_3"] = {
    {
      item_name = "Coins",
      item_amount = 50,
      item_icon = AssignCoinIcon(50),
      item_type = "currency"
    }
  },
  ["day_4"] = {
    {
      item_name = "broccoli_bait",
      item_amount = 1,
      item_icon = AssignBaitIcon("broccoli_bait"),
      item_type = "bait"
    }
  },
  ["day_5"] = {
    {
      item_name = "Coins",
      item_amount = 60,
      item_icon = AssignCoinIcon(60),
      item_type = "currency"
    }
  },
  ["day_6"] = {
    {
      item_name = "chicken_bait",
      item_amount = 1,
      item_icon = AssignBaitIcon("chicken_bait"),
      item_type = "bait"
    }
  },
  ["day_7"] = {
    {
      item_name = "Coins",
      item_amount = 100,
      item_icon = AssignCoinIcon(100),
      item_type = "currency"
    },
    {
      item_name = "hotdog_bait",
      item_amount = 2,
      item_icon = AssignBaitIcon("hotdog_bait"),
      item_type = "bait"
    },
    {
      item_name = "donut_bait",
      item_amount = 1,
      item_icon = AssignBaitIcon("donut_bait"),
      item_type = "bait"
    }
  }
}

function FormatTitle(title: string)
  local formatted_title = title:gsub("_", " ")
  return formatted_title:gsub("^%l", string.upper)
end