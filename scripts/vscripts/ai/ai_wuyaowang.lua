function Spawn( entityKeyValues )
    if IsServer() then
		Timers(function ()
			if not thisEntity:IsAlive() then
				return nil
			end
			if thisEntity:IsChanneling() then
				return 1
            end
            if wuyaowang_one() then
                local enemies = FindUnitsInRadius(
                    thisEntity:GetTeamNumber(), 
                    thisEntity:GetOrigin(), 
                    nil, 
                    650, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                    DOTA_UNIT_TARGET_FLAG_NONE, 
                    FIND_CLOSEST, 
                    false
                )
                if #enemies > 0 then
                    thisEntity:CastAbilityOnTarget(enemies[1], wuyaowang_one_ability, thisEntity:GetEntityIndex())
                end
                return 3                  
            end
            if wuyaowang_two() then
                local enemies = FindUnitsInRadius(
                    thisEntity:GetTeamNumber(), 
                    thisEntity:GetOrigin(), 
                    nil, 
                    650, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                    DOTA_UNIT_TARGET_FLAG_NONE, 
                    FIND_CLOSEST, 
                    false
                )
                if #enemies > 0 then
                    thisEntity:CastAbilityOnTarget(enemies[1], wuyaowang_two_ability, thisEntity:GetEntityIndex())
                end
                return 1                  
            end
            if wuyaowang_three() then
                local enemies = FindUnitsInRadius(
                    thisEntity:GetTeamNumber(), 
                    thisEntity:GetOrigin(), 
                    nil, 
                    300, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                    DOTA_UNIT_TARGET_FLAG_NONE, 
                    FIND_CLOSEST, 
                    false
                )
                if #enemies > 0 then
                    thisEntity:CastAbilityOnTarget(enemies[1], wuyaowang_three_ability, thisEntity:GetEntityIndex())
                end
                return 1
            end
            return 1
		end)
	end
end

function wuyaowang_one()
	if not wuyaowang_one_ability then
		wuyaowang_one_ability = thisEntity:FindAbilityByName("initiative_shadow_one_lua")
	end
	return wuyaowang_one_ability and wuyaowang_one_ability:IsFullyCastable()
end

function wuyaowang_two()
	if not wuyaowang_two_ability then
		wuyaowang_two_ability = thisEntity:FindAbilityByName("initiative_shadow_two_lua")
	end
	return wuyaowang_two_ability and wuyaowang_two_ability:IsFullyCastable()
end

function wuyaowang_three()
	if not wuyaowang_three_ability then
		wuyaowang_three_ability = thisEntity:FindAbilityByName("initiative_shadow_three_lua")
	end
	return wuyaowang_three_ability and wuyaowang_three_ability:IsFullyCastable()
end