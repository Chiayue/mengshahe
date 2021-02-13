function Spawn( entityKeyValues )
    if IsServer() then
		Timers(function ()
			if not thisEntity:IsAlive() then
				return nil
			end
			if thisEntity:IsChanneling() then
				return 1
            end
            if shitouren_one() then
                local enemies = FindUnitsInRadius(
                    thisEntity:GetTeamNumber(), 
                    thisEntity:GetOrigin(), 
                    nil, 
                    650, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO, 
                    DOTA_UNIT_TARGET_FLAG_NONE, 
                    FIND_CLOSEST, 
                    false
                )
                if #enemies > 0 then
                    thisEntity:CastAbilityOnTarget(enemies[1], shitouren_one_ability, thisEntity:GetEntityIndex())
                end
                return 1                  
            end
            if shitouren_two() then
                thisEntity:CastAbilityImmediately(thisEntity:FindAbilityByName("initiative_shitouren_two_lua"),thisEntity:GetEntityIndex())
                return 1      
            end
            if shitouren_three() then
                local enemies = FindUnitsInRadius(
                    thisEntity:GetTeamNumber(), 
                    thisEntity:GetOrigin(), 
                    nil, 
                    500, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO, 
                    DOTA_UNIT_TARGET_FLAG_NONE, 
                    FIND_CLOSEST, 
                    false
                )
                if #enemies > 0 then
                    thisEntity:CastAbilityImmediately(thisEntity:FindAbilityByName("initiative_shitouren_three_lua"),thisEntity:GetEntityIndex())    
                end
                return 1                  
            end
            return 1
		end)
	end
end

function shitouren_one()
	if not shitouren_one_ability then
		shitouren_one_ability = thisEntity:FindAbilityByName("initiative_shitouren_one_lua")
	end
	return shitouren_one_ability and shitouren_one_ability:IsFullyCastable()
end
function shitouren_two()
	if not shitouren_two_ability then
		shitouren_two_ability = thisEntity:FindAbilityByName("initiative_shitouren_two_lua")
	end
	return shitouren_two_ability and shitouren_two_ability:IsFullyCastable()
end
function shitouren_three()
	if not shitouren_three_ability then
		shitouren_three_ability = thisEntity:FindAbilityByName("initiative_shitouren_three_lua")
	end
	return shitouren_three_ability and shitouren_three_ability:IsFullyCastable()
end