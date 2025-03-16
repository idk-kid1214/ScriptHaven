local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(1, -210, 0, 10)
frame.BackgroundTransparency = 0.3
frame.Parent = gui

local runButton = Instance.new("TextButton")
runButton.Size = UDim2.new(1, 0, 0, 50)
runButton.Text = "Run Script"
runButton.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(1, 0, 0, 50)
closeButton.Position = UDim2.new(0, 0, 0, 50)
closeButton.Text = "Close"
closeButton.Parent = frame

local collisionButton = Instance.new("TextButton")
collisionButton.Size = UDim2.new(1, 0, 0, 50)
collisionButton.Position = UDim2.new(0, 0, 0, 100)
collisionButton.Text = "Added Collision: OFF"
collisionButton.Parent = frame
collisionButton.Visible = false

local truss, transparentPart

local function createParts()
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    truss = Instance.new("TrussPart")
    truss.Size = Vector3.new(1, 200, 1)
    truss.Position = Vector3.new(root.Position.X, 87.4, root.Position.Z)
    truss.Anchored = true
    truss.Parent = workspace
    
    transparentPart = Instance.new("Part")
    transparentPart.Size = Vector3.new(2048, 1.2, 2048)
    transparentPart.CFrame = CFrame.new(0, 181.6, 0)
    transparentPart.Transparency = 0.9
    transparentPart.Anchored = true
    transparentPart.CanCollide = false
    transparentPart.Parent = workspace
    
    collisionButton.Visible = true
    closeButton.Visible = true
    runButton:Destroy()
end

local function toggleCollision()
    if transparentPart then
        transparentPart.CanCollide = not transparentPart.CanCollide
        collisionButton.Text = "Added Collision: " .. (transparentPart.CanCollide and "ON" or "OFF")
    end
end

local function cleanup()
    if truss then truss:Destroy() end
    if transparentPart then transparentPart:Destroy() end
    gui:Destroy()
end

runButton.MouseButton1Click:Connect(function()
    createParts()
end)

collisionButton.MouseButton1Click:Connect(toggleCollision)
closeButton.MouseButton1Click:Connect(cleanup)
