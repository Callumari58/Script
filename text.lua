--// Hub Script by ChatGPT
-- Đặt LocalScript này vào StarterPlayerScripts

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Khung Key System
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 150)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
KeyFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
KeyFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", KeyFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0, 200, 0, 40)
KeyBox.Position = UDim2.new(0.5, -100, 0.5, -20)
KeyBox.PlaceholderText = "Enter Key..."
KeyBox.Text = ""
KeyBox.Parent = KeyFrame

local ConfirmButton = Instance.new("TextButton")
ConfirmButton.Size = UDim2.new(0, 80, 0, 40)
ConfirmButton.Position = UDim2.new(0.5, -40, 1, -50)
ConfirmButton.Text = "Confirm"
ConfirmButton.Parent = KeyFrame

-- Khung Hub chính
local HubFrame = Instance.new("Frame")
HubFrame.Size = UDim2.new(0, 400, 0, 250)
HubFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
HubFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
HubFrame.Visible = false
HubFrame.Parent = ScreenGui
Instance.new("UICorner", HubFrame).CornerRadius = UDim.new(0, 12)

-- Tabs
local TabButtons = Instance.new("Frame")
TabButtons.Size = UDim2.new(0, 100, 1, 0)
TabButtons.Position = UDim2.new(0, 0, 0, 0)
TabButtons.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabButtons.Parent = HubFrame
Instance.new("UICorner", TabButtons).CornerRadius = UDim.new(0, 12)

local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -100, 1, 0)
Pages.Position = UDim2.new(0, 100, 0, 0)
Pages.BackgroundTransparency = 1
Pages.Parent = HubFrame

-- Hàm tạo tab
local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = name
    btn.Parent = TabButtons

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = Pages

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages:GetChildren()) do
            p.Visible = false
        end
        page.Visible = true
    end)

    return page
end

-- Tạo các tab
local CombatPage = CreateTab("Combat")
local FarmPage = CreateTab("Farm")
local MiscPage = CreateTab("Misc")

-- Nút trong Combat
local CombatButton = Instance.new("TextButton")
CombatButton.Size = UDim2.new(0, 200, 0, 40)
CombatButton.Position = UDim2.new(0, 20, 0, 20)
CombatButton.Text = "Increase WalkSpeed"
CombatButton.Parent = CombatPage
CombatButton.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 50
    end
end)

-- Nút trong Farm
local FarmButton = Instance.new("TextButton")
FarmButton.Size = UDim2.new(0, 200, 0, 40)
FarmButton.Position = UDim2.new(0, 20, 0, 20)
FarmButton.Text = "Teleport to Spawn"
FarmButton.Parent = FarmPage
FarmButton.MouseButton1Click:Connect(function()
    if player.Character then
        player.Character:MoveTo(Vector3.new(0, 10, 0))
    end
end)

-- Nút trong Misc
local MiscButton = Instance.new("TextButton")
MiscButton.Size = UDim2.new(0, 200, 0, 40)
MiscButton.Position = UDim2.new(0, 20, 0, 20)
MiscButton.Text = "Reset Character"
MiscButton.Parent = MiscPage
MiscButton.MouseButton1Click:Connect(function()
    player.Character:BreakJoints()
end)

-- Key system
local CorrectKey = "12345" -- bạn có thể đổi key
ConfirmButton.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then
        KeyFrame.Visible = false
        HubFrame.Visible = true
        -- mặc định mở tab đầu tiên
        Pages:GetChildren()[1].Visible = true
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Wrong Key!"
    end
end)