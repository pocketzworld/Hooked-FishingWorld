--!Type(Client)

--!SerializeField
local startPoint : Transform = nil
--!SerializeField
local endPoint : Transform = nil
--!SerializeField
local resolution : number = 20
--!SerializeField
local curveHeight : number = 1.0

local lineRenderer = nil

function self:Start()
    lineRenderer = self.gameObject:GetComponent(LineRenderer)
    lineRenderer.positionCount = resolution
end

function self:Update()
    DrawCurvedLine()
end

function DrawCurvedLine()
    for i = 1, resolution do
        local t = (i - 1) / (resolution - 1)
        local point = Vector3.Lerp(startPoint.position, endPoint.position, t)
        point.y = point.y + math.sin(t * math.pi) * curveHeight
        lineRenderer:SetPosition(i-1, point)
    end
end
