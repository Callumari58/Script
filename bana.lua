-- // Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- // SETTINGS
local CorrectKey = "12345"           -- TODO: change this
local BANANA_IMAGE_ID = "rbxassetid://12283162167" -- TODO: replace with your banana image id
local REMEMBER_KEY_THIS_SESSION = true -- uses shared[] to skip key prompt on subsequent spawns


-- // ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BananaMaruHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- // Banana Toggle (draggable)
local ToggleIcon = Instance.new("ImageButton")
ToggleIcon.Name = "BananaToggle"
ToggleIcon.Size = UDim2.new(0, 60, 0, 60)
ToggleIcon.Position = UDim2.new(0, 20, 0.5, -30) -- left middle
ToggleIcon.BackgroundTransparency = 1
ToggleIcon.Image = BANANA_IMAGE_ID
ToggleIcon.Parent = ScreenGui

-- Drag logic
do
    local dragging, dragInput, dragStart, startPos
    ToggleIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ToggleIcon.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    ToggleIcon.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            ToggleIcon.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- // Main Frame (Hub)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 560, 0, 340)
Main.Position = UDim2.new(0.5, -280, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BackgroundTransparency = 0.08
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("TextLabel")
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
TopBar.BackgroundTransparency = 0.2
TopBar.Text = "🍌 Banana/Maru Hub"
TopBar.Font = Enum.Font.GothamBold
TopBar.TextSize = 16
TopBar.TextColor3 = Color3.fromRGB(255,255,255)
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

-- Sidebar
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 140, 1, -36)
SideBar.Position = UDim2.new(0, 0, 0, 36)
SideBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
SideBar.BackgroundTransparency = 0.1
SideBar.Parent = Main
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 10)

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -140, 1, -36)
TabContainer.Position = UDim2.new(0, 140, 0, 36)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Main

-- List layout for sidebar buttons
local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 6)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = SideBar

-- Helpers
local function createTabButton(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 38)
    btn.Position = UDim2.new(0, 8, 0, 0)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.BackgroundTransparency = 0.05
    btn.AutoButtonColor = true
    btn.Parent = SideBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local function createTabPage(name)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundColor3 = Color3.fromRGB(30,30,30)
    page.BackgroundTransparency = 0.05
    page.Visible = false
    page.Parent = TabContainer
    Instance.new("UICorner", page).CornerRadius = UDim.new(0, 10)
    return page
end

local tabs = {"Farm","Farm Other","Sea Event","Other","Settings"}
local tabButtons = {}
local tabPages = {}

for _, t in ipairs(tabs) do
    tabButtons[t] = createTabButton(t)
    tabPages[t] = createTabPage(t)
end
local function showTab(name)
    for k, p in pairs(tabPages) do p.Visible = (k == name) end
end
showTab("Farm")

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        showTab(name)
    end)
end

-- // Toggle via Banana & RightShift
ToggleIcon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

-- // Key System (enter once per session)
local function hasKeyAlready()
    if not REMEMBER_KEY_THIS_SESSION then return false end
    shared.__BananaHubKeyOK = shared.__BananaHubKeyOK or false
    return shared.__BananaHubKeyOK == true
end
local function markKeyOK()
    if REMEMBER_KEY_THIS_SESSION then
        shared.__BananaHubKeyOK = true
    end
end

local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 300, 0, 160)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
KeyFrame.BackgroundTransparency = 0.1
KeyFrame.Visible = not hasKeyAlready()
KeyFrame.Parent = ScreenGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 36)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "🔑 Enter Key"
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 16
KeyTitle.TextColor3 = Color3.fromRGB(255,255,255)
KeyTitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -20, 0, 38)
KeyBox.Position = UDim2.new(0, 10, 0, 50)
KeyBox.PlaceholderText = "Type your key..."
KeyBox.Text = ""
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
KeyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
KeyBox.Parent = KeyFrame
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local ConfirmKey = Instance.new("TextButton")
ConfirmKey.Size = UDim2.new(1, -20, 0, 36)
ConfirmKey.Position = UDim2.new(0, 10, 1, -46)
ConfirmKey.Text = "Confirm"
ConfirmKey.Font = Enum.Font.GothamBold
ConfirmKey.TextSize = 14
ConfirmKey.TextColor3 = Color3.fromRGB(255,255,255)
ConfirmKey.BackgroundColor3 = Color3.fromRGB(50,120,200)
ConfirmKey.Parent = KeyFrame
Instance.new("UICorner", ConfirmKey).CornerRadius = UDim.new(0, 8)

-- Loading Toast
local function loadingToast(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 260, 0, 60)
    label.Position = UDim2.new(0.5, -130, 0.5, -30)
    label.BackgroundColor3 = Color3.fromRGB(30,30,30)
    label.BackgroundTransparency = 0.15
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextSize = 18
    label.Font = Enum.Font.GothamBold
    label.Text = text or "Loading Hub..."
    label.Parent = ScreenGui
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 10)
    return label
end

local function doOpenHubWithLoading()
    local toast = loadingToast("Loading Hub...")
    task.wait(1.2)
    toast.Text = "✅ Done"
    task.wait(0.6)
    toast:Destroy()
    Main.Visible = true
end

if hasKeyAlready() then
    KeyFrame.Visible = false
    doOpenHubWithLoading()
end

ConfirmKey.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then
        markKeyOK()
        KeyFrame.Visible = false
        doOpenHubWithLoading()
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "❌ Wrong key!"
    end
end)

-- // ---------- TABS CONTENT ----------
local function makeTitle(parent, text)
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -20, 0, 28)
    t.Position = UDim2.new(0, 10, 0, 10)
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextColor3 = Color3.fromRGB(255,255,255)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 16
    t.Parent = parent
    return t
end
local function addToggle(parent, label, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 34)
    btn.Position = UDim2.new(0, 16, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(55,55,55)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = label .. " OFF"
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = label .. (state and " ON" or " OFF")
    end)
    return function() return state end, function(v) state=v; btn.Text = label .. (state and " ON" or " OFF") end, btn
end

-- Farm
makeTitle(tabPages["Farm"], "⚡ Farm (place your Blox Fruits logic here)")
local getAutoFarm = addToggle(tabPages["Farm"], "AutoFarm", 48)

-- Farm Other
makeTitle(tabPages["Farm Other"], "🗡️ Farm Other")
local getAutoBoss = addToggle(tabPages["Farm Other"], "AutoBoss", 48)
local getAutoChest = addToggle(tabPages["Farm Other"], "AutoChest", 88)

-- Sea Event
makeTitle(tabPages["Sea Event"], "🌊 Sea Event")
local getSeaDetect = addToggle(tabPages["Sea Event"], "Detect Events", 48)

-- Other (Speed, Fly, Noclip)
makeTitle(tabPages["Other"], "⚙️ Utilities")
local getSpeed = addToggle(tabPages["Other"], "Speed", 48)
local getFly = addToggle(tabPages["Other"], "Fly", 88)
local getNoclip = addToggle(tabPages["Other"], "Noclip", 128)

-- Settings
makeTitle(tabPages["Settings"], "⚙️ Settings & Visual")
local fpsBoostGet = addToggle(tabPages["Settings"], "FPS Boost", 48)

-- // ---------- Utility Loops (examples) ----------
local function Char() return player.Character or player.CharacterAdded:Wait() end
local function Hum() local c=Char(); return c and c:FindFirstChildOfClass("Humanoid") end
local function Root() local c=Char(); return c and c:FindFirstChild("HumanoidRootPart") end

-- Speed + Noclip loop
RS.Heartbeat:Connect(function()
    local h = Hum()
    if h then
        h.WalkSpeed = getSpeed() and 60 or 16
    end
    if getNoclip() and Char() then
        for _, part in ipairs(Char():GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Fly loop
local flyConn
local function startFly()
    local r = Root(); if not r then return end
    local bv = Instance.new("BodyVelocity")
    bv.Name = "FlyVel"
    bv.MaxForce = Vector3.new(4000,4000,4000)
    bv.Parent = r
    flyConn = RS.RenderStepped:Connect(function()
        if not getFly() then
            if bv and bv.Parent then bv:Destroy() end
            if flyConn then flyConn:Disconnect() end
            return
        end
        local h = Hum(); if not h then return end
        local dir = h.MoveDirection
        local y = 0
        if UIS:IsKeyDown(Enum.KeyCode.Space) then y = 45
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then y = -45 end
        bv.Velocity = Vector3.new(dir.X*55, y, dir.Z*55)
    end)
end
task.spawn(function()
    local last = false
    while task.wait(0.12) do
        if getFly() and not last then startFly() end
        last = getFly()
    end
end)

-- Placeholders for your Blox Fruits logic
task.spawn(function()
    while task.wait(0.2) do
        if getAutoFarm() then
            -- TODO: your Auto Farm Level/Quest/Mob logic here
        end
        if getAutoBoss() then
            -- TODO: find and fight bosses
        end
        if getAutoChest() then
            -- TODO: scan workspace for chests and tween to them
        end
        if getSeaDetect() then
            -- TODO: detect sea events / sea beast and notify
        end
    end
end)
