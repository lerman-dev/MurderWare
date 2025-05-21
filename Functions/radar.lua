-- MurderWare RadarScript v0.1
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Create radar GUI
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "MurderWareRadar"

local radarFrame = Instance.new("Frame", screenGui)
radarFrame.AnchorPoint = Vector2.new(1, 1)
radarFrame.Position = UDim2.new(1, -20, 1, -20)
radarFrame.Size = UDim2.new(0, 200, 0, 200)
radarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
radarFrame.BackgroundTransparency = 0.2
radarFrame.BorderSizePixel = 0

-- Function to create dots
local function createDot(color)
	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0, 6, 0, 6)
	dot.AnchorPoint = Vector2.new(0.5, 0.5)
	dot.BackgroundColor3 = color
	dot.BorderSizePixel = 0
	dot.BackgroundTransparency = 0
	dot.Parent = radarFrame
	return dot
end

-- Main update
RunService.RenderStepped:Connect(function()
	for _, child in ipairs(radarFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local cam = Workspace.CurrentCamera
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local radarSize = radarFrame.AbsoluteSize.X
	local scale = 0.1

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local char = player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hrp then
				local offset = (hrp.Position - root.Position) * scale
				local x = math.clamp(offset.X, -radarSize/2, radarSize/2)
				local z = math.clamp(offset.Z, -radarSize/2, radarSize/2)

				local roleColor = Color3.fromRGB(0, 255, 0) -- Innocent default
				local tool = player.Character:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
				if tool then
					if tool.Name:lower():find("gun") then
						roleColor = Color3.fromRGB(0, 150, 255)
					elseif tool.Name:lower():find("knife") then
						roleColor = Color3.fromRGB(255, 50, 50)
					end
				end

				local dot = createDot(roleColor)
				dot.Position = UDim2.new(0.5, x, 0.5, z)
			end
		end
	end

	-- GunDrop check
	for _, model in ipairs(Workspace:GetChildren()) do
		if model:IsA("Model") then
			local part = model:FindFirstChild("GunDrop")
			if part and part:IsA("BasePart") then
				local offset = (part.Position - root.Position) * scale
				local x = math.clamp(offset.X, -radarSize/2, radarSize/2)
				local z = math.clamp(offset.Z, -radarSize/2, radarSize/2)

				local dot = createDot(Color3.fromRGB(255, 255, 0)) -- Yellow for gun
				dot.Position = UDim2.new(0.5, x, 0.5, z)
			end
		end
	end
end)
