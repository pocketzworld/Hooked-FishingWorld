--!Type(Module)

--!SerializeField
local EventHudOBJ : GameObject = nil
--!SerializeField
local energyRefillPopup : GameObject = nil
--!SerializeField
local superBoostPopup : GameObject = nil
--!SerializeField
local energyWidget : GameObject = nil
--!SerializeField
local EventOverUI : GameObject = nil
--!SerializeField
local EventObjs : GameObject = nil

local preTokens = 0

local container: VisualElement

local EventActive = BoolValue.new("EventActive", true)

local PrankModule = require("PrankModule")

function ShowResult(response : PrankModule.PrankResponse)
	local tokensGained = response.state.eventStatus.luckyTokens - preTokens
	EventHudOBJ:GetComponent(EventHud).UpdateEventValuesResponse(response, tokensGained)
end

function SyncState(state : PrankModule.UserPrankState)
	preTokens = state.eventStatus.luckyTokens
	EventHudOBJ:GetComponent(EventHud).UpdateEventValuesState(state)
end

function ResetStreak()
	EventHudOBJ:GetComponent(EventHud).ResetStreak()
end

function ShowPopup(popup : string, state : PrankModule.UserPrankState)
	if popup == "refill" then
		energyRefillPopup:SetActive(true)
		local popupScript = energyRefillPopup:GetComponent(UIEnergyRefillContent)
		popupScript.SetStateValues(state)
	end
	if popup == "superboost" then
		superBoostPopup:SetActive(true)
		local popupScript = superBoostPopup:GetComponent(UISuperBoostPopup)
		popupScript.SetStateValues(state)
	end
end

function EndEvent()
	EventOverUI:SetActive(true)
	EventObjs:SetActive(false)
end


function GetEventActiveStorage()
	Storage.GetValue("Event_Active", function(value)
		if value == nil then
			Storage.SetValue("Event_Active", true)
		else
			EventActive.value = value
		end
	end)
end


function self:ClientAwake()
	EventActive.Changed:Connect(function(value)
		if value == false then
			EndEvent()
		end
	end)
end


function self:ServerStart()
	Timer.After(1, GetEventActiveStorage)
	Timer.Every(5, GetEventActiveStorage)
end