function call_fenshen(params)
    local cast_point = params.target_points[1]
    local caster = params.caster
    local ability = params.ability
    local attack_damage = caster:GetAverageTrueAttackDamage(caster) * 0.25
    local health = caster:GetMaxHealth() * 0.25
    local armor = caster:GetPhysicalArmorBaseValue() * 0.25
    local magic_armor = caster:GetMagicalArmorValue() * 0.25
    local start_point = cast_point
    local end_porit = cast_point + 100 
    local own_player = caster.player_id
    for i=1,4 do
        local end_cast_point= RotatePosition(start_point,QAngle(0,90, 0),end_porit)
        end_porit = end_cast_point
        local yanmo_1 = CreateUnitByName("xiaoyanmo", end_cast_point, true, caster,nil, DOTA_TEAM_BADGUYS)
        FindClearSpaceForUnit(yanmo_1,end_cast_point,true)
        local duration = ability:GetSpecialValueFor("alive_time")
        yanmo_1:SetBaseMaxHealth(health)
        yanmo_1:SetMaxHealth(health)
        yanmo_1:SetHealth(health)
        yanmo_1:SetBaseDamageMax(attack_damage )
        yanmo_1:SetBaseDamageMin(attack_damage)
        yanmo_1:SetPhysicalArmorBaseValue(armor)
        yanmo_1:SetBaseMagicalResistanceValue(magic_armor)
        -- yanmo_1:SetContext("player_id",tostring(own_player) , 0)
        -- yanmo_1:SetContext("unit_type", "1", 0)
        yanmo_1.unit_type_flag = DOTA_UNIT_TYPE_FLAG_NONE
        yanmo_1.player_id = own_player
        yanmo_1:AddNewModifier(caster,ability,"modifier_kill_self",{duration = duration})
        local pfx3 = ParticleManager:CreateParticle("particles/heroes/invoker/combination_t29_sun_strike.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControlEnt(pfx3, 0, nil, PATTACH_WORLDORIGIN, "", end_cast_point, true)
        ParticleManager:ReleaseParticleIndex(pfx3)
    end
end