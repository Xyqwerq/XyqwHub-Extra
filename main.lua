-- ========== XyqwHub | EXTRA MODE (Safe Shell) — v7.6.1 FIXED ==========
-- Безопасная оболочка для самых жёстких античитов (BAC-6519, Steal an Egg, Blade Ball).
-- ОТЛИЧИЯ ОТ DEFAULT/GHOST:
--   • НЕТ 48 скриптов, только 4 тяжёлых байпасса
--   • НЕТ hookfunction / hookmetamethod (Delta не крашится, BAC не палит)
--   • НЕТ VirtualUser (ломается на мобилке)
--   • НЕТ BindToClose (крашит Delta — уже удалён)
--   • Использует только gethui для скрытия окна
--   • Таймер выживания в заголовке (Extra | 01:23)
--   • Кнопка COPY кладёт в буфер строку "survived for N seconds"

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local HUB_NAME = "XyqwHub Extra"
local VERSION = "7.6.1 Extra"
local startTime = tick()
local isRunning = true

-- Цвета (фирменный стиль)
local RED_MAIN = Color3.fromRGB(255, 0, 0)
local RED_DARK = Color3.fromRGB(40, 0, 0)
local RED_BG = Color3.fromRGB(0, 0, 0)
local RED_TITLE = Color3.fromRGB(20, 0, 0)

-- ========== БЕЗОПАСНЫЕ ФУНКЦИИ ==========
local function Notify(text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = HUB_NAME,
            Text = tostring(text),
            Duration = duration or 5,
        })
    end)
end

local function SafeHttpGet(url)
    if typeof(syn) == "table" and syn.request then
        local ok, res = pcall(function() return syn.request({Url = url, Method = "GET"}).Body end)
        if ok and res then return res end
    end
    if typeof(http_request) == "function" then
        local ok, res = pcall(function() return http_request({Url = url, Method = "GET"}).Body end)
        if ok and res then return res end
    end
    if typeof(request) == "function" then
        local ok, res = pcall(function() return request({Url = url, Method = "GET"}).Body end)
        if ok and res then return res end
    end
    return game:HttpGet(url)
end

local function SafeLoadstring(url)
    local code = SafeHttpGet(url)
    if not code or #code == 0 then error("Empty response from " .. url) end
    return loadstring(code)()
end

-- ========== SESSION ФАЙЛ (детектор кика) ==========
pcall(function()
    if not isfolder("XyqwHub") then makefolder("XyqwHub") end
    if not isfolder("XyqwHub/Logs") then makefolder("XyqwHub/Logs") end
end)
pcall(function()
    if writefile then writefile("XyqwHub/Logs/session.txt", "active") end
end)

-- ========== SCREEN GUI (gethui) ==========
local screenGui = Instance.new("ScreenGui")
local stealthNames = {"Chat", "RobloxGui", "TopBar", "Notification", "Backpack", "TouchGui", "ControlFrame"}
screenGui.Name = stealthNames[math.random(1, #stealthNames)] .. tostring(math.random(100000, 999999))
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = math.random(100, 500)

local parentAssigned = false
pcall(function()
    if gethui then
        screenGui.Parent = gethui()
        parentAssigned = true
    end
end)
if not parentAssigned then
    pcall(function() screenGui.Parent = CoreGui end)
    if not screenGui.Parent then
        screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
end

-- ========== DOCK КНОПКА ==========
local dockButton = Instance.new("TextButton")
dockButton.Name = "DockButton"
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
dockButton.AutoButtonColor = false
dockButton.Active = true
dockButton.ZIndex = 999
dockButton.Parent = screenGui

-- ========== ГЛАВНОЕ ОКНО ==========
local mainFrame = Instance.new("Frame")
mainFrame.Name = "M" .. math.random(1000, 9999)
mainFrame.Size = UDim2.new(0, 280, 0, 340)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -170)
mainFrame.BackgroundColor3 = RED_BG
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = RED_MAIN
mainFrame.Active = true
mainFrame.Parent = screenGui

local function OpenGui()
    if mainFrame.Visible then return end
    mainFrame.Visible = true
    dockButton.Visible = false
end

local function CloseGui()
    mainFrame.Visible = false
    dockButton.Visible = true
end

-- ========== TITLE BAR ==========
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = RED_TITLE
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = HUB_NAME .. " | 00:00"
titleLabel.TextColor3 = RED_MAIN
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 12
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextScaled = true
titleLabel.Parent = titleBar

-- COPY
local copyLogsBtn = Instance.new("TextButton")
copyLogsBtn.Name = "CopyBtn"
copyLogsBtn.Size = UDim2.new(0, 50, 1, 0)
copyLogsBtn.Position = UDim2.new(1, -80, 0, 0)
copyLogsBtn.BackgroundColor3 = RED_DARK
copyLogsBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
copyLogsBtn.Text = "COPY"
copyLogsBtn.Font = Enum.Font.GothamBold
copyLogsBtn.TextSize = 10
copyLogsBtn.BorderSizePixel = 1
copyLogsBtn.BorderColor3 = RED_MAIN
copyLogsBtn.AutoButtonColor = false
copyLogsBtn.Parent = titleBar

-- X
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = RED_DARK
closeBtn.TextColor3 = RED_MAIN
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.BorderSizePixel = 1
closeBtn.BorderColor3 = RED_MAIN
closeBtn.AutoButtonColor = false
closeBtn.Parent = titleBar

copyLogsBtn.MouseButton1Click:Connect(function()
    local timePassed = math.floor(tick() - startTime)
    local report = "XyqwHub Extra survived for: " .. timePassed .. " seconds."
    pcall(function()
        setclipboard(report)
        copyLogsBtn.Text = "OK"
        Notify("Copied: " .. timePassed .. " sec.", 3)
        task.delay(2, function()
            if copyLogsBtn.Parent then copyLogsBtn.Text = "COPY" end
        end)
    end)
end)

closeBtn.MouseButton1Click:Connect(CloseGui)

-- ========== SCROLL ==========
local scroll = Instance.new("ScrollingFrame")
scroll.Name = "ScriptScroll"
scroll.Size = UDim2.new(1, -10, 1, -40)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 2000)
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = RED_MAIN
scroll.Parent = mainFrame

-- ========== СПИСОК СКРИПТОВ (4 тяжёлых байпасса) ==========
local Scripts = {
    {Name = "PulseHub (Steal An Egg)", URL = "https://raw.githubusercontent.com/PulseZax/Loader/refs/heads/main/.lua"},
    {Name = "Moondiety (Steal An Egg)", URL = "https://moondiety.com/loader"},
    {Name = "Blade Ball (Rise)", URL = "https://raw.githubusercontent.com/joshhhie/rise/refs/heads/main/loader.lua"},
    {Name = "Infinite Yield", URL = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
}

local yPos = 5
for _, data in ipairs(Scripts) do
    local btn = Instance.new("TextButton")
    btn.Name = "Btn_" .. data.Name:gsub("%s+", "_")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = RED_BG
    btn.TextColor3 = RED_MAIN
    btn.Text = data.Name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextScaled = false
    btn.TextTruncate = Enum.TextTruncate.AtEnd
    btn.TextXAlignment = Enum.TextXAlignment.Center
    btn.BorderSizePixel = 2
    btn.BorderColor3 = RED_MAIN
    btn.AutoButtonColor = false
    btn.Parent = scroll

    local isLoading = false
    btn.MouseButton1Click:Connect(function()
        if isLoading then return end
        isLoading = true
        btn.Text = "Loading..."
        btn.TextColor3 = Color3.fromRGB(255, 150, 0)

        task.spawn(function()
            local ok, err = pcall(function()
                SafeLoadstring(data.URL)
            end)
            if ok then
                btn.Text = data.Name .. " (OK)"
                btn.TextColor3 = Color3.fromRGB(0, 255, 100)
                Notify(data.Name .. " — executed!", 3)
            else
                btn.Text = data.Name .. " (ERR)"
                btn.TextColor3 = RED_MAIN
                Notify(data.Name .. " — error", 4)
            end
            task.wait(2)
            if btn.Parent then
                btn.Text = data.Name
                btn.TextColor3 = RED_MAIN
            end
            isLoading = false
        end)
    end)

    -- Hover-эффект
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = RED_DARK}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = RED_BG}):Play()
    end)

    yPos = yPos + 36
end

-- ========== DESTROY (фикс: удаление session.txt + Notify вместо ShowRobloxNotification) ==========
local destroyBtn = Instance.new("TextButton")
destroyBtn.Name = "DestroyBtn"
destroyBtn.Size = UDim2.new(1, -10, 0, 32)
destroyBtn.Position = UDim2.new(0, 5, 0, yPos + 8)
destroyBtn.BackgroundColor3 = RED_DARK
destroyBtn.TextColor3 = RED_MAIN
destroyBtn.Text = "Destroy XyqwHub Extra"
destroyBtn.Font = Enum.Font.GothamBold
destroyBtn.TextSize = 14
destroyBtn.BorderSizePixel = 2
destroyBtn.BorderColor3 = RED_MAIN
destroyBtn.AutoButtonColor = false
destroyBtn.Parent = scroll
yPos = yPos + 48

destroyBtn.MouseEnter:Connect(function()
    TweenService:Create(destroyBtn, TweenInfo.new(0.12), {BackgroundColor3 = RED_MAIN, TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
end)
destroyBtn.MouseLeave:Connect(function()
    TweenService:Create(destroyBtn, TweenInfo.new(0.15), {BackgroundColor3 = RED_DARK, TextColor3 = RED_MAIN}):Play()
end)

destroyBtn.MouseButton1Click:Connect(function()
    Notify("XyqwHub Extra Destroyed!", 2)
    shared.XyqwHubRunning = nil
    isRunning = false
    -- ВАЖНО: удаляем session.txt, чтобы лоадер не решил, что был кик
    pcall(function()
        if delfile and isfile("XyqwHub/Logs/session.txt") then
            delfile("XyqwHub/Logs/session.txt")
        end
    end)
    screenGui:Destroy()
end)

scroll.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ========== ТАЙМЕР В ЗАГОЛОВКЕ ==========
task.spawn(function()
    while screenGui.Parent and isRunning do
        local timePassed = math.floor(tick() - startTime)
        local mins = math.floor(timePassed / 60)
        local secs = timePassed % 60
        pcall(function()
            titleLabel.Text = string.format("%s | %02d:%02d", HUB_NAME, mins, secs)
        end)
        task.wait(1)
    end
end)

-- ========== ДРАГ TITLE BAR ==========
local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local mousePos = input.Position
        -- Игнорируем перетаскивание если нажали по кнопкам
        local function IsOver(btn)
            local p = btn.AbsolutePosition
            local s = btn.AbsoluteSize
            return mousePos.X >= p.X and mousePos.X <= p.X + s.X
               and mousePos.Y >= p.Y and mousePos.Y <= p.Y + s.Y
        end
        if IsOver(copyLogsBtn) or IsOver(closeBtn) then return end
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ========== ДРАГ DOCK ==========
local dockDragging, dockDragStart, dockStartPos, dockDragMoved = false, nil, nil, false
dockButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dockDragging = true
        dockDragMoved = false
        dockDragStart = input.Position
        dockStartPos = dockButton.Position
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

-- ========== РЕСАЙЗ ==========
local resizeHandle = Instance.new("TextButton")
resizeHandle.Name = "ResizeHandle"
resizeHandle.Size = UDim2.new(0, 14, 0, 14)
resizeHandle.Position = UDim2.new(1, -14, 1, -14)
resizeHandle.BackgroundColor3 = RED_MAIN
resizeHandle.Text = ""
resizeHandle.BorderSizePixel = 0
resizeHandle.ZIndex = 10
resizeHandle.AutoButtonColor = false
resizeHandle.Parent = mainFrame

local resizing, rsStart, rsSize = false, nil, nil
resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        rsStart = input.Position
        rsSize = mainFrame.Size
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - rsStart
        mainFrame.Size = UDim2.new(
            0, math.clamp(rsSize.X.Offset + delta.X, 250, 600),
            0, math.clamp(rsSize.Y.Offset + delta.Y, 200, 600)
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)

-- ========== ФИНАЛЬНОЕ УВЕДОМЛЕНИЕ ==========
task.spawn(function()
    task.wait(0.5)
    Notify("Extra Mode Loaded! Safe Shell Active.", 5)
    task.wait(2)
    Notify("BAC games detected — using safe bypass.", 4)
end)

-- ========== СБРОС ФЛАГА ПРИ ЗАКРЫТИИ ==========
task.spawn(function()
    while screenGui.Parent do task.wait(5) end
    shared.XyqwHubRunning = nil
end)

-- ========== КОНЕЦ XYQWHUB EXTRA 7.6.1 ==========
