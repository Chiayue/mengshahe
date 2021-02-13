dajiasai_lua = class({})
LinkLuaModifier( "modifier_active_point_magical_lua","ability/abilities_lua/modifier/modifier_active_point_magical_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dajiasai_lua_wear","ability/abilities_lua/dajiasai_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function dajiasai_lua:OnSpellStart()
    local caster = self:GetCaster()
    game_playerinfo:set_player_gold(caster:GetPlayerID(),5000 + caster:GetLevel()*500)
    caster:AddNewModifier( caster, self, "modifier_active_point_magical_lua", { duration = 7.0 } )
end

function dajiasai_lua:GetIntrinsicModifierName()
    return "modifier_dajiasai_lua_wear"
end

if modifier_dajiasai_lua_wear==nil then
    modifier_dajiasai_lua_wear = ({})
end


function modifier_dajiasai_lua_wear:IsHidden() return true end
function modifier_dajiasai_lua_wear:RemoveOnDeath() return false end

function modifier_dajiasai_lua_wear:OnCreated(params)
    if IsServer() then
        local hero = self:GetParent()
        -- local weartable = {
        --   "models/items/axe/generic_blinkdag/generic_blinkdag.vmdl",
        --   "models/items/axe/molten_claw/molten_claw.vmdl",
        --   "models/items/axe/shout_mask/shout_mask.vmdl",
        --   "models/items/axe/axe_cape/axe_cape.vmdl",
        -- }
        -- WearForHero(weartable,self:GetParent())
        -- local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_helm_shoutmask/axe_shout_mask_ambient.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[3] );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[3], PATTACH_POINT_FOLLOW, "attach_eye_l", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[3], PATTACH_POINT_FOLLOW, "attach_eye_r", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 2, hero.wear_table[3], PATTACH_POINT_FOLLOW, "attach_mouth", hero:GetOrigin(), true );
        -- ParticleManager:ReleaseParticleIndex(nFXIndex)
        -- nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_armor_molten_claw/axe_molten_claw_ambient.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[2] );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[2], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 4, hero.wear_table[2], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        -- ParticleManager:ReleaseParticleIndex(nFXIndex)
        -- nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_cinder/axe_cinder_ambient_alt.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[4] );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[4], PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 3, hero.wear_table[4], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 4, hero.wear_table[4], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 7, hero.wear_table[4], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 9, hero.wear_table[4], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        -- ParticleManager:SetParticleControlEnt( nFXIndex, 10, hero.wear_table[4], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        -- ParticleManager:ReleaseParticleIndex(nFXIndex)
        -- hero:AddActivityModifier('jog')
    end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
