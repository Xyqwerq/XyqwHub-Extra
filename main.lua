-- ========== XyqwHub | EXTRA MODE - Версия 1.0 ==========
-- Специализированный хаб для игр со сложными античитами (BAC, Steal an Egg).
-- Включает таймер выживания и Safe Black Box (Ghost Hook).

pcall(function() 
    if delfile and isfile("XyqwHub/Logs/latestlog.txt") then 
        delfile("XyqwHub/Logs/latestlog.txt") 
    end 
end)

local function _s(...) return string.char(...) end
local HUB_NAME = "XyqwHub Extra"
local VERSION = "1.0"
local OWNER_IDS = {4396977722, 8527910367}
local BETA_IDS = {9686718765, 3701387385}

local IS_RELAUNCH = (shared.XyqwHubRunning == true)
if IS_RELAUNCH then
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title = HUB_NAME, Text = "Already running", Duration = 3}) end)
    return
end
shared.XyqwHubRunning = true

local _settings = {}
local function GetSetting(key, default) if _settings[key] == nil then return default end return _settings[key] end
local function SetSetting(key, value) _settings[key] = value end

local LANG_CODE = GetSetting("lang", "EN")
local THEME_NAME = GetSetting("theme", "Red")
local TOPBAR_HIDDEN = GetSetting("topbar", false)
local FAVORITES = GetSetting("fav", {})
local RECENT = GetSetting("recent", {})
local AUTOEXEC = GetSetting("autoexec", {})
local ORDER = GetSetting("order", {})
local ANTI_KICK_MESSAGES = GetSetting("akmsg", true)
local ANTI_KICK_LOGS = {}

local CONFIG_FOLDER = "XyqwHub"
local FAV_FILE = CONFIG_FOLDER .. "/FavScripts/favorites.json"
local RCT_FILE = CONFIG_FOLDER .. "/RctScripts/recent.json"
local CUSTOM_COLOR_FILE = CONFIG_FOLDER .. "/CustomColor/custom_color.json"
local AUTOEXEC_FILE = CONFIG_FOLDER .. "/AutoExecute/autoexec.json"
local SETTINGS_FILE = CONFIG_FOLDER .. "/Settings/settings.json"
local ORDER_FILE = CONFIG_FOLDER .. "/Settings/order.json"
local SESSION_FILE = CONFIG_FOLDER .. "/Session/last_jobid.txt"
local XYQWHUB_URL = "https://raw.githubusercontent.com/Xyqwerq/XyqwHub-Extra/main/main.lua"

pcall(function()
    if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
    if not isfolder(CONFIG_FOLDER .. "/FavScripts") then makefolder(CONFIG_FOLDER .. "/FavScripts") end
    if not isfolder(CONFIG_FOLDER .. "/RctScripts") then makefolder(CONFIG_FOLDER .. "/RctScripts") end
    if not isfolder(CONFIG_FOLDER .. "/CustomColor") then makefolder(CONFIG_FOLDER .. "/CustomColor") end
    if not isfolder(CONFIG_FOLDER .. "/AutoExecute") then makefolder(CONFIG_FOLDER .. "/AutoExecute") end
    if not isfolder(CONFIG_FOLDER .. "/Settings") then makefolder(CONFIG_FOLDER .. "/Settings") end
    if not isfolder(CONFIG_FOLDER .. "/Session") then makefolder(CONFIG_FOLDER .. "/Session") end
end)

local function SaveTable(path, tbl) pcall(function() if writefile then writefile(path, game:GetService("HttpService"):JSONEncode(tbl)) end end) end
local function LoadTable(path)
    local ok, data = pcall(function()
        if readfile and isfile and isfile(path) then return game:GetService("HttpService"):JSONDecode(readfile(path)) end
        return nil
    end)
    if ok and type(data) == "table" then return data end
    return {}
end

FAVORITES = LoadTable(FAV_FILE)
RECENT = LoadTable(RCT_FILE)
AUTOEXEC = LoadTable(AUTOEXEC_FILE)
ORDER = LoadTable(ORDER_FILE)

pcall(function()
    if writefile and game.JobId and game.JobId ~= "" then writefile(SESSION_FILE, game.JobId) end
end)

local THEMES = {
    Red = {MAIN = Color3.fromRGB(255, 0, 0), DARK = Color3.fromRGB(40, 0, 0), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(20, 0, 0)},
    Blue = {MAIN = Color3.fromRGB(0, 140, 255), DARK = Color3.fromRGB(0, 20, 50), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(0, 10, 25)},
    Green = {MAIN = Color3.fromRGB(0, 220, 90), DARK = Color3.fromRGB(0, 40, 15), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(0, 20, 8)},
    Purple = {MAIN = Color3.fromRGB(180, 0, 255), DARK = Color3.fromRGB(30, 0, 45), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(15, 0, 22)},
    Pink = {MAIN = Color3.fromRGB(255, 20, 147), DARK = Color3.fromRGB(45, 0, 25), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(22, 0, 12)},
    Orange = {MAIN = Color3.fromRGB(255, 140, 0), DARK = Color3.fromRGB(45, 25, 0), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(22, 12, 0)},
    Cyan = {MAIN = Color3.fromRGB(0, 255, 255), DARK = Color3.fromRGB(0, 40, 40), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(0, 20, 20)},
    Yellow = {MAIN = Color3.fromRGB(255, 230, 0), DARK = Color3.fromRGB(45, 40, 0), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(22, 20, 0)},
    Lime = {MAIN = Color3.fromRGB(50, 255, 50), DARK = Color3.fromRGB(0, 45, 0), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(0, 22, 0)},
    Magenta = {MAIN = Color3.fromRGB(255, 0, 255), DARK = Color3.fromRGB(45, 0, 45), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(22, 0, 22)},
    White = {MAIN = Color3.fromRGB(255, 255, 255), DARK = Color3.fromRGB(40, 40, 40), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(20, 20, 20)},
    Rainbow = {MAIN = Color3.fromRGB(255, 0, 0), DARK = Color3.fromRGB(40, 0, 40), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(20, 0, 20)},
    Custom = {MAIN = Color3.fromRGB(255, 0, 0), DARK = Color3.fromRGB(40, 0, 0), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(20, 0, 0)},
}

local currentTheme = THEMES[THEME_NAME] or THEMES.Red
if not THEMES[THEME_NAME] then THEME_NAME = "Red" end
local RED_MAIN = currentTheme.MAIN
local RED_DARK = currentTheme.DARK
local RED_BG = currentTheme.BG
local RED_TITLE = currentTheme.TITLE
local URL_OK = Color3.fromRGB(0, 255, 100)
local URL_BAD = Color3.fromRGB(255, 50, 50)
local URL_UNKNOWN = Color3.fromRGB(150, 150, 150)
local URL_CHECKING = Color3.fromRGB(255, 200, 0)

local LANG = {}
LANG.EN = {
    Loaded = "loaded", Error = "error", Search = "Search...", CustomPlaceholder = "Paste URL...",
    RunCustom = "Run", JobIdCopied = "JobId copied!", ScriptExecuted = "Script executed!",
    OwnerWelcome = "Welcome, my father :3", BetaWelcome = "Glad you're here, tester <3",
    TagRemoved = "Tag removed!", LangChanged = "Language changed to English",
    FavShared = "Favorites shared!", RctShared = "Recent shared!", LoadstringCopied = "Loadstring copied!",
    ColorReset = "Color reset", ColorShared = "Color copied!", AutoExecOn = "Auto-Execute: ON", AutoExecOff = "Auto-Execute: OFF",
    KeybindChanged = "Auto-Hide keybind: ", UrlCheckStarted = "Testing URLs...", UrlCheckDone = "URL test complete!",
    WelcomeTitle = "Welcome to XyqwHub Extra!", ClickXToClose = "Click X to close", PlayersTitle = "Players", ServerTitle = "Server Info",
    CustomTitle = "Custom Script", CustomColorTitle = "Custom Color", ChangeLogTitle = "ChangeLog",
    SettingsTitle = "Settings", Apply = "Apply", Reset = "Reset", ShareColor = "Share Color",
    CopyJobId = "Copy JobId", Rejoin = "Rejoin", ServerHop = "ServerHop", TPToSmall = "TP to Small",
    RemoveTags = "Remove Tags", ShareFav = "Share Favorite Scripts", ShareRct = "Share Recent Scripts",
    TestURLs = "Test URLs", SettingsBtn = "Settings", Destroy = "Destroy XyqwHub", ResetOrder = "Reset Order",
    PlaceId = "PlaceId", JobId = "JobId", Players = "Players", Creator = "Creator",
    Presets = "Presets", AutoHideBind = "Auto-Hide keybind:", ShareHub = "Share XyqwHub",
    HideTopBar = "Hide Top Bar", HideTopBarOn = "Hide Top Bar: ON", HideTopBarOff = "Hide Top Bar: OFF",
    OrderSaved = "Order saved!", OrderReset = "Order reset!", AntiKickOn = "AntiKick: ON", AntiKickOff = "AntiKick: OFF",
    AutoReinjectOn = "Auto-Reinject: ON", AutoReinjectOff = "Auto-Reinject: OFF",
    ReinjectQueued = "XyqwHub will reload after teleport", ReinjectNotSupported = "Auto-Reinject not supported",
    ExecutorInfoTitle = "Executor Info", RunUNCTest = "Run UNC Test", RunSUNCTest = "Run sUNC Test",
    Testing = "Testing...", TestResult = "Result", RejoinLastSession = "Rejoin Last Session",
    ChangeLogText = [[XyqwHub Extra ChangeLog
========================================
Version 1.0 (EXTRA MODE)
========================================
- Специализированный хаб для BAC-6519.
- Встроен таймер выживания.
- Интегрирован Safe Black Box (без крашей).
- Добавлены: PulseHub и Moondiety (Bypass).
XyqwHub Extra 1.0]],
}
LANG.RU = {
    Loaded = "загружен", Error = "ошибка", Search = "Поиск...", CustomPlaceholder = "Ссылка...",
    RunCustom = "Запустить", JobIdCopied = "JobId скопирован!", ScriptExecuted = "Скрипт выполнен!",
    OwnerWelcome = "Welcome, my father :3", BetaWelcome = "Glad you're here, tester <3",
    TagRemoved = "Тег убран!", LangChanged = "Язык изменён на Русский",
    FavShared = "Избранное скопировано!", RctShared = "Недавние скопированы!",
    LoadstringCopied = "Loadstring скопирован!", ColorReset = "Цвет сброшен", ColorShared = "Цвет скопирован!",
    AutoExecOn = "Авто-запуск: ВКЛ", AutoExecOff = "Авто-запуск: ВЫКЛ",
    KeybindChanged = "Бинд Auto-Hide: ", UrlCheckStarted = "Проверка URL...", UrlCheckDone = "Проверка завершена!",
    WelcomeTitle = "Добро пожаловать в XyqwHub Extra!", ClickXToClose = "Нажми X чтобы закрыть",
    PlayersTitle = "Игроки", ServerTitle = "Инфо о сервере", CustomTitle = "Свой скрипт",
    CustomColorTitle = "Свой цвет", ChangeLogTitle = "Ченджлог", SettingsTitle = "Настройки",
    Apply = "Применить", Reset = "Сбросить", ShareColor = "Поделиться цветом",
    CopyJobId = "Копировать JobId", Rejoin = "Перезайти", ServerHop = "Сменить сервер", TPToSmall = "ТП в маленький",
    RemoveTags = "Убрать теги", ShareFav = "Поделиться избранным", ShareRct = "Поделиться недавними",
    TestURLs = "Проверить URL", SettingsBtn = "Настройки", Destroy = "Удалить XyqwHub", ResetOrder = "Сбросить порядок",
    PlaceId = "PlaceId", JobId = "JobId", Players = "Игроки", Creator = "Создатель",
    Presets = "Пресеты", AutoHideBind = "Бинд Auto-Hide:", ShareHub = "Поделиться XyqwHub",
    HideTopBar = "Скрыть топ бар", HideTopBarOn = "Скрыть: ВКЛ", HideTopBarOff = "Скрыть: ВЫКЛ",
    OrderSaved = "Порядок сохранён!", OrderReset = "Порядок сброшен!", AntiKickOn = "AntiKick: ВКЛ", AntiKickOff = "AntiKick: ВЫКЛ",
    AutoReinjectOn = "Auto-Reinject: ВКЛ", AutoReinjectOff = "Auto-Reinject: ВЫКЛ",
    ReinjectQueued = "XyqwHub перезагрузится после телепорта", ReinjectNotSupported = "Auto-Reinject не поддерживается",
    ExecutorInfoTitle = "Инфо об экзекьюторе", RunUNCTest = "Запустить UNC тест", RunSUNCTest = "Запустить sUNC тест",
    Testing = "Тестирование...", TestResult = "Результат", RejoinLastSession = "Rejoin Last Session",
    ChangeLogText = [[XyqwHub Extra Ченджлог
========================================
Версия 1.0 (EXTRA MODE)
========================================
- Специализированный хаб для BAC-6519.
- Встроен таймер выживания.
- Интегрирован Safe Black Box (без крашей).
- Добавлены: PulseHub и Moondiety (Bypass).
XyqwHub Extra 1.0]],
}

for _, lang in ipairs({"UK", "BE", "KK"}) do
    LANG[lang] = LANG[lang] or {}
    for k, v in pairs(LANG.EN) do if not LANG[lang][k] then LANG[lang][k] = v end end
end

local function _(key) return LANG[LANG_CODE] and LANG[LANG_CODE][key] or LANG.EN[key] or key end
local function ShowRobloxNotification(text, duration)
    duration = duration or 4
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title = HUB_NAME, Text = tostring(text), Duration = duration}) end)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local function QueueReinject()
    if not GetSetting("autoreinject", true) then return false end
    local restoreCode = 'task.wait(3)\nif rawget(_G, "XyqwHubRunning") then rawset(_G, "XyqwHubRunning", nil) end\nloadstring(game:HttpGet("' .. XYQWHUB_URL .. '"))()'
    local queued = false
    pcall(function() if typeof(queue_on_teleport) == "function" then queue_on_teleport(restoreCode); queued=true end end)
    if queued then ShowRobloxNotification(_("ReinjectQueued"), 3) end
    return queued
end

local heartbeatTasks, renderTasks = {}, {}
local heartbeatConnection, renderConnection = nil, nil
local function AddHeartbeatTask(fn)
    table.insert(heartbeatTasks, fn)
    if not heartbeatConnection then heartbeatConnection = RunService.Heartbeat:Connect(function(dt) for _, task in ipairs(heartbeatTasks) do pcall(task, dt) end end) end
end
local function AddRenderTask(fn)
    table.insert(renderTasks, fn)
    if not renderConnection then renderConnection = RunService.RenderStepped:Connect(function(dt) for _, task in ipairs(renderTasks) do pcall(task, dt) end end) end
end

local function MakeResizable(frame, minW, minH, maxW, maxH)
    minW, minH, maxW, maxH = minW or 200, minH or 150, maxW or 900, maxH or 1000
    local handle = Instance.new("TextButton")
    handle.Name = "R" .. math.random(100, 999)
    handle.Size = UDim2.new(0, 12, 0, 12); handle.Position = UDim2.new(1, -12, 1, -12)
    handle.BackgroundColor3 = RED_MAIN; handle.Text = ""; handle.BorderSizePixel = 0; handle.ZIndex = 200; handle.Parent = frame; handle.AutoButtonColor = false
    local resizing, rsStart, rsSize = false, nil, nil
    handle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = true; rsStart = input.Position; rsSize = frame.Size end end)
    UserInputService.InputChanged:Connect(function(input) if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - rsStart; frame.Size = UDim2.new(0, math.clamp(rsSize.X.Offset + delta.X, minW, maxW), 0, math.clamp(rsSize.Y.Offset + delta.Y, minH, maxH)) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end end)
end

local function MakeDraggable(frame, dragPart)
    dragPart = dragPart or frame
    local dragging, dragStart, startPos = false, nil, nil
    dragPart.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = frame.Position end end)
    dragPart.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
end

-- ========== XYQWHUB-EXTRA (v1.0) — ЧАСТЬ 2/3 ==========

-- Таймер для Extra Mode
local startTime = tick()

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

-- Список скриптов (с добавленными байпассами)
local JJS_URL = "https://raw.githubusercontent.com/Xyqwerq/JJS-SCRIPT/main/jjs_script.lua"
local SCRIPTS = {
    {Name = "PulseHub (Steal An Egg)", Category = "Misc", URL = "https://raw.githubusercontent.com/PulseZax/Loader/refs/heads/main/.lua"},
    {Name = "Moondiety (Steal An Egg)", Category = "Misc", URL = "https://moondiety.com/loader"},
    {Name = "Infinite Yield", Category = "Misc", URL = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
    {Name = "Blade Ball", Category = "BB", URL = "https://raw.githubusercontent.com/joshhhie/rise/refs/heads/main/loader.lua"},
    {Name = "Blade Ball 2", Category = "BB", URL = "https://wings.ac/loader"},
    {Name = "AntiKillParts", Category = "Misc", URL = "https://raw.githubusercontent.com/sovetskii-shashlik/Anti-kill-parts-updated-/refs/heads/main/Anti%20kill%20parts%20by%20Zephyr"},
    {Name = "RUNAWAYS", Category = "Misc", URL = "https://raw.githubusercontent.com/Bac0nHck/Scripts/refs/heads/main/RUNAWAYS.lua"},
    {Name = "UwU hub", Category = "INK", URL = "https://raw.githubusercontent.com/platinww/UwU/refs/heads/main/INK-GAME"},
    {Name = "RuzHub (MM2)", Category = "MM2", URL = "https://raw.githubusercontent.com/pruzgar242-rgb/Update/refs/heads/main/out.lua%20(17).txt"},
    {Name = "Kiti (MM2)", Category = "MM2", URL = "https://pastefy.app/gPuS4n3Q/raw"},
    {Name = "Doors V2 (Copy)", Category = "Misc", URL = "SPECIAL_COPY_DOORS_V2"},
    {Name = "Doors v4", Category = "Misc", URL = "https://raw.githubusercontent.com/sillyleo67/Doors/refs/heads/main/Twinkhook.lua"},
}

-- ========== ТЕГИ ==========
local function IsOwner() for _, id in ipairs(OWNER_IDS) do if Players.LocalPlayer.UserId == id then return true end end return false end
local function IsBeta() for _, id in ipairs(BETA_IDS) do if Players.LocalPlayer.UserId == id then return true end end return false end

local tagsEnabled = true
local activeTags = {}
local function GetRole(plr)
    for _, id in ipairs(OWNER_IDS) do if plr.UserId == id then return "OWNER" end end
    for _, id in ipairs(BETA_IDS) do if plr.UserId == id then return "TESTER" end end
    return nil
end

local function CreateTagForPlayer(plr)
    if not tagsEnabled then return end
    local role = GetRole(plr)
    if not role then return end
    if activeTags[plr] and activeTags[plr].Parent then return end
    local char = plr.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "T" .. math.random(1000, 9999)
    billboard.Size = UDim2.new(0, 160, 0, 20); billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true; billboard.LightInfluence = 0; billboard.MaxDistance = 500; billboard.Adornee = rootPart; billboard.Parent = char
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 0, 18); label.Position = UDim2.new(0.5, -75, 0.5, -9)
    label.BackgroundTransparency = 1; label.Font = Enum.Font.GothamBold; label.TextSize = 14
    label.TextStrokeTransparency = 0; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); label.Parent = billboard
    local gradient = Instance.new("UIGradient")
    if role == "OWNER" then
        label.Text = HUB_NAME .. " OWNER"
        gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 0, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))})
    else
        label.Text = HUB_NAME .. " Tester"
        gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 120, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 20, 60)), ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 120, 255))})
    end
    gradient.Parent = label
    local glow = Instance.new("UIStroke")
    glow.Color = role == "OWNER" and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 120, 255)
    glow.Thickness = 1; glow.Transparency = 0.3; glow.Parent = label
    task.spawn(function()
        local rotation = 0
        while label.Parent and tagsEnabled do rotation = (rotation + 2) % 360; gradient.Rotation = rotation; task.wait(0.03) end
    end)
    activeTags[plr] = billboard
end

local function RemoveTagForPlayer(plr) if activeTags[plr] then activeTags[plr]:Destroy() activeTags[plr] = nil end end
local function RemoveAllTags()
    tagsEnabled = false
    for plr, tag in pairs(activeTags) do if tag and tag.Parent then tag:Destroy() end end
    activeTags = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char then
            for _, child in ipairs(char:GetChildren()) do if child.Name:sub(1,1) == "T" and child:IsA("BillboardGui") then child:Destroy() end end
        end
    end
end
local function CheckAllPlayers()
    if not tagsEnabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do if GetRole(plr) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then CreateTagForPlayer(plr) end end
end
local function SetupCharacterTag(plr)
    task.spawn(function()
        local char = plr.Character or plr.CharacterAdded:Wait()
        local rootPart = char:WaitForChild("HumanoidRootPart", 5)
        if not rootPart then return end
        activeTags[plr] = nil; task.wait(0.5)
        if GetRole(plr) and tagsEnabled then CreateTagForPlayer(plr) end
    end)
end

CheckAllPlayers()
AddHeartbeatTask(CheckAllPlayers)
Players.PlayerAdded:Connect(function(plr) SetupCharacterTag(plr); plr.CharacterAdded:Connect(function() SetupCharacterTag(plr) end) end)
Players.PlayerRemoving:Connect(RemoveTagForPlayer)
for _, plr in ipairs(Players:GetPlayers()) do SetupCharacterTag(plr); plr.CharacterAdded:Connect(function() SetupCharacterTag(plr) end) end

local VirtualUser = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)

local fpsValue = 60
local fpsCounter, fpsTime = 0, 0
AddRenderTask(function(dt) fpsCounter = fpsCounter + 1; fpsTime = fpsTime + dt; if fpsTime >= 1 then fpsValue = fpsCounter; fpsCounter = 0; fpsTime = 0 end end)

local function GetPing() local ok, ping = pcall(function() return math.floor(Players.LocalPlayer:GetNetworkPing() * 1000) end); return ok and ping or 0 end
local function GetExecutorName() local ok, name = pcall(function() if identifyexecutor then return identifyexecutor() end return "Unknown" end); return ok and name or "Unknown" end

-- ========== EXTRA SCREEN GUI (Скрытый) ==========
local screenGui = Instance.new("ScreenGui")
local stealthNames = {"Chat", "RobloxGui", "TopBar", "Notification", "LoadingScreen", "Backpack", "PlayerList", "CoreGui", "RobloxLoadingScreen", "TouchGui", "ControlFrame"}
screenGui.Name = stealthNames[math.random(1, #stealthNames)] .. tostring(math.random(100000, 999999))
screenGui.ResetOnSpawn = false; screenGui.IgnoreGuiInset = true; screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; screenGui.DisplayOrder = math.random(100, 500)

local parentAssigned = false
pcall(function()
    if gethui then screenGui.Parent = gethui(); parentAssigned = true end
end)
if not parentAssigned then
    if syn and syn.protect_gui then syn.protect_gui(screenGui); screenGui.Parent = CoreGui; parentAssigned = true
    elseif protect_gui then protect_gui(screenGui); screenGui.Parent = CoreGui; parentAssigned = true
    else pcall(function() screenGui.Parent = CoreGui end); if not screenGui.Parent then screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end end
end

task.spawn(function() while screenGui.Parent do screenGui.Name = stealthNames[math.random(1, #stealthNames)] .. tostring(math.random(100000, 999999)); task.wait(2 + math.random() * 2) end end)

local globalDrag = false
local topBar = Instance.new("TextButton")
topBar.Name = "TopBar"; topBar.Size = UDim2.new(0, 420, 0, 24); topBar.Position = UDim2.new(0.5, -210, 0, 10)
topBar.BackgroundColor3 = RED_BG; topBar.BorderSizePixel = 2; topBar.BorderColor3 = RED_MAIN; topBar.Text = ""; topBar.AutoButtonColor = false; topBar.Active = true; topBar.Parent = screenGui

local topBarText = Instance.new("TextLabel")
topBarText.Size = UDim2.new(1, -150, 1, 0); topBarText.Position = UDim2.new(0, 5, 0, 0); topBarText.BackgroundTransparency = 1
topBarText.Font = Enum.Font.GothamBold; topBarText.TextSize = 12; topBarText.TextColor3 = RED_MAIN; topBarText.TextXAlignment = Enum.TextXAlignment.Left; topBarText.Text = "..."; topBarText.Parent = topBar

-- ТАЙМЕР В ТОП-БАРЕ
local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(0, 80, 1, 0); timerLabel.Position = UDim2.new(1, -125, 0, 0)
timerLabel.BackgroundTransparency = 1; timerLabel.Font = Enum.Font.GothamBold; timerLabel.TextSize = 12
timerLabel.TextColor3 = Color3.fromRGB(0, 255, 100); timerLabel.Text = "TIME: 00:00"; timerLabel.Parent = topBar

task.spawn(function()
    while topBarText.Parent do 
        local timePassed = math.floor(tick() - startTime)
        local mins = math.floor(timePassed / 60)
        local secs = timePassed % 60
        topBarText.Text = string.format("%s | %s | FPS: %d | Ping: %d ms", GetExecutorName(), Players.LocalPlayer.Name, fpsValue, GetPing())
        timerLabel.Text = string.format("TIME: %02d:%02d", mins, secs)
        task.wait(1) 
    end 
end)

-- ========== XYQWHUB-EXTRA (v1.0) — ЧАСТЬ 3/3 ==========

-- СПЕЦ-КНОПКИ ВНИЗУ
local removeTagsContainer = Instance.new("Frame")
removeTagsContainer.Size = UDim2.new(1, -10, 0, 32); removeTagsContainer.Position = UDim2.new(0, 5, 0, 0)
removeTagsContainer.BackgroundColor3 = RED_BG; removeTagsContainer.BorderSizePixel = 2; removeTagsContainer.BorderColor3 = RED_MAIN; removeTagsContainer.Parent = scrollFrame; removeTagsContainer.Visible = false

local removeTagsBtn = Instance.new("TextButton")
removeTagsBtn.Size = UDim2.new(1, 0, 1, 0); removeTagsBtn.BackgroundTransparency = 1; removeTagsBtn.Text = _("RemoveTags")
removeTagsBtn.TextColor3 = RED_MAIN; removeTagsBtn.TextScaled = true; removeTagsBtn.Font = Enum.Font.GothamBold; removeTagsBtn.Parent = removeTagsContainer; removeTagsBtn.AutoButtonColor = false
removeTagsBtn.MouseEnter:Connect(function() TweenColor(removeTagsContainer, "BackgroundColor3", RED_DARK, 0.12) end)
removeTagsBtn.MouseLeave:Connect(function() TweenColor(removeTagsContainer, "BackgroundColor3", RED_BG, 0.15) end)
removeTagsBtn.MouseButton1Click:Connect(function() RemoveAllTags(); ShowRobloxNotification(_("TagRemoved"), 3) end)

local shareFavContainer = Instance.new("Frame")
shareFavContainer.Size = UDim2.new(1, -10, 0, 32); shareFavContainer.Position = UDim2.new(0, 5, 0, 0)
shareFavContainer.BackgroundColor3 = RED_BG; shareFavContainer.BorderSizePixel = 2; shareFavContainer.BorderColor3 = RED_MAIN; shareFavContainer.Parent = scrollFrame; shareFavContainer.Visible = false

local shareFavBtn = Instance.new("TextButton")
shareFavBtn.Size = UDim2.new(1, 0, 1, 0); shareFavBtn.BackgroundTransparency = 1; shareFavBtn.Text = _("ShareFav")
shareFavBtn.TextColor3 = RED_MAIN; shareFavBtn.TextScaled = true; shareFavBtn.Font = Enum.Font.GothamBold; shareFavBtn.Parent = shareFavContainer; shareFavBtn.AutoButtonColor = false
shareFavBtn.MouseEnter:Connect(function() TweenColor(shareFavContainer, "BackgroundColor3", RED_DARK, 0.12) end)
shareFavBtn.MouseLeave:Connect(function() TweenColor(shareFavContainer, "BackgroundColor3", RED_BG, 0.15) end)
shareFavBtn.MouseButton1Click:Connect(function()
    local list = {}; for name, _ in pairs(FAVORITES) do table.insert(list, name) end; table.sort(list)
    local text = HUB_NAME .. " - My Favorite Scripts:\n"
    if #list == 0 then text = text .. "(empty)" else for i, name in ipairs(list) do text = text .. i .. ". " .. name .. "\n" end end
    text = text .. "\nGenerated by " .. HUB_NAME .. " " .. VERSION; pcall(function() setclipboard(text) end); ShowRobloxNotification(_("FavShared"), 3)
end)

local shareRctContainer = Instance.new("Frame")
shareRctContainer.Size = UDim2.new(1, -10, 0, 32); shareRctContainer.Position = UDim2.new(0, 5, 0, 0)
shareRctContainer.BackgroundColor3 = RED_BG; shareRctContainer.BorderSizePixel = 2; shareRctContainer.BorderColor3 = RED_MAIN; shareRctContainer.Parent = scrollFrame; shareRctContainer.Visible = false

local shareRctBtn = Instance.new("TextButton")
shareRctBtn.Size = UDim2.new(1, 0, 1, 0); shareRctBtn.BackgroundTransparency = 1; shareRctBtn.Text = _("ShareRct")
shareRctBtn.TextColor3 = RED_MAIN; shareRctBtn.TextScaled = true; shareRctBtn.Font = Enum.Font.GothamBold; shareRctBtn.Parent = shareRctContainer; shareRctBtn.AutoButtonColor = false
shareRctBtn.MouseEnter:Connect(function() TweenColor(shareRctContainer, "BackgroundColor3", RED_DARK, 0.12) end)
shareRctBtn.MouseLeave:Connect(function() TweenColor(shareRctContainer, "BackgroundColor3", RED_BG, 0.15) end)
shareRctBtn.MouseButton1Click:Connect(function()
    local text = HUB_NAME .. " - My Recent Scripts:\n"
    if #RECENT == 0 then text = text .. "(empty)" else for i, name in ipairs(RECENT) do text = text .. i .. ". " .. name .. "\n" end end
    text = text .. "\nGenerated by " .. HUB_NAME .. " " .. VERSION; pcall(function() setclipboard(text) end); ShowRobloxNotification(_("RctShared"), 3)
end)

local urlTestContainer = Instance.new("Frame")
urlTestContainer.Size = UDim2.new(1, -10, 0, 32); urlTestContainer.Position = UDim2.new(0, 5, 0, 0)
urlTestContainer.BackgroundColor3 = RED_BG; urlTestContainer.BorderSizePixel = 2; urlTestContainer.BorderColor3 = RED_MAIN; urlTestContainer.Parent = scrollFrame; urlTestContainer.Visible = false

local urlTestBtn = Instance.new("TextButton")
urlTestBtn.Size = UDim2.new(1, 0, 1, 0); urlTestBtn.BackgroundTransparency = 1; urlTestBtn.Text = _("TestURLs")
urlTestBtn.TextColor3 = RED_MAIN; urlTestBtn.TextScaled = true; urlTestBtn.Font = Enum.Font.GothamBold; urlTestBtn.Parent = urlTestContainer; urlTestBtn.AutoButtonColor = false
urlTestBtn.MouseEnter:Connect(function() TweenColor(urlTestContainer, "BackgroundColor3", RED_DARK, 0.12) end)
urlTestBtn.MouseLeave:Connect(function() TweenColor(urlTestContainer, "BackgroundColor3", RED_BG, 0.15) end)

local settingsContainer = Instance.new("Frame")
settingsContainer.Size = UDim2.new(1, -10, 0, 32); settingsContainer.Position = UDim2.new(0, 5, 0, 0)
settingsContainer.BackgroundColor3 = RED_BG; settingsContainer.BorderSizePixel = 2; settingsContainer.BorderColor3 = RED_MAIN; settingsContainer.Parent = scrollFrame; settingsContainer.Visible = false

local settingsBtn = Instance.new("TextButton")
settingsBtn.Size = UDim2.new(1, 0, 1, 0); settingsBtn.BackgroundTransparency = 1; settingsBtn.Text = _("SettingsBtn")
settingsBtn.TextColor3 = RED_MAIN; settingsBtn.TextScaled = true; settingsBtn.Font = Enum.Font.GothamBold; settingsBtn.Parent = settingsContainer; settingsBtn.AutoButtonColor = false
settingsBtn.MouseEnter:Connect(function() TweenColor(settingsContainer, "BackgroundColor3", RED_DARK, 0.12) end)
settingsBtn.MouseLeave:Connect(function() TweenColor(settingsContainer, "BackgroundColor3", RED_BG, 0.15) end)

local resetOrderContainer = Instance.new("Frame")
resetOrderContainer.Size = UDim2.new(1, -10, 0, 32); resetOrderContainer.Position = UDim2.new(0, 5, 0, 0)
resetOrderContainer.BackgroundColor3 = RED_BG; resetOrderContainer.BorderSizePixel = 2; resetOrderContainer.BorderColor3 = RED_MAIN; resetOrderContainer.Parent = scrollFrame; resetOrderContainer.Visible = false

local resetOrderBtn = Instance.new("TextButton")
resetOrderBtn.Size = UDim2.new(1, 0, 1, 0); resetOrderBtn.BackgroundTransparency = 1; resetOrderBtn.Text = _("ResetOrder")
resetOrderBtn.TextColor3 = RED_MAIN; resetOrderBtn.TextScaled = true; resetOrderBtn.Font = Enum.Font.GothamBold; resetOrderBtn.Parent = resetOrderContainer; resetOrderBtn.AutoButtonColor = false
resetOrderBtn.MouseEnter:Connect(function() TweenColor(resetOrderContainer, "BackgroundColor3", RED_DARK, 0.12) end)
resetOrderBtn.MouseLeave:Connect(function() TweenColor(resetOrderContainer, "BackgroundColor3", RED_BG, 0.15) end)
resetOrderBtn.MouseButton1Click:Connect(function()
    ORDER = {}; SetSetting("order", ORDER); SaveTable(ORDER_FILE, {})
    for _, entry in ipairs(buttons) do entry.Container:Destroy() end
    buttons = {}; for _, data in ipairs(SCRIPTS) do CreateScriptButton(data) end
    if _G.RefreshButtons then _G.RefreshButtons() end; ShowRobloxNotification(_("OrderReset"), 3)
end)

local antiKickContainer = Instance.new("Frame")
antiKickContainer.Size = UDim2.new(1, -10, 0, 32); antiKickContainer.Position = UDim2.new(0, 5, 0, 0)
antiKickContainer.BackgroundColor3 = RED_BG; antiKickContainer.BorderSizePixel = 2; antiKickContainer.BorderColor3 = RED_MAIN; antiKickContainer.Parent = scrollFrame; antiKickContainer.Visible = false

local antiKickBtn = Instance.new("TextButton")
antiKickBtn.Name = "AntiKickBtn"; antiKickBtn.Size = UDim2.new(1, 0, 1, 0); antiKickBtn.BackgroundTransparency = 1
antiKickBtn.TextColor3 = RED_MAIN; antiKickBtn.TextScaled = true; antiKickBtn.Font = Enum.Font.GothamBold; antiKickBtn.Parent = antiKickContainer; antiKickBtn.AutoButtonColor = false

local function UpdateAntiKickText()
    antiKickBtn.Text = "AntiKick Settings — EXTRA MODE (Safe)"
    antiKickBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
end
UpdateAntiKickText()

antiKickBtn.MouseEnter:Connect(function() TweenColor(antiKickContainer, "BackgroundColor3", RED_DARK, 0.12) end)
antiKickBtn.MouseLeave:Connect(function() TweenColor(antiKickContainer, "BackgroundColor3", RED_BG, 0.15) end)

local ShowAntiKickSettings
antiKickBtn.MouseButton1Click:Connect(function() if ShowAntiKickSettings then ShowAntiKickSettings() end end)

local destroyContainer = Instance.new("Frame")
destroyContainer.Size = UDim2.new(1, -10, 0, 32); destroyContainer.Position = UDim2.new(0, 5, 0, 0)
destroyContainer.BackgroundColor3 = RED_BG; destroyContainer.BorderSizePixel = 2; destroyContainer.BorderColor3 = RED_MAIN; destroyContainer.Parent = scrollFrame; destroyContainer.Visible = false

local destroyBtnMain = Instance.new("TextButton")
destroyBtnMain.Size = UDim2.new(1, 0, 1, 0); destroyBtnMain.BackgroundTransparency = 1; destroyBtnMain.Text = _("Destroy")
destroyBtnMain.TextColor3 = RED_MAIN; destroyBtnMain.TextScaled = true; destroyBtnMain.Font = Enum.Font.GothamBold; destroyBtnMain.Parent = destroyContainer; destroyBtnMain.AutoButtonColor = false
destroyBtnMain.MouseEnter:Connect(function() TweenColor(destroyContainer, "BackgroundColor3", RED_DARK, 0.12) end)
destroyBtnMain.MouseLeave:Connect(function() TweenColor(destroyContainer, "BackgroundColor3", RED_BG, 0.15) end)
destroyBtnMain.MouseButton1Click:Connect(function() ShowRobloxNotification(HUB_NAME .. " Destroyed!", 2); shared.XyqwHubRunning = nil; screenGui:Destroy() end)

-- ========== ОКНО ANTIKICK SETTINGS (EXTRA) ==========
ShowAntiKickSettings = function()
    local frame = Instance.new("Frame")
    frame.Name = "AKFrame"; frame.Size = UDim2.new(0, 350, 0, 250); frame.Position = UDim2.new(0.5, -175, 0.5, -125)
    frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1
    title.TextColor3 = RED_MAIN; title.Text = "Extra Mode Info"; title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 51; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 30); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 52; dragBar.Parent = frame; dragBar.AutoButtonColor = false
    MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 28); closeBtn.Position = UDim2.new(1, -35, 0, 2); closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 51; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false
    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end)

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -20, 0, 160); desc.Position = UDim2.new(0, 10, 0, 40)
    desc.BackgroundColor3 = RED_DARK; desc.BorderSizePixel = 1; desc.BorderColor3 = RED_MAIN
    desc.TextColor3 = RED_MAIN; desc.TextWrapped = true; desc.TextXAlignment = Enum.TextXAlignment.Left; desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.TextSize = 12; desc.Font = Enum.Font.Gotham; desc.ZIndex = 51; desc.Parent = frame
    desc.Text = "Вы находитесь в Extra Mode.\n\nЭтот режим использует безопасную оболочку (Safe Shell).\nВнутренние хуки на Kick отключены, чтобы вас не забанил Adonis (0x3).\n\nЕсли вы играете в 'Steal an Egg', запустите PulseHub или Moondiety из списка скриптов. Они используют C++ защиту и обойдут античит BAC-6519."

    MakeResizable(frame, 300, 200, 700, 500)
end

-- ========== ОКНО SETTINGS ==========
local ShowSettings
ShowSettings = function()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 200); frame.Position = UDim2.new(0.5, -150, 0.5, -100); frame.BackgroundColor3 = RED_BG
    frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 24); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1
    title.TextColor3 = RED_MAIN; title.Text = _("SettingsTitle"); title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 51; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 26); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 52; dragBar.Parent = frame; dragBar.AutoButtonColor = false
    MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 24); closeBtn.Position = UDim2.new(1, -30, 0, 4); closeBtn.BackgroundTransparency = 1; closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 51; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false

    local bindLbl = Instance.new("TextLabel")
    bindLbl.Size = UDim2.new(1, -20, 0, 20); bindLbl.Position = UDim2.new(0, 10, 0, 40); bindLbl.BackgroundTransparency = 1
    bindLbl.TextColor3 = RED_MAIN; bindLbl.Text = _("AutoHideBind"); bindLbl.TextScaled = true; bindLbl.Font = Enum.Font.GothamBold; bindLbl.TextXAlignment = Enum.TextXAlignment.Left; bindLbl.ZIndex = 51; bindLbl.Parent = frame

    local bindBtn = Instance.new("TextButton")
    bindBtn.Size = UDim2.new(1, -20, 0, 30); bindBtn.Position = UDim2.new(0, 10, 0, 64); bindBtn.BackgroundColor3 = RED_DARK
    bindBtn.TextColor3 = RED_MAIN; bindBtn.Text = tostring(GetSetting("bind", "RightShift")) .. " — click to change"; bindBtn.TextScaled = true
    bindBtn.Font = Enum.Font.GothamBold; bindBtn.BorderSizePixel = 1; bindBtn.BorderColor3 = RED_MAIN; bindBtn.ZIndex = 51; bindBtn.Parent = frame; bindBtn.AutoButtonColor = false

    local waiting = false
    local inputConnection = nil
    bindBtn.MouseButton1Click:Connect(function()
        if waiting then return end
        waiting = true; bindBtn.Text = "Press any key..."
        if inputConnection then pcall(function() inputConnection:Disconnect() end) inputConnection = nil end
        inputConnection = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local keyName = input.KeyCode.Name; SetSetting("bind", keyName); bindBtn.Text = keyName .. " — click to change"
                ShowRobloxNotification(_("KeybindChanged") .. keyName, 2); waiting = false
                if inputConnection then pcall(function() inputConnection:Disconnect() end) inputConnection = nil end
            end
        end)
    end)

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, -20, 0, 60); hint.Position = UDim2.new(0, 10, 0, 105); hint.BackgroundTransparency = 1
    hint.TextColor3 = Color3.fromRGB(150, 150, 150); hint.Text = "Press bind to hide/show " .. HUB_NAME .. " GUI.\nCurrent: " .. tostring(GetSetting("bind", "RightShift"))
    hint.TextWrapped = true; hint.TextScaled = true; hint.Font = Enum.Font.Gotham; hint.TextXAlignment = Enum.TextXAlignment.Left; hint.TextYAlignment = Enum.TextYAlignment.Top; hint.ZIndex = 51; hint.Parent = frame

    closeBtn.MouseButton1Click:Connect(function() if inputConnection then pcall(function() inputConnection:Disconnect() end) inputConnection = nil end; frame:Destroy() end)
    MakeResizable(frame, 250, 180, 700, 500)
end
settingsBtn.MouseButton1Click:Connect(ShowSettings)

urlTestBtn.MouseButton1Click:Connect(function()
    ShowRobloxNotification(_("UrlCheckStarted"), 2)
    task.spawn(function()
        for _, entry in ipairs(buttons) do
            local data = entry.Data
            if data.URL ~= "SPECIAL_COPY_DOORS_V2" then
                entry.StatusDot.BackgroundColor3 = URL_CHECKING
                local ok = pcall(function() local res = SafeHttpGet(data.URL); if res and #res > 0 then return true end; return false end)
                if ok then entry.StatusDot.BackgroundColor3 = URL_OK else entry.StatusDot.BackgroundColor3 = URL_BAD end
                task.wait(0.3)
            end
        end
        ShowRobloxNotification(_("UrlCheckDone"), 3)
    end)
end)

_G.RefreshButtons = function()
    local search = string.lower(searchBar.Text)
    for _, entry in ipairs(buttons) do
        local show = true
        if currentTab == "Fav" then if not FAVORITES[entry.Data.Name] then show = false end
        elseif currentTab == "Rct" then local found = false; for _, n in ipairs(RECENT) do if n == entry.Data.Name then found = true break end end; if not found then show = false end
        elseif currentTab ~= "All" then if entry.Data.Category ~= currentTab then show = false end end
        if show and search ~= "" and not string.find(string.lower(entry.Data.Name), search, 1, true) then show = false end
        entry.Container.Visible = show
    end

    local visible = 0
    for _, entry in ipairs(buttons) do if entry.Container.Visible then entry.Container.Position = UDim2.new(0, 5, 0, visible * buttonHeight + 5); visible = visible + 1 end end

    local showAll = (currentTab == "All" and search == ""); local showFav = (currentTab == "Fav"); local showRct = (currentTab == "Rct")
    removeTagsContainer.Visible = showAll; urlTestContainer.Visible = showAll; settingsContainer.Visible = showAll
    resetOrderContainer.Visible = showAll; antiKickContainer.Visible = showAll; destroyContainer.Visible = showAll
    shareFavContainer.Visible = showFav; shareRctContainer.Visible = showRct

    local specialY = visible * buttonHeight + 5
    if showAll then
        removeTagsContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        urlTestContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        settingsContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        resetOrderContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        antiKickContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        destroyContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        visible = visible + 6
    end
    if showFav then shareFavContainer.Position = UDim2.new(0, 5, 0, specialY); visible = visible + 1 end
    if showRct then shareRctContainer.Position = UDim2.new(0, 5, 0, specialY); visible = visible + 1 end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, visible * buttonHeight + 20)
end

_G.RefreshButtons()
searchBar:GetPropertyChangedSignal("Text"):Connect(function() if _G.RefreshButtons then _G.RefreshButtons() end end)

-- ========== CHANGELOG ==========
local function ShowChangeLog()
    local frame = Instance.new("Frame")
    frame.Name = "CLFrame"; frame.Size = UDim2.new(0, 350, 0, 350); frame.Position = UDim2.new(0.5, -175, 0.5, -175)
    frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1
    title.TextColor3 = RED_MAIN; title.Text = _("ChangeLogTitle"); title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 51; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 30); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 52; dragBar.Parent = frame; dragBar.AutoButtonColor = false
    MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 28); closeBtn.Position = UDim2.new(1, -35, 0, 2); closeBtn.BackgroundTransparency = 1; closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 51; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -45); scroll.Position = UDim2.new(0, 5, 0, 35); scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.CanvasSize = UDim2.new(0, 0, 0, 15000); scroll.ScrollBarThickness = 4; scroll.ScrollBarImageColor3 = RED_MAIN; scroll.ZIndex = 51; scroll.Parent = frame

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -10, 0, 14990); text.Position = UDim2.new(0, 5, 0, 5); text.BackgroundTransparency = 1; text.TextColor3 = RED_MAIN; text.TextWrapped = true; text.TextXAlignment = Enum.TextXAlignment.Left; text.TextYAlignment = Enum.TextYAlignment.Top; text.TextSize = 12; text.Font = Enum.Font.Gotham; text.Text = _("ChangeLogText"); text.ZIndex = 51; text.Parent = scroll

    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end)
    MakeResizable(frame, 250, 200, 900, 1000)
end
changelogButton.MouseButton1Click:Connect(ShowChangeLog)

-- ========== ЯЗЫК ==========
langButton.MouseButton1Click:Connect(function()
    local langs = {"EN", "RU", "UK", "BE", "KK"}; local idx = 1
    for i, l in ipairs(langs) do if l == LANG_CODE then idx = i break end end
    idx = idx + 1; if idx > #langs then idx = 1 end
    LANG_CODE = langs[idx]; SetSetting("lang", LANG_CODE); langButton.Text = LANG_CODE
    searchBar.PlaceholderText = _("Search"); removeTagsBtn.Text = _("RemoveTags"); shareFavBtn.Text = _("ShareFav"); shareRctBtn.Text = _("ShareRct"); urlTestBtn.Text = _("TestURLs"); settingsBtn.Text = _("SettingsBtn"); resetOrderBtn.Text = _("ResetOrder"); destroyBtnMain.Text = _("Destroy"); UpdateAntiKickText()
    ShowRobloxNotification(_("LangChanged"), 3); UpdateHeaderLayout()
end)

-- ========== PLAYER LIST ==========
local function ShowPlayerList()
    local frame = Instance.new("Frame")
    frame.Name = "PLFrame"; frame.Size = UDim2.new(0, 350, 0, 400); frame.Position = UDim2.new(0.5, -175, 0.5, -200); frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = _("PlayersTitle") .. " (" .. #Players:GetPlayers() .. ")"; title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 51; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 30); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 52; dragBar.Parent = frame; dragBar.AutoButtonColor = false; MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 28); closeBtn.Position = UDim2.new(1, -35, 0, 2); closeBtn.BackgroundTransparency = 1; closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 51; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -45); scroll.Position = UDim2.new(0, 5, 0, 35); scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 25 + 10); scroll.ScrollBarThickness = 4; scroll.ScrollBarImageColor3 = RED_MAIN; scroll.ZIndex = 51; scroll.Parent = frame

    local yPos = 5
    for _, plr in ipairs(Players:GetPlayers()) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 22); label.Position = UDim2.new(0, 5, 0, yPos); label.BackgroundColor3 = RED_DARK; label.TextColor3 = RED_MAIN; label.Text = plr.Name .. " | ID: " .. plr.UserId; label.TextScaled = true; label.Font = Enum.Font.Gotham; label.BorderSizePixel = 1; label.BorderColor3 = RED_MAIN; label.ZIndex = 51; label.Parent = scroll
        yPos = yPos + 25
    end
    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end); MakeResizable(frame, 250, 200, 900, 1000)
end

-- ========== SERVER INFO ==========
local function ShowServerInfo()
    local frame = Instance.new("Frame")
    frame.Name = "SIFrame"; frame.Size = UDim2.new(0, 350, 0, 400); frame.Position = UDim2.new(0.5, -175, 0.5, -200); frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = _("ServerTitle"); title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 51; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 30); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 52; dragBar.Parent = frame; dragBar.AutoButtonColor = false; MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 28); closeBtn.Position = UDim2.new(1, -35, 0, 2); closeBtn.BackgroundTransparency = 1; closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 51; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 110); info.Position = UDim2.new(0, 10, 0, 40); info.BackgroundTransparency = 1; info.TextColor3 = RED_MAIN; info.TextWrapped = true; info.TextXAlignment = Enum.TextXAlignment.Left; info.TextYAlignment = Enum.TextYAlignment.Top; info.TextSize = 13; info.Font = Enum.Font.Gotham
    info.Text = _("PlaceId") .. ": " .. game.PlaceId .. "\n" .. _("JobId") .. ": " .. game.JobId .. "\n" .. _("Players") .. ": " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers .. "\n" .. _("Creator") .. ": " .. game.CreatorId
    info.ZIndex = 51; info.Parent = frame

    local function GetServers() local ok, result = pcall(function() return HttpService:JSONDecode(SafeHttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")) end); return (ok and result and result.data) and result.data or {} end

    local rejoinBtn = Instance.new("TextButton")
    rejoinBtn.Size = UDim2.new(1, -20, 0, 30); rejoinBtn.Position = UDim2.new(0, 10, 0, 158); rejoinBtn.BackgroundColor3 = RED_DARK; rejoinBtn.TextColor3 = RED_MAIN; rejoinBtn.Text = _("Rejoin"); rejoinBtn.TextScaled = true; rejoinBtn.Font = Enum.Font.GothamBold; rejoinBtn.BorderSizePixel = 1; rejoinBtn.BorderColor3 = RED_MAIN; rejoinBtn.ZIndex = 51; rejoinBtn.Parent = frame; rejoinBtn.AutoButtonColor = false
    rejoinBtn.MouseButton1Click:Connect(function() QueueReinject(); ShowRobloxNotification("Rejoining...", 2); task.wait(0.5); pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer) end) end)

    local hopBtn = Instance.new("TextButton")
    hopBtn.Size = UDim2.new(0.5, -13, 0, 30); hopBtn.Position = UDim2.new(0, 10, 0, 194); hopBtn.BackgroundColor3 = RED_DARK; hopBtn.TextColor3 = RED_MAIN; hopBtn.Text = _("ServerHop"); hopBtn.TextScaled = true; hopBtn.Font = Enum.Font.GothamBold; hopBtn.BorderSizePixel = 1; hopBtn.BorderColor3 = RED_MAIN; hopBtn.ZIndex = 51; hopBtn.Parent = frame; hopBtn.AutoButtonColor = false
    hopBtn.MouseButton1Click:Connect(function()
        QueueReinject(); ShowRobloxNotification("Searching...", 3); local servers = GetServers(); if #servers == 0 then ShowRobloxNotification("No servers!", 3) return end
        local target = servers[math.random(1, #servers)]; ShowRobloxNotification("Hopping...", 2); task.wait(0.5); pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, target.id, Players.LocalPlayer) end)
    end)

    local smallBtn = Instance.new("TextButton")
    smallBtn.Size = UDim2.new(0.5, -13, 0, 30); smallBtn.Position = UDim2.new(0.5, 3, 0, 194); smallBtn.BackgroundColor3 = RED_DARK; smallBtn.TextColor3 = RED_MAIN; smallBtn.Text = _("TPToSmall"); smallBtn.TextScaled = true; smallBtn.Font = Enum.Font.GothamBold; smallBtn.BorderSizePixel = 1; smallBtn.BorderColor3 = RED_MAIN; smallBtn.ZIndex = 51; smallBtn.Parent = frame; smallBtn.AutoButtonColor = false
    smallBtn.MouseButton1Click:Connect(function()
        QueueReinject(); ShowRobloxNotification("Searching...", 3); local servers = GetServers(); if #servers == 0 then ShowRobloxNotification("No servers!", 3) return end
        local best = servers[1]; for _, srv in ipairs(servers) do if srv.playing < best.playing then best = srv end end; ShowRobloxNotification("Teleporting to " .. best.playing .. " players...", 3); task.wait(0.5); pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, best.id, Players.LocalPlayer) end)
    end)

    local lastSessionBtn = Instance.new("TextButton")
    lastSessionBtn.Size = UDim2.new(1, -20, 0, 30); lastSessionBtn.Position = UDim2.new(0, 10, 0, 232); lastSessionBtn.BackgroundColor3 = RED_DARK; lastSessionBtn.TextColor3 = RED_MAIN; lastSessionBtn.Text = _("RejoinLastSession"); lastSessionBtn.TextScaled = true; lastSessionBtn.Font = Enum.Font.GothamBold; lastSessionBtn.BorderSizePixel = 1; lastSessionBtn.BorderColor3 = RED_MAIN; lastSessionBtn.ZIndex = 51; lastSessionBtn.Parent = frame; lastSessionBtn.AutoButtonColor = false
    lastSessionBtn.MouseButton1Click:Connect(function()
        local ok, savedJob = pcall(function() if readfile and isfile and isfile(SESSION_FILE) then return readfile(SESSION_FILE) end; return nil end)
        if ok and savedJob and savedJob ~= "" and savedJob ~= game.JobId then QueueReinject(); ShowRobloxNotification("Rejoining last server...", 2); task.wait(0.5); pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, savedJob, Players.LocalPlayer) end)
        else ShowRobloxNotification("No saved session", 2) end
    end)

    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(1, -20, 0, 30); copyBtn.Position = UDim2.new(0, 10, 0, 270); copyBtn.BackgroundColor3 = RED_MAIN; copyBtn.TextColor3 = Color3.fromRGB(0, 0, 0); copyBtn.Text = _("CopyJobId"); copyBtn.TextScaled = true; copyBtn.Font = Enum.Font.GothamBold; copyBtn.BorderSizePixel = 0; copyBtn.ZIndex = 51; copyBtn.Parent = frame; copyBtn.AutoButtonColor = false
    copyBtn.MouseButton1Click:Connect(function() pcall(function() setclipboard(game.JobId) end); ShowRobloxNotification(_("JobIdCopied"), 2) end)

    local reinjectBtn = Instance.new("TextButton")
    reinjectBtn.Size = UDim2.new(1, -20, 0, 32); reinjectBtn.Position = UDim2.new(0, 10, 0, 308); reinjectBtn.TextColor3 = RED_MAIN; reinjectBtn.TextScaled = true; reinjectBtn.Font = Enum.Font.GothamBold; reinjectBtn.BorderSizePixel = 1; reinjectBtn.BorderColor3 = RED_MAIN; reinjectBtn.ZIndex = 51; reinjectBtn.Parent = frame; reinjectBtn.AutoButtonColor = false

    local function UpdateReinjectButton()
        if GetSetting("autoreinject", true) then reinjectBtn.Text = _("AutoReinjectOn"); reinjectBtn.TextColor3 = Color3.fromRGB(0, 255, 100); reinjectBtn.BackgroundColor3 = RED_DARK
        else reinjectBtn.Text = _("AutoReinjectOff"); reinjectBtn.TextColor3 = RED_MAIN; reinjectBtn.BackgroundColor3 = RED_BG end
    end
    UpdateReinjectButton()
    reinjectBtn.MouseButton1Click:Connect(function() SetSetting("autoreinject", not GetSetting("autoreinject", true)); UpdateReinjectButton(); ShowRobloxNotification(GetSetting("autoreinject", true) and _("AutoReinjectOn") or _("AutoReinjectOff"), 2) end)

    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end); MakeResizable(frame, 280, 300, 700, 700)
end

-- ========== CUSTOM SCRIPT ==========
local function ShowCustomScript()
    local frame = Instance.new("Frame")
    frame.Name = "CSFrame"; frame.Size = UDim2.new(0, 350, 0, 175); frame.Position = UDim2.new(0.5, -175, 0.5, -87); frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = _("CustomTitle"); title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 51; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 30); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 52; dragBar.Parent = frame; dragBar.AutoButtonColor = false; MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 28); closeBtn.Position = UDim2.new(1, -35, 0, 2); closeBtn.BackgroundTransparency = 1; closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 51; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 0, 36); input.Position = UDim2.new(0, 10, 0, 40); input.BackgroundColor3 = RED_DARK; input.TextColor3 = RED_MAIN; input.PlaceholderText = _("CustomPlaceholder"); input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150); input.Text = ""; input.TextSize = 12; input.Font = Enum.Font.Gotham; input.BorderSizePixel = 1; input.BorderColor3 = RED_MAIN; input.ZIndex = 51; input.Parent = frame

    local runBtn = Instance.new("TextButton")
    runBtn.Size = UDim2.new(1, -20, 0, 36); runBtn.Position = UDim2.new(0, 10, 0, 100); runBtn.BackgroundColor3 = RED_MAIN; runBtn.TextColor3 = Color3.fromRGB(0, 0, 0); runBtn.Text = _("RunCustom"); runBtn.TextScaled = true; runBtn.Font = Enum.Font.GothamBold; runBtn.BorderSizePixel = 0; runBtn.ZIndex = 51; runBtn.Parent = frame; runBtn.AutoButtonColor = false

    runBtn.MouseButton1Click:Connect(function()
        local url = input.Text:match('game:HttpGet%s*%(%s*["\']([^"\']+)["\']') or input.Text:match("^https?://") and input.Text or nil
        if not url then ShowRobloxNotification("Invalid URL!", 3) return end
        local success = pcall(function() SafeLoadstring(url) end)
        if success then ShowRobloxNotification("Custom - " .. _("ScriptExecuted"), 3) else ShowRobloxNotification("Custom - " .. _("Error"), 5) end
    end)
    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end); MakeResizable(frame, 250, 150, 700, 500)
end

-- ========== CUSTOM COLOR ==========
local function ShowCustomColor()
    local frame = Instance.new("Frame")
    frame.Name = "CCFrame"; frame.Size = UDim2.new(0, 280, 0, 380); frame.Position = UDim2.new(0.5, -140, 0.5, -190); frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 0, 22); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = _("CustomColorTitle"); title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 51; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 24); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 52; dragBar.Parent = frame; dragBar.AutoButtonColor = false; MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 22); closeBtn.Position = UDim2.new(1, -28, 0, 4); closeBtn.BackgroundTransparency = 1; closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 51; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false

    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(1, -20, 0, 36); preview.Position = UDim2.new(0, 10, 0, 32); preview.BackgroundColor3 = Color3.fromRGB(GetSetting("cc_r", 255), GetSetting("cc_g", 0), GetSetting("cc_b", 0)); preview.BorderSizePixel = 2; preview.BorderColor3 = RED_MAIN; preview.ZIndex = 51; preview.Parent = frame

    local tempColor = {r = GetSetting("cc_r", 255), g = GetSetting("cc_g", 0), b = GetSetting("cc_b", 0)}
    local hexInput, setSliders
    local function UpdateAll() preview.BackgroundColor3 = Color3.fromRGB(tempColor.r, tempColor.g, tempColor.b); if hexInput then hexInput.Text = string.format("#%02X%02X%02X", tempColor.r, tempColor.g, tempColor.b) end end

    local function MakeSlider(label, yPos, channel)
        local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(0, 20, 0, 18); lbl.Position = UDim2.new(0, 10, 0, yPos); lbl.BackgroundTransparency = 1; lbl.TextColor3 = RED_MAIN; lbl.Text = label; lbl.TextScaled = true; lbl.Font = Enum.Font.GothamBold; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 51; lbl.Parent = frame
        local valLbl = Instance.new("TextLabel"); valLbl.Size = UDim2.new(0, 40, 0, 18); valLbl.Position = UDim2.new(1, -50, 0, yPos); valLbl.BackgroundTransparency = 1; valLbl.TextColor3 = RED_MAIN; valLbl.Text = tostring(tempColor[channel]); valLbl.TextScaled = true; valLbl.Font = Enum.Font.Gotham; valLbl.TextXAlignment = Enum.TextXAlignment.Right; valLbl.ZIndex = 51; valLbl.Parent = frame
        local slider = Instance.new("Frame"); slider.Size = UDim2.new(1, -100, 0, 12); slider.Position = UDim2.new(0, 35, 0, yPos + 3); slider.BackgroundColor3 = RED_DARK; slider.BorderSizePixel = 1; slider.BorderColor3 = RED_MAIN; slider.ZIndex = 51; slider.Parent = frame
        local fill = Instance.new("Frame"); fill.Size = UDim2.new(tempColor[channel] / 255, 0, 1, 0); fill.BackgroundColor3 = RED_MAIN; fill.BorderSizePixel = 0; fill.ZIndex = 52; fill.Parent = slider
        local drag = false
        local function UpdateFromX(mouseX) local rel = math.clamp((mouseX - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1); local v = math.floor(rel * 255); tempColor[channel] = v; fill.Size = UDim2.new(rel, 0, 1, 0); valLbl.Text = tostring(v); UpdateAll() end
        slider.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = true; UpdateFromX(input.Position.X) end end)
        UserInputService.InputChanged:Connect(function(input) if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateFromX(input.Position.X) end end)
        UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = false end end)
        return function(v) tempColor[channel] = v; fill.Size = UDim2.new(v / 255, 0, 1, 0); valLbl.Text = tostring(v) end
    end

    setSliders = {R = MakeSlider("R", 76, "r"), G = MakeSlider("G", 100, "g"), B = MakeSlider("B", 124, "b")}

    local hexLbl = Instance.new("TextLabel"); hexLbl.Size = UDim2.new(0, 40, 0, 18); hexLbl.Position = UDim2.new(0, 10, 0, 150); hexLbl.BackgroundTransparency = 1; hexLbl.TextColor3 = RED_MAIN; hexLbl.Text = "HEX:"; hexLbl.TextScaled = true; hexLbl.Font = Enum.Font.GothamBold; hexLbl.TextXAlignment = Enum.TextXAlignment.Left; hexLbl.ZIndex = 51; hexLbl.Parent = frame
    hexInput = Instance.new("TextBox"); hexInput.Size = UDim2.new(1, -60, 0, 22); hexInput.Position = UDim2.new(0, 50, 0, 148); hexInput.BackgroundColor3 = RED_DARK; hexInput.TextColor3 = RED_MAIN; hexInput.PlaceholderText = "#FF0000"; hexInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150); hexInput.Text = string.format("#%02X%02X%02X", tempColor.r, tempColor.g, tempColor.b); hexInput.TextSize = 12; hexInput.Font = Enum.Font.Gotham; hexInput.ClearTextOnFocus = false; hexInput.BorderSizePixel = 1; hexInput.BorderColor3 = RED_MAIN; hexInput.ZIndex = 51; hexInput.Parent = frame

    hexInput.FocusLost:Connect(function()
        local text = hexInput.Text:gsub("#", ""):gsub("%s", "")
        if #text == 6 then local r, g, b = tonumber(text:sub(1, 2), 16), tonumber(text:sub(3, 4), 16), tonumber(text:sub(5, 6), 16); if r and g and b then tempColor.r = r; tempColor.g = g; tempColor.b = b; if setSliders then setSliders.R(r) setSliders.G(g) setSliders.B(b) end end end
        UpdateAll()
    end)

    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(1, -20, 0, 28); applyBtn.Position = UDim2.new(0, 10, 0, 308); applyBtn.BackgroundColor3 = RED_MAIN; applyBtn.TextColor3 = Color3.fromRGB(0, 0, 0); applyBtn.Text = _("Apply"); applyBtn.TextScaled = true; applyBtn.Font = Enum.Font.GothamBold; applyBtn.BorderSizePixel = 0; applyBtn.ZIndex = 51; applyBtn.Parent = frame; applyBtn.AutoButtonColor = false
    applyBtn.MouseButton1Click:Connect(function()
        SetSetting("cc_r", tempColor.r); SetSetting("cc_g", tempColor.g); SetSetting("cc_b", tempColor.b)
        THEMES.Custom.MAIN = Color3.fromRGB(tempColor.r, tempColor.g, tempColor.b)
        THEMES.Custom.DARK = Color3.fromRGB(math.floor(tempColor.r * 0.15), math.floor(tempColor.g * 0.15), math.floor(tempColor.b * 0.15))
        THEMES.Custom.BG = Color3.fromRGB(0, 0, 0); THEMES.Custom.TITLE = Color3.fromRGB(math.floor(tempColor.r * 0.08), math.floor(tempColor.g * 0.08), math.floor(tempColor.b * 0.08))
        if _G.ApplyTheme then _G.ApplyTheme("Custom") end; ShowRobloxNotification("Custom Color applied!", 3); frame:Destroy()
    end)
    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end); MakeResizable(frame, 280, 350, 600, 800)
end

-- ========== ТЕМЫ ==========
local themeOrder = {"Red", "Blue", "Green", "Purple", "Pink", "Orange", "Cyan", "Yellow", "Lime", "Magenta", "White", "Rainbow", "Custom"}
local themeIndex = 1; for i, name in ipairs(themeOrder) do if name == THEME_NAME then themeIndex = i break end end

_G.ApplyTheme = function(themeName)
    THEME_NAME = themeName; SetSetting("theme", themeName)
    if themeName == "Custom" then local cr, cg, cb = GetSetting("cc_r", 255), GetSetting("cc_g", 0), GetSetting("cc_b", 0); THEMES.Custom.MAIN = Color3.fromRGB(cr, cg, cb); THEMES.Custom.DARK = Color3.fromRGB(math.floor(cr * 0.15), math.floor(cg * 0.15), math.floor(cb * 0.15)); THEMES.Custom.BG = Color3.fromRGB(0, 0, 0); THEMES.Custom.TITLE = Color3.fromRGB(math.floor(cr * 0.08), math.floor(cg * 0.08), math.floor(cb * 0.08)) end
    local t = THEMES[themeName]; RED_MAIN = t.MAIN; RED_DARK = t.DARK; RED_BG = t.BG; RED_TITLE = t.TITLE
    mainFrame.BackgroundColor3 = RED_BG; mainFrame.BorderColor3 = RED_MAIN; titleBar.BackgroundColor3 = RED_TITLE; titleLabel.TextColor3 = RED_MAIN
    for _, btn in ipairs({closeButton, langButton, playerBtn, serverBtn, customBtn, changelogButton, themeBtn, colorBtn, infoBtn}) do btn.BackgroundColor3 = RED_DARK; btn.TextColor3 = RED_MAIN; btn.BorderColor3 = RED_MAIN end
    searchBar.BackgroundColor3 = RED_DARK; searchBar.TextColor3 = RED_MAIN; searchBar.BorderColor3 = RED_MAIN; scrollFrame.ScrollBarImageColor3 = RED_MAIN
    for n, btn in pairs(tabButtons) do if n == currentTab then btn.BackgroundColor3 = RED_MAIN; btn.TextColor3 = Color3.fromRGB(0, 0, 0) else btn.BackgroundColor3 = RED_DARK; btn.TextColor3 = RED_MAIN end; btn.BorderColor3 = RED_MAIN end
    for _, entry in ipairs(buttons) do entry.Container.BackgroundColor3 = RED_BG; entry.Container.BorderColor3 = RED_MAIN; entry.Btn.TextColor3 = RED_MAIN; entry.Star.BackgroundColor3 = RED_BG; entry.Star.TextColor3 = RED_MAIN; entry.Star.BorderColor3 = RED_MAIN; entry.AutoBtn.BorderColor3 = RED_MAIN; if entry.DragStrip then entry.DragStrip.BackgroundColor3 = RED_MAIN end; if AUTOEXEC[entry.Data.Name] then entry.AutoBtn.BackgroundColor3 = RED_MAIN; entry.AutoBtn.TextColor3 = Color3.fromRGB(0, 0, 0) else entry.AutoBtn.BackgroundColor3 = RED_BG; entry.AutoBtn.TextColor3 = RED_MAIN end end
    removeTagsContainer.BorderColor3 = RED_MAIN; shareFavContainer.BorderColor3 = RED_MAIN; shareRctContainer.BorderColor3 = RED_MAIN; urlTestContainer.BorderColor3 = RED_MAIN; settingsContainer.BorderColor3 = RED_MAIN; resetOrderContainer.BorderColor3 = RED_MAIN; antiKickContainer.BorderColor3 = RED_MAIN; destroyContainer.BorderColor3 = RED_MAIN; removeTagsBtn.TextColor3 = RED_MAIN; shareFavBtn.TextColor3 = RED_MAIN; shareRctBtn.TextColor3 = RED_MAIN; urlTestBtn.TextColor3 = RED_MAIN; settingsBtn.TextColor3 = RED_MAIN; resetOrderBtn.TextColor3 = RED_MAIN; destroyBtnMain.TextColor3 = RED_MAIN; UpdateAntiKickText()
    topBar.BackgroundColor3 = RED_BG; topBar.BorderColor3 = RED_MAIN; topBarText.TextColor3 = RED_MAIN; hideTopBtn.BackgroundColor3 = RED_DARK; hideTopBtn.TextColor3 = RED_MAIN; hideTopBtn.BorderColor3 = RED_MAIN
    dockButton.BackgroundColor3 = RED_BG; dockButton.TextColor3 = RED_MAIN; dockButton.BorderColor3 = RED_MAIN
    if themeName ~= "Rainbow" then ShowRobloxNotification("Theme: " .. themeName, 2) end
end

themeBtn.MouseButton1Click:Connect(function() themeIndex = themeIndex + 1; if themeIndex > #themeOrder then themeIndex = 1 end; _G.ApplyTheme(themeOrder[themeIndex]); if THEME_NAME == "Rainbow" then ShowRobloxNotification("Theme: Rainbow", 2) end end)

task.spawn(function()
    local hue = 0
    while screenGui.Parent do
        if THEME_NAME == "Rainbow" then
            hue = (hue + 0.008) % 1; local c = Color3.fromHSV(hue, 1, 1); local darkHue = Color3.fromHSV(hue, 1, 0.18)
            mainFrame.BorderColor3 = c; titleBar.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 0.08); titleLabel.TextColor3 = c
            for _, btn in ipairs({closeButton, langButton, playerBtn, serverBtn, customBtn, changelogButton, themeBtn, colorBtn, infoBtn}) do btn.BackgroundColor3 = darkHue; btn.TextColor3 = c; btn.BorderColor3 = c end
            searchBar.TextColor3 = c; searchBar.BorderColor3 = c; searchBar.BackgroundColor3 = darkHue; scrollFrame.ScrollBarImageColor3 = c
            for n, btn in pairs(tabButtons) do if n == currentTab then btn.BackgroundColor3 = c; btn.TextColor3 = Color3.fromRGB(0, 0, 0); btn.BorderColor3 = c else btn.BackgroundColor3 = darkHue; btn.TextColor3 = c; btn.BorderColor3 = c end end
            for _, entry in ipairs(buttons) do entry.Container.BorderColor3 = c; entry.Btn.TextColor3 = c; entry.Star.TextColor3 = c; entry.Star.BorderColor3 = c; entry.Star.BackgroundColor3 = darkHue; entry.AutoBtn.BorderColor3 = c; if entry.DragStrip then entry.DragStrip.BackgroundColor3 = c end; if AUTOEXEC[entry.Data.Name] then entry.AutoBtn.BackgroundColor3 = c; entry.AutoBtn.TextColor3 = Color3.fromRGB(0, 0, 0) else entry.AutoBtn.BackgroundColor3 = darkHue; entry.AutoBtn.TextColor3 = c end end
            removeTagsContainer.BorderColor3 = c; shareFavContainer.BorderColor3 = c; shareRctContainer.BorderColor3 = c; urlTestContainer.BorderColor3 = c; settingsContainer.BorderColor3 = c; resetOrderContainer.BorderColor3 = c; antiKickContainer.BorderColor3 = c; destroyContainer.BorderColor3 = c; removeTagsBtn.TextColor3 = c; shareFavBtn.TextColor3 = c; shareRctBtn.TextColor3 = c; urlTestBtn.TextColor3 = c; settingsBtn.TextColor3 = c; resetOrderBtn.TextColor3 = c; destroyBtnMain.TextColor3 = c
            topBar.BorderColor3 = c; topBarText.TextColor3 = c; hideTopBtn.BackgroundColor3 = darkHue; hideTopBtn.TextColor3 = c; hideTopBtn.BorderColor3 = c; dockButton.TextColor3 = c; dockButton.BorderColor3 = c
        end
        task.wait(0.05)
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed) if gameProcessed then return end; if input.UserInputType == Enum.UserInputType.Keyboard then if input.KeyCode.Name == GetSetting("bind", "RightShift") then if mainFrame.Visible then CloseGui() else OpenGui() end end end end)

local resizeHandle = Instance.new("TextButton")
resizeHandle.Name = "ResizeHandle"; resizeHandle.Size = UDim2.new(0, 14, 0, 14); resizeHandle.Position = UDim2.new(1, -14, 1, -14); resizeHandle.BackgroundColor3 = RED_MAIN; resizeHandle.Text = ""; resizeHandle.BorderSizePixel = 0; resizeHandle.ZIndex = 10; resizeHandle.Parent = mainFrame; resizeHandle.AutoButtonColor = false

local sizeLabel = Instance.new("TextLabel")
sizeLabel.Name = "SizeLabel"; sizeLabel.Size = UDim2.new(0, 70, 0, 14); sizeLabel.Position = UDim2.new(1, -88, 1, -16); sizeLabel.BackgroundTransparency = 1; sizeLabel.TextColor3 = RED_MAIN; sizeLabel.Text = "280 x 340"; sizeLabel.TextSize = 10; sizeLabel.Font = Enum.Font.Gotham; sizeLabel.TextXAlignment = Enum.TextXAlignment.Right; sizeLabel.ZIndex = 10; sizeLabel.Parent = mainFrame

local resizing, resizeStart, resizeStartSize = false, nil, nil
resizeHandle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = true; resizeStart = input.Position; resizeStartSize = mainFrame.Size end end)
UserInputService.InputChanged:Connect(function(input) if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - resizeStart; local newX = math.clamp(resizeStartSize.X.Offset + delta.X, 280, 900); local newY = math.clamp(resizeStartSize.Y.Offset + delta.Y, 340, 1000); mainFrame.Size = UDim2.new(0, newX, 0, newY); savedSize = mainFrame.Size; sizeLabel.Text = math.floor(newX) .. " x " .. math.floor(newY); UpdateTabLayout(); UpdateScriptButtonLayout(); UpdateHeaderLayout() end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end end)

local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local mousePos = input.Position
        local function IsOverButton(btn) if not btn then return false end; local p = btn.AbsolutePosition; local s = btn.AbsoluteSize; return mousePos.X >= p.X and mousePos.X <= p.X + s.X and mousePos.Y >= p.Y and mousePos.Y <= p.Y + s.Y end
        if IsOverButton(changelogButton) or IsOverButton(langButton) or IsOverButton(closeButton) or IsOverButton(themeBtn) or IsOverButton(customBtn) or IsOverButton(playerBtn) or IsOverButton(serverBtn) or IsOverButton(colorBtn) then return end
        dragging = true; dragStart = input.Position; startPos = mainFrame.Position
    end
end)
titleBar.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

closeButton.MouseButton1Click:Connect(CloseGui)

local function ShowWelcomeMessage()
    local frame = Instance.new("Frame")
    frame.Name = "WFrame"; frame.Size = UDim2.new(0, 340, 0, 340); frame.Position = UDim2.new(0.5, -170, 0.5, -170); frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 100; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local blocker = Instance.new("TextButton")
    blocker.Size = UDim2.new(1, 0, 1, 0); blocker.BackgroundTransparency = 1; blocker.Text = ""; blocker.Active = true; blocker.AutoButtonColor = false; blocker.ZIndex = 100; blocker.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 22); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = _("WelcomeTitle"); title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 101; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 24); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 102; dragBar.Parent = frame; dragBar.AutoButtonColor = false; MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 22); closeBtn.Position = UDim2.new(1, -31, 0, 4); closeBtn.BackgroundTransparency = 1; closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 102; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false
    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end)

    local docScroll = Instance.new("ScrollingFrame")
    docScroll.Size = UDim2.new(1, -10, 1, -40); docScroll.Position = UDim2.new(0, 5, 0, 35); docScroll.BackgroundTransparency = 1; docScroll.BorderSizePixel = 0; docScroll.CanvasSize = UDim2.new(0, 0, 0, 400); docScroll.ScrollBarThickness = 4; docScroll.ScrollBarImageColor3 = RED_MAIN; docScroll.ZIndex = 101; docScroll.Parent = frame

    local doc = Instance.new("TextLabel")
    doc.Size = UDim2.new(1, -10, 0, 390); doc.Position = UDim2.new(0, 5, 0, 0); doc.BackgroundTransparency = 1; doc.TextColor3 = RED_MAIN; doc.TextWrapped = true; doc.TextXAlignment = Enum.TextXAlignment.Left; doc.TextYAlignment = Enum.TextYAlignment.Top; doc.TextSize = 11; doc.Font = Enum.Font.Gotham
    doc.Text = "─── 1.0 EXTRA MODE ───\n★ Специализированный хаб для BAC-6519.\n★ Встроен таймер выживания.\n★ Интегрирован Safe Black Box.\n★ Добавлены: PulseHub и Moondiety.\n\n─── TITLE BAR ───\nTh - Theme\nCC - Custom Color\nCL - ChangeLog\nC - Custom Script\nP - Players\nS - Server Info\n\nTikTok: xyqwerq.tvink\nTG: t.me/xyqwsquad"
    doc.ZIndex = 101; doc.Parent = docScroll

    MakeResizable(frame, 280, 250, 900, 1000)
end

UpdateTabLayout()
UpdateScriptButtonLayout()
UpdateHeaderLayout()
SwitchTab("All")

task.spawn(function() task.wait(0.5); ShowRobloxNotification(HUB_NAME .. " EXTRA MODE Loaded!", 4) end)
task.spawn(function() task.wait(1.2); ShowWelcomeMessage() end)
task.spawn(function() task.wait(2.5); if IsOwner() then ShowRobloxNotification(_("OwnerWelcome"), 5) elseif IsBeta() then ShowRobloxNotification(_("BetaWelcome"), 5) end end)

task.spawn(function() while screenGui.Parent do task.wait(30); pcall(function() if writefile and game.JobId and game.JobId ~= "" then writefile(SESSION_FILE, game.JobId) end end) end end)

task.spawn(function()
    while screenGui.Parent do task.wait(5); if not screenGui.Parent then break end end
    shared.XyqwHubRunning = nil
end)

