--!Type(UI)

--!SerializeField
local default_fish : Texture2D = nil

--!Bind
local actionButton : VisualElement = nil
--!Bind
local actionLabel : UILabel = nil
--!Bind
local fishSlider : UISlider = nil
--!Bind
local hookSlider : UISlider = nil
--!Bind
local fishProgressBar : UIProgressBar = nil

--!Bind
local FishingElement : VisualElement = nil

local gameManager = require("GameManager")
local FishMetaData = require("FishMetaData")
local fish_metadata = FishMetaData.fish_metadata

actionLabel:SetPrelocalizedText("Tap!")
actionButton:RegisterPressCallback(function()
    gameManager.increaseValueOnPress()
end, true, true, true)

fishSlider.highValue = 350
hookSlider.highValue = 350

function UpdateHook(arg)
    hookSlider:SetValueWithoutNotify(arg)
end

function UpdateFish(arg)
    fishSlider:SetValueWithoutNotify(arg)
end

function UpdateProgressBar(arg)
    fishProgressBar.value = arg
end

function CreatFishBarIcon(fishID)
    local fishIcon = fishSlider:Q("_knob")
    fishIcon:Clear()
    local fishTexture = default_fish --fish_metadata[fishID].FishImage
    local _fishImage = Image.new()
    _fishImage:AddToClassList("fishIcon")
    _fishImage.image = fishTexture
    fishIcon:Add(_fishImage)
end

function HideMiniGame()
    FishingElement:EnableInClassList("hidden", true)
    actionButton:EnableInClassList("hidden", true)
end
function ShowMiniGame(fishName : string, playerStrength : number)
    FishingElement:EnableInClassList("hidden", false)
    actionButton:EnableInClassList("hidden", false)
    CreatFishBarIcon(fishName)
end

HideMiniGame()