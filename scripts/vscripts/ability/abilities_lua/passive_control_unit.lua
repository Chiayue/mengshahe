control_unit = class({})

function DoSpellStart(params)
    local target = params.target
    local caster = params.caster
    if ContainUnitTypeFlag(target, DOTA_UNIT_TYPE_FLAG_CREEP + DOTA_UNIT_TYPE_FLAG_GENERAL) then
        if caster.control_unit and caster.control_unit:IsNull()~=true and caster.control_unit:IsAlive() then
            caster.control_unit:ForceKill(false)
        end
        if ContainUnitTypeFlag(target, DOTA_UNIT_TYPE_FLAG_CREEP + DOTA_UNIT_TYPE_FLAG_GENERAL + DOTA_UNIT_TYPE_FLAG_ELITE) then
            game_playerinfo:change_player_wood(caster, 1)
        else
            target:AddNewModifier(caster, params.ability, "modifier_kill_self", {duration = 180,noParticle = true})
            target:AddNewModifier(caster, params.ability, "modifier_custom_wudi", {})
            local damage_amount = target:GetBaseDamageMax() * 10
            target:SetBaseDamageMax(damage_amount)
            target:SetBaseDamageMin(damage_amount)
        end
        target:SetTeam(caster:GetTeam())
        target:SetOwner(caster)
        target:SetControllableByPlayer(caster:GetPlayerID(), false)
        caster.control_unit = target
    else
        send_error_tip(caster:GetPlayerID(),"error_cannotdominant")
        return
    end
end

function wear_cloth(params)
    local caster = params.caster
    local wearTable = {
        "models/items/doom/doom_the_fallen_head/doom_the_fallen_head.vmdl",
        "models/items/doom/doom_the_fallen_arms/doom_the_fallen_arms.vmdl",
        "models/items/doom/ti8_doom_obsidian_overlord_back/ti8_doom_obsidian_overlord_back.vmdl",
        "models/items/doom/doom_the_fallen_belt/doom_the_fallen_belt.vmdl",
        "models/items/doom/doom_the_fallen_shoulder/doom_the_fallen_shoulder.vmdl",
        "models/items/doom/doom_the_fallen_tail/doom_the_fallen_tail.vmdl",
        "models/items/doom/doom_the_fallen_weapon/doom_the_fallen_weapon.vmdl",
    }
    WearForHero(wearTable,caster)
    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_obsidian/doom_obsidian_wings_ambient.vpcf", PATTACH_POINT_FOLLOW	,  caster.wear_table[3] );
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster.wear_table[3], PATTACH_POINT_FOLLOW	, "", caster:GetOrigin(), true );
    ParticleManager:ReleaseParticleIndex(nFXIndex)
    nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_the_fallen/doom_the_fallen_head.vpcf", PATTACH_POINT_FOLLOW	,  caster.wear_table[1] );
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster.wear_table[1], PATTACH_POINT_FOLLOW	, "", caster:GetOrigin(), true );
    ParticleManager:ReleaseParticleIndex(nFXIndex)
    nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_the_fallen/doom_the_fallen_belt.vpcf", PATTACH_POINT_FOLLOW	,  caster.wear_table[4] );
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster.wear_table[4], PATTACH_POINT_FOLLOW	, "", caster:GetOrigin(), true );
    ParticleManager:ReleaseParticleIndex(nFXIndex)
    nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_the_fallen/doom_the_fallen_shoulder.vpcf", PATTACH_POINT_FOLLOW	,  caster.wear_table[5] );
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster.wear_table[5], PATTACH_POINT_FOLLOW	, "", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 1, caster.wear_table[5], PATTACH_POINT_FOLLOW	, "attach_shoulder_r_fx", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 2, caster.wear_table[5], PATTACH_POINT_FOLLOW	, "attach_shoulder_l_fx", caster:GetOrigin(), true );
    ParticleManager:ReleaseParticleIndex(nFXIndex)
    nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_the_fallen/doom_the_fallen_weapon.vpcf", PATTACH_POINT_FOLLOW	,  caster.wear_table[5] );
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster.wear_table[5], PATTACH_POINT_FOLLOW	, "", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 1, caster.wear_table[5], PATTACH_POINT_FOLLOW	, "attach_weapon_fx", caster:GetOrigin(), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 26, caster.wear_table[5], PATTACH_POINT_FOLLOW	, "", caster:GetOrigin(), true );
    ParticleManager:ReleaseParticleIndex(nFXIndex)
    
end


