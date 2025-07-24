-- ตัวอย่าง LocalScript สำหรับ Mad City (Roblox)
-- สร้าง GUI สวย ๆ 3D ที่ติดตามหัวผู้เล่น
-- มีฟังก์ชันเยอะ เช่น AutoShoot, SpeedBoost, HighJump

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MadCityCheatGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- สร้าง Frame หลัก (พื้นหลังโปร่งแสงสีเข้ม)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 400)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- เพิ่ม Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Mad City Pro Script v1.0"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- ฟังก์ชันสร้างปุ่ม toggle
local function createToggleButton(text, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text .. ": OFF"
    btn.AutoButtonColor = true
    btn.Parent = frame

    local toggled = false
    btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        btn.Text = text .. (toggled and ": ON" or ": OFF")
        btn.BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 60, 90)
        btn.ToggleState = toggled
    end)
    return btn
end

-- สร้างปุ่มฟังก์ชันต่าง ๆ
local btnAutoShoot = createToggleButton("Auto Shoot", UDim2.new(0, 10, 0, 60))
local btnSpeedBoost = createToggleButton("Speed Boost", UDim2.new(0, 10, 0, 110))
local btnHighJump = createToggleButton("High Jump", UDim2.new(0, 10, 0, 160))
local btnNoClip = createToggleButton("No Clip", UDim2.new(0, 10, 0, 210))
local btnShowHWID = createToggleButton("Show HWID", UDim2.new(0, 10, 0, 260))

-- แสดง HWID (สมมุติแบบง่าย)
local hwidLabel = Instance.new("TextLabel")
hwidLabel.Size = UDim2.new(1, -20, 0, 30)
hwidLabel.Position = UDim2.new(0, 10, 0, 310)
hwidLabel.BackgroundTransparency = 1
hwidLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
hwidLabel.Font = Enum.Font.GothamBold
hwidLabel.TextSize = 16
hwidLabel.Text = "HWID: N/A"
hwidLabel.Visible = false
hwidLabel.Parent = frame

btnShowHWID.MouseButton1Click:Connect(function()
    hwidLabel.Visible = btnShowHWID.ToggleState
    if hwidLabel.Visible then
        -- สร้าง HWID ง่าย ๆ จาก UserId
        hwidLabel.Text = "HWID: " .. tostring(player.UserId * 123456789 % 999999999)
    end
end)

-- ฟังก์ชัน Auto Shoot (ตัวอย่างยิงปืนอัตโนมัติ)
local autoShootEnabled = false
btnAutoShoot.MouseButton1Click:Connect(function()
    autoShootEnabled = btnAutoShoot.ToggleState
end)

-- ฟังก์ชัน Speed Boost
local speedBoostEnabled = false
local normalWalkSpeed = 16
local boostedSpeed = 50
btnSpeedBoost.MouseButton1Click:Connect(function()
    speedBoostEnabled = btnSpeedBoost.ToggleState
    if speedBoostEnabled then
        if character and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.WalkSpeed = boostedSpeed
        end
    else
        if character and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.WalkSpeed = normalWalkSpeed
        end
    end
end)

-- ฟังก์ชัน High Jump
local highJumpEnabled = false
local normalJumpPower = 50
local boostedJumpPower = 150
btnHighJump.MouseButton1Click:Connect(function()
    highJumpEnabled = btnHighJump.ToggleState
    if highJumpEnabled then
        if character and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.JumpPower = boostedJumpPower
        end
    else
        if character and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.JumpPower = normalJumpPower
        end
    end
end)

-- ฟังก์ชัน No Clip (เดินทะลุผนังง่าย ๆ)
local noClipEnabled = false
btnNoClip.MouseButton1Click:Connect(function()
    noClipEnabled = btnNoClip.ToggleState
end)

-- แทนที่หัวลูกกระสุนปืนอัตโนมัติ (ตัวอย่าง)
local function tryAutoShoot()
    -- ตัวอย่างโค้ดยิงปืน (ต้องแก้ตาม Mad City จริง)
    -- นี้เป็นเพียงตัวอย่าง print แสดงผล
    print("Auto Shoot กำลังทำงาน...")
    -- คุณสามารถเพิ่มโค้ดยิงจริงได้ที่นี่
end

-- Main Loop
RunService.RenderStepped:Connect(function()
    -- Auto Shoot
    if autoShootEnabled then
        tryAutoShoot()
    end

    -- No Clip Implementation (ง่าย ๆ)
    if noClipEnabled and character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end

    -- อัพเดต character ถ้าเปลี่ยนตัว
    if not character or not character.Parent then
        character = player.Character or player.CharacterAdded:Wait()
        if speedBoostEnabled and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.WalkSpeed = boostedSpeed
        end
        if highJumpEnabled and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.JumpPower = boostedJumpPower
        end
    end

    -- อัพเดต GUI ให้ติดตามหัวผู้เล่น (3D ขยับตามกล้อง)
    if character and character:FindFirstChild("Head") then
        local headPos, onScreen = camera:WorldToViewportPoint(character.Head.Position + Vector3.new(0, 2, 0))
        if onScreen then
            frame.Position = UDim2.new(0, headPos.X - frame.Size.X.Offset/2, 0, headPos.Y - frame.Size.Y.Offset/2)
            frame.Visible = true
        else
            frame.Visible = false
        end
    else
        frame.Visible = false
    end
end)

print("Mad City Pro Script loaded. GUI พร้อมใช้งาน")
