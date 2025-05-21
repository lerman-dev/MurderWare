-- MurderWare FlyScript v0.3 (BodyVelocity + Boost Edition)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local Value = player.PlayerGui:WaitForChild("MurderWareGUI"):WaitForChild("Fly")

local flying = false
local bodyVelocity
local bodyGyro

local flySpeed = 70 -- скорость полёта

local function startFlying()
	if bodyVelocity then bodyVelocity:Destroy() end
	if bodyGyro then bodyGyro:Destroy() end

	-- Выключаем все физические состояния
	for _, state in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
		humanoid:SetStateEnabled(state, false)
	end

	local animate = character:FindFirstChild("Animate")
	if animate then animate.Disabled = true end

	-- Подлёт вверх!
	rootPart.Velocity = Vector3.new(0, 100, 0)

	-- Небольшая задержка перед началом полёта (подлёт)
	task.delay(0.3, function()
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bodyVelocity.Velocity = Vector3.zero
		bodyVelocity.P = 10_000
		bodyVelocity.Parent = rootPart

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		bodyGyro.P = 10_000
		bodyGyro.CFrame = rootPart.CFrame
		bodyGyro.Parent = rootPart

		flying = true

		RunService.RenderStepped:Connect(function()
			if flying and bodyVelocity then
				local moveDirection = humanoid.MoveDirection
				bodyVelocity.Velocity = moveDirection * flySpeed
				bodyGyro.CFrame = CFrame.new(Vector3.zero, moveDirection + Vector3.new(0, 0.01, 0)) -- Плавный поворот
			end
		end)
	end)
end

local function stopFlying()
	flying = false

	if bodyVelocity then bodyVelocity:Destroy() end
	if bodyGyro then bodyGyro:Destroy() end

	for _, state in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
		humanoid:SetStateEnabled(state, true)
	end

	local animate = character:FindFirstChild("Animate")
	if animate then animate.Disabled = false end
end

-- Обработка Value
Value:GetPropertyChangedSignal("Value"):Connect(function()
	if Value.Value then
		startFlying()
	else
		stopFlying()
	end
end)

-- Автостарт
if Value.Value then
	startFlying()
end
