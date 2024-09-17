--!Type(Module)

--!SerializeField
local testMode: boolean = false

if not server then
	return
end

local PrankModule = require("PrankModule")
local PersistentKey = "event_state"

caughtFishRarity = "Common"
local fishRarityRewardsTable = {
	Common = 1,
	Uncommon = 2,
	Rare = 3,
	Epic = 4,
	Legendary = 5,
	Mythical = 6
}

-- Data taken from
-- https://www.notion.so/pocketworlds/Prank-Event-Overview-For-Worlds-3646c56a5b56412a9550581ea3ae3cd9

export type StoredState = {
	streak: number,
}

export type StateModifiedResponse = {
	ranksAdvanced: number,
	status: PrankModule.TicketEventUserStatusData,
}

export type EventProvider = {
	GetStatusForPlayer: (
		player: Player,
		cb: (response: PrankModule.TicketEventUserStatusData | nil, err: any) -> ()
	) -> (),
	ModifyPlayer: (
		player: Player,
		energyLost: number,
		luckyTokensWon: number,
		ticketsGained: number,
		itemToUse: string | nil,
		cb: (response: StateModifiedResponse | nil, err: any) -> ()
	) -> (),
}

export type Prank = {
	New: (provider: EventProvider) -> Prank,
	provider: EventProvider,
	streakBoost: number,
	streakBoostMin: number,
	pendingRequests: { [number]: any },
	playerStates: {
		[string]: {
			streak: number,
		},
	},
	SetStreakBoost: (self: Prank, streakBoost: number, streakBoostMin: number) -> Prank,
	ItemGuaranteesSuccess: (itemId: string | nil) -> boolean,
	ValidatePrankItem: (self: Prank, state: PrankModule.UserPrankState, itemId: string | nil) -> boolean,
	GetTicketMultiplierForItem: (itemId: string | nil) -> number,
	CalculateTicketReward: (
		self: Prank,
		state: PrankModule.UserPrankState,
		itemId: string | nil
	) -> number,
    CalculateTicketBoost: (
        self: Prank,
        _eventStatus: PrankModule.TicketEventUserStatusData
    ) -> number,
	TryPrank: (
		self: Prank,
		player: Player,
		itemId: string,
		cb: (data: PrankModule.PrankResponseData | nil, err: string | nil) -> ()
	) -> (),
    StartBoost: (
		self: Prank,
		player: Player,
		itemId: string,
		cb: (data: PrankModule.PrankResponseData | nil, err: string | nil) -> ()
	) -> (),
	RefillEnergy: (
		self: Prank,
		player: Player,
		itemId: string,
		cb: (data: PrankModule.PrankResponseData | nil, err: string | nil) -> ()
	) -> (),
	OnSuccessfulPrank: (
		self: Prank,
		player: Player,
		state: PrankModule.UserPrankState,
		usedItemId: string | nil,
		cb: (data: PrankModule.PrankResponseData | nil, err: string | nil) -> ()
	) -> (),
	OnFailedPrank: (
		self: Prank,
		player: Player,
		state: PrankModule.UserPrankState,
		usedItemId: string | nil,
		cb: (data: PrankModule.PrankResponseData | nil, err: string | nil) -> ()
	) -> (),
	QueryStateForPlayer: (
		self: Prank,
		player: Player,
		cb: (state: PrankModule.UserPrankStateData | nil, err: string | nil) -> ()
	) -> (),
	StoreStateForPlayer: (
		self: Prank,
		player: Player,
		state: StoredState,
		cb: (err: string | nil) -> ()
	) -> (),
}

Prank = {} :: Prank
Prank.__index = Prank
function Prank.New(provider: EventProvider): Prank
	local self = {
		provider = provider,
		streakBoost = 0,
		streakBoostMin = 0,
		playerStates = {},
		pendingRequests = {},
	} :: Prank
	setmetatable(self, Prank)
	return self
end

function Prank:SetStreakBoost(streakBoost: number, streakBoostMin: number): Prank
	self.streakBoost = streakBoost
	self.streakBoostMin = streakBoostMin
	return self
end

function Prank:CalculateTicketReward(state: PrankModule.UserPrankState, itemId: string | nil): number
	-- base tickets x action indicator boost x (1.0 + streak boost) x (1.0 + lucky token boost + item boost) x party time.

	local baseTickets = 300
	local actionItemBoost = self:GetTicketMultiplierForItem(itemId)

	local streakBoost = 1.0 + (0.05 * state.streak)

	local luckyTokenBoost = 1.0 + state.eventStatus.boostLuckyTokens

	local itemBoost = 1.0 + state.eventStatus.boostItems

	local superBoost =  1.0 + state.eventStatus.boostSuper

	local rarityBoost = fishRarityRewardsTable[caughtFishRarity]

	print("Base: " .. tostring(baseTickets) .. " Rarity: " .. tostring(rarityBoost) .. " Action: " .. tostring(actionItemBoost) .. " Streak: " .. tostring(streakBoost) .. " Lucky: " .. tostring(luckyTokenBoost) .. " Item: " .. tostring(itemBoost) .. " Super: " .. tostring(superBoost))

	return math.floor(baseTickets * streakBoost * luckyTokenBoost * itemBoost * superBoost * rarityBoost)
end

function Prank:CalculateTicketBoost(_eventStatus: PrankModule.TicketEventUserStatusData): number
	local luckyTokenBoost = _eventStatus.boostLuckyTokens
	local itemBoost = _eventStatus.boostItems

	return 1 + luckyTokenBoost + itemBoost
end

function Prank:ItemGuaranteesSuccess(itemId: string | nil): boolean
	return itemId == PrankModule.GUARANTEED_ITEM_ID or itemId == PrankModule.GUARANTEED_ITEM_AND_DOUBLE_TICKETS_ID
end

function Prank:ValidatePrankItem(state: PrankModule.UserPrankState, itemId: string | nil): boolean
	if itemId == nil then
		-- Using default item
		return true
	end

	if itemId ~= PrankModule.GUARANTEED_ITEM_ID and itemId ~= PrankModule.GUARANTEED_ITEM_AND_DOUBLE_TICKETS_ID then
		return false
	end

	return state:GetEventItem(itemId :: string).ownedAmount > 0
end

function Prank:ValidateSuperBoostItem(state: PrankModule.UserPrankState, itemId: string): boolean
	if itemId ~= PrankModule.STAGE_BONUS_TIME_1 and itemId ~= PrankModule.STAGE_BONUS_TIME_2 then
		return false
	end

	return state:GetEventItem(itemId :: string).ownedAmount > 0
end

function Prank:ValidateEnergyRefillItem(state: PrankModule.UserPrankState, itemId: string): boolean
	if itemId ~= PrankModule.ENERGY_REFILL_SMALL and itemId ~= PrankModule.ENERGY_REFILL_MAX then
		return false
	end

	return state:GetEventItem(itemId :: string).ownedAmount > 0
end

function Prank:GetTicketMultiplierForItem(itemId: string | nil): number
	if itemId == PrankModule.GUARANTEED_ITEM_AND_DOUBLE_TICKETS_ID then
		return 2
	end
	return 1
end

function Prank:OnSuccessfulPrank(
	player: Player,
	state: PrankModule.UserPrankState,
	itemId: string | nil,
	cb: (data: PrankModule.PrankResponseData | nil, err: string | nil) -> ()
): ()
	local luckyTokensWon = 0

	state.streak = state.streak + 1
	if state.streak > 15 then
		state.streak = 0
		luckyTokensWon = 5
	end

	self.playerStates[player.user.id] = {
		streak = state.streak,
	}

	if state.streak >= 11 then
		luckyTokensWon = 2
	end

	local ticketsAwarded = self:CalculateTicketReward(state, itemId)
	local energyLost = 0

	self.provider:ModifyPlayer(
		player,
		energyLost,
		luckyTokensWon,
		ticketsAwarded,
		itemId,
		function(response: StateModifiedResponse, err: string | nil)
			if err ~= nil then
				return cb(nil, err)
			end

			self:StoreStateForPlayer(player, state, function(err: string | nil)
				if err ~= nil then
					return cb(nil, err)
				end

				return cb({
					wasSuccessful = true,
					ranksAdvanced = response.ranksAdvanced,
					ticketsGained = ticketsAwarded,
					state = PrankModule.UserPrankState
						.New({
							streak = state.streak,
							eventStatus = response.status,
							ticketRewardBase = ticketsAwarded,
							ticketRewardTotal = ticketsAwarded,
							ticketBoost = self:CalculateTicketBoost(response.status),
						})
						:Serialize(),
				}, nil)
			end)
		end
	)
end

function Prank:OnFailedPrank(
	player: Player,
	state: PrankModule.UserPrankState,
	itemId: string | nil,
	cb: (data: PrankModule.PrankResponseData | nil, err: string | nil) -> ()
): ()
	-- Reset streak
	state.streak = 0

	self.playerStates[player.user.id] = {
		streak = state.streak,
	}

	local ticketsAwarded = 0
	local energyLost = 0
	local luckyTokensWon = 0

	-- Take 1 energy and give 0 tickets
	self.provider:ModifyPlayer(
		player,
		energyLost,
		luckyTokensWon,
		ticketsAwarded,
		itemId,
		function(response: StateModifiedResponse, err: string | nil)
			if err ~= nil then
				return cb(nil, err)
			end

			self:StoreStateForPlayer(player, state, function(err: string | nil)
				if err ~= nil then
					return cb(nil, err)
				end

				return cb({
					wasSuccessful = false,
					ranksAdvanced = response.ranksAdvanced,
					ticketsGained = ticketsAwarded,
					state = PrankModule.UserPrankState
						.New({
							streak = state.streak,
							eventStatus = response.status,
						})
						:Serialize(),
				}, nil)
			end)
		end
	)
end

function Prank:TryPrank(
	player: Player,
	itemId: string | nil,
	cb: (data: PrankModule.PrankResponseData | nil, err: string) -> ()
): ()
	self:QueryStateForPlayer(player, function(data: PrankModule.UserPrankStateData, err: string | nil)
		if err ~= nil then
			return cb(nil, err)
		end

		local state: PrankModule.UserPrankState = PrankModule.UserPrankState.New(data)
		--[[
		if state.eventStatus.energyAmount < 1 then
			return cb(nil, PrankModule.ERR_NOT_ENOUGH_ENERGY)
		end
		]]

		if not self:ValidatePrankItem(state, itemId) then
			return cb(nil, PrankModule.ERR_NOT_ENOUGH_ITEMS)
		end

		return self:OnSuccessfulPrank(player, state, itemId, cb)
	end)
end

function Prank:StartBoost(
	player: Player,
	itemId: string,
	cb: (err: string | nil) -> ()
): ()
	self:QueryStateForPlayer(player, function(data: PrankModule.UserPrankStateData, err: string | nil)
		if err ~= nil then
			return cb(err)
		end

		local state: PrankModule.UserPrankState = PrankModule.UserPrankState.New(data)

		if state.eventStatus.boostSuper > 0 then
			return cb(PrankModule.ERR_BOOST_ALREADY_ACTIVE)
		end

		if not self:ValidateSuperBoostItem(state, itemId) then
			print("Not enough items: " .. itemId)
			return cb(PrankModule.ERR_NOT_ENOUGH_ITEMS)
		end

        self.provider:ModifyPlayer(
            player,
            0,
			0,
            0,
            itemId,
            function(response: StateModifiedResponse, err: string | nil)
                return cb(err)
            end
        )

	end)
end

function Prank:RefillEnergy(
	player: Player,
	itemId: string,
	cb: (err: string | nil) -> ()
): ()
	self:QueryStateForPlayer(player, function(data: PrankModule.UserPrankStateData, err: string | nil)
		if err ~= nil then
			return cb(err)
		end

		local state: PrankModule.UserPrankState = PrankModule.UserPrankState.New(data)
		
		if not self:ValidateEnergyRefillItem(state, itemId) then
			print("Not enough items: " .. itemId)
			return cb(PrankModule.ERR_NOT_ENOUGH_ITEMS)
		end

        self.provider:ModifyPlayer(
            player,
            0,
			0,
            0,
            itemId,
            function(response: StateModifiedResponse, err: string | nil)
                return cb(err)
            end
        )

	end)
end

function Prank:QueryStateForPlayer(
	player: Player,
	cb: (state: PrankModule.UserPrankStateData | nil, err: string | nil) -> ()
)
	local stateQuery = function(state: StoredState)
		self.provider:GetStatusForPlayer(player, function(response: PrankModule.TicketEventUserStatusData | nil, err)
			if err ~= nil then
				return cb(nil, err)
			end
			cb(
				PrankModule.UserPrankState.New({
					streak = state.streak,
					eventStatus = response,
					ticketBoost = self:CalculateTicketBoost(response),
				}),
				nil
			)
		end)
	end

	local cachedState = self.playerStates[player.user.id]
	if cachedState == nil then
		Storage.GetPlayerValue(player, PersistentKey, function(data: StoredState | nil)
			if data == nil then
				-- Default state
				data = {
					streak = 0,
				}
			end

			self.playerStates[player.user.id] = data
			stateQuery(data)
		end)
		return
	end

	stateQuery(cachedState)
end

function Prank:StoreStateForPlayer(player: Player, state: StoredState, cb: (err: string | nil) -> ()): ()
	Storage.SetPlayerValue(player, PersistentKey, {
		streak = state.streak,
	}, function(errorCode)
		if errorCode ~= 0 then
			print("Something went wrong while storing player state: " .. tostring(errorCode))
			return cb(PrankModule.ERR_INTERNAL)
		end

		cb(nil)
	end)
end

export type MockEventProvider = {
	states: { [string]: PrankModule.TicketEventUserStatusData },
	New: () -> MockEventProvider,
} & EventProvider

MockEventProvider = {} :: MockEventProvider
MockEventProvider.__index = MockEventProvider
function MockEventProvider.New(): MockEventProvider
	local self = {
		states = {},
	} :: MockEventProvider
	setmetatable(self, MockEventProvider)
	return self
end

function MockEventProvider:NewState()
	return {
		boostLuckyTokens = 0,
		boostItems = 0,
		boostSuper = 0,
		ticketsTotal = 0,
		rank = 0,
		luckyTokens = 0,
		energyAmount = 8,
		-- More stuff:
		energyNextIncrementIn = 240,
		energyMax = 15,
		energyPerSecondIncrease = 240,
		-- 
		eventInventory = {
			{
				id = PrankModule.GUARANTEED_ITEM_ID,
				ownedAmount = 0,
				text = "Plain Purse",
				subText = "Guaranteed success!",
				imageUrl = "https://cdn.highrisegame.com/images/collectibles/box.webp",
			},
			{
				id = PrankModule.GUARANTEED_ITEM_AND_DOUBLE_TICKETS_ID,
				ownedAmount = 5,
				text = "Extravagant Purse",
				subText = "Guaranteed success, plus 2x tickets!",
				imageUrl = "https://cdn.highrisegame.com/images/collectibles/box_super.webp",
			},
			{
				id = PrankModule.ENERGY_REFILL_SMALL,
				ownedAmount = 5,
				text = "7 Energy",
				subText = "Refill 7 energy",
				imageUrl = "nil",				
			},
			{
				id = PrankModule.ENERGY_REFILL_MAX,
				ownedAmount = 5,
				text = "Max Energy",
				subText = "Refill all energy",
				imageUrl = "nil",				
			},
			{
				id = PrankModule.STAGE_BONUS_TIME_1,
				ownedAmount = 5,
				text = "30% Bonus",
				subText = "description",
				imageUrl = "nil",				
			},
			{
				id = PrankModule.STAGE_BONUS_TIME_2,
				ownedAmount = 5,
				text = "60% Bonus",
				subText = "description",
				imageUrl = "nil",
			}
		},
	} :: PrankModule.TicketEventUserStatusData
end

function MockEventProvider:GetStatusForPlayer(
	player: Player,
	cb: (response: PrankModule.TicketEventUserStatusData, err: any) -> ()
): ()
	local userId = player.user.id
	local data = self.states[userId]
	if data == nil then
		data = self:NewState()
		self.states[userId] = data
	end

	cb(data, nil)
end

function MockEventProvider:ModifyPlayer(
	player: Player,
	energyLost: number,
	luckyTokensWon: number,
	ticketsGained: number,
	itemToUse: string | nil,
	cb: (response: StateModifiedResponse | nil, err: any) -> ()
): ()
	local userId = player.user.id
	local data = self.states[userId]
	data.ticketsTotal = math.max(0, data.ticketsTotal + ticketsGained)
	data.energyAmount = math.max(0, data.energyAmount)
	data.rank = data.rank + 1
	data.luckyTokens = data.luckyTokens + luckyTokensWon

	if itemToUse == PrankModule.STAGE_BONUS_TIME_1 or itemToUse == PrankModule.STAGE_BONUS_TIME_2 then
		if itemToUse == PrankModule.STAGE_BONUS_TIME_1 then data.boostSuper =  .6 elseif itemToUse == PrankModule.STAGE_BONUS_TIME_2 then data.boostSuper = .3 end
	end

	if itemToUse == PrankModule.ENERGY_REFILL_SMALL then
		data.energyAmount = data.energyAmount + 7
	end

	if itemToUse == PrankModule.ENERGY_REFILL_MAX then
		data.energyAmount = 15
	end

	if itemToUse ~= nil then
		for _, item in ipairs(data.eventInventory) do
			if item.id == itemToUse then
				item.ownedAmount = math.max(0, item.ownedAmount - 1)
				break
			end
		end
	end

	cb({
		status = data,
		ranksAdvanced = 1,
	}, nil)
end

local _prank: Prank
if testMode then
	_prank = Prank.New(MockEventProvider.New())
else
	_prank = Prank.New({
		GetStatusForPlayer = function(
			_,
			player: Player,
			cb: (response: PrankModule.TicketEventUserStatusData | nil, err: any) -> ()
		)
			InternalTickets.GetStatusForPlayer(player, function(response: PrankModule.TicketEventUserStatusData, err)
				if err ~= 0 then
					print("Error while getting status for player: " .. tostring(err))
					return cb(nil, PrankModule.ERR_INTERNAL)
				end

				cb(PrankModule.TicketEventUserStatus.New(response):Serialize(), nil)
			end)
		end,
		ModifyPlayer = function(
			_,
			player: Player,
			energyLost: number,
			luckyTokensWon: number,
			ticketsGained: number,
			itemToUse: string | nil,
			cb: (response: StateModifiedResponse | nil, err: any) -> ()
		)
			local tr = InternalTicketsTransaction.new()
			if ticketsGained > 0 then
				tr:GiveTickets(ticketsGained)
			end
			--[[
			if energyLost > 0 then
				tr:TakeEnergy(energyLost)
			end
			--]]
			if luckyTokensWon > 0 then
				tr:GiveLuckyTokens(luckyTokensWon)
			end
			if itemToUse ~= nil then
				tr:TakeEventItem(itemToUse, 1)
			end

			InternalTickets.ChangeInventory(tr, player, function(
				response: {
					status: PrankModule.TicketEventUserStatusData,
					ranksAdvanced: number,
				},
				err
			)
				if err ~= 0 then
					print("Error while modifying player: " .. tostring(err))
					return cb(nil, PrankModule.ERR_INTERNAL)
				end

				cb({
					status = PrankModule.TicketEventUserStatus.New(response.status):Serialize(),
					ranksAdvanced = response.ranksAdvanced,
				}, nil)
			end)
		end,
	})
end

-- 30% boost after 6 consecutive successful pranks
_prank:SetStreakBoost(0.3, 6)

function Instance(): any
	return _prank
end

function self:ServerAwake()
	local instance = Instance()

	server.PlayerDisconnected:Connect(function(player)
		-- Clear player state on disconnect
		instance[player.user.id] = nil
	end)

	PrankModule.EVENTS.RequestState:Connect(function(player: Player)
		instance:QueryStateForPlayer(player, function(data: PrankModule.UserPrankStateData | nil, err: string | nil)
			PrankModule.EVENTS.StateResponse:FireClient(player, data, err)
		end)
	end)

	PrankModule.EVENTS.RequestPrank:Connect(function(player: Player, itemId: string | nil)
		local userId = player.user.id
		if instance.pendingRequests[userId] then
			PrankModule.EVENTS.PrankResponse:FireClient(player, nil, PrankModule.ERR_PENDING_REQUEST)
			return
		end

		instance.pendingRequests[userId] = true
		instance:TryPrank(player, itemId, function(data: PrankModule.PrankResponseData | nil, err: string | nil)
			instance.pendingRequests[userId] = nil
			PrankModule.EVENTS.PrankResponse:FireClient(player, data, err)
		end)
	end)
    
    PrankModule.EVENTS.RequestSuperBoost:Connect(function(player: Player, itemId: string | nil)
		local userId = player.user.id
		if instance.pendingRequests[userId] then
			PrankModule.EVENTS.SuperBoostResponse:FireClient(player, nil, PrankModule.ERR_PENDING_REQUEST)
			return
		end

		instance.pendingRequests[userId] = true
		instance:StartBoost(player, itemId, function(err: string | nil)
			instance.pendingRequests[userId] = nil
			PrankModule.EVENTS.SuperBoostResponse:FireClient(player, err)
		end)
	end)

	PrankModule.EVENTS.RequestEnergyRefill:Connect(function(player: Player, itemId: string | nil)
		local userId = player.user.id
		if instance.pendingRequests[userId] then
			PrankModule.EVENTS.SuperBoostResponse:FireClient(player, nil, PrankModule.ERR_PENDING_REQUEST)
			return
		end

		instance.pendingRequests[userId] = true
		instance:RefillEnergy(player, itemId, function(err: string | nil)
			instance.pendingRequests[userId] = nil
			PrankModule.EVENTS.EnergyRefillResponse:FireClient(player, err)
		end)
	end)

	PrankModule.EVENTS.ResetStreakRequest:Connect(function(player)
		instance.playerStates[player.user.id] = {
			streak = 0,
			PrankModule.EVENTS.ResetStreakResponse:FireClient(player)
		}
	end)

end
