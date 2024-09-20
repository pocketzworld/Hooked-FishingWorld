--!Type(UI)

--!Bind
local event_hud : UILuaView = nil
--!Bind
local ticketsLabel : Label = nil
--!Bind
local boostLabel : Label = nil
--!Bind
local ticketsAddLabel : Label = nil
--!Bind
local tokensAddLabel : Label = nil
--!Bind
local miniStripLabel_boost : Label = nil
--!Bind
local miniStripLabel_streak : Label = nil
--!Bind
local rankLabel : Label = nil
--!Bind
local boostButton : VisualElement = nil

local boostActive = false

local clientPrankModule = require("ClientPrankModule")
local PrankModule = require("PrankModule")

function UpdateEventValuesResponse(response : PrankModule.PrankResponse, tokensGained : number)
    local totallTickets = response.state.eventStatus.ticketsTotal
    local gainedTickets = response.ticketsGained
    local rank = response.state.eventStatus.rank

    ticketsLabel.text = tostring(totallTickets)
    boostLabel.text = tostring(string.format("%.1f", response.state.ticketBoost)) .. "X"
    ticketsAddLabel.text = "+" .. tostring(gainedTickets)
    tokensAddLabel.text = "+" .. tostring(tokensGained)

    miniStripLabel_boost.text = "+" .. tostring(math.floor(response.state.eventStatus.boostSuper * 10)*10) .. "% Super Boost!"
    miniStripLabel_streak.text = "+" .. tostring(response.state.streak) .. "X Streak"

    rankLabel.text = "Rank " .. tostring(rank)

    ticketsAddLabel:EnableInClassList("invis", gainedTickets <= 0)
    tokensAddLabel:EnableInClassList("invis", tokensGained <= 0)
    Timer.After(1, function()
        ticketsAddLabel:EnableInClassList("invis", true)
        tokensAddLabel:EnableInClassList("invis", true)
    end)
    
    miniStripLabel_boost:EnableInClassList("hidden", response.state.eventStatus.boostSuper <= 0)
    boostActive = response.state.eventStatus.boostSuper ~= 0
    boostButton:EnableInClassList("hidden", boostActive)
    MoveSuperBoostTimer()
end

function UpdateEventValuesState(state)
    local totallTickets = state.eventStatus.ticketsTotal

    local rank = state.eventStatus.rank

    ticketsLabel.text = tostring(totallTickets)
    boostLabel.text = tostring(string.format("%.1f", state.ticketBoost)) .. "X"

    miniStripLabel_boost.text = "+" .. tostring(math.floor(state.eventStatus.boostSuper * 10)*10) .. "% Super Boost!"
    miniStripLabel_streak.text = "+" .. tostring(state.streak) .. "X Streak"
    rankLabel.text = "Rank " .. tostring(rank)

    miniStripLabel_boost:EnableInClassList("hidden", state.eventStatus.boostSuper <= 0)
    boostActive = state.eventStatus.boostSuper ~= 0
    boostButton:EnableInClassList("hidden", boostActive)
    MoveSuperBoostTimer()
end

function ResetStreak()
    miniStripLabel_streak.text = "+0X Streak"
end

boostButton:RegisterPressCallback(function()
    clientPrankModule.ShowBoostUI()
    --audioModule.PlaySound("errorSound1", 1)
end)


function MoveSuperBoostTimer()
    _aboveChat = event_hud.parent.parent
    _superBoost = _aboveChat:Q(nil, "event-super-boost-hud-head")

    if _superBoost == nil then return end
    _superBoost.style.bottom = StyleLength.new(90)
end

function ToggleBoostTimer(active : boolean)
    if not boostActive then
        _superBoost.style.display = DisplayStyle.None
        return 
    end

    _aboveChat = event_hud.parent.parent
    _superBoost = _aboveChat:Q(nil, "event-super-boost-hud-head")

    if _superBoost == nil then return end
    _superBoost.style.display = active and DisplayStyle.Flex or DisplayStyle.None
end

function self:ClientAwake()
    MoveSuperBoostTimer()
end