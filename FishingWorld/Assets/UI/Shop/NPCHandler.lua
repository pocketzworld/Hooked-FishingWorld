--!Type(Client)

local uiManager = require("UIManager")
local audioManager = require("AudioManager")

function self:Awake()
    local taphandler = self.gameObject:GetComponent(TapHandler)
    taphandler.Tapped:Connect(function()
        uiManager.ButtonPressed("Shop")
        audioManager.PlaySound("coinsSound1", 1)
    end)
end