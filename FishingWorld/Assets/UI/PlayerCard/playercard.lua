--!Type(UI)

--!Bind
local _HeaderTitle : Label = nil

--!Bind
local _CloseButton : VisualElement = nil
--!Bind
local _ProgressButton : VisualElement = nil
--!Bind
local _StatsButton : VisualElement = nil
--!Bind
local _QuestsButton : VisualElement = nil

--!Bind
local _ContentHeaderTitle : UILabel = nil

local UIManager = require("UIManager")

_CloseButton:RegisterPressCallback(function()
  UIManager.ButtonPressed("Close")
end, true, true, true)

local ToolTips = {
  ["Progress"] = "View your level and rod progress",
  ["Stats"] = "Display your player stats including level, strength, hook speed, and reel speed",
  ["Quests"] = "View your current quests and rewards"
}

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
  _HeaderTitle.text = "Player Profile"
  _ContentHeaderTitle:SetPrelocalizedText(ToolTips["Progress"])
end

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