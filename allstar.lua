local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "KEEEDUM HUB"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 350, 0, 260)
Frame.Position = UDim2.new(0.5, -175, 0.4, -130)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 15)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "🤖 ASTD Macro Recorder (ตำแหน่ง + อัพเกรด)"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Position = UDim2.new(0,0,0,5)

local function createButton(text, y, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(0.9,0,0,40)
    btn.Position = UDim2.new(0.05,0,0,y)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 18
    btn.Text = text

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,12)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ตัวแปรเก็บ sequence
local recording = false
local macroSequence = {} -- {action="build"/"upgrade", position=Vector3, time=number}

local lastRecordTime = 0
local playing = false
local playCoroutine

local function recordAction(actionType, position)
    if recording then
        local now = tick()
        table.insert(macroSequence, {
            action = actionType,
            position = position and Vector3.new(position.X, position.Y, position.Z) or nil,
            time = now - lastRecordTime
        })
        lastRecordTime = now
        print("บันทึก: "..actionType..(position and (" ตำแหน่ง: "..tostring(position)) or ""))
    end
end

-- ฟังก์ชันวางป้อมจริง (จำลอง)  
local function buildTowerAt(position)
    -- ตัวอย่าง: เดินไปตำแหน่ง แล้วเรียก RemoteEvent วางป้อม  
    print("วางป้อมที่: "..tostring(position))

    -- สมมติ RemoteEvent วางป้อม
    -- local remote = game:GetService("ReplicatedStorage"):WaitForChild("PlaceTower")
    -- remote:FireServer(position)

    -- ตัวอย่างแค่ teleport ตัวละคร
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = CFrame.new(position + Vector3.new(0,3,0))
    end
end

-- ฟังก์ชันอัพเกรดป้อม (จำลอง)
local function upgradeTowerAt(position)
    print("อัพเกรดป้อมที่: "..tostring(position))

    -- สมมติ RemoteEvent อัพเกรด
    -- local remote = game:GetService("ReplicatedStorage"):WaitForChild("UpgradeTower")
    -- remote:FireServer(position)

    -- หรือคลิก UI ปุ่มอัพเกรด ถ้ามี
end

local function playMacro()
    if #macroSequence == 0 then
        warn("ไม่มีข้อมูลแมโครที่บันทึก")
        return
    end
    playing = true
    playCoroutine = coroutine.create(function()
        while playing do
            for i, action in ipairs(macroSequence) do
                if not playing then break end
                wait(action.time)
                if action.action == "build" and action.position then
                    buildTowerAt(action.position)
                elseif action.action == "upgrade" and action.position then
                    upgradeTowerAt(action.position)
                end
            end
        end
    end)
    coroutine.resume(playCoroutine)
    print("เริ่มเล่นแมโคร")
end

local function stopMacro()
    playing = false
    if playCoroutine and coroutine.status(playCoroutine) ~= "dead" then
        coroutine.close(playCoroutine)
    end
    print("หยุดเล่นแมโคร")
end

-- ปุ่ม GUI
local btnRecord = createButton("🔴 เริ่มอัดแมโคร", 0.2, function()
    recording = true
    macroSequence = {}
    lastRecordTime = tick()
    print("เริ่มอัดแมโคร")
end)

local btnStopRecord = createButton("⏹️ หยุดอัดแมโคร", 0.45, function()
    recording = false
    print("หยุดอัดแมโคร จำนวน action: "..#macroSequence)
end)

local btnPlay = createButton("▶️ เริ่มเล่นแมโคร", 0.7, function()
    if not playing then
        playMacro()
    end
end)

local btnStop = createButton("⏹️ หยุดแมโคร", 0.95, function()
    if playing then
        stopMacro()
    end
end)

-- ตัวอย่างบันทึกการวางและอัพเกรดโดยกดปุ่ม (ปรับตามเกมจริง)
UIS.InputBegan:Connect(function(input, gameProcessed)
    if recording and not gameProcessed and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart
        local pos = hrp.Position
        if input.KeyCode == Enum.KeyCode.B then
            recordAction("build", pos)
        elseif input.KeyCode == Enum.KeyCode.U then
            recordAction("upgrade", pos)
        end
    end
end)

print("✅ Macro Recorder (ตำแหน่ง+อัพเกรด) โหลดเรียบร้อย")
