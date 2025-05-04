local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local keys = { W = false, A = false, S = false, D = false }
local flying = false
local conn = nil
local speed = 1
local savedPosition = hrp.Position
local originalGravity = workspace.Gravity

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyTeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 90)
frame.Position = UDim2.new(0.5, -110, 0.5, -45)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 180, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Text = "Flight: OFF"
toggleButton.Parent = frame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 60, 0, 25)
speedInput.Position = UDim2.new(0, 10, 0, 50)
speedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.Text = "1"
speedInput.PlaceholderText = "Speed"
speedInput.ClearTextOnFocus = false
speedInput.Parent = frame

local xButton = Instance.new("TextButton")
xButton.Size = UDim2.new(0, 20, 0, 20)
xButton.Position = UDim2.new(1, -25, 0, 5)
xButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
xButton.TextColor3 = Color3.new(1,1,1)
xButton.Text = "X"
xButton.Parent = frame

-- Input tracking
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if keys[input.KeyCode.Name] ~= nil then keys[input.KeyCode.Name] = true end
end)

UserInputService.InputEnded:Connect(function(input, gp)
	if keys[input.KeyCode.Name] ~= nil then keys[input.KeyCode.Name] = false end
end)

speedInput.FocusLost:Connect(function()
	local val = tonumber(speedInput.Text)
	if val and val >= 0 then
		speed = val
	else
		speedInput.Text = tostring(speed)
	end
end)

-- Teleport fly
local function startFlying()
	-- Save the current gravity and set it to 0
	originalGravity = workspace.Gravity
	workspace.Gravity = 0

	humanoid.PlatformStand = true
	savedPosition = hrp.Position  -- Save initial position when flying starts

	conn = RunService.RenderStepped:Connect(function()
		if not flying then return end

		hrp.Velocity = Vector3.zero

		local camCF = workspace.CurrentCamera.CFrame
		local moveDir = Vector3.zero

		if keys.W then moveDir += camCF.LookVector end
		if keys.S then moveDir -= camCF.LookVector end
		if keys.A then moveDir -= camCF.RightVector end
		if keys.D then moveDir += camCF.RightVector end

		if moveDir.Magnitude > 0 then
			-- Change the position based on savedPosition instead of directly modifying hrp.Position
			savedPosition = savedPosition + moveDir.Unit * speed
		end

		local forward = camCF.LookVector
		hrp.CFrame = CFrame.new(savedPosition, savedPosition + Vector3.new(forward.X, 0, forward.Z))
	end)
end

local function stopFlying()
	flying = false
	if conn then conn:Disconnect() conn = nil end
	humanoid.PlatformStand = false
	hrp.Velocity = Vector3.zero
	
	-- Restore the original gravity when flight is turned off
	workspace.Gravity = originalGravity
end

-- Button behavior
toggleButton.MouseButton1Click:Connect(function()
	flying = not flying
	toggleButton.Text = "Flight: " .. (flying and "ON" or "OFF")
	toggleButton.BackgroundColor3 = flying and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
	if flying then
		startFlying()
	else
		stopFlying()
	end
end)

xButton.MouseButton1Click:Connect(function()
	stopFlying()
	screenGui:Destroy()
end)
