function Spawn(entityKeyValues)
    if IsServer() then
        PaoAbility = thisEntity:FindAbilityByName("boss_god_water_pao")
        WaveAbility = thisEntity:FindAbilityByName("boss_god_water_wave")
        CopyAbility = thisEntity:FindAbilityByName("boss_god_water_copy")

        thisEntity:SetContextThink("Think", function ()
			if not thisEntity:IsAlive() then
				return nil
			end
			if GameRules:IsGamePaused() == true then
				return 1
			end
			if thisEntity:IsChanneling() then
				return 1
			end
			if CanWave() then
				thisEntity:CastAbilityNoTarget(WaveAbility, thisEntity:GetEntityIndex())
				return 1
			end
            if CanCopy() then
				thisEntity:CastAbilityNoTarget(CopyAbility, thisEntity:GetEntityIndex())
				return 1
			end
			if CanPao() then
				local closest = FindClosest()
				if closest then
					thisEntity:CastAbilityOnTarget(closest, PaoAbility, thisEntity:GetEntityIndex())
				end
				return 1
			end
			return 1
		end, 5)
	end
end

function CanPao()
	return PaoAbility:IsFullyCastable() and thisEntity:GetHealth() < thisEntity:GetMaxHealth() * 1
end

function CanWave()
	return WaveAbility:IsFullyCastable() and thisEntity:GetHealth() < thisEntity:GetMaxHealth() * 0.5
end

function CanCopy()
	return CopyAbility:IsFullyCastable() and thisEntity:GetHealth() < thisEntity:GetMaxHealth() * 0.3
end

function FindClosest()
    local closest = nil
    local distance = 0
	for _, hero in pairs(HeroList:GetAllHeroes()) do
		if hero:IsAlive() and hero:IsRealHero() then
			if hero:FindModifierByName("modifier_boss_god_water_pao") then
				hero:ForceKill(false)
			else
				if closest then
					local temp = (hero:GetOrigin() - thisEntity:GetOrigin()):Length2D()
					if distance > temp then
						closest = hero
						distance = temp
					end
				else
					closest = hero
					distance = (hero:GetOrigin() - thisEntity:GetOrigin()):Length2D()
				end
			end
		end
	end
	return closest
end