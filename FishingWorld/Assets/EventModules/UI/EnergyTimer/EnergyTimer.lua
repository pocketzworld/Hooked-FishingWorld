--!Type(UI)

--!Bind
local event_widgetContainer : VisualElement = nil
--!Bind
local event_bag : VisualElement = nil

local prankModule = require("PrankModule")
local clientPrankModule = require("ClientPrankModule")

local timeRemaining = 0
local energy = 0
local maxEnergy = 0
local energyTimer = nil

event_widgetContainer:RegisterPressCallback(function()
    --print("WidgetContainer Pressed")
    UI:ExecuteDeepLink("https://high.rs/event-info")
end)

event_bag:RegisterPressCallback(function()
    --print("Bag Pressed")
    UI:ExecuteDeepLink("https://high.rs/backpack")
end)