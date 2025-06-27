-------- OMG HAX

r = game:service("RunService")


Tool = script.Parent
hammer = Tool.Handle

local shockRing = Instance.new("Part")
shockRing.formFactor = 2
shockRing.Size = Vector3.new(1, 0.4, 1)
shockRing.Anchored = true
shockRing.Locked = true
shockRing.CanCollide = false
shockRing.archivable = false
shockRing.TopSurface = 0
shockRing.BottomSurface = 0
shockRing.Transparency = 1
local decal = Instance.new("Decal")
decal.Face = 1
decal.Texture = "http://www.roblox.com/asset/?version=1&id=1280730"
decal.Parent = shockRing

local bottomDecal = decal:Clone()
bottomDecal.Face = 4
bottomDecal.Parent = shockRing



function doDamage(hit)
	local humanoid = hit.Parent:findFirstChild("Humanoid")
	local vCharacter = Tool.Parent
	local vPlayer = game.Players:playerFromCharacter(vCharacter)
	local hum = vCharacter:findFirstChild("Humanoid") -- non-nil if tool held by a character
	if humanoid~=nil and humanoid ~= hum and hum ~= nil then
		tagHumanoid(humanoid, vPlayer)
		humanoid:TakeDamage(humanoid.MaxHealth)
		if humanoid.Health <= 0 then
			local c = hit.CFrame
			hit.CFrame = CFrame.new(hit.Position)
			hit.CFrame = c
		end
		delay(1, function() untagHumanoid(humanoid) end)
	else
		local c = hit.CFrame	hit:BreakJoints()	hit.CFrame = CFrame.new(hit.Position)	hit.CFrame = c
	end
end


function tagHumanoid(humanoid, player)
	local creator_tag = Instance.new("ObjectValue")
	creator_tag.Value = player
	creator_tag.Name = "creator"
	creator_tag.Parent = humanoid
end

function untagHumanoid(humanoid)
	if humanoid ~= nil then
		local tag = humanoid:findFirstChild("creator")
		if tag ~= nil then
			tag.Parent = nil
		end
	end
end

function blow(obj, pos, notme)
	if (obj ~= notme) then
		if (obj.className == "Part") or (obj.className == "Seat") then
			if (not obj.Anchored) and (((pos - obj.Position) * Vector3.new(1, 0, 1)).magnitude < 96) and (pos.y <= obj.Position.y + 8) and (pos.y >= obj.Position.y - 8) then
				delay((pos - obj.Position).magnitude / 96, function()	doDamage(obj)	obj.Velocity = ((obj.Position - pos).unit + Vector3.new(0, 0.5, 0)) * 96 + obj.Velocity	obj.RotVelocity = obj.RotVelocity + Vector3.new(obj.Position.z - pos.z, 0, pos.x - obj.Position.x).unit * 40	end)
			end
		elseif (obj.className == "Model") or (obj.className == "Hat") or (obj.className == "Tool") or (obj == workspace) then
			local list = obj:GetChildren()
			for x = 1, #list do
				blow(list[x], pos, notme)
			end
		end
	end
end

function attack()
	damage = slash_damage
	local anim = Instance.new("StringValue")
	anim.Name = "toolanim"
	anim.Value = "Slash"
	anim.Parent = Tool
	wait(0.2)

	print("Blasting!")

	local pos = hammer.CFrame * (Vector3.new(0, 1.4, 0) * hammer.Mesh.Scale)

	blow(workspace, pos, Tool.Parent)

	shockRing.CFrame = CFrame.new(pos)
	for x = 1, 29 do
		delay(x / 30, function()	shockRing.Parent = nil	shockRing.Size = Vector3.new(0, 0.4, 0) + Vector3.new(6.4, 0, 6.4) * x	shockRing.Parent = Tool	end)
	end
	delay(1, function() shockRing.Parent = nil end)
end


Tool.Enabled = true
function onActivated()

	if not Tool.Enabled then
		return
	end

	Tool.Enabled = false

	local character = Tool.Parent;
	local humanoid = character.Humanoid
	if humanoid == nil then
		print("Humanoid not found")
		return 
	end

	hammer.Boom:Play()
	attack()

	wait(0)

	Tool.Enabled = true
end


script.Parent.Activated:connect(onActivated)
--script.Parent.Equipped:connect(onEquipped)
