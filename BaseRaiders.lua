local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(1, -210, 0, 10)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui

local runButton = Instance.new("TextButton")
runButton.Size = UDim2.new(1, 0, 0, 30)
runButton.Text = "Run Script"
runButton.Parent = frame

local cancelButton = Instance.new("TextButton")
cancelButton.Size = UDim2.new(1, 0, 0, 30)
cancelButton.Position = UDim2.new(0, 0, 0, 35)
cancelButton.Text = "Cancel"
cancelButton.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 0, 30)
toggleButton.Position = UDim2.new(0, 0, 0, 70)
toggleButton.Text = "Added Collision: OFF"
toggleButton.Visible = false
toggleButton.Parent = frame

local truss, transparentPart
local collisionEnabled = false

local function createParts()
    truss = Instance.new("TrussPart")
    truss.Size = Vector3.new(1, 200, 1)
    truss.Position = Vector3.new(rootPart.Position.X, 87.4, rootPart.Position.Z)
    truss.Anchored = true
    truss.Parent = workspace
    
    transparentPart = Instance.new("Part")
    transparentPart.Size = Vector3.new(2048, 1.2, 2048)
    transparentPart.CFrame = CFrame.new(0, 181.6, 0)
    transparentPart.Transparency = 0.9
    transparentPart.CanCollide = false
    transparentPart.Anchored = true
    transparentPart.Parent = workspace
    
    runButton:Destroy()
    cancelButton:Destroy()
    frame:Destroy()
    toggleButton.Visible = true
end

local function toggleCollision()
    if transparentPart then
        collisionEnabled = not collisionEnabled
        transparentPart.CanCollide = collisionEnabled
        toggleButton.Text = "Added Collision: " .. (collisionEnabled and "ON" or "OFF")
    end
end

local function cancel()
    if truss then truss:Destroy() end
    if transparentPart then transparentPart:Destroy() end
    screenGui:Destroy()
end

runButton.MouseButton1Click:Connect(createParts)
toggleButton.MouseButton1Click:Connect(toggleCollision)
cancelButton.MouseButton1Click:Connect(cancel)
