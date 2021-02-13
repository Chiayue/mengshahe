quantu_chenmo_lua = class({})
--------------------------------------------------------------------------------

function quantu_chenmo_lua:OnSpellStart()
    local caster = self:GetCaster()
    SetBaseStrength(caster, 15)
    SetBaseAgility(caster, 15)
    SetBaseIntellect(caster, 15)

    local playercount = global_var_func.all_player_amount
    for playerid = 0, playercount - 1 do
        if playerid~=caster:GetPlayerID() then
            local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
            if hero:IsAlive() then
                hero:AddNewModifier( hero, self, "modifier_silenced_lua", { duration = 10.0 } )
            end
        end
    end
    caster:EmitSound("tiny.han")--调用音效
end

function quantu_chenmo_lua:GetIntrinsicModifierName()
    return "modifier_quantu_chenmo_wear"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_quantu_chenmo_wear","ability/abilities_lua/quantu_chenmo_lua", LUA_MODIFIER_MOTION_NONE )

if modifier_quantu_chenmo_wear == nil then
    modifier_quantu_chenmo_wear =({})
end

function modifier_quantu_chenmo_wear:RemoveOnDeath() return false end
function modifier_quantu_chenmo_wear:IsHidden() return true end
function modifier_quantu_chenmo_wear:IsPurgable() return false end

function modifier_quantu_chenmo_wear:OnCreated(params)
    if IsServer() then
        local hero = self:GetParent()
        local weartable = {
           "models/items/silencer/frostivus2018_silencer_silent_paragon_off_hand/frostivus2018_silencer_silent_paragon_off_hand.vmdl",
           "models/items/silencer/frostivus2018_silencer_silent_paragon_arms/frostivus2018_silencer_silent_paragon_arms.vmdl",
           "models/items/silencer/frostivus2018_silencer_silent_paragon_belt/frostivus2018_silencer_silent_paragon_belt.vmdl",
           "models/items/silencer/frostivus2018_silencer_silent_paragon_shoulder/frostivus2018_silencer_silent_paragon_shoulder.vmdl",
           "models/items/silencer/ti6_helmet/mesh/ti6_helmet.vmdl",
           "models/items/silencer/silencer_ti8_immortal_weapon/silencer_ti8_immortal_weapon.vmdl"
        }
        WearForHero(weartable,self:GetParent())
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/silencer/silencer_silent_paragon/silencer_silent_paragon_shield_ambient.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[1] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[1], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[1], PATTACH_POINT_FOLLOW, "attach_shield", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, hero.wear_table[1], PATTACH_POINT_FOLLOW, "attach_gem", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 6, hero.wear_table[1], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/silencer/silencer_silent_paragon/silencer_silent_paragon_belt_ambient.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[3] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[3], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[3], PATTACH_POINT_FOLLOW, "attach_shield", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, hero.wear_table[3], PATTACH_POINT_FOLLOW, "attach_gem", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 6, hero.wear_table[3], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 11, hero.wear_table[3], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/silencer/silencer_ti6/silencer_ti6_ambient.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[5] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[5], PATTACH_POINT_FOLLOW, "attach_head", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[5], PATTACH_POINT_FOLLOW, "attach_eye_l", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, hero.wear_table[5], PATTACH_POINT_FOLLOW, "attach_eye_r", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/silencer/silencer_ti8/silencer_ti8_ambient.vpcf", PATTACH_POINT_FOLLOW	,  hero.wear_table[6] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[6], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[6], PATTACH_POINT_FOLLOW, "attach_bladeorient", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, hero.wear_table[6], PATTACH_POINT_FOLLOW, "attach_gem_a", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 3, hero.wear_table[6], PATTACH_POINT_FOLLOW, "attach_gem_b", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 4, hero.wear_table[6], PATTACH_POINT_FOLLOW, "attach_gem_c", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 10, hero.wear_table[6], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
    end 
end
