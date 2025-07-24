game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		
		-- Establece la vida máxima y actual a 100 millones
		humanoid.MaxHealth = 100000000
		humanoid.Health = 100000000
	end)
end)