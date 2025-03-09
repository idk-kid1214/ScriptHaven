local player = game.Players.LocalPlayer
local userInterface = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local toggleButton = Instance.new("TextButton", userInterface)

toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Toggle Size"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local isChangingSize = false
local sizeCoroutine = nil

toggleButton.MouseButton1Click:Connect(function()
    isChangingSize = not isChangingSize
    toggleButton.TextColor3 = isChangingSize and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)

    -- If size change is already active, stop it first
    if sizeCoroutine then
        coroutine.close(sizeCoroutine)
    end

    -- Locate the FoodHitbox for the player
    local foodHitbox = workspace:FindFirstChild(player.Name):FindFirstChild("FoodHitbox")
    if not foodHitbox then
        warn("FoodHitbox not found in Player's folder!")
        return
    end

    -- Continuously set the size while the toggle is on
    if isChangingSize then
        sizeCoroutine = coroutine.create(function()
            while isChangingSize do
                foodHitbox.Size = Vector3.new(150, 150, 150)
                print("Set FoodHitbox size to 100, 100, 100")
                wait(0.1)  -- Short wait to prevent too frequent changes
            end
        end)
        coroutine.resume(sizeCoroutine)
    end
end)
