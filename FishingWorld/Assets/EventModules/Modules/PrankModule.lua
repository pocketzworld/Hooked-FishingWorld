--!Type(Module)

EVENTS = {
	RequestState = Event.new("req_sstate"),
	StateResponse = Event.new("state_res"),
	RequestPrank = Event.new("req_prank"),
	PrankResponse = Event.new("prank_res"),
	RequestSuperBoost = Event.new("request_super_boost"),
	SuperBoostResponse = Event.new("super_boost_res"),
	RequestEnergyRefill = Event.new("req_energy_refill"),
	EnergyRefillResponse = Event.new("energy_refill_res"),
	ResetStreakRequest = Event.new("reset_streak_req"),
	ResetStreakResponse = Event.new("reset_streak_res"),
} :: { [string]: Event }

ERR_INTERNAL = "err_internal"
ERR_NOT_ENOUGH_ENERGY = "err_not_enough_energy"
ERR_NOT_ENOUGH_ITEMS = "err_not_enough_items"
ERR_PENDING_REQUEST = "err_pending_request"
ERR_TIMED_OUT = "err_timed_out"
ERR_BOOST_ALREADY_ACTIVE = "err_boost_already_active"

GUARANTEED_ITEM_ID = "stage_success_helper"
GUARANTEED_ITEM_AND_DOUBLE_TICKETS_ID = "stage_tickets_helper"

ENERGY_REFILL_SMALL = "energy_refill_small"
ENERGY_REFILL_MAX = "energy_refill_max"

STAGE_BONUS_TIME_1 = "stage_bonus_time_2"
STAGE_BONUS_TIME_2 = "stage_bonus_time_1"

export type TicketEventItemData = {
	id: string,
	ownedAmount: number,
	text: string,
	subText: string,
	imageUrl: string,
}

export type TicketEventItem = {
	New: (data: TicketEventItemData) -> TicketEventItem,
	Serialize: (self: TicketEventItem) -> TicketEventItemData,
} & TicketEventItemData

export type TicketEventUserStatusData = {
	boostLuckyTokens: number,
	boostItems: number,
	boostSuper: number,
	ticketsTotal: number,
	rank: number,
	energyNextIncrementIn: number,
	energyPerSecondIncrease: number,
	energyMax: number,
	eventInventory: { TicketEventItemData },
	luckyTokens: number,
	energyAmount: number,
}

export type TicketEventUserStatus = {
	New: (data: TicketEventUserStatusData) -> TicketEventUserStatus,
	Serialize: (self: TicketEventUserStatus) -> TicketEventUserStatusData,
} & TicketEventUserStatusData

export type UserPrankStateData = {
	ticketRewardBase: number,
	ticketRewardTotal: number,
	ticketBoost: number,
	streak: number,
	eventStatus: TicketEventUserStatusData,
}

export type UserPrankState = {
	New: (data: UserPrankStateData) -> UserPrankState,
	ticketRewardBase: number,
	ticketRewardTotal: number,
	ticketBoost: number,
	streak: number,
	eventStatus: TicketEventUserStatus,
	Serialize: (self: UserPrankState) -> UserPrankStateData,
	GetEventItem: (self: UserPrankState, itemId: string) -> TicketEventItem,
}

export type PrankResponseData = {
	ranksAdvanced: number,
	ticketsGained: number,
	wasSuccessful: boolean,

	state: UserPrankStateData,
}

export type PrankResponse = {
	ranksAdvanced: number,
	ticketsGained: number,
	wasSuccessful: boolean,
	state: UserPrankState,
}

local function TabLines(str: string): string
	local lines = {}
	for line in str:gmatch("[^\n]+") do
		table.insert(lines, "\t" .. line)
	end

	return table.concat(lines, "\n")
end

TicketEventItem = {} :: TicketEventItem
TicketEventItem.__index = TicketEventItem
function TicketEventItem.New(data: TicketEventItemData): TicketEventItem
	local self = {
		id = data.id,
		ownedAmount = data.ownedAmount,
		text = data.text,
		subText = data.subText,
		imageUrl = data.imageUrl,
	} :: TicketEventItem
	setmetatable(self, TicketEventItem)
	return self
end

function TicketEventItem:__tostring(): string
	return string.format(
		"TicketEventItem(\n\tid: %s, \n\tamount: %d, \n\ttext: %s, \n\tsubText: %s, \n\timageUrl: %s\n)",
		self.id,
		self.ownedAmount,
		self.text,
		self.subText,
		self.imageUrl:sub(1, 12) .. "..."
	)
end

function TicketEventItem:Serialize(): TicketEventItemData
	return {
		id = self.id,
		ownedAmount = self.ownedAmount,
		text = self.text,
		subText = self.subText,
		imageUrl = self.imageUrl,
	}
end

TicketEventUserStatus = {} :: TicketEventUserStatus
TicketEventUserStatus.__index = TicketEventUserStatus
function TicketEventUserStatus.New(data: TicketEventUserStatusData): TicketEventUserStatus
	local self = {
		boostLuckyTokens = data.boostLuckyTokens,
		boostItems = data.boostItems,
		boostSuper = data.boostSuper,
		ticketsTotal = data.ticketsTotal,
		rank = data.rank,
		energyNextIncrementIn = data.energyNextIncrementIn,
		energyPerSecondIncrease = data.energyPerSecondIncrease,
		energyMax = data.energyMax,
		eventInventory = {},
		luckyTokens = data.luckyTokens,
		energyAmount = data.energyAmount,
	} :: TicketEventUserStatus
	setmetatable(self, TicketEventUserStatus)

	for _, itemData in ipairs(data.eventInventory) do
		table.insert(self.eventInventory, TicketEventItem.New(itemData))
	end

	return self
end

function TicketEventUserStatus:Serialize(): TicketEventUserStatusData
	local items: { TicketEventItemData } = {}
	for _, item in ipairs(self.eventInventory) do
		table.insert(items, item:Serialize())
	end

	return {
		boostLuckyTokens = self.boostLuckyTokens,
		boostItems = self.boostItems,
		boostSuper = self.boostSuper,
		ticketsTotal = self.ticketsTotal,
		rank = self.rank,
		energyNextIncrementIn = self.energyNextIncrementIn,
		energyPerSecondIncrease = self.energyPerSecondIncrease,
		energyMax = self.energyMax,
		eventInventory = items,
		luckyTokens = self.luckyTokens,
		energyAmount = self.energyAmount,
	}
end

function TicketEventUserStatus:__tostring(): string
	local items = {}
	for _, item in ipairs(self.eventInventory) do
		table.insert(items, TabLines(tostring(item)))
	end

	local itemStr = TabLines(table.concat(items, ", "))

	return string.format(
		"TicketEventUserStatus(\n\tboostLuckyTokens: %f, \n\tboostItems: %f, \n\tboostSuper: %f, \n\tticketsTotal: %d, \n\trank: %d, \n\tenergyNextIncrementIn: %d, \n\tenergyPerSecondIncrease: %d, \n\tenergyMax: %d, \n\tluckyTokens: %d, \n\tenergyAmount: %d, \n\teventInventory: [\n%s\n\t]\n)",
		self.boostLuckyTokens,
		self.boostItems,
		self.boostSuper,
		self.ticketsTotal,
		self.rank,
		self.energyNextIncrementIn,
		self.energyPerSecondIncrease,
		self.energyMax,
		self.luckyTokens,
		self.energyAmount,
		itemStr
	)
end

UserPrankState = {} :: UserPrankState
UserPrankState.__index = UserPrankState
function UserPrankState.New(data: UserPrankStateData): UserPrankState
	local self = {
		ticketRewardBase = data.ticketRewardBase,
		ticketRewardTotal = data.ticketRewardTotal,
		ticketBoost = data.ticketBoost,
		streak = data.streak,
		eventStatus = TicketEventUserStatus.New(data.eventStatus),
	} :: UserPrankState
	setmetatable(self, UserPrankState)
	return self
end

function UserPrankState:Serialize(): UserPrankStateData
	return {
		ticketRewardBase = self.ticketRewardBase,
		ticketRewardTotal = self.ticketRewardTotal,
		ticketBoost = self.ticketBoost,
		streak = self.streak,
		eventStatus = self.eventStatus:Serialize(),
	}
end

function UserPrankState:__tostring(): string
	return string.format(
		"UserPrankState(\n\tstreak: %d, \n\teventStatus: %s\n)",
		self.streak,
		TabLines(tostring(self.eventStatus))
	)
end

function UserPrankState:GetEventItem(itemId: string): TicketEventItem
	--print("GetEventItem", itemId)
	for _, item in ipairs(self.eventStatus.eventInventory) do
		if item.id == itemId then
			return item
		end
	end

	error("Item not found")
end

PrankResponse = {} :: PrankResponse
PrankResponse.__index = PrankResponse
function PrankResponse.New(data: PrankResponseData): PrankResponse
	local self = {
		ranksAdvanced = data.ranksAdvanced,
		ticketsGained = data.ticketsGained,
		wasSuccessful = data.wasSuccessful,
		state = UserPrankState.New(data.state),
	} :: PrankResponse
	setmetatable(self, PrankResponse)
	return self
end

function PrankResponse:__tostring(): string
	return string.format(
		"PrankResponse(\n\tranksAdvanced: %d, \n\tticketsGained: %d, \n\twasSuccessful: %s, \nstate: %s\n)",
		self.ranksAdvanced,
		self.ticketsGained,
		tostring(self.wasSuccessful),
		TabLines(tostring(self.state))
	)
end
