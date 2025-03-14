local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.5, -25)
button.Text = "Teleport Sequence"
button.Parent = screenGui

-- Teleport function
local function teleportSequence()
    local savedPosition = hrp.Position -- Save current position
    
    local positions = {
        Vector3.new(-486.2377, -1.3086e-07, -485.8777),
        Vector3.new(486.1329, -1.3136e-07, -485.9947),
        Vector3.new(486.1539, -1.3235e-07, 481.7996),
        Vector3.new(-486.3548, -1.3183e-07, 481.7873),
        Vector3.new(-486.2377, -1.3086e-07, -485.8777)
    }
    
    for _, pos in ipairs(positions) do
        hrp.CFrame = CFrame.new(pos)
        task.wait(0.5)
    end
    
    hrp.CFrame = CFrame.new(savedPosition) -- Return to saved position
end

button.MouseButton1Click:Connect(teleportSequence)
