local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoinUtilityGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create the teleport button
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "CoinTeleporterToggle"
teleportButton.Size = UDim2.new(0, 200, 0, 50)
teleportButton.Position = UDim2.new(0.5, -100, 0.1, 0)
teleportButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
teleportButton.Text = "Coin Teleporter: OFF"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextSize = 20
teleportButton.Parent = screenGui

-- Create the duplicate/spawn button
local spawnButton = Instance.new("TextButton")
spawnButton.Name = "CoinSpawnerToggle"
spawnButton.Size = UDim2.new(0, 200, 0, 50)
spawnButton.Position = UDim2.new(0.5, -100, 0.2, 0)
spawnButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
spawnButton.Text = "Coin Spawner: OFF"
spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnButton.Font = Enum.Font.SourceSansBold
spawnButton.TextSize = 20
spawnButton.Parent = screenGui

-- Variables
local isTeleporting = false
local teleportLoop = nil
local isSpawning = false
local spawnLoop = nil

-- Cooldown variables
local teleportCooldown = 0.4
local spawnCooldown = 0.01
local lastTeleportTime = 0
local lastSpawnTime = 0

-- Function to randomly teleport to coins
local function teleportToRandomCoin()
    -- Check cooldown
    local currentTime = tick()
    if currentTime - lastTeleportTime < teleportCooldown then
        return
    end
    lastTeleportTime = currentTime
    
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

-- Function to spawn/duplicate random coins with increased radius
local function spawnRandomCoin()
    -- Check cooldown
    local currentTime = tick()
    if currentTime - lastSpawnTime < spawnCooldown then
        return
    end
    lastSpawnTime = currentTime
    
    -- Get all coins in the CollectCoinLocal folder
    local coinFolder = workspace:FindFirstChild("CollectCoinLocal")
    if coinFolder and #coinFolder:GetChildren() > 0 then
        -- Get all coin models from the folder
        local coins = coinFolder:GetChildren()
        
        -- Select a random coin from the available ones
        local randomCoin = coins[math.random(1, #coins)]
        
        -- Duplicate the coin
        local newCoin = randomCoin:Clone()
        
        -- Get player position to spawn nearby
        local player = Players.LocalPlayer
        local character = player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                -- Position the new coin randomly around the player within a 35 stud radius
                local radius = 35
                local angle = math.random() * math.pi * 2
                local distance = math.random() * radius
                
                -- Calculate random position using polar coordinates for better distribution
                local randomOffset = Vector3.new(
                    math.cos(angle) * distance,
                    3, -- Slightly above the ground
                    math.sin(angle) * distance
                )
                
                -- Position the clone
                if newCoin:IsA("Model") and newCoin.PrimaryPart then
                    newCoin:SetPrimaryPartCFrame(CFrame.new(humanoidRootPart.Position + randomOffset))
                else
                    -- If it's a model without PrimaryPart, try to position all parts
                    for _, part in pairs(newCoin:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Position = humanoidRootPart.Position + randomOffset
                            break -- Just position one part and let the rest follow
                        end
                    end
                end
                
                -- Parent the new coin to the same folder
                newCoin.Parent = coinFolder
            end
        end
    else
        -- Notify if the CollectCoinLocal folder doesn't exist or is empty
        StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "No coins found to duplicate",
            Duration = 3
        })
    end
end

-- Teleport button functionality
teleportButton.MouseButton1Click:Connect(function()
    isTeleporting = not isTeleporting
    
    if isTeleporting then
        -- Change button appearance
        teleportButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        teleportButton.Text = "Coin Teleporter: ON"
        
        -- Start the teleport loop
        teleportLoop = RunService.Heartbeat:Connect(function()
            teleportToRandomCoin()
        end)
    else
        -- Change button appearance
        teleportButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        teleportButton.Text = "Coin Teleporter: OFF"
        
        -- Stop the teleport loop
        if teleportLoop then
            teleportLoop:Disconnect()
            teleportLoop = nil
        end
    end
end)

-- Spawn button functionality
spawnButton.MouseButton1Click:Connect(function()
    isSpawning = not isSpawning
    
    if isSpawning then
        -- Change button appearance
        spawnButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        spawnButton.Text = "Coin Spawner: ON"
        
        -- Start the spawn loop
        spawnLoop = RunService.Heartbeat:Connect(function()
            spawnRandomCoin()
        end)
    else
        -- Change button appearance
        spawnButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        spawnButton.Text = "Coin Spawner: OFF"
        
        -- Stop the spawn loop
        if spawnLoop then
            spawnLoop:Disconnect()
            spawnLoop = nil
        end
    end
end)

-- Cleanup on script destruction
screenGui.AncestryChanged:Connect(function(_, parent)
    if parent == nil then
        if teleportLoop then teleportLoop:Disconnect() end
        if spawnLoop then spawnLoop:Disconnect() end
    end
end)
