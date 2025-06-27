-- [Programmed by abrah_m]

local PlayersService = game:GetService("Players");
local DebrisService = game:GetService("Debris");

local Tool = script.Parent

local Debounce = false;
local CanDamage = false;

local Player
local Character

local SwingTrack

Tool.Equipped:Connect(function()
	Character = Tool.Parent
	Player = PlayersService:GetPlayerFromCharacter(Character)
	
	SwingTrack = Character.Humanoid.Animator:LoadAnimation(script.Swing)
end)

Tool.Activated:Connect(function()
	if not Debounce then
		Debounce = true;
		
		CanDamage = true;
		
		SwingTrack:Play()
		
		Tool.Handle.Swing:Play()
		
		Tool.Handle.Touched:Connect(function(hit)
			if hit.Parent:FindFirstChild("Humanoid") and hit.Parent:FindFirstChild("HumanoidRootPart") and CanDamage then
				script.Parent.Handle.Ban:Play()
				
				local Explosion = Instance.new("Explosion", workspace)
				Explosion.BlastRadius = 10;
				Explosion.BlastPressure = 0;
				Explosion.Position = hit.Parent:FindFirstChild("HumanoidRootPart").Position
				
				hit.Parent:FindFirstChild("Humanoid").Health = 0;
				
				for i, obj in pairs(hit.Parent:GetDescendants()) do
					if obj:IsA("Motor6D") and obj.Parent.Name ~= "HumanoidRootPart" then
						local Socket = Instance.new("BallSocketConstraint", obj.Parent)
						local a1, a2 = Instance.new("Attachment", obj.Part0), Instance.new("Attachment", obj.Part1)
						
						Socket.Attachment0 = a1
						Socket.Attachment1 = a2
						
						a1.CFrame = obj.C0
						a2.CFrame = obj.C1
						
						Socket.LimitsEnabled = true;
						Socket.TwistLimitsEnabled = true;
						
						obj:Destroy()
					end
				end
				
				local BodyVelocity = Instance.new("BodyVelocity", hit.Parent:FindFirstChild("HumanoidRootPart"))
				BodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 10000000;
				BodyVelocity.Velocity = Character.HumanoidRootPart.CFrame.LookVector * 1000;
				
				DebrisService:AddItem(BodyVelocity, 0.1)
				
				CanDamage = false;
			end
		end)
		
		SwingTrack.Stopped:Wait()
		
		CanDamage = false;
		
		wait()
		
		Debounce = false;
	end
end)
