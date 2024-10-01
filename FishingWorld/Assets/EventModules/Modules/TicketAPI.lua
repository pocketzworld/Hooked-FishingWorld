--!Type(Module)

if not server then
	return
end

export type EventItemData = {
	id: string,
	ownedAmount: number,
	text: string,
	subText: string,
	imageUrl: string,
}

export type ParticipationTierRewardData = {
	_id: string,
	category: string,
	amount: number,
	item_id: string,
	account_bound: boolean,
}

export type TierData = {
	_id: string,
	min: number,
	max: number | nil,
	rewards: { ParticipationTierRewardData },
}

export type EventData = {
	_id: string,
	is_live: boolean,
	participation_tiers: { TierData },
	user_tiers: { TierData },
	crew_tiers: { TierData },
}

export type EventUserStatusData = {
	boostLuckyTokens: number,
	boostItems: number,
	boostSuper: number,
	ticketsTotal: number,
	rank: number,
	energyNextIncrementIn: number,
	energyPerSecondIncrease: number,
	energyMax: number,
	eventInventory: { EventItemData },
	luckyTokens: number,
	energyAmount: number,
}

export type StateModifiedResponse = {
	ranksAdvanced: number,
	status: EventUserStatusData,
}

type TicketAPI = {
	baseURL: string,
	New: (baseURL: string) -> TicketAPI,
	GetStatusForPlayer: (player: Player, cb: (response: EventUserStatusData | nil, err: any) -> ()) -> (),
	ModifyPlayer: (
		player: Player,
		energyLost: number,
		luckyTokensWon: number,
		ticketsGained: number,
		itemToUse: string | nil,
		cb: (response: StateModifiedResponse | nil, err: any) -> ()
	) -> (),
}

TicketAPI = {}
TicketAPI.__index = TicketAPI
function TicketAPI.New(baseURL: string): TicketAPI
	local self = {} :: TicketAPI
	setmetatable(self, TicketAPI)
	self.baseURL = baseURL
	return self
end

function TicketAPI:DecodeStatus(json: any): EventUserStatusData
	local res: EventUserStatusData = {
		boostLuckyTokens = json["boosts"]["lucky_tokens"],
		boostItems = json["boosts"]["items"],
		boostSuper = json["boosts"]["super_boost"],
		ticketsTotal = json["tickets"],
		rank = json["rank"],
		energyNextIncrementIn = json["event_wallet"]["energy"]["nextIncrementIn"],
		energyPerSecondIncrease = json["event_wallet"]["energy"]["secondsPerIncrease"],
		energyMax = json["event_wallet"]["energy"]["max"],
		luckyTokens = json["event_wallet"]["luckyTokens"],
		energyAmount = json["event_wallet"]["energy"]["amount"],
		eventInventory = {},
	}

	for _, itemData in ipairs(json["event_inventory"]) do
		local item: EventItemData = {
			id = itemData["item_id"],
			ownedAmount = itemData["amount"],
			text = itemData["text"],
			subText = itemData["subtext"],
			imageUrl = itemData["image_url"],
		}

		table.insert(res.eventInventory, item)
	end

	return res
end

function TicketAPI:GetData(cb: (response: EventData | nil, err: any) -> ()): ()
	local req = HTTPRequest.new(self.baseURL .. "/realm/direct/tickets_event", HTTPMethod.GET)

	req:SetHeader("Content-Type", "application/json")

	req:SetHeader("x-world-id", "66bf8479a69108d97800051e") --- FOR TEST IN STUDIO

	HTTPClient.Request(req, function(res, err)
		if err == HTTPError.None then
			cb(res:GetJSONBody(), nil)
		else
			cb(nil, tostring(err))
		end
	end)
end

function TicketAPI:GetStatusForPlayer(player: Player, cb: (response: EventUserStatusData | nil, err: any) -> ()): ()
	local req = HTTPRequest.new(self.baseURL .. "/realm/direct/tickets_user_status", HTTPMethod.GET)

	req:SetHeader("Content-Type", "application/json")
	req:SetQueryParameter("user_id", player.user.id)

	req:SetHeader("x-world-id", "66bf8479a69108d97800051e") --- FOR TEST IN STUDIO

	HTTPClient.Request(req, function(res, err)
		if err == HTTPError.None then
			print(tostring(res:GetBody()))
			local json = res:GetJSONBody()
			cb(self:DecodeStatus(json), nil)
		else
			cb(nil, tostring(err))
		end
	end)
end

function TicketAPI:ModifyPlayer(
	player: Player,
	energyLost: number,
	luckyTokensWon: number,
	ticketsGained: number,
	itemToUse: string | nil,
	cb: (response: StateModifiedResponse | nil, err: any) -> ()
): ()
	local req = HTTPRequest.new(self.baseURL .. "/realm/direct/tickets_change_inventory", HTTPMethod.POST)

	req:SetHeader("Content-Type", "application/json")
	local cost = {}
	if itemToUse ~= nil then
		table.insert(cost, {
			item_id = itemToUse,
			amount = 1,
		})
	end

	req:SetHeader("x-world-id", "66bf8479a69108d97800051e") --- FOR TEST IN STUDIO

	req:SetJSONBody({
		user_id = player.user.id,
		tickets_won = ticketsGained,
		energy_lost = energyLost,
		lucky_tokens = luckyTokensWon,
		cost = cost,
		rewards = {},
	})

	HTTPClient.Request(req, function(res, err)
		if err == HTTPError.None then
			local json = res:GetJSONBody()
			cb({
				status = self:DecodeStatus(json["status"]),
				ranksAdvanced = json["ranks_advanced"],
			}, nil)
		else
			cb(nil, tostring(err))
		end
	end)
end

function New(baseURL: string): TicketAPI
	return TicketAPI.New(baseURL)
end
