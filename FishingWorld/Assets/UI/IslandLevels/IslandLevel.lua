--!Type(UI)

--!Bind
local level_label : Label = nil

-- Tween Position
local fromP = self.transform.position
local toP = fromP + Vector3.new(0, 10, 0)
self.transform:TweenPosition(fromP, toP)
    :Duration(1.5)
    :PingPong()
    :Loop()
    :Play();

function SetText(value)
    local text = tostring(value)
    level_label.text = text
end
