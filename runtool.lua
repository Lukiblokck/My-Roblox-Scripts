-- https://scriptblox.com/script/Universal-Script-Run-Tool-29865

local tool = Instance.new("Tool")
    tool.Name = "Very Speed Run Tool"

    tool.Parent = game.Players.LocalPlayer.Backpack
    tool.RequiresHandle = false

    local moving = false
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    local runService = game:GetService("RunService")
    local movementSpeed = 300 



    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://18897115785" 
    local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator")
    local animationTrack

    local function moveForward()
        while moving do
            local forwardDirection = humanoidRootPart.CFrame.LookVector
            humanoidRootPart.Velocity = forwardDirection * movementSpeed
            runService.Stepped:Wait()
        end
    end

    tool.Equipped:Connect(function()
        moving = true

        for i, v in character:GetChildren() do
            if v:IsA("Part") then
                local Attachment = Instance.new("Attachment")
                local ParticleEmitter = Instance.new("ParticleEmitter")


                Attachment.Parent = v
                Attachment.Name = "sigmarun"

                ParticleEmitter.Brightness = 5
                ParticleEmitter.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.109804, 1, 0.0117647),0),ColorSequenceKeypoint.new(1,Color3.new(0.0470588, 1, 0.0470588),0)})
                ParticleEmitter.Drag = 3
                ParticleEmitter.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
                ParticleEmitter.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
                ParticleEmitter.Lifetime = NumberRange.new(0.5,0.5)
                ParticleEmitter.LightEmission = -1
                ParticleEmitter.LockedToPart = true
                ParticleEmitter.Rate = 2.5
                ParticleEmitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,2,0),NumberSequenceKeypoint.new(1,2,0)})
                ParticleEmitter.Speed = NumberRange.new(0,0)
                ParticleEmitter.Texture = [[http://www.roblox.com/asset/?id=14904853757]]
                ParticleEmitter.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.198684,0.491803,0),NumberSequenceKeypoint.new(0.501316,0.513661,0),NumberSequenceKeypoint.new(0.798684,0.497268,0),NumberSequenceKeypoint.new(1,1,0)})
                ParticleEmitter.ZOffset = -1
                ParticleEmitter.Parent = Attachment
            end
        end
        animationTrack = animator:LoadAnimation(animation)
        animationTrack:Play()
        moveForward()
    end)

    tool.Unequipped:Connect(function()
        moving = false
        for i, v in character:GetDescendants() do
            if v:IsA("Attachment") and v:FindFirstChild("ParticleEmitter") and v.Name == "sigmarun" then
                v:Destroy()
            end
        end
        if animationTrack then
            animationTrack:Stop()
        end
    end)