--!Type(UI)

--!SerializeField
local image1 : Texture = nil
--!SerializeField
local image2 : Texture = nil
--!SerializeField
local image3 : Texture = nil

--!Bind
local drawer_root : UILuaView = nil
--!Bind
local drawer : VisualElement = nil
--!Bind
local toggleButton : VisualElement = nil
--!Bind
local stageLabel : Label = nil
--!Bind
local ticketsAmount : Label = nil
--!Bind
local rocketAmount : Label = nil
--!Bind
local totalAmount : Label = nil
--!Bind
local miniStripLabel_streak : Label = nil
--!Bind
local miniStripLabel_boost : Label = nil
--!Bind
local squareRow : VisualElement = nil
--!Bind
local boostButton : VisualElement = nil

local isDrawerOpen = true

local clientPrankModule = require("ClientPrankModule")
local ServerPrankModule = require("ServerPrankModule")
local PrankModule = require("PrankModule")
local UIModule = require("UIModule")
--local audioModule = require("AudioManager")

function ToggleDrawer()
    isDrawerOpen = not isDrawerOpen
    drawer:EnableInClassList("close", not isDrawerOpen)
    --if audioModule.PlaySound then audioModule.PlaySound("refreshPopup", 1) end
end

-- Procedurally make an item element
function MakeEventItem (text : string, amount : number, texture : Texture, cb : () -> ())
    local itemElement = VisualElement.new()
    itemElement:AddToClassList("square-element")

    local imageEl = UIImage.new()
    imageEl.image = texture
    imageEl:AddToClassList("square-image")
    itemElement:Add(imageEl)

    local text = Label.new(text)
    text:AddToClassList("square-label")
    itemElement:Add(text)

    local amountElement = VisualElement.new()
    amountElement:AddToClassList("square-amount")
    local amountLabel = Label.new("x" .. tostring(amount))
    amountLabel:AddToClassList("square-amount-label")
    amountElement:Add(amountLabel)
    itemElement:Add(amountElement)

    if amount == 0 then
        itemElement:AddToClassList("empty")
        itemElement:RegisterPressCallback(function() 
            --print("ITEM EMPTY: OPEN THE SHOP DEEPLINK")
            UI:ExecuteDeepLink("https://high.rs/shop?type=ic&id=66dde521dc5a2eeb8f86ba88")
            CloseDrawer()
        end)
    elseif amount == math.huge then
        amountElement:AddToClassList("hidden")
        itemElement:RegisterPressCallback(cb)
    else
        itemElement:RegisterPressCallback(cb)
    end

    return itemElement
end

function OpenDrawer(state : PrankModule.UserPrankState, taskScript : TaskScript)
    
    self.gameObject:SetActive(true)
    Timer.After(0.05, function() ToggleDrawer() end)

    local EventConsumables = clientPrankModule.GetConsumables(state)[1]
    squareRow:Clear()
    for _, item in ipairs(EventConsumables) do
		local itemElement = MakeEventItem(item.text, item.ownedAmount, item.image, function()

            ----- ITEM SELECTED CALLBACK -----

            --- Check Energy First ---
            local energy = state.eventStatus.energyAmount
            if energy <= 0 then
                UIModule.ShowPopup("refill", state)
                return
            end

            --- Close the Drawer ---
            clientPrankModule.HidePrankUI()
            CloseDrawer()

			----- CLIENT ACTION TO TAKE PLACE BEFORE ACTUALLY PRANKING	-----
			taskScript.DoTask(function(complete)
				if not complete then print("Error: Task Could Not Complete") return end

				----- START PRANK REQUEST -----
				clientPrankModule.RequestPrank(item.id, function(res, err)
					if err ~= nil then
						print("Error requesting prank: " .. err)
						return
					end

					--print("Prank: " .. tostring(res))
					UIModule.ShowDrawer("response", res)
				end)
			end)
		end)

        squareRow:Add(itemElement)
    end

    --stageLabel.text = ("Stage " .. tostring(state.stageId) .. "/" .. tostring(state.totalStages))
    ticketsAmount.text = tostring(state.ticketRewardBase) .. " X"
    rocketAmount.text = tostring(math.floor(state.ticketBoost)) .. "x ="
    totalAmount.text = tostring(math.floor(state.ticketRewardTotal))
    miniStripLabel_streak.text = "+" .. tostring(state.streak) .. "X Streak!"
    miniStripLabel_boost.text = "+" .. tostring(math.floor(state.eventStatus.boostSuper * 10) *10) .. "% Super Boost!"
    miniStripLabel_boost:EnableInClassList("hidden", state.eventStatus.boostSuper == 0)
    boostButton:EnableInClassList("hidden", state.eventStatus.boostSuper ~= 0)
end

function CloseDrawer()
    if isDrawerOpen then
        ToggleDrawer()
    end
    Timer.After(0.3, function() self.gameObject:SetActive(false) end)
end

boostButton:RegisterPressCallback(function()
    clientPrankModule.ShowBoostUI()
    --audioModule.PlaySound("errorSound1", 1)
end)

drawer_root:RegisterPressCallback(CloseDrawer)
drawer:RegisterPressCallback(CloseDrawer)

CloseDrawer()

function self:ClientAwake()
    Input.Tapped:Connect(function()
        if isDrawerOpen then
            CloseDrawer()
        end
    end)
end