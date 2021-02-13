function Spawn( entityKeyValues )
    if not IsServer() then
		return
	end
    if thisEntity == nil then
		return
    end
    thisEntity:SetContextThink( "do_ability", do_ability, 0 )

end


function do_ability()
    local unit = thisEntity
    local unit_heal = unit:GetHealth() 
    local unit_max = unit:GetMaxHealth()
    if unit:IsChanneling() then
        return 1
    end 
    if unit_heal > unit_max * 0.9 then
       return 1
    end
    local jiguang = unit:FindAbilityByName("jiguang")
    if jiguang:IsFullyCastable() then
        local cast_range = jiguang:GetCastRange(unit:GetOrigin(), jiguang)
        local heros = FindUnitsInRadius( unit:GetTeam(), unit:GetOrigin(), nil, cast_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
        if (#heros > 0) then 
            unit:CastAbilityNoTarget(jiguang,unit:GetEntityIndex())
            return 8
        end
    end
    local penhuo_line = unit:FindAbilityByName("penhuo_line")
    if penhuo_line:IsFullyCastable() then
        unit:CastAbilityNoTarget(penhuo_line,unit:GetEntityIndex())
        return 8
    end
    local sanweizhenhuo = unit:FindAbilityByName("sanweizhenhuo")
    if sanweizhenhuo:IsFullyCastable() then
        unit:CastAbilityNoTarget(sanweizhenhuo,unit:GetEntityIndex())
        return 8
    end
    local huo_dun = unit:FindAbilityByName("huo_dun")
    if unit_heal < unit_max * 0.7 then
        if huo_dun:IsFullyCastable() then
            unit:CastAbilityNoTarget(huo_dun,unit:GetEntityIndex())
            return 8
        end
     end
    return 1
end