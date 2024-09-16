--!Type(Client)

--!SerializeField
local playerCamera : Transform = nil
--!SerializeField
local IslandPoints : {GameObject} = nil
--!SerializeField
local padding : number = 1
local cam : Camera

local levelSelectMode = true

local teleportManager = require("TeleporterController")

function self:Start()
    cam = self.gameObject:GetComponent(Camera)

    for each, gameObj in IslandPoints do
        local tapHandler = gameObj:GetComponent(TapHandler)
        tapHandler.Tapped:Connect(function()
            playerCamera.gameObject:GetComponent(Camera).enabled = true
            teleportManager.Teleport(gameObj.transform.position)
            print("Teleporting to " .. gameObj.name)

            playerCamera.gameObject:SetActive(true)
            Timer.After(0.2, function()
                playerCamera.gameObject:GetComponent(RTSCamera).CenterOn(gameObj.transform.position)
                SwitchToPlayer()
            end)
        end)
    end
end

function self:Update()
    if levelSelectMode then
        if IslandPoints ~= nil and #IslandPoints > 0 then
            ZoomToFit()
        end
    else
        directionToTarget = client.localPlayer.character.transform.position - self.transform.position;
        targetRotation = Quaternion.LookRotation(directionToTarget);
        self.transform.rotation = Quaternion.Lerp(self.transform.rotation, targetRotation, 100 * Time.deltaTime);

        cam.fieldOfView = Mathf.Lerp(cam.fieldOfView, 30, 100 * Time.deltaTime);

    end
end

function SwitchToPlayer()
    levelSelectMode = false
    cam.orthographic = false
    Timer.After(.2, function()
        -- Tween Position
        local fromP = self.transform.position
        local toP = playerCamera.position
        self.transform:TweenPosition(fromP, toP)
            :Duration(1.5)
            :EaseInOutCubic()
            :Play();
        Timer.After(1.5, function() self.gameObject:SetActive(false) end)
    end)
    
    for each, gameObj in IslandPoints do gameObj.gameObject:SetActive(false) end
end

function ZoomToFit()
    -- Initialize bounds at the first point
    local bounds : Bounds = Bounds.new(IslandPoints[1].transform.position, Vector3.new(0, 0, 0))

    -- Encapsulate all island points
    for gameObj, point in IslandPoints do
        bounds:Encapsulate(point.transform.position)
    end

    -- Calculate the size needed to fit the bounding box within the camera view
    local greatestSize : number = math.max(bounds.size.x, bounds.size.z)
    local newSize : number = greatestSize * (1+padding)
    cam.orthographicSize = newSize
end