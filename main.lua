-- ========== XyqwHub | EXTRA MODE (Safe Shell) ==========
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local HUB_NAME = "XyqwHub Extra"
local startTime = tick()
local isRunning = true

-- Тема Xyqw
local RED_MAIN = Color3.fromRGB(255, 0, 0)
local RED_DARK = Color3.fromRGB(40, 0, 0)
local RED_BG = Color3.fromRGB(0, 0, 0)
local RED_TITLE = Color3.fromRGB(20, 0, 0)

local function Notify(text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = HUB_NAME, Text = text, Duration = duration or 5})
    end)
end

-- БЕЗОПАСНАЯ ЗАГРУЗКА
local function SafeHttpGet(url)
    if typeof(syn) == "table" and syn.request then
        return syn.request({Url = url, Method = "GET"}).Body
    elseif typeof(http_request) == "function" then
        return http_request({Url = url, Method = "GET"}).Body
    elseif typeof(request) == "function" then
        return request({Url = url, Method = "GET"}).Body
    else
        return game:HttpGet(url)
    end
end

local function SafeLoadstring(url)
    local code = SafeHttpGet(url)
    return loadstring(code)()
end

-- ДЕТЕКТОР КИКА (Без BindToClose)
pcall(function() 
    if writefile then writefile("XyqwHub/Logs/session.txt", "active") end 
end)

-- СКРЫТЫЙ GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Chat_" .. math.random(100000, 999999)
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999

local success = pcall(function()
    screenGui.Parent = gethui()
end)
if not success or not screenGui.Parent then
    screenGui.Parent = CoreGui
end

-- DOCK КНОПКА
local dockButton = Instance.new("TextButton")
dockButton.Size = UDim2.new(0, 80, 0, 30)
dockButton.Position = UDim2.new(0.5, -40, 0.05, 42)
dockButton.BackgroundColor3 = RED_BG
dockButton.TextColor3 = RED_MAIN
dockButton.Text = "Xyqw"
dockButton.Font = Enum.Font.GothamBold
dockButton.TextSize = 14
dockButton.BorderSizePixel = 2
dockButton.BorderColor3 = RED_MAIN
dockButton.Visible = false
dockButton.Parent = screenGui

-- ГЛАВНОЕ ОКНО
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 340)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -170)
mainFrame.BackgroundColor3 = RED_BG
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = RED_MAIN
mainFrame.Active = true
mainFrame.Parent = screenGui

-- ФУНКЦИИ
local function OpenGui()
    if mainFrame.Visible then return end
    mainFrame.Visible = true
    dockButton.Visible = false
end

local function CloseGui()
    mainFrame.Visible = false
    dockButton.Visible = true
end

dockButton.MouseButton1Click:Connect(OpenGui)

-- ТАЙТЛ БАР
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = RED_TITLE
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "XyqwHub Extra | 00:00"
titleLabel.TextColor3 = RED_MAIN
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 12
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Кнопка COPY
local copyLogsBtn = Instance.new("TextButton")
copyLogsBtn.Size = UDim2.new(0, 50, 1, 0)
copyLogsBtn.Position = UDim2.new(1, -80, 0, 0)
copyLogsBtn.BackgroundColor3 = RED_DARK
copyLogsBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
copyLogsBtn.Text = "COPY"
copyLogsBtn.Font = Enum.Font.GothamBold
copyLogsBtn.TextSize = 10
copyLogsBtn.BorderSizePixel = 1
copyLogsBtn.BorderColor3 = RED_MAIN
copyLogsBtn.Parent = titleBar

copyLogsBtn.MouseButton1Click:Connect(function()
    local timePassed = math.floor(tick() - startTime)
    local report = "XyqwHub Extra survived for: " .. timePassed .. " seconds."
    pcall(function()
        setclipboard(report)
        copyLogsBtn.Text = "OK"
        Notify("Скопировано: " .. timePassed .. " сек.", 3)
    end)
end)

-- Кнопка X
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = RED_DARK
closeBtn.TextColor3 = RED_MAIN
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 1
closeBtn.BorderColor3 = RED_MAIN
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(CloseGui)

-- ТАЙМЕР
task.spawn(function()
    while screenGui.Parent do
        local timePassed = math.floor(tick() - startTime)
        local mins = math.floor(timePassed / 60)
        local secs = timePassed % 60
        titleLabel.Text = string.format("XyqwHub Extra | %02d:%02d", mins, secs)
        task.wait(1)
    end
end)

-- СКРОЛЛ
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -40)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 2000)
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = RED_MAIN
scroll.Parent = mainFrame

-- ПЕРЕТАСКИВАНИЕ (Main)
local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = mainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ПЕРЕТАСКИВАНИЕ (Dock)
local dockDragging, dockDragStart, dockStartPos, dockDragMoved = false, nil, nil, false
dockButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dockDragging = true; dockDragMoved = false
        dockDragStart = input.Position; dockStartPos = dockButton.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dockDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dockDragStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then dockDragMoved = true end
        if dockDragMoved then
            dockButton.Position = UDim2.new(dockStartPos.X.Scale, dockStartPos.X.Offset + delta.X, dockStartPos.Y.Scale, dockStartPos.Y.Offset + delta.Y)
        end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if dockDragging and not dockDragMoved then OpenGui() end
        dockDragging = false
    end
end)

-- РЕСАЙЗ
local resizeHandle = Instance.new("TextButton")
resizeHandle.Size = UDim2.new(0, 14, 0, 14)
resizeHandle.Position = UDim2.new(1, -14, 1, -14)
resizeHandle.BackgroundColor3 = RED_MAIN
resizeHandle.Text = ""
resizeHandle.BorderSizePixel = 0
resizeHandle.Parent = mainFrame
local resizing, rsStart, rsSize = false, nil, nil
resizeHandle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = true; rsStart = input.Position; rsSize = mainFrame.Size end end)
UserInputService.InputChanged:Connect(function(input) if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - rsStart; mainFrame.Size = UDim2.new(0, math.clamp(rsSize.X.Offset + delta.X, 250, 600), 0, math.clamp(rsSize.Y.Offset + delta.Y, 200, 600)) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end end)

-- СПИСОК СКРИПТОВ
local Scripts = {
    {Name = "PulseHub (Steal An Egg)", URL = "https://raw.githubusercontent.com/PulseZax/Loader/refs/heads/main/.lua"},
    {Name = "Moondiety (Steal An Egg)", URL = "https://moondiety.com/loader"},
    {Name = "Blade Ball (Rise)", URL = "https://raw.githubusercontent.com/joshhhie/rise/refs/heads/main/loader.lua"},
    {Name = "Infinite Yield", URL = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"}
}

local yPos = 5
for _, data in ipairs(Scripts) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = RED_BG
    btn.TextColor3 = RED_MAIN
    btn.Text = data.Name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 2
    btn.BorderColor3 = RED_MAIN
    btn.Parent = scroll
    yPos = yPos + 36
    
    btn.MouseButton1Click:Connect(function()
        btn.Text = "Loading..."
        btn.TextColor3 = Color3.fromRGB(255, 150, 0)
        task.spawn(function()
            local ok, err = pcall(function()
                SafeLoadstring(data.URL)
            end)
            if ok then
                btn.Text = data.Name .. " (OK)"
                btn.TextColor3 = Color3.fromRGB(0, 255, 100)
            else
                btn.Text = data.Name .. " (ERR)"
                btn.TextColor3 = RED_MAIN
            end
        end)
    end)
end

-- Кнопка Destroy (с удалением сессии)
local destroyBtn = Instance.new("TextButton")
destroyBtn.Size = UDim2.new(1, -10, 0, 32)
destroyBtn.Position = UDim2.new(0, 5, 0, yPos)
destroyBtn.BackgroundColor3 = RED_DARK
destroyBtn.TextColor3 = RED_MAIN
destroyBtn.Text = "Destroy XyqwHub"
destroyBtn.Font = Enum.Font.GothamBold
destroyBtn.TextSize = 14
destroyBtn.BorderSizePixel = 2
destroyBtn.BorderColor3 = RED_MAIN
destroyBtn.Parent = scroll
yPos = yPos + 36

destroyBtn.MouseButton1Click:Connect(function()
    ShowRobloxNotification("XyqwHub Destroyed!", 2)
    pcall(function() 
        if delfile then delfile("XyqwHub/Logs/session.txt") end 
    end)
    screenGui:Destroy()
end)

scroll.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

Notify("Extra Mode Loaded! Safe Shell Active.", 5)
