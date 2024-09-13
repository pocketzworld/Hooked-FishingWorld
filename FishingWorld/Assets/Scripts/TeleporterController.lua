--!Type(Module)

local teleportRequest = Event.new("TeleportRequest")
local teleportEvent = Event.new("TeleportEvent")

function self:ClientAwake()
    teleportEvent:Connect(function(player, pos)
        if player == client.localPlayer then return end
        player.character:Teleport(pos)
    end)
end

function Teleport(Destination)
    client.localPlayer.character:Teleport(Destination)
    teleportRequest:FireServer(Destination)
end

------------ Server ------------

function self:ServerAwake()
    teleportRequest:Connect(function(player, pos)
        player.character.transform.position = pos
        teleportEvent:FireAllClients(player, pos)
    end)
end