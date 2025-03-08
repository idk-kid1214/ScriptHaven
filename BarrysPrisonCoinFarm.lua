local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoinCollectorGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create the toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "CoinCollectorToggle"
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0.5, -100, 0.1, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.Text = "Coin Teleporter: OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.Parent = screenGui

-- Variables
local isRunning = false
local teleportLoop = nil

-- Function to randomly teleport to coins
local function teleportToRandomCoin()
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Get all coins in the CollectCoinLocal folder
    local coinFolder = workspace:FindFirstChild("CollectCoinLocal")
    if coinFolder and #coinFolder:GetChildren() > 0 then
        -- Get all coin models from the folder
        local coins = coinFolder:GetChildren()
        
        -- Select a random coin from the available ones
        local randomCoin = coins[math.random(1, #coins)]
        
        -- Calculate the position to teleport to
        -- For models, we need to find a good position - using the PrimaryPart or first part found
        local targetPosition
        if randomCoin:IsA("Model") and randomCoin.PrimaryPart then
            targetPosition = randomCoin.PrimaryPart.Position
        else
            -- If it's a model without PrimaryPart, try to find any part
            for _, part in pairs(randomCoin:GetDescendants()) do
                if part:IsA("BasePart") then
                    targetPosition = part.Position
                    break
                end
            end
        end
        
        -- If we found a valid position, teleport to it
        if targetPosition then
            -- Adding a small Y offset to avoid being stuck in the ground
            humanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 0))
        end
    else
        -- Notify if the CollectCoinLocal folder doesn't exist or is empty
        StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "No coins found to teleport to",
            Duration = 3
        })
    end
end

-- Toggle button functionality
toggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    
    if isRunning then
        -- Change button appearance
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        toggleButton.Text = "Coin Teleporter: ON"
        
        -- Start the teleport loop
        teleportLoop = game:GetService("RunService").Heartbeat:Connect(function()
            teleportToRandomCoin()
            -- Add a short wait to prevent too rapid teleporting
            wait(0.5)
        end)
    else
        -- Change button appearance
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        toggleButton.Text = "Coin Teleporter: OFF"
        
        -- Stop the teleport loop
        if teleportLoop then
            teleportLoop:Disconnect()
            teleportLoop = nil
        end
    end
end)

-- Cleanup on script destruction
screenGui.AncestryChanged:Connect(function(_, parent)
    if parent == nil and teleportLoop then
        teleportLoop:Disconnect()
    end
end)
