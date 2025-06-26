-- GUI de Inmortalidad para Roblox
-- Coloca este script en StarterPlayerScripts (LocalScript)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables de estado
local isImmortal = false
local immortalConnection = nil
local currentMethod = 1

-- Crear la GUI
local function createImmortalityGUI()
    -- Crear ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ImmortalityGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0, 10, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Sombra
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = mainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = shadow
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "🛡️ PANEL DE INMORTALIDAD"
    titleLabel.TextColor3 = Color3.white
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleLabel
    
    -- Botón de cerrar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.white
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleLabel
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    -- Estado actual
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -20, 0, 30)
    statusLabel.Position = UDim2.new(0, 10, 0, 60)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Estado: MORTAL"
    statusLabel.TextColor3 = Color3.fromRGB(220, 50, 50)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = mainFrame
    
    -- Botón principal de inmortalidad
    local immortalButton = Instance.new("TextButton")
    immortalButton.Name = "ImmortalButton"
    immortalButton.Size = UDim2.new(1, -20, 0, 50)
    immortalButton.Position = UDim2.new(0, 10, 0, 100)
    immortalButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    immortalButton.BorderSizePixel = 0
    immortalButton.Text = "🛡️ ACTIVAR INMORTALIDAD"
    immortalButton.TextColor3 = Color3.white
    immortalButton.TextScaled = true
    immortalButton.Font = Enum.Font.GothamBold
    immortalButton.Parent = mainFrame
    
    local immortalCorner = Instance.new("UICorner")
    immortalCorner.CornerRadius = UDim.new(0, 8)
    immortalCorner.Parent = immortalButton
    
    -- Selector de método
    local methodLabel = Instance.new("TextLabel")
    methodLabel.Name = "MethodLabel"
    methodLabel.Size = UDim2.new(1, -20, 0, 25)
    methodLabel.Position = UDim2.new(0, 10, 0, 170)
    methodLabel.BackgroundTransparency = 1
    methodLabel.Text = "Método de Inmortalidad:"
    methodLabel.TextColor3 = Color3.white
    methodLabel.TextScaled = true
    methodLabel.Font = Enum.Font.Gotham
    methodLabel.Parent = mainFrame
    
    -- Botones de método
    local methods = {
        {name = "Salud Infinita", desc = "Salud = ∞"},
        {name = "Regeneración", desc = "Regen constante"},
        {name = "Anti-Daño", desc = "Bloquea daño"},
        {name = "Completa", desc = "Máxima protección"}
    }
    
    local methodButtons = {}
    for i, method in ipairs(methods) do
        local methodButton = Instance.new("TextButton")
        methodButton.Name = "Method" .. i
        methodButton.Size = UDim2.new(0.48, 0, 0, 35)
        methodButton.Position = UDim2.new((i-1) % 2 * 0.52, 10, 0, 200 + math.floor((i-1) / 2) * 45)
        methodButton.BackgroundColor3 = i == 1 and Color3.fromRGB(70, 120, 200) or Color3.fromRGB(60, 60, 70)
        methodButton.BorderSizePixel = 0
        methodButton.Text = method.name
        methodButton.TextColor3 = Color3.white
        methodButton.TextScaled = true
        methodButton.Font = Enum.Font.Gotham
        methodButton.Parent = mainFrame
        
        local methodCorner = Instance.new("UICorner")
        methodCorner.CornerRadius = UDim.new(0, 6)
        methodCorner.Parent = methodButton
        
        methodButtons[i] = methodButton
    end
    
    -- Información de salud
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, -20, 0, 25)
    healthLabel.Position = UDim2.new(0, 10, 0, 310)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "Salud: 100/100"
    healthLabel.TextColor3 = Color3.white
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.Parent = mainFrame
    
    -- Botón de tecla rápida
    local hotkeyButton = Instance.new("TextButton")
    hotkeyButton.Name = "HotkeyButton"
    hotkeyButton.Size = UDim2.new(1, -20, 0, 30)
    hotkeyButton.Position = UDim2.new(0, 10, 0, 340)
    hotkeyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
    hotkeyButton.BorderSizePixel = 0
    hotkeyButton.Text = "Tecla rápida: F (Presiona para cambiar)"
    hotkeyButton.TextColor3 = Color3.white
    hotkeyButton.TextScaled = true
    hotkeyButton.Font = Enum.Font.Gotham
    hotkeyButton.Parent = mainFrame
    
    local hotkeyCorner = Instance.new("UICorner")
    hotkeyCorner.CornerRadius = UDim.new(0, 6)
    hotkeyCorner.Parent = hotkeyButton
    
    return screenGui, {
        mainFrame = mainFrame,
        statusLabel = statusLabel,
        immortalButton = immortalButton,
        methodButtons = methodButtons,
        healthLabel = healthLabel,
        closeButton = closeButton,
        hotkeyButton = hotkeyButton
    }
end

-- Funciones de inmortalidad
local function stopImmortality()
    if immortalConnection then
        immortalConnection:Disconnect()
        immortalConnection = nil
    end
end

local function startImmortality(method)
    stopImmortality()
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if method == 1 then
        -- Método 1: Salud infinita
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        
    elseif method == 2 then
        -- Método 2: Regeneración
        immortalConnection = RunService.Heartbeat:Connect(function()
            if humanoid.Parent and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        
    elseif method == 3 then
        -- Método 3: Anti-daño
        immortalConnection = humanoid.HealthChanged:Connect(function(newHealth)
            if newHealth < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        
    elseif method == 4 then
        -- Método 4: Completa
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        
        immortalConnection = RunService.Heartbeat:Connect(function()
            if humanoid.Parent and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    end
end

-- Crear GUI y configurar eventos
local gui, elements = createImmortalityGUI()
local currentHotkey = Enum.KeyCode.F

-- Actualizar interfaz
local function updateInterface()
    if isImmortal then
        elements.statusLabel.Text = "Estado: INMORTAL 🛡️"
        elements.statusLabel.TextColor3 = Color3.fromRGB(50, 220, 50)
        elements.immortalButton.Text = "⚔️ DESACTIVAR INMORTALIDAD"
        elements.immortalButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    else
        elements.statusLabel.Text = "Estado: MORTAL ⚰️"
        elements.statusLabel.TextColor3 = Color3.fromRGB(220, 50, 50)
        elements.immortalButton.Text = "🛡️ ACTIVAR INMORTALIDAD"
        elements.immortalButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    end
    
    -- Actualizar botones de método
    for i, button in ipairs(elements.methodButtons) do
        if i == currentMethod then
            button.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
        else
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        end
    end
end

-- Actualizar salud en la interfaz
local function updateHealthDisplay()
    spawn(function()
        while gui.Parent do
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                local health = math.floor(humanoid.Health)
                local maxHealth = math.floor(humanoid.MaxHealth)
                
                if maxHealth == math.huge then
                    elements.healthLabel.Text = "Salud: ∞/∞"
                else
                    elements.healthLabel.Text = "Salud: " .. health .. "/" .. maxHealth
                end
            else
                elements.healthLabel.Text = "Salud: --/--"
            end
            wait(0.1)
        end
    end)
end

-- Eventos de botones
elements.immortalButton.MouseButton1Click:Connect(function()
    isImmortal = not isImmortal
    
    if isImmortal then
        startImmortality(currentMethod)
    else
        stopImmortality()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
    
    updateInterface()
end)

-- Eventos de métodos
for i, button in ipairs(elements.methodButtons) do
    button.MouseButton1Click:Connect(function()
        currentMethod = i
        if isImmortal then
            startImmortality(currentMethod)
        end
        updateInterface()
    end)
end

-- Botón de cerrar
elements.closeButton.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(elements.mainFrame, 
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0)}
    )
    tween:Play()
    tween.Completed:Connect(function()
        gui:Destroy()
    end)
end)

-- Tecla rápida
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == currentHotkey then
        elements.immortalButton.MouseButton1Click:Fire()
    end
end)

-- Configurar tecla rápida
elements.hotkeyButton.MouseButton1Click:Connect(function()
    elements.hotkeyButton.Text = "Presiona una tecla..."
    elements.hotkeyButton.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        currentHotkey = input.KeyCode
        elements.hotkeyButton.Text = "Tecla rápida: " .. input.KeyCode.Name
        elements.hotkeyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
        connection:Disconnect()
    end)
end)

-- Reconectar cuando el personaje reaparezca
player.CharacterAdded:Connect(function()
    wait(1) -- Esperar a que el personaje se cargue completamente
    if isImmortal then
        startImmortality(currentMethod)
    end
end)

-- Inicializar
updateInterface()
updateHealthDisplay()

print("GUI de Inmortalidad cargada. Presiona F para alternar o usa la interfaz.")
