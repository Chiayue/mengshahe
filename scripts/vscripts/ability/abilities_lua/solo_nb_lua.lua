solo_nb_lua = class({})
--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_solo_nb_lua","ability/abilities_lua/solo_nb_lua", LUA_MODIFIER_MOTION_NONE )

function solo_nb_lua:GetIntrinsicModifierName()
    return "modifier_solo_nb_lua"
end

if modifier_solo_nb_lua == nil then
	modifier_solo_nb_lua = class({})
end

function modifier_solo_nb_lua:IsHidden()
    return true -- 隐藏
end

function modifier_solo_nb_lua:IsPurgable()
    return false -- 无法驱散
end
 
function modifier_solo_nb_lua:RemoveOnDeath()
    return false -- 死亡不移除
end

function modifier_solo_nb_lua:OnCreated(params)
    if IsServer() then
        local hero = self:GetParent()
        local weartable = {
            "models/items/tidehunter/living_iceberg_collection_back/living_iceberg_collection_back.vmdl",
            "models/items/tidehunter/living_iceberg_collection_belt/living_iceberg_collection_belt.vmdl",
            "models/items/tidehunter/living_iceberg_collection_arms/living_iceberg_collection_arms.vmdl",
            "models/items/tidehunter/diving_helmet/tidehunter_diving_helmet.vmdl",
            "models/items/tidehunter/blink_dagger_tide/blink_dagger_tide.vmdl",
            "models/items/tidehunter/claddish_cudgel/claddish_cudgel.vmdl",
        }
        WearForHero(weartable,self:GetParent())
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/tidehunter/tidehunter_divinghelmet/tidehunter_divinghelmet_ambient.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[4] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[4], PATTACH_POINT_FOLLOW, "attach_helmet", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[4], PATTACH_POINT_FOLLOW, "attach_tube", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/tidehunter/tidehunter_blink_dagger/tidehunter_blink_ambient.vpcf", PATTACH_POINT_FOLLOW, hero.wear_table[5]);
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[5], PATTACH_POINT_FOLLOW, "attach_blink", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/tidehunter/tidehunter_claddish/tidehunter_claddish_ambient.vpcf", PATTACH_POINT_FOLLOW, hero.wear_table[6]);
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[6], PATTACH_POINT_FOLLOW, "attach_claddish_ambient", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)

        local playercount = global_var_func.all_player_amount
        if playercount == 1 then
            local caster = self:GetAbility():GetCaster()
            
            SetBaseStrength(caster, 111)
            SetBaseAgility(caster, 111)
            SetBaseIntellect(caster, 111)

            game_playerinfo:set_dynamic_properties(PlayerResource:GetSteamAccountID(caster:GetPlayerID()), "extra_attack_speed", 111)
        end
    end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
