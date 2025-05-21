-- MurderWare FlyScript v1.2 (Jetpack Fly + Smooth Takeoff)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local Value = player:WaitForChild("PlayerGui"):WaitForChild("MurderWareGUI"):WaitForChild("Fly")

local flySpeed = 35 -- flying speed
local flying = false
local keys = {}

local bodyGyro
local bodyVelocity

-- Track user input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed then
		keys[input.KeyCode] = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	keys[input.KeyCode] = false
end)

local function startFlying()
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end

	humanoid.PlatformStand = true

	-- Initial upward impulse for smooth takeoff
	rootPart.Velocity = Vector3.new(0, 30, 0)

	-- Delay before enabling controlled flight
	task.delay(0.25, function()
		if not Value.Value then return end -- check if still flying

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.P = 5000
		bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		bodyGyro.CFrame = rootPart.CFrame
		bodyGyro.Parent = rootPart

		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bodyVelocity.Velocity = Vector3.zero
		bodyVelocity.P = 4000
		bodyVelocity.Parent = rootPart

		flying = true

		RunService.RenderStepped:Connect(function()
			if not flying then return end

			local cam = workspace.CurrentCamera
			bodyGyro.CFrame = cam.CFrame

			local moveDir = Vector3.zero
			if keys[Enum.KeyCode.W] then moveDir += cam.CFrame.LookVector end
			if keys[Enum.KeyCode.S] then moveDir -= cam.CFrame.LookVector end
			if keys[Enum.KeyCode.A] then moveDir -= cam.CFrame.RightVector end
			if keys[Enum.KeyCode.D] then moveDir += cam.CFrame.RightVector end
			if keys[Enum.KeyCode.Space] then moveDir += Vector3.new(0, 1, 0) end
			if keys[Enum.KeyCode.LeftControl] then moveDir -= Vector3.new(0, 1, 0) end

			if moveDir.Magnitude > 0 then
				bodyVelocity.Velocity = moveDir.Unit * flySpeed
			else
				bodyVelocity.Velocity = Vector3.zero
			end
		end)
	end)
end

local function stopFlying()
	flying = false
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
	humanoid.PlatformStand = false
end

-- Listen for toggle changes
Value:GetPropertyChangedSignal("Value"):Connect(function()
	if Value.Value then
		startFlying()
	else
		stopFlying()
	end
end)

-- Auto start if enabled
if Value.Value then
	startFlying()
end
