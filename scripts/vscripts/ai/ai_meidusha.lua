function Spawn( entityKeyValues )
    if IsServer() then
		Timers(function ()
			if not thisEntity:IsAlive() then
				return nil
			end
			if thisEntity:IsChanneling() then
				return 1
            end
            if meidusha_one() then
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
                    thisEntity:CastAbilityOnTarget(enemies[1], meidusha_one_ability, thisEntity:GetEntityIndex())
                end
                return 1                  
            end
            if meidusha_two() then
                local enemies = FindUnitsInRadius(
                    thisEntity:GetTeamNumber(), 
                    thisEntity:GetOrigin(), 
                    nil, 
                    600, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO, 
                    DOTA_UNIT_TARGET_FLAG_NONE, 
                    FIND_CLOSEST, 
                    false
                )
                if #enemies > 0 then
                    thisEntity:CastAbilityOnTarget(enemies[1], meidusha_two_ability, thisEntity:GetEntityIndex())
                end
                return 1                  
            end
            if meidusha_three() then
                local enemies = FindUnitsInRadius(
                    thisEntity:GetTeamNumber(), 
                    thisEntity:GetOrigin(), 
                    nil, 
                    600, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO, 
                    DOTA_UNIT_TARGET_FLAG_NONE, 
                    FIND_CLOSEST, 
                    false
                )
                if #enemies > 0 then
                    thisEntity:CastAbilityOnTarget(enemies[1], meidusha_three_ability, thisEntity:GetEntityIndex())
                end
                return 1                  
            end
            return 1
		end)
	end
end

function meidusha_one()
	if not meidusha_one_ability then
		meidusha_one_ability = thisEntity:FindAbilityByName("initiative_meidusha_one_lua")
	end
	return meidusha_one_ability and meidusha_one_ability:IsFullyCastable()
end
function meidusha_two()
	if not meidusha_two_ability then
		meidusha_two_ability = thisEntity:FindAbilityByName("initiative_meidusha_two_lua")
	end
	return meidusha_two_ability and meidusha_two_ability:IsFullyCastable()
end
function meidusha_three()
	if not meidusha_three_ability then
		meidusha_three_ability = thisEntity:FindAbilityByName("initiative_meidusha_three_lua")
	end
	return meidusha_three_ability and meidusha_three_ability:IsFullyCastable()
end