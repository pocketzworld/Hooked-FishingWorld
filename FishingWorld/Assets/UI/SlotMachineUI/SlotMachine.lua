--!Type(UI)

--!SerializeField
local ItemIcons: {Texture} = nil
--!SerializeField
local SpinEasing : AnimationCurve = nil

--!Bind
local player_wallet_text : Label = nil

--!Bind
local slot_machine_container: VisualElement = nil
--!Bind
local slot_container: VisualElement = nil
--!Bind
local wheel_one: VisualElement = nil
--!Bind
local wheel_two: VisualElement = nil
--!Bind
local wheel_three: VisualElement = nil
--!Bind
local center: VisualElement = nil

--!Bind
local bingo_button : VisualElement = nil

--!Bind
local click_off : VisualElement = nil
--!Bind
local exit_label : VisualElement = nil

--!Bind
local powerup_one : VisualElement = nil
--!Bind
local powerup_two : VisualElement = nil

local TweenModule = require("TweenModule")
local Tween = TweenModule.Tween
local Easing = TweenModule.Easing

local audioManager = require("AudioManager")
local uiManagr = require("UIManager")
local slotMachineManager = require("SlotMachineManager")
local playerTracker = require("PlayerTracker")
local inventoryManager = require("PlayerInventoryManager")

local canSpin = true
local hasTokens = true

local power_slots = {
    powerup_one,
    powerup_two
}


local mainPopInTween = Tween:new(
    .4,
    1,
    .3,
    false,
    false,
    Easing.easeOutBack,
    function(value, t)
        slot_machine_container.style.scale = StyleScale.new(Scale.new(Vector2.new(value, value)))
    end,
    function()
        slot_machine_container.style.scale = StyleScale.new(Scale.new(Vector2.new(1, 1)))
    end
)

function SpinWheelAnimations(wheel : VisualElement)
    local SpinTween = Tween:new(
        -1400,
        0,
        .75,
        false,
        false,
        function(t)
            return SpinEasing:Evaluate(t)
        end,
        function(value, t)
            wheel.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.new(value)))
        end,
        function()
            wheel.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.new(0)))
        end
    )

    SpinTween:start()
end

function CreateItem(itemID: number, wheel: VisualElement)
    local _item = Image.new()
    _item:AddToClassList("Slot__Item")

    _item.image = ItemIcons[itemID]

    wheel:Add(_item)
    return _item
end

function Spin(prizeID : number, wheel : VisualElement, delay : number | nil)
    if delay then
        Timer.After(delay, function()
            audioManager.playSparkle()
            wheel:Clear()
            wheel.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.new(-1400)))
            for i=1, 20 do 
                if i == 2 then
                    local new_final_item = CreateItem(prizeID, wheel)
                    Timer.After(1.25, function()
                        new_final_item:AddToClassList("Slot__Item--Main")
                        audioManager.playPop()
                    end)
                else
                    CreateItem(math.random(1, #ItemIcons), wheel)
                end
            end
            SpinWheelAnimations(wheel)
        end)
    else
        wheel:Clear()
        wheel.style.translate = StyleTranslate.new(Translate.new(Length.new(0), Length.new(-1400)))
        for i=1, 20 do 
            if i == 2 then
                local new_final_item = CreateItem(prizeID, wheel)
                new_final_item:AddToClassList("Slot__Item--Main")
            else
                CreateItem(math.random(1, #ItemIcons), wheel)
            end
        end
    end
end

function Activate(rewardID: number | nil)

    local spins = {1,2,3,4,5}
    if not rewardID then
        -- ShuffleSpins
        for i = #spins, 2, -1 do
            local j = math.random(i)
            spins[i], spins[j] = spins[j], spins[i]
        end
        spins[2] = math.random(1, #ItemIcons)
    end

    Spin(rewardID or spins[1], wheel_one, 0)
    Spin(rewardID or spins[2], wheel_two, .5)
    Spin(rewardID or spins[3], wheel_three, 1)
end

bingo_button:RegisterPressCallback(function()
    if hasTokens and canSpin then
        canSpin = false
        Timer.After(3, function()
            canSpin = true
        end)
        slotMachineManager.RequestSlot()
        audioManager.playPop()
    end
end)

click_off:RegisterPressCallback(function()
    uiManagr.CloseSlotMachine()
end)
exit_label:RegisterPressCallback(function()
    uiManagr.CloseSlotMachine()
end)


-- Function to generate a power up ui element and add it to the next available slot
function create_powerup(powerupId)
    local powerup = VisualElement.new()
    powerup:AddToClassList("powerup")
    powerup:AddToClassList("powerup-"..powerupId)

    powerup:RegisterPressCallback(function()
    end)

    -- Find the next available slot
    for i, slot in ipairs(power_slots) do
        if slot.childCount == 0 then
            slot:Add(powerup)
            break
        end
    end

end

function UpdatePowerUps(inventory, oldInv)
    for j, powerupSlot in ipairs(power_slots) do
        powerupSlot:Clear()
    end

    for i, item in ipairs(inventory) do
        if table.find(inventoryManager.powerup_ids, item.id) then
            for i = 1, item.amount do
                create_powerup(item.id)
            end
        end
    end
end

function self:Start()
    Spin(1, wheel_one  , nil)
    Spin(1, wheel_two  , nil)
    Spin(1, wheel_three, nil)

    slotMachineManager.playerSlotResponse:Connect(function(rewardID)
        print("Player Slot Response Received", tostring(rewardID))
        Activate(rewardID)
        if rewardID then 
            Timer.After(2, function()
                audioManager.PlayPerfect()
            end)
        end
    end)
    slotMachineManager.rewardAnimationEvent:Connect(function(rewardID)
        if rewardID == 1 then uiManagr.PlaySlotsRewardAnimation(center, 5, "+75 Chips!", ItemIcons[rewardID])
        elseif rewardID == 2 then uiManagr.PlayPowerUpRewardAnimation(center, 1, "Free Daub!", ItemIcons[rewardID])
        elseif rewardID == 3 then uiManagr.PlaySlotsRewardAnimation(center, 15, "+500 Chips!", ItemIcons[rewardID])
        elseif rewardID == 4 then uiManagr.PlaySlotsRewardAnimation(center, 1, "+1 Gold!", ItemIcons[rewardID])
        end
    end)

    playerTracker.players[client.localPlayer].Tokens.Changed:Connect(function(newTokens, OldTokens)
        local tickerTween = Tween:new(
            OldTokens,
            newTokens,
            .5,
            false,
            false,
            Easing.linear,
            function(value, t)
                player_wallet_text.text = tostring(math.floor(value))
            end
        )
        tickerTween:start()

        if newTokens < 100 then
            hasTokens = false
            bingo_button:EnableInClassList("locked-button", true)
        else
            hasTokens = true
            bingo_button:EnableInClassList("locked-button", false)
        end
        audioManager.PlayRapidTick()
    end)

    playerTracker.players[client.localPlayer].playerInventory.Changed:Connect(UpdatePowerUps)
    self.gameObject:SetActive(false)
end

function OpenAnims()
    audioManager.PlayRapidTick()

    audioManager.playPop()
    mainPopInTween:start()
    local tickerTween = Tween:new(
        0,
        playerTracker.players[client.localPlayer].Tokens.value,
        .5,
        false,
        false,
        Easing.linear,
        function(value, t)
            player_wallet_text.text = tostring(math.floor(value))
        end
    )
    tickerTween:start()
end