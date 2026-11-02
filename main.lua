-- universal-tool-spam / main.lua
-- Refactored for mobile (Delta, Arceus X, Codex)
-- Features: object pool, anti-AFK, speed slider, respawn-safe, draggable GUI,
--           persistent tool selection (remembered until changed manually)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local lp = Players.LocalPlayer

-- ==================== CONFIG ====================
local SPAM_SPEED = 0.0001
local SCAN_INTERVAL = 1.0
local DRAG_THRESHOLD = 10
local COLOR_BTN_IDLE = Color3.fromRGB(45, 45, 52)
local COLOR_BTN_SELECTED = Color3.fromRGB(0, 120, 200)
-- ================================================

-- ---------- Anti-AFK ----------
lp.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- ---------- GUI Parent (executor-safe) ----------
local guiParent
do
    local ok, res = pcall(function() return gethui() end)
    if ok and res then
        guiParent = res
    else
        local ok2, res2 = pcall(function() return game:GetService("CoreGui") end)
        if ok2 and res2 then
            guiParent = res2
        else
            guiParent = lp:WaitForChild("PlayerGui")
        end
    end
end

for _, obj in ipairs(guiParent:GetChildren()) do
    if obj.Name == "UniversalToolSpam" then
        obj:Destroy()
    end
end

-- ---------- UI Construction ----------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalToolSpam"
screenGui.ResetOnSpawn = false
screenGui.Parent = guiParent

-- Container (draggable group)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0, 12, 0.5, -16)
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = screenGui

-- Toggle button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 90, 0, 32)
toggleBtn.Position = UDim2.new(0, 0, 0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "SPAM: OFF"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 13
toggleBtn.Parent = mainFrame

local corner1 = Instance.new("UICorner")
corner1.CornerRadius = UDim.new(0, 8)
corner1.Parent = toggleBtn

-- Arrow button
local arrowBtn = Instance.new("TextButton")
arrowBtn.Name = "ArrowBtn"
arrowBtn.Size = UDim2.new(0, 28, 0, 32)
arrowBtn.Position = UDim2.new(0, 94, 0, 0)
arrowBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
arrowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
arrowBtn.Text = "▼"
arrowBtn.Font = Enum.Font.GothamBold
arrowBtn.TextSize = 14
arrowBtn.Parent = mainFrame

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 8)
corner2.Parent = arrowBtn

-- Dropdown
local dropdown = Instance.new("ScrollingFrame")
dropdown.Name = "Dropdown"
dropdown.Size = UDim2.new(0, 134, 0, 0)
dropdown.Position = UDim2.new(0, 0, 0, 34)
dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
dropdown.BorderSizePixel = 0
dropdown.ScrollBarThickness = 3
dropdown.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
dropdown.ClipsDescendants = true
dropdown.Visible = false
dropdown.Parent = mainFrame

local corner3 = Instance.new("UICorner")
corner3.CornerRadius = UDim.new(0, 8)
corner3.Parent = dropdown

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = dropdown

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 6)
padding.PaddingBottom = UDim.new(0, 6)
padding.PaddingLeft = UDim.new(0, 6)
padding.PaddingRight = UDim.new(0, 6)
padding.Parent = dropdown

-- Speed slider
local sliderFrame = Instance.new("Frame")
sliderFrame.Name = "SpeedSliderFrame"
sliderFrame.Size = UDim2.new(1, 0, 0, 38)
sliderFrame.BackgroundTransparency = 1
sliderFrame.LayoutOrder = 999
sliderFrame.Parent = dropdown

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, 0, 0, 14)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Speed: 0.0001s"
sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 10
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.Parent = sliderFrame

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, -4, 0, 8)
sliderTrack.Position = UDim2.new(0, 2, 0, 20)
sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 68)
sliderTrack.BorderSizePixel = 0
sliderTrack.Parent = sliderFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 4)
sliderCorner.Parent = sliderTrack

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 4)
fillCorner.Parent = sliderFill

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 14, 0, 14)
sliderKnob.Position = UDim2.new(0.5, -7, 0.5, -7)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.BorderSizePixel = 0
sliderKnob.Parent = sliderTrack

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(0, 7)
knobCorner.Parent = sliderKnob

-- ---------- State ----------
local enabled = false
local selectedToolName = nil
local generation = 0
local toolButtons = {}
local buttonPool = {}
local isDraggingSlider = false

-- ---------- Slider Logic ----------
local function updateSliderVisual(ratio)
    sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
    sliderKnob.Position = UDim2.new(ratio, -7, 0.5, -7)
end

local function setSpeedFromRatio(ratio)
    local minV, maxV = 0.0001, 0.5
    local value = minV + (maxV - minV) * (ratio ^ 2)
    SPAM_SPEED = value
    sliderLabel.Text = string.format("Speed: %.4fs", value)
    updateSliderVisual(ratio)
end

setSpeedFromRatio(0.1)

sliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingSlider = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not isDraggingSlider then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    local relX = input.Position.X - sliderTrack.AbsolutePosition.X
    local ratio = math.clamp(relX / sliderTrack.AbsoluteSize.X, 0, 1)
    setSpeedFromRatio(ratio)
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingSlider = false
    end
end)

-- ---------- Drag Logic (whole GUI) ----------
local potentialDrag = false
local dragging = false
local dragStart = nil
local startPos = nil

local function beginDrag(input)
    potentialDrag = true
    dragging = false
    dragStart = input.Position
    startPos = mainFrame.Position
end

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        beginDrag(input)
    end
end)

arrowBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        beginDrag(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not potentialDrag then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local delta = input.Position - dragStart
    if not dragging then
        if delta.Magnitude >= DRAG_THRESHOLD then
            dragging = true
        else
            return
        end
    end

    mainFrame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        potentialDrag = false
        dragging = false
    end
end)

-- ---------- Dropdown Toggle ----------
local dropdownOpen = false

local function setDropdownOpen(open)
    dropdownOpen = open
    local targetHeight = open and 180 or 0
    if open then dropdown.Visible = true end

    local tween = TweenService:Create(
        dropdown,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 134, 0, targetHeight) }
    )
    tween:Play()
    tween.Completed:Connect(function()
        if not dropdownOpen then dropdown.Visible = false end
    end)
end

arrowBtn.MouseButton1Click:Connect(function()
    setDropdownOpen(not dropdownOpen)
end)

-- ---------- Highlight Helper ----------
local function updateSelectionHighlight()
    for name, btn in pairs(toolButtons) do
        if name == selectedToolName then
            btn.BackgroundColor3 = COLOR_BTN_SELECTED
        else
            btn.BackgroundColor3 = COLOR_BTN_IDLE
        end
    end
end

-- ---------- Tool Button Pool ----------
local function getOrCreateButton(toolName, layoutOrder)
    local btn = buttonPool[#buttonPool]
    if btn then
        table.remove(buttonPool)
    else
        btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 0, 26)
        btn.BackgroundColor3 = COLOR_BTN_IDLE
        btn.TextColor3 = Color3.fromRGB(220, 220, 230)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.TextTruncate = Enum.TextTruncate.AtEnd
        btn.BorderSizePixel = 0
        btn.Parent = dropdown
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 5)
        c.Parent = btn

        btn.MouseButton1Click:Connect(function()
            local name = btn:GetAttribute("ToolName")
            if name then
                selectedToolName = name
                updateSelectionHighlight()
                toggleBtn.Text = "SPAM: " .. (enabled and "ON" or "OFF")
                setDropdownOpen(false)
            end
        end)
    end
    btn.Name = toolName
    btn.Text = toolName
    btn.LayoutOrder = layoutOrder
    btn.Visible = true
    btn:SetAttribute("ToolName", toolName)
    btn.BackgroundColor3 = (toolName == selectedToolName)
        and COLOR_BTN_SELECTED or COLOR_BTN_IDLE
    return btn
end

local function releaseButton(btn)
    btn.Visible = false
    btn:SetAttribute("ToolName", nil)
    btn.BackgroundColor3 = COLOR_BTN_IDLE
    table.insert(buttonPool, btn)
end

-- ---------- Tool Scanning (selection is NOT reset) ----------
local function scanTools()
    local char = lp.Character
    if not char then return end

    local currentSet = {}
    local order = 0

    for _, item in ipairs(lp.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            currentSet[item.Name] = true
            if not toolButtons[item.Name] then
                toolButtons[item.Name] = getOrCreateButton(item.Name, order)
            end
            order = order + 1
        end
    end

    local equipped = char:FindFirstChildOfClass("Tool")
    if equipped then
        currentSet[equipped.Name] = true
        if not toolButtons[equipped.Name] then
            toolButtons[equipped.Name] = getOrCreateButton(equipped.Name, order)
        end
    end

    for name, btn in pairs(toolButtons) do
        if not currentSet[name] then
            releaseButton(btn)
            toolButtons[name] = nil
            -- selectedToolName НЕ сбрасываем: выбор запоминается навсегда
        end
    end

    updateSelectionHighlight()

    -- Статус кнопки: если выбранный предмет недоступен — показываем ожидание
    if selectedToolName then
        if currentSet[selectedToolName] then
            toggleBtn.Text = "SPAM: " .. (enabled and "ON" or "OFF")
        else
            toggleBtn.Text = enabled and "SPAM: ON (waiting)" or "SPAM: OFF"
        end
    end
end

-- ---------- Spam Loop ----------
local function startSpamLoop()
    task.spawn(function()
        local myGen = generation
        while enabled and myGen == generation do
            local char = lp.Character
            if not char then
                task.wait(0.5)
                continue
            end

            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 then
                task.wait(0.5)
                continue
            end

            if selectedToolName then
                local tool = lp.Backpack:FindFirstChild(selectedToolName)
                    or char:FindFirstChild(selectedToolName)

                if tool and tool:IsA("Tool") then
                    pcall(function()
                        humanoid:EquipTool(tool)
                        task.wait(SPAM_SPEED)
                        humanoid:UnequipTools()
                    end)
                else
                    task.wait(0.2)
                end
            else
                task.wait(0.2)
            end

            task.wait(SPAM_SPEED)
        end
    end)
end

toggleBtn.MouseButton1Click:Connect(function()
    if dragging then return end
    enabled = not enabled

    if enabled then
        if not selectedToolName then
            enabled = false
            toggleBtn.Text = "SPAM: OFF"
            return
        end
        toggleBtn.Text = "SPAM: ON"
        startSpamLoop()
    else
        toggleBtn.Text = "SPAM: OFF"
    end
end)

-- ---------- Character Lifecycle ----------
local function onCharacterAdded(char)
    generation = generation + 1

    if screenGui.Parent == nil then
        screenGui.Parent = guiParent
    end

    if enabled and selectedToolName then
        startSpamLoop()
    end

    task.wait(1)
    scanTools()
end

lp.CharacterAdded:Connect(onCharacterAdded)

if lp.Character then
    task.defer(onCharacterAdded, lp.Character)
end

-- ---------- Background Scanner ----------
task.spawn(function()
    while true do
        task.wait(SCAN_INTERVAL)
        pcall(scanTools)
    end
end)