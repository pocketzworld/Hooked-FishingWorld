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
local EventConsumablesEnergy = nil

cancelButton:RegisterPressCallback(function()
    --print("Cancel button pressed")
    self.gameObject:SetActive(false)
end)

item1:RegisterPressCallback(function()
    --print("Item 1 pressed")
    clientPrankModule.RequestEnergyRefill(EventConsumablesEnergy[1].id, function(err)
        if err then
            print("Error: " .. err) --#TODO OPEN EVENT STORE
            self.gameObject:SetActive(false)
            UI:ExecuteDeepLink("https://high.rs/shop?type=ic&id=66e9d968f3e754f7116bbd76")
        else
            print("Success")
            clientPrankModule.QueryEnergyData()
            self.gameObject:SetActive(false)
        end
    end)
end)

item2:RegisterPressCallback(function()
    --print("Item 2 pressed")
    clientPrankModule.RequestEnergyRefill(EventConsumablesEnergy[2].id, function(err)
        if err then
            print("Error: " .. err) --#TODO OPEN EVENT STORE
            self.gameObject:SetActive(false)
            UI:ExecuteDeepLink("https://high.rs/shop?type=ic&id=66e9d968f3e754f7116bbd76")
        else
            --print("Success")
            clientPrankModule.QueryEnergyData()
            self.gameObject:SetActive(false)
        end
    end)
end)

function SetStateValues(state)
    currentState = state
    EventConsumablesEnergy = clientPrankModule.GetConsumables(state)[1]

    item1AmountLabel.text = tostring("x" .. EventConsumablesEnergy[1].ownedAmount)
    item2AmountLabel.text = tostring("x" .. EventConsumablesEnergy[2].ownedAmount)
end