-- Single-Cycle Teleport Script
-- When activated, completes one full cycle and stops at position 6
-- Place this in StarterPlayerScripts

local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Create our main positions array
local positions = {
    Vector3.new(-248.11647033691406, 11.142134666442871, 312.2153015136719), -- Position 1
    Vector3.new(-447.9196472167969, 11.142129898071289, -35.20195770263672), -- Position 2
    Vector3.new(-247.82156372070312, 11.142139434814453, -382.8570251464844), -- Position 3
    Vector3.new(153.32684326171875, 11.142125129699707, -382.4230651855469), -- Position 4
    Vector3.new(354.2684020996094, 10.517284393310547, -35.67249298095703), -- Position 5
    Vector3.new(-248.11647033691406, 11.142134666442871, 312.2153015136719) -- Position 6 (same as 1)
}

-- Calculate center point - we're using a rough approximation based on the positions
local center = Vector3.new(0, 11, 0)

-- Calculate far positions (20x the distance)
local farPositions = {}
for i, pos in ipairs(positions) do
    local directionVector = (pos - center).Unit
    local distance = (pos - center).Magnitude
    farPositions[i] = center + (directionVector * (distance * 20))
end

-- Create GUI elements
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Create buttons
local normalButton = Instance.new("TextButton")
normalButton.Size = UDim2.new(0, 200, 0, 50)
normalButton.Position = UDim2.new(0.5, -100, 0.1, 0)
normalButton.AnchorPoint = Vector2.new(0, 0)
normalButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
normalButton.Text = "START NORMAL PATH"
normalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
normalButton.Font = Enum.Font.SourceSansBold
normalButton.TextSize = 18
normalButton.Parent = gui

local farButton = Instance.new("TextButton")
farButton.Size = UDim2.new(0, 200, 0, 50)
farButton.Position = UDim2.new(0.5, -100, 0.2, 0)
farButton.AnchorPoint = Vector2.new(0, 0)
farButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
farButton.Text = "START FAR PATH"
farButton.TextColor3 = Color3.fromRGB(255, 255, 255)
farButton.Font = Enum.Font.SourceSansBold
farButton.TextSize = 18
farButton.Parent = gui

-- Add debug text to show current position
local debugLabel = Instance.new("TextLabel")
debugLabel.Size = UDim2.new(0, 400, 0, 30)
debugLabel.Position = UDim2.new(0.5, -200, 0.3, 0)
debugLabel.BackgroundTransparency = 0.5
debugLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
debugLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
debugLabel.Text = "Ready to teleport"
debugLabel.Font = Enum.Font.SourceSans
debugLabel.TextSize = 14
debugLabel.Parent = gui

-- Variables to track cycles
local normalCycleActive = false
local farCycleActive = false

-- Function to teleport the player
local function teleportPlayer(position)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        debugLabel.Text = "Teleporting to position"
        character:SetPrimaryPartCFrame(CFrame.new(position))
        return true
    else
        debugLabel.Text = "Error: Character not found"
        return false
    end
end

-- Function to run a single cycle through all points
local function runNormalCycle()
    if normalCycleActive then return end
    normalCycleActive = true
    
    -- Disable both buttons during cycle
    normalButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    normalButton.Text = "CYCLE IN PROGRESS..."
    farButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    farButton.Text = "CYCLE IN PROGRESS..."
    
    -- Run through positions one by one
    task.spawn(function()
        for i = 1, #positions do
            if player.Character then
                teleportPlayer(positions[i])
                debugLabel.Text = "Position " .. i .. " of " .. #positions
            end
            
            -- Wait between teleports
            if i < #positions then
                task.wait(0.5)
            end
        end
        
        -- Reset buttons when cycle completes
        normalCycleActive = false
        normalButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        normalButton.Text = "START NORMAL PATH"
        farButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        farButton.Text = "START FAR PATH"
        debugLabel.Text = "Cycle complete - Stopped at position 6"
    end)
end

-- Function to run a single cycle through all far points
local function runFarCycle()
    if farCycleActive then return end
    farCycleActive = true
    
    -- Disable both buttons during cycle
    normalButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    normalButton.Text = "CYCLE IN PROGRESS..."
    farButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    farButton.Text = "CYCLE IN PROGRESS..."
    
    -- Run through positions one by one
    task.spawn(function()
        for i = 1, #farPositions do
            if player.Character then
                teleportPlayer(farPositions[i])
                debugLabel.Text = "Far Position " .. i .. " of " .. #farPositions
            end
            
            -- Wait between teleports
            if i < #farPositions then
                task.wait(0.5)
            end
        end
        
        -- Reset buttons when cycle completes
        farCycleActive = false
        normalButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        normalButton.Text = "START NORMAL PATH"
        farButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        farButton.Text = "START FAR PATH"
        debugLabel.Text = "Far cycle complete - Stopped at position 6"
    end)
end

-- Connect button click events
normalButton.MouseButton1Click:Connect(function()
    if not normalCycleActive and not farCycleActive then
        runNormalCycle()
    end
end)

farButton.MouseButton1Click:Connect(function()
    if not normalCycleActive and not farCycleActive then
        runFarCycle()
    end
end)

-- Notify that script loaded successfully
print("Teleport script loaded successfully!")
debugLabel.Text = "Teleport system ready - click a button to start"
