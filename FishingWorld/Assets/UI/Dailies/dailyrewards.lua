--!Type(UI)

--!Bind
local _progressBar : UIProgressBar = nil
--!Bind
local _closeButton : VisualElement = nil -- Close button for the daily rewards UI

local UIManager = require("UIManager")

-- Register a callback to close the daily rewards UI
_closeButton:RegisterPressCallback(function()
  UIManager.ButtonPressed("Close")
end, true, true, true)

local dailies = 7
_progressBar.value = 0

-- Fill the progress bar every 5 seconds until it's full
function FillProgressBar()
    local progress = 0
    local interval = Timer.Every(5, function()
        progress = progress + 0.125
        _progressBar.value = progress
        if progress >= 1 then
            interval = nil
        end
    end)
end

FillProgressBar()