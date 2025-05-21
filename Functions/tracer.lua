-- MurderWare TraceScript v0.3 (Value Enabled)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local traces = {}
local gunTrace = nil

-- UI toggle reference
local Value = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MurderWareGUI"):WaitForChild("Tracer")

-- Returns color based on player role
local function getRoleColor(player)
	local backpack = player:FindFirstChild("Backpack")
	local character = player.Character
	if not character then return Color3.new(0,1,0) end -- default green (innocent)

	local function hasWeapon(name)
		if character:FindFirstChild(name) then return true end
		if backpack and backpack:FindFirstChild(name) then return true end
		return false
	end

	if hasWeapon("Knife") then
		return Color3.fromRGB(255, 0, 0) -- Red for murderer
	elseif hasWeapon("Gun") then
		return Color3.fromRGB(0, 0, 255) -- Blue for sheriff
	else
		return Color3.fromRGB(0, 255, 0) -- Green for innocent
	end
end

local function createLine()
	local line = Drawing.new("Line")
	line.Visible = false
	line.Color = Color3.new(1, 1, 1)
	line.Thickness = 2
	line.Transparency = 1
	return line
end

local function getStartPos()
	local cam = Workspace.CurrentCamera
	local char = LocalPlayer.Character
	if not char then return nil end

	local head = char:FindFirstChild("Head")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not head or not hrp then return nil end

	local distToHead = (cam.CFrame.Position - head.Position).Magnitude
	if distToHead < 1 then
		return head.Position
	else
		return hrp.Position
	end
end

local function updateTrace(player, line)
	if player == LocalPlayer then
		line.Visible = false
		return
	end

	local character = player.Character
	if not character then
		line.Visible = false
		return
	end

	local head = character:FindFirstChild("Head")
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not head or not hrp then
		line.Visible = false
		return
	end

	local cam = Workspace.CurrentCamera
	local startPos = getStartPos()
	if not startPos then
		line.Visible = false
		return
	end

	local distToHead = (cam.CFrame.Position - head.Position).Magnitude
	local targetPart = distToHead < 1 and head or hrp

	local screenStart, onScreenStart = cam:WorldToViewportPoint(startPos)
	local screenTarget, onScreenTarget = cam:WorldToViewportPoint(targetPart.Position)

	if not onScreenStart or not onScreenTarget then
		line.Visible = false
		return
	end

	line.From = Vector2.new(screenStart.X, screenStart.Y)
	line.To = Vector2.new(screenTarget.X, screenTarget.Y)
	line.Color = getRoleColor(player)
	line.Thickness = 2
	line.Visible = true
end

local function updateGunDrop()
	local cam = Workspace.CurrentCamera
	local startPos = getStartPos()
	if not startPos then
		if gunTrace then
			gunTrace.Visible = false
		end
		return
	end

	for _, model in ipairs(Workspace:GetChildren()) do
		if model:IsA("Model") then
			local gunDrop = model:FindFirstChild("GunDrop")
			if gunDrop and gunDrop:IsA("BasePart") then
				if not gunTrace then
					gunTrace = createLine()
					gunTrace.Color = Color3.fromRGB(255, 255, 0)
					gunTrace.Thickness = 3
				end

				local screenStart, onScreenStart = cam:WorldToViewportPoint(startPos)
				local screenTarget, onScreenTarget = cam:WorldToViewportPoint(gunDrop.Position)

				if onScreenStart and onScreenTarget then
					gunTrace.From = Vector2.new(screenStart.X, screenStart.Y)
					gunTrace.To = Vector2.new(screenTarget.X, screenTarget.Y)
					gunTrace.Visible = true
				else
					gunTrace.Visible = false
				end

				return
			end
		end
	end

	if gunTrace then
		gunTrace.Visible = false
	end
end

-- Current connection holder
local connection

local function startTracing()
	if connection then return end
	connection = RunService.RenderStepped:Connect(function()
		for _, player in ipairs(Players:GetPlayers()) do
			if not traces[player] then
				traces[player] = createLine()
			end
			updateTrace(player, traces[player])
		end
		updateGunDrop()
	end)
end

local function stopTracing()
	if connection then
		connection:Disconnect()
		connection = nil
	end
	for _, line in pairs(traces) do
		line.Visible = false
	end
	if gunTrace then
		gunTrace.Visible = false
	end
end

-- Toggle listener
Value:GetPropertyChangedSignal("Value"):Connect(function()
	if Value.Value then
		startTracing()
	else
		stopTracing()
	end
end)

-- Auto-start if enabled
if Value.Value then
	startTracing()
end

local function onDeath()
	script:Destroy()
end

-- Called when a new character is spawned
local function onCharacterAdded(char)
	character = char
	local humanoid = char:WaitForChild("Humanoid", 5)
	if humanoid then
		humanoid.Died:Connect(onDeath)
	end
end