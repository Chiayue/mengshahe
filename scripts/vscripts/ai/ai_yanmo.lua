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
    if unit:IsAlive() then
        local fenshen = unit:FindAbilityByName("call_yanmo_fenshen")
        if fenshen then
            if fenshen:IsFullyCastable()  then
                local heros = FindUnitsInRadius( unit:GetTeam(), unit:GetOrigin(), nil, fenshen:GetCastRange(unit:GetOrigin(), fenshen), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
                if (#heros < 1) then 
                    return 2
                end
                local postion = heros[1]:GetOrigin()
                unit:CastAbilityOnPosition(postion,fenshen,unit:GetEntityIndex())
            end
        else 
            return nil
        end
        return 2
    else
        return nil
    end
end