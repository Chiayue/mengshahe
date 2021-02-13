function Spawn( entityKeyValues )
    if IsServer() then
		Timers(function ()
			if not thisEntity:IsAlive() then
				return nil
			end
			if thisEntity:IsChanneling() then
				return 1
            end
            if munaiyi_one() then
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
                    thisEntity:CastAbilityOnTarget(enemies[1], munaiyi_one_ability, thisEntity:GetEntityIndex())
                end
                return 1                  
            end
            if munaiyi_two() then
                local enemies = FindUnitsInRadius(
                    thisEntity:GetTeamNumber(), 
                    thisEntity:GetOrigin(), 
                    nil, 
                    500, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                    DOTA_UNIT_TARGET_FLAG_NONE, 
                    FIND_CLOSEST, 
                    false
                )
                if #enemies > 0 then
                    thisEntity:CastAbilityImmediately(thisEntity:FindAbilityByName("initiative_munaiyi_two_lua"),thisEntity:GetEntityIndex())
                end
                return 1
            end
            if munaiyi_three() then
                thisEntity:CastAbilityImmediately(thisEntity:FindAbilityByName("initiative_munaiyi_three_lua"),thisEntity:GetEntityIndex())
                return 1
            end
            return 1
		end)
	end
end

function munaiyi_one()
	if not munaiyi_one_ability then
		munaiyi_one_ability = thisEntity:FindAbilityByName("initiative_munaiyi_one_lua")
	end
	return munaiyi_one_ability and munaiyi_one_ability:IsFullyCastable()
end

function munaiyi_two()
	if not munaiyi_two_ability then
		munaiyi_two_ability = thisEntity:FindAbilityByName("initiative_munaiyi_two_lua")
	end
	return munaiyi_two_ability and munaiyi_two_ability:IsFullyCastable()
end

function munaiyi_three()
	if not munaiyi_three_ability then
		munaiyi_three_ability = thisEntity:FindAbilityByName("initiative_munaiyi_three_lua")
	end
	return munaiyi_three_ability and munaiyi_three_ability:IsFullyCastable()
end