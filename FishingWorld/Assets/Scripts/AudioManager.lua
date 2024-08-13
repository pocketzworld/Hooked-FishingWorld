--!Type(Module)

--!SerializeField
local BGMusic : AudioShader = nil
--!SerializeField
local paperSoundEffect1 : AudioShader = nil
--!SerializeField
local rewardSoundEffect1 : AudioShader = nil
--!SerializeField
local splashSoundEffect1 : AudioShader = nil
--!SerializeField
local coinsSoundEffect1 : AudioShader = nil
--!SerializeField
local coinsSoundEffect2 : AudioShader = nil
--!SerializeField
local equipSoundEffect : AudioShader = nil
--!SerializeField
local baitSoundEffect : AudioShader = nil
--!SerializeField
local errorSoundEffect : AudioShader = nil

audioMap = {
    paperSound1 = paperSoundEffect1,
    rewardSound1 = rewardSoundEffect1,
    splashSound1 = splashSoundEffect1,
    coinsSound1 = coinsSoundEffect1,
    coinsSound2 = coinsSoundEffect2,
    equipSound = equipSoundEffect,
    baitSound = baitSoundEffect,
    errorSound = errorSoundEffect
}

function PlaySound(sound, pitch)
    Audio:PlaySound((audioMap[sound]), self.gameObject, 1, pitch, false, false)
end

function self:ClientAwake()
    Audio:PlayMusic(BGMusic, 1)
end