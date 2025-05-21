local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Disable physics states that may interfere with flying
humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)

-- Disable default animations
local animate = character:FindFirstChild("Animate")
if animate then
	animate.Disabled = true
end

local flySpeed = 3
local flying = true

-- Start flying by translating the character every frame
task.spawn(function()
	while flying and RunService.Heartbeat:Wait() do
		if humanoid.MoveDirection.Magnitude > 0 then
			character:TranslateBy(humanoid.MoveDirection * flySpeed)
		end
	end
end)
