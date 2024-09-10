--!Type(UI)

--!Bind
local _PlayerIcon : UIUserThumbnail = nil
--!Bind
local _PlayerName : UILabel = nil
--!Bind
local _closeButton : VisualElement = nil


local UIManager = require("UIManager")

_PlayerName.text = client.localPlayer.name
_PlayerIcon:Load(client.localPlayer)


_closeButton:RegisterPressCallback(function()
  UIManager.ButtonPressed("Close")
end, true, true, true)
