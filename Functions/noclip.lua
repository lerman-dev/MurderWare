-- MurderWare NoClipScript v1.0 (with value tracking and death detection)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local Value = player:WaitForChild("PlayerGui"):WaitForChild("MurderWareGUI"):WaitForChild("Noclip")

local noclip = false
local connection

-- Enables NoClip by setting CanCollide to false for all character parts
local function enableNoClip()
	if connection then connection:Disconnect() end

	connection = RunService.Stepped:Connect(function()
		if not noclip or not character then return end

		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide == true then
				part.CanCollide = false
			end
		end
	end)
end

-- Disables NoClip and disconnects the loop
local function disableNoClip()
	noclip = false
	if connection then
		connection:Disconnect()
		connection = nil
	end
end

-- Tracks changes to the Value and toggles NoClip accordingly
Value:GetPropertyChangedSignal("Value"):Connect(function()
	noclip = Value.Value
	if noclip then
		enableNoClip()
	else
		disableNoClip()
	end
end)

-- Called when the player dies, disables NoClip
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

-- Listen for character spawns
player.CharacterAdded:Connect(onCharacterAdded)

-- Initialize if value is already true
if Value.Value then
	noclip = true
	enableNoClip()
end

-- Hook into death if humanoid already exists
local existingHumanoid = character:FindFirstChild("Humanoid")
if existingHumanoid then
	existingHumanoid.Died:Connect(onDeath)
end
