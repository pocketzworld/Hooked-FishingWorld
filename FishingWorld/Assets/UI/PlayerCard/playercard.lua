--!Type(UI)


--!Bind
local _closeButton : VisualElement = nil

local UIManager = require("UIManager")

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

--[[
function Initialize()
  _PlayerLevel.text = HardCodedPlayer.level
  _PlayerStrength.text = HardCodedPlayer.strength
  _PlayerHookSpeed.text = HardCodedPlayer.hookSpeed
  _PlayerReelSpeed.text = HardCodedPlayer.reelSpeed

  _PlayerLevelBar.style.width = StyleLength.new(Length.Percent(HardCodedPlayer.currentLevelProgress / HardCodedPlayer.totalLevelProgress * 100))
  _RodLevelBar.style.width = StyleLength.new(Length.Percent(HardCodedPlayer.currentRodProgress / HardCodedPlayer.totalRodProgress * 100))

  _LevelProgress.text = HardCodedPlayer.currentLevelProgress .. "/" .. HardCodedPlayer.totalLevelProgress
  _RodProgress.text = HardCodedPlayer.currentRodProgress .. "/" .. HardCodedPlayer.totalRodProgress
end
]]--