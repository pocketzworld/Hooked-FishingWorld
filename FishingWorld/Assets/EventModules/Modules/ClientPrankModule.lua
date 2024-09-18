--!Type(Module)

--!SerializeField
local freeActionImage: Texture2D = nil

--!SerializeField
local guaranteedActionImage: Texture2D = nil

--!SerializeField
local guaranteedDoubleActionImage: Texture2D = nil

if not client then
	return
end

local UIModule = require("UIModule")
local PrankModule = require("PrankModule")

local pending: EventConnection | nil = nil
local pendingTimer: Timer | nil = nil

local prankScreen: VisualElement | nil = nil

export type Consumable = {
	id: string | nil,
	ownedAmount: number,
	text: string,
	image: Texture2D,
}

local function CancelQuery()
	if pending then
		if pending ~= nil then pending:Disconnect() end
		pending = nil
	end
	if pendingTimer then
		pendingTimer:Stop()
		pendingTimer = nil
	end
end

function QueryState(cb: (state: PrankModule.UserPrankState | nil, err: string | nil) -> ())
	CancelQuery()

	pending = PrankModule.EVENTS.StateResponse:Connect(
		function(data: PrankModule.UserPrankStateData | nil, err: string | nil)
			CancelQuery()
			if err ~= nil then
				print("error print " .. tostring(err))
				cb(nil, err)
			else
				cb(PrankModule.UserPrankState.New(data), nil)
			end
		end
	)
	pendingTimer = Timer.After(5, function()
		CancelQuery()
		cb(nil, PrankModule.ERR_TIMED_OUT)
	end)

	PrankModule.EVENTS.RequestState:FireServer(nil)
end

function RequestPrank(itemId: string | nil, cb: (state: PrankModule.PrankResponse | nil, err: string | nil) -> ())
	CancelQuery()

	pending = PrankModule.EVENTS.PrankResponse:Connect(
		function(data: PrankModule.PrankResponse | nil, err: string | nil)
			CancelQuery()
			if err ~= nil then
				cb(nil, err)
			else
				cb(PrankModule.PrankResponse.New(data), nil)
			end

			-- Fetch Energy and Energy Time for Client UI
			local state = nil
			if data ~= nil then
				state = data.state
			end

		end
	)
	pendingTimer = Timer.After(5, function()
		CancelQuery()
		cb(nil, PrankModule.ERR_TIMED_OUT)
	end)

	PrankModule.EVENTS.RequestPrank:FireServer(itemId)
end

function RequestSuperBoost(itemId: string, cb: (err: string | nil) -> ())
	CancelQuery()

	pending = PrankModule.EVENTS.SuperBoostResponse:Connect(
		function(err: string | nil)
			CancelQuery()
			if err ~= nil then
				cb(err)
			else
				cb(nil)
			end
		end
	)
	pendingTimer = Timer.After(5, function()
		CancelQuery()
		cb(PrankModule.ERR_TIMED_OUT)
	end)

	PrankModule.EVENTS.RequestSuperBoost:FireServer(itemId)
end

function RequestEnergyRefill(itemId: string, cb: (err: string | nil) -> ())
	CancelQuery()

	pending = PrankModule.EVENTS.EnergyRefillResponse:Connect(
		function(err: string | nil)
			CancelQuery()
			if err ~= nil then
				cb(err)
			else
				cb(nil)
			end
		end
	)
	pendingTimer = Timer.After(5, function()
		CancelQuery()
		cb(PrankModule.ERR_TIMED_OUT)
	end)

	PrankModule.EVENTS.RequestEnergyRefill:FireServer(itemId)
end

function GetConsumables(state: PrankModule.UserPrankState): { {Consumable} }

	local energyRefillSmall = state:GetEventItem(PrankModule.ENERGY_REFILL_SMALL)
	local energyRefillMax = state:GetEventItem(PrankModule.ENERGY_REFILL_MAX)
	local stageBonusTime1 = state:GetEventItem(PrankModule.STAGE_BONUS_TIME_1)
	local stageBonusTime2 = state:GetEventItem(PrankModule.STAGE_BONUS_TIME_2)
--[[
	local consumablesActions: { Consumable } = {
		{
			id = guaranteedDoubleItem.id,
			ownedAmount = guaranteedDoubleItem.ownedAmount,
			text = guaranteedDoubleItem.subText,
			image = guaranteedDoubleActionImage,
		},
		{
			id = guaranteedItem.id,
			ownedAmount = guaranteedItem.ownedAmount,
			text = guaranteedItem.subText,
			image = guaranteedActionImage,
		},
		{
			id = nil,
			ownedAmount = math.huge,
			text = "%d%% chance",
			image = freeActionImage,
		},
	}
--]]
--[[
	local consumablesEnergy: { Consumable } = {
		{
			id = energyRefillMax.id,
			ownedAmount = energyRefillMax.ownedAmount,
			text = energyRefillMax.subText,
			image = energyRefillMax.imageUrl,
		},
		{
			id = energyRefillSmall.id,
			ownedAmount = energyRefillSmall.ownedAmount,
			text = energyRefillSmall.subText,
			image = energyRefillSmall.imageUrl,
		},
	}
--]]

	local consumablesBoosts: { Consumable } = {
		{
			id = stageBonusTime1.id,
			ownedAmount = stageBonusTime1.ownedAmount,
			text = stageBonusTime1.subText,
			image = stageBonusTime1.imageUrl,
		},
		{
			id = stageBonusTime2.id,
			ownedAmount = stageBonusTime2.ownedAmount,
			text = stageBonusTime2.subText,
			image = stageBonusTime2.imageUrl,
		},
	}

	return {consumablesBoosts}
end

function ShowBoostUI()
	QueryState(function(res, err)
		if err then
			print("Error querying state: " .. err)
			return
		end
		
		--print("State: " .. tostring(res))
		UIModule.ShowPopup("superboost", res)

		if res ~= nil then
			state = res
		end
	end)
end

function EventAction()
    QueryState(function(res, err)
        local state = nil
		if err then
			print("Error querying state: " .. err)
			return
		end
		if res ~= nil then
			state = res
		end
        --print("State: " .. tostring(state))

        ----- Request Event Funciton -----

        --- Check Energy First ---
		--[[
        local energy = state.eventStatus.energyAmount
        if energy <= 0 then
            print("Energy is less than 0")
            UIModule.ShowPopup("refill", state)
            return
        end
		]]

        ----- START PRANK REQUEST -----
        RequestPrank(nil, function(res, err)
            if err ~= nil then
                print("Error requesting prank: " .. err)
                return
            end

            --print("Prank: " .. tostring(res))
            --UIModule.ShowDrawer("response", res)
            UIModule.ShowResult(res)
        end)

	end)
end

function SuncUItoState()
	QueryState(function(res, err)
		if err then
			print("Error querying state: " .. err)
			return
		end
		if res ~= nil then
			UIModule.SyncState(res)
		end
	end)

	PrankModule.EVENTS.ResetStreakResponse:Connect(function()
		UIModule.ResetStreak()
	end)
end

function self:ClientStart()
	SuncUItoState()
end