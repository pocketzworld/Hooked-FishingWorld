--!Type(UI)

--!Bind
local cancelButton : VisualElement = nil
--!Bind
local item1 : VisualElement = nil
--!Bind
local item2 : VisualElement = nil
--!Bind
local item1AmountLabel : Label = nil
--!Bind
local item2AmountLabel : Label = nil

local clientPrankModule = require("ClientPrankModule")

local currentState = nil
local EventConsumablesBoost = {}

cancelButton:RegisterPressCallback(function()
    --print("Cancel button pressed")
    self.gameObject:SetActive(false)
end)

item1:RegisterPressCallback(function()
    --print("Item 1 pressed")
    clientPrankModule.RequestSuperBoost(EventConsumablesBoost[1].id, function(err)
        if err then
            print("Error: " .. err) --#TODO OPEN EVENT STORE
            self.gameObject:SetActive(false)
            UI:ExecuteDeepLink("https://high.rs/shop?type=ic&id=66dde521dc5a2eeb8f86ba88")
        else
            print("Success")
            clientPrankModule.SuncUItoState()
            self.gameObject:SetActive(false)
        end
    end)
end)

item2:RegisterPressCallback(function()
    --print("Item 2 pressed")
    clientPrankModule.RequestSuperBoost(EventConsumablesBoost[2].id, function(err)
        if err then
            print("Error: " .. err) --#TODO OPEN EVENT STORE
            self.gameObject:SetActive(false)
            UI:ExecuteDeepLink("https://high.rs/shop?type=ic&id=66dde521dc5a2eeb8f86ba88")
        else
            print("Success")
            clientPrankModule.SuncUItoState()
            self.gameObject:SetActive(false)
        end
    end)
end)

function SetStateValues(state)
    EventConsumablesBoost = clientPrankModule.GetConsumables(state)[1]
    print("EventConsumablesBoost: " .. tostring(EventConsumablesBoost))

    item1AmountLabel.text = tostring("x" .. EventConsumablesBoost[1].ownedAmount)
    item2AmountLabel.text = tostring("x" .. EventConsumablesBoost[2].ownedAmount)
end