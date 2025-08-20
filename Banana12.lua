-- BananaCat Hub Fake (cho Roblox Studio game riêng của bạn)

local player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
ScreenGui.Name = "BananaCatHub"

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

-- Tab Buttons
local Tabs = Instance.new("Frame", MainFrame)
Tabs.Size = UDim2.new(0, 100, 1, 0)
Tabs.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Content Frame
local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -100, 1, 0)
Content.Position = UDim2.new(0, 100, 0, 0)
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

-- Helper hàm tạo nút tab
local function CreateTab(name)
    local btn = Instance.new("TextButton", Tabs)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1,1,1)
    return btn
end

-- Các tab
local FarmTab = CreateTab("Farm")
local TeleportTab = CreateTab("Teleport")
local StatsTab = CreateTab("Stats")
local MiscTab = CreateTab("Misc")

-- Hàm hiển thị nội dung
local function ShowTab(tabName)
    Content:ClearAllChildren()
    if tabName == "Farm" then
        local farmBtn = Instance.new("TextButton", Content)
        farmBtn.Size = UDim2.new(0, 200, 0, 50)
        farmBtn.Position = UDim2.new(0.5, -100, 0.1, 0)
        farmBtn.Text = "Auto Farm (OFF)"
        farmBtn.TextColor3 = Color3.new(1,1,1)
        farmBtn.BackgroundColor3 = Color3.fromRGB(70,130,180)
        local autoFarm = false
        farmBtn.MouseButton1Click:Connect(function()
            autoFarm = not autoFarm
            farmBtn.Text = "Auto Farm ("..(autoFarm and "ON" or "OFF")..")"
            if autoFarm then
                task.spawn(function()
                    while autoFarm do
                        task.wait(2)
                        print("Đang auto farm quái...")
                        -- Thêm code farm NPC ở đây
                    end
                end)
            end
        end)
    elseif tabName == "Teleport" then
        local tpBtn = Instance.new("TextButton", Content)
        tpBtn.Size = UDim2.new(0, 200, 0, 50)
        tpBtn.Position = UDim2.new(0.5, -100, 0.1, 0)
        tpBtn.Text = "Teleport Đảo A"
        tpBtn.TextColor3 = Color3.new(1,1,1)
        tpBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        tpBtn.MouseButton1Click:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(1000,50,2000)
            end
        end)
    elseif tabName == "Stats" then
        local statBtn = Instance.new("TextButton", Content)
        statBtn.Size = UDim2.new(0, 200, 0, 50)
        statBtn.Position = UDim2.new(0.5, -100, 0.1, 0)
        statBtn.Text = "Auto Stats"
        statBtn.TextColor3 = Color3.new(1,1,1)
        statBtn.BackgroundColor3 = Color3.fromRGB(155, 89, 182)
        statBtn.MouseButton1Click:Connect(function()
            print("Cộng điểm tự động vào Strength...")
            -- FireServer vào Remote cộng điểm (nếu game của bạn có)
        end)
    elseif tabName == "Misc" then
        local espBtn = Instance.new("TextButton", Content)
        espBtn.Size = UDim2.new(0, 200, 0, 50)
        espBtn.Position = UDim2.new(0.5, -100, 0.1, 0)
        espBtn.Text = "ESP Players"
        espBtn.TextColor3 = Color3.new(1,1,1)
        espBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        espBtn.MouseButton1Click:Connect(function()
            print("Bật ESP hiển thị người chơi...")
            -- Thêm code highlight/ESP
        end)
    end
end

-- Gắn sự kiện cho tab
FarmTab.MouseButton1Click:Connect(function() ShowTab("Farm") end)
TeleportTab.MouseButton1Click:Connect(function() ShowTab("Teleport") end)
StatsTab.MouseButton1Click:Connect(function() ShowTab("Stats") end)
MiscTab.MouseButton1Click:Connect(function() ShowTab("Misc") end)

-- Mặc định mở tab Farm
ShowTab("Farm")