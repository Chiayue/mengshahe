function Spawn(entityKeyValues)
    if IsServer() then
        Ability1 = thisEntity:FindAbilityByName("boss_finally_ability_1")
        Ability2 = thisEntity:FindAbilityByName("boss_finally_ability_2")
		Ability3 = thisEntity:FindAbilityByName("boss_finally_ability_3")
		Ability4 = thisEntity:FindAbilityByName("boss_finally_ability_4")

		Ability1:StartCooldown(Ability1:GetCooldown(1))
		Ability2:StartCooldown(Ability2:GetCooldown(1))
		Ability3:StartCooldown(Ability3:GetCooldown(1))
		Ability4:StartCooldown(Ability4:GetCooldown(1))

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
			if CanAbility4() then
				thisEntity:CastAbilityNoTarget(Ability4, thisEntity:GetEntityIndex())
				return 5
			end
			if CanAbility3() then
				local enemies = FindUnitsInRadius(
					thisEntity:GetTeamNumber(), 
					thisEntity:GetOrigin(), 
					nil, 
					800, 
					DOTA_UNIT_TARGET_TEAM_ENEMY, 
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
					DOTA_UNIT_TARGET_FLAG_NONE, 
					FIND_CLOSEST, 
					false
				)
				if #enemies > 0 then
					thisEntity:CastAbilityOnTarget(enemies[1], Ability3, thisEntity:GetEntityIndex())
					return 5
				end
				return 1
			end
			if CanAbility2() then
				thisEntity:CastAbilityNoTarget(Ability2, thisEntity:GetEntityIndex())
				return 5
			end
			if CanAbility1() then
				local closest = FindClosest()
				if closest then
					thisEntity:CastAbilityOnTarget(closest, Ability1, thisEntity:GetEntityIndex())
				end
				return 5
			end
			return 1
		end, 5)
	end
end

function CanAbility1()
	return Ability1:IsFullyCastable() and thisEntity:GetHealth() < thisEntity:GetMaxHealth() * 1
end

function CanAbility2()
	return Ability2:IsFullyCastable() and thisEntity:GetHealth() < thisEntity:GetMaxHealth() * 0.9
end

function CanAbility3()
	return Ability3:IsFullyCastable() and thisEntity:GetHealth() < thisEntity:GetMaxHealth() * 0.7
end

function CanAbility4()
	return Ability4:IsFullyCastable() and thisEntity:GetHealth() < thisEntity:GetMaxHealth() * 0.4
end

function FindClosest()
	local enemies = FindUnitsInRadius(
        thisEntity:GetTeamNumber(), 
        thisEntity:GetOrigin(), 
        nil, 
        800, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_CLOSEST, 
        false
    )
    if #enemies > 0 then
        return enemies[1]
    end
	return nil
end