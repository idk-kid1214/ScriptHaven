local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local playerMesh = character:FindFirstChild("PlayerMesh")  -- Assuming PlayerMesh contains Ragdolled

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 100, 0, 50)
button.Position = UDim2.new(0.5, -50, 0, 50)
button.Text = "Lock CFrame"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

local toggled = false
local savedCFrame

local function toggleLock()
    toggled = not toggled
    if toggled then
        savedCFrame = humanoidRootPart.CFrame
        button.Text = "Unlock CFrame"
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

        while toggled do
            if humanoidRootPart then
                humanoidRootPart.CFrame = savedCFrame
                humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                humanoid.PlatformStand = true

                -- Ensure Ragdolled is set to false
                if playerMesh and playerMesh:FindFirstChild("Ragdolled") then
                    playerMesh.Ragdolled.Value = false
                end
            end
            task.wait()
        end
    else
        button.Text = "Lock CFrame"
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        humanoid.PlatformStand = false
    end
end

-- Bind the function to the button click
button.MouseButton1Click:Connect(toggleLock)

-- Bind the function to the "F" key
local userInputService = game:GetService("UserInputService")

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        toggleLock()
    end
end)
