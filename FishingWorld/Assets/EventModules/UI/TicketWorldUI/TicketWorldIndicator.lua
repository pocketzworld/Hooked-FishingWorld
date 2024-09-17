--!Type(UI)

--!Bind
local ticket_container : VisualElement = nil
--!Bind
local ticket_label : Label = nil

function self:Awake()
    scene.PlayerJoined:Connect(function(scene, player)
        player.CharacterChanged:Connect(function(player, character)
            if player ~= client.localPlayer then
                return
            end
            self.transform.parent.parent = character.transform
            self.transform.parent.localPosition = Vector3.new(0, 0, 0)
            self.transform.parent.localRotation = Quaternion.new(0, 0, 0, 0)
            ticket_container:EnableInClassList("fade", true)
        end)
    end)
end

function ShowTickets(tickets : number)
    ticket_label.text = "+" .. tostring(tickets)
    ticket_container:EnableInClassList("fade", false)
    Timer.After(1, function() ticket_container:EnableInClassList("fade", true) end)
end

