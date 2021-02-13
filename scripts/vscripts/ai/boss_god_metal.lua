function Spawn(entityKeyValues)
	if IsServer() then
		SpearAbility = thisEntity:FindAbilityByName("boss_god_metal_spear")
		ChopAbility = thisEntity:FindAbilityByName("boss_god_metal_chop")
		DrainAbility = thisEntity:FindAbilityByName("boss_god_metal_drain")

		thisEntity:SetContextThink("Think", function ()
			if not thisEntity:IsAlive() then
				return nil
			end
			if GameRules:IsGamePaused() == true then
				return 0.1
			end
			if thisEntity:IsChanneling() then
				return 0.1
			end

			if CanDrain() then
				thisEntity:CastAbilityNoTarget(DrainAbility, thisEntity:GetEntityIndex())
				return 1
			end
			
			if CanSpear() then
				thisEntity:CastAbilityNoTarget(SpearAbility, thisEntity:GetEntityIndex())
				return 1
			end

			if CanChop() then
				thisEntity:CastAbilityOnTarget(RandomHero(), ChopAbility, thisEntity:GetEntityIndex())
				return 1
			end

			return 1
		end, 5)
	end
end

function CanDrain()
	return DrainAbility:IsFullyCastable() and not AllDeath() and thisEntity:GetHealth() < thisEntity:GetMaxHealth() * 0.3
end

function CanSpear()
	return SpearAbility:IsFullyCastable() and not AllDeath() and thisEntity:GetHealth() < thisEntity:GetMaxHealth() * 0.5
end

function CanChop()
	return ChopAbility:IsFullyCastable() and not AllDeath() and thisEntity:GetHealth() < thisEntity:GetMaxHealth() * 0.9
end

function FindHPLowest()
	local lowest = nil
	for _, hero in pairs(HeroList:GetAllHeroes()) do
		if hero:IsAlive() then
			if lowest then
				if lowest:GetHealth() > hero:GetHealth() then
					lowest = hero
				end
			else
				lowest = hero
			end
		end
	end
	return lowest
end

function RandomHero()
	local heroes = {}
	for _, hero in pairs(HeroList:GetAllHeroes()) do
		if hero:IsAlive() then
			table.insert(heroes, hero)
		end
	end
	return heroes[RandomInt(1, #heroes)]
end

function AllDeath()
	for _, hero in pairs(HeroList:GetAllHeroes()) do
		if hero:IsAlive() then
			return false
		end
	end
	return true
end