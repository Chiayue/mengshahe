
require("info/game_playerinfo")

--------------------------------------------------------------------------------

laohaidao_huilu_lua = class({})

function laohaidao_huilu_lua:OnSpellStart()
    
    if not IsServer() then
        return
    end
    game_playerinfo:set_player_gold(self:GetCaster():GetPlayerID(),-2500)
    local value = RandomInt(1,10)

    SetBaseStrength(self:GetCaster(), value)
    SetBaseAgility(self:GetCaster(), value)
    SetBaseIntellect(self:GetCaster(), value)
end

function laohaidao_huilu_lua:CastFilterResult()
    if not IsServer() then
        return
    end
    if  game_playerinfo:get_player_gold(self:GetCaster():GetPlayerID()) < 2500 then
        return UF_FAIL_CUSTOM
    end

    local nFXIndex = ParticleManager:CreateParticle( "particles/items4_fx/bull_whip_self.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "", self:GetCaster():GetOrigin(), true );
    ParticleManager:ReleaseParticleIndex( nFXIndex )
    self:GetCaster():EmitSound("haidao.bianda")

    return UF_SUCCESS
end

function laohaidao_huilu_lua:GetCustomCastError()
    if not IsServer() then
        return
    end
    if game_playerinfo:get_player_gold(self:GetCaster():GetPlayerID())  < 2500 then
        return "#DOTA_Tooltip_laohaidao_huilu_lua_CastError"
    end

    return ""
end

function laohaidao_huilu_lua:GetIntrinsicModifierName()
    return "modifier_laohaidao_wear"
end

LinkLuaModifier( "modifier_laohaidao_wear","ability/abilities_lua/laohaidao_huilu_lua", LUA_MODIFIER_MOTION_NONE )

if modifier_laohaidao_wear==nil then
    modifier_laohaidao_wear = ({})
end

function modifier_laohaidao_wear:IsHidden() return true end
function modifier_laohaidao_wear:RemoveOnDeath() return false end
function modifier_laohaidao_wear:OnCreated(params)
    if IsServer() then
        local hero = self:GetParent()
        local weartable = {
            "models/items/kunkka/kunkka_immortal/kunkka_shoulder_immortal.vmdl",
            "models/items/kunkka/vengeful_ghost_captain_head/vengeful_ghost_captain_head.vmdl",
            "models/items/kunkka/vengeful_ghost_captain_back/vengeful_ghost_captain_back.vmdl",
            "models/items/kunkka/vengeful_ghost_captain_belt/vengeful_ghost_captain_belt.vmdl",
            "models/items/kunkka/vengeful_ghost_captain_gloves/vengeful_ghost_captain_gloves.vmdl",
            "models/items/kunkka/vengeful_ghost_captain_legs/vengeful_ghost_captain_legs.vmdl",
            "models/items/kunkka/whaleblade/ti8_kunkka_whaleblade.vmdl"
        }
        WearForHero(weartable,self:GetParent())
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ambient_alt.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[1] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[1], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[1], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 3, hero.wear_table[1], PATTACH_POINT_FOLLOW, "attach_shark", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 6, hero.wear_table[1], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 9, hero.wear_table[1], PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        hero.wear_table[7]:SetSkin(1)
        nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_kunkka/kunkka_weapon_glow_ambient.vpcf", PATTACH_POINT_FOLLOW,  hero.wear_table[7] );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero.wear_table[7], PATTACH_POINT_FOLLOW, "attach_tidebringer", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero.wear_table[7], PATTACH_POINT_FOLLOW, "attach_tidebringer_2", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, hero.wear_table[7], PATTACH_POINT_FOLLOW, "attach_sword", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/kunkka/kunkka_weapon_whaleblade_retro/kunkka_weapon_glow_whaleblade_retro_lvl2_ambient.vpcf", PATTACH_POINT_FOLLOW,  hero );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero, PATTACH_POINT_FOLLOW, "attach_tidebringer", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero, PATTACH_POINT_FOLLOW, "attach_tidebringer_2", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, hero, PATTACH_POINT_FOLLOW, "attach_sword", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 4, hero, PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 6, hero, PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 7, hero, PATTACH_POINT_FOLLOW, "", hero:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
    end
end

