-- MurderWare FlyScript v0.2 (Fixed with deltaTime)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local Value = player.PlayerGui:WaitForChild("MurderWareGUI"):WaitForChild("Fly")

local flying = false
local flySpeed = 3

local function startFlying()
    -- Disable humanoid states that interfere with flying
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

    -- Disable default animations for flying look
    local animate = character:FindFirstChild("Animate")
    if animate then
        animate.Disabled = true
    end

    flying = true

    -- Start flying loop with deltaTime to control speed properly
    task.spawn(function()
        local lastTime = tick()
        while flying do
            local now = tick()
            local deltaTime = now - lastTime
            lastTime = now

            RunService.Heartbeat:Wait()

            if humanoid.MoveDirection.Magnitude > 0 then
                local moveVector = humanoid.MoveDirection * flySpeed * deltaTime * 60
                character:TranslateBy(moveVector)
            end
        end
    end)
end

local function stopFlying()
    flying = false

    -- Re-enable humanoid states
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

    -- Restore animations
    local animate = character:FindFirstChild("Animate")
    if animate then
        animate.Disabled = false
    end
end

-- Listen for fly toggle changes
Value:GetPropertyChangedSignal("Value"):Connect(function()
    if Value.Value then
        startFlying()
    else
        stopFlying()
    end
end)

-- Start flying immediately if enabled
if Value.Value then
    startFlying()
end
