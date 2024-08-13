--!Type(Client)

--!SerializeField
local waterBiome : string = "any"
--!SerializeField
local lockedAlert : string = "any"

function GetBiome()
    return waterBiome
end

function GetLockedAlert()
    return lockedAlert
end