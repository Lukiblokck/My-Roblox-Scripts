-- SCRIPT DE INMORTALIDAD PARA ROBLOX
-- Solo ejecuta y serás inmortal instantáneamente

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Función principal de inmortalidad
local function makeImmortal()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Hacer inmortal de múltiples formas
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    -- Protección contra daño
    local connection
    connection = humanoid.HealthChanged:Connect(function(health)
        if health < humanoid.MaxHealth then
            humanoid.Health = math.huge
        end
    end)
    
    -- Protección contra muerte
    humanoid.Died:Connect(function()
        wait(0.1)
        if player.Character then
            makeImmortal()
        end
    end)
    
    print("🛡️ INMORTALIDAD ACTIVADA - Eres invencible!")
    return connection
end

-- Función para proteger contra resets
local function protectFromReset()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Prevenir que el personaje se resetee
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Anchored = false
        end
    end
end

-- Activar inmortalidad cuando el personaje spawne
player.CharacterAdded:Connect(function(character)
    wait(1) -- Esperar a que el personaje cargue completamente
    makeImmortal()
    protectFromReset()
end)

-- Si ya hay un personaje, activar inmediatamente
if player.Character then
    makeImmortal()
    protectFromReset()
end

-- Mantener inmortalidad constantemente
RunService.Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        if humanoid.Health < math.huge then
            humanoid.Health = math.huge
            humanoid.MaxHealth = math.huge
        end
    end
end)

-- Protección extra contra scripts que intenten matarte
local mt = getrawmetatable(game)
local oldindex = mt.__index
setreadonly(mt, false)

mt.__index = function(t, k)
    if k == "Health" and t.Parent == player.Character then
        return math.huge
    end
    return oldindex(t, k)
end

setreadonly(mt, true)

print("🎮 SCRIPT CARGADO EXITOSAMENTE")
print("💚 Eres completamente INMORTAL")
print("🔥 Disfruta tu invencibilidad!")
