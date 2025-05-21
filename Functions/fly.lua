-- MurderWare FlyScript v0.1
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Value = game.ReplicatedStorage:WaitForChild("MWFly")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local flying = false

local function startFlying()
    -- Disable all pesky humanoid states that ruin our flight vibes
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

    -- Kill default animations so we look slick in the air
    local animate = character:FindFirstChild("Animate")
    if animate then
        animate.Disabled = true
    end

    local flySpeed = 3
    flying = true

    task.spawn(function()
        while flying do
            RunService.Heartbeat:Wait()
            if humanoid.MoveDirection.Magnitude > 0 then
                character:TranslateBy(humanoid.MoveDirection * flySpeed)
            end
        end
    end)
end

local function stopFlying()
    flying = false

    -- Bring back all humanoid states like nothing happened
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)

    -- Restore animations for normal swag
    local animate = character:FindFirstChild("Animate")
    if animate then
        animate.Disabled = false
    end
end

-- Listen for the fly toggle and handle accordingly
Value:GetPropertyChangedSignal("Value"):Connect(function()
    if Value.Value then
        startFlying()
    else
        stopFlying()
    end
end)

-- If fly is already on when script loads, start flying right away
if Value.Value then
    startFlying()
end
