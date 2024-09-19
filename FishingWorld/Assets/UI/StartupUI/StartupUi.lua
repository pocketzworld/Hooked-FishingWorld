--!Type(UI)

--!SerializeField
local Pages : {Texture} = nil

--!Bind
local startupContainer : VisualElement = nil
--!Bind
local tutorialImage : Image = nil

local uiManager = require("UIManager")

local page = 1
tutorialImage.image = Pages[page]
startupContainer:RegisterPressCallback(function()
    if page >= #Pages then
        self.gameObject:SetActive(false)
        return
    end
    page = page + 1
    tutorialImage.image = Pages[page]
end, true, true, true)