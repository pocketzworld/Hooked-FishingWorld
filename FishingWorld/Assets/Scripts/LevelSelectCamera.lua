--!Type(Client)

--!SerializeField
local rewardPopup : GameObject = nil
--!SerializeField
local lockedImage : Texture = nil
--!SerializeField
local playerCamera : Transform = nil
--!SerializeField
local padding : number = 1
local cam : Camera

local levelSelectMode = true

local uiManager = require("UIManager")
local audioManager = require("AudioManager")
local islandManager = require("IslandManager")
local playerTracker = require("PlayerTracker")
local teleportManager = require("TeleporterController")

local IslandPoints = nil
local IslandLevelReqs = nil

function CheckPlayerlevelReqs(req : number)
    local playerLevel = playerTracker.GetPlayerLevel()
    return playerLevel >= req
end

function self:Start()
    cam = self.gameObject:GetComponent(Camera)
    IslandPoints = islandManager.GetIslandPoints()
    IslandLevelReqs = islandManager.GetIslandLevelReqs()

    rewardPopup.transform.parent = self.transform
    rewardPopup.transform.localScale = Vector3.new(600, 600, 1)
    rewardPopup.transform.localPosition = Vector3.new(0, 0, 0)
    rewardPopup.transform.localRotation = Quaternion.Euler(0, 0, 0)

    for i, gameObj in ipairs(IslandPoints) do
        local tapHandler = gameObj:GetComponent(TapHandler)
        tapHandler.Tapped:Connect(function()

            if CheckPlayerlevelReqs(IslandLevelReqs[i]) == false then
                print("Player level is too low to teleport to " .. gameObj.name .. ". Required level: " .. IslandLevelReqs[i])
                -- Display a message to the player that they need a different pole
                uiManager.ShowFishPopup("Level " .. IslandLevelReqs[i], 
                    nil, 
                    nil, 
                    "You need to be a higher level to fish here!", 
                    lockedImage,
                    nil,
                    "Region Locked!")

                audioManager.PlaySound("splashSound1", 1)
                audioManager.PlaySound("errorSound", 1)

                return
            end

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

    rewardPopup.transform.parent = playerCamera
    rewardPopup.transform.localScale = Vector3.new(1, 1, 1)
    rewardPopup.transform.localPosition = Vector3.new(0, 0, 0)
    rewardPopup.transform.localRotation = Quaternion.Euler(0, 0, 0)

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