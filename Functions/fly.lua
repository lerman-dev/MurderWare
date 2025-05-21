-- MurderWare FlyScript v0.2 (BodyVelocity Edition)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local Value = player.PlayerGui:WaitForChild("MurderWareGUI"):WaitForChild("Fly")

local flying = false
local bodyVelocity

local flySpeed = 70 -- настраивай под вкус

local function startFlying()
    if bodyVelocity then bodyVelocity:Destroy() end

    -- Remove unwanted states
    for _, state in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
        humanoid:SetStateEnabled(state, false)
    end

    -- Disable animations
    local animate = character:FindFirstChild("Animate")
    if animate then animate.Disabled = true end

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.P = 10_000
    bodyVelocity.Parent = rootPart

    flying = true

    RunService.RenderStepped:Connect(function()
        if flying and bodyVelocity and humanoid.MoveDirection.Magnitude > 0 then
            bodyVelocity.Velocity = humanoid.MoveDirection * flySpeed
        elseif flying and bodyVelocity then
            bodyVelocity.Velocity = Vector3.zero
        end
    end)
end

local function stopFlying()
    flying = false

    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end

    -- Re-enable all states
    for _, state in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
        humanoid:SetStateEnabled(state, true)
    end

    -- Re-enable animations
    local animate = character:FindFirstChild("Animate")
    if animate then animate.Disabled = false end
end

-- Connect toggle
Value:GetPropertyChangedSignal("Value"):Connect(function()
    if Value.Value then
        startFlying()
    else
        stopFlying()
    end
end)

-- Auto start
if Value.Value then
    startFlying()
end
