local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- สร้าง ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KEEEDUM HUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.4, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- มุมมน 3D style
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 18)

-- เงาขอบนุ่ม
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(200, 200, 200)
UIStroke.Thickness = 3
UIStroke.Transparency = 0.8

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "KEEEDUM HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.AnchorPoint = Vector2.new(0.5, 0.5)
Title.Position = UDim2.new(0.5, 0, 0, 20)

-- Layout for buttons
local UIListLayout = Instance.new("UIListLayout", MainFrame)
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    MainFrame.Size = UDim2.new(0, 350, 0, UIListLayout.AbsoluteContentSize.Y + 60)
end)

-- Function to create nice buttons
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 18
    btn.Text = text
    btn.AutoButtonColor = true
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 14)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(150, 150, 150)
    stroke.Thickness = 1
    stroke.Transparency = 0.7

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ฟังก์ชันหลักแต่ละอัน

-- Ball ESP toggle
local espEnabled = false
local espHighlights = {}

local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        -- สร้าง Highlight ให้ลูกบอลทุกลูก
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("ball") then
                if not espHighlights[obj] then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = Color3.fromRGB(255, 255, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 100, 0)
                    hl.FillTransparency = 0.4
                    hl.OutlineTransparency = 0.2
                    hl.Adornee = obj
                    hl.Parent = obj
                    espHighlights[obj] = hl
                end
            end
        end
    else
        -- ลบ Highlight ทั้งหมด
        for obj, hl in pairs(espHighlights) do
            if hl and hl.Parent then
                hl:Destroy()
            end
        end
        espHighlights = {}
    end
end

-- Hoop Teleport function
local function hoopTeleport()
    local ball = Workspace:FindFirstChild("Basketball") or Workspace:FindFirstChildWhichIsA("BasePart", true)
    local hoop = nil
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("hoop") or obj.Name:lower():find("goal")) then
            hoop = obj
            break
        end
    end
    if ball and hoop then
        ball.CFrame = hoop.CFrame + Vector3.new(0, 5, 0)
    else
        warn("ไม่พบลูกบอลหรือห่วงในแมพนี้")
    end
end

-- Auto Score (กดปุ่ม E เพื่อชู๊ตอัตโนมัติ)
local function autoScore()
    local UserInputService = game:GetService("UserInputService")
    local ball = Workspace:FindFirstChild("Basketball") or Workspace:FindFirstChildWhichIsA("BasePart", true)
    local hoop = nil
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("hoop") or obj.Name:lower():find("goal")) then
            hoop = obj
            break
        end
    end
    if not ball or not hoop then
        warn("ไม่พบลูกบอลหรือห่วงในแมพนี้")
        return
    end

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.E then
            ball.CFrame = hoop.CFrame + Vector3.new(0, 5, 0)
            print("🏀 Auto Score!")
        end
    end)
end

-- Aim Assist (ช่วยเล็งลูกบอลไปยังห่วงเวลาลูกบอลอยู่ใกล้)
local aimAssistConnection
local function toggleAimAssist()
    if aimAssistConnection then
        aimAssistConnection:Disconnect()
        aimAssistConnection = nil
        print("Aim Assist ปิดแล้ว")
    else
        aimAssistConnection = RunService.RenderStepped:Connect(function()
            local char = Player.Character
            local ball = Workspace:FindFirstChild("Basketball") or Workspace:FindFirstChildWhichIsA("BasePart", true)
            local hoop = nil
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("hoop") or obj.Name:lower():find("goal")) then
                    hoop = obj
                    break
                end
            end
            if char and char:FindFirstChild("HumanoidRootPart") and ball and hoop then
                local dist = (ball.Position - char.HumanoidRootPart.Position).Magnitude
                if dist < 20 then
                    ball.Velocity = (hoop.Position - ball.Position).Unit * 80
                end
            end
        end)
        print("Aim Assist เปิดแล้ว")
    end
end

-- Speed Control
local speedEnabled = false
local function toggleSpeed()
    speedEnabled = not speedEnabled
    local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = speedEnabled and 50 or 16
    end
end

-- Jump Boost
local jumpEnabled = false
local function toggleJump()
    jumpEnabled = not jumpEnabled
    local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = jumpEnabled and 100 or 50
    end
end

-- สร้างปุ่มและเชื่อมฟังก์ชัน
local btnESP = createButton("🟡 Toggle Ball ESP", toggleESP)
local btnTeleport = createButton("🌀 Hoop Teleport", hoopTeleport)
local btnAutoScore = createButton("🏀 Auto Score (กด E)", autoScore)
local btnAimAssist = createButton("🎯 Toggle Aim Assist", toggleAimAssist)
local btnSpeed = createButton("⚡ Toggle Speed Boost", toggleSpeed)
local btnJump = createButton("🦘 Toggle Jump Boost", toggleJump)

print("✅ Basketball Zero GUI พร้อมใช้งาน!")
