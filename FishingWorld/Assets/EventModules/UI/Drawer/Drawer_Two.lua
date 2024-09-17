--!Type(UI)

--!Bind
local drawer_response_root : UILuaView = nil
--!Bind
local drawer2 : VisualElement = nil
--!Bind
local toggleButton2 : VisualElement = nil
--!Bind
local resultLabel : Label = nil
--!Bind
local stageLabel : Label = nil
--!Bind
local currentAmount : Label = nil
--!Bind
local plusAmount : Label = nil
--!Bind
local rankLabel : Label = nil
--!Bind
local rankProgress : Label = nil
--!Bind
local rankIcon : VisualElement = nil
--!Bind
local resultIcon : VisualElement = nil
--!Bind
local luckyTokensStrip : VisualElement = nil
--!Bind
local luckyTokensAmount : Label = nil

local isDrawerOpen = true

--local audioModule = require("AudioManager")
local PrankModule = require("PrankModule")
preTokens = 0

function ToggleDrawer()
    isDrawerOpen = not isDrawerOpen
    drawer2:EnableInClassList("close", not isDrawerOpen)
    --if audioModule.PlaySound then audioModule.PlaySound("refreshPopup", 1) end
end

function OpenDrawer(response : PrankModule.PrankResponse)

    self.gameObject:SetActive(true)
    Timer.After(0.05, function() ToggleDrawer() end)

    local wasSuccessful = response.wasSuccessful
    drawer2:EnableInClassList("fail", not wasSuccessful)
    resultIcon:EnableInClassList("fail", not wasSuccessful)
    resultLabel:EnableInClassList("fail", not wasSuccessful)
    stageLabel:EnableInClassList("fail", not wasSuccessful)

    if wasSuccessful then
        resultLabel.text = "Success! " .. tostring(response.isBonus and "Bonus!" or "")
        --stageLabel.text = "Promoted to Stage " .. tostring(response.state.stageId) .. " / " .. response.state.totalStages
        plusAmount.text = "+" .. tostring(response.ticketsGained)

        --audioModule.PlaySound("successSound1", 1)
        client.localPlayer.character:PlayEmote("emoji-flex", false)
    else
        resultLabel.text = "Oh No!"
        --stageLabel.text = "Demoted to Stage " .. tostring(response.state.stageId) .. " / " .. response.state.totalStages
        plusAmount.text = ""

        --audioModule.PlaySound("failSound1", 1)
        client.localPlayer.character:PlayEmote("emoji-angry", false)
    end
    
    currentAmount.text = tostring(response.state.eventStatus.ticketsTotal)

    rankLabel.text = "Rank " .. tostring(response.state.eventStatus.rank)

    if response.ranksAdvanced ~= 0 then
        rankProgress.text =  tostring(math.abs(response.ranksAdvanced))
        rankIcon:EnableInClassList("fail", response.ranksAdvanced < 0)
        rankProgress:EnableInClassList("fail", response.ranksAdvanced < 0)

        rankIcon:EnableInClassList("hidden", false)
        rankProgress:EnableInClassList("hidden", false)
    else
        rankIcon:EnableInClassList("hidden", true)
        rankProgress:EnableInClassList("hidden", true)
    end

    local luckyTokenIncrease = response.state.eventStatus.luckyTokens - preTokens
    luckyTokensStrip:EnableInClassList("hidden", not (luckyTokenIncrease > 0))
    luckyTokensAmount.text = "+" .. tostring(luckyTokenIncrease) .. " Lucky Tokens"

end

function CloseDrawer()
    if isDrawerOpen then
        ToggleDrawer()
    end
    Timer.After(0.3, function() self.gameObject:SetActive(false) end)
end

drawer_response_root:RegisterPressCallback(CloseDrawer)
drawer2:RegisterPressCallback(CloseDrawer)

CloseDrawer()

function self:ClientAwake()
    Input.Tapped:Connect(function()
        if isDrawerOpen then
            CloseDrawer()
        end
    end)
end