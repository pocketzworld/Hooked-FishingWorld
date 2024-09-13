--!Type(Client)

--!SerializeField
local waterRarity : string = "Mythical"
--!SerializeField
local waterBiome : string = "any"
--!SerializeField
local lockedAlert : string = "any"

function GetRarity()
    return waterRarity
end

function GetBiome()
    return waterBiome
end

function GetLockedAlert()
    return lockedAlert
end