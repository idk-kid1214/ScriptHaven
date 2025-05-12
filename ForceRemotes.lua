local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "RemoteGui"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Parent = frame

local remoteBox = Instance.new("TextBox")
remoteBox.Size = UDim2.new(1, -20, 0, 40)
remoteBox.Position = UDim2.new(0, 10, 0, 35)
remoteBox.PlaceholderText = "Remote paths (comma separated)"
remoteBox.Text = ""
remoteBox.TextWrapped = true
remoteBox.TextColor3 = Color3.new(1,1,1)
remoteBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
remoteBox.ClearTextOnFocus = false
remoteBox.Parent = frame

local fireButton = Instance.new("TextButton")
fireButton.Size = UDim2.new(0, 120, 0, 30)
fireButton.Position = UDim2.new(0, 10, 0, 90)
fireButton.Text = "Run Remotes"
fireButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
fireButton.TextColor3 = Color3.new(1,1,1)
fireButton.Parent = frame

local bypassButton = Instance.new("TextButton")
bypassButton.Size = UDim2.new(0, 140, 0, 30)
bypassButton.Position = UDim2.new(0, 150, 0, 90)
bypassButton.Text = "Try Bypass"
bypassButton.BackgroundColor3 = Color3.fromRGB(80, 70, 90)
bypassButton.TextColor3 = Color3.new(1,1,1)
bypassButton.Parent = frame

local autoFireCheckbox = Instance.new("TextButton")
autoFireCheckbox.Size = UDim2.new(0, 20, 0, 20)
autoFireCheckbox.Position = UDim2.new(0, 5, 0, 5)
autoFireCheckbox.Text = ""
autoFireCheckbox.BackgroundColor3 = Color3.fromRGB(100,100,100)
autoFireCheckbox.Parent = frame

local autoFireLabel = Instance.new("TextLabel")
autoFireLabel.Size = UDim2.new(0, 120, 0, 20)
autoFireLabel.Position = UDim2.new(0, 30, 0, 5)
autoFireLabel.Text = "Auto Fire"
autoFireLabel.TextColor3 = Color3.new(1,1,1)
autoFireLabel.BackgroundTransparency = 1
autoFireLabel.TextXAlignment = Enum.TextXAlignment.Left
autoFireLabel.Parent = frame

local autoBypassCheckbox = autoFireCheckbox:Clone()
autoBypassCheckbox.Position = UDim2.new(0, 150, 0, 5)
autoBypassCheckbox.Parent = frame

local autoBypassLabel = autoFireLabel:Clone()
autoBypassLabel.Position = UDim2.new(0, 175, 0, 5)
autoBypassLabel.Text = "Auto Bypass"
autoBypassLabel.Parent = frame

local delayInput = Instance.new("TextBox")
delayInput.Size = UDim2.new(0, 60, 0, 25)
delayInput.Position = UDim2.new(0, 10, 0, 130)
delayInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
delayInput.TextColor3 = Color3.new(1,1,1)
delayInput.PlaceholderText = "Delay"
delayInput.Text = "1"
delayInput.ClearTextOnFocus = false
delayInput.Parent = frame

local logFrame = Instance.new("ScrollingFrame")
logFrame.Size = UDim2.new(1, -20, 0, 220)
logFrame.Position = UDim2.new(0, 10, 0, 170)
logFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
logFrame.BorderSizePixel = 0
logFrame.CanvasSize = UDim2.new(0,0,0,0)
logFrame.ScrollBarThickness = 6
logFrame.Parent = frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = logFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Logging function
local function log(msg)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Text = msg
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.Parent = logFrame
	logFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 5)
end

-- Functions

local function tryBypass(remoteEvent)
    local success, errorMessage = pcall(function()
        if remoteEvent and remoteEvent.Parent == ReplicatedStorage then
            remoteEvent:FireServer()
        else
            error("Remote event not found or is not in ReplicatedStorage")
        end
    end)

    if not success then
        impersonateOwner(remoteEvent)
    else
        print("Bypass Successful")
    end
end

local function impersonateOwner(remoteEvent)
    local success, errorMessage = pcall(function()
        -- Attempt to bypass security checks, impersonate the owner
        local owner = game.CreatorId == localPlayer.UserId
        if owner then
            remoteEvent:FireServer()
        else
            tryBypassWithOwnerImpersonation(remoteEvent)
        end
    end)

    if not success then
        print("Impersonation Failed: " .. errorMessage)
    else
        print("Impersonation Successful")
    end
end

local function tryBypassWithOwnerImpersonation(remoteEvent)
    local success, errorMessage = pcall(function()
        -- Attempt to bypass and impersonate the owner simultaneously
        local owner = game.CreatorId == localPlayer.UserId
        if remoteEvent and remoteEvent.Parent == ReplicatedStorage then
            if owner then
                remoteEvent:FireServer()
            else
                error("Player is not the owner")
            end
        else
            error("Remote event not found")
        end
    end)

    if not success then
        print("Bypass with Impersonation Failed: " .. errorMessage)
    else
        print("Bypass with Impersonation Successful")
    end
end

local function getRemoteList()
	local list = {}
	for _, path in ipairs(string.split(remoteBox.Text, ",")) do
		local success, remote = pcall(function() return game:FindFirstChild(path:match("^%s*(.-)%s*$"), true) end)
		if success and remote and remote:IsA("RemoteEvent") then
			table.insert(list, remote)
		else
			log("Invalid or missing remote: " .. path)
		end
	end
	return list
end

local function tryFireRemotes()
	for _, remote in ipairs(getRemoteList()) do
		pcall(function()
			remote:FireServer()
			log("Fired: " .. remote:GetFullName())
		end)
	end
end

-- Buttons
fireButton.MouseButton1Click:Connect(tryFireRemotes)
bypassButton.MouseButton1Click:Connect(tryBypass)
closeButton.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Toggle checkboxes
local autoFireOn, autoBypassOn = false, false
autoFireCheckbox.MouseButton1Click:Connect(function()
	autoFireOn = not autoFireOn
	autoFireCheckbox.BackgroundColor3 = autoFireOn and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100,100,100)
end)
autoBypassCheckbox.MouseButton1Click:Connect(function()
	autoBypassOn = not autoBypassOn
	autoBypassCheckbox.BackgroundColor3 = autoBypassOn and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100,100,100)
end)

-- Loop
task.spawn(function()
	while gui and gui.Parent do
		local delayTime = tonumber(delayInput.Text) or 1
		if autoFireOn then tryFireRemotes() end
		if autoBypassOn then tryBypass() end
		task.wait(math.clamp(delayTime, 0.05, 30))
	end
end)
