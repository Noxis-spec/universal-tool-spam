local SPAM_SPEED = 0.0001
local enabled = false
local currentToolName = nil
local menuOpen = false

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

-- Ждем полной прогрузки интерфейса игрока
local playerGui = lp:WaitForChild("PlayerGui")

-- Инициализация графической библиотеки элементов
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = playerGui -- Использование PlayerGui вместо CoreGui для совместимости с Delta/Arceus
ScreenGui.Name = "UniversalSpamLibraryUI"
ScreenGui.ResetOnSpawn = false -- Меню не пропадет после смерти персонажа

-- Главный контейнер
local MainHolder = Instance.new("Frame")
MainHolder.Parent = ScreenGui
MainHolder.Size = UDim2.new(0, 130, 0, 45)
MainHolder.Position = UDim2.new(0.3, 0, 0.4, 0) -- Сдвинул чуть правее от левого края дисплея
MainHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainHolder.BorderSizePixel = 0
MainHolder.Active = true
MainHolder.Draggable = true 

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainHolder

-- Главная кнопка спама
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = MainHolder
ToggleButton.Size = UDim2.new(1, -35, 1, 0)
ToggleButton.Position = UDim2.new(0, 0, 0, 0)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Text = "SPAM: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(235, 75, 75)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 16

-- Кнопка стрелочки
local DropdownArrow = Instance.new("TextButton")
DropdownArrow.Parent = MainHolder
DropdownArrow.Size = UDim2.new(0, 35, 1, 0)
DropdownArrow.Position = UDim2.new(1, -35, 0, 0)
DropdownArrow.BackgroundTransparency = 1
DropdownArrow.Text = "▼"
DropdownArrow.TextColor3 = Color3.fromRGB(200, 200, 200)
DropdownArrow.Font = Enum.Font.SourceSansBold
DropdownArrow.TextSize = 14

-- Выдвижное меню
local DropdownMenu = Instance.new("Frame")
DropdownMenu.Parent = MainHolder
DropdownMenu.Size = UDim2.new(1, 0, 0, 0)
DropdownMenu.Position = UDim2.new(0, 0, 0, 48)
DropdownMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
DropdownMenu.BorderSizePixel = 0
DropdownMenu.ClipsDescendants = true

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 8)
MenuCorner.Parent = DropdownMenu

-- Скролл-зона
local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Parent = DropdownMenu
ScrollList.Size = UDim2.new(1, -10, 1, -30)
ScrollList.Position = UDim2.new(0, 5, 0, 5)
ScrollList.BackgroundTransparency = 1
ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollList.ScrollBarThickness = 2
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

-- Текст статуса выбранного предмета
local InfoText = Instance.new("TextLabel")
InfoText.Parent = DropdownMenu
InfoText.Size = UDim2.new(1, 0, 0, 20)
InfoText.Position = UDim2.new(0, 0, 1, -22)
InfoText.BackgroundTransparency = 1
InfoText.Text = "Target: None"
InfoText.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoText.Font = Enum.Font.SourceSansItalic
InfoText.TextSize = 12

-- Библиотечный аниматор выдвижения меню
local function toggleMenu()
    menuOpen = not menuOpen
    local targetSize = menuOpen and UDim2.new(1, 0, 0, 150) or UDim2.new(1, 0, 0, 0)
    DropdownArrow.Text = menuOpen and "▲" or "▼"
    
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(DropdownMenu, tweenInfo, {Size = targetSize})
    tween:Play()
end

DropdownArrow.MouseButton1Click:Connect(toggleMenu)

-- Функция полной библиотеки обновления списка предметов
local function updateInventoryList()
    local currentButtons = {}
    local addedTools = {}

    local backpack = lp:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then addedTools[tool.Name] = true end
        end
    end
    
    if lp.Character then
        local equippedTool = lp.Character:FindFirstChildOfClass("Tool")
        if equippedTool then addedTools[equippedTool.Name] = true end
    end

    for _, child in pairs(ScrollList:GetChildren()) do
        if child:IsA("TextButton") then
            if not addedTools[child.Text] then
                child:Destroy()
            else
                currentButtons[child.Text] = true
            end
        end
    end

    for toolName, _ in pairs(addedTools) do
        if not currentButtons[toolName] then
            local ItemBtn = Instance.new("TextButton")
            ItemBtn.Parent = ScrollList
            ItemBtn.Size = UDim2.new(1, 0, 0, 25)
            ItemBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            ItemBtn.Text = toolName
            ItemBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
            ItemBtn.Font = Enum.Font.SourceSans
            ItemBtn.TextSize = 13
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = ItemBtn
            
            ItemBtn.MouseButton1Click:Connect(function()
                currentToolName = toolName
                InfoText.Text = "Target: " .. toolName
                toggleMenu()
            end)
        end
    end
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

-- Ежесекундный фоновый процесс
task.spawn(function()
    while true do
        pcall(updateInventoryList)
        task.wait(1)
    end
end)

-- Логика переключения режима спама
ToggleButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        ToggleButton.TextColor3 = Color3.fromRGB(75, 235, 75)
        ToggleButton.Text = "SPAM: ON"
    else
        ToggleButton.TextColor3 = Color3.fromRGB(235, 75, 75)
        ToggleButton.Text = "SPAM: OFF"
    end
end)

-- Основной цикл ультра-кликера предметов
task.spawn(function()
    while true do
        if enabled and currentToolName then
            local character = lp.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local backpack = lp:FindFirstChild("Backpack")
            
            if humanoid and backpack then
                local tool = backpack:FindFirstChild(currentToolName)
                if tool then
                    humanoid:EquipTool(tool)
                end
                task.wait(SPAM_SPEED)
                humanoid:UnequipTools()
            end
        end
        task.wait(SPAM_SPEED)
    end
end)
