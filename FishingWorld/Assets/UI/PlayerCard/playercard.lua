--!Type(UI)

--!Bind
local _PlayerIcon : UIUserThumbnail = nil
--!Bind
local _PlayerName : UILabel = nil
--!Bind
local _closeButton : VisualElement = nil


--!Bind
local _PlayerLevel : Label = nil
--!Bind
local _PlayerStrength : Label = nil
--!Bind
local _PlayerHookSpeed : Label = nil
--!Bind
local _PlayerReelSpeed : Label = nil

--!Bind
local _PlayerLevelBar : VisualElement = nil -- Modify the width of this element to change the progress
--!Bind
local _RodLevelBar : VisualElement = nil

--!Bind
local _LevelProgress : Label = nil -- Should be in this format (current/total)
--!Bind
local _RodProgress : Label = nil -- Should be in this format (current/total)

local UIManager = require("UIManager")

_PlayerName.text = client.localPlayer.name
_PlayerIcon:Load(client.localPlayer)

_closeButton:RegisterPressCallback(function()
  UIManager.ButtonPressed("Close")
end, true, true, true)

local HardCodedPlayer = {
  level = 2,
  strength = 5,
  hookSpeed = 2,
  reelSpeed = 1,
  currentLevelProgress = 1050,
  totalLevelProgress = 10250,
  currentRodProgress = 500,
  totalRodProgress = 1000,
}

function Initialize()
  _PlayerLevel.text = HardCodedPlayer.level
  _PlayerStrength.text = HardCodedPlayer.strength
  _PlayerHookSpeed.text = HardCodedPlayer.hookSpeed
  _PlayerReelSpeed.text = HardCodedPlayer.reelSpeed

  _PlayerLevelBar.style.width = StyleLength.new(HardCodedPlayer.currentLevelProgress / HardCodedPlayer.totalLevelProgress * 100)
  _RodLevelBar.style.width = StyleLength.new(HardCodedPlayer.currentRodProgress / HardCodedPlayer.totalRodProgress * 100)

  _LevelProgress.text = HardCodedPlayer.currentLevelProgress .. "/" .. HardCodedPlayer.totalLevelProgress
  _RodProgress.text = HardCodedPlayer.currentRodProgress .. "/" .. HardCodedPlayer.totalRodProgress
end