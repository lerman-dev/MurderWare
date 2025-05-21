-- MurderWare FlyScript v1.0 (REAL FLY, not sliding)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local Value = player:WaitForChild("PlayerGui"):WaitForChild("MurderWareGUI"):WaitForChild("Fly")

local flySpeed = 70
local flying = false
local bodyGyro, bodyVelocity
local keys = {}

-- Input
UserInputService.InputBegan:Connect(function(input, processed)
	if not processed then
		keys[input.KeyCode] = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	keys[input.KeyCode] = false
end)

-- Fly Logic
local function startFlying()
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end

	humanoid.PlatformStand = true

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.P = 9e4
	bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bodyGyro.CFrame = rootPart.CFrame
	bodyGyro.Parent = rootPart

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bodyVelocity.P = 9e4
	bodyVelocity.Parent = rootPart

	flying = true

	RunService.RenderStepped:Connect(function()
		if flying then
			local cam = workspace.CurrentCamera
			bodyGyro.CFrame = cam.CFrame

			local moveVec = Vector3.zero
			if keys[Enum.KeyCode.W] then moveVec += cam.CFrame.LookVector end
			if keys[Enum.KeyCode.S] then moveVec -= cam.CFrame.LookVector end
			if keys[Enum.KeyCode.A] then moveVec -= cam.CFrame.RightVector end
			if keys[Enum.KeyCode.D] then moveVec += cam.CFrame.RightVector end
			if keys[Enum.KeyCode.Space] then moveVec += cam.CFrame.UpVector end
			if keys[Enum.KeyCode.LeftControl] then moveVec -= cam.CFrame.UpVector end

			bodyVelocity.Velocity = moveVec.Unit * flySpeed
		end
	end)
end

local function stopFlying()
	flying = false
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
	humanoid.PlatformStand = false
end

Value:GetPropertyChangedSignal("Value"):Connect(function()
	if Value.Value then
		startFlying()
	else
		stopFlying()
	end
end)

if Value.Value then
	startFlying()
end
