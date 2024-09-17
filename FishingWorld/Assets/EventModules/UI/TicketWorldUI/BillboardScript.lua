--!Type(Client)

--!SerializeField
local locUp : boolean = false
--!SerializeField
local mainCam : GameObject = nil

function self:Update()
    if mainCam then 
        local targetPos
        if locUp then
            targetPos = Vector3.new(mainCam.transform.position.x, self.transform.position.y, mainCam.transform.position.z)
        else
            targetPos = mainCam.transform.position
        end

        local direction = (targetPos - self.transform.position).normalized
        self.transform.forward = -direction
    end
end