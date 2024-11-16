--!Type(Module)

--!SerializeField
local env: string = "dev"

--!SerializeField
local worldId: string = ""

local function ApiEndpoint()
	local cases = {
		["dev"] = "hangout-private-lb-dev-36e08553239a8871.elb.us-east-1.amazonaws.com",
		["dev1"] = "hangout-private-lb-dev1-1bb54090ed7eada7.elb.us-east-1.amazonaws.com",
		["dev2"] = "hangout-private-lb-dev2-4abf9e7323b16256.elb.us-east-1.amazonaws.com",
		["dev3"] = "hangout-private-lb-dev3-f4ea2dbbc802aa31.elb.us-east-1.amazonaws.com",
		["rc"] = "hangout-private-lb-rc-07b69f9a56492336.elb.us-east-1.amazonaws.com",
		["liveops"] = "hangout-private-lb-liveops-614010634fd20aaa.elb.us-east-1.amazonaws.com",
		["production"] = "hangout-private-lb-production-8aa74c0c4ba3cd65.elb.us-east-1.amazonaws.com",
	}
	return cases[env] or cases["dev"]
end

function self:ServerAwake()
	function IncrementMission(missionName: string, userIds: { string }, amount: number)
		local apiEndpoint = ApiEndpoint()

		if worldId == "" then
			print("Unable to increment mission due to invalid world ID")
			return
		end

		local req = HTTPRequest.new("http://" .. apiEndpoint .. "/realm/direct/increment_mission", HTTPMethod.POST)

		req:SetHeader("Content-Type", "application/json")
		local userProgress = {}
		for i = 1, #userIds do
			table.insert(userProgress, {
				_id = userIds[i],
				mission_name = missionName,
				progress = amount,
			})
		end

		req:SetJSONBody({
			world_id = worldId,
			user_progress = userProgress,
		})

		HTTPClient.Request(req, function(res, err)
			-- Add callback handler here

			if err then
				print("Error while incrementing mission: " .. err)
			else
				print("Incremented mission " .. missionName .. " by " .. amount .. " for " .. #userIds .. " users")
			end
		end)
	end
end
