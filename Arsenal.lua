-- Roblox Arsenal AutoKill Script ตัวอย่าง
-- ฟังก์ชันและ GUI พร้อมใช้งาน

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Config --
local autoAimEnabled = false
local autoKillDistance = 100 -- ระยะยิงอัตโนมัติ (studs)

-- สร้าง GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KEEEDUM HUB"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0, 20, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.3
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Arsenal AutoKill"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleButton.Text = "เปิด AutoKill (ปิด)"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.GothamSemibold
ToggleButton.TextSize = 16
ToggleButton.Parent = Frame
ToggleButton.AutoButtonColor = false

ToggleButton.MouseEnter:Connect(function()
    ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
ToggleButton.MouseLeave:Connect(function()
    ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
end)

-- ฟังก์ชันหาเป้าหมายที่ใกล้ที่สุด
local function getClosestEnemy()
    local character = LocalPlayer.Character
    if not character then return nil end
    local head = character:FindFirstChild("Head")
    if not head then return nil end

    local closestEnemy = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local enemyHead = player.Character.Head
            local distance = (enemyHead.Position - head.Position).magnitude
            if distance < shortestDistance and distance <= autoKillDistance then
                shortestDistance = distance
                closestEnemy = enemyHead
            end
        end
    end

    return closestEnemy
end

-- ฟังก์ชันยิงปืน (ตรงนี้ให้แก้ตาม RemoteEvent ของเกม Arsenal)
local function shoot()
    -- ตัวอย่างยิงปืนโดยการส่ง RemoteEvent
    -- ต้องแก้ให้ตรงกับเกมจริงๆ
    local character = LocalPlayer.Character
    if not character then return end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Fire") then
        tool.Fire:FireServer()
    elseif tool and tool:FindFirstChild("ShootEvent") then
        tool.ShootEvent:FireServer()
    else
        -- ถ้าไม่มี RemoteEvent ตัวอย่างกดคลิกซ้ายด้วย VirtualInput
        -- หรือยิงไม่ได้
    end
end

-- ฟังก์ชัน AutoKill
local function autoKill()
    if not autoAimEnabled then return end

    local target = getClosestEnemy()
    if target then
        -- หมุนกล้องไปยังเป้าหมาย
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)

        -- ยิงปืน
        shoot()
    end
end

-- Toggle AutoKill
ToggleButton.MouseButton1Click:Connect(function()
    autoAimEnabled = not autoAimEnabled
    if autoAimEnabled then
        ToggleButton.Text = "เปิด AutoKill (เปิด)"
    else
        ToggleButton.Text = "เปิด AutoKill (ปิด)"
    end
end)

-- เชื่อมต่อกับ RenderStepped เพื่อเรียก autoKill ทุกเฟรม
RunService.RenderStepped:Connect(function()
    if autoAimEnabled then
        autoKill()
    end
end)
